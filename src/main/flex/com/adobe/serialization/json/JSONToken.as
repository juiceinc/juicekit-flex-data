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
public class JSONToken {

  private var _type:int;
  private var _value:Object;

  /**
   * Creates a new JSONToken with a specific token type and value.
   *
   * @param type The JSONTokenType of the token
   * @param value The value of the token
   * @langversion ActionScript 3.0
   * @playerversion Flash 8.5
   * @tiptext
   */
  public function JSONToken(type:int = -1 /* JSONTokenType.UNKNOWN */, value:Object = null) {
    _type = type;
    _value = value;
  }

  /**
   * Returns the type of the token.
   *
   * @see com.adobe.serialization.json.JSONTokenType
   * @langversion ActionScript 3.0
   * @playerversion Flash 8.5
   * @tiptext
   */
  public function get type():int {
    return _type;
  }

  /**
   * Sets the type of the token.
   *
   * @see com.adobe.serialization.json.JSONTokenType
   * @langversion ActionScript 3.0
   * @playerversion Flash 8.5
   * @tiptext
   */
  public function set type(value:int):void {
    _type = value;
  }

  /**
   * Gets the value of the token
   *
   * @see com.adobe.serialization.json.JSONTokenType
   * @langversion ActionScript 3.0
   * @playerversion Flash 8.5
   * @tiptext
   */
  public function get value():Object {
    return _value;
  }

  /**
   * Sets the value of the token
   *
   * @see com.adobe.serialization.json.JSONTokenType
   * @langversion ActionScript 3.0
   * @playerversion Flash 8.5
   * @tiptext
   */
  public function set value(v:Object):void {
    _value = v;
  }

}

}