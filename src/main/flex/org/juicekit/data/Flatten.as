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
	
	import flash.utils.Dictionary;
	
	import mx.collections.ArrayCollection;
	
	import org.juicekit.util.Property;
	
	/**
	 * Returns values of a property of items in an ArrayCollection.
	 *
	 * @author Chris Gemignani
	 */
	[Bindable]
	public class Flatten extends DataBase {
		
		
		/**
		 * Remove duplicates from result.
		 *
		 * @default true
		 */
		public function set dedup(v:Boolean):void {
			_dedup = v;
			invalidateProperties();
		}
		
		public function get dedup():Boolean {
			return _dedup;
		}
		
		private var _dedup:Boolean = true;
		
		
		/**
		 * Sort result.
		 *
		 * @default true
		 */
		public function set sort(v:Boolean):void {
			_sort = v;
			invalidateProperties();
		}
		public function get sort():Boolean {
			return _sort;
		}
		private var _sort:Boolean = true;
		
		
		/**
		 * Reverse result.
		 *
		 * @default false
		 */
		public function set reverse(v:Boolean):void {
			_reverse = v;
			invalidateProperties();
		}
		public function get reverse():Boolean {
			return _reverse;
		}
		private var _reverse:Boolean = true;
		
		
		
		/**
		 * A property name to evaluate against each item in <code>dataProvider</code>.
		 * @param v
		 */
		public function set property(v:String):void {
			_property = v;
			invalidateProperties();
			var r:ArrayCollection = result;
		}
		
		
		public function get property():String {
			return _property;
		}
		
		private var _property:String = '';
		
		
		/**
		 * Perform the flattening by extracting <code>property</code> values
		 * from each object.
		 * @return a flattened Array containing values of property
		 */
		override protected function doResult():Array {
			var r:Array = [];
			if (property) {
				var o:Object;
				var p:Property = Property.$(property);
				var v:Object;
				var map:Dictionary = new Dictionary();
				
				for each (o in dataProvider) {
					v = p.getValue(o);
					if (dedup) {
						// store values in a Dictionary
						// to determine if they are unique
						if (map[v] == undefined) {
							map[v] = 1;
							r.push(p.getValue(o));
						}
					} else {
						r.push(p.getValue(o));
					}
				}
				if (sort) {
					r.sort();
				}
				if (reverse) {
					r.reverse();
				}
			}
			return r;
		}
		
		
		/**
		 * Constructor
		 */
		public function Flatten() {
		}
		
	}
}