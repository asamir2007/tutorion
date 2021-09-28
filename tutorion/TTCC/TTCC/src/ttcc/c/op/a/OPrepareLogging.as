// Project TTCC
package ttcc.c.op.a {
	
	//{ =*^_^*= import
	import org.jinanoimateydragoncat.utils.flow.operations.Operation;
	import ttcc.Application;
	import ttcc.c.op.AO;
	import ttcc.LOG;
	import ttcc.n.connectors.NetConnector;
	import ttcc.n.loaders.XMLDataRequest;
	//} =*^_^*= END OF import
	
	
	/**
	 * 
	 * @author Jinanoimatey Dragoncat
	 * @version 0.0.0
	 * @created 20.01.2012 20:33
	 */
	public class OPrepareLogging extends AO {
		
		//{ =*^_^*= CONSTRUCTOR
		
		function OPrepareLogging (onComplete:Function, applicationRef:Application) {
			super(null, NAME, onComplete);
			//set_warningResultCode(OPERATION_RESULT_CODE_FAILURE);	
			appRef=applicationRef;
		}
		//} =*^_^*= END OF CONSTRUCTOR
		
		protected override function start():void {
			NetConnector.set_loggerRef(log_NetncFMS);
			XMLDataRequest.set_showXMLDataRequestMessages(false);
			
			end(OPERATION_RESULT_CODE_SUCCESS);
		}
		
		private function log_NetncFMS(msg:String, level:uint):void {
			LOG(5, 'NetncFMS>'+msg, level);
		}
		
		
		
		private var appRef:Application;
		
		//{ =*^_^*= =*^_^*= ID
		/**
		 * data:
		 */
		//public static const OPERATION_RESULT_CODE_SUCCESS:uint = 0;
		/**
		 * data:
		 */
		//public static const OPERATION_RESULT_CODE_FAILURE:uint = 1;
		
		/*protected override function getResultCodeDescription(resultCode:uint):String {
			return ['success', 'failure'][resultCode];
		}*/
		
		//} =*^_^*= =*^_^*= END OF ID
		
		public static const NAME:String='OPrepareLogging';
		
	}
}

//{ =*^_^*= History
/* > (timestamp) [ ("+" (added) ) || ("-" (removed) ) || ("*" (modified) )] (text)
 * > 
 */
//} =*^_^*= END OF History

// template last modified:11.03.2011_[18#51#40]_[5]