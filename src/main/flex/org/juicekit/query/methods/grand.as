
package org.juicekit.query.methods
{
	import org.juicekit.query.CalculatedLiteral;
	
	/**
	 * Returns a new <code>DeferredLiteral</code> operator.
	 * @param the input object
	 * @return the new DeferredLiteral expression
	 */
	public function grand(a:*):CalculatedLiteral
	{
		return new CalculatedLiteral(sum(a));
	}
}