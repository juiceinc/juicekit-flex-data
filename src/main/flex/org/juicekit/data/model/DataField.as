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

package org.juicekit.data.model
{
    import flash.events.Event;
    
    import org.juicekit.query.Expression;
    import org.juicekit.query.methods.sum;
    import org.juicekit.util.DataUtil;
    import org.juicekit.util.Strings;
    
    
    /**
     * A data field stores metadata for an individual data variable.
     */
    [Bindable]
    public class DataField
    {
        
        //-------------------------------------------
        //
        // Properties
        //
        //-------------------------------------------
        
        
        /** 
         * A unique id for the data field, often the name. 
         **/
        protected var _id:String;
        
        
        public function set id(v:String):void {
            if (v != _id) {
                _id = v;
                dataFieldChanged();
            }
        }
        
        [Bindable(event="dataFieldChanged")]
        public function get id():String {
            return _id == null ? _name : _id; 
        } 
        
        
        
        /** 
         * The name of the data field. The property name to
         * look for the value in an object.
         * 
         * Required.
         * 
         **/
        protected var _name:String;
        
        
        public function set name(v:String):void {
            if (v != _name) {
                _name = v;
                dataFieldChanged();
            }
        }
        
        [Bindable(event="dataFieldChanged")]
        public function get name():String {
            return _name;
        } 
        
        
        /** 
         * The property name to access on the raw object. 
         * 
         * <p>If not specified, use name.</p>
         **/
        protected var _rawField:String;
        
        
        public function set rawField(v:String):void {
            if (v != _rawField) {
                _rawField = v;
                dataFieldChanged();
            }
        }
        
        [Bindable(event="dataFieldChanged")]
        public function get rawField():String {
            return _rawField == null ? _name : _rawField; 
        } 
        
        
        /** 
         * The data type of this field.
         * 
         * Required.
         * 
         *  @see org.juicekit.data.DataUtil. 
         **/
        protected var _type:int = -1;
        
        
        public function set type(v:int):void {
            if (v != _type) {
                _type = v;
                dataFieldChanged();
            }
        }
        
        [Bindable(event="dataFieldChanged")]
        public function get type():int {
            return _type;
        } 
        
        
        /** 
         * A formatting string for displaying values of this field.
         * @see org.juicekit.util.Strings#format
         * 
         * <p>If not specified, use defaults based on type.</p>
         */
        protected var _format:String;
        
        public function set format(v:String):void {
            if (v != _format) {
                _format = v;
                dataFieldChanged();
            }
        }
        
        [Bindable(event="dataFieldChanged")]
        public function get format():String {
            if (_format == null) {
                _format = getDefaultFormat(type);
            } 
            return _format;
        } 
        
        
        
        /** 
         * A formatting string for exporting values of this field.
         * @see org.juicekit.util.Strings#format
         * 
         * <p>If not specified, use defaults based on type.</p>
         */
        protected var _detailFormat:String;
        
        public function set detailFormat(v:String):void {
            if (v != _detailFormat) {
                _detailFormat = v;
                dataFieldChanged();
            }
        }
        
        [Bindable(event="dataFieldChanged")]
        public function get detailFormat():String {
            if (_detailFormat == null) {
                _detailFormat = getDefaultDetailFormat(type);
            } 
            return _detailFormat;
        } 
        
        
        
        /** 
         * A label describing this data field, useful for axis titles. 
         * 
         * <p>If not specified, use name.</p>
         **/
        protected var _label:String;
        
        
        public function set label(v:String):void {
            if (v != _label) {
                _label = v;
                dataFieldChanged();
            }
        }
        
        [Bindable(event="dataFieldChanged")]
        public function get label():String {
            return _label == null ? _name : _label; 
        } 
        
        
        /** 
         * A description describing this data field, useful for tooltips. 
         * 
         * <p>If not specified, use expression.toString().</p>
         **/
        protected var _description:String;
        
        
        public function set description(v:String):void {
            if (v != _description) {
                _description = v;
                dataFieldChanged();
            }
        }
        
        [Bindable(event="dataFieldChanged")]
        public function get description():String {
            return _description == null ? expression.toString() : _description; 
        } 
        
        
        /** 
         * The default value for this data field. 
         **/
        protected var _defaultValue:Object;
        
        public function set defaultValue(v:Object):void {
            if (v != _defaultValue) {
                _defaultValue = v;
                dataFieldChanged();
            }
        }
        
        [Bindable(event="dataFieldChanged")]
        public function get defaultValue():Object {
            if (_defaultValue == null) {
                _defaultValue = getDefaultValue(type);
            } 
            return _defaultValue;
        } 
        
        
        /** 
         * An expression to calculate the value of this field from a DataItem object
         * 
         * @see DataItem  
         **/
        protected var _expression:Expression;
        
        public function set expression(v:*):void {
            if (v is Expression) {
                _expression = v;
            } else if (v is String) {
                _expression = Expression.expr(v);
            } else {
                _expression = null;
            }
            dataFieldChanged();
        }
        
        [Bindable(event="dataFieldChanged")]
        public function get expression():Expression {
            if (_expression == null) {
                _expression = Expression.expr(rawField);
            } 
            _expression.dataField = this;
            return _expression;
        } 
        
        
        /** 
         * An expression to calculate the value of this field from a DataItem object
         * when the field is aggregated
         * 
         * @see DataItem  
         **/
        protected var _aggregationExpression:Expression;
        
        public function set aggregationExpression(v:*):void {
            if (v is Expression) {
                _aggregationExpression = v;
            } else if (v is String) {
                _aggregationExpression = Expression.expr(v);
            } else {
                _aggregationExpression = null;
            }
            dataFieldChanged();
        }
        
        [Bindable(event="dataFieldChanged")]
        public function get aggregationExpression():Expression {
            if (_aggregationExpression == null) {
                _aggregationExpression = sum(expression);
            } 
            _aggregationExpression.dataField = this;
            return _aggregationExpression;
        } 
        
        
        /** 
         * Is this data field usable as a metric?
         * 
         **/
        protected var _isMetric:Object;
        
        
        public function set isMetric(v:Object):void {
            if (v != _isMetric) {
                _isMetric = v;
                dataFieldChanged();
            }
        }
        
        protected const DIMENSION_TYPES:Array = [DataUtil.STRING, DataUtil.BOOLEAN, DataUtil.DATE, DataUtil.OBJECT];
        
        [Bindable(event="dataFieldChanged")]
        public function get isMetric():Object {
            if (_isMetric == null) {
                return DIMENSION_TYPES.indexOf(type) == -1;
            }
            return _isMetric;
        } 
        
        /** 
         * Is this data field additive?
         * 
         **/
        protected var _isAdditive:Object;
        
        
        public function set isAdditive(v:Object):void {
            if (v != _isAdditive) {
                _isAdditive = v;
                dataFieldChanged();
            }
        }
        
        [Bindable(event="dataFieldChanged")]
        public function get isAdditive():Object {
            if (_isAdditive == null) {
                return isMetric;
            } 
            return _isAdditive;
        } 
        
        
        /** 
         * Is this data field usable as a dimension?
         * 
         **/
        protected var _isDimension:Object;
        
        
        public function set isDimension(v:Object):void {
            if (v != _isDimension) {
                _isDimension = v;
                dataFieldChanged();
            }
        }
        
        [Bindable(event="dataFieldChanged")]
        public function get isDimension():Object {
            if (_isDimension == null) {
                return DIMENSION_TYPES.indexOf(type) != -1;
            }
            return _isDimension;
        }
        
        
        
        //-------------------------------------------
        //
        // Methods
        //
        //-------------------------------------------
        
        public function formatValue(v:*):String {
            var f:String = this.format;
            if (f) {
                return Strings.format('{0:' + f + '}', v);
            } else {
                return String(v);
            }
        }
        
        
        public function clone():DataField {
            return new DataField(name,
                type,
                _defaultValue,
                _id,
                _format,
                _label,
                _rawField,
                _expression,
                _isMetric,
                _isAdditive,
                _isDimension);
            
        }
        
        
        /**
         * Notification that DataField properties have changed.
         */
        private function dataFieldChanged():void {
            dispatchEvent(new Event('dataFieldChanged'));
        }
        
        
        //-------------------------
        // Defaults
        //-------------------------
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
        
        //                                                 NUMBER      INT       DATE     STRING  OBJECT  BOOLEAN   CURRENCY      PCT 
        private static var _defaultValue:Object = '';
        private static var _defaultValues:Array        = [  0,           0,     null, 'Unknown', {},       false,         0,       0];

        private static var _defaultFormat:String = '';
        [ArrayElementType("String")]
        private static var _defaultFormats:Array       = ["#,##0.00",  "#,##0", "M d, Y",        "", "",          "",  "$#,##0",  "0.0%"];

        private static var _defaultDetailFormat:String = '';
        [ArrayElementType("String")]
        private static var _defaultDetailFormats:Array = ["#,##0.000", "#,##0", "M d, Y",        "", "",          "",  "$#,##0.00", "0.00%"];

        private static var _defaultTypeName:String = 'Unknown';
        [ArrayElementType("String")]
        private static var _typeNames:Array = ["Number", "Integer", "Date", "String", "Object", "Boolean", "Currency", "Percentage"];

        
        public function getDefaultValue(type:int):Object {
            if (type >= 0 && type < (_defaultValues.length - 1)) {
                return _defaultValues[type];
            } else {
                return _defaultValue;                
            }
        }
        
        public function getDefaultFormat(type:int):String {
            if (type >= 0 && type < (_defaultFormats.length - 1)) {
                return _defaultFormats[type];
            } else {
                return _defaultFormat;                
            }
        }
        
        public function getDefaultDetailFormat(type:int):String {
            if (type >= 0 && type < (_defaultDetailFormats.length - 1)) {
                return _defaultDetailFormats[type];
            } else {
                return _defaultDetailFormat;                
            }
        }
        
        public function get typeName():String {
            if (type >= 0 && type < (_typeNames.length - 1)) {
                return _typeNames[type];
            } else {
                return _defaultTypeName;                
            }
        }
        
        
        //-------------------------------------------
        //
        // Constructor
        //
        //-------------------------------------------
        
        /**
         * Creates a new DataField.
         * @param name the name of the data field
         * @param type the data type of this field
         * @param def the default value of this field
         * @param id a unique id for the field. If null, the name will be used
         * @param format a formatting string for printing values of this field
         * @param label a label describing this data field
         * @param rawField the field on the raw object
         * @param expr an expression to calculate to get this field value
         * @param isMetric can the field be treated as a metric
         * @param isAdditive is the field additive
         * @param isDimension can the field be treated as a dimension
         */
        public function DataField(name:String, 
                                  type:int, 
                                  def:Object=null,
                                  id:String=null, 
                                  format:String=null, 
                                  label:String=null,
                                  rawField:String=null,
                                  expr:*=null,
                                  isMetric:Object=null,
                                  isAdditive:Object=null,
                                  isDimension:Object=null):void
        {
            this.name = name;
            this.type = type;
            this.defaultValue = def;
            this.id = id;
            this.format = format;
            this.label = label;
            this.rawField = rawField;
            
            this.expression = expr;
            
            this.isMetric = isMetric;
            this.isAdditive = isMetric;
            this.isDimension = isMetric;
        }
        
    } // end of class DataField
}