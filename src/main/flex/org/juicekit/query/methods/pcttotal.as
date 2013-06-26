
package org.juicekit.query.methods
{
	import org.juicekit.query.Arithmetic;
	import org.juicekit.query.Sum;
	
	/**
	 * Creates a new <code>Arithmetic</code> query operator.
	 *
	 * This evaluates <code>(val) / grand total of val</code>
	 *
	 * @param val a value expression
	 * @return the new query operator
	 */
	public function pcttotal(val:*):Arithmetic
	{		
		return Arithmetic.DivideZero(sum(val), grand(val));
	}
	
	
}