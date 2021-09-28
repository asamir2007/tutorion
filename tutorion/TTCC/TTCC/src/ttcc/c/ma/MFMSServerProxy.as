// Project TTCC
package ttcc.c.ma {
	
	//{ =*^_^*= import
	import ttcc.c.ae.AEApp;
	import ttcc.d.a.ARO;
	import ttcc.d.dsp.DUApiAndStoragePaths;
	import ttcc.d.dsp.DUAppEnvData;
	import ttcc.LOG;
	import ttcc.LOGGER;
	import ttcc.n.connectors.NetConnector;
	//} =*^_^*= END OF import
	
	
	/**
	 * application(game) manager - ctrl ALL
	 * @author Jinanoimatey Dragoncat
	 * @version 0.0.0
	 * @created 28.05.2012 17:26
	 */
	public class MFMSServerProxy extends AM {
		
		//{ =*^_^*= CONSTRUCTOR
		
		function MFMSServerProxy () {
			super(NAME);
		}
		//} =*^_^*= END OF CONSTRUCTOR
		
		
		public override function listen(eventType:String, details:Object):void {
			var r:ARO;
			switch (eventType) {
			
			case ID_A_SETUP_CONNECTION:
				connectToFMS(details.duenv, details.dupaths, details.timeout, details.options);
				break;
				
			}
		}
		
		//{ =*^_^*= ID_A_SETUP_CONNECTION
		private function connectToFMS(duenv:DUAppEnvData, dupaths:DUApiAndStoragePaths, timeout:int, options:Object):void {
			if (!ncFMS) {
				ncFMS=new NetConnector;
				ncFMS.constuct(el_ncFMS);
			}
			if (!options) {options={};}
			
			log(5, '\n=======+++++++======\nconnecting to fms, arguments:\n'+[
				'url:'+dupaths.get_fmsRtmfpURL()+"/"+duenv.get_roomID()
				,'userid:'+duenv.get_userID()
				,'ession:'+duenv.get_sessionID()
				,'token:'+duenv.get_token()
				,LOGGER.traceObject(options)
				].join('\n'),0
			);
			
			ncFMS.connect(
				timeout
				,dupaths.get_fmsRtmfpURL()+"/"+duenv.get_roomID()
				,duenv.get_userID()
				,duenv.get_sessionID()
				,duenv.get_token()
				,options
			);
		}
		private function el_ncFMS(target:NetConnector, eventType:String, eventData:Object):void {
			switch (eventType) {
			
			case NetConnector.ID_E_SUCCESS:
				e.listen(ID_E_CONNECTION_ESTABLISHED, ncFMS);
				break;
				
			case NetConnector.ID_E_CLOSED:
			case NetConnector.ID_E_ER_FAILED:
			case NetConnector.ID_E_ER_REJECTED:
			case NetConnector.ID_E_ER_TIMED_OUT:
				e.listen(ID_E_CONNECTION_LOST, eventType);
				break;
			
			
			}
			//LOG(4, 'el_ncFMS>'+eventType+'/'+eventData);
		}
		//} =*^_^*= END OF ID_A_SETUP_CONNECTION
		
		
		//{ =*^_^*= private 
		private var ncFMS:NetConnector;
		private function get e():AEApp {return get_envRef();}
		//} =*^_^*= END OF private
		
		
		//{ =*^_^*= id
		/**
		 * data:{duenv:DUAppEnvData, dupaths:DUApiAndStoragePaths, timeout:int//connection timeout//, options:Object}
		 */
		public static const ID_A_SETUP_CONNECTION:String=NAME+'ID_A_SETUP_CONNECTION';
		//} =*^_^*= END OF id
		
		//{ =*^_^*= events
		/**
		 * data:NetConnector_event:String
		 */
		public static const ID_E_CONNECTION_LOST:String=NAME+'ID_E_CONNECTION_LOST';
		/**
		 * data:NetConnector
		 */
		public static const ID_E_CONNECTION_ESTABLISHED:String=NAME+'ID_E_CONNECTION_ESTABLISHED';
		//} =*^_^*= END OF events
		
		public static const NAME:String = 'MFMSServerProxy';
		
		public override function autoSubscribeEvents():Array {
			return [
				ID_A_SETUP_CONNECTION
			];
		}
		
	}
}

//{ =*^_^*= History
/* > (timestamp) [ ("+" (added) ) || ("-" (removed) ) || ("*" (modified) )] (text)
 * > 
 */
//} =*^_^*= END OF History

// template last modified:11.03.2011_[18#51#40]_[5]