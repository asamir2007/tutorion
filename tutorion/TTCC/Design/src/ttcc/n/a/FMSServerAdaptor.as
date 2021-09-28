// Project Connect
package ttcc.n.a {
	
	//{ =*^_^*= import
	import flash.net.Responder;
	import ttcc.LOG;
	import ttcc.n.connectors.NetConnector;
	//} =*^_^*= END OF import
	
	
	/**
	 * calls a command or method on Server 
	 * @author Jinanoimatey Dragoncat
	 * @version 0.0.0
	 * @created 23.05.2012 22:42
	 */
	public class FMSServerAdaptor {
		
		//{ =*^_^*= CONSTRUCTOR
		function FMSServerAdaptor () {}
		/**
		 * 
		 * @param	eventListener function(target:FMSServerAdaptor, eventType:String, eventData:Object):void
		 */
		public function construct(eventListener:Function, nc:NetConnector):void {
			//if (eventListener==null) {throw new ArgumentError('eventListener==null');}
			//if (nc==null) {throw new ArgumentError('nc==null');}
			
			//this.nc=nc;
			//el=eventListener;
			
			//ncR=new Responder(el_ncR_Result, el_ncR_Status);
		}
		public function destruct():void {
		}
		//} =*^_^*= END OF CONSTRUCTOR
		
		//{ =*^_^*= user access
		/**
		 * @param	commandName
		 * @param	commandArgs
		 * @param	responder if null, builtin responder will be used
		 */
		public function call(commandName:String, commandArgs:Array, responder:Responder=null):void {
			// check whether still connected
			if (!nc.connected) {
				el(this, ID_E_ERR_NC_NOT_CONNECTED, null);
				return;
			}
			if (!commandArgs) {commandArgs=[];}
			var aa:Array=commandArgs.slice()
			aa.unshift(commandName, (responder!=null)?responder:ncR);
			nc.call.apply(nc, aa);
		}
		//} =*^_^*= END OF user access
		
		
		private function el_ncR_Result(a:Object):void{
			if (a.toString().toLowerCase() == NC_RESULT_SUCCESS) {
				el(this, ID_E_RESULT_SUCCESS, a);
			} else {
				el(this, ID_E_ERR_RESULT_ERROR, a);
			}
		}
		private function el_ncR_Status(a:Object):void {
			el(this, ID_E_ERR_STATUS_ERROR, a);
		}
		
		//{ =*^_^*= id
		public static const ID_E_ERR_NC_NOT_CONNECTED:String='ID_E_ERR_NC_NOT_CONNECTED';
		/**
		 * data: additional error information from server
		 */
		public static const ID_E_ERR_RESULT_ERROR:String='ID_E_ERR_RESULT_ERROR';
		/**
		 * data: additional error information from server
		 */
		public static const ID_E_RESULT_SUCCESS:String='ID_E_RESULT_SUCCESS';
		/**
		 * data: additional error information from server
		 */
		public static const ID_E_ERR_STATUS_ERROR:String='ID_E_ERR_STATUS_ERROR';
		/**
		 * data: {n:String, a:Array}; n-command name, a-command arguments
		 */
		//public static const ID_E_NC_CALL:String='ID_E_NC_CALL';
		
		private static const NC_RESULT_SUCCESS:String='ok';// TODO: PRIORITY:LOW ^maybe should move this constant to SP?
		//} =*^_^*= END OF id
		
		
		//{ =*^_^*= events
		//public function setListener(a:Function):void {el=a;}
		private var el:Function;
		//} =*^_^*= END OF events
		
		//{ =*^_^*= private 
		private var nc:NetConnector;
		private var ncR:Responder;
		//} =*^_^*= END OF private
	}
}

//{ =*^_^*= History
/* > (timestamp) [ ("+" (added) ) || ("-" (removed) ) || ("*" (modified) )] (text)
 * > 
 */
//} =*^_^*= END OF History

// template last modified:11.03.2011_[18#51#40]_[5]