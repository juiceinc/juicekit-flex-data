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
 * @private
 */
public class JSONParseError extends Error {

  /** The location in the string where the error occurred */
  private var _location:int;

  /** The string in which the parse error occurred */
  private var _text:String;

  /**
   * Constructs a new JSONParseError.
   *
   * @param message The error message that occured during parsing
   * @langversion ActionScript 3.0
   * @playerversion Flash 8.5
   * @tiptext
   */
  public function JSONParseError(message:String = "", location:int = 0, text:String = "") {
    super(message);
    //name = "JSONParseError";
    _location = location;
    _text = text;
  }

  /**
   * Provides read-only access to the location variable.
   *
   * @return The location in the string where the error occurred
   * @langversion ActionScript 3.0
   * @playerversion Flash 8.5
   * @tiptext
   */
  public function get location():int {
    return _location;
  }

  /**
   * Provides read-only access to the text variable.
   *
   * @return The string in which the error occurred
   * @langversion ActionScript 3.0
   * @playerversion Flash 8.5
   * @tiptext
   */
  public function get text():String {
    return _text;
  }
}

}