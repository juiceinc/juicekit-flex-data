package org.juicekit {

  import flexunit.framework.TestCase;
  
  import mx.utils.ObjectUtil;
  
  import org.juicekit.data.converter.DelimitedTextConverter;
  import org.juicekit.data.model.DataField;
  import org.juicekit.data.model.DataSchema;
  import org.juicekit.query.methods.*;
  import org.juicekit.util.DataUtil;

  public class DelimitedTextConverterTest extends TestCase {

    public function testDLCCommas():void {
      var s:String = 'a,b,c\n1,2,3\n3,4,5'
      var dtc:DelimitedTextConverter = new DelimitedTextConverter(',');
      var results:Array = dtc.parse(s).nodes.data;
      assertEquals(2, results.length);
      assertEquals(ObjectUtil.compare([{a: 1, b: 2, c: 3}, {a: 3, b: 4, c: 5}], results), 0)
    }


    public function testDLCEmbeddedComma():void {
      var s:String = 'a,b,c\n1,"2,3",3\n3,4,5'
      var dtc:DelimitedTextConverter = new DelimitedTextConverter(',');
      var results:Array = dtc.parse(s).nodes.data;
      assertEquals(2, results.length);
      assertEquals(ObjectUtil.compare([{a: 1, b: "2,3", c: 3}, {a: 3, b: "4", c: 5}], results), 0)
    }


    public function testDLCEmbeddedNewlineComma():void {
      var s:String = 'a,b,c\n1,"2,\n3",3\n3,4,5'
      var dtc:DelimitedTextConverter = new DelimitedTextConverter(',');
      var results:Array = dtc.parse(s).nodes.data;
      assertEquals(2, results.length);
      assertEquals(ObjectUtil.compare([{a: 1, b: "2,\n3", c: 3}, {a: 3, b: "4", c: 5}], results), 0)
    }


    public function testDLCWikipediaExample():void {
      //http://en.wikipedia.org/wiki/Comma-separated_values
      var s:String = 'year,make,model,features,price\n1997,Ford,E350,"ac, abs, moon",3000.00\n1999,Chevy,"Venture ""Extended Edition""","",4900.00\n1996,Jeep,Grand Cherokee,"MUST SELL!\nair, moon roof, loaded",4799.00';
      var dtc:DelimitedTextConverter = new DelimitedTextConverter(',');
      var results:Array = dtc.parse(s).nodes.data;
      assertEquals(3, results.length);
      assertEquals(ObjectUtil.compare({year: 1997, make: "Ford", model: 'E350', features: 'ac, abs, moon', price: 3000}, results[0]), 0);
      assertEquals(ObjectUtil.compare({year: 1999, make: "Chevy", model: 'Venture "Extended Edition"', features: '', price: 4900}, results[1]), 0);
      assertEquals(ObjectUtil.compare({year: 1996, make: "Jeep", model: 'Grand Cherokee', features: 'MUST SELL!\nair, moon roof, loaded', price: 4799}, results[2]), 0);
    }


    public function testDLCEmbeddedDoubleQuoteComma():void {
      var s:String = 'a,b,c\n1,"""2,3""",3\n3,4,5'
      var dtc:DelimitedTextConverter = new DelimitedTextConverter(',');
      var results:Array = dtc.parse(s).nodes.data;
      assertEquals(2, results.length);
      assertEquals(ObjectUtil.compare([{a: 1, b: '"2,3"', c: 3}, {a: 3, b: "4", c: 5}], results), 0)
    }


    public function testDLCEmbeddedDoubleQuoteComma2():void {
      var s:String = 'a,b,c\n1,2,3"",3\n3,4,5'
      var dtc:DelimitedTextConverter = new DelimitedTextConverter(',');
      var results:Array = dtc.parse(s).nodes.data;
      assertEquals(2, results.length);
      assertEquals(ObjectUtil.compare([{a: 1, b: 2, c: '3"'}, {a: 3, b: 4, c: "5"}], results), 0)
    }

    public function testDLCTabs():void {
      var s:String = 'a\tb\tc\n1\t2\t3\n3\t4\t5'
      var dtc:DelimitedTextConverter = new DelimitedTextConverter('\t');
      var results:Array = dtc.parse(s).nodes.data;
      assertEquals(2, results.length);
      assertEquals(ObjectUtil.compare([{a: 1, b: 2, c: 3}, {a: 3, b: 4, c: 5}], results), 0)
    }

    public function testDLCBars():void {
      var s:String = 'a|b|c\n1|2|3\n3|4|5'
      var dtc:DelimitedTextConverter = new DelimitedTextConverter('|');
      var results:Array = dtc.parse(s).nodes.data;
      assertEquals(2, results.length);
      assertEquals(ObjectUtil.compare([{a: 1, b: 2, c: 3}, {a: 3, b: 4, c: 5}], results), 0)
    }

    /**
     * Test where the rows don't all contain values
     */
    public function testDLCUneven():void {
      var s:String = 'a|b|c\n1|2|3\n3|4'
      var dtc:DelimitedTextConverter = new DelimitedTextConverter('|');

      var results:Array = dtc.parse(s).nodes.data;
      assertEquals(2, results.length);
      assertEquals(ObjectUtil.compare([{a: 1, b: 2, c: 3}, {a: 3, b: 4, c: 0}], results), 0)
    }

    /**
     * Test overriding the schema
     */
    public function testDLSchema():void {
      var s:String = 'a|b|c\n1|2|3\n3|4|'
      var dtc:DelimitedTextConverter = new DelimitedTextConverter('|');

      var schema:DataSchema = new DataSchema(new DataField('astr', DataUtil.STRING, 'none', null, '0', '0'), new DataField('b', DataUtil.INT, 0, null, '0', '0'), new DataField('c', DataUtil.INT, -1, null, '0', '0'));
      schema.hasHeader = true;
//     DataField
//		 * @param name the name of the data field
//		 * @param type the data type of this field
//		 * @param def the default value of this field
//		 * @param id a unique id for the field. If null, the name will be used
//		 * @param format a formatting string for printing values of this field
//		 * @param label a label describing this data field

      var results:Array = dtc.parse(s, schema).nodes.data;
      assertEquals(2, results.length);
      assertEquals(ObjectUtil.compare([{astr: '1', b: 2, c: 3}, {astr: '3', b: 4, c: 0}], results), 0)
    }

  }
}