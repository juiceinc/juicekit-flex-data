package org.juicekit
{

	[Suite]
	[RunWith("org.flexunit.runners.Suite")]
	public class QueryTestSuite
	{
		public var expressionTests:ExpressionTests;
		public var dlcTests:DelimitedTextConverterTest;
		public var dataIOTests:DataIOTests;
	}
}