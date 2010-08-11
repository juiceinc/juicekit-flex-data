package org.juicekit.data {
import flash.events.Event;
import flash.events.EventDispatcher;

import mx.collections.ArrayCollection;


/**
 * Merges multiple ArrayCollections into one in a Bindable fashion.
 * The result is present in the <code>result</code> parameter.
 * 
 * @author Sal Uryasev
 */
public class Concatenate extends EventDispatcher {
  public function Concatenate() {
  }

  private var _dataProviders:Array = [];

  /**
   * A flag that stores if <code>result</code> needs to
   * be recalculated.
   */
  private var dirty:Boolean = true;


  public function set dataProviders(a:Array):void {
    _dataProviders = a;
    dirty = true;
    dispatchEvent(new Event('arraysMerged', true));
  }


  public function get dataProviders():Array {
    return _dataProviders;
  }

  private var _result:ArrayCollection = new ArrayCollection([]);


  [Bindable(event='arraysMerged')]
  public function get result():ArrayCollection {
    if (dirty) {
      var r:Array = [];
      for each (var ac:*in _dataProviders) {
        if (ac is ArrayCollection) {
          r = r.concat(ac.source);
        }
      }
      _result.source = r;
      dirty = false;
    }
    return _result;
  }

}
}