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
 * Expression operator that type checks a sub-expression.
 */
public class IsA extends Expression
{
  private var _type:Class;
  private var _clause:Expression;

  /** The class type to check for. */
  public function get type():Class {
    return _type;
  }

  /** The sub-expression clause to type check. */
  public function get clause():Expression {
    return _clause;
  }

  public function set clause(e:*):void {
    _clause = e == null ? null : Expression.expr(e);
  }

  /**
   * @inheritDoc
   */
  public override function get numChildren():int {
    return _clause ? 1 : 0;
  }

  /**
   * Creates a new IsA operator.
   * @param type the class type to check for
   * @param clause the sub-expression clause to type check. If null,
   *  the input object (rather than a sub-property or expression result)
   *  will be type checked.
   */
  public function IsA(type:Class, clause:* = null) {
    _type = type;
    this.clause = clause;
  }

  /**
   * @inheritDoc
   */
  public override function clone():Expression
  {
    return new IsA(_type, _clause.clone());
  }

  /**
   * @inheritDoc
   */
  public override function eval(o:Object = null):*
  {
    return predicate(o);
  }

  /**
   * @inheritDoc
   */
  public override function predicate(o:Object):Boolean
  {
    if (_clause) {
      return _clause.eval(o) is _type;
    } else {
      return o is _type;
    }
  }

  /**
   * @inheritDoc
   */
  public override function getChildAt(idx:int):Expression
  {
    return (idx == 0 ? _clause : null);
  }

  /**
   * @inheritDoc
   */
  public override function setChildAt(idx:int, expr:Expression):Boolean
  {
    if (idx == 0) {
      _clause = expr;
      return true;
    }
    return false;
  }

  /**
   * @inheritDoc
   */
  public override function toString():String
  {
    var c:String = _clause ? _clause.toString() : "<object>";
    return "(" + c + " IS " + _type.toString() + ")";
  }

} // end of class IsA
}