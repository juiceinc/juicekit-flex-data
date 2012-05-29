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
	import org.juicekit.util.Stats;

	/**
	 * Aggregate operator for computing the percentile a set of values.
	 */
	public class Percentile extends AggregateExpression
	{
		private var _percentile:Number;
		private var _collection:Array = [];
		private var _stats:Stats;
		
		/**
		 * Creates a new Maximum operator
		 * @param input the sub-expression of which to compute the percentile
		 * @param percentile a number between 0 and 1. 0 is the minimum, 1 is the maximum
		 */
		public function Percentile(input:*, percentile:Number=0.5) {
			_percentile = percentile;
			super(input);
		}
		
		/**
		 * @inheritDoc
		 */
		public override function eval(o:Object = null):*
		{
			_stats = new Stats(_collection);
			return _stats.getPercentile(_percentile);
		}
		
		/**
		 * @inheritDoc
		 */
		public override function reset():void
		{
			_collection = [];
		}
		
		/**
		 * @inheritDoc
		 */
		public override function aggregate(value:Object):void
		{
			var v:* = _expr.eval(value);
			if (v != null && !isNaN(v)) {
				_collection.push(v);
			}
		}
		
	} // end of class Percentile
}