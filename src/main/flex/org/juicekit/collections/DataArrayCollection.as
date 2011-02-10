package org.juicekit.collections
{
    import flash.events.Event;
    
    import mx.binding.utils.BindingUtils;
    import mx.collections.ArrayCollection;
    import mx.controls.DataGrid;
    import mx.controls.dataGridClasses.DataGridColumn;
    import mx.events.CollectionEvent;
    import mx.events.CollectionEventKind;
    
    import org.juicekit.collections.StatsArrayCollection;
    import org.juicekit.data.model.DataField;
    import org.juicekit.data.model.DataItem;
    import org.juicekit.data.model.DataSchema;
    import org.juicekit.query.Expression;
    import org.juicekit.query.Query;
    import org.juicekit.query.methods.*;
    import org.juicekit.util.DataUtil;
    
    /*
    import spark.components.DataGrid;
    */
    
    /**
     * An array collection 
     */
    public class DataArrayCollection extends StatsArrayCollection
    {
        
        //---------------------------------------------------
        //
        // Properties
        //
        //---------------------------------------------------
        
        private var _schema:DataSchema;
        
        [Bindable(event="schemaChanged")]
        public function get schema():DataSchema 
        {
            return _schema;
        }
        public function set schema(s:DataSchema):void 
        {
            if (s !== _schema) {
                //                if (_schema) 
                //                    _schema.removeEventListener(CollectionEvent.COLLECTION_CHANGE, handleSchemaChange);
                _schema = s;
                //                _schema.addEventListener(CollectionEvent.COLLECTION_CHANGE, handleSchemaChange, false, 0, true);
                for each (var di:DataItem in this.source) {
                    (di as DataItem).setSchema(_schema);
                }
                dispatchEvent(new Event('schemaChanged'));
            }
        }
        
        protected function handleSchemaChange(e:Event):void {
        }
        
        
        //---------------------------------------------------
        //
        // Methods
        //
        //---------------------------------------------------
        
        override public function addItemAt(item:Object, index:int):void
        {
            var d:DataItem;
            if (item is DataItem) 
            {
                d = item as DataItem;
                d.setSchema(schema);
            } 
            else 
            {
                d = new DataItem(schema, item);                
            }
            super.addItemAt(d, index);            
        }


        override public function setItemAt(item:Object, index:int):Object
        {
            var d:DataItem;
            if (item is DataItem) 
            {
                d = item as DataItem;
                d.setSchema(schema);
            } 
            else 
            {
                d = new DataItem(schema, item);                
            }
            return super.setItemAt(d, index);
        }
        
        
        
        /**
         * A DataArrayCollection created by aggregating DataFields in the schema.
         */
        [Bindable(event="collectionChange")]
        [Bindable(event="schemaChanged")]
        public function get aggregateDataArrayCollection():DataArrayCollection {
            if (schema) {
                var selectVars:Object = {};
                for each (var fld:DataField in schema) {
                    selectVars[fld.name] = fld.aggregationExpression;
                }
                var q:Query = select(selectVars);
                var r:Array = q.eval(this.source);
                var result:DataArrayCollection = new DataArrayCollection(r);
                result.schema = q.dataSchema;
                return result;                              
            }
            return null;
        }
        
        
        /**
         * Wrap all objects as DataItems
         */
        override public function set source(s:Array):void
        {
            if (!schema && s && s.length) {
                this.schema = DataUtil.inferSchema(s);
            }
            var dataItemArray:Array = [];
            for each (var item:Object in s) {
                dataItemArray.push(new DataItem(schema, item));
            }
            super.source = dataItemArray;
            dispatchEvent(new CollectionEvent(CollectionEvent.COLLECTION_CHANGE, true, false, CollectionEventKind.RESET));
        }
        
        
        //---------------------------------------------------
        //
        // Constructor
        //
        //---------------------------------------------------
        
        public function DataArrayCollection(source:Array=null, schema:DataSchema=null):void             
        {
            if (schema != null)
                this.schema = schema;
            this.source = source;            
        }
    }
}