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
import org.juicekit.query.*;

/**
 * Base class representing an aggregate query operator.
 */
public class AggregateExpression extends Expression
{
  /** The sub-expression to aggregate. */
  protected var _expr:Expression;

  /** The sub-expression to aggregate. */
  public function get input():Expression {
    return _expr;
  }

  public function set input(e:*):void {
    _expr = Expression.expr(e);
  }

  /**
   * @inheritDoc
   */
  public override function get numChildren():int {
    return 1;
  }

  /**
   * Creates a new AggregateExpression.
   * @param input the sub-expression to aggregate.
   */
  public function AggregateExpression(input:*) {
    this.input = input;
  }

  /**
   * @inheritDoc
   */
  public override function getChildAt(idx:int):Expression
  {
    return idx == 0 ? _expr : null;
  }

  /**
   * @inheritDoc
   */
  public override function setChildAt(idx:int, expr:Expression):Boolean
  {
    if (idx == 0) {
      _expr = expr;
      return true;
    }
    return false;
  }

  // --------------------------------------------------------------------

  /**
   * Resets the aggregation computation.
   */
  public function reset():void
  {
    // subclasses override this
  }

  /**
   * Increments the aggregation computation to include the input value.
   * @param value a value to include within the aggregation.
   */
  public function aggregate(value:Object):void
  {
    // subclasses override this
  }

} // end of class AggregateExpression
}