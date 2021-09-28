// Project TTCC
package ttcc.c.vcm {
	
	//{ =*^_^*= import
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import ttcc.APP;
	import ttcc.c.v.AVGUIController;
	import ttcc.cfg.AppCfg;
	import ttcc.LOG;
	import ttcc.media.Text;
	import ttcc.n.loaders.Im;
	import ttcc.v.av.VCAV;
	import ttcc.v.av.VCAVContactsList;
	import ttcc.v.av.VCAVContactsListElement;
	import ttcc.v.av.VCAVVideoWindow;
	//} =*^_^*= END OF import
	
	/**
	 * display manager - controlls audio video interface
	 * @author Jinanoimatey Dragoncat
	 * @version 0.0.0
	 * @created 04.07.2012 3:08
	 */
	public class VCMAV extends AVCM {
		
		//{ =*^_^*= CONSTRUCTOR
		
		function VCMAV () {
			super(NAME);
		}
		//} =*^_^*= END OF CONSTRUCTOR
		
		
		public override function listen(eventType:String, details:Object):void {
			
			switch (eventType) {
			
			case ID_A_SET_PRIMARY_VIDEO:
				setVideo(details);
				break;
				
			case ID_A_ADD_VIDEO:
				// add to list
				addUser(details);
				break;
				
			case ID_A_REMOVE_VIDEO:
				// remove from list
				removeUser(details);
				break;
				
			case ID_A_REGISTER_SINGLETON_VC:
				vc=details;
				configureVC();
				break;
				
			case ID_A_SET_VISIBILITY:
				vc.set_visible((details<2)?Boolean(details):!vc.get_visible());
				break;
				
			case ID_A_SET_WINDOW_XYWH:
				vc.setXY(details[0],details[1]);
				vc.setWH(details[2],details[3]);
				break;
			
			//{ ^_^ update toggle buttons
			case ID_A_SET_STATE_AU_OUT:
				vc.setStateFor(VCAV.ID_ST_AU_IS_ON_OUT, !details);vc.redraw();
				break;
			case ID_A_SET_STATE_V_OUT:
				vc.setStateFor(VCAV.ID_ST_V_IS_ON_OUT, !details);vc.redraw();
				break;
			case ID_A_SET_STATE_AU_IN:
				vc.setStateFor(VCAV.ID_ST_AU_IS_ON_IN, !details);vc.redraw();
				break;
			case ID_A_SET_STATE_V_IN:
				vc.setStateFor(VCAV.ID_ST_V_IS_ON_IN, !details);vc.redraw();
				break;
			case ID_A_SET_STATE_S:
				vc.setStateFor(VCAV.ID_ST_S_IS_ON, !details);vc.redraw();
				break;
			//} ^_^ END OF update toggle buttons			
				
			}
		}
		
		private function removeUser(u:AVGUIController):void {
			cl.removeElementLEById(u.get_id());
			vc.redraw();
		}
		
		private function setVideo(u:AVGUIController):void {
			vidW.construct(u.get_id(), null, AppCfg.AV_VIDEO_DEFAULT_W, AppCfg.AV_VIDEO_DEFAULT_H, false, u);
		}
		private function addUser(u:AVGUIController):void {
			vc.addElement(u.get_id(), el_contact, AppCfg.AV_SL_CONTACT_VP_W, AppCfg.AV_SL_CONTACT_VP_H, false, u);
			vc.redraw();
		}
		
		private function setVisibility(target:DisplayObject, a:Boolean):void {
			if (!target) {return;}target.visible = a;
		}
		
		private function configureVC():void {
			cl=new VCAVContactsList(el_contact);
			vidW=new VCAVVideoWindow();
			vidW.setResourceO(VCAVVideoWindow.ID_ELEMENT_DEFAULT_USER_PICTURE, vc.get_defaultUserpic());
			vidW.setResourceO(VCAVVideoWindow.ID_ELEMENT_ICON_HAS_NO_AUDIO, vc.get_icon_hasNoAudio());
			vidW.resourcesAreConfigured();
			
			vc.construct(cl, vidW);
			vc.setListener(el_vc);
		}
		
		private function createAvatarSmallPicture(a:String):DisplayObject {
			var s:Sprite=new Sprite;
			s.graphics.beginFill(0,0);
			s.graphics.drawRect(0, 0, AppCfg.AV_SL_STREAM_VP_W, AppCfg.AV_SL_STREAM_VP_H);
			s.addChild(new Im(a))
			return s;
		}
		
		private function el_vc (target:VCAV, eventType:String, details:Object):void {
			switch (eventType) {
				
			case VCAV.ID_E_B_SETTINGS:
				get_envRef().listen(ID_E_B_SETTINGS, details);
				break;
			
			case VCAV.ID_E_B_STREAM:
				get_envRef().listen(ID_E_B_STREAM, details);
				break;
			
			case VCAV.ID_E_B_TAU_OUT:
				get_envRef().listen(ID_E_B_TAU_OUT, details);
				break;
			
			case VCAV.ID_E_B_TV_OUT:
				get_envRef().listen(ID_E_B_TV_OUT, details);
				break;
			
			case VCAV.ID_E_B_TAU_IN:
				get_envRef().listen(ID_E_B_TAU_IN, details);
				break;
			
			case VCAV.ID_E_B_TV_IN:
				get_envRef().listen(ID_E_B_TV_IN, details);
				break;
			
			}
			
		}
		
		private function el_contact (target:VCAVContactsListElement, eventType:String):void {
			//LOG(3,'contact action:id='+target.get_id()+' eventType='+eventType, 0);
			
			switch (eventType) {
			
			case VCAVContactsListElement.EVENT_ELEMENT_SELECTED:
				// diselect all
				//vc.deselectAll();
				// select target
				//target.set_selected(true);
				get_envRef().listen(ID_E_USER_SELECTED, target.get_id());
				break;
			
			}
		}
		
		
		//{ =*^_^*= private 
		private var vc:VCAV;
		// contacts list
		private var cl:VCAVContactsList;	
		private var vidW:VCAVVideoWindow;	
		/**
		 * [DU?]
		 */
		private var streamList_D:Array;
		private var clientUserName:String;
		//} =*^_^*= END OF private
		
		
		//{ =*^_^*= events
		/**
		 * data:Boolean
		 */
		public static const ID_E_B_TAU_OUT:String=NAME+'>ID_E_B_TAU_OUT';
		/**
		 * data:Boolean
		 */
		public static const ID_E_B_TV_OUT:String=NAME+'>ID_E_B_TV_OUT';
		/**
		 * for all incoming streams
		 * data:Boolean
		 */
		public static const ID_E_B_TAU_IN:String=NAME+'>ID_E_B_TAU_IN';
		/**
		 * for all incoming streams
		 * data:Boolean
		 */
		public static const ID_E_B_TV_IN:String=NAME+'>ID_E_B_TV_IN';
		public static const ID_E_B_SETTINGS:String=NAME+'>ID_E_B_SETTINGS';
		/**
		 * shut down streaming completely/resume streaming
		 * data:Boolean
		 */
		public static const ID_E_B_STREAM:String=NAME+'>ID_E_B_STREAM';
		/**
		 * userID:String
		 */
		public static const ID_E_USER_SELECTED:String=NAME+'>ID_E_USER_SELECTED';
		//} =*^_^*= END OF events
		
		//{ =*^_^*= id
		/**
		 * [AVGUIController]
		 */
		public static const ID_A_SET_PRIMARY_VIDEO:String = NAME + '>ID_A_SET_PRIMARY_VIDEO';
		/**
		 * [AVGUIController]
		 */
		public static const ID_A_ADD_VIDEO:String = NAME + '>ID_A_ADD_VIDEO';
		/**
		 * [AVGUIController]
		 */
		public static const ID_A_REMOVE_VIDEO:String = NAME + '>ID_A_REMOVE_VIDEO';
		/**
		 * data:VCAV
		 */
		public static const ID_A_REGISTER_SINGLETON_VC:String = NAME + '>ID_A_REGISTER_SINGLETON_VC';
		/**
		 * data:uint
		 * 0 false, 1 true, 2 toggle
		 */
		public static const ID_A_SET_VISIBILITY:String=NAME+'>ID_A_SET_VISIBILITY';
		/**
		 * data:[x,y,w,h]
		 */
		public static const ID_A_SET_WINDOW_XYWH:String=NAME+'>ID_A_SET_WINDOW_XYWH';
		/**
		 * data:Boolean
		 */
		public static const ID_A_SET_STATE_AU_OUT:String=NAME+'>ID_A_SET_STATE_AU_OUT';
		/**
		 * data:Boolean
		 */
		public static const ID_A_SET_STATE_V_OUT:String=NAME+'>ID_A_SET_STATE_V_OUT';
		/**
		 * data:Boolean
		 */
		public static const ID_A_SET_STATE_AU_IN:String=NAME+'>ID_A_SET_STATE_AU_IN';
		/**
		 * data:Boolean
		 */
		public static const ID_A_SET_STATE_V_IN:String=NAME+'>ID_A_SET_STATE_V_IN';
		/**
		 * data:Boolean
		 */
		public static const ID_A_SET_STATE_S:String=NAME+'>ID_A_SET_STATE_S';
		//} =*^_^*= END OF id
		
		public override function autoSubscribeEvents():Array {
			return [
				ID_A_REGISTER_SINGLETON_VC
				,ID_A_SET_VISIBILITY
				,ID_A_SET_WINDOW_XYWH
				,ID_A_SET_PRIMARY_VIDEO
				,ID_A_ADD_VIDEO
				,ID_A_REMOVE_VIDEO
				,ID_A_SET_STATE_AU_OUT
				,ID_A_SET_STATE_V_OUT
				,ID_A_SET_STATE_V_IN
				,ID_A_SET_STATE_AU_IN
				,ID_A_SET_STATE_S
			];
		}
		
		public static const NAME:String = 'VCMAV';
	}
}


//{ =*^_^*= History
/* > (timestamp) [ ("+" (added) ) || ("-" (removed) ) || ("*" (modified) )] (text)
 * > 
 */
//} =*^_^*= END OF History

// template last modified:11.03.2011_[18#51#40]_[5]