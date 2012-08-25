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
    import flash.events.EventDispatcher;
    
    import mx.events.PropertyChangeEvent;
    
    import org.juicekit.query.Expression;
    import org.juicekit.query.methods.*;
    import org.juicekit.util.DataUtil;
    import org.juicekit.util.Strings;
    
    
    /**
     * A data field stores metadata for an individual data variable.
     */
    [Bindable]
    public class DataField extends EventDispatcher
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
                var oldValue:* = _id;
                _id = v;
                dataFieldChanged('id', oldValue, v);
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
                var oldValue:* = _name;
                _name = v;
                dataFieldChanged('name', oldValue, v);
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
                var oldValue:* = _rawField;
				_expression = null;
				_aggregationExpression = null;
                _rawField = v;
                dataFieldChanged('rawField', oldValue, v);
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
                var oldValue:* = _type;
                _type = v;
                dataFieldChanged('type', oldValue, v);
            }
        }
        
        [Bindable(event="dataFieldChanged")]
        public function get type():int {
            return _type;
        } 
        
        
        /** 
         * A formatting string for displaying values of this field.
         * 
         * <p>If not specified, use defaults based on type.</p>
         *
         * @see org.juicekit.util.Strings
         */
        protected var _format:String;
        
        public function set format(v:String):void {
            if (v != _format) {
				var oldValue:* = _format;
				if (v == getDefaultFormat(type))
					v = null;
				
                _format = v;
                dataFieldChanged('format', oldValue, v);
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
         * 
         * <p>If not specified, use defaults based on type.</p>
         *
         * @see org.juicekit.util.Strings
         */
        protected var _detailFormat:String;
        
        public function set detailFormat(v:String):void {
            if (v != _detailFormat) {
                var oldValue:* = _detailFormat;
                _detailFormat = v;
                dataFieldChanged('detailFormat', oldValue, v);
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
                var oldValue:* = _label;
                _label = v;
                dataFieldChanged('label', oldValue, v);
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
                var oldValue:* = _description;
                _description = v;
                dataFieldChanged('description', oldValue, v);
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
                var oldValue:* = _defaultValue;
                _defaultValue = v;
                dataFieldChanged('defaultValue', oldValue, v);
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
            var oldValue:* = _expression;
            if (v is Expression) {
                _expression = v;                
            } else if (v is String) {
                _expression = Expression.expr(v);
            } else {
                _expression = null;
            }
            dataFieldChanged('expression', oldValue, _expression);
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
		 * A related field is used to calculate expressions that involve two DataFields.
		 * 
		 * See wtdaverage.
		 **/
		protected var _relatedField:DataField;
		
		public function set relatedField(v:DataField):void {
			_relatedField = v;
		}
        
		public function get relatedField():DataField {
			return _relatedField;
		}

		
        /** 
         * An expression to calculate the value of this field from a DataItem object
         * when the field is aggregated
         * 
         * @see DataItem  
         **/
        protected var _aggregationExpression:Expression;
        
        public function set aggregationExpression(v:*):void {
            var oldValue:* = aggregationExpression;
            if (v is Expression) {
                _aggregationExpression = v;
            } else if (v is String) {
                _aggregationExpression = Expression.expr(v);
            } else {
                _aggregationExpression = null;
            }
            dataFieldChanged('aggregationExpression', oldValue, aggregationExpression);
        }
        
        [Bindable(event="dataFieldChanged")]
        public function get aggregationExpression():Expression {
            if (_aggregationExpression == null) {
				if (_aggregationOperator == 'weightedAverage') {
					_aggregationExpression = aggregationOperator(expression, relatedField.expression);
				} else {
					_aggregationExpression = aggregationOperator(expression);
				}					
            } 
            _aggregationExpression.dataField = this;
            return _aggregationExpression;
        } 
		
		
		/**
		 * Register new operators to use for aggregation.
		 * 
		 * @param code a string to use to identify the operator
		 * @param op a unary function 
		 */
		public function registerAggregationOperator(code:String, op:Function):void {
			_aggregationOperatorMap[code] = op;		
		}
		
		
		/** 
		 * An operator to calculate the value of this field from a DataItem object
		 * when the field is aggregated.
		 * 
		 * @see DataItem  
		 **/
		protected var _aggregationOperator:String = 'sum';
		protected var _aggregationOperatorMap:Object = {
			'sum': sum,
			'average': average,
			'min': min,
			'max': max,
			'count': count,
			'median': median,
			'weightedAverage': wtdaverage
		};
			
		
		/**
		 * Set the aggregation operator as a String. The aggregation operator
		 * must be registered in the aggregationOperatorMap.
		 * 
		 * Operators can include 'sum', 'average', 'min', 'max', 'count', 'weightedAverage' 
		 */ 
		public function set aggregationOperator(v:*):void {
			if (v == 'weightedAverage' && relatedField == null) {
				throw new Error('weightedAverage operator requires setting a relatedField to provide the weighting.');	
			}
			var oldValue:* = aggregationExpression;
			_aggregationExpression = null;
			_aggregationOperator = v;
			dataFieldChanged('aggregationExpression', oldValue, aggregationExpression);
		}
		
		[Bindable(event="dataFieldChanged")]
		public function get aggregationOperator():* {
			if (_aggregationOperatorMap.hasOwnProperty(_aggregationOperator)) {
				return _aggregationOperatorMap[_aggregationOperator];
			} else {
				return _aggregationOperatorMap['sum'];
			}
		} 		
		
		
		/**
		 * Aggregate an expression
		 */
		public function aggregate(v:*):* {
			return (aggregationOperator as Function)(v);
		}
        
        /** 
         * Is this data field usable as a metric?
         * 
         **/
        protected var _isMetric:Object;
        
        
        public function set isMetric(v:Object):void {
            if (v != _isMetric) {
                var oldValue:* = _isMetric;
                _isMetric = v;
                dataFieldChanged('isMetric', oldValue, v);
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
                var oldValue:* = _isAdditive;
                _isAdditive = v;
                dataFieldChanged('isAdditive', oldValue, v);
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
                var oldValue:* = _isDimension;
                _isDimension = v;
                dataFieldChanged('isDimension', oldValue, v);
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
        public function dataFieldChanged(prop:String, oldValue:*, newValue:*):void {
            dispatchEvent(new Event('dataFieldChanged'));
            dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, prop, oldValue, newValue)); 
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
        
		
		protected static var _defaultValue:Object = '';
		
		protected static var _defaultValues:Array        = [  
			0,           // number           
			0,           // int
			null,        // date
			'Unknown',   // string
			{},          // object
			false,       // boolean
			0,           // currency
			0            // pct
		];
		
		protected static var _defaultFormat:String = '';
		
		[ArrayElementType("String")]
		protected static var _defaultFormats:Array       = [
			"#,##0.00",  
			"#,##0", 
			"MMM d, yyyy",        
			"", 
			"",          
			"",  
			"$#,##0",  
			"0.00%"
		];
		
		protected static var _defaultDetailFormat:String = '';
		[ArrayElementType("String")]
		protected static var _defaultDetailFormats:Array = [
			"#,##0.000", 
			"#,##0", 
			"ddd MMMM d, yyyy",        
			"", 
			"",          
			"",  
			"$#,##0.00", 
			"0.000%"
		];
		
		protected static var _defaultTypeName:String = 'Unknown';
		
		[ArrayElementType("String")]
		protected static var _typeNames:Array = [
			"Number", 
			"Integer", 
			"Date", 
			"String", 
			"Object", 
			"Boolean", 
			"Currency", 
			"Percentage"
		];

        
        public function getDefaultValue(type:int):Object {
            if (type >= 0 && type < _defaultValues.length) {
                return _defaultValues[type];
            } else {
                return _defaultValue;                
            }
        }
        
        public function getDefaultFormat(type:int):String {
            if (type >= 0 && type < _defaultFormats.length) {
                return _defaultFormats[type];
            } else {
                return _defaultFormat;                
            }
        }
        
        public function getDefaultDetailFormat(type:int):String {
            if (type >= 0 && type < _defaultDetailFormats.length) {				
                return _defaultDetailFormats[type];
            } else {
                return _defaultDetailFormat;                
            }
        }
        
        public function get typeName():String {
            if (type >= 0 && type < _typeNames.length) {
                return _typeNames[type];
            } else {
                return _defaultTypeName;                
            }
        }

		
		/**
		 * Register updated default formats for a type
		 */
		public static function registerFormatForType(type:int, format:String, detailFormat:String):void 
		{
			if (type > 0 && type < _defaultFormats.length) 
			{
				if (format != null) _defaultFormats[type] = format;
				if (detailFormat != null) _defaultDetailFormats[type] = detailFormat;
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
                                  isDimension:Object=null)
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