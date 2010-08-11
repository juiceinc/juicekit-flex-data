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
 * Expression operator that computes the exclusive-or ("xor") of
 * sub-expression clauses.
 */
public class Xor extends CompositeExpression
{
  /**
   * Creates a new Xor operator.
   * @param clauses the sub-expression clauses
   */
  public function Xor(...clauses) {
    super(clauses);
  }

  /**
   * @inheritDoc
   */
  public override function clone():Expression
  {
    return cloneHelper(new Xor());
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
    if (_children.length == 0) return false;

    var b:Boolean = _children[0].predicate(o);
    for (var i:int = 1; i < _children.length; ++i) {
      b = (b != Expression(_children[i]).predicate(o));
    }
    return b;
  }

  /**
   * @inheritDoc
   */
  public override function toString():String
  {
    return _children.length == 0 ? "FALSE" : super.getString("XOR");
  }

} // end of class Xor
}