// Project TTCC
package ttcc.c.ma.ac {
	
	//{ =*^_^*= import
	import ttcc.APP;
	import ttcc.Application;
	import ttcc.c.ae.AEApp;
	import ttcc.c.ma.ac.MAPPComponent;
	import ttcc.c.ma.MChat;
	import ttcc.c.vcm.d.DUMPButton;
	import ttcc.c.vcm.VCMChat;
	import ttcc.c.ma.ac.MACMP;
	import ttcc.cfg.AppCfg;
	import ttcc.d.a.ARO;
	import ttcc.d.a.DUAppComponentCfg;
	import ttcc.media.PictureStoreroom;
	import ttcc.media.Text;
	import ttcc.v.chat.VCChat;
	//} =*^_^*= END OF import
	
	
	/**
	 * application component
	 * @author Jinanoimatey Dragoncat
	 * @version 0.0.0
	 * @created 19.06.2012 15:38
	 */
	public class MACChat extends MAPPComponent {
		
		//{ =*^_^*= CONSTRUCTOR
		
		function MACChat (app:Application) {
			super(NAME, COMPONENT_ID, 101000, [MACMP.COMPONENT_ID]);
			a=app;
		}
		//} =*^_^*= END OF CONSTRUCTOR
		
		
		public override function listen(eventType:String, details:Object):void {
			super.listen(eventType, details);
			switch (eventType) {
			
			case MChat.ID_E_CONNECTED:
				// tell about
				reportReady();
				break;
				
			case MChat.ID_E_CONNECTION_ERROR:
				// tell about
				if (componentStartedUp) {
					e.listen(getServiceActionName(S_ID_E_OPERATION_ERROR), null);
				} else {
					e.listen(getServiceActionName(S_ID_E_FAILED_TO_RUN_COMPONENT), null);
				}
				break;
				
			}
		}
		
		private function reportReady():void {
			componentStartedUp=true;
			e.listen(getServiceActionName(S_ID_E_COMPONENT_IS_READY), null);
		}
		
		protected override function runComponent():void {
			super.runComponent();
			e.listen(VCMChat.ID_A_SET_REQUIRED_DATA, a.get_ds().get_clientUserId());
			e.listen(MChat.ID_A_PREPARE_MODEL, null);
			if (a.get_ds().get_replayMode()) {
				reportReady();
				return;
			}
			e.listen(MChat.ID_A_CONNECT, null);
		}
		
		protected override function checkCFG(cfg:DUAppComponentCfg):void {
			super.checkCFG(cfg);
			cfg.setBoolean(ID_AC_CFG_P_MPBUTTON_PRESENT, true);
			cfg.setBoolean(ID_AC_CFG_P_WINDOW_PRESENT, true);
		}
		
		protected override function applyCFG(cfg:DUAppComponentCfg):void {
			super.applyCFG(cfg);
		}
		
		protected override function prepareBeforeStartup():void {
			super.prepareBeforeStartup();
			//prepare agents
			e.placeAgent(new MChat(a));
			e.placeAgent(new VCMChat(a));
			//prepare view
			var c:VCChat=new VCChat;
			c.setAppRef_(a);
			c.set_de(a.get_de());
			// configure chat
			c.setResources(
				APP.lText().get_TEXT(Text.ID_TEXT_CHAT_WINDOW_TITLE)
				,PictureStoreroom.getPicture('users')
				,[PictureStoreroom.getPicture('sndms_w'), PictureStoreroom.getPicture('sndms_b'), PictureStoreroom.getPicture('sndms_p')]
				,PictureStoreroom.getPicture('chat_h')
			);
			a.get_mainScreen().set_chat(c);
			e.listen(VCMChat.ID_A_REGISTER_SINGLETON_VC, a.get_mainScreen().get_chat());
		}
		
		protected override function window__setXYWH(x:Number, y:Number, w:Number, h:Number):void {
			super.window__setXYWH(x,y,w,h);
			e.listen(VCMChat.ID_A_SET_WINDOW_XYWH, [x,y,w,h]);
		}
		
		protected override function window__setInitialVisibility(a:Boolean):void {
			super.window__setInitialVisibility(a);
			e.listen(VCMChat.ID_A_SET_VISIBILITY, a);
		}
		
		protected override function displayMPButton():void {
			super.displayMPButton();
			e.listen(MACMP.ID_A_ADD_BUTTON, new DUMPButton(
				COMPONENT_ID
				,51000
				,"chat_w"
				,"chat_b"
				,"chat_p"
				,APP.lText().get_TEXT(Text.ID_TEXT_CHAT_WINDOW_TITLE)
			));
		}
		
		//{ =*^_^*= private 
		private var componentStartedUp:Boolean;
		//} =*^_^*= END OF private
		
		private function get e():AEApp {return get_envRef();}
		private var a:Application;		
		
		//{ =*^_^*= id
		//} =*^_^*= END OF id
		
		//{ =*^_^*= =*^_^*= component cfg properties list
		public static const COMPONENT_ID:String = 'text_chat';
		//} =*^_^*= =*^_^*= END OF component cfg properties list
		
		
		//{ =*^_^*= events
		//} =*^_^*= END OF events
		
		public static const NAME:String = 'MACChat';
		
		
		public override function autoSubscribeEvents():Array {
			var events:Array=super.autoSubscribeEvents();if (!events) {events=[];}
			return events.concat(
				MChat.ID_E_CONNECTED
				,MChat.ID_E_CONNECTION_ERROR
			);
		}
	}
}

//{ =*^_^*= History
/* > (timestamp) [ ("+" (added) ) || ("-" (removed) ) || ("*" (modified) )] (text)
 * > 
 */
//} =*^_^*= END OF History

// template last modified:11.03.2011_[18#51#40]_[5]