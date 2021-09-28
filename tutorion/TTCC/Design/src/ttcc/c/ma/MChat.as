// Project TTCC
package ttcc.c.ma {
	
	//{ =*^_^*= import
	import org.jinanoimateydragoncat.works.cyber_modules.d.SSTM;
	import ttcc.APP;
	import ttcc.Application;
	import ttcc.c.ae.AEApp;
	import ttcc.c.vcm.VCMChat;
	import ttcc.cfg.SP;
	import ttcc.d.a.ARO;
	import ttcc.d.a.DUChatAdaptorMessage;
	import ttcc.d.a.DUUD;
	import ttcc.d.m.ChatComModel;
	import ttcc.d.v.DUChatMessage;
	import ttcc.media.Text;
	import ttcc.n.a.FMSServerAdaptor;
	import ttcc.n.a.FMSSOChatAdaptor;
	//} =*^_^*= END OF import
	
	
	/**
	 * chat manager - ctrl chat
	 * @author Jinanoimatey Dragoncat
	 * @version 0.0.0
	 * @created 28.05.2012 21:04
	 */
	public class MChat extends ACMM {
		
		//{ =*^_^*= CONSTRUCTOR
		
		function MChat (app:Application) {
			super(NAME);
			a=app;
		}
		//} =*^_^*= END OF CONSTRUCTOR
		
		
		public override function listen(eventType:String, details:Object):void {
			var r:ARO;
			var uu:DUUD;
			switch (eventType) {
			
			case ID_A_PREPARE_MODEL:
				M=new ChatComModel();
				M.construct(NAME+'ComModel');
				M.setViewUpdatesListener(el_M);
				registerModel(a, M);
				break;
				
			case ID_A_CONNECT:
				
				// construct adapter, listen for first "ID_E_END_PROCESS" event,  then send "ID_E_CONNECTED" to env
				//soa=new FMSSOChatAdaptor();
				//soa.construct(el_soa);
				//soa.preapareAndConnectSharedObject(a.get_fmsNetConnectorRef().get_nc());
				//
				//nca=new FMSServerAdaptor();
				//nca.construct(el_nca, a.get_fmsNetConnectorRef());				
				//
				e.listen(ID_E_CONNECTED, null);
				
				break;
				
			case MUserData.ID_E_USER_LOGIN:
				//forward 
				soa.userLoggedIn(details);
				//display in chat
				uu=details;
				addAndDisplayMessage(new DUChatMessage(
					S_ID_USER_ID_CLIENT
					,null
					,APP.lText().secondsToCurrentTime(a.getCurrentTime())
					,APP.lText().getText(Text.ID_TEXT_CHAT_U_LOGGED_IN, [
						(uu.get_displayName()==null)?APP.lText().get_TEXT(Text.ID_TEXT_CHAT_CL_INVISIBLE_USER_NAME):uu.get_displayName()
					])
				));
				break;
			
			case MUserData.ID_E_USER_LOGOUT:
				//forward 
				soa.userLoggedOut(details);
				//display in chat
				uu=details;
				addAndDisplayMessage(new DUChatMessage(
					S_ID_USER_ID_CLIENT
					,null
					,APP.lText().secondsToCurrentTime(a.getCurrentTime())
					,APP.lText().getText(Text.ID_TEXT_CHAT_U_LOGGED_OUT, [
						(uu.get_displayName()==null)?APP.lText().get_TEXT(Text.ID_TEXT_CHAT_CL_INVISIBLE_USER_NAME):uu.get_displayName()
					])
				));
				break;
				
			case MUserData.ID_E_USER_LIST_REF:
				//get users online list
				soa.usersLoggedIn(details);
				e.unsubscribe(this, MUserData.ID_E_USER_LIST_REF);
				break;
				
			/*case MUserData.ID_E_USER_CHAT_TYPING_ON:
				// TODO: 
				break;
				
			case MUserData.ID_E_USER_CHAT_TYPING_OFF:
				// TODO: 
				break;
			*/	
			case VCMChat.ID_E_CHAT_BAN:
				var du:DUUD=a.get_ds().get_userDUByID(details);
				if (!du) {log(7,'VCMChat.ID_E_CHAT_BAN> user not found, id='+details,1);return;}
				e.listen(MUserData.ID_A_SET_USER_PROPERTY_CHAT_BAN, {du:du, v:!du.get_isBannedChat()});
				break;
				
			case VCMChat.ID_E_TEXT_INPUT:
				// send message
				sendTextMessage(details);
				break;
				
			case VCMChat.ID_E_IT_FOCUS:
				e.listen(MUIActions.ID_A_SET_CHAT_TYPING, details);
				break;
				
			}
		}
		
		private function addAndDisplayMessage(a:DUChatMessage):void {
			M.addMessage(a);
		}
		
		private function sendTextMessage(text:String):void {
			if (text.length<1||text==' ') {
				e.listen(VCMChat.ID_A_SET_TEXT_INPUT, '');
				return;
			}
			log(0,'a.get_ds().get_clientUserData().get_isBannedChat()'+a.get_ds().get_clientUserData().get_isBannedChat());
			if (a.get_ds().get_clientUserData().get_isBannedChat()&&lastText!=text) {
				var ddate:Date=new Date;
				var hrs:int=((ddate.getHours()>12)?(ddate.getHours()-12):ddate.getHours());
				var dateText:String=(((hrs<10)?'0':'')+hrs)
				+':'+(((ddate.getMinutes()<10)?'0':'')+ddate.getMinutes())
				+':'+(((ddate.getSeconds()<10)?'0':'')+ddate.getSeconds())
				+' '+((hrs>12)?'PM':'AM');
				
				M.addMessage(new DUChatMessage(
					a.get_ds().get_clientUserData().get_id()
					,a.get_ds().get_clientUserData().get_displayName()
					,dateText
					,text
				));
				
				lastText=text;
				e.listen(VCMChat.ID_A_SET_TEXT_INPUT, '');
				return;
			}
			nca.call(SP.METHOD_RTMP_CHAT_SEND_MSG, [text]);
		}
		private var lastText:String;
		
		
		private function el_soa(target:FMSSOChatAdaptor, eventType:uint, eventData:Object):void {
			//log(0,'el_soa>'+['ID_E_NEW_MESSAGES_LIST','ID_E_NEW_USER_LIST','ID_E_END_PROCESS'][eventType],1)
			// forward events to the system
			switch (eventType) {
			
			case FMSSOChatAdaptor.ID_E_FAILED_TO_CONNECT:
				e.listen(ID_E_CONNECTION_ERROR, null);
				break;
				
			case FMSSOChatAdaptor.ID_E_END_PROCESS:
				if (chatIsNotReady) {
					subscribeToEvents();
					chatIsNotReady=false;
					// addOnlineUsersToTheList
					e.listen(MUserData.ID_A_GET_USER_LIST_REF, null);
					e.listen(ID_E_CONNECTED, null);
				}
				break;
			
			case FMSSOChatAdaptor.ID_E_NEW_MESSAGES_LIST:
				// convert and display messages
				var ml:Array=soa.get_chatMessagesList();
				var vcml:Array=[];
				var du_:DUChatMessage;
				for each(var i:DUChatAdaptorMessage in ml) {
					if (i.get_type()==SP.ID_EVENT_USER_LOGIN||i.get_type()==SP.ID_EVENT_USER_LOGOUT) {continue;}
					du_=new DUChatMessage(i.get_userID(), i.get_userDisplayName(), i.get_time(), i.get_text());
					vcml.push(du_);
					M.addMessage(du_);
				}
				break;
			
			case FMSSOChatAdaptor.ID_E_NEW_USER_LIST:
				M.set_usersList(soa.get_userList());
				break;
			
			}
		}
		
		private function el_nca(target:FMSServerAdaptor, eventType:String, eventData:Object):void {
			if (eventType==FMSServerAdaptor.ID_E_RESULT_SUCCESS) {
				//clear text field
				e.listen(VCMChat.ID_A_SET_TEXT_INPUT, "");
				return;
			}
			//error occured
			log(5, NAME+'>some error occured at el_nca() - responder error', 2);
		}
		
		
		private function subscribeToEvents():void {
			e.subscribe(this, MUserData.ID_E_USER_CHAT_TYPING_ON);
			e.subscribe(this, MUserData.ID_E_USER_CHAT_TYPING_OFF);
			e.subscribe(this, MUserData.ID_E_USER_LOGIN);
			e.subscribe(this, MUserData.ID_E_USER_LOGOUT);
			e.subscribe(this, VCMChat.ID_E_TEXT_INPUT);
			e.subscribe(this, VCMChat.ID_E_IT_FOCUS);
			e.subscribe(this, MUserData.ID_E_USER_LIST_REF);
		}
		private var chatIsNotReady:Boolean=true;
		
		
		//{ =*^_^*= private 
		/**
		 * initialize after fms connector is ready
		 */
		private var soa:FMSSOChatAdaptor;
		private var nca:FMSServerAdaptor;
		//} =*^_^*= END OF private
		
		//{ =*^_^*= model
		/**
		 * @param	a updatedPropertiesIDList
		 */
		private function el_M(targetModel:SSTM, elementID:uint, updateFromDataport:Boolean=false):void {
			switch (elementID) {
			
			case SSTM.ID_P_A_RESET_MODEL:
				//some special actions
				break;
			
			case ChatComModel.ID_P_MESSAGES:
				var nm:Array=M.get_newMessagesList();
				e.listen(VCMChat.ID_A_DISPLAY_MESSAGES, nm);
				break;
				
			case ChatComModel.ID_P_USERS:
				e.listen(VCMChat.ID_A_DISPLAY_USER_LIST, M.get_usersList());
				break;
			
			case ChatComModel.ID_P_CLEAR_MESSAGES:
				e.listen(VCMChat.ID_A_CLEAR_TEXT_OUTPUT, null);
				break;
			
			}
		}
		
		private var M:ChatComModel;
		//} =*^_^*= END OF model
		
		private function get e():AEApp {return get_envRef();}
		private var a:Application;		
		
		//{ =*^_^*= id
		public static const ID_A_CONNECT:String=NAME+'>ID_A_CONNECT';
		public static const ID_A_PREPARE_MODEL:String=NAME+'>ID_A_PREPARE_MODEL';
		//} =*^_^*= END OF id
		
		//{ =*^_^*= events
		public static const ID_E_CONNECTED:String=NAME+'>ID_E_CONNECTED';
		public static const ID_E_CONNECTION_ERROR:String=NAME+'>ID_E_CONNECTION_ERROR';
		//} =*^_^*= END OF events
		
		//{ ^_^ s id
		/**
		 * specifies user id of application(client)
		 */
		public static const S_ID_USER_ID_CLIENT:String="client";
		//} ^_^ END OF s id
		
		public static const NAME:String = 'MChat';
		
		public override function autoSubscribeEvents():Array {
			return [
				ID_A_CONNECT
				,ID_A_PREPARE_MODEL
				,VCMChat.ID_E_CHAT_BAN
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