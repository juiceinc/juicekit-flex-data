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

import flash.utils.IDataInput;
import flash.utils.IDataOutput;

import org.juicekit.data.model.DataSchema;
import org.juicekit.data.model.DataSet;

/**
 * Interface for data converters that map between an external data file
 * format and ActionScript objects (e.g., Arrays and Objects).
 */
public interface IDataConverter
{
  /**
   * Converts data from an external format into ActionScript objects.
   * @param input the loaded input data
   * @param schema a data schema describing the structure of the data.
   *  Schemas are optional in many but not all cases.
   * @return a DataSet instance containing converted data objects.
   */
  function read(input:IDataInput, schema:DataSchema = null):DataSet;

  /**
   * Converts data from ActionScript objects into an external format.
   * @param data the data set to write.
   * @param output an object to which to write the output. If this value
   *  is null, a new <code>ByteArray</code> will be created.
   * @return the converted data. If the <code>output</code> parameter is
   *  non-null, it is returned. Otherwise the return value will be a
   *  newly created <code>ByteArray</code>
   */
  function write(data:DataSet, output:IDataOutput = null):IDataOutput;

} // end of interface IDataConverter
}