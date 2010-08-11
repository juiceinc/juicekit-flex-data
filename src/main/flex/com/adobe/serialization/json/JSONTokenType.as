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
 * Class containing constant values for the different types
 * of tokens in a JSON encoded string.
 * @private
 */
public class JSONTokenType {

  public static const UNKNOWN:int = -1;

  public static const COMMA:int = 0;

  public static const LEFT_BRACE:int = 1;

  public static const RIGHT_BRACE:int = 2;

  public static const LEFT_BRACKET:int = 3;

  public static const RIGHT_BRACKET:int = 4;

  public static const COLON:int = 6;

  public static const TRUE:int = 7;

  public static const FALSE:int = 8;

  public static const NULL:int = 9;

  public static const STRING:int = 10;

  public static const NUMBER:int = 11;

}

}