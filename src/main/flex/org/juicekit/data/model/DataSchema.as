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
    
    import mx.collections.ArrayCollection;
    import mx.collections.ArrayList;
    import mx.collections.IList;
    import mx.controls.dataGridClasses.DataGridColumn;
    
    import org.juicekit.util.Arrays;
    import org.juicekit.util.DataUtil;
    
    import spark.components.gridClasses.GridColumn;
    
    
    /**
     * A data schema represents a set of data variables and their associated
     * types. A schema maintains a collection of <code>DataField</code>
     * objects.
     * @see flare.data.DataField
     */
    [Bindable]
    public class DataSchema extends ArrayCollection
    {
        //-------------------------------------------
        //
        // Properties
        //
        //-------------------------------------------
        
        [ArrayElementType("org.juicekit.data.model.DataField")]
        
        public var dataRoot:String = null;
        public var hasHeader:Boolean = false;
        
        /** Default to displaying formatted numbers */
        public var showFormats:Boolean = false;
        
        private var _nameLookup:/*String->DataField*/Object = {};
        private var _rawNameLookup:/*String->DataField*/Object = {};
        private var _idLookup:/*String->DataField*/Object = {};
        
        /** An array containing the data fields in this schema. */
        public function get fields():Array {
            return Arrays.copy(this.toArray());
        }
        
        /** The number of data fields in this schema. */
        public function get numFields():int {
            return this.length;
        }
        
        //-------------------------------------------
        //
        // Methods
        //
        //-------------------------------------------
        
        /**
         * Adds a field to this schema.
         * @param field the data field to add
         */
        public function addField(field:DataField):void
        {
            _nameLookup[field.name] = field;
            _rawNameLookup[field.rawField] = field;
            _idLookup[field.id] = field;
            this.addItem(field);
            dispatchEvent(new Event('collectionChange'));
        }
        
        /**
         * Retrieves a data field by name.
         * @param name the data field name @param useRawNameLookup use rawNameLookup in addition to nameLookup
         * @return the corresponding data field, or null if no data field is
         *  found matching the name
         */
        public function getFieldByName(name:String, useRawNameLookup:Boolean=true):DataField
        {
            if (_nameLookup.hasOwnProperty(name)) 
            {
                return _nameLookup[name];
            }
            else if (useRawNameLookup && !_rawNameLookup.hasOwnProperty(name)) 
            {
                _rawNameLookup[name] = new DataField(name, DataUtil.UNKNOWN);
            } 
            return _rawNameLookup[name];
        }
        
        public function $(name:String):DataField
        {
            return _nameLookup[name];
        }
        
        /**
         * Retrieves a data field by id.
         * @param name the data field id
         * @return the corresponding data field, or null if no data field is
         *  found matching the id
         */
        public function getFieldById(id:String):DataField
        {
            return _idLookup[id];
        }
        
        /**
         * Retrieves a data field by its index in this schema.
         * @param idx the index of the data field in this schema
         * @return the corresponding data field
         */
        public function getFieldAt(idx:int):DataField
        {
            return this.getItemAt(idx) as DataField;
        }
        
        /**
         * Gets a value from a field 
         * 
         * @param name The name of the field
         * @param o An object to look in
         * @return The value corresponding to field <code>name</code> on object <code>o</code>.
         */
        public function getFieldValue(name:String, o:Object):* {
            if (showFormats) 
                return getFormattedFieldValue(name, o);
            else 
                var fld:DataField = getFieldByName(name) 
                return getFieldByName(name).expression.eval(o);
        }
        
        
        /**
         * Gets a formatted value from a field 
         * 
         * @param name The name of the field
         * @param o An object to look in
         * @return The formatted value corresponding to field <code>name</code> on object <code>o</code>.
         */
        public function getFormattedFieldValue(name:String, o:Object):String {
            var fld:DataField = getFieldByName(name);
            return fld.formatValue(fld.expression.eval(o));
        }
        
        
        [Bindable(event="collectionChange")]
        public function get formattedDataGridColumns():Array {
            var columns:Array = [];
            for each (var f:DataField in this) {
                var col:DataGridColumn = new DataGridColumn('$' + f.name);
                col.headerText = f.label;
                columns.push(col);
            }
            return columns;
        }
        
        
        [Bindable(event="collectionChange")]
        public function get dataGridColumns():Array {
            var columns:Array = [];
            for each (var f:DataField in this) {
                var col:DataGridColumn = new DataGridColumn(f.name);
                col.headerText = f.label;
                columns.push(col);
            }
            return columns;
        }
        
        [Bindable(event="collectionChange")]
        public function get sparkFormattedDataGridColumns():IList {
            var columns:ArrayList = new ArrayList();
            for each (var f:DataField in this) {
                var col:GridColumn = new GridColumn();
                col.dataField = '$' + f.name;
                col.headerText = f.label;
                columns.addItem(col);
            }
            return columns;
        }
        
        
        [Bindable(event="collectionChange")]
        public function get sparkDataGridColumns():IList {
            var columns:ArrayList = new ArrayList();
            for each (var f:DataField in this) {
                var col:GridColumn = new GridColumn();
                col.dataField = f.name;
                col.headerText = f.label;
                columns.addItem(col);
            }
            return columns;
        }
        
        private var _metrics:DataSchema;
        private var _dimensions:DataSchema;
        
        [Bindable(event="collectionChange")]
        public function get metrics():DataSchema {
            if (_metrics == null) _metrics = new DataSchema();
            var idx:int;
            for each (var fld:DataField in this) {                
                if (fld.isMetric) {
                    if (!_metrics.getFieldByName(fld.name, false)) {                        
                        _metrics.addField(fld);
                    }
                }
            }
            
            // Step through all the fields backwards and make 
            // sure they were seen
            idx = _metrics.length - 1;
            while (idx >= 0) {
                fld = _metrics.getFieldAt(idx); 
                if (!this.getFieldByName(fld.name)) {
                    _metrics.removeItemAt(idx);
                }
                idx -= 1;   
            }
            return _metrics;
        }
    
        
        [Bindable(event="collectionChange")]
        public function get dimensions():DataSchema {
            if (_dimensions == null) _dimensions = new DataSchema();
            var idx:int;
            for each (var fld:DataField in this) {                
                if (fld.isDimension) {
                    if (!_dimensions.getFieldByName(fld.name, false)) {                        
                        _dimensions.addField(fld);
                    }
                }
            }
            
            // Step through all the fields backwards and make 
            // sure they were seen
            idx = _dimensions.length - 1;
            while (idx >= 0) {
                fld = _dimensions.getFieldAt(idx); 
                if (!this.getFieldByName(fld.name)) {
                    _dimensions.removeItemAt(idx);
                }
                idx -= 1;   
            }
            return _dimensions;
        }
        
        //-------------------------------------------
        //
        // Constructor
        //
        //-------------------------------------------
        
        /**
         * Creates a new DataSchema.
         * @param fields an ordered list of data fields to include in the
         * schema
         */
        public function DataSchema(...fields)
        {
            for each (var f:DataField in fields) {
                addField(f);
            }
        }
        
        
    } // end of class DataSchema
}