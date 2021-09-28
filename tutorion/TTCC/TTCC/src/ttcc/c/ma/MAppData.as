// Project TTCC
package ttcc.c.ma {
	
	//{ =*^_^*= import
	import org.jinanoimateydragoncat.utils.flow.operations.Operation;
	import ttcc.Application;
	import ttcc.c.ae.AEApp;
	import ttcc.c.op.AO;
	import ttcc.c.op.d.OGetDataFromAppEnv;
	import ttcc.c.op.s.OGetAppComponentsCfgData;
	import ttcc.c.op.s.OGetPathsListAndUserData;
	import ttcc.d.a.ARO;
	//} =*^_^*= END OF import
	
	
	/**
	 * store & ctrl app data
	 * @author Jinanoimatey Dragoncat
	 * @version 0.0.0
	 * @created 05.06.2012 22:07
	 */
	public class MAppData extends AM {
		
		//{ =*^_^*= CONSTRUCTOR
		
		function MAppData (app:Application) {
			super(NAME);
			a=app;
		}
		//} =*^_^*= END OF CONSTRUCTOR
		
		
		public override function listen(eventType:String, details:Object):void {
			var r:ARO;
			switch (eventType) {
			
			case ID_A_GET_ENV_DATA:
				var o0:OGetDataFromAppEnv=new OGetDataFromAppEnv(el_o0, a.get_mainScreen().get_displayObject().stage);
				o0.startOperation();
				break;
			
			case ID_A_GET_PATHS_AND_USER_DATA:
				// get user data and paths from server
				var o1:OGetPathsListAndUserData=new OGetPathsListAndUserData(
					el_o1
					, a.get_httpXMLAdaptor()
					, a.get_ds().get_startupEnvData().get_settingsXML()
				);
				o1.startOperation();
				break;
				
			case ID_A_GET_APPLICATION_AND_COMPONENTS_CONFIG_DATA:
				// get user data and paths from server
				var o2:OGetAppComponentsCfgData=new OGetAppComponentsCfgData(
					el_o2
					, a.get_httpXMLAdaptor()
				);
				o2.startOperation();
				break;
				
			}
		}
		
		private function el_o0(o:Operation):void {
			switch (o.get_resultCode()) {
			
			case AO.OPERATION_RESULT_CODE_FAILURE:
				e.listen(ID_E_ENV_DATA, new ARO(null, null, ARO.ID_RESULT_CODE_FAILURE));
				break;
			
			case OGetDataFromAppEnv.OPERATION_RESULT_CODE_SUCCESS:
				e.listen(ID_E_ENV_DATA, new ARO(null, o.get_data(), ARO.ID_RESULT_CODE_SUCCESS));
				break;
				
			}
		}
		
		private function el_o1(o:Operation):void {
			switch (o.get_resultCode()) {
			case AO.OPERATION_RESULT_CODE_FAILURE:
				e.listen(ID_E_PATHS_AND_USER_DATA, new ARO(null, null, ARO.ID_RESULT_CODE_FAILURE));
				break;
			
			case OGetPathsListAndUserData.OPERATION_RESULT_CODE_SUCCESS:
				e.listen(ID_E_PATHS_AND_USER_DATA, new ARO(null, o.get_data(), ARO.ID_RESULT_CODE_SUCCESS));
				break;
				
			}
		}
		
		
		private function el_o2(o:Operation):void {
			switch (o.get_resultCode()) {
			case AO.OPERATION_RESULT_CODE_FAILURE:
				e.listen(ID_E_GET_APPLICATION_AND_COMPONENTS_CONFIG_DATA, new ARO(null, null, ARO.ID_RESULT_CODE_FAILURE));
				break;
			
			case OGetAppComponentsCfgData.OPERATION_RESULT_CODE_SUCCESS:
				e.listen(ID_E_GET_APPLICATION_AND_COMPONENTS_CONFIG_DATA, new ARO(null, o.get_data(), ARO.ID_RESULT_CODE_SUCCESS));
				break;
				
			}
		}
		
		
		
		
		//{ =*^_^*= private 
		private function get e():AEApp {return get_envRef();}
		private var a:Application;
		//} =*^_^*= END OF private
		
		//{ =*^_^*= id
		/**
		 * data:null
		 */
		public static const ID_A_GET_ENV_DATA:String=NAME+'>ID_A_GET_ENV_DATA';
		/**
		 * data:null
		 */
		public static const ID_A_GET_PATHS_AND_USER_DATA:String=NAME+'>ID_A_GET_PATHS_AND_USER_DATA';
		/**
		 * data:null
		 */
		public static const ID_A_GET_APPLICATION_AND_COMPONENTS_CONFIG_DATA:String=NAME+'>ID_A_GET_APPLICATION_AND_COMPONENTS_CONFIG_DATA';
		//} =*^_^*= END OF id
		
		//{ =*^_^*= events
		/**
		 * ARO:DUAppEnvData
		 */
		public static const ID_E_ENV_DATA:String=NAME+'>ID_E_ENV_DATA';
		/**
		 * ARO:DUApiAndStoragePaths
		 */
		public static const ID_E_PATHS_AND_USER_DATA:String=NAME+'>ID_E_PATHS_AND_USER_DATA';
		/**
		 * ARO:DUDUAppComponentsCfg
		 */
		public static const ID_E_GET_APPLICATION_AND_COMPONENTS_CONFIG_DATA:String=NAME+'>ID_E_GET_APPLICATION_AND_COMPONENTS_CONFIG_DATA';
		//} =*^_^*= END OF events
		
		public static const NAME:String = 'MAppData';
		
		public override function autoSubscribeEvents():Array {
			return [
				ID_A_GET_ENV_DATA
				,ID_A_GET_APPLICATION_AND_COMPONENTS_CONFIG_DATA
				,ID_A_GET_PATHS_AND_USER_DATA
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