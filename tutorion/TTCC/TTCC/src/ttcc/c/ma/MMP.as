// Project TTCC
package ttcc.c.ma {
	
	//{ =*^_^*= import
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import ttcc.APP;
	import ttcc.Application;
	import ttcc.c.ae.AEApp;
	import ttcc.c.vcm.d.DUMPButton;
	import ttcc.c.vcm.d.DUMPElement;
	import ttcc.c.vcm.VCMMainPanel;
	import ttcc.cfg.AppCfg;
	import ttcc.cfg.SP;
	import ttcc.d.a.ARO;
	import ttcc.d.a.DUUD;
	import ttcc.d.m.AbstractModel;
	import ttcc.LOG;
	import ttcc.LOGGER;
	import ttcc.media.PictureStoreroom;
	import ttcc.media.Text;
	import ttcc.v.mp.VCMainPanelClassroomInfoElement;
	import ttcc.v.mp.VCMainPanelUsersListElement;
	import ttcc.v.mp.VCMainPanelUsersListElementMenu;
	import ttcc.v.mp.VCMainPanelUsersOnlineElement;
	//} =*^_^*= END OF import
	
	
	/**
	 * main panel 
	 * @author Jinanoimatey Dragoncat
	 * @version 0.0.0
	 * @created 19.08.2012 18:29
	 */
	public class MMP extends ACMM {
		
		//{ =*^_^*= CONSTRUCTOR
		
		function MMP (app:Application) {
			super(NAME);
			a=app;
		}
		//} =*^_^*= END OF CONSTRUCTOR
		
		public override function listen(eventType:String, details:Object):void {
			//var r:ARO;
			
			switch (eventType) {
				

//{ =*^_^*= =*^_^*= MUserData
				case MUserData.ID_E_USER_LIST_REF:
					var list:Array=details;
					numUsersOnline=list.length;
					listen(ID_A_SET_USERS_ONLINE, numUsersOnline);
					// process users - simulate login
					for each(var i:Object in list) {usersList.userLoggedIn(i);}
					break;
				
				case MUserData.ID_E_USER_LOGIN:
					numUsersOnline+=1;
					listen(ID_A_SET_USERS_ONLINE, numUsersOnline);
					// process user
					usersList.userLoggedIn(details);
					break;
				
				case MUserData.ID_E_USER_LOGOUT:
					numUsersOnline-=1;
					numUsersOnline=(numUsersOnline<0)?0:numUsersOnline;
					listen(ID_A_SET_USERS_ONLINE, numUsersOnline);
					// process user
					usersList.userLoggedOut(details);
					break;
				
				case MUserData.ID_E_USER_STREAM_NAME_PRESENT:
				case MUserData.ID_E_USER_STREAM_NAME_IS_EMPTY:
					usersList.userPropertyUpdatedStreamName(details);
					break;
				
				case MUserData.ID_E_USER_CHAT_TYPING_OFF:
				case MUserData.ID_E_USER_CHAT_TYPING_ON:
					usersList.userPropertyUpdatedChatTyping(details);
					break;
				case MUserData.ID_E_USER_HAND_DOWN:
				case MUserData.ID_E_USER_HAND_UP:
					usersList.userPropertyUpdatedHandUp(details);
					break;
				/* NOT USED HERE - display stream data instead
				 * case MUserData.ID_E_USER_SOUND_OFF:
				case MUserData.ID_E_USER_SOUND_ON:
					break;*/
//} =*^_^*= =*^_^*= END OF MUserData				


				case ID_A_SET_ROOM_TITLE:
					classInfo.setTextOutput(
						VCMainPanelClassroomInfoElement.ID_OUT_TEXT_0
						,APP.lText().get_TEXT(Text.ID_TEXT_MP_CLASS)+':'+details);
					break;
					
				case ID_A_SET_USERS_ONLINE:
					var n:int=(details<10)?'0'+details:details;
					usersOnline.setTextOutput(
						VCMainPanelClassroomInfoElement.ID_OUT_TEXT_0
						,APP.lText().get_TEXT(Text.ID_TEXT_MP_USERS_ONLINE)+':'+details);
					break;
					
				case ID_A_RUN:
					prepare(details);
					break;
					
				case VCMMainPanel.ID_E_BUTTON_PRESSED:
					buttonPressed(details);
					break;
				
				case ID_A_REGISTER_MODEL:
					registerModel(a, usersList.get_model());
					//req userlist
					if (!a.get_ds().get_replayMode()) {
						e.subscribe(this, MUserData.ID_E_USER_LIST_REF);
						e.listen(MUserData.ID_A_GET_USER_LIST_REF, null);
					}
					break;
					
				//case ID_A_DISPLAY_START_MENU:
					//break;
				//case ID_A_HIDE_START_MENU:
					//break;
			}
		}
		
		
		private function prepare(details:Object):void {
			//{ ^_^ place start button
			e.listen(VCMMainPanel.ID_A_ADD_BUTTON, new DUMPButton(
				S_ID_B_START
				,5000
				,'start_w','start_w','start_w'
				,APP.lText().get_TEXT(Text.ID_TEXT_MAIN_PANEL_B_START_TIP)
			));
			//} ^_^ END OF place start button
			
			//{ ^_^ place room info
			var cid:DUMPElement=new DUMPElement('classroominfo', 10000);
			classInfo = new VCMainPanelClassroomInfoElement();
			classInfo.set_dt0W(200);
			e.listen(VCMMainPanel.ID_A_ADD_ELEMENT, {e:classInfo, d:cid});
			//} ^_^ END OF place room info
			
			//{ ^_^ place usersOnline
			var cid0:DUMPElement=new DUMPElement('usersOnline', 10100);
			usersOnline = new VCMainPanelUsersOnlineElement();
			usersOnline.set_dt0W(200);
			usersOnline.construct();
			listen(ID_A_SET_USERS_ONLINE, 1);
			e.listen(VCMMainPanel.ID_A_ADD_ELEMENT, {e:usersOnline, d:cid0});
			//} ^_^ END OF place usersOnline
			
			//{ ^_^ add handup toggle button
			e.listen(VCMMainPanel.ID_A_ADD_BUTTON, new DUMPButton(
				S_ID_B_HAND_UP
				,15000
				,'ruka_6','ruka_6','ruka_6'
				,APP.lText().get_TEXT(Text.ID_TEXT_MAIN_PANEL_B_HAND_UP)
			));
			e.listen(VCMMainPanel.ID_A_ADD_BUTTON, new DUMPButton(
				S_ID_B_HAND_DOWN
				,15001
				,'ruka_1','ruka_1','ruka_1'
				,APP.lText().get_TEXT(Text.ID_TEXT_MAIN_PANEL_B_HAND_DOWN)
			));
			//} ^_^ END OF add handup toggle button
			
			//{ ^_^ usersList
			var cid3:DUMPElement=new DUMPElement('usersList', 700000);
			usersList = new VCMainPanelUsersListElement();
			usersList.setResources(
				PictureStoreroom.getPictureClass('write_0')
				,PictureStoreroom.getPictureClass('write_1')
				,PictureStoreroom.getPictureClass('voice_0')
				,PictureStoreroom.getPictureClass('voice_1')
				,PictureStoreroom.getPictureClass('hand_0')
				,PictureStoreroom.getPictureClass('hand_1')
				,AppCfg.MAIN_PANEL_CL_CONTACT_AVATAR_W
				,AppCfg.MAIN_PANEL_CL_CONTACT_AVATAR_H
				,AppCfg.MAIN_PANEL_CL_CONTACT_STATE_ICON_W
				,AppCfg.MAIN_PANEL_CL_CONTACT_STATE_ICON_H
			);
			
			usersList.construct(el_userList);
			usersList.prepareModel(a);
			e.listen(VCMMainPanel.ID_A_ADD_ELEMENT, {e:usersList, d:cid3});
			//} ^_^ END OF usersList
			
			//{ ^_^ prepare menu
			e.listen(VCMMainPanel.ID_A_PREPARE_MENU, 
				{
					menuData:a.get_ds().get_duAppComponentsCfg().get_mainMenuRawData()
					,layoutsList:a.get_ds().get_duAppComponentsCfg().get_layoutsList()
				}
			);
			//} ^_^ END OF prepare menu
			
			//display room title
			listen(ID_A_SET_ROOM_TITLE, a.get_ds().get_startupPathsList().get_roomTitle());
			
		}
		
		private function el_userList(target:VCMainPanelUsersListElement, type:uint, data:Object):void {
			
			switch (type) {
			
			case VCMainPanelUsersListElement.ID_E_ELEMENT_SELECTED:
				// create popup
				var tdu:DUUD=data.targetDU;
				var popup:VCMainPanelUsersListElementMenu=new VCMainPanelUsersListElementMenu(a.get_ds().get_clientUserData(), tdu);
				popup.setEventListener(el_userListElementPupupMenu);
				
				var vc:DisplayObject=data.targetDO;
				popup.get_vc().x=(vc.x-vc.width/2+usersList.getComponent().x);
				popup.get_vc().y=(vc.y+vc.height+usersList.getComponent().y);
				e.listen(VCMMainPanel.ID_A_REMOVE_POPUP, null);
				e.listen(VCMMainPanel.ID_A_ADD_POPUP, {target:popup.get_vc(), anchor:usersList.getComponent()});
			case VCMainPanelUsersListElement.ID_E_REDRAW_MP:
				//redraw
				e.listen(VCMMainPanel.ID_A_REDRAW_VC, null);
				break;
			
			}
			
		}
		
		private function el_userListElementPupupMenu(target:VCMainPanelUsersListElementMenu, id:String):void {
			switch (id) {
				case 'handOn':
				case 'handOff':
					target.get_targetUD().set_handIsUp(id=='handOn');
					e.listen(MUserData.ID_A_SET_USER_PROPERTY_HAND_IS_UP, target.get_targetUD());
					break;
					
				case 'streamOn':
				case 'streamOff':
					target.get_targetUD().set_streamingIsOn(id=='streamOn');
					e.listen(MUserData.ID_A_SET_USER_PROPERTY_STREAM_IS_ON, target.get_targetUD());
					break;
			}
		}
		
		private function buttonPressed(buttonID:String):void {
			switch (buttonID) {
			
			case S_ID_B_HAND_UP:
				e.listen(MUIActions.ID_A_SET_HAND_IS_UP, true);
				break;
			case S_ID_B_HAND_DOWN:
				e.listen(MUIActions.ID_A_SET_HAND_IS_UP, false);
				break;
				
			}
		}
		
		//{ =*^_^*= private id
		private static const S_ID_B_HAND_DOWN:String='handUp';
		private static const S_ID_B_HAND_UP:String='handDown';
		public static const S_ID_B_START:String='bStart';
		//} =*^_^*= END OF private id
		
		
		//{ =*^_^*= private
		private var usersList:VCMainPanelUsersListElement;
		
		private var numUsersOnline:int=1;
		private var classInfo:VCMainPanelClassroomInfoElement;
		private var usersOnline:VCMainPanelUsersOnlineElement;
		
		private function get e():AEApp {return get_envRef();}
		private var a:Application;		
		//} =*^_^*= END OF private
		
		//{ =*^_^*= id
		public static const ID_A_RUN:String=NAME+'>ID_A_RUN';
		/**
		 * String//text//
		 */
		public static const ID_A_SET_ROOM_TITLE:String=NAME+'>ID_A_SET_ROOM_TITLE';
		/**
		 * String//text//
		 */
		public static const ID_A_SET_USERS_ONLINE:String=NAME+'>ID_A_SET_USERS_ONLINE';
		/**
		 * execute after MReplay started
		 */
		public static const ID_A_REGISTER_MODEL:String=NAME+'>ID_A_REGISTER_MODEL';
		//public static const ID_A_DISPLAY_START_MENU:String=NAME+'>ID_A_DISPLAY_START_MENU';
		//public static const ID_A_HIDE_START_MENU:String=NAME+'>ID_A_HIDE_START_MENU';
		//} =*^_^*= END OF id
		
		//{ =*^_^*= events
		//public static const ID_E_PLAYBACK_RESUME:String=NAME+'>ID_E_PLAYBACK_RESUME';
		//} =*^_^*= END OF events
		
		
		public static const NAME:String = 'MMP';
		
		public override function autoSubscribeEvents():Array {
			return [
				ID_A_RUN
				,ID_A_SET_ROOM_TITLE
				//,ID_A_SET_USERS_ONLINE
				,MUserData.ID_E_USER_LOGIN
				,MUserData.ID_E_USER_LOGOUT
				,VCMMainPanel.ID_E_BUTTON_PRESSED
				,MUserData.ID_E_USER_STREAM_NAME_PRESENT
				,MUserData.ID_E_USER_STREAM_NAME_IS_EMPTY
				,MUserData.ID_E_USER_CHAT_TYPING_OFF
				,MUserData.ID_E_USER_CHAT_TYPING_ON
				,MUserData.ID_E_USER_HAND_DOWN
				,MUserData.ID_E_USER_HAND_UP
				,ID_A_REGISTER_MODEL
				//,ID_A_DISPLAY_START_MENU
				//,ID_A_HIDE_START_MENU
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