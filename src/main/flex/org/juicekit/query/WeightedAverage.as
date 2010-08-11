/*
 * Copyright (c) 2007-2010 Regents of the University of California.
 *   All rights reserved.
 *
 *   Redistribution and use in source and binary forms, with or without
 *   modification, are permitted provided that the following conditions
 *   are met:
 *
 *   1. Redistributions of source code must retain the above copyright
 *   notice, this list of conditions and the following disclaimer.
 *
 *   2. Redistributions in binary form must reproduce the above copyright
 *   notice, this list of conditions and the following disclaimer in the
 *   documentation and/or other materials provided with the distribution.
 *
 *   3.  Neither the name of the University nor the names of its contributors
 *   may be used to endorse or promote products derived from this software
 *   without specific prior written permission.
 *
 *   THIS SOFTWARE IS PROVIDED BY THE REGENTS AND CONTRIBUTORS ``AS IS'' AND
 *   ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 *   IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 *   ARE DISCLAIMED.  IN NO EVENT SHALL THE REGENTS OR CONTRIBUTORS BE LIABLE
 *   FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 *   DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
 *   OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 *   HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
 *   LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
 *   OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
 *   SUCH DAMAGE.
 */

package org.juicekit.query {


/**
 * Aggregate operator for computing the weighted average of a set of values.
 */
public class WeightedAverage extends AggregateExpression {
  protected var _sum:Number;
  protected var _weight:Number;

  /** The sub-expression that forms the weighting. */
  protected var _wt:Expression;


  /** The sub-expression to aggregate. */
  public function get weight():Expression {
    return _wt;
  }


  public function set weight(e:*):void {
    _wt = Expression.expr(e);
  }


  /**
   * Creates a new WeightedAverage operator. The weighted average is equal
   * to <code>sum(input expression*weight expression) / sum(weight expression)</code>
   *
   * @param input the sub-expression of which to compute the average
   * @param weight the sub-expression to use to weight the average
   */
  public function WeightedAverage(input:*, weight:*) {
    this.weight = weight;
    super(input);
  }


  /**
   * @inheritDoc
   */
  public override function reset():void {
    _sum = 0;
    _weight = 0;
  }


  /**
   * @inheritDoc
   */
  public override function eval(o:Object = null):* {
    return _sum / _weight;
  }


  /**
   * @inheritDoc
   */
  public override function aggregate(value:Object):void {
    var x:Number = Number(_expr.eval(value));
    var w:Number = Number(_wt.eval(value));
    if (!isNaN(x) && !(isNaN(w))) {
      _sum += x * w;
      _weight += w;
    }
  }

} // end of class WeightedAverage
}