
package org.juicekit.query.methods
{
	import org.juicekit.query.Arithmetic;
	
	/**
	 * Creates a new <code>Arithmetic</code> query operator.
	 *
	 * This evaluates <code>pcttotal(newval) - pcttotal(oldval)</code>
	 *
	 * @param newval a value expression
	 * @param oldval a value expression
	 * @return the new query operator
	 */
	public function sharechange(oldval:*, newval:*):Arithmetic
	{
		return Arithmetic.Subtract(pcttotal(newval), pcttotal(oldval));
	}
}