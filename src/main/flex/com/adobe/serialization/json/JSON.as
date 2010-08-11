/*
 * Copyright 2007-2010 Juice, Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package com.adobe.serialization.json {

/**
 * This class provides encoding and decoding of the JSON format.
 *
 * Example usage:
 * <code>
 *     // create a JSON string from an internal object
 *     JSON.encode( myObject );
 *
 *    // read a JSON string into an internal object
 *    var myObject:Object = JSON.decode( jsonString );
 *  </code>
 * @private
 */
public class JSON {


  /**
   * Encodes a object into a JSON string.
   *
   * @param o The object to create a JSON string for
   * @return the JSON string representing o
   * @langversion ActionScript 3.0
   * @playerversion Flash 8.5
   * @tiptext
   */
  public static function encode(o:Object):String {

    var encoder:JSONEncoder = new JSONEncoder(o);
    return encoder.getString();

  }

  /**
   * Decodes a JSON string into a native object.
   *
   * @param s The JSON string representing the object
   * @return A native object as specified by s
   * @throw JSONParseError
   * @langversion ActionScript 3.0
   * @playerversion Flash 8.5
   * @tiptext
   */
  public static function decode(s:String):Object {

    var decoder:JSONDecoder = new JSONDecoder(s)
    return decoder.getObject();

  }

}

}