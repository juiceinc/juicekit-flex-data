/*
 * Copyright (c) 2007-2010 Regents of the University of California.
 *   All rights reserved.
 *
 *   Redistribution and use in source and binary forms, with or without
 *   modification, are permitted provided that the following conditions
 *   are met:
 *
 *   1. Redistributions of source code must retain the above copyright
 *   notice, this list of conditions and the following disclaimer.
 *
 *   2. Redistributions in binary form must reproduce the above copyright
 *   notice, this list of conditions and the following disclaimer in the
 *   documentation and/or other materials provided with the distribution.
 *
 *   3.  Neither the name of the University nor the names of its contributors
 *   may be used to endorse or promote products derived from this software
 *   without specific prior written permission.
 *
 *   THIS SOFTWARE IS PROVIDED BY THE REGENTS AND CONTRIBUTORS ``AS IS'' AND
 *   ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 *   IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 *   ARE DISCLAIMED.  IN NO EVENT SHALL THE REGENTS OR CONTRIBUTORS BE LIABLE
 *   FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 *   DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
 *   OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 *   HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
 *   LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
 *   OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
 *   SUCH DAMAGE.
 */

package org.juicekit.data.converter
{
import flash.utils.ByteArray;
import flash.utils.IDataInput;
import flash.utils.IDataOutput;

import org.juicekit.data.model.DataField;
import org.juicekit.data.model.DataSchema;
import org.juicekit.data.model.DataSet;
import org.juicekit.data.model.DataTable;
import org.juicekit.util.DataUtil;

/**
 * Converts data between delimited text (e.g., tab delimited) and
 * flare DataSet instances.
 */
public class DelimitedTextConverter implements IDataConverter
{
  private const DQUOTE:String = '"';


  private var _delim:String;

  public function get delimiter():String {
    return _delim;
  }

  public function set delimiter(d:String):void {
    _delim = d;
  }

  /**
   * Creates a new DelimitedTextConverter.
   * @param delim the delimiter string separating values (tab by default)
   */
  public function DelimitedTextConverter(delim:String = "\t")
  {
    _delim = delim;
  }

  /**
   * @inheritDoc
   */
  public function read(input:IDataInput, schema:DataSchema = null):DataSet
  {
    return parse(input.readUTFBytes(input.bytesAvailable), schema);
  }

  /**
   * Count the number of double quotes in a string.
   *
   * A line and column must have an even number of double quotes
   */
  private function countQuotes(text:String):uint {
    var cnt:int = 0;
    if (text.indexOf('"') == -1) {
      return 0;
    } else {
      var len:int = text.length;
      for (var i:int = 0; i < len; i++) {
        if (text.charAt(i) == DQUOTE) {
          cnt += 1;
        }
      }
      return cnt;
    }
  }

  /**
   * Split a string into lines,
   *
   * If a newline is embedded in a pair of doublequotes
   * it is not considered a line break.
   */
  private function splitLines(text:String):Array {
    var lines:Array = text.split(/\r\n|\r|\n/);
    var quoteMatchedLines:Array = [];
    var outline:String = '';
    if (lines.length > 0) {
      for each (var line:String in lines) {
        if (outline.length > 0) {
          outline += "\n" + line;
        } else {
          outline += line;
        }
        var quoteCnt:uint = countQuotes(outline);
        if (quoteCnt % 2 == 0) {
          quoteMatchedLines.push(outline);
          outline = '';
        }
      }
      if (outline.length > 0) {
        quoteMatchedLines.push(outline);
      }
    }

    return quoteMatchedLines;
  }

  /**
   * Parse a line into columns.
   *
   * If a delimiter is surrounded by doublequotes
   * it is not considered a separator.
   */
  private function splitColumns(text:String):Array {
    var columns:Array = text.split(_delim);
    var quoteMatchedColumns:Array = [];
    var outcol:String = '';
    var col:String;
    if (columns.length > 0) {
      for each (col in columns) {
        if (outcol.length > 0) {
          outcol += _delim + col;
        } else {
          outcol += col;
        }

        // columns must have an even number
        // of doublequotes
        if (countQuotes(outcol) % 2 == 0) {
          quoteMatchedColumns.push(outcol);
          outcol = '';
        }
      }
      if (outcol.length > 0) {
        quoteMatchedColumns.push(outcol);
      }
    }

    var len:int = quoteMatchedColumns.length;
    for (var i:int = 0; i < len; i++) {
      var v:String = quoteMatchedColumns[i];
      var vlen:uint = v.length;
      if (v.indexOf(DQUOTE) != -1) {
        if (vlen > 0 &&
            v.charAt(0) == v.charAt(vlen - 1) &&
            v.charAt(0) == DQUOTE) {
          v = v.substr(1, vlen - 2);
        }
        v = v.split('""').join('"');
        quoteMatchedColumns[i] = v;
      }
    }

    return quoteMatchedColumns;
  }


  /**
   * Converts data from a tab-delimited string into ActionScript objects.
   * @param input the loaded input data
   * @param schema a data schema describing the structure of the data.
   *  Schemas are optional in many but not all cases.
   * @param data an array in which to write the converted data objects.
   *  If this value is null, a new array will be created.
   * @return an array of converted data objects. If the <code>data</code>
   *  argument is non-null, it is returned.
   */
  public function parse(text:String, schema:DataSchema = null):DataSet
  {
    var tuples:Array = [];
    var lines:Array = splitLines(text);

    if (schema == null) {
      schema = inferSchema(lines);
    }

    var i:int = schema.hasHeader ? 1 : 0;
    for (; i < lines.length; ++i) {
      var line:String = lines[i];
      if (line.length == 0) break;
      var tok:Array = splitColumns(line);
      var tuple:Object = {};
      for (var j:int = 0; j < schema.numFields; ++j) {
        var field:DataField = schema.getFieldAt(j);
        tuple[field.name] = DataUtil.parseValue(tok[j], field.type);
      }
      tuples.push(tuple);
    }
    return new DataSet(new DataTable(tuples, schema));
  }

  /**
   * @inheritDoc
   */
  public function write(data:DataSet, output:IDataOutput = null):IDataOutput
  {
    if (output == null) output = new ByteArray();
    var tuples:Array = data.nodes.data;
    var schema:DataSchema = data.nodes.schema;

    for each (var tuple:Object in tuples) {
      var i:int = 0, s:String;
      if (schema == null) {
        for (var name:String in tuple) {
          if (i > 0) output.writeUTFBytes(_delim);
          output.writeUTFBytes(String(tuple[name])); // TODO: proper string formatting
          ++i;
        }
      } else {
        for (; i < schema.numFields; ++i) {
          var f:DataField = schema.getFieldAt(i);
          if (i > 0) output.writeUTFBytes(_delim);
          output.writeUTFBytes(String(tuple[f.name])); // TODO proper string formatting
        }
      }
      output.writeUTFBytes("\n");
    }
    return output;
  }

  /**
   * Infers the data schema by checking values of the input data.
   * @param lines an array of lines of input text
   * @return the inferred schema
   */
  protected function inferSchema(lines:Array):DataSchema
  {
    var header:Array = splitColumns(lines[0]);
    var types:Array = new Array(header.length);

    // initialize data types
    var tok:Array = splitColumns(lines[1]);
    for (var col:int = 0; col < header.length; ++col) {
      types[col] = DataUtil.type(tok[col]);
    }

    // now process data to infer types
    for (var i:int = 2; i < lines.length; ++i) {
      tok = splitColumns(lines[i]);
      for (col = 0; col < tok.length; ++col) {
        if (types[col] == -1) continue;
        var type:int = DataUtil.type(tok[col]);
        if (types[col] != type) {
          types[col] = -1;
        }
      }
    }

    // finally, we create the schema
    var schema:DataSchema = new DataSchema();
    schema.hasHeader = true;
    for (col = 0; col < header.length; ++col) {
      schema.addField(new DataField(header[col],
              types[col] == -1 ? DataUtil.STRING : types[col]));
    }
    return schema;
  }

} // end of class DelimitedTextConverter
}