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

package org.juicekit.util
{
    import org.juicekit.data.model.DataField;
    import org.juicekit.data.model.DataSchema;
    
    /**
     * Utility class for parsing and representing data field values.
     */
    public class DataUtil
    {
        /** Constant indicating an unknown data type. */
        public static const UNKNOWN:int = -1;
        /** Constant indicating a numeric data type. */
        public static const NUMBER:int = 0;
        /** Constant indicating an integer data type. */
        public static const INT:int = 1;
        /** Constant indicating a Date data type. */
        public static const DATE:int = 2;
        /** Constant indicating a String data type. */
        public static const STRING:int = 3;
        /** Constant indicating an arbitrary Object data type. */
        public static const OBJECT:int = 4;
        /** Constant indicating a boolean data type. */
        public static const BOOLEAN:int = 5;
        /** Constant indicating a numeric data type that should be displayed as currency. */
        public static const CURRENCY:int = 6;
        /** Constant indicating a percentage data type. */
        public static const PCT:int = 7;
        
        
        /**
         * Parse an input value given its data type.
         * @param val the value to parse
         * @param type the data type to parse as
         * @return the parsed data value
         */
        public static function parseValue(val:Object, type:int):Object
        {
            switch (type) {
                case NUMBER:
                    return Number(val);
                case INT:
                    return int(val);
                case BOOLEAN:
                    return Boolean(val);
                case DATE:
                    var t:Number = val is Number ? Number(val)
                    : Date.parse(String(val));
                    return isNaN(t) ? null : new Date(t);
				case CURRENCY:
					var s:String = String(val);
					if (s.charAt(0) == '$')
						s = s.substr(1);
					s = s.replace(',', '');
					return Number(s);
				case PCT:
					s = String(val);
					if (s.charAt(s.length - 1) == '%')
						s = s.substr(0, s.length-1);
					return Number(s) / 100;
                case STRING:
                    return String(val);
                default:    
					return val;
            }
        }
        
        /**
         * Returns the data type for the input string value. This method
         * attempts to parse the value as a number of different data types.
         * If successful, the matching data type is returned. If no parse
         * succeeds, this method returns the <code>STRING</code> constant.
         * @param s the string to parse
         * @return the inferred data type of the string contents
         */
        public static function type(s:String):int
        {
			if (s.length == 0) return NUMBER;
            if (!isNaN(Number(s))) return NUMBER;
            if (!isNaN(Date.parse(s))) return DATE;
			if (s.length > 0 && s.charAt(0) == '$') 
				return CURRENCY;
			if (s.length > 0 && s.charAt(s.length - 1) == '%') 
				return PCT;
            return STRING;
        }
        
        
        public static function typeFromObject(o:Object):int
        {
            if (o is String) {
                return STRING;
            } else if (o is int) {
                return INT;
            } else if (o is Boolean) {
                return BOOLEAN;          
            } else if (o is Number) {
                return NUMBER;
            } else if (o is Date) {
                return DATE;
            } else { 
                return -1;
            }
        }
        
        
        /**
         * Infers the data schema by checking values of the input data.
         * @param tuples an array of data tuples
         * @return the inferred schema
         */
        public static function inferSchema(tuples:Array):DataSchema
        {
            if (tuples == null || tuples.length == 0) return null;
            
            var header:Array = [];
            for (var name:String in tuples[0]) {
                header.push(name);
            }
            var types:Array = new Array(header.length);
            
            // initialize data types
            for (var col:int = 0; col < header.length; ++col) {
                types[col] = DataUtil.type(tuples[0][header[col]]);
            }
            
            // now process data to infer types
            for (var i:int = 2; i < tuples.length; ++i) {
                var tuple:Object = tuples[i];
                for (col = 0; col < header.length; ++col) {
                    name = header[col];
                    var value:Object = tuple[name];
                    if (types[col] == -1 || value == null) continue;
                    
                    var type:int =
                        value is Number ? NUMBER :
                        value is String ? STRING :
                        value is int ? INT :
                        value is Boolean ? BOOLEAN :
                        value is Date ? DATE : OBJECT;
                    
                    if (types[col] != type) {
                        types[col] = -1;
                    }
                }
            }
            
            // finally, we create the schema
            var schema:DataSchema = new DataSchema();
            for (col = 0; col < header.length; ++col) {
                schema.addField(
                    new DataField(header[col],
                        types[col] == -1 ? DataUtil.STRING : types[col]));
            }
            
            Sort.sortArrayCollectionBy(schema, ['isMetric', 'name']);
            return schema;
        }
        
    } // end of class DataUtil
}