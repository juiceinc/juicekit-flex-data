package org.juicekit.data.model
{
    import flash.utils.Proxy;
    import flash.utils.flash_proxy;
    
    
    /**
     * Helper class that allows access to an object through a DataSchema.
     * 
     * @see org.juicekit.data.model.DataSchema
     * @see org.juicekit.data.model.DataArrayCollection
     */
    public class DataItem extends Proxy {
        protected var schema:DataSchema;
        
        /**
         * The original object used to create the DataItem.
         */
        public var _object:Object;
        
        
        public function setSchema(s:DataSchema):void {
            schema = s;
        }
        
        public function DataItem(dataSchema:DataSchema, obj:Object=null) {
            schema = dataSchema;
            init(obj);
        }
        
        public function init(obj:Object):Object {
            _object = obj;
            return this;
        }
        
        
        override flash_proxy function callProperty(methodName:*, ... args):* {
            return null;
        }
        
        
        /**
         * Search for a property by looking in the schema. 
         */
        override flash_proxy function getProperty(name:*):* {
            if (schema == null) {
                return _object[name]
            } else {
                var nm:String;
                if (name is String) {
                    nm = name as String;
                } else if (name is QName) {
                    nm = (name as QName).localName;
                } 
                if (nm.charAt(0) == '$') {
                    nm = nm.substr(1);
                    return schema.getFormattedFieldValue(nm, _object);
                } else {
                    return schema.getFieldValue(nm, _object);
                }
            } 
        }
        
        override flash_proxy function setProperty(name:*, value:*):void {
            _object[name] = value;    
        }
        
        protected var _item:Array; // array of object's properties
        
        override flash_proxy function nextNameIndex(index:int):int {
            if (schema && schema.length > 0) {
                if (index < schema.length) {
                    return index + 1;
                } else {
                    return 0;
                }
            } else {
                // initial call
                if (index == 0) {
                    _item = new Array();
                    for (var x:* in _object) {
                        _item.push(x);
                    }
                }
                
                if (index < _item.length) {
                    return index + 1;
                } else {
                    return 0;
                }
            }
        }
        override flash_proxy function nextName(index:int):String {
            if (schema && schema.length > 0) {
                return schema[index-1].name;
            } else {
                return _object[index-1];
            }
        }        
        
        override flash_proxy function nextValue( index:int ):*
        {
            if (schema && schema.length > 0) {
                return flash_proxy::getProperty( schema[index-1].name );        	
            } else {
                return flash_proxy::getProperty( _object[ index - 1 ]);        	
            }
        }
        
    } // end of class ValueProxy    
}