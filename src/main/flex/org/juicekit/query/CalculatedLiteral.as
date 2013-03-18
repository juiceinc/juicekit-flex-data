package org.juicekit.query
{
	/**
	 * A Literal that gets a value by evaluting expression against
	 * all items at eval time.
	 * 
	 * Used for calculating % of grand totals.
	 */
	public class CalculatedLiteral extends Literal
	{
		public var expr:Expression;
		
		public function CalculatedLiteral(o:*)
		{
			expr = Expression.expr(o);	
			super(0);
		}
	}
}