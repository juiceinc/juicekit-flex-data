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
import flash.utils.ByteArray;

/**
 * Utility class providing functions for manipulating <code>String</code>
 * objects. These functions are intended for use by the
 * <code>Fn</code> operator.
 */
public class StringUtil
{
  public static function concat(...args):String
  {
    return args.join("");
  }

  public static function concat_ws(sep:String, ...args):String
  {
    return args.join(sep);
  }

  public static function format(x:Number, d:int):String
  {
    return x.toFixed(d);
  }

  public static function insert(s:String, pos:int, len:int, ns:String):String
  {
    var slen:int = s.length;
    if (pos < 0 || pos > slen)
      return s;
    if (len < 0 || len > slen)
      return s.substring(0, pos) + ns;
    else
      return s.substring(0, pos) + ns + s.substring(len);
  }

  public static function left(s:String, len:int):String
  {
    return s.substring(0, len);
  }

  public static function length(s:String):int
  {
    return s.length;
  }

  public static function lower(s:String):String
  {
    return s.toLowerCase();
  }

  public static function lpad(s:String, len:int, pad:String):String
  {
    var strlen:int = s.length;
    if (strlen > len) {
      return s.substring(0, len);
    }
    else if (strlen == len) {
      return s;
    }
    else {
      var b:ByteArray = new ByteArray();
      var padlen:int = pad.length;
      var diff:int = len - strlen;

      for (var i:int = 0; i < diff; i += padlen)
        b.writeUTFBytes(pad);
      if (b.length > diff)
        b.position = diff;
      b.writeUTFBytes(s);
      b.position = 0;
      return b.readUTFBytes(b.length);
    }
  }

  public static function position(sub:String, s:String):int
  {
    return s.indexOf(sub);
  }

  public static function reverse(s:String):String
  {
    var b:ByteArray = new ByteArray();
    for (var i:int = s.length - 1; --i >= 0;) {
      b.writeUTFBytes(s.charAt(i));
    }
    b.position = 0;
    return b.readUTFBytes(b.length);
  }

  public static function repeat(s:String, count:int):String
  {
    var b:ByteArray = new ByteArray();
    for (var i:int = 0; i < count; ++i) {
      b.writeUTFBytes(s);
    }
    b.position = 0;
    return b.readUTFBytes(b.length);
  }

  public static function replace(s:String, orig:String, replace:String):String
  {
    return s.replace(new RegExp(orig, "g"), replace);
  }

  public static function right(s:String, len:int):String
  {
    return s.substring(s.length - len);
  }

  public static function rpad(s:String, len:int, pad:String):String
  {
    var strlen:int = s.length;
    if (strlen > len) {
      return s.substring(0, len);
    }
    else if (strlen == len) {
      return s;
    }
    else {
      var b:ByteArray = new ByteArray();
      b.writeUTFBytes(s);
      var padlen:int = pad.length;
      var diff:int = len - strlen;

      for (var i:int = 0; i < diff; i += padlen)
        b.writeUTFBytes(pad);
      b.position = 0;
      return b.readUTFBytes(len);
    }
  }

  public static function space(len:int):String
  {
    return repeat(" ", len);
  }

  public static function substring(s:String, pos:int, len:int = -1):String
  {
    return len < 0 ? s.substr(pos) : s.substr(pos, len);
  }

  public static function upper(s:String):String
  {
    return s.toUpperCase();
  }

  public static function startsWith(s:String, p:String):Boolean
  {
    return s.indexOf(p) == 0;
  }

  public static function endsWith(s:String, p:String):Boolean
  {
    var diff:int = s.length - p.length;
    if (diff < 0) return false;
    for (var i:uint = 0; i < p.length; ++i) {
      if (s.charCodeAt(i + diff) != p.charCodeAt(i))
        return false;
    }
    return true;
  }

} // end of class StringUtil
}