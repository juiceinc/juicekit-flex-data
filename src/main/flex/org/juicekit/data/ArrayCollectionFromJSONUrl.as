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
	
	import com.adobe.serialization.json.JSON;
	import com.adobe.serialization.json.JSONParseError;
	
	import mx.core.UIComponent;
	import mx.logging.*;
	import mx.rpc.Fault;
	import mx.rpc.events.FaultEvent;
	
	import org.juicekit.util.Property;
	
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
	 * Loads an ArrayCollection of objects from a data source.
	 *
	 *
	 */
	[Bindable]
	public class ArrayCollectionFromJSONUrl extends ArrayCollectionFromUrlBase {
		
		/**
		 * The raw object returned by json parsing. Only populated
		 * if <code>parseMode</code> is "json".
		 */
		public var rawObject:Object;
		
		
		/**
		 * @private
		 *
		 * Parse the result as JSON data. Raises a FaultEvent
		 *
		 * @param payload The contents available at <code>url</code>
		 * @return an array of objects created by parsing payload
		 */
		override protected function doHandleResultString(payload:String):Array {
			var o:Object;
			try {
				o = JSON.decode(payload);
			} catch(err:JSONParseError) {
				dispatchEvent(new FaultEvent(FaultEvent.FAULT));
				return null;
			}
			
			rawObject = o;
			if (_failurePath != null) {
				var f:Object = Property.$(failurePath).getValue(o);
				if ((f != null) && failTest(f)) {
					return [];
				}
			}
			if ((_failureFunction != null) && (failTest(_failureFunction(o)))) {
				return [];
			}
			
			if (arrayPath != null) {
				// evaluate the arrayPath as a property to get the
				// Array that is embedded in the JSON response.
				o = Property.$(arrayPath).getValue(o);
			}
			// make sure the result is an array
			if (o is Array) {
				return o as Array;
			} else {
				return [o];
			}
			
		}
		
		
		/**
		 * Dispatch a failure message if we are passed a failure
		 * message in JSON.
		 */
		private function failTest(failObj:*):Boolean {
			if (failObj is String) {
				var f:FaultEvent = FaultEvent.createEvent(new Fault('001', failObj as String));
				dispatchEvent(f);
				return true;
			} else if ((failObj is Boolean) && (failObj)) {
				dispatchEvent(new FaultEvent(FaultEvent.FAULT));
				return true;
			}
			return false;
		}
		
		
		/**
		 * The property containing the property containing an array if
		 * the parseMode is 'json'.
		 */
		public function set arrayPath(v:String):void {
			_arrayPath = v;
			propertyChanged();
		}
		
		
		public function get arrayPath():String {
			return _arrayPath;
		}
		
		private var _arrayPath:String;
		
		/**
		 * Points to a location in a JSON object, which,
		 * if exists will force the datapull to fail with the specific
		 * object as a message
		 *
		 * <p>Either failureFunction or failurePath should be set,
		 * but not both.</p>
		 */
		public function set failurePath(v:String):void {
			_failurePath = v;
			propertyChanged();
		}
		
		
		public function get failurePath():String {
			return _failurePath;
		}
		
		private var _failurePath:String;
		
		
		/**
		 * Offers more direct control over failure mechanisms
		 * failureFunction can either return a Boolean,
		 * a message to pass into the FaultEvent, or null.
		 * A string message and true will be taken as a Fault.
		 *
		 * <p>This is predominantly for use with <code>parseMode='json'</code>, but may also
		 * be tested against a pre-parsed csv file.</p>
		 *
		 * <p>Either failureFunction or failurePath should be set, but not both.</p>
		 */
		public function set failureFunction(f:Function):void {
			_failureFunction = f;
			propertyChanged();
		}
		
		public function get failureFunction():Function {
			return _failureFunction;
		}
		
		private var _failureFunction:Function;
		
		
		/**
		 * Constructor
		 */
		public function ArrayCollectionFromJSONUrl():void {
			super();
			logger = Log.getLogger('ArrayCollectionFromUrl');
		}
		
		
		
	}
}
