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
	import org.juicekit.query.Query;
	import org.juicekit.query.methods.*;
	
	/**
	 * <p>A Pivot creates a new object for each unique <code>dimension</code>.
	 * This object contains a versions of each <code>metric</code> for each
	 * unique value in <code>pivotField</code>.</p>
	 *
	 * <p>A Pivot has two required inputs; an ArrayCollection, and
	 * pivotField a String or Array. The result
	 * of the Pivot can be found in <code>results</code>, a bindable
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
	 * <pre><code><Pivot id="myPivot" dataProvider="myData" pivotField="SEX"/>
	 * </code></pre>
	 *
	 * <p>Would result in <code>myPivot.result</code> containing the following objects:</p>
	 *
	 * <pre><code>{ STATE: 'California', 'value.M': 25.5, 'value.F': 30.1 },
	 * { STATE: 'Nevada', 'value.M': 10.1, 'value.F': 12.9 }
	 * </code></pre>
	 *
	 * <p>Multiple fields can be pivoted on simultaneously by passing an Array to
	 * pivotField. Consider the following MXML:</p>
	 *
	 * <pre><code><Pivot id="myPivot" dataProvider="myData" pivotField="['SEX','STATE']"/>
	 * </code></pre>
	 *
	 * <p>Which results in <code>myPivot.result</code> containing the following objects:</p>
	 *
	 * <pre><code>{ 'value.M.California': 25.5, 'value.F.California': 30.1,
	 * 'value.M.Nevada': 10.1, 'value.F.Nevada': 12.9 }
	 * </code></pre>
	 *
	 */
	[Bindable]
	public class Pivot extends DataProcessingBase {
		
		/**
		 * The delimiter between pivot items
		 */
		public var delimiter:String = ':';
		
		
		private function stringFromProps(propArr:Array, o:Object):String {
			var result:Array = [];
			for each (var p:String in propArr) {
				result.push(o[p].toString());
			}
			return result.join(delimiter);
		}
		
		override protected function doResult():Array {
			if (pivotField) {
				var result:Array = [];
				var pivotFields:Array = [];
				
				// generate pivotFieldProps
				if (pivotField is String) {
					pivotFields.push(pivotField);
				} else if (pivotField is Array) {
					pivotFields = pivotField;
				} else {
					trace('pivotField must be String or Array');
				}
				
				var measureProps:Array = [];
				var dimensionProps:Array = [];
				
				var firstObj:Object = dataProvider.getItemAt(0);
				// measures
				for (var k:String in firstObj) {
					if (measures == null) {
						// if measures is un-set, use all Number
						// fields as measures
						if (firstObj[k] is Number && pivotFields.indexOf(k) == -1 && dimensions.indexOf(k) == -1) {
							measureProps.push(k);
						}
					} else {
						if (measures.indexOf(k) != -1) {
							measureProps.push(k);
						}
					}
					if (dimensions == null) {
						// if dimensions is un-set, use all String
						// fields as dimensions
						if (firstObj[k] is String && pivotFields.indexOf(k) == -1) {
							dimensionProps.push(k);
						}
					} else {
						if (dimensions.indexOf(k) != -1) {
							dimensionProps.push(k);
						}
					}
				}
				
				var uniquePivotVals:Array = select(pivotField).groupby(pivotField).eval(dataProvider.source);
				// make a list of strings
				uniquePivotVals = uniquePivotVals.map(function(itm:Object, ...rest):String {
					return itm[pivotField];
				});
				var selectVars:Object = {};
				for each (var d:String in dimensionProps) {
					selectVars[d] = d;
				}
				for each (var m:String in measureProps) {
					for each (var pv:Object in uniquePivotVals) {
						selectVars[m + delimiter + pv.toString()] = sum(iff(eq(pivotField, _(pv)), m, _(0)));
					}
				}
				
				var q:Query = new Query([selectVars], null, null, dimensionProps);
				
			}
			return q.eval(dataProvider.source);
		}
		
		
		
		//----------------------------------
		// pivotFields
		//----------------------------------
		
		/**
		 * A String or Array of strings indicating the field
		 * (or fields) that should be pivoted on.
		 */
		public function set pivotField(v:*):void {
			_pivot = v;
			invalidateProperties();
		}
		
		
		public function get pivotField():* {
			return _pivot;
		}
		
		
		private var _pivot:* = null;
		
		
		/**
		 * <p>An optional array of field names indicating the fields
		 * that should be paired with the pivotField for output.</p>
		 *
		 * <p>If dimensions are unspecified, all Number fields will
		 * be used.</p>
		 *
		 */
		public function set measures(v:Array):void {
			_measures = v;
			invalidateProperties();
		}
		
		
		public function get measures():Array {
			return _measures;
		}
		
		private var _measures:Array;
		
		
		
		/**
		 * <p>An optional array of field names indicating the fields
		 * that should be treated as dimensions. Whenever
		 * dimensions change, a row will be output.</p>
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
		public function Pivot() {
			
		}
		
	}
}