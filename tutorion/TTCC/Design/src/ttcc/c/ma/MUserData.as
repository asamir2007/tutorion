// Project TTCC
package ttcc.c.ma {
	
	//{ =*^_^*= import
	import ttcc.Application;
	import ttcc.c.ae.AEApp;
	import ttcc.c.vcm.VCMMainScreen;
	import ttcc.cfg.SP;
	import ttcc.d.a.ARO;
	import ttcc.d.a.DUAIUserAccessInfo;
	import ttcc.d.a.DUAUserInfo;
	import ttcc.d.a.DUUD;
	import ttcc.d.DUA;
	import ttcc.d.DUAI;
	import ttcc.n.a.FMSServerAdaptor;
	import ttcc.n.a.FMSSOUDAdaptor;
	import ttcc.n.connectors.NetConnector;
	//} =*^_^*= END OF import
	
	
	/**
	 * store & ctrl user data, dispatch events like "login" "chat user started typing"
	 * @author Jinanoimatey Dragoncat
	 * @version 0.0.0
	 * @created 29.05.2012 8:11
	 */
	public class MUserData extends AM {
		
		//{ =*^_^*= CONSTRUCTOR
		
		function MUserData (app:Application) {
			super(NAME);
			a=app;
		}
		//} =*^_^*= END OF CONSTRUCTOR
		
		
		public override function listen(eventType:String, details:Object):void {
			var r:ARO;
			var targetDU:DUUD;
			switch (eventType) {
			
			case ID_A_PREPARE_AND_CONNECT:
				// prepare adaptors
				break;
				nca=new FMSServerAdaptor();
				nca.construct(el_nca, a.get_fmsNetConnectorRef());
				
				soa=new FMSSOUDAdaptor();
				soa.construct(el_soa, a.get_ds().get_startupPathsList().get_userName());
				soa.preapareAndConnectSharedObject(a.get_fmsNetConnectorRef().get_nc());
				break;
				
			case ID_A_GET_USER_LIST_REF:
				break;
				e.listen(ID_E_USER_LIST_REF, soa.get_userListCopyRefOnly());
				break;
				
			case ID_A_REQUEST_USER_DATA_ACCESS_MEANS:
					//sendDataAccessorAndInfo(details.ownerID, details.targetID, details.customer);
				break;
				
			case ID_A_SET_USER_PROPERTY_STREAM_IS_ON:
				targetDU=details;
				sendSetUserProperty(targetDU.get_id(), SP.SHARED_OBJECT_USER_PROPERTY_STREAM_ON, uint(targetDU.get_streamingIsOn()));
				break;
			case ID_A_SET_USER_PROPERTY_HAND_IS_UP:
				targetDU=details;
				sendSetUserProperty(targetDU.get_id(), SP.SHARED_OBJECT_USER_PROPERTY_HAND_UP, uint(targetDU.get_handIsUp()));
				break;
			case ID_A_SET_USER_PROPERTY_CHAT_TYPING:
				targetDU=details;
				sendSetUserProperty(targetDU.get_id(), SP.SHARED_OBJECT_USER_PROPERTY_CHAT_TYPING, uint(targetDU.get_chatIsTyping()));
				break;
			case ID_A_SET_USER_PROPERTY_CHAT_BAN:
				targetDU=(details.du);
				sendSetUserProperty(targetDU.get_id(), SP.SHARED_OBJECT_USER_PROPERTY_CHAT_BANNED, uint(details.v));
				break;
				
			case ID_A_CHECK_LECTOR_IS_PRESENT:
				checkIfLectorIsPresent();
				break;
				
			}
		}
		
		private function constructAndGetAccessorInfo(ownerID:String, targetID:String):DUAIUserAccessInfo {
			var duai:DUAIUserAccessInfo=new DUAIUserAccessInfo();
			duai.construct(ownerID);
			if (ownerID==null) {//full access
				duai.sp(DUAIUserAccessInfo.ID_A_W__CHAT_TYPING, DUAI.ID_ACCESS_ALLOW_AND_LOG);
				duai.sp(DUAIUserAccessInfo.ID_A_W__HAND_UP, DUAI.ID_ACCESS_ALLOW_AND_LOG);
				duai.sp(DUAIUserAccessInfo.ID_A_W__STREAM_SOUND_ON, DUAI.ID_ACCESS_ALLOW_AND_LOG);
				duai.sp(DUAIUserAccessInfo.ID_A_W__STREAMING_ON, DUAI.ID_ACCESS_ALLOW_AND_LOG);
				duai.sp(DUAIUserAccessInfo.ID_A_W__STREAMNAME, DUAI.ID_ACCESS_ALLOW_AND_LOG);
				duai.sp(DUAIUserAccessInfo.ID_A_W__CHAT_BAN, DUAI.ID_ACCESS_ALLOW_AND_LOG);
				return duai;
			}
			// TODO: depend on targetID and ownerID determine and record permissions list
			return null;
		}
		
		private function sendDataAccessorAndInfo(ownerID:String, targetID:String, customer:String):void {
			var dua:DUA=new DUAUserInfo; 
			var ud:DUUD=getUserDUByID(targetID);
			if (!ud) {log(4, 'FATAL ERROR: FAILED:'+ID_A_REQUEST_USER_DATA_ACCESS_MEANS+'; arguments:'[customer, ownerID, targetID], 2);return;}
			dua.construct(el_accessor, ud);
			
			// TODO:null below means: permission construction is not implemented yet - grant full access
			var duai:DUAI=constructAndGetAccessorInfo(null, targetID);
			
			e.listen(ID_E_USER_DATA_ACCESS_MEANS, {customer:customer, ownerID:ownerID, targetID:targetID, dua:dua, duai:duai});
		}
		
		private function getUserDUByID(uid:String):DUUD {
			var list:Array=soa.get_userListCopyRefOnly();
			for each(var i:DUUD in list) {if (i.get_id()==uid) {return i;}}
			return null;
		}
		
		private function el_nca(target:FMSServerAdaptor, eventType:String, eventData:Object):void {
			// listen for events(typically errors, and error details in status)
			switch (eventType) {
			
			case FMSServerAdaptor.ID_E_ERR_NC_NOT_CONNECTED:
			case FMSServerAdaptor.ID_E_ERR_RESULT_ERROR:
			case FMSServerAdaptor.ID_E_ERR_STATUS_ERROR:
				log(5, NAME+'>'+eventType+eventData, 2);
				e.listen(ID_E_FAILED_TO_CONNECT, null);
				break;
				
			case FMSServerAdaptor.ID_E_RESULT_SUCCESS:
				//nothing
				break;
			
			}
		}
		
		private function el_soa(target:FMSSOUDAdaptor, eventType:uint, eventData:Object):void {
			// forward events to the system
			switch (eventType) {
			
			case FMSSOUDAdaptor.ID_E_CLIENT_USER_DATA_READY:
				accessor=new DUAUserInfo();
				accessor.construct_DUAUserInfo(el_accessor, eventData);//data holder
				duai=constructAndGetAccessorInfo(null, DUUD(eventData).get_id());//all permissions granted
				
				var ul:Array=soa.get_userListCopyRefOnly();
				for each(var i:DUUD in ul) {a.get_ds().addUser(i);}
				
				e.listen(ID_E_CONNECTED, eventData);
				break;
				
			case FMSSOUDAdaptor.ID_E_USER_LOGIN:
				a.get_ds().addUser(eventData);
				e.listen(ID_E_USER_LOGIN, eventData);
				if (!a.get_ds().get_clientUserData().get_isLector()) {checkIfLectorIsPresent();}
				break;
				
			case FMSSOUDAdaptor.ID_E_USER_LOGOUT:
				a.get_ds().removeUser(eventData);
				e.listen(ID_E_USER_LOGOUT, eventData);
				if (!a.get_ds().get_clientUserData().get_isLector()) {checkIfLectorIsPresent();}
				break;
			
			case FMSSOUDAdaptor.ID_E_USER_DATA_UPDATED:
				processDataUpdatedEvent(eventData);
				break;
				
			}
		}
		
		private function checkIfLectorIsPresent():void {
			return;
			for each(var i:DUUD in a.get_ds().get_userList()) {
				if (i.get_isLector()) {
					// hide no lector msg
					e.listen(VCMMainScreen.ID_A_DISPLAY_NO_LECTOR_MESSAGE, false);
					return;
				}
			}
			// show no lector msg
			e.listen(VCMMainScreen.ID_A_DISPLAY_NO_LECTOR_MESSAGE, true);
		}
		
		private function el_accessor(target:DUA, eventType:uint, eventData:Object):void {
			if (eventType!=DUA.ID_E_ACCESS_GRANTED) {return;}
			var accessor:DUUD=getUserDUByID(DUAI(eventData.i).get_ownerID());
			var targetDU:DUUD=eventData.t;
			
			switch (eventData.a) {
			
			case DUAIUserAccessInfo.ID_A_W__HAND_UP:
				sendSetUserProperty(targetDU.get_id(), SP.SHARED_OBJECT_USER_PROPERTY_HAND_UP, uint(targetDU.get_handIsUp()));
				break;			
			case DUAIUserAccessInfo.ID_A_W__CHAT_TYPING:
				sendSetUserProperty(targetDU.get_id(), SP.SHARED_OBJECT_USER_PROPERTY_CHAT_TYPING, uint(targetDU.get_chatIsTyping()));
				break;
			case DUAIUserAccessInfo.ID_A_W__CHAT_BAN:
				sendSetUserProperty(targetDU.get_id(), SP.SHARED_OBJECT_USER_PROPERTY_CHAT_BANNED, uint(targetDU.get_isBannedChat()));
				break;
			case DUAIUserAccessInfo.ID_A_W__STREAMING_ON:
				sendSetUserProperty(targetDU.get_id(), SP.SHARED_OBJECT_USER_PROPERTY_STREAM_ON, uint(targetDU.get_streamingIsOn()));
				break;
			
			
			
			}
		}
		
		/*private function el_accessorClientUser(target:DUA, eventType:uint, eventData:Object, accessor:DUUD):void {
			switch (eventData.a) {
			
			case DUAIUserAccessInfo.ID_A_W__STREAM_SOUND_ON:
				sendSetUserProperty(targetDU.get_id(), SP.SHARED_OBJECT_USER_PROPERTY_SOUND_ON, true);
				break;
			case DUAIUserAccessInfo.ID_A_W__STREAMING_ON:
				sendSetUserProperty(targetDU.get_id(), SP.SHARED_OBJECT_USER_PROPERTY_STREAM_ON, uint(targetDU.get_streamingIsOn()));
				break;
			}
			
		}*/
		
		
		private function processDataUpdatedEvent(eventData:Object):void {
			//log(0, "DATA_UPDATED:"+eventData, 1);
				
			var u:DUUD=eventData.u;
			//if (u.get_id()==a.get_ds().get_clientUserData().get_id()) {a.get_ds().set_clientUserData(u);}
			
			switch (eventData.pid) {
			
			case FMSSOUDAdaptor.ID_UD_P_I_UNKNOWN_USER_DATA_PROPERTY_NAME:
				// log
				log(6, 'unknown user data has been changed', 1);
				break;
			
			case FMSSOUDAdaptor.ID_UD_P_I_CHAT_TYPING:
				// dispatch event
				e.listen((u.get_chatIsTyping())?ID_E_USER_CHAT_TYPING_ON:ID_E_USER_CHAT_TYPING_OFF, u);
				break;
			
			case FMSSOUDAdaptor.ID_UD_P_I_CHAT_BANNED:
				// dispatch event
				e.listen((u.get_isBannedChat())?ID_E_USER_CHAT_BANNED_ON:ID_E_USER_CHAT_BANNED_OFF, u);
				break;
			
			case FMSSOUDAdaptor.ID_UD_P_I_HAND_UP:
				// dispatch event
				e.listen((u.get_handIsUp())?ID_E_USER_HAND_UP:ID_E_USER_HAND_DOWN, u);
				break;
				
			case FMSSOUDAdaptor.ID_UD_P_I_SOUND_ON:
				// dispatch event
				e.listen((u.get_streamSoundIsOn())?ID_E_USER_SOUND_ON:ID_E_USER_SOUND_OFF, u);
				break;
				
			case FMSSOUDAdaptor.ID_UD_P_I_STREAM_NAME:
				// dispatch event
				e.listen((u.get_streamingIsOn())?ID_E_USER_STREAM_NAME_PRESENT:ID_E_USER_STREAM_NAME_IS_EMPTY, u);
				break;
			
			case FMSSOUDAdaptor.ID_UD_P_I_STREAM_ON:
				// dispatch event
				e.listen((u.get_streamingIsOn())?ID_E_USER_STREAM_ON:ID_E_USER_STREAM_OFF, u);
				break;			
				
			}
		}
		
		//{ =*^_^*= private 
		
		private function sendSetUserProperty(userID:String, propertyName:String, propertyValue:Object):void {
			log(5, 'sendSetUserProperty, userID='+userID+'propertyName='+propertyName+'propertyValue='+propertyValue,0);
			nca.call(SP.METHOD_RTMP_SET_USER_DATA_PROPERTY, [userID, propertyName, propertyValue]);
		}
		
		
		private var nca:FMSServerAdaptor;
		/**
		 * initialize after fms connector is ready
		 */
		private var soa:FMSSOUDAdaptor;
		private var duai:DUAIUserAccessInfo;
		private var dua:DUA;
		private var accessor:DUAUserInfo;
		//} =*^_^*= END OF private
		
		//{ =*^_^*= actions
		/**
		 * data:{customer:customer id, ownerID:String, targetID:String}
		 */
		public static const ID_A_REQUEST_USER_DATA_ACCESS_MEANS:String=NAME+"ID_A_REQUEST_USER_DATA_ACCESS_MEANS";
		/**
		 * propertyName, propertyValue
		 */
		public static const ID_A_SET_USER_DATA:String=NAME+'ID_A_SET_USER_DATA';
		/**
		 * data:
		 */
		public static const ID_A_PREPARE_AND_CONNECT:String=NAME+'ID_A_PREPARE_AND_CONNECT';
		/**
		 * data:
		 */
		public static const ID_A_GET_USER_LIST_REF:String=NAME+'ID_A_GET_USER_LIST_REF';
		/**
		 * data:DUUD
		 */
		public static const ID_A_SET_USER_PROPERTY_CHAT_TYPING:String=NAME+'ID_A_SET_USER_PROPERTY_CHAT_TYPING';
		/**
		 * data:{du:DUUD, v:Boolean//banned//}
		 */
		public static const ID_A_SET_USER_PROPERTY_CHAT_BAN:String=NAME+'ID_A_SET_USER_PROPERTY_CHAT_BAN';
		/**
		 * data:DUUD
		 */
		public static const ID_A_SET_USER_PROPERTY_HAND_IS_UP:String=NAME+'ID_A_SET_USER_PROPERTY_HAND_IS_UP';
		/**
		 * data:DUUD
		 */
		public static const ID_A_SET_USER_PROPERTY_STREAM_IS_ON:String=NAME+'ID_A_SET_USER_PROPERTY_STREAM_IS_ON';
		public static const ID_A_CHECK_LECTOR_IS_PRESENT:String=NAME+'ID_A_CHECK_LECTOR_IS_PRESENT';
		//} =*^_^*= END OF actions
		
		//{ =*^_^*= events
		//public static const ID_E_USER_DATA_CHANGED:String=NAME+'ID_E_USER_DATA_CHANGED';
		/**
		 * data:DUUD// client user data
		 */
		public static const ID_E_CONNECTED:String=NAME+'ID_E_CONNECTED';
		/**
		 * data:
		 */
		public static const ID_E_FAILED_TO_CONNECT:String=NAME+'ID_E_FAILED_TO_CONNECT';
		/**
		 * data:DUUD
		 */
		public static const ID_E_USER_LOGIN:String=NAME+"ID_E_USER_LOGIN";
		/**
		 * data:DUUD
		 */
		public static const ID_E_USER_LOGOUT:String=NAME+"ID_E_USER_LOGOUT";
		
		
		//{ =*^_^*= user data events
		/**
		 * data:DUUD
		 */
		public static const ID_E_USER_HAND_UP:String=NAME+"ID_E_USER_HAND_UP";
		/**
		 * data:DUUD
		 */
		public static const ID_E_USER_HAND_DOWN:String=NAME+"ID_E_USER_HAND_DOWN";
		/**
		 * data:DUUD
		 */
		public static const ID_E_USER_CHAT_TYPING_ON:String=NAME+"ID_E_USER_CHAT_TYPING_ON";
		/**
		 * data:DUUD
		 */
		public static const ID_E_USER_CHAT_TYPING_OFF:String=NAME+"ID_E_USER_CHAT_TYPING_OFF";
		/**
		 * data:DUUD
		 */
		public static const ID_E_USER_CHAT_BANNED_ON:String=NAME+"ID_E_USER_CHAT_BANNED_ON";
		/**
		 * data:DUUD
		 */
		public static const ID_E_USER_CHAT_BANNED_OFF:String=NAME+"ID_E_USER_CHAT_BANNED_OFF";
		/**
		 * data:DUUD
		 */
		public static const ID_E_USER_SOUND_ON:String=NAME+"ID_E_USER_SOUND_ON";
		/**
		 * data:DUUD
		 */
		public static const ID_E_USER_SOUND_OFF:String=NAME+"ID_E_USER_SOUND_OFF";
		/**
		 * data:DUUD
		 */
		public static const ID_E_USER_STREAM_NAME_PRESENT:String=NAME+"ID_E_USER_STREAM_NAME_PRESENT";
		/**
		 * data:DUUD
		 */
		public static const ID_E_USER_STREAM_NAME_IS_EMPTY:String=NAME+"ID_E_USER_STREAM_NAME_IS_EMPTY";
		/**
		 * data:DUUD
		 */
		public static const ID_E_USER_STREAM_ON:String=NAME+"ID_E_USER_STREAM_ON";
		/**
		 * data:DUUD
		 */
		public static const ID_E_USER_STREAM_OFF:String=NAME+"ID_E_USER_STREAM_OFF";
		//} =*^_^*= END OF user data events
		
		/**
		 * data:{ownerID:String, targetID:String, dua:DUA, duai:DUAI}
		 */
		public static const ID_E_USER_DATA_ACCESS_MEANS:String=NAME+"ID_E_USER_DATA_ACCESS_MEANS";
		/**
		 * data:[DUUD]
		 */
		public static const ID_E_USER_LIST_REF:String=NAME+"ID_E_USER_LIST_REF";
		//} =*^_^*= END OF events
		
		private function get e():AEApp {return get_envRef();}
		private var a:Application;
		
		public static const NAME:String = 'MUserData';
		
		public override function autoSubscribeEvents():Array {
			return [
				ID_A_PREPARE_AND_CONNECT
				,ID_A_GET_USER_LIST_REF
				,ID_A_SET_USER_DATA
				,ID_A_REQUEST_USER_DATA_ACCESS_MEANS
				,ID_A_SET_USER_PROPERTY_STREAM_IS_ON
				,ID_A_SET_USER_PROPERTY_HAND_IS_UP
				,ID_A_SET_USER_PROPERTY_CHAT_TYPING
				,ID_A_SET_USER_PROPERTY_CHAT_BAN
				,ID_A_CHECK_LECTOR_IS_PRESENT
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