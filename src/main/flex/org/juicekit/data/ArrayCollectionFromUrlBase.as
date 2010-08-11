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


import flash.events.Event;
import flash.events.EventDispatcher;
import flash.utils.getTimer;

import mx.collections.ArrayCollection;
import mx.core.IMXMLObject;
import mx.logging.*;
import mx.rpc.events.FaultEvent;
import mx.rpc.events.ResultEvent;
import mx.rpc.http.HTTPService;
import mx.utils.NameUtil;

import org.juicekit.util.Strings;

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
 * Base class that offers support for creating a bindable
 * ArrayCollection created by loading and parsing content
 * available at a URL.
 */
[Bindable]
public class ArrayCollectionFromUrlBase extends EventDispatcher implements IMXMLObject  {
  // Event names to dispatch
  private const AC_RECALC:String = "acRecalc";
  public static const DATA_LOADED:String = 'dataLoaded';
  public static const REQUEST_SENT:String = 'requestSent';


  /**
   * A data structure to optionally cache requests
   */
  private var _cache:Object = {};


  /**
   * Flex HttpService to make requests
   */
  protected var httpService:HTTPService = new HTTPService();


  /**
   * An identifier for logging
   */
  public var queryName:String = NameUtil.createUniqueName(this);


  /**
   * Should results be cached?
   */
  public var useCache:Boolean = true;

  
  /**
   * Should the result array collection be cleared as the http
   * request is sent?
   */
  public var clearResultOnRequest:Boolean = false;


  /**
   * The number of accesses of <code>url</code>.
   *
   * <p>Note: for performance and debugging purposes.</p>
   */
  public var resultFetches:int = 0;


  /**
   * The number of http requests performed.
   *
   * <p>Note: for performance and debugging purposes.</p>
   */
  public var httpRequests:int = 0;


  /**
   * The number of milliseconds it took to fetch
   * <code>url</code> during the most recent evaluation.
   */
  public var requestTime:Number;

  /**
   * @private
   *
   * The time a request was sent. Used to calculate requestTime.
   */
  private var _requestStartTime:Number;


  /**
   * The number of milliseconds it took to parse the
   * data from <code>url</code> into Objects.
   */
  public var parseTime:Number;


  protected var logger:ILogger;


  /**
   * @private
   *
   * A flag that stores if <code>result</code> needs to
   * be recalculated.
   */
  private var dirty:Boolean = true;


  /**
   * The maximum number of rows to return. Zero means return all.
   *
   * <p>Note: <code>limit</code> is applied after <code>filterFunction</code>.</p>
   *
   * @default 0
   */
  public var limit:uint = 0;


  /**
   * A filter to run on the returned rows. Only rows that pass are included.
   *
   * <p>filterFunction is evaluated after <code>limit</code> is performed.</p>
   *
   * <p>filterFunction has the signature <code>function filterFunction(element:Object, index:int, array:Array):Boolean</code>.</p>
   */
  public var filterFunction:Function = null;


  /**
   * A filter to run to calculate additional fields.
   *
   * <p>postprocessRow is evaluated after <code>limit</code> and <code>filterFunction</code>.</p>
   *
   * <p>postprocessRow has the signature <code>function postprocessRow(element:Object, index:int, array:Array):void</code>.</p>
   */
  public var postprocessRow:Function = null;


  /**
   * A function to run to restructure the array.
   *
   * <p>postprocessArray is evaluated after <code>limit</code>, <code>filterFunction</code>
   * and <code>postprocessRow</code>.</p>
   *
   * <p>postprocessArray has the signature <code>function postprocessArray(inputArray:Array):Array</code>.</p>
   */
  public var postprocessArray:Function = null;


  /**
   * Wait for an object to reference <code>result</code> before fetching data.
   *
   * @default true
   */
  public var lazy:Boolean = true;


  /**
   * The raw text returned by the most recent http request.
   *
   * @default null
   */
  public var rawResultString:String;


  /**
   * @private
   *
   * Implement IMXMLObject
   */
  public function initialized(document:Object, id:String):void {
    if (!lazy) {
      var r:ArrayCollection = this.result;
    }
  }


  /**
   * @private
   *
   * A property has changed and the result needs to be
   * refetched.
   */
  protected function propertyChanged():void {
    dirty = true;
    dispatchEvent(new Event(AC_RECALC));
    if (!lazy) {
      var r:ArrayCollection = this.result;
    }
  }


  /**
   * Constructor
   */
  public function ArrayCollectionFromUrlBase() {
    httpService.method = "GET";
    httpService.resultFormat = "text";
    httpService.addEventListener(ResultEvent.RESULT, resultHandler);
    httpService.addEventListener(FaultEvent.FAULT, faultHandler);
    logger = Log.getLogger('ArrayCollectionFromUrlBase');
  }


  /**
   * @private
   *
   * Handle faults.
   *
   * @param event
   */
  private function faultHandler(event:FaultEvent):void {
    dispatchEvent(event);
  }


  /**
   * Subclasses should override this to handle the fetched data.
   *
   * @param payload The contents available at <code>url</code>
   * @return an array of objects created by parsing payload
   */
  protected function doHandleResultString(payload:String):Array {
    return [];    
  }

  /**
   * @private
   *
   * Handles the result of a http request. The resulting
   * text is either processed as JSON or a delimited file
   * depending on <code>parseMode</code>.
   */
  private function resultHandler(event:ResultEvent):void {
    var d:Array = [];
    var starttime:Number = getTimer();
    requestTime = starttime - _requestStartTime;

    rawResultString = event.result as String;
    var resultLength:int = rawResultString.length;
    if (useCache) {
      _cache[_requestedUrl] = rawResultString;
    }

    d = doHandleResultString(rawResultString);

    // filter rows using a filtering function
    if (filterFunction != null) {
      d = d.filter(filterFunction);
    }

    // limit rows
    if (limit > 0) {
      d = d.slice(0, limit);
    }

    // create new variables on each row
    if (postprocessRow != null) {
      d.forEach(postprocessRow);
    }

    // restructure the entire array
    if (postprocessArray != null) {
      d = postprocessArray(d);
    }

    result.source = d;
    parseTime = getTimer() - starttime;

    logger.info(Strings.format('{0:0}ms request time/{1:0}ms parse time/{2:0} rows/{3:0} bytes/{4}',
                this.requestTime,
                this.parseTime,
                d.length,
                resultLength,
                this.url));

    dispatchEvent(new Event(DATA_LOADED));
  }


  /**
   * The url to fetch data from
   */
  public function set url(v:String):void {
    _url = v;
    propertyChanged();
  }


  public function get url():String {
    return _url;
  }

  /**
   * Store the URL
   */
  private var _url:String;
  private var _requestedUrl:String;


  /**
   * An ArrayCollection containing the result.
   */
  [Bindable(event='acRecalc')]
  public function get result():ArrayCollection {
    resultFetches += 1;
    if (dirty) {
      if (url != null) {
        _requestStartTime = getTimer();
        if (clearResultOnRequest) {
          _result.removeAll();
        }
        if (useCache && _cache[url] != undefined) {
          // Handle the result directly using the cached value
          var e:ResultEvent = new ResultEvent(ResultEvent.RESULT, false, true, _cache[url]);
          resultHandler(e);
        } else {
          httpService.cancel();
          httpService.url = url;
          httpService.send();
          dispatchEvent(new Event(REQUEST_SENT));
          httpRequests += 1;
          _requestedUrl = url;
        }
        dirty = false;
      }
    }
    return _result;
  }

  private var _result:ArrayCollection = new ArrayCollection([]);



}
}
