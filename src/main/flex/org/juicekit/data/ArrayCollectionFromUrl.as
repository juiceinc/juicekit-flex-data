/*
 * Copyright 2007-2010 Juice, Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package org.juicekit.data {

import mx.logging.*;

import org.juicekit.data.converter.DelimitedTextConverter;


/**
 * Dispatched when data has been loaded.
 *
 * @eventType flash.events.Event
 */
[Event(name="dataLoaded", type="flash.events.Event")]

/**
 * Dispatched when a data request has been sent.
 *
 * @eventType flash.events.Event
 */
[Event(name="requestSent", type="flash.events.Event")]

/**
 * Dispatched when a fault event occurs
 *
 * @eventType mx.rpc.events.FaultEvent
 */
[Event(name="fault", type="mx.rpc.events.FaultEvent")]


/**
 * Loads an ArrayCollection of objects from a delimited data source.
 *
 *
 */
[Bindable]
public class ArrayCollectionFromUrl extends ArrayCollectionFromUrlBase  {


  /**
   * Subclasses should override this to handle the fetched data.
   *
   * @param payload The contents available at <code>url</code>
   * @return an array of objects created by parsing payload
   */
  override protected function doHandleResultString(payload:String):Array {
    return delimitedTextConverter.parse(payload).nodes.data;
  }


  /**
   * The delimiter to use when parsing the data source at <code>url</code>.
   *
   * @default ','
   */
  public function set delimiter(v:String):void {
    delimitedTextConverter.delimiter = v;
    propertyChanged();
  }


  public function get delimiter():String {
    return delimitedTextConverter.delimiter;
  }

  private var delimitedTextConverter:DelimitedTextConverter = new DelimitedTextConverter(',');

  /**
   * Constructor
   */
  public function ArrayCollectionFromUrl():void {
    super();
    logger = Log.getLogger('ArrayCollectionFromUrl');
  }

}
}
