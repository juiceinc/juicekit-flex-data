package org.juicekit {

  import mx.collections.ArrayCollection;
  import mx.utils.ObjectUtil;
  
  import org.flexunit.Assert;
  import org.juicekit.data.LiveQuery;
  import org.juicekit.query.methods.*;


  /**
  * Tests of LiveQuery
  */
  public class LiveQueryTest {

    public var liveQuery:LiveQuery;


    public var stateDataArray:Array = [
     {state: 'VA', cnt: 4, cnt2: 5},
     {state: 'VA', cnt: 3, cnt2: 6},
     {state: 'PA', cnt: 2, cnt2: 7},
     {state: 'PA', cnt: 1, cnt2: 8}
    ];


    /**
    * Test if a query returns result.
    */
    public var tests:Array = [
      { query: select(),
        result: [{}, {}, {}, {}] },
        
      { query: select('state').groupby('state'),
        result: [{state: 'PA'}, {state: 'VA'}] },
        
      { query: select('state', {sum: sum('cnt')}).groupby('state'),
        result: [{state: 'PA', sum: 3}, {state: 'VA', sum: 7}] },
        
      // can provide a single object and the result is the same
      { query: select({state: 'state',
                       sum: sum('cnt')}).groupby('state'),
        result: [{state: 'PA', sum: 3}, {state: 'VA', sum: 7}] },
        
      { query: select('state', {max: max('cnt')}).groupby('state'),
        result: [{state: 'PA', max: 2}, {state: 'VA', max: 4}] },

      { query: select('state', {value: min('cnt')}).groupby('state'),
        result: [{state: 'PA', value: 1}, {state: 'VA', value: 3}] },

      // weighted average
      { query: select('state', {value: wtdaverage('cnt','cnt2')}).groupby('state'),
        result: [{state: 'PA', value: (2*7+1*8)/(7+8)}, {state: 'VA', value: (4*5+3*6)/(5+6)}] },

      // percentage change from first value to second value
      // in terms of second value
      { query: select('state', {value: pctchange('cnt','cnt2')}).groupby('state'),
        result: [{state: 'PA', value: (3-15)/15}, {state: 'VA', value: (7-11)/11}] },

    ];


    /**
    * Test different results if the arrayCollection has been modified.
    * 
    * <p><code>resultPre</code> is the LiveQuery result prior to adding the items
    * in the <code>change</code> Array. <code>result</code> is the result
    * after the items are added.<p>
    */
    public var testChangeInput:Array = [
      { query: select(),
        change: [{'state': 'VT', cnt: 1, cnt2: 1}],
        resultPre: [{}, {}, {}, {}],
        result: [{}, {}, {}, {}, {}]
        },
        
      { query: select('state').groupby('state'),
        change: [{'state': 'VT', cnt: 1, cnt2: 1}],
        resultPre: [{state: 'PA'}, {state: 'VA'}],
        result: [{state: 'PA'}, {state: 'VA'}, {state: 'VT'}]
        },
        
      { query: select('state').groupby('state'),
        change: [{'state': 'PA', cnt: 1, cnt2: 1}],
        resultPre: [{state: 'PA'}, {state: 'VA'}],
        result: [{state: 'PA'}, {state: 'VA'}] 
        },
        
      { query: select('state', {sum: sum('cnt')}).groupby('state'),
        change: [{'state': 'PA', cnt: 1, cnt2: 1}],
        resultPre: [{state: 'PA', sum: 3}, {state: 'VA', sum: 7}],
        result: [{state: 'PA', sum: 4}, {state: 'VA', sum: 7}] 
        },

      { query: select('state', {max: max('cnt')}).groupby('state'),
        change: [{'state': 'PA', cnt: 10.5, cnt2: 1}],
        resultPre: [{state: 'PA', max: 2}, {state: 'VA', max: 4}], 
        result: [{state: 'PA', max: 10.5}, {state: 'VA', max: 4}] 
        },

    ];


    /**
    * Test each item in tests
    */
    [Test]
    public function liveQueryTests():void {
      for each (var test:Object in tests) {
        runBeforeEveryTest();
        liveQuery.query = test.query;
        var result:Array = liveQuery.result.source;
        var cmp:int = ObjectUtil.compare(result, test.result);
        Assert.assertEquals(
          0,
          cmp
        );
      }
    }
    

    /**
    * Tests of LiveQuery result before and after a change 
    * dataProvider.
    */
    [Test]
    public function liveQueryChangeTests():void {
      var result:Array;
      var cmp:int;
      
      for each (var test:Object in testChangeInput) {
        runBeforeEveryTest();
        liveQuery.query = test.query;

        // The result prior adding items from test.change
        result = liveQuery.result.source;
        cmp = ObjectUtil.compare(result, test.resultPre);
        Assert.assertEquals(
          0,
          cmp
        )

        // Add the items in change to the dataProvider
        if (test.hasOwnProperty('change')) {
          for each (var itm:Object in test.change) {
            liveQuery.dataProvider.addItem(itm);
          }
        }
        
        // Test the new result
        result = liveQuery.result.source;
        cmp = ObjectUtil.compare(result, test.result);
        Assert.assertEquals(
          0,
          cmp
        )
      }
    }


    /**
    * Set up the array collection and LiveQuery
    */
    [Before(order=1)]
    public function runBeforeEveryTest():void {
      liveQuery = new LiveQuery();
      var ac:ArrayCollection = new ArrayCollection();
      for each (var itm:Object in stateDataArray) {
        ac.addItem(itm);
      }
      liveQuery.dataProvider = ac;
      liveQuery.query = select('state', {sum: sum('cnt')}).groupby('state');
    }


    [After]
    public function runAfterEveryTest():void {
      liveQuery = null;
    }

  }

}