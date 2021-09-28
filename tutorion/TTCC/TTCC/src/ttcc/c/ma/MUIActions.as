// Project TTCC
package ttcc.c.ma {
	
	//{ =*^_^*= import
	import ttcc.Application;
	import ttcc.c.ae.AEApp;
	import ttcc.c.ma.ac.MACAV;
	import ttcc.c.ma.ac.MACChat;
	import ttcc.c.ma.ac.MACConsole;
	import ttcc.c.ma.ac.MACCourseLoader;
	import ttcc.c.ma.ac.MACPresentationLoader;
	import ttcc.c.ma.ac.MACReplay;
	import ttcc.c.ma.ac.MACWhiteboard;
	import ttcc.c.ma.ac.MAPPComponent;
	import ttcc.c.ma.ac.MAPPComponentInfo;
	import ttcc.c.vcm.VCMAV;
	import ttcc.c.vcm.VCMChat;
	import ttcc.c.vcm.VCMCourseLoader;
	import ttcc.c.vcm.VCMMainPanel;
	import ttcc.c.vcm.VCMPresentationLoader;
	import ttcc.c.vcm.VCMReplay;
	import ttcc.c.vcm.VCMWhiteboard;
	import ttcc.d.a.ARO;
	import ttcc.d.a.DUAIUserAccessInfo;
	import ttcc.d.a.DUAUserInfo;
	import ttcc.d.a.DULayoutComponentInfo;
	import ttcc.d.a.DULayoutInfo;
	import ttcc.d.a.DUUD;
	//} =*^_^*= END OF import
	
	
	/**
	 * 
	 * @author Jinanoimatey Dragoncat
	 * @version 0.0.0
	 * @created 21.06.2012 23:49
	 */
	public class MUIActions extends AM {
		
		//{ =*^_^*= CONSTRUCTOR
		
		function MUIActions (app:Application) {
			super(NAME);
			a=app;
		}
		//} =*^_^*= END OF CONSTRUCTOR
		
		
		public override function listen(eventType:String, details:Object):void {
			var r:ARO;
			switch (eventType) {
			
			case ID_A_CONNECT:
				e.listen(MUserData.ID_A_REQUEST_USER_DATA_ACCESS_MEANS, {customer:NAME, ownerID:a.get_ds().get_clientUserId(), targetID:a.get_ds().get_clientUserId()});
				break;
				
			case MUserData.ID_E_USER_DATA_ACCESS_MEANS:
				if (details.customer==NAME) {
					// store
					duai=details.duai;
					dua=details.dua;
				}
				e.listen(ID_E_CONNECTED, null);
				break;
					
			case VCMMainPanel.ID_E_BUTTON_PRESSED:
				// Entry point
				buttonPressed(details);
				break;
			
			case ID_A_SET_HAND_IS_UP:
				dua.set_HandUp(details, duai);
				break;
				
			case ID_A_SET_CHAT_TYPING:
				dua.set_ChatTyping(details, duai);
				break;
				
			//case ID_A_SET_CHAT_BAN:
				//dua.set_chatBan(details.v, duai);
				//break;
				
			case ID_A_SET_STREAM_IS_ON:
				dua.set_ChatTyping(details, duai);
				break;
				
			case VCMMainPanel.ID_E_MENU_ACTION:
				// detect event type, process, send to apropropriate system layer if needed
				switch (details.id) {
				
				case "securitySettings":
					e.listen(MFlashPlatform.ID_A_SHOW_SECURITY_SETTINGS_GENERAL, null);
					break;
				case "toggleFullscreen":
					e.listen(MFlashPlatform.ID_A_TOGGLE_FULLSCREEN, null);
					break;
				case "windowsLayouts":
					applyWindowsLayout(details.details);
					break;
				
				}
				break;
				
			case ID_A_APPLY_DEFAULT_WINDOWS_LAYOUT:
				applyWindowsLayout(null);
				break;
				
				
			}
		}
		
		private function buttonPressed(buttonID:String):void {
			switch (buttonID) {
			
			case MACReplay.COMPONENT_ID:
				e.listen(VCMReplay.ID_A_SET_VISIBILITY, 2);
				break;
				
			case MACChat.COMPONENT_ID:
				// show/hide 
				e.listen(VCMChat.ID_A_SET_VISIBILITY, 2);
				break;
			
			case MACPresentationLoader.COMPONENT_ID:
				// show hide 
				e.listen(VCMPresentationLoader.ID_A_SET_VISIBILITY, 2);
				break;
			
			/*case null:
				// show hide 
				e.listen(VCMCourseLoader.ID_A_SET_VISIBILITY, 2);
				break;*/
			
			case MACConsole.COMPONENT_ID:
				// show hide 
				Application.setVisibilityConsole(!Application.getVisibilityConsole());
				break;
			
			case MACAV.COMPONENT_ID:
				// show hide 
				e.listen(VCMAV.ID_A_SET_VISIBILITY, 2);
				break;
			
			case MACWhiteboard.COMPONENT_ID:
				// show hide 
				e.listen(VCMWhiteboard.ID_A_SET_VISIBILITY, 2);
				break;
				
			case MACCourseLoader.COMPONENT_ID:
				// show hide 
				e.listen(VCMCourseLoader.ID_A_SET_VISIBILITY, 2);
				break;
				
			case MMP.S_ID_B_START:
				e.listen(VCMMainPanel.ID_A_SET_MENU_VISIBILITY, 1);
				break;
				
			}
		}
		
		private function applyWindowsLayout(layoutID:String):void {
			//default layout
			if (layoutID==null) {layoutID="default";}
			// find layout
			var layout:DULayoutInfo=a.get_ds().get_duAppComponentsCfg().get_layoutByID(layoutID);
			if (!layout) {log(3, 'applyWindowsLayout>no such layout:'+layoutID, 2);return;}
			// apply
			var agentName:String;
			for each(var i:DULayoutComponentInfo in layout.get_componentsList()) {
				// TODO: check whether component started up (?)
				var ci:MAPPComponentInfo=MAPPComponent.getComponentInfoByID(i.get_id());
				if (!ci) {log(3,NAME+'>!MAPPComponentInfo, id='+i.get_id(),1);continue;}
				agentName = MAPPComponent.getComponentInfoByID(i.get_id()).getAgentName();
				// TODO: send message
				e.listen(agentName+MAPPComponent.S_ID_A_APPLY_WINDOW_SETTINGS, i);
			}
		}
		
		//{ =*^_^*= private 
		private var duai:DUAIUserAccessInfo;
		private var dua:DUAUserInfo;
		
		private function get e():AEApp {return get_envRef();}
		private var a:Application;
		//} =*^_^*= END OF private
		
		
		//{ =*^_^*= id
		/**
		 * get data accessor
		 * data:
		 */
		public static const ID_A_CONNECT:String=NAME+'>ID_A_CONNECT';
		/**
		 * data:Boolean
		 */
		public static const ID_A_SET_HAND_IS_UP:String=NAME+'>ID_A_SET_HAND_IS_UP';
		/**
		 * data:Boolean
		 */
		public static const ID_A_SET_CHAT_TYPING:String=NAME+'>ID_A_SET_CHAT_TYPING';
		/**
		 * 
		 * data:{du:DUUD, v:Boolean//banned//}
		 */
		//public static const ID_A_SET_CHAT_BAN:String=NAME+'>ID_A_SET_CHAT_BAN';
		/**
		 * data:Boolean
		 */
		public static const ID_A_SET_STREAM_IS_ON:String=NAME+'>ID_A_SET_STREAM_IS_ON';
		public static const ID_A_APPLY_DEFAULT_WINDOWS_LAYOUT:String=NAME+'>ID_A_APPLY_DEFAULT_WINDOWS_LAYOUT';
		
		//} =*^_^*= END OF id
		
		//{ =*^_^*= events
		public static const ID_E_CONNECTED:String=NAME+'>ID_E_CONNECTED';
		//} =*^_^*= END OF events
		
		public static const NAME:String = 'MUIActions';
		
		public override function autoSubscribeEvents():Array {
			return [
				VCMMainPanel.ID_E_BUTTON_PRESSED
				,ID_A_CONNECT
				,MUserData.ID_E_USER_DATA_ACCESS_MEANS
				,ID_A_SET_HAND_IS_UP
				,ID_A_SET_CHAT_TYPING
				,ID_A_SET_STREAM_IS_ON
				,ID_A_APPLY_DEFAULT_WINDOWS_LAYOUT
				,VCMMainPanel.ID_E_MENU_ACTION
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