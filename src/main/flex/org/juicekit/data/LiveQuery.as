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
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import org.juicekit.query.Query;
	
	/**
	 * Dispatched when data has been calculated.
	 *
	 * @eventType flash.events.Event
	 */
	[Event(name="complete", type="flash.events.Event")]
	
	
	[Bindable]
	/**
	 * Allows an ArrayCollection of source data to be connected to a
	 * flare Query such that the result of the flare Query is
	 * continuously updated if the source data changes.    
	 *
	 */
	public class LiveQuery extends DataProcessingBase {
		
		/**
		 * Perform the query calculation
		 * @return
		 */
		override protected function doResult():Array {
			return query.eval(dataProvider.source);
		}
		
		/**
		 * A Flare query to evaluate against the data in
		 * <code>dataProvider</code>.
		 *
		 * @param q A JuiceKit Query
		 */
		public function set query(q:Query):void {
			_query = q;
			invalidateProperties();
		}
		
		
		public function get query():Query {
			return _query;
		}
		
		/** Storage for the Query object */
		private var _query:Query = null;
		
		
		/**
		 * Set whether the LiveQuery recalculates.
		 */
		public function set enabled(v:Boolean):void {
			_enabled = v;
		}
		
		public function get enabled():Boolean {
			return true;
		}
		
		/** Storage for the enabled property */
		private var _enabled:Boolean = true;
		
		/**
		 * Constructor
		 */
		public function LiveQuery() {
		}
		
	}
}