// Project TTCC
package ttcc.c.ma {
	
	//{ =*^_^*= import
	import flash.display.Stage;
	import flash.display.StageDisplayState;
	import flash.system.Security;
	import flash.system.SecurityPanel;
	import ttcc.Application;
	import ttcc.c.ae.AEApp;
	//} =*^_^*= END OF import
	
	
	/**
	 * provides access to specific non-essential flash platform functionality
	 * @author Jinanoimatey Dragoncat
	 * @version 0.0.0
	 * @created 13.09.2012 20:12
	 */
	public class MFlashPlatform extends AM {
		
		//{ =*^_^*= CONSTRUCTOR
		
		function MFlashPlatform (app:Application) {
			super(NAME);
			a=app;
		}
		//} =*^_^*= END OF CONSTRUCTOR
		
		
		public override function listen(eventType:String, details:Object):void {
			switch (eventType) {
			
			case ID_A_TOGGLE_FULLSCREEN:
				var s:Stage=a.get_mainScreen().get_displayObject().stage;
				if (!s) {log(3, 'ID_A_TOGGLE_FULLSCREEN>stage is null',1);break;}
				s.displayState=((s.displayState!=StageDisplayState.FULL_SCREEN)?StageDisplayState.FULL_SCREEN:StageDisplayState.NORMAL);
				break;
			case ID_A_SHOW_SECURITY_SETTINGS_CAMERA:
				Security.showSettings(SecurityPanel.CAMERA);
				break;
			case ID_A_SHOW_SECURITY_SETTINGS_GENERAL:
				Security.showSettings(SecurityPanel.SETTINGS_MANAGER);
				break;
			
			}
		}
		
		//{ =*^_^*= actions
		public static const ID_A_SHOW_SECURITY_SETTINGS_CAMERA:String=NAME+'ID_A_SHOW_SECURITY_SETTINGS_CAMERA';
		public static const ID_A_SHOW_SECURITY_SETTINGS_GENERAL:String=NAME+'ID_A_SHOW_SECURITY_SETTINGS_GENERAL';
		public static const ID_A_TOGGLE_FULLSCREEN:String=NAME+'ID_A_TOGGLE_FULLSCREEN';
		//} =*^_^*= END OF actions
		
		//{ =*^_^*= events
		//} =*^_^*= END OF events
		
		private function get e():AEApp {return get_envRef();}
		private var a:Application;
		
		public static const NAME:String = 'MFlashPlatform';
		
		public override function autoSubscribeEvents():Array {
			return [
				ID_A_SHOW_SECURITY_SETTINGS_CAMERA
				,ID_A_SHOW_SECURITY_SETTINGS_GENERAL
				,ID_A_TOGGLE_FULLSCREEN
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