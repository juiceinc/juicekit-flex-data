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
 * Aggregate operator for computing the minimum of a set of values.
 */
public class Minimum extends AggregateExpression
{
  private var _value:Object = null;

  /**
   * Creates a new Minimum operator
   * @param input the sub-expression of which to compute the minimum
   */
  public function Minimum(input:*) {
    super(input);
  }

  /**
   * @inheritDoc
   */
  public override function eval(o:Object = null):*
  {
    return _value;
  }

  /**
   * @inheritDoc
   */
  public override function reset():void
  {
    _value = null;
  }

  /**
   * @inheritDoc
   */
  public override function aggregate(value:Object):void
  {
    value = _expr.eval(value);
		// Make sure that value is not null because null evaluates to 
		// less than any number.
    if (_value == null || (value != null && value < _value)) {
      _value = value;
    }
  }

} // end of class Minimum
}