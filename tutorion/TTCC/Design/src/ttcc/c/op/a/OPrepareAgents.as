// Project TTCC
package ttcc.c.op.a {
	
	//{ =*^_^*= import
	import org.jinanoimateydragoncat.utils.flow.operations.Operation;
	import ttcc.Application;
	import ttcc.c.ae.AEApp;
	import ttcc.c.ae.AER;
	import ttcc.c.ae.DE;
	import ttcc.c.ma.ac.MACChat;
	import ttcc.c.ma.ac.MACMP;
	import ttcc.c.ma.MApp;
	import ttcc.c.ma.ac.MAPPComponents;
	import ttcc.c.ma.MAppData;
	import ttcc.c.ma.MAppStartup;
	import ttcc.c.ma.MChat;
	import ttcc.c.ma.MFlashPlatform;
	import ttcc.c.ma.MFMSServerProxy;
	import ttcc.c.ma.MServerMonitor;
	import ttcc.c.ma.MUIActions;
	import ttcc.c.ma.MUserData;
	import ttcc.c.vcm.VCMChat;
	import ttcc.c.vcm.VCMCourseLoader;
	import ttcc.c.vcm.VCMMainPanel;
	import ttcc.c.vcm.VCMMainScreen;
	import ttcc.c.op.AO;
	import ttcc.c.vcm.VCMPresentationLoader;
	//} =*^_^*= END OF import
	
	
	/**
	 * 
	 * @author Jinanoimatey Dragoncat
	 * @version 0.0.0
	 * @created 26.05.2012_02#54#22
	 */
	public class OPrepareAgents extends AO {
		
		//{ =*^_^*= CONSTRUCTOR
		
		function OPrepareAgents (onComplete:Function, applicationRef:Application) {
			super(null, NAME, onComplete);
			appRef=applicationRef;
		}
		//} =*^_^*= END OF CONSTRUCTOR
		
		protected override function start():void {
			appRef.set_de(new DE());
			
			appRef.set_ae(new AEApp());
			appRef.set_aer(new AER());
			//app platform
			appRef.get_ae().placeAgent(new MAppStartup(appRef));
			appRef.get_ae().placeAgent(new MFlashPlatform(appRef));
			appRef.get_ae().placeAgent(new MApp(appRef));
			appRef.get_ae().placeAgent(new MUIActions(appRef));
			appRef.get_ae().placeAgent(new MAppData(appRef));
			appRef.get_ae().placeAgent(new MUserData(appRef));
			appRef.get_ae().placeAgent(new MFMSServerProxy());
			
			appRef.get_ae().placeAgent(new MServerMonitor(appRef));
			
			
			appRef.get_ae().placeAgent(new VCMMainScreen(appRef));
			
			
			//APPComponents manager
			appRef.get_ae().placeAgent(new MAPPComponents(appRef, appRef.getComponentsList()));
			//APPComponents 
			// TODO: remove from here
			
			//appRef.get_ae().placeAgent(new VCMCourseLoader());
			
			
			end(AO.OPERATION_RESULT_CODE_SUCCESS);
		}
		
		private var appRef:Application;
		
		//{ =*^_^*= =*^_^*= ID
		//} =*^_^*= =*^_^*= END OF ID
		
		public static const NAME:String='OPrepareAgents';
		
	}
}

//{ =*^_^*= History
/* > (timestamp) [ ("+" (added) ) || ("-" (removed) ) || ("*" (modified) )] (text)
 * > 
 */
//} =*^_^*= END OF History

// template last modified:11.03.2011_[18#51#40]_[5]