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

import flash.events.Event;
import flash.net.URLLoader;
import flash.net.URLLoaderDataFormat;
import flash.net.URLRequest;

import org.juicekit.data.converter.Converters;
import org.juicekit.data.converter.IDataConverter;
import org.juicekit.data.model.DataSchema;

/**
 * A data source provides access to remote data on the Internet.
 * A DataSource requires a URL for retrieving a data file, and a format
 * string representing the data format. The currently supported formats are
 * "tab" (Tab-Delimited Text) and "json" (JavaScript Object Notation).
 * Additionally, a DataSource can be given a schema object describing the
 * data fields and their types (int, Number, Date, String, etc). If no
 * schema is provided, the data converter for the particular format will
 * attempt to infer the data types directly from the data itself.
 *
 * <p>Once a DataSource has been created, use the <tt>load</tt> method to
 * initiate data loading. This method returns a <tt>URLLoader</tt>
 * instance. Add a listener to the URLLoader's COMPLETE event to be
 * notified when loading and parsing has been completed. When a COMPLETE
 * event is issued, the URLLoader's <tt>data</tt> property will contain the
 * loaded and parsed data set.</p>
 */
public class DataSource
{
  private var _url:String;
  private var _format:String;
  private var _schema:DataSchema;

  /** The URL of the remote data set. */
  public function get url():String {
    return _url;
  }

  /** The format of the remote data set (e.g., "tab" or "json"). */
  public function get format():String {
    return _format;
  }

  /** A schema describing the attributes of the data set. */
  public function get schema():DataSchema {
    return _schema;
  }

  /**
   * Creates a new DataSource.
   * @param url the URL of the remote data set
   * @param format the format of the remote data set (e.g., "tab" or
   *  "json")
   * @param schema an optional schema describing the attibutes of the
   *  data set
   */
  public function DataSource(url:String, format:String, schema:DataSchema = null)
  {
    _url = url;
    _format = format;
    _schema = schema;
  }

  /**
   * Initiates loading of the data set. When the load completes, a data
   * converter instance is used to convert the retrieved data set into
   * ActionScript objects. The parsed data is then available through the
   * <code>data</code> property of the returned <code>URLLoader</code>.
   * @return a URLLoader instance responsible for loading the data set.
   *  Add an event listener for the <code>COMPLETE</code> event to be
   *  notified when data loading has completed.
   */
  public function load():URLLoader
  {
    var loader:URLLoader = new URLLoader();
    loader.dataFormat = URLLoaderDataFormat.BINARY;
    loader.addEventListener(Event.COMPLETE,
            function(evt:Event):void {
              var conv:IDataConverter = Converters.lookup(_format);
              loader.data = conv.read(loader.data, _schema);
            }
            );
    loader.load(new URLRequest(_url));
    return loader;
  }

  /* TODO later -- support streaming data
   public function stream():URLStream
   {

   }
   */

} // end of class DataSource
}