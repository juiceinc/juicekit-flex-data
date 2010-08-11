package org.juicekit.data
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import mx.core.UIComponent;
	import mx.managers.SystemManager;

	/**
	 * A base class for a nonvisual component that can support
	 * invalidation. The component will perform processing on the
	 * next Frame.
	 */
	public class DeferredProcessingBase extends EventDispatcher
	{
		/** Storage for a UIComponent that can perform callLater */
		protected var callLaterObject:UIComponent;
		
		/** 
		 * Storage for flag if callLater is already active. This needs
		 * to be cleared by doRecalc.
		 */
		protected var callLaterPending:Boolean = false;
		
		
		/**
		 * Subclasses should call this to trigger a 
		 * doRecalc on the next frame. 
		 */
		protected function invalidateProperties(e:Event=null):void {
			if (!callLaterPending) {
				if (!callLaterObject) {
					callLaterObject = new UIComponent();
					
					// TODO: validate this
					var sm:SystemManager = SystemManager.getSWFRoot(this) as SystemManager;
					
					callLaterObject.systemManager = sm;
				}
				callLaterObject.callLater(doRecalc);
				callLaterPending = true;
			}
		}
		
		protected function callLater(fn:Function):void {
			if (!callLaterObject) {
				callLaterObject = new UIComponent();
				
				// TODO: validate this
				var sm:SystemManager = SystemManager.getSWFRoot(this) as SystemManager;
				
				callLaterObject.systemManager = sm;
			}
			callLaterObject.callLater(fn);			
		}

		
		/**
		 * Perform the actual calculation. Subclasses
		 * should override this. The recalc should set 
		 * <code>callLaterPending</code> to false at the
		 * end of the recalculation.
		 */
		protected function doRecalc():void {
		}

		
		/**
		 * Constructor
		 */
		public function DeferredProcessingBase() {			
			//throw new Error("This is an abstract class.");
		}
		
	}
}