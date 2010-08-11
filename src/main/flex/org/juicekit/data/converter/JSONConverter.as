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
import com.adobe.serialization.json.JSON;

import flash.utils.ByteArray;
import flash.utils.IDataInput;
import flash.utils.IDataOutput;

import org.juicekit.data.model.DataField;
import org.juicekit.data.model.DataSchema;
import org.juicekit.data.model.DataSet;
import org.juicekit.data.model.DataTable;
import org.juicekit.util.DataUtil;
import org.juicekit.util.Property;

/**
 * Converts data between JSON (JavaScript Object Notation) strings and
 * flare DataSet instances.
 */
public class JSONConverter implements IDataConverter
{
  /**
   * @inheritDoc
   */
  public function read(input:IDataInput, schema:DataSchema = null):DataSet
  {
    var data:Array;
    return new DataSet(new DataTable(
            data = parse(input.readUTFBytes(input.bytesAvailable), schema),
            schema ? schema : DataUtil.inferSchema(data)
            ));
  }

  /**
   * Converts data from a JSON string into ActionScript objects.
   * @param input the loaded input data
   * @param schema a data schema describing the structure of the data.
   *  Schemas are optional in many but not all cases.
   * @param data an array in which to write the converted data objects.
   *  If this value is null, a new array will be created.
   * @return an array of converted data objects. If the <code>data</code>
   *  argument is non-null, it is returned.
   */
  public function parse(text:String, schema:DataSchema):Array
  {
    var json:Object = JSON.decode(text) as Object;
    var list:Array = json as Array;

    if (schema != null) {
      if (schema.dataRoot) {
        // if nested, extract data array
        list = Property.$(schema.dataRoot).getValue(json);
      }
      // convert value types according to schema
      for each (var t:Object in list) {
        for each (var f:DataField in schema.fields) {
          t[f.name] = DataUtil.parseValue(t[f.name], f.type);
        }
      }
    }
    return list;
  }

  /**
   * @inheritDoc
   */
  public function write(data:DataSet, output:IDataOutput = null):IDataOutput
  {
    var tuples:Array = data.nodes.data;
    if (output == null) output = new ByteArray();
    output.writeUTFBytes(JSON.encode(tuples));
    return output;
  }

} // end of class JSONConverter
}