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
    import org.juicekit.data.model.DataField;
    import org.juicekit.util.DataUtil;

/**
 * Expression operator for a literal value.
 */
public class Literal extends Expression
{
  /** The boolean true literal. */
  public static const TRUE:Literal = new Literal(true);
  /** The boolean false literal. */
  public static const FALSE:Literal = new Literal(false);

  override public function get dataField():DataField {
      var nm:String = value.toString();
      var typ:int = DataUtil.type(value.toString());
      return new DataField(nm, typ);
  };
  
  private var _value:Object = null;

  /** The literal value of this expression. */
  public function get value():Object {
    return _value;
  }

  public function set value(val:Object):void {
    _value = val;
  }

  /**
   * Creates a new Literal instance.
   * @param val the literal value
   */
  public function Literal(val:Object = null) {
    _value = val;
  }

  /**
   * @inheritDoc
   */
  public override function clone():Expression
  {
    return new Literal(_value);
  }

  /**
   * @inheritDoc
   */
  public override function predicate(o:Object):Boolean
  {
    return Boolean(_value);
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
  public override function toString():String
  {
    return String(_value);
  }

} // end of class Literal
}