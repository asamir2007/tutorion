// Project TTCC
package ttcc.c.ma.ac {
	
	//{ =*^_^*= import
	import ttcc.APP;
	import ttcc.Application;
	import ttcc.c.ae.AEApp;
	import ttcc.c.ma.ac.MAPPComponent;
	import ttcc.c.ma.MAV;
	import ttcc.c.vcm.d.DUMPButton;
	import ttcc.c.vcm.VCMAV;
	import ttcc.c.ma.ac.MACMP;
	import ttcc.cfg.AppCfg;
	import ttcc.d.a.ARO;
	import ttcc.d.a.DUAppComponentCfg;
	import ttcc.media.PictureStoreroom;
	import ttcc.media.Text;
	import ttcc.v.av.VCAV;
	//} =*^_^*= END OF import
	
	
	/**
	 * application component
	 * @author Jinanoimatey Dragoncat
	 * @version 0.0.0
	 * @created 05.07.2012 3:29
	 */
	public class MACAV extends MAPPComponent {
		
		//{ =*^_^*= CONSTRUCTOR
		
		function MACAV (app:Application) {
			super(NAME, COMPONENT_ID, 103000, [MACMP.COMPONENT_ID]);
			a=app;
		}
		//} =*^_^*= END OF CONSTRUCTOR
		
		
		public override function listen(eventType:String, details:Object):void {
			super.listen(eventType, details);
			switch (eventType) {
			
			case MAV.ID_E_CONNECTED:
			case MAV.ID_E_PREPARED:
				componentStartedUp=true;
				// tell about
				e.listen(getServiceActionName(S_ID_E_COMPONENT_IS_READY), null);
				break;
				
			case MAV.ID_E_CONNECTION_ERROR:
				// tell about
				if (componentStartedUp) {
					e.listen(getServiceActionName(S_ID_E_OPERATION_ERROR), null);
				} else {
					e.listen(getServiceActionName(S_ID_E_FAILED_TO_RUN_COMPONENT), null);
				}
				break;
				
			}
		}
		
		protected override function runComponent():void {
			super.runComponent();
			e.listen(MAV.ID_A_PREPARE_MODEL, null);
			e.listen(MAV.ID_A_PREPARE, {replayMode:a.get_ds().get_replayMode()});
			if (!a.get_ds().get_replayMode()) {
				e.listen(MAV.ID_A_CONNECT, null);
			}
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
			e.placeAgent(new MAV(a));
			e.placeAgent(new VCMAV());
			
			//prepare view
			
			//{ ^_^ video
			var c:VCAV=new VCAV;
			c.set_de(a.get_de());
			
			// configure video resources
			c.setResources(APP.lText().get_TEXT(Text.ID_TEXT_VIDEO_WINDOW_TITLE),PictureStoreroom.getPicture('video_h')
				,AppCfg.AV_VIDEO_DEFAULT_W+AppCfg.AV_SL_CONTACT_VP_W
				,AppCfg.AV_VIDEO_DEFAULT_H+AppCfg.AV_SL_CONTACT_VP_H*3.5
			);
			
			var resAppID:Array=[
				VCAV.ID_B_SETTINGS
				,VCAV.ID_B_TOGGLE_V_IN_ON
				,VCAV.ID_B_TOGGLE_V_IN_OFF
				,VCAV.ID_B_TOGGLE_V_OUT_ON
				,VCAV.ID_B_TOGGLE_V_OUT_OFF
				,VCAV.ID_B_TOGGLE_AU_IN_ON
				,VCAV.ID_B_TOGGLE_AU_IN_OFF
				,VCAV.ID_B_TOGGLE_AU_OUT_ON
				,VCAV.ID_B_TOGGLE_AU_OUT_OFF
				,VCAV.ID_B_TOGGLE_S_ON
				,VCAV.ID_B_TOGGLE_S_OFF
			];
			var resString:Array=[
				Text.ID_TEXT_VIDEO_WINDOW_B_SETTINGS
				,Text.ID_TEXT_VIDEO_B_TOGGLE_V_IN_ON
				,Text.ID_TEXT_VIDEO_B_TOGGLE_V_IN_OFF
				,Text.ID_TEXT_VIDEO_B_TOGGLE_V_OUT_ON
				,Text.ID_TEXT_VIDEO_B_TOGGLE_V_OUT_OFF
				,Text.ID_TEXT_VIDEO_B_TOGGLE_AU_IN_ON
				,Text.ID_TEXT_VIDEO_B_TOGGLE_AU_IN_OFF
				,Text.ID_TEXT_VIDEO_B_TOGGLE_AU_OUT_ON
				,Text.ID_TEXT_VIDEO_B_TOGGLE_AU_OUT_OFF
				,Text.ID_TEXT_VIDEO_B_TOGGLE_S_ON
				,Text.ID_TEXT_VIDEO_B_TOGGLE_S_OFF
			];
			var resFileName:Array=[
				'settings_h'
				,'cam_on_in'
				,'cam_off_in'
				,'cam_on_out'
				,'cam_off_out'
				,'sound_on_in'
				,'sound_off_in'
				,'sound_on_out'
				,'sound_off_out'
				,'stream_on_out'
				,'stream_off_out'
			];
			var l:uint = resFileName.length;
			for (var i:int = 0;i < l;i++ ) {
				c.setDOResource(resAppID[i], PictureStoreroom.getPicture(resFileName[i]));
				c.setStringResource(resAppID[i], APP.lText().get_TEXT(resString[i]));
			}
			
			
			c.setResourceO(VCAV.ID_ELEMENT_DEFAULT_USER_PICTURE, PictureStoreroom.getPictureClass("default_user_picture"));
			c.setResourceO(VCAV.ID_ELEMENT_ICON_HAS_NO_AUDIO, PictureStoreroom.getPictureClass("icon_stream_sound_off"));
			c.resourcesAreConfigured();
			
			a.get_mainScreen().set_av(c);
			e.listen(VCMAV.ID_A_REGISTER_SINGLETON_VC, a.get_mainScreen().get_av());
			//} ^_^ END OF video
			
			
		}
		
		protected override function window__setXYWH(x:Number, y:Number, w:Number, h:Number):void {
			super.window__setXYWH(x,y,w,h);
			e.listen(VCMAV.ID_A_SET_WINDOW_XYWH, [x,y,w,h]);
		}
		
		protected override function window__setInitialVisibility(a:Boolean):void {
			super.window__setInitialVisibility(a);
			e.listen(VCMAV.ID_A_SET_VISIBILITY, a);
		}
		
		protected override function displayMPButton():void {
			super.displayMPButton();
			e.listen(MACMP.ID_A_ADD_BUTTON, new DUMPButton(
				COMPONENT_ID
				,50000
				,"video_w"
				,"video_w"
				,"video_w"
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
		public static const COMPONENT_ID:String = 'v_list';
		//} =*^_^*= =*^_^*= END OF component cfg properties list
		
		
		//{ =*^_^*= events
		//} =*^_^*= END OF events
		
		public static const NAME:String = 'MACAV';
		
		
		public override function autoSubscribeEvents():Array {
			var events:Array=super.autoSubscribeEvents();if (!events) {events=[];}
			return events.concat(
				MAV.ID_E_CONNECTED
				,MAV.ID_E_PREPARED
				,MAV.ID_E_CONNECTION_ERROR
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