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

package org.juicekit.query
{
    import flash.utils.describeType;
    import flash.utils.getQualifiedClassName;
    
    import mx.utils.ObjectUtil;
    
    import org.juicekit.data.DeferredProcessingBase;
    import org.juicekit.data.model.DataField;
    import org.juicekit.data.model.DataSchema;
    import org.juicekit.query.*;
    import org.juicekit.util.Filter;
    import org.juicekit.util.Property;
    import org.juicekit.util.Sort;
    
    /**
     * Performs query processing over a collection of ActionScript objects.
     * Queries can perform filtering, sorting, grouping, and aggregation
     * operations over a data collection. Arbitrary data collections can
     * be queried by providing a visitor function similar to the
     * <code>Array.forEach</code> method to the query <code>eval</code> method.
     *
     * <p>The <code>select</code> and <code>where</code> methods in the
     * <code>org.juicekit.query.methods</code> package are useful shorthands
     * for helping to construct queries in code.</p>
     *
     * <p>Here is an example of a query. It uses helper methods defined in the
     * <code>org.juicekit.query.methods</code> package. For example, the
     * <code>sum</code> method creates a <code>Sum</code> query operator and
     * the <code>_</code> method creates as a <code>Literal</code> expression
     * for its input value.</p>
     *
     * <pre>
     * import org.juicekit.query.methods.*;
     *
     * var data:Array = [
     *  {cat:"a", val:1}, {cat:"a", val:2}, {cat:"b", val:3}, {cat:"b", val:4},
     *  {cat:"c", val:5}, {cat:"c", val:6}, {cat:"d", val:7}, {cat:"d", val:8}
     * ];
     *
     * var r:Array = select("cat", {sum:sum("val")}) // sum of values
     *               .where(neq("cat", _("d"))       // exclude category "d"
     *               .groupby("cat")                 // group by category
     *               .eval(data);                    // evaluate with data array
     *
     * // r == [{cat:"a", sum:3}, {cat:"b", sum:7}, {cat:"c", sum:11}]
     * </pre>
     */
    public class Query extends DeferredProcessingBase
    {
        private var _select:Array;
        private var _orderby:Array;
        private var _groupby:Array;
        private var _where:Function;
        private var _wheres:Array = [];
        private var _sort:Sort;
        private var _aggrs:Array;
		private var _calculatedLiterals:Array;
        private var _map:Boolean = false;
        private var _update:Boolean = false;
        
        /**
         * Creates a new Query.
         * @param select an array of select clauses. A select clause consists
         *  of either a string representing the name of a variable to query or
         *  an object of the form <code>{name:expr}</code>, where
         *  <code>name</code> is the name of the query variable to include in
         *  query result objects and <code>expr</code> is an Expression for
         *  the actual query value. Expressions can be any legal expression,
         *  including aggregate operators.
         * @param where a where expression for filtering an object collection
         * @param orderby directives for sorting query results, using the
         *  format of the <code>flare.util.Sort</code> class methods.
         * @param groupby directives for grouping query results, using the
         *  format of the <code>flare.util.Sort</code> class methods.
         * @see flare.util.Sort
         */
        public function Query(select:Array = null, where:* = null,
                                    orderby:Array = null, groupby:Array = null)
        {
            if (select != null) setSelect(select);
            this.where(where);
            _orderby = orderby;
            _groupby = groupby;
        }
        
        // -- public methods --------------------------------------------------
        
        /**
         * Sets the select clauses used by this query. A select clause consists
         * of either a string representing the name of a variable to query or
         * an object of the form <code>{name:expr}</code>, where
         * <code>name</code> is the name of the query variable to include in
         * query result objects and <code>expr</code> is an
         * <code>Expression</code> for the actual query value.
         * <p>Calling the <code>select</code> method will overwrite the effect
         * of any previous calls to the <code>select</code> or
         * <code>update</code> methods.</p>
         * @param terms a list of query terms (select clauses). If the first
         *  element is an array, it will be used as the term list.
         * @return this query object
         */
        public function select(...terms):Query
        {
            if (terms.length > 0 && terms[0] is Array) {
                terms = terms[0];
            }
            setSelect(terms);
            _update = false;
            return this;
        }
        
        /**
         * Sets the select clauses used by this query to update the values
         * of the input set. An update clause consists of an object of the
         * form <code>{name:expr}</code>, where <code>name</code> is the name
         * of the data variable to set and <code>expr</code> is an
         * <code>Expression</code> for computing the value. When
         * <code>eval</code> is invoked for an update query, the values of the
         * input objects are updated and the returned result set is an array
         * containing these input objects.
         * <p>Calling the <code>update</code> method will overwrite the effect
         * of any previous calls to the <code>select</code> or
         * <code>update</code> methods.</p>
         * @param terms a list of query terms (update clauses). If the first
         *  element is an array, it will be used as the term list.
         * @return this query object
         */
        public function update(...terms):Query
        {
            if (terms == null || terms.length == 0) {
                throw new Error("Nothing to update!");
            } else if (terms[0] is Array) {
                terms = terms[0];
            }
            setSelect(terms);
            _update = true;
            return this;
        }
        
        
        /**
         * Sets the where clause (filter conditions) used by this query.
         * @param e the filter expression. This can be a string, a literal
         *  value, or an <code>Expression</code> instance. This input value
         *  will be run through the <code>Expression.expr</code> method.
         * @return this query object
         */
        public function where(e:*):Query
        {
            _where = Filter.$(e);
            if (_where != null) {
                _wheres.push(_where);
            }
            return this;
        }
        
        /**
         * Sets the sort order for query results.
         * @param terms the sort terms as a list of field names to sort on.
         *  By default, fields are sorted in ascending order. Add the prefix
         *  "-" (negative sign) to the field name to sort in descending order.
         * @return this query object
         */
        public function orderby(...terms):Query
        {
            _orderby = (terms.length > 0 ? terms : null);
            return this;
        }
        
        /**
         * Sets the group by terms for aggregate queries.
         * @param terms an ordered list of terms to group by.
         * @return this query object
         */
        public function groupby(...terms):Query
        {
            _groupby = (terms.length > 0 ? terms : null);
            return this;
        }
        
        
        /**
         * Sets whether or not aggregate functions will be mapped to all
         * tuples in the data set. This allows the results of aggregate
         * operators to be applied for all tuples. For example, the
         * <code>map</code> directive allows queries of this form:
         * <pre>
         * var q:Query = select({a:div(a,sum(a))}).map().eval(...);
         * </pre>
         * <p>The result include normalized <code>a</code> values for
         * all tuples in the input data. Without the map directive, a
         * "group-by" for all data would be assumed and only a single tuple
         * would be returned in the result set (matching the normal behavior
         * of a SQL database). Map can also be specified with a
         * group-by clause, in which case the aggregate operators will be
         * handled separately for each group, but the result set will still
         * contain a result for every tuple in the input set.</p>
         * <p>The map directive has no effect on "update" queries, which
         * already apply map semantics. It only effects "select" queries.</p>
         * @param value if true (the default), aggregate operators will be
         *  applied (mapped) to all tuples; if false, normal group-by semantics
         *  will be used.
         * @return this query object
         */
        public function map(value:Boolean = true):Query
        {
            _map = value;
            return this;
        }
        
        // -- helper methods --------------------------------------------------
        
        protected function setSelect(a:Array):void {
            _select = [];
            for each (var o:Object in a) {
                if (o is String) {
                    _select.push({
                        name: o as String,
                        expression: new Variable(o as String)
                    });
                } else {
                    for (var n:String in o) {
                        _select.push({
                            name: n,
                            expression: Expression.expr(o[n])
                        });
                    }
                }
            }
        }
        
        
        protected function sorter():Sort
        {
            var s:Array = [], i:int;
            if (_orderby != null) {
                for (i = 0; i < _orderby.length; ++i)
                    s.push(_orderby[i]);
            }
            return s.length == 0 ? null : new Sort(s);
        }
        
		
		protected function aggregates():Array
		{
			var aggrs:Array = [];
			for each (var pair:Object in _select) {
				var expr:Expression = pair.expression;
				expr.visit(function(e:Expression):void {
					if (e is AggregateExpression)
						aggrs.push(e);
				});
			}
			return aggrs.length == 0 ? null : aggrs;
		}
		
		
		protected function deferredLiterals():Array
		{
			var lits:Array = [];
			for each (var pair:Object in _select) {
				var expr:Expression = pair.expression;
				expr.visit(function(e:Expression):void {
					if (e is CalculatedLiteral)
						lits.push(e);
				});
			}
			return lits.length == 0 ? null : lits;
		}
		
        // -- query processing ------------------------------------------------
        
        /**
         * Evaluates this query on an object collection. The input argument can
         * either be an array of objects or a visitor function that takes
         * another function as input and applies it to all items in a
         * collection.
         * @param input either an array of objects or a visitor function
         * @param toClass an optional Class that results will be cast to
         * @return an array of processed query results
         */
        public function eval(input:*, toClass:Class=null, classCache:Array=null):Array
        {
            // check for initialization
            if (_sort == null) _sort = sorter();
			if (_aggrs == null) _aggrs = aggregates();
			if (_calculatedLiterals == null) _calculatedLiterals = deferredLiterals();
            
            // TODO -- evaluate any sub-queries in WHERE clause
            var results:Array = [];
			var cn:String = getQualifiedClassName(input);
            var visitor:Function;
            if (input is Array) {
                visitor = (input as Array).forEach;
			} else if (cn == '__AS3__.vec::Vector.<Object>') {
				visitor = input.forEach;
            } else if (input is Function) {
                visitor = input as Function;
            } else if (Object(input).hasOwnProperty("visit") &&
                Object(input).visit is Function) {
                visitor = Object(input).visit as Function;
            } else {
                throw new ArgumentError("Illegal input argument: " + input);
            }
            
            // collect and filter
            if (_wheres.length > 1) {
                visitor(function(item:Object, ...rest):void {
                    // making _where an Array
                    var result:Boolean = true;
                    for each (var wh:Function in _wheres) {
                        if (wh != null && wh(item) == false) {
                            result = false;
                            break;
                        }
                    }
                    if (result) results.push(item);
                });
            } else {
                if (_where != null) {
                    visitor(function(item:Object, ...rest):void {
                        if (_where(item)) results.push(item);
                    });
                } else {
                    visitor(function(item:Object, ...rest):void {
                        results.push(item);
                    });
                }
            }
            
            if (_select == null) {
            } else if (_update && _aggrs == null && _groupby == null) {
                results = applyAll(results);
            } else if (_aggrs == null && _groupby == null) {
                results = projectAll(results);
            } else {
                results = aggregate(results);
            }
            
            
            // ChrisG: Move the sort to the last action
            // sort the result set
            if (_sort != null) {
                _sort.sort(results);
            }
            
            if (toClass) {
                var Klass:Class = toClass;
                var klassProperties:Vector.<String> = new Vector.<String>();
                var prop:String;
                var hasKlassProperties:Boolean = false;
				var klassDescription:XML = describeType(Klass);
				var klassIsDynamic:Boolean = klassDescription..type.@isDynamic;				
                var klassResults:Array = [];
                var k:Object;
				var cacheLength:int = (classCache == null) ? 0 : classCache.length;
				var cnt:int = 0;
                for each (var row:Object in results) {
                    if (!hasKlassProperties) {
                        for (prop in row) {
                            k = new Klass();
							// If Klass is dynamic, add all properties and 
							// assume Klass will be able to handle them.
                            if (k.hasOwnProperty(prop) || klassIsDynamic) {
                                klassProperties.push(prop);
                            }                        
                        }
                    }
					
                    // copy properties over to the new object					
					if (cnt < cacheLength) {
						k = classCache[cnt];
					}
					else {
						k = new Klass();
					}

					for each (prop in klassProperties) {
						k[prop] = row[prop];                        
					}
                    klassResults.push(k);
					cnt += 1;
                    hasKlassProperties = true;
                }
                return klassResults;
            }
            else 
            {
                return results;
            }
        }
        
        
        /**
         * Perform an evaluation of the query with major parts
         * of the query split across several frames. This allows
         * for the UI to remain responsive but the Query will run
         * slower.
         */
        /*
        public function evalAsync(input:*):Array
        {
        }
        */
        
        
        protected function projectAll(results:Array):Array
        {
            for (var i:int = 0; i < results.length; ++i) {
                var item:Object = {};
                for each (var pair:Object in _select) {
                    var p:Property = Property.$(pair.name);
                    var expr:Expression = pair.expression;
                    p.setValue(item, expr.eval(results[i]));
                }
                results[i] = item;
            }
            return results;
        }
        
        protected function applyAll(results:Array):Array
        {
            var o:Object = {};
            for each (var item:Object in results) {
                for each (var pair:Object in _select) {
                    var name:String = pair.name;
                    var expr:Expression = pair.expression;
                    o[name] = expr.eval(item);
                }
                for each (pair in _select) {
                    name = pair.name;
                    var p:Property = Property.$(name);
                    p.setValue(item, o[name]);
                }
            }
            return results;
        }
        
        // -- group-by and aggregation ----------------------------------------
        
        private static function makeKey(props:Array, x:Object):String
        {
            var propVals:Array = []
            var a:*;
            for each (var p:Property in props) {
                a = p.getValue(x);
				if (a == null) 
					a = '__NULL__';
                propVals.push(a.toString());
            }
            return propVals.join('::');
        }
        
        
        
        /**
         * Performs grouping and aggregation of query results.
         * @param items the filtered query results array
         * @return aggregated query results array
         */
        protected function aggregate(items:Array):Array
        {
            var h:int, i:int, j:int, item:Object;
            var results:Array = [], props:Array = [];
            var lookup:Object = {};
            var key:String;
            
            // get group-by properties as key
            if (_groupby != null) {
                for (i = _groupby.length; --i >= 0;) {
                    if (_groupby[i] is String) {
                        props.push(Property.$(_groupby[i]));
                    }
                }
            }

			// Perform a summary query to set the values for calculatedLiterals
			if (_calculatedLiterals && _calculatedLiterals.length > 0) {
				var litSelect:Object = {};
				
				for (i = _calculatedLiterals.length; --i >= 0;) {
					var lit:CalculatedLiteral = _calculatedLiterals[i] as CalculatedLiteral;
					litSelect['v' + i] = lit.expr;
				}
				var litResults:Array = new Query([litSelect]).eval(items);
				if (litResults.length > 0) {
					var litResult:Object = litResults[0];
					for (i = _calculatedLiterals.length; --i >= 0;) {
						lit = _calculatedLiterals[i] as CalculatedLiteral;
						lit.value = litResult['v' + i];
					}
				}				
			}
            
            // process all groups
            reset(_aggrs);
            var aggrItem:AggrItem;
            var idx:int = 0;
            for each (item in items) {
                key = makeKey(props, item);
                if (!lookup.hasOwnProperty(key)) 
                {
                    lookup[key] = new AggrItem(aggregates(), item, idx);                                            
                } 
                else 
                {
                    aggrItem = lookup[key] as AggrItem;
                    aggrItem.items.push(item);
                    aggrItem.indices.push(idx);
                }
                idx += 1;
            }
            
            reset(_aggrs);
            for (key in lookup) {
                aggrItem = lookup[key] as AggrItem;
                for (i = 1,h = 0,item = aggrItem.items[0]; i <= aggrItem.items.length; ++i) {
                    // update the aggregate functions
                    for each (var aggr:AggregateExpression in _aggrs) {
                        aggr.aggregate(aggrItem.items[i - 1]);
                    }
                    
                    // handle change of group
                    if (i == aggrItem.items.length)
                    {
                        if (_update) {
                            for each (idx in aggrItem.indices) 
                                items[idx] = apply(items[idx]);   
                        } else if (_map) {
                            for each (idx in aggrItem.indices) {
                                items[idx] = project(items[idx]);   
                            } 
                        } else {
                            results.push(project(item));
                        }
                        reset(_aggrs);
                    }
                }
            }
            
            return (_update || _map ? items : results);
        }
        
        protected function reset(aggrs:Array):void
        {
            for each (var aggr:AggregateExpression in aggrs) {
                aggr.reset();
            }
        }
        
        protected function apply(item:Object):Object
        {
            var o:Object = {};
            for each (var pair:Object in _select) {
                var name:String = pair.name;
                var expr:Expression = pair.expression;
                o[name] = expr.eval(item);
            }
            for each (pair in _select) {
                name = pair.name;
                var p:Property = Property.$(name);
                p.setValue(item, o[name]);
            }
            return item;
        }
        
        protected function project(item:Object):Object
        {
            var result:Object = {};
            for each (var pair:Object in _select) {
                var p:Property = Property.$(pair.name);
                var expr:Expression = pair.expression;
                p.setValue(result, expr.eval(item));
            }
            return result;
        }
        
        private static function sameGroup(props:Array, x:Object, y:Object):Boolean
        {
            var a:*, b:*;
            for each (var p:Property in props) {
                a = p.getValue(x);
                b = p.getValue(y);
                
                if (a is Date && b is Date) {
                    if ((a as Date).time != (b as Date).time)
                        return false;
                } else if (a != b) {
                    return false;
                }
            }
            return true;
        }
        
        public function get dataSchema():DataSchema
        {
            // Calculate dataSchema
            var schema:DataSchema = new DataSchema();
            for each (var o:Object in _select) {
                var df:DataField = (o.expression as Expression).dataField.clone();
				var tempProps:DataField = df;
				while (!(tempProps.expression is Variable))
					tempProps = tempProps.expression.dataField;
				df.format = tempProps.format;
				df.type = tempProps.type;
				
                df.name = o.name;
                df.expression = new Variable(df.name);
                df.description = df.description;

                schema.addField(df);
            }
            for each (var grp:String in _groupby) {
                df = schema.getFieldByName(grp);
                if (df) {
                    df.isDimension = true;
                    df.isMetric = false;
                }
            }

            return schema;
        }
        
    } // end of class Query
}
import mx.utils.ObjectUtil;


/**
 * Helper class for doing aggregations.
 */
class AggrItem {
    
    public var aggrs:Array;
    public var items:Array;
    public var indices:Array;
    
    public function AggrItem(aggrs:Array, item:Object, idx:int) {
        this.aggrs = aggrs;
        this.items = [item];
        this.indices = [idx];
    }
}