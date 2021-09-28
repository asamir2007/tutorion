package org.jinanoimateydragoncat.utils.flow.operations {
	
	
	//{ =*^_^*= import
	//} =*^_^*= END OF import
	
	/**
	 * 
	 * @author Jinanoimatey Dragoncat
	 * @version 0.0.0
	 */
	public class Operation {
		
		//{ =^_^= CONSTRUCTOR
		
		/**
		 * 
		 * @param args operation arguments (used to store arbitrary data)
		 * @param name 
		 * @param onComplete function (op:Operation):void;
		 */
		function Operation (args:Object, name:String, onComplete:Function=null) {
			this.OPERATION_NAME = name;
			this.onComplete = onComplete;
			this.args = args;
		}
		//} =^_^= END OF CONSTRUCTOR
		
		public function get_onComplete():Function {return onComplete;}
		public function get_data():Object {return data;}
		public function get_args():Object {return args;}
		/**
		 * depends on operation(for example OperationA.RESULT_CODE_SUCCESS or OperationA.RESULT_CODE_FAILURE)
		 * @return
		 */
		public function get_resultCode():uint {return resultCode;}
		public function get_name():String {return OPERATION_NAME;}
		
		public function startOperation():void {
			log(OPERATION_NAME+'" has been started.');
			start();
		}
		
		
		protected function start():void {
			// override and place your code here
		}
		
		protected function getResultCodeDescription(resultCode:uint):String {
			// override and place your code here
			return 'no description for resultCode #'+resultCode;
		}
		
		/**
		 * information about operation ending with result code that >= code willbe highlighted in logger as warning
		 * @param code
		 */
		protected final function set_warningResultCode(code:uint):void {
			warningResultCode = code;
		}
		
		
		/**
		 * call this method after operation is completed.
		 */
		protected final function end(resultCode:uint):void {
			log(OPERATION_NAME+'" has been completed. Result:'+getResultCodeDescription(resultCode), (resultCode>=warningResultCode)?LOGGER_LEVEL_WARNING:LOGGER_LEVEL_INFO);
			this.resultCode = resultCode;
			if (onComplete!=null) {onComplete(this)}
		}
		
		protected var data:Object;
		protected var args:Object;
		
		private var warningResultCode:uint=uint.MAX_VALUE;
		private var resultCode:uint;
		private var OPERATION_NAME:String;
		private var onComplete:Function;
		
		//{ =*^_^*= logging new
		public static const LOGGER_LEVEL_INFO:uint=0;
		public static const LOGGER_LEVEL_WARNING:uint=1;
		public static const LOGGER_LEVEL_ERROR:uint=2;
		/**
		* @param	m msg
		* @param	l level constants
		*/
		protected final function log(m:String, l:int=0):void {
			if (i==null) {return;}
			i(OPERATION_NAME+'>'+m, l);
		}
		
		/**
		 * function (m:String, l:uint):void;//message, level
		 */
		public static function setL(a:Function):void {i=a;}
		/**
		 * logger method ref
		 */
		private static var i:Function;
		//} =*^_^*= END OF logging new
		
	}
}

//{ =*^_^*= History
/* > (timestamp) [ ("+" (added) ) || ("-" (removed) ) || ("*" (modified) )] (text)
 * > 25.05.2012_23#10#01 + new logging system
 * > 25.05.2012_23#34#55 - nextOperation
 * > 
 */
//} =*^_^*= END OF History

// template last modified:11.03.2011_[18#51#40]_[5]