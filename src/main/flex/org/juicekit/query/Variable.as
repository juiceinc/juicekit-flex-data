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
  import org.juicekit.util.Property;

/**
 * Expression operator that retrieves a value from an object property.
 * Uses a <code>flare.util.Property</code> instance to access the value.
 * @see flare.util.Property
 */
public class Variable extends Expression
{
  /** @private */
  protected var _prop:Property;

  /** The name of the variable property. */
  public function get name():String {
    return _prop.name;
  }

  public function set name(f:String):void {
    _prop = Property.$(f);
  }

  /**
   * Creates a new Variable operator.
   * @param name the name of the variable property
   */
  public function Variable(name:String) {
    this.name = name;
  }

  /**
   * @inheritDoc
   */
  public override function clone():Expression
  {
    return new Variable(_prop.name);
  }

  /**
   * @inheritDoc
   */
  public override function eval(o:Object = null):*
  {
    return _prop.getValue(o);
  }

  /**
   * @inheritDoc
   */
  public override function toString():String
  {
    return "`" + _prop.name + "`";
  }

} // end of class Variable
}