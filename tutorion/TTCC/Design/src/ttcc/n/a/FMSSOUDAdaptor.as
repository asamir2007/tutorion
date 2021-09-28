// Project Connect
package ttcc.n.a {
	
	//{ =*^_^*= import
	import flash.events.SyncEvent;
	import flash.net.NetConnection;
	import flash.net.Responder;
	import flash.net.SharedObject;
	import ttcc.cfg.SP;
	import ttcc.d.a.DUUD;
	import ttcc.LOG;
	//} =*^_^*= END OF import
	
	
	/**
	 * FMSSharedObjectUserDataAdaptor
	 * listens to server's events and converts data format(server->application)
	 * @author Jinanoimatey Dragoncat
	 * @version 0.0.0
	 * @created 06.06.2012 1:30
	 */
	public class FMSSOUDAdaptor {
		
		//{ =*^_^*= CONSTRUCTOR
		function FMSSOUDAdaptor () {}
		/**
		 * 
		 * @param	eventListener function(target:FMSSOUDAdaptor, eventType:uint, eventData:Object):void
		 */
		public function construct(eventListener:Function, clientUserName:String):void {
			if (eventListener==null) {throw new ArgumentError('eventListener==null');}
			if (clientUserName==null) {throw new ArgumentError('clientUserName==null');}
			
			username=clientUserName;
			el=eventListener;
		}
		public function destruct():void {
		}
		//} =*^_^*= END OF CONSTRUCTOR
		
		//{ =*^_^*= user access
		
		public function preapareAndConnectSharedObject(ncReference:NetConnection):void {
			so=SharedObject.getRemote(SP.SHARED_OBJECT_NAME_USER_DATA_AND_EVENTS, ncReference.uri, true);
			so.addEventListener(SyncEvent.SYNC, el_so);
			so.connect(ncReference);
		}
		
		/**
		 * actual user list, FOR REFERENCE ONLY! DO NOT EDIT!
		 * @return [DUUD]
		 */
		public function get_userListCopyRefOnly():Array {return userList.slice();}
		
		//} =*^_^*= END OF user access
		
		/**
		* el_so() -- handle changes on fms
		**/
		private function el_so(e:SyncEvent):void {
			//LOG(5, 'SyncEvent');
			if (!dataIsReady) {
				if (so.data.ready) {
					if (SO_getUserIndex(username) == -1) {
						//LOG(5, 'SyncEvent wrong data', 1);
						return;// ^_^ ingore that, wait for correct data
					}
					dataIsReady=true;
					data=so.data.users;// cache data
					SO_updateUserListMap();// convert data
					//LOG(5, 'el');
					el(this, ID_E_CLIENT_USER_DATA_READY, getDUByName(username));
				}
				return;
			}
			
			if (!dataIsReady) {return;}
			
			data=so.data.users;// cache data
			SO_updateUserListMap();// convert data
			
			var l:Object=so.data.last;// ^_^ last operation
			switch(l.type) {
			
				case SP.ID_EVENT_USER_LOGIN:// user logged in(ANY user) ^_^
					el(this, ID_E_USER_LOGIN, getDUByName(l.user));
					break;
				case SP.ID_EVENT_USER_LOGOUT://user logged out(ANY user) ^_^
					// remove from list
					el(this, ID_E_USER_LOGOUT, removeDUByName(l.user));
					break;
				case SP.ID_EVENT_USER_DATA_UPDATED:// some user data updated ^_^
					// detect which user data has been changed; dispatch event;
					el(this, ID_E_USER_DATA_UPDATED, {u:getDUByName(l.user), pid:LIST_UD_P_N.indexOf(l.attrib)});
					break;
					
				default:
					el(this, ID_E_USER_LOGIN, getDUByName(l.user));
					break;
					
			}
		}
		
		
		
		//{ =*^_^*= id
		/**
		 * data:DUUD
		 */
		public static const ID_E_USER_LOGIN:uint=0;
		/**
		 * data:DUUD
		 */
		public static const ID_E_USER_LOGOUT:uint=1;
		/**
		 * data:{u:DUUD, pid:user_data_property_id}
		 */
		public static const ID_E_USER_DATA_UPDATED:uint=2;
		/**
		 * data:DUUD//client user data
		 */
		public static const ID_E_CLIENT_USER_DATA_READY:uint=3;
		//} =*^_^*= END OF id
		
		
		//{ =*^_^*= events
		//public function setListener(a:Function):void {el=a;}
		private var el:Function;
		//} =*^_^*= END OF events
		
		//{ =*^_^*= private 
		/**
		* ^_^
		* 	contains user data
		* , last operation 
		* , ready - the data on server is valid, can proceed
		*/
		private var so:SharedObject;
		
		/**
		* ^_^ can do something( valid data)
		* used at event dispatch
		*/
		private var dataIsReady:Boolean;
		private var username:String;
		private var data:Array;
		private var userList:Array;		
		//private var deletedUserList:Vector.<DUUD>;		
		private var userListByName:Object;		
		//} =*^_^*= END OF private
		
		//{ =*^_^*= =*^_^*= low level -- shared object
		private function SO_getUserIndex(name:String):int {
			var arr:Array=so.data.users;
			var l:int=arr.length;
			for (var i:int=0;i<l;i++) {
				if (arr[i].name==name) {return i;}
			}
			return -1;
		}
		/**
		* ^_^ update user list
		**/
		private function SO_updateUserListMap():void {
			if (!userList) {userList=[];}
			if (!userListByName) {userListByName={};}
			
			// convert server data to app data
			var l:int=data.length;
			var n:String;
			var nu:DUUD;
			var names:Array=[];
			for (var i:int=0;i<l;i++) {
				n=data[i].name;
				names.push(n);
				
				nu=userListByName[n];
				if (userListByName[n]==null) {//not in list
					//create
					nu=new DUUD();nu.construct(data[i].name);
					userList.push(nu);
					//add to list
					userListByName[n]=nu;
				}
				//sync
				convertRawToDU(nu, data[i]);
			}
			
			for each(var uu:DUUD in userList) {
				if (names.indexOf(uu.get_name())==-1) {//missing user(removed by server)
					userList.splice(userList.indexOf(uu), 1);//sync
				}
			}
			
		}
		
		private function convertRawToDU(du:DUUD, raw:Object):DUUD {
			du.set_avatarPicture(raw[LIST_UD_P_N[ID_UD_P_I_AVATAR_PICTURE]]);
			du.set_avatarPictureSmall(raw[LIST_UD_P_N[ID_UD_P_I_AVATAR_PICTURE_SMALL]]);
			du.set_isBannedChat(raw[LIST_UD_P_N[ID_UD_P_I_CHAT_BANNED]]);
			du.set_chatIsTyping(raw[LIST_UD_P_N[ID_UD_P_I_CHAT_TYPING]]);
			du.set_displayName(raw[LIST_UD_P_N[ID_UD_P_I_DISPLAY_NAME]]);
			du.set_handIsUp(raw[LIST_UD_P_N[ID_UD_P_I_HAND_UP]]);
			du.set_isLector(raw[LIST_UD_P_N[ID_UD_P_I_IS_LECTOR]]);
			//du.set_(raw[LIST_UD_P_N[ID_UD_P_I_NAME]]);
			du.set_streamSoundIsOn(raw[LIST_UD_P_N[ID_UD_P_I_SOUND_ON]]);
			du.set_streamName(raw[LIST_UD_P_N[ID_UD_P_I_STREAM_NAME]]);
			du.set_streamingIsOn(raw[LIST_UD_P_N[ID_UD_P_I_STREAM_ON]]);
			return du;
		}
		
		private function getDUByName(name:String):DUUD {
			return userListByName[name];
		}
		private function removeDUByName(name:String):DUUD {
			var du:DUUD=userListByName[name];
			du.set_loggedIn(false);
			userListByName[name] = null;
			return du;
		}
		//} =*^_^*= =*^_^*= END OF low level -- shared object
		
		
		
		//{ =*^_^*= server protocol details
		private static const LIST_UD_P_N:Array=[//{
			SP.SHARED_OBJECT_USER_PROPERTY_STREAM_ON
			,SP.SHARED_OBJECT_USER_PROPERTY_STREAM_NAME
			,SP.SHARED_OBJECT_USER_PROPERTY_SOUND_ON
			,SP.SHARED_OBJECT_USER_PROPERTY_CHAT_TYPING
			,SP.SHARED_OBJECT_USER_PROPERTY_HAND_UP
			,SP.SHARED_OBJECT_USER_PROPERTY_CHAT_BANNED
			,'name'
			,'lector'
			,'username2'
			,'ava_small'
			,'ava'
		];//}
		
		
		/**
		 * user_data_property_id
		 */
		public static const ID_UD_P_I_UNKNOWN_USER_DATA_PROPERTY_NAME:int=-1;
		/**
		 *  устанавливается лектором чтобы дать слово. Сервер обрабатывает этот флаг и выставляет streamName
		 * user_data_property_id
		 */
		public static const ID_UD_P_I_STREAM_ON:int=00;//LIST_UD_P_N.indexOf('streamingUser');
		/**
		 * stream name to connect to
		 * user_data_property_id
		 */
		public static const ID_UD_P_I_STREAM_NAME:int=01;//LIST_UD_P_N.indexOf('streamName');
		
		// TODO: remove from application
		public static const ID_UD_P_I_SOUND_ON:int=02;//LIST_UD_P_N.indexOf('streamMuted');
		/**
		 * user_data_property_id
		 */
		public static const ID_UD_P_I_CHAT_TYPING:int=03;//LIST_UD_P_N.indexOf('chatTyping');
		/**
		 * user_data_property_id
		 */
		public static const ID_UD_P_I_HAND_UP:int=04;//LIST_UD_P_N.indexOf('handUp');
		/**
		 * user_data_property_id
		 */
		public static const ID_UD_P_I_CHAT_BANNED:int=05;//LIST_UD_P_N.indexOf('chatBan');
		/**
		 * user_data_property_id
		 */
		private static const ID_UD_P_I_NAME:int=06;//LIST_UD_P_N.indexOf('name');
		/**
		 * user_data_property_id
		 */
		private static const ID_UD_P_I_IS_LECTOR:int=07;//LIST_UD_P_N.indexOf('lector');
		/**
		 * user_data_property_id
		 */
		private static const ID_UD_P_I_DISPLAY_NAME:int=08;//LIST_UD_P_N.indexOf('username2');
		/**
		 * user_data_property_id
		 */
		private static const ID_UD_P_I_AVATAR_PICTURE_SMALL:int=09;//LIST_UD_P_N.indexOf('ava_small');
		/**
		 * user_data_property_id
		 */
		private static const ID_UD_P_I_AVATAR_PICTURE:int=10;//LIST_UD_P_N.indexOf('ava');
		//} =*^_^*= END OF server protocol details
		
	}
}

//{ =*^_^*= History
/* > (timestamp) [ ("+" (added) ) || ("-" (removed) ) || ("*" (modified) )] (text)
 * > 
 */
//} =*^_^*= END OF History

// template last modified:11.03.2011_[18#51#40]_[5]