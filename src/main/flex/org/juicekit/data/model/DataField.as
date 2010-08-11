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
/**
 * A data field stores metadata for an individual data variable.
 */
public class DataField
{
  private var _id:String;
  private var _name:String;
  private var _format:String;
  private var _label:String;
  private var _type:int;
  private var _def:Object;

  /** A unique id for the data field, often the name. */
  public function get id():String {
    return _id;
  }

  /** The name of the data field. */
  public function get name():String {
    return _name;
  }

  /** A formatting string for printing values of this field.
   *  @see flare.util.Stings#format
   */
  public function get format():String {
    return _format;
  }

  /** A label describing this data field, useful for axis titles. */
  public function get label():String {
    return _label;
  }

  /** The data type of this field.
   *  @see flare.data.DataUtil. */
  public function get type():int {
    return _type;
  }

  /** The default value for this data field. */
  public function get defaultValue():Object {
    return _def;
  }

  /**
   * Creates a new DataField.
   * @param name the name of the data field
   * @param type the data type of this field
   * @param def the default value of this field
   * @param id a unique id for the field. If null, the name will be used
   * @param format a formatting string for printing values of this field
   * @param label a label describing this data field
   */
  public function DataField(name:String, type:int, def:Object = null,
                            id:String = null, format:String = null, label:String = null)
  {
    _name = name;
    _type = type;
    _def = def;
    _id = (id == null ? name : id);
    _format = format;
    _label = label == null ? name : _label;
  }

} // end of class DataField
}