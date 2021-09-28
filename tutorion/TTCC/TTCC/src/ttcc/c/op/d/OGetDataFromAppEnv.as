// Project TTCC
package ttcc.c.op.d {
	
	//{ =*^_^*= import
	import flash.display.Stage;
	import flash.external.ExternalInterface;
	import ttcc.c.op.AO;
	import ttcc.d.dsp.DUAppEnvData;
	import ttcc.LOGGER;
	//} =*^_^*= END OF import
	
	
	/**
	 * 
	 * @author Jinanoimatey Dragoncat
	 * @version 0.0.0
	 * @created 26.05.2012_02#52#42
	 */
	public class OGetDataFromAppEnv extends AO {
		
		//{ =*^_^*= CONSTRUCTOR
		
		function OGetDataFromAppEnv (onComplete:Function, stageRef:Stage) {
			super(null, NAME, onComplete);
			this.stageRef=stageRef;
		}
		//} =*^_^*= END OF CONSTRUCTOR
		
		protected override function start():void {
				log('getFromExternalInterface()', 0);
			// TODO: недопустимо: инкапсулировать в браузере
			// TODO: it is inadmissible, all inquiries to browser must be incapsulated by JS(java script^_^)
			try {
				var swfPageURL:String=ExternalInterface.call("document.location.href.toString");
			} catch (e:Error) {
				log(LOGGER.traceObject(e), 2);
				//fscommand('quit');
				end(OPERATION_RESULT_CODE_FAILURE);
			}
			if (!stageRef||!stageRef.loaderInfo.parameters) {
				log('!stageRef||!stageRef.loaderInfo.parameters',2);
				end(OPERATION_RESULT_CODE_FAILURE);
			}
			
			data=new DUAppEnvData();
			var p:Object=stageRef.loaderInfo.parameters;
			
			DUAppEnvData(data).construct(
				swfPageURL
				,p.req_url
				,p.user_id
				,p.room_id
				,p.con_id
				,p.token
				,p.settingsXML
				,p.rep
			);
			end(OPERATION_RESULT_CODE_SUCCESS);
		}
		
		private var stageRef:Stage;
		
		//{ =*^_^*= =*^_^*= ID
		/**
		 * data:DUAppEnvData
		 */
		public static const OPERATION_RESULT_CODE_SUCCESS:uint=0;
		//} =*^_^*= =*^_^*= END OF ID
		
		public static const NAME:String='OGetDataFromAppEnv';
		
	}
}

//{ =*^_^*= History
/* > (timestamp) [ ("+" (added) ) || ("-" (removed) ) || ("*" (modified) )] (text)
 * > 
 */
//} =*^_^*= END OF History

// template last modified:11.03.2011_[18#51#40]_[5]