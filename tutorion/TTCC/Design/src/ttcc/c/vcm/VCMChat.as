// Project TTCC
package ttcc.c.vcm {
	
	//{ =*^_^*= import
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import org.jinanoimateydragoncat.display.utils.Utils;
	import ttcc.APP;
	import ttcc.Application;
	import ttcc.c.ae.AEApp;
	import ttcc.c.ma.MChat;
	import ttcc.c.ma.MUIActions;
	import ttcc.c.ma.MUserData;
	import ttcc.cfg.AppCfg;
	import ttcc.d.a.DUChatAdaptorUser;
	import ttcc.d.a.DUUD;
	import ttcc.d.m.GUIWindowModel;
	import ttcc.d.v.DUChatMessage;
	import ttcc.LOG;
	import ttcc.media.PictureStoreroom;
	import ttcc.media.Text;
	import ttcc.n.loaders.Im;
	import ttcc.v.chat.VCChat;
	import ttcc.v.chat.VCChatContactsList;
	import ttcc.v.chat.VCChatContactsListElement;
	//} =*^_^*= END OF import
	
	/**
	 * display manager - controlls chat interface
	 * @author Jinanoimatey Dragoncat
	 * @version 0.0.0
	 * @created 28.05.2012 18:38
	 */
	public class VCMChat extends AVCM {
		
		//{ =*^_^*= CONSTRUCTOR
		
		function VCMChat (a:Application) {
			super(NAME);
			this.a=a;
			cl=new VCChatContactsList(el_contact,a.get_ds().get_clientUserData().get_isLector())
		}
		//} =*^_^*= END OF CONSTRUCTOR
		
		
		public override function listen(eventType:String, details:Object):void {
			
			switch (eventType) {
			
			case ID_A_SET_REQUIRED_DATA:
				clientUserName=details;
				break;
				
			case ID_A_DISPLAY_USER_LIST:
				// analyse user list, remove missing, add new
				//rebuildUserList(details);
				userList_D=details.slice();
				processUserList();
				// display user list
				displayUserList();
				break;
				
			case ID_A_DISPLAY_MESSAGES:
				for each(var i:DUChatMessage in details) {
					displayChatMessage(i);
				}
				vc.scrollMsgDTToBottom();
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
				
			case ID_A_SET_TEXT_INPUT:
				if (details==null) {details='';}
				vc.setTextInput(VCChat.ID_TEXT_IN_0, details);
				break;
				
			case ID_A_CLEAR_TEXT_OUTPUT:
				vc.setOutText('');
				break;
				
			case MUserData.ID_E_USER_CHAT_BANNED_ON:
			case MUserData.ID_E_USER_CHAT_BANNED_OFF:
				if (!a.get_ds().get_clientUserData().get_isLector()) {return;}
				var element:VCChatContactsListElement=cl.getElementById(DUUD(details).get_id());
				if (element!=null) {
					LOG(0,'set_state:'+!DUUD(details).get_isBannedChat()+' for:'+DUUD(details).get_id(),2);
					element.set_state(!DUUD(details).get_isBannedChat());
				}
				break;
				
			}
		}
		
		
		private function processUserList():void {
			for each(var u:DUChatAdaptorUser in userList_D) {// lectors first
				if (u.get_isLector()) {u.set_forcedListPostion(0);}
			}
		}
		
		private function displayUserList():void {
			// sort user list
			var a:Array=[];
			var i:DUChatAdaptorUser;
			for each(i in userList_D) {
				a.push({d:i, y:i.get_forcedListPostion()});
			}
			a.sortOn('y', Array.NUMERIC);
			
			//display
			cl.clearContent();
			for each(var j:Object in a) {
				i=j.d;
				cl.addElement(
					processTextUserName(i)
					,createAvatarSmallPicture(i.get_avatarPictureSmall(),AppCfg.CHAT_CL_CONTACT_AVATAR_W, AppCfg.CHAT_CL_CONTACT_AVATAR_H)
					,userList_D.indexOf(i)
					,false
					,i.get_name()
				);
			}
			vc.redraw();
		}
		
		private function processTextUserName(du:DUChatAdaptorUser):String {
			//check for empty or nvisible text
			var n:String=du.get_displayName();
			if (n==null || n.length<1 || n.replace('','').length<1) {
				n=APP.lText().get_TEXT(Text.ID_TEXT_CHAT_CL_INVISIBLE_USER_NAME);
			}
			
			if (du.get_isLector()) {
				return Text.helperHTML_Color_Bold(n, (du.get_name()==clientUserName)?
												AppCfg.STYLE_CHAT_OUTGOING_MSG_TEXT_COLOR:
												AppCfg.STYLE_CHAT_INCOMING_MSG_TEXT_COLOR);
			}
			return Text.helperHTML_Color(n, (du.get_name()==clientUserName)?
												AppCfg.STYLE_CHAT_OUTGOING_MSG_TEXT_COLOR:
												AppCfg.STYLE_CHAT_INCOMING_MSG_TEXT_COLOR);
		}
		private function processText(ownerID:String, text:String):String {
			var c:String;
			if (ownerID==clientUserName) {
				c=AppCfg.STYLE_CHAT_OUTGOING_MSG_TEXT_COLOR;
			} else if (ownerID==MChat.S_ID_USER_ID_CLIENT) {
				c=AppCfg.STYLE_CHAT_CLIENT_MSG_TEXT_COLOR
			} else {
				c=AppCfg.STYLE_CHAT_INCOMING_MSG_TEXT_COLOR
			}
			//LOG(0,[ownerID,clientUserName,MChat.S_ID_USER_ID_CLIENT],2)
			//LOG(0,c,2)
			return Text.helperHTML_Color(text, c);
		}
		
		private function displayChatMessage(a:DUChatMessage):void {
			var s2:String="";
			if (a.get_userID()!=MChat.S_ID_USER_ID_CLIENT) {
				s2=processText(a.get_userID(), a.get_userDisplayName())+'>';
			}
			vc.addToOutText(
				'[%] '.replace('%', a.get_time())
				+s2
				+processText(a.get_userID(), a.get_text())+'\n'
			);
		}
		
		private function setVisibility(target:DisplayObject, a:Boolean):void {
			if (!target) {return;}target.visible = a;
		}
		
		private function configureVC():void {
			vc.construct(cl);
			vc.setListener(el_chat);
		}
		
/*		private function createAvatarSmallPicture(a:String):DisplayObject {
			var s:Sprite=new Sprite;
			s.graphics.beginFill(0,0);
			s.graphics.drawRect(0, 0, AppCfg.CHAT_CL_CONTACT_AVATAR_W, AppCfg.CHAT_CL_CONTACT_AVATAR_H);
			s.addChild(new Im(p, null, null
				,function(a:Im):void {
					Utils.resizeDO(a, AppCfg.CHAT_CL_CONTACT_AVATAR_W, AppCfg.CHAT_CL_CONTACT_AVATAR_H)
					Utils.centerDO(a, s.getRect(s))
				}
				,function(a:Im, errorOccured:Boolean):void {
					// TODO: display default user picture
				}
			));
			
			return s;
		}
*/		
		public static function createAvatarSmallPicture(a:String, w:uint, h:uint):DisplayObject {
			var s:Sprite=new Sprite;
			s.graphics.beginFill(0,0);s.graphics.drawRect(0, 0, w, h);
			
			var defaultIm:DisplayObject=PictureStoreroom.getPicture('default_user_picture');
				s.addChild(defaultIm);
				Utils.resizeDO(defaultIm, w, h);
				Utils.centerDO(defaultIm, new Rectangle(0,0,w,h));
			if (a==null||a.length<1) {
				LOG(3,'createAvatarSmallPicture>image path is empty or null',1);return s;
			}
			
			var p:String=(a.indexOf('?')!=-1)?'&r=':+'?r=';
			p=String(a)+String((a.indexOf('?')!=-1)?'&r=':'?r=')+String(uint(Math.random()*999999999));
			//LOG(0,'createAvatarSmallPicture<<<<<, p='+p,1)
			//s.addChild(new Im((a+'?rnd='+int(Math.random()*int.MAX_VALUE)),null,null,
			s.addChild(new Im(p,null,null,
				function (a:Im):void {
					//LOG(0,'loaded>><<<<',1)
					defaultIm.parent.removeChild(defaultIm);
					defaultIm=null;
					Utils.resizeDO(a, w, h);
					Utils.centerDO(a, new Rectangle(0,0,w,h));
				}
				,function (a:Im, r:Boolean):void {
					//LOG(0,'[[[[[[[[[[[[[]]]]]]]]]]]]] default, p='+p,2)
				}
			));
			
			
			return s;
		}
		
		
		
		private function el_chat (target:VCChat, eventType:String):void {
			switch (eventType) {
			
			case VCChat.ID_E_BUTTON_SEND:
				get_envRef().listen(ID_E_TEXT_INPUT, vc.getTextInput(VCChat.ID_TEXT_IN_0));
				break;
			
			case VCChat.ID_E_IT_FOCUS_IN:
			case VCChat.ID_E_IT_FOCUS_OUT:
				get_envRef().listen(ID_E_IT_FOCUS, eventType==VCChat.ID_E_IT_FOCUS_IN);
				break;
			
			}
			
		}
		
		private function el_contact (target:VCChatContactsListElement, eventType:String):void {
			LOG(3,'contact action:id='+target.get_id()+' eventType='+eventType, 0);
			
			switch (eventType) {
			
			case VCChatContactsListElement.EVENT_ELEMENT_SELECTED:
				// insert name
				vc.setTextInput(VCChat.ID_TEXT_IN_0, APP.lText().get_TEXT(Text.ID_TEXT_CHAT_CL_DEAR)+' '+DUChatAdaptorUser(userList_D[target.get_id()]).get_displayName()+', ');
				vc.setItFocus();
				break;
			
			case VCChatContactsListElement.EVENT_ELEMENT_STATE_CHANGED:
				var id:String=DUChatAdaptorUser(userList_D[target.get_id()]).get_name();
				get_envRef().listen(ID_E_CHAT_BAN, id);
				break;
			
			}
		}
		
		
		//{ =*^_^*= private 
		private var vc:VCChat;
		// contacts list
		private var cl:VCChatContactsList;	
		private function get e():AEApp {return get_envRef();}
		private var a:Application;
		/**
		 * [DUChatAdaptorUser]
		 */
		private var userList_D:Array;
		private var clientUserName:String;
		//} =*^_^*= END OF private
		
		
		//{ =*^_^*= id
		/**
		 * [DUChatAdaptorUser]
		 */
		public static const ID_A_DISPLAY_USER_LIST:String = NAME + '>ID_A_DISPLAY_USER_LIST';
		/**
		 * data:[DUChatMessage]
		 */
		public static const ID_A_DISPLAY_MESSAGES:String = NAME + '>ID_A_DISPLAY_MESSAGES';
		/**
		 * data:String
		 */
		public static const ID_A_SET_TEXT_INPUT:String = NAME + '>ID_A_SET_TEXT_INPUT';
		public static const ID_A_CLEAR_TEXT_OUTPUT:String = NAME + '>ID_A_CLEAR_TEXT_OUTPUT';
		/**
		 * data:VCChat
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
		 * data:String//userName(id)
		 */
		public static const ID_A_SET_REQUIRED_DATA:String=NAME+'>ID_A_SET_REQUIRED_DATA';
		
		
		/**
		 * user has pressed "enter" key or "send message" button
		 * data:String
		 */
		public static const ID_E_TEXT_INPUT:String = NAME + '>ID_E_TEXT_INPUT';
		/**
		 * data:Boolean
		 */
		public static const ID_E_IT_FOCUS:String = NAME + '>ID_E_IT_FOCUS';
		/**
		 * String//userID//
		 */
		public static const ID_E_CHAT_BAN:String = NAME + '>ID_E_CHAT_BAN';
		//} =*^_^*= END OF id
		
		public override function autoSubscribeEvents():Array {
			return [
				ID_A_REGISTER_SINGLETON_VC
				,ID_A_SET_VISIBILITY
				,ID_A_SET_WINDOW_XYWH
				,ID_A_SET_REQUIRED_DATA
				,ID_A_DISPLAY_MESSAGES
				,ID_A_DISPLAY_USER_LIST
				,ID_A_SET_TEXT_INPUT
				,ID_A_CLEAR_TEXT_OUTPUT
				,MUserData.ID_E_USER_CHAT_BANNED_OFF
				,MUserData.ID_E_USER_CHAT_BANNED_ON
			];
		}
		
		public static const NAME:String = 'VCMChat';
	}
}


//{ =*^_^*= History
/* > (timestamp) [ ("+" (added) ) || ("-" (removed) ) || ("*" (modified) )] (text)
 * > 
 */
//} =*^_^*= END OF History

// template last modified:11.03.2011_[18#51#40]_[5]