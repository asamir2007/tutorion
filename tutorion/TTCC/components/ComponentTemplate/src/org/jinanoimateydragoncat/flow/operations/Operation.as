package org.jinanoimateydragoncat.utils.flow.operations {
	
	
	//{ =*^_^*= import
	import org.jinanoimateydragoncat.utils.Logger;
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
		 * @param onComplete function (op:Operation):Boolean=execute next operation; if onComplete==null next operation will be executed.
		 * @param nextOperation
		 */
		function Operation (args:Object, name:String, onComplete:Function=null, nextOperation:Operation=null) {
			this.OPERATION_NAME = name;
			this.onComplete = onComplete;
			this.nextOperation = nextOperation;
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
		public function set_nextOperation(operation:Operation):void {nextOperation = operation;}
		
		public function startOperation(previousOperation:Operation=null):void {
			log(OPERATION_NAME+'" has been started.');
			start(previousOperation);
		}
		
		
		protected function start(previousOperation:Operation=null):void {
			// override and place your code here
		}
		
		protected function getResultCodeDescription(resultCode:uint):String {
			// override and place your code here
			return 'no description for resultCode #'+resultCode;
		}
		
		/**
		 * information about operation ending with result code code willbe highlighted in logger as warning
		 * @param code
		 */
		protected final function set_warningResultCode(code:uint):void {
			warningResultCode = code;
		}
		
		
		/**
		 * call this method after operation is completed.
		 */
		protected final function end(resultCode:uint):void {
			log(OPERATION_NAME+'" has been completed. Result:'+getResultCodeDescription(resultCode),(warningResultCode==resultCode)?Logger.LEVEL_WARNING:Logger.LEVEL_INFO);
			this.resultCode = resultCode;
			if (onComplete!=null) {
				if (!onComplete(this)) {return;}
			}
			
			if (nextOperation!=null) {nextOperation.startOperation(this);}
		}
		
		protected var data:Object;
		protected var args:Object;
		
		private var warningResultCode:uint=uint.MAX_VALUE;
		private var resultCode:uint;
		private var OPERATION_NAME:String;
		private var onComplete:Function;
		private var nextOperation:Operation;
		
		//{logging
		public static var debugMode:Boolean = false;
		
		public static function setLogger(logger:Logger):void {Operation.logger = logger;}
		
		protected final function log(message:String, level:uint=Logger.LEVEL_INFO, forceAddTimeStamp:Boolean=false):void {
			if (debugMode) {
				if (logger==null) {throw new Error(OPERATION_NAME+'::log()>logger is null.');}
				logger.log(OPERATION_NAME+'>'+message, level, forceAddTimeStamp);
			}
		}
		private static var logger:Logger;
		//}
	}
}