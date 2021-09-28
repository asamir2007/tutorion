// Project TTCC
package ttcc.d.a {
	
	//{ =*^_^*= import
	//} =*^_^*= END OF import
	
	
	/**
	 * AgentResponceObject
	 * @author Jinanoimatey Dragoncat
	 * @version 0.0.0
	 * @created 26.05.2012_02#54#22
	 */
	public class ARO {
		
		//{ =*^_^*= CONSTRUCTOR
		
		/**
		 * 
		 * @param	args
		 * @param	result
		 * @param	resultCode
		 */
		function ARO (args:Object, result:Object, resultCode:uint=0) {
			this.in_=args;
			this.out_=result;
			this.rc=resultCode;
		}
		//} =*^_^*= END OF CONSTRUCTOR
		
		/**
		 * data passed as argument upon method call(event dispatch)
		 */
		public function get_args():Object {return in_;}
		/**
		 * result data or error details
		 */
		public function get_result():Object {return out_;}
		/**
		 * operation result code(if any)
		 */
		public function get_code():uint {return rc;}
		
		public static const ID_RESULT_CODE_SUCCESS:uint=0;
		public static const ID_RESULT_CODE_FAILURE:uint=1;
		
		private var in_:Object;
		private var out_:Object;
		private var rc:uint;
		
	}
}

//{ =*^_^*= History
/* > (timestamp) [ ("+" (added) ) || ("-" (removed) ) || ("*" (modified) )] (text)
 * > 
 */
//} =*^_^*= END OF History

// template last modified:11.03.2011_[18#51#40]_[5]