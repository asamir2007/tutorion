// Project TTCC
package ttcc.c.op {
	
	//{ =*^_^*= import
	import org.jinanoimateydragoncat.utils.flow.operations.Operation;
	//} =*^_^*= END OF import
	
	
	/**
	 * Abstract Operation
	 * @author Jinanoimatey Dragoncat
	 * @version 0.0.0
	 * @created 26.05.2012_02#54#22
	 */
	public class AO extends Operation {
		
		//{ =*^_^*= CONSTRUCTOR
		
		function AO (args:Object, name:String, onComplete:Function=null) {
			super(args, name, onComplete);
			set_warningResultCode(1);
		}
		//} =*^_^*= END OF CONSTRUCTOR
		
		protected override function getResultCodeDescription(resultCode:uint):String {
			return ['success', 'failure'][resultCode];
		}
		
		/**
		 * data:
		 */
		public static const OPERATION_RESULT_CODE_SUCCESS:uint = 0;
		/**
		 * data:
		 */
		public static const OPERATION_RESULT_CODE_FAILURE:uint = 1;
		
	}
}

//{ =*^_^*= History
/* > (timestamp) [ ("+" (added) ) || ("-" (removed) ) || ("*" (modified) )] (text)
 * > 
 */
//} =*^_^*= END OF History

// template last modified:11.03.2011_[18#51#40]_[5]