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
 * Expression operator that tests if a value is within a given range.
 * Implemented as an <code>And</code> of <code>Comparison</code>
 * expressions.
 */
public class Range extends And
{
  /** Sub-expression for the minimum value of the range. */
  public function get min():Expression {
    return _children[0].left;
  }

  public function set min(e:*):void {
    _children[0].left = Expression.expr(e);
  }

  /** Sub-expression for the maximum value of the range. */
  public function get max():Expression {
    return _children[1].right;
  }

  public function set max(e:*):void {
    _children[1].right = Expression.expr(e);
  }

  /** Sub-expression for the value to test for range inclusion. */
  public function get val():Expression {
    return _children[0].right;
  }

  public function set val(e:*):void {
    var expr:Expression = Expression.expr(e);
    _children[0].right = expr;
    _children[1].left = expr;
  }

  /**
   * Create a new Range operator.
   * @param min sub-expression for the minimum value of the range
   * @param max sub-expression for the maximum value of the range
   * @param val sub-expression for the value to test for range inclusion
   */
  public function Range(min:*, max:*, val:*)
  {
    addChild(new Comparison(Comparison.LTEQ, min, val));
    addChild(new Comparison(Comparison.LTEQ, val, max));
  }

  /**
   * @inheritDoc
   */
  public override function clone():Expression
  {
    return new Range(min.clone(), max.clone(), val.clone());
  }

} // end of class RangePredicate
}