package org.juicekit.data {
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.getTimer;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.core.Application;
	import mx.core.FlexGlobals;
	import mx.core.UIComponent;
	import mx.events.CollectionEvent;
	import mx.managers.SystemManager;
	import mx.utils.NameUtil;
	
	import org.juicekit.collections.StatsArrayCollection;
	
	import spark.components.Application;
	
	
	/**
	 * Dispatched when data has been calculated.
	 *
	 * @eventType flash.events.Event
	 */
	[Event(name="complete", type="flash.events.Event")]
	
	
	/**
	 * A base class for JuiceKit client side data processing.
	 */
	[Bindable]
	public class DataBase extends DeferredProcessingBase {
		
		public static const COMPLETE:String = 'complete';
		
		/**
		 * Dispatched when a query recalculation needs to be performed.
		 */
		protected const RECALC:String = "dataRecalc";
		
		
		/**
		 * The number of accesses of <code>result</code>
		 * for performance and debugging purposes.
		 */
		//TODO: move diagnostics out to a common module for all org.juicekit.util.data classes,
		// see Green Threads: http://code.google.com/p/greenthreads/source/browse/trunk/src/org/greenthreads/ThreadStatistics.as
		public var resultFetches:int = 0;
		
		/**
		 * The number of times <code>query</code> had to be
		 * evaluated, for performance and debugging purposes.
		 */
		public var resultCalculations:int = 0;
		
		
		/**
		 * The number of milliseconds it took to evaluate
		 * <code>query</code> during the most recent eval.
		 */
		public var evalTime:Number;
		
		
		/**
		 * A unique name for logging
		 */
		public var queryName:String = NameUtil.createUniqueName(this);
		
		
		
		/**
		 * A flag that indicates if <code>result</code> needs to
		 * be recalculated.
		 */
		protected var dirty:Boolean = true;
		
		
		/**
		 * Suppress dirty events while recalc is occurring
		 *
		 */
		protected var recalcInProgress:Boolean = false;
		
		
		//----------------------------------
		// postprocessing
		//----------------------------------
		
		/**
		 * A filter to run to calculate additional fields.
		 *
		 * <p>postprocessRow has the signature
		 * <code>function postprocessRow(element:Object, index:int, array:Array):void</code>.</p>
		 */
		public var postprocessRow:Function = null;
		
		
		/**
		 * A function to run to restructure the array.
		 *
		 * postprocessArray has the signature
		 * <code>function postprocessArray(inputArray:Array):Array</code>.
		 */
		public var postprocessArray:Function = null;
		
		
		/**
		 * Restrict the number of results. Zero
		 * means return all results
		 *
		 * @default 0
		 */
		public function set limit(v:int):void {
			_limit = v;
			invalidateProperties();
		}
		
		
		public function get limit():int {
			return _limit;
		}
		
		/** Storage for the row limit property */
		private var _limit:int = 0;
		
		
		/**
		 * Perform recalculation
		 */
		override protected function doRecalc():void {
			resultCalculations += 1;
			if (dataProvider) {
				var starttime:Number = getTimer();
				
				// Do the calculation
				var r:Array = doResult();
				
				// create new variables on each row
				if (postprocessRow != null) {
					r.forEach(postprocessRow);
				}
				
				// restructure the entire array
				if (postprocessArray != null) {
					r = postprocessArray(r);
				}
				
				evalTime = getTimer() - starttime;
				
				// Clear the dirty flag before setting _result.source
				// since setting _result.source might cause more
				// attempts to fetch result.
				if (limit > 0) {
					_result.source = r.slice(0, limit);
				} else {
					_result.source = r;
				}
			} else {
				if (limit > 0) {
					_result.source = dataProvider.source.slice(0, limit);
				} else {
					_result.source = dataProvider.source.slice();
				}
			}
			callLaterPending = false;
			this.dispatchEvent(new Event(RECALC));
		}
		
		
		//----------------------------------
		// result
		//----------------------------------
		
		/**
		 * The result of <code>query</code> evaluated against
		 * <code>dataProvider.source</code> as an ArrayCollection.
		 *
		 * <p><code>result</code> is bindable.</p>
		 */
		[Bindable(event='dataRecalc')] 
		public function get result():StatsArrayCollection {
			resultFetches += 1;
			return _result;
		}
		
		private var _result:StatsArrayCollection = new StatsArrayCollection();
		
		
		/**
		 * Calculate the result value.
		 *
		 * Subclasses should override this.
		 *
		 * @return
		 */
		protected function doResult():Array {
			return [];
		}
		
		
		/**
		 * The data source for the query to evaluate against.
		 *
		 * @param v
		 */
		public function set dataProvider(v:ArrayCollection):void {
			if (dataProvider) {
				dataProvider.removeEventListener(CollectionEvent.COLLECTION_CHANGE, invalidateProperties);
			}
			_dataProvider = v;
			dataProvider.addEventListener(CollectionEvent.COLLECTION_CHANGE, invalidateProperties);
			invalidateProperties();
		}
		
		
		public function get dataProvider():ArrayCollection {
			return _dataProvider;
		}
		
		private var _dataProvider:ArrayCollection = null;
		
		/**
		 * Constructor
		 */		
		public function DataBase() {
			//throw new Error("This is an abstract class.");
		}
	}
}