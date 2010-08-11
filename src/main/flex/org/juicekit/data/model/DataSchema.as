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

package org.juicekit.data.model
{
import org.juicekit.util.Arrays;


/**
 * A data schema represents a set of data variables and their associated
 * types. A schema maintains a collection of <code>DataField</code>
 * objects.
 * @see flare.data.DataField
 */
public class DataSchema
{
  public var dataRoot:String = null;
  public var hasHeader:Boolean = false;

  private var _fields:/*DataField*/Array = [];
  private var _nameLookup:/*String->DataField*/Object = {};
  private var _idLookup:/*String->DataField*/Object = {};

  /** An array containing the data fields in this schema. */
  public function get fields():Array {
    return Arrays.copy(_fields);
  }

  /** The number of data fields in this schema. */
  public function get numFields():int {
    return _fields.length;
  }

  /**
   * Creates a new DataSchema.
   * @param fields an ordered list of data fields to include in the
   * schema
   */
  public function DataSchema(...fields)
  {
    for each (var f:DataField in fields) {
      addField(f);
    }
  }

  /**
   * Adds a field to this schema.
   * @param field the data field to add
   */
  public function addField(field:DataField):void
  {
    _fields.push(field);
    _nameLookup[field.name] = field;
    _idLookup[field.id] = field;
  }

  /**
   * Retrieves a data field by name.
   * @param name the data field name
   * @return the corresponding data field, or null if no data field is
   *  found matching the name
   */
  public function getFieldByName(name:String):DataField
  {
    return _nameLookup[name];
  }

  /**
   * Retrieves a data field by id.
   * @param name the data field id
   * @return the corresponding data field, or null if no data field is
   *  found matching the id
   */
  public function getFieldById(id:String):DataField
  {
    return _idLookup[id];
  }

  /**
   * Retrieves a data field by its index in this schema.
   * @param idx the index of the data field in this schema
   * @return the corresponding data field
   */
  public function getFieldAt(idx:int):DataField
  {
    return _fields[idx];
  }

} // end of class DataSchema
}