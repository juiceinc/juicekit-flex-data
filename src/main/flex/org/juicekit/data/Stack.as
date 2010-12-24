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
	import mx.events.CollectionEvent;
	
	/**
	 * <p>A Stack creates a new object for each unique <code>dimension</code>.
	 * This object contains a versions of each <code>metric</code> for each
	 * unique value in <code>StackField</code>.</p>
	 *
	 * <p>A Stack has two required inputs; an ArrayCollection, and
	 * StackField a String or Array. The result
	 * of the Stack can be found in <code>results</code>, a bindable
	 * ArrayCollection that is lazily computed.</p>
	 *
	 * <p>For instance, if the dataProvider <code>myData</code> contained the following data:</p>
	 *
	 * <pre><code>myData:ArrayCollection = new ArrayCollection([
	 *   { SEX: 'M', STATE: 'California', value: 25.5 },
	 *   { SEX: 'F', STATE: 'California', value: 30.1 },
	 *   { SEX: 'M', STATE: 'Nevada', value: 10.1 },
	 *   { SEX: 'F', STATE: 'Nevada', value: 12.9 }
	 * ]);
	 * </code></pre>
	 *
	 * <p>The following MXML:</p>
	 *
	 * <pre><code><Stack id="myStack" dataProvider="myData" StackField="SEX"/>
	 * </code></pre>
	 *
	 * <p>Would result in <code>myStack.result</code> containing the following objects:</p>
	 *
	 * <pre><code>{ STATE: 'California', 'value.M': 25.5, 'value.F': 30.1 },
	 * { STATE: 'Nevada', 'value.M': 10.1, 'value.F': 12.9 }
	 * </code></pre>
	 *
	 * <p>Multiple fields can be pivoted on simultaneously by passing an Array to
	 * stackFields. Consider the following MXML:</p>
	 *
	 * <pre><code><Stack id="myStack" dataProvider="myData" StackField="['SEX','STATE']"/>
	 * </code></pre>
	 *
	 * <p>Which results in <code>myStack.result</code> containing the following objects:</p>
	 *
	 * <pre><code>{ 'value.M.California': 25.5, 'value.F.California': 30.1,
	 * 'value.M.Nevada': 10.1, 'value.F.Nevada': 12.9 }
	 * </code></pre>
	 *
	 */
	[Bindable]
	public class Stack extends DataProcessingBase {
		
		
		private function stringFromProps(propArr:Array, o:Object):String {
			var result:Array = [];
			for each (var p:String in propArr) {
				result.push(o[p].toString());
			}
			return result.join('.');
		}
		
		
		override protected function doResult():Array {
			var result:Array = [];
			if (stackFields && dataProvider && dataProvider.length > 0) {
				var dimensionProps:Array = [];
				
				var firstObj:Object = dataProvider.getItemAt(0);
				// measures
				for (var k:String in firstObj) {
					if (dimensions == null) {
						// if dimensions is un-set, use all String
						// fields as dimensions
						if (firstObj[k] is String && stackFields.indexOf(k) == -1) {
							dimensionProps.push(k);
						}
					} else {
						if (dimensions.indexOf(k) != -1) {
							dimensionProps.push(k);
						}
					}
				}
				
				// whenver dimensions change, output the new object
				var newobj:Object;
				var prevDimStr:String = '###NOMATCH###';
				var p:String;
				for each (var stackField:String in stackFields) {
					for each (var o:Object in dataProvider) {
						newobj = {};
						for each (p in dimensionProps) {
							newobj[p] = o[p];
						}
						newobj['measureName'] = stackField;
						newobj['measureValue'] = o[stackField];
						result.push(newobj);
					}
				}
			}
			return result;
		}
		
		
		/**
		 * A String or Array of strings indicating the field
		 * (or fields) that should be pivoted on.
		 */
		public function set stackFields(v:Array):void {
			_stackFields = v;
			invalidateProperties();
		}
		
		
		public function get stackFields():Array {
			return _stackFields;
		}
		
		
		private var _stackFields:Array;
		
		
		//----------------------------------
		// dimensions
		//----------------------------------
		
		/**
		 * <p>An optional array of field names indicating the fields
		 * that should be treated as dimensions. Dimensions are output
		 * with every row.</p>
		 *
		 * <p>If dimensions are unspecified, all String fields will
		 * be used.</p>
		 *
		 */
		public function set dimensions(v:Array):void {
			_dimensions = v;
			invalidateProperties();
		}
		
		
		public function get dimensions():Array {
			return _dimensions;
		}
		
		private var _dimensions:Array;
		
		
		/**
		 * Constructor
		 */
		public function Stack():void {
			
		}
		
	}
}