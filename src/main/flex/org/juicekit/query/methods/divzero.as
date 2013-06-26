/** 2013 Chris Gemignani, Juice Inc. */

package org.juicekit.query.methods
{
	import org.juicekit.query.Arithmetic;
	
	/**
	 * Creates a new division <code>Arithmetic</code> query operator.
	 * @param a the left side argument.
	 *  This value can be an expression or a literal value.
	 *  Literal values are parsed using the Expression.expr method.
	 * @param b the right side argument
	 *  This value can be an expression or a literal value.
	 *  Literal values are parsed using the Expression.expr method.
	 * @return the new query operator
	 */
	public function divzero(a:*, b:*):Arithmetic
	{
		return Arithmetic.DivideZero(a, b);
	}
}