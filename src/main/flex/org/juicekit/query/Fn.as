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
 * Expression operator that performs function invocation. The set of
 * available functions is determined by a static function table maintained
 * by this class. The function table can be extended to introduce custom
 * functions into the query language.
 */
public class Fn extends CompositeExpression
{
  private var _name:String;
  private var _func:Function;
  private var _args:Array;

  /**
   * Creates a new Fn (function) operator.
   * @param name the name of the function. This should map to an entry
   *  in the static function table.
   * @params args sub-expressions for the function arguments
   */
  public function Fn(name:String, ...args) {
    _name = name.toUpperCase();
    _func = table[_name];
    super(args);
  }

  /**
   * @inheritDoc
   */
  public override function clone():Expression
  {
    return new Fn(_name, _children);
  }

  /**
   * @inheritDoc
   */
  public override function eval(o:Object = null):*
  {
    // first, initialize the argument array as needed
    if (_args == null || _args.length != _children.length) {
      _args = new Array(_children.length);
    }
    // now evaluate all sub-expressions
    for (var i:int = 0; i < _children.length; ++i) {
      _args[i] = _children[i].eval(o);
    }
    // now evaluate the function
    return _func.apply(null, _args);
  }

  /**
   * @inheritDoc
   */
  public override function toString():String
  {
    return _name + getString();
  }

  // --------------------------------------------------------------------

  /**
   * Function table mapping function names to Function instances.
   * Functions can be added or removed at run-time by editing this
   * object.
   */
  public static var table:Object = {
    // Math Functions
    ABS:    Math.abs,
    ACOS:    Math.acos,
    ASIN:    Math.asin,
    ATAN:    Math.atan,
    ATAN2:    Math.atan2,
    CEIL:    Math.ceil,
    CEILING:  Math.ceil,
    COS:    Math.cos,
    EXP:    Math.exp,
    FLOOR:    Math.floor,
    LOG:    Math.log,
    MAX:    Math.max,
    MIN:    Math.min,
    POW:    Math.pow,
    POWER:    Math.pow,
    RANDOM:    Math.random,
    ROUND:    Math.round,
    SIN:    Math.sin,
    SQRT:    Math.sqrt,
    TAN:    Math.tan,

    // String Functions
    CONCAT:    StringUtil.concat,
    CONCAT_WS:  StringUtil.concat_ws,
    FORMAT:    StringUtil.format,
    INSERT:    StringUtil.insert,
    LEFT:    StringUtil.left,
    LENGTH:    StringUtil.length,
    LOWER:    StringUtil.lower,
    LCASE:    StringUtil.lower,
    LPAD:    StringUtil.lpad,
    MID:    StringUtil.substring,
    POSITION:  StringUtil.position,
    REVERSE:  StringUtil.reverse,
    REPEAT:    StringUtil.repeat,
    REPLACE:  StringUtil.replace,
    RIGHT:    StringUtil.right,
    RPAD:    StringUtil.rpad,
    SPACE:    StringUtil.space,
    SUBSTRING:  StringUtil.substring,
    UPPER:    StringUtil.upper,
    UCASE:    StringUtil.upper,

    // Date/Time Functions
    DAY:    DateUtil.day,
    DAYOFWEEK:  DateUtil.dayOfWeek,
    HOUR:    DateUtil.hour,
    MICROSECOND:DateUtil.microsecond,
    MINUTE:    DateUtil.minute,
    MONTH:    DateUtil.month,
    NOW:    DateUtil.now,
    SECOND:    DateUtil.second,
    YEAR:    DateUtil.year
  };

} // end of class Fn
}