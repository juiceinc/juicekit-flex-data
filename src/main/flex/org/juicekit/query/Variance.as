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

package org.juicekit.query
{
/**
 * Aggregate operator for computing variance or standard deviation.
 */
public class Variance extends AggregateExpression
{
  /** Flag indicating the population variance or deviation. */
  public static const POPULATION:int = 0;
  /** Flag indicating the sample variance or deviation. */
  public static const SAMPLE:int = 2;
  /** Flag indicating the variance should be computed. */
  public static const VARIANCE:int = 0;
  /** Flag indicating the standard deviation should be computed. */
  public static const DEVIATION:int = 1;

  private var _type:int;
  private var _sum:Number;
  private var _accum:Number;
  private var _count:Number;

  /**
   * Creates a new Variance operator. By default, the population variance
   * is computed. Use the type flags to change this. For example, the type
   * argument <code>Variance.SAMPLE | Variance.DEVIATION</code> results in
   * the sample standard deviation being computed.
   * @param input the sub-expression of which to compute variance
   * @param type the type of variance or deviation to compute
   */
  public function Variance(input:*, type:int = 0) {
    super(input);
    _type = type;
  }

  /**
   * @inheritDoc
   */
  public override function reset():void
  {
    _sum = 0;
    _accum = 0;
    _count = 0;
  }

  /**
   * @inheritDoc
   */
  public override function eval(o:Object = null):*
  {
    var n:Number = _count - (_type & SAMPLE ? 1 : 0);
    var v:Number = _sum / n;
    v = v * v + _accum / n;
    return (_type & DEVIATION ? Math.sqrt(v) : v);
  }

  /**
   * @inheritDoc
   */
  public override function aggregate(value:Object):void
  {
    var x:Number = Number(_expr.eval(value));
    if (!isNaN(x)) {
      _sum += x;
      _accum += x * x;
      _count += 1;
    }
  }

} // end of class Variance
}