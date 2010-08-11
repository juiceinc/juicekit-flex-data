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
 * Expression operator for text matching operations. Performs prefix,
 * suffix, containment, and regular expression matching.
 */
public class Match extends BinaryExpression
{
  /** Indicates a prefix matching test. */
  public static const PREFIX:int = 0;
  /** Indicates a suffix matching test. */
  public static const SUFFIX:int = 1;
  /** Indicates a string containment test. */
  public static const WITHIN:int = 2;
  /** Indicates a regular expression matching test. */
  public static const REGEXP:int = 3;

  /** Returns a string representation of the string matching operator. */
  public override function get operatorString():String
  {
    switch (_op) {
      case PREFIX: return 'STARTS-WITH';
      case SUFFIX: return 'ENDS-WITH';
      case WITHIN: return 'CONTAINS';
      case REGEXP: return 'REGEXP';
      default: return '?';
    }
  }

  /**
   * Create a new Match expression.
   * @param operation the operation to perform
   * @param left the left sub-expression
   * @param right the right sub-expression
   */
  public function Match(op:int, left:*, right:*)
  {
    super(op, PREFIX, REGEXP, left, right);
  }

  /**
   * @inheritDoc
   */
  public override function clone():Expression
  {
    return new Match(_op, _left.clone(), _right.clone());
  }

  /**
   * @inheritDoc
   */
  public override function eval(o:Object = null):*
  {
    var s:String = String(_left.eval(o));
    var p:String = String(_right.eval(o));

    // compute return value
    switch (_op) {
      case PREFIX: return StringUtil.startsWith(s, p);
      case SUFFIX: return StringUtil.endsWith(s, p);
      case WITHIN: return s.indexOf(p) >= 0;
      case REGEXP: return parseRegExp(p).test(s);
    }
    throw new Error("Unknown operation type: " + _op);
  }

  private var cachedRegExp:RegExp;
  private var cachedPattern:String;

  private function parseRegExp(p:String):RegExp
  {
    if (p == cachedPattern) return cachedRegExp;

    cachedPattern = p;
    var tok:Array = p.split("/");
    cachedRegExp = new RegExp(tok[1], tok[2]);
    return cachedRegExp;
  }

  // -- Static constructors ---------------------------------------------

  /**
   * Creates a new Match operator for matching string prefix.
   * @param left the left-hand input expression
   * @param right the right-hand input expression
   * @return the new Match operator
   */
  public static function StartsWith(left:*, right:*):Match
  {
    return new Match(PREFIX, left, right);
  }

  /**
   * Creates a new Match operator for matching a string suffix.
   * @param left the left-hand input expression
   * @param right the right-hand input expression
   * @return the new Match operator
   */
  public static function EndsWith(left:*, right:*):Match
  {
    return new Match(SUFFIX, left, right);
  }

  /**
   * Creates a new Match operator for matching string containment.
   * @param left the left-hand input expression
   * @param right the right-hand input expression
   * @return the new Match operator
   */
  public static function Contains(left:*, right:*):Match
  {
    return new Match(WITHIN, left, right);
  }

  /**
   * Creates a new Match operator for matching a regular expression.
   * @param left the left-hand input expression
   * @param right the right-hand input expression
   * @return the new Match operator
   */
  public static function RegEx(left:*, right:*):Match
  {
    return new Match(REGEXP, left, right);
  }

} // end of class Match
}