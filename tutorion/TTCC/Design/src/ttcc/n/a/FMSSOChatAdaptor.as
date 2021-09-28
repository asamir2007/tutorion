// Project Connect
package ttcc.n.a {
	
	//{ =*^_^*= import
	import flash.events.SyncEvent;
	import flash.net.NetConnection;
	import flash.net.Responder;
	import flash.net.SharedObject;
	import ttcc.cfg.SP;
	import ttcc.d.a.DUChatAdaptorMessage;
	import ttcc.d.a.DUChatAdaptorUser;
	import ttcc.d.a.DUUD;
	import ttcc.LOG;
	//} =*^_^*= END OF import
	
	
	/**
	 * FMSSharedObjectChatAdaptor
	 * listens to server's events and converts data format(server->application)
	 * @author Jinanoimatey Dragoncat
	 * @version 0.0.0
	 * @created 09.06.2012 20:00
	 */
	public class FMSSOChatAdaptor {
		
		//{ =*^_^*= CONSTRUCTOR
		function FMSSOChatAdaptor () {
			defaultUserList=[new DUChatUser('FMS', 'FMS', null, null, false, true)];
		}
		/**
		 * 
		 * @param	eventListener function(target:FMSSOChatAdaptor, eventType:uint, eventData:Object):void
		 */
		public function construct(eventListener:Function):void {
			if (eventListener==null) {throw new ArgumentError('eventListener==null');}
			
			el=eventListener;
		}
		public function destruct():void {
		}
		//} =*^_^*= END OF CONSTRUCTOR
		
		//{ =*^_^*= user access
		public function preapareAndConnectSharedObject(ncReference:NetConnection):void {
			try {
				so=SharedObject.getRemote(SP.SHARED_OBJECT_NAME_CHAT, ncReference.uri, true);//throw
				so.addEventListener(SyncEvent.SYNC, el_so);
				so.connect(ncReference);//throw
			} catch (e:Error) {
				if (so) {so.removeEventListener(SyncEvent.SYNC, el_so);}
				el(ID_E_FAILED_TO_CONNECT, null);
			}
		}
		
		/**
		 * chat user list 
		 * [DUChatAdaptorUser]
		 */
		public function get_userList():Array {return externalUserList;}
		/**
		 * chat user list for chat interface
		 * [DUChatAdaptorMessage]
		 */
		public function get_chatMessagesList():Array {return chatMessagesList;}
		
		public function userLoggedIn(userRef:DUUD):void {
			addUser(userRef);
		}
		public function usersLoggedIn(usersRefsList:Array):void {
			addUsers(usersRefsList);
		}
		public function userLoggedOut(userRef:DUUD):void {
			removeUser(userRef);
		}
		
		//} =*^_^*= END OF user access
		
		/**
		* el_so() -- handle changes on fms
		**/
		private function el_so(e:SyncEvent):void {
			if (!so.data.ready) {return;}
			
			var o:Object=so.data.chat;
			var messages:Array=[];
			
			if (!internalUserList) {// check if no parsed user list present
				// user list from server
				serverUserListRaw=[];
				externalUserList=[];
				
				var arr:Object=o.usr_cash;
				var el0:Object;
				for (var i:String in arr) {
					el0=arr[i];
					if (el0) {serverUserListRaw.push(el0);}
				}
				
				internalUserList=SO_parseUserList(serverUserListRaw);// convert data
				
				//do not fill external user list with offline users
				/*for each(var n:DUChatUser in internalUserList) {
					externalUserList.push(convertToExternal(n));
				}*/
				
				//el(this, ID_E_NEW_USER_LIST, null);
				
				messages=SO_parseMessagesList(o.msg);// convert data
			}
			
			messages.push(convertRawToDUMessage(null, o.evt));
			processMessagesList(messages);
			
			el(this, ID_E_END_PROCESS, null);
			
		}
		
		
		private function removeUser(u:DUUD):void {
			// find user in internal list, set it's state to offline, remove user from external chat list
			var name:String=u.get_name();
			var iu:DUChatUser=getUserById(name);
			if (!iu) {LOG(2, 'removeUser('+u.getTextRepresentation()+') - no such user in the internal user list', 1);return;}
			iu.set_online(false);
			
			if (removeChatUserByName(name)) {
				el(this, ID_E_NEW_USER_LIST, null);
				return;
			}
			
			LOG(2, 'removeUser('+u.getTextRepresentation()+') - no such user in the external user list', 1);
		}
		
		/**
		 * internal user list
		 */
		private function addUser(u:DUUD):void {
			addUser_(u);
			el(this, ID_E_NEW_USER_LIST, null);
		}
		
		/**
		 * internal user list
		 */
		private function addUsers(arr:Array):void {
			//LOG(0,'addUsers:'+arr,1);
			for each(var u:DUUD in arr) {addUser_(u);}
			el(this, ID_E_NEW_USER_LIST, null);
		}
		
		/**
		 * internal user list
		 */
		private function addUser_(u:DUUD):void {
			// convert user data and add user to list
			var cu:DUChatUser=getUserById(u.get_name());
			if (cu) {
				//LOG(0,'the user /'+u+'/ is in list, set online flag',1);
				cu.set_online(true);
				//check wether user present in external list
				var eu:DUChatAdaptorUser=getExtUserById(u.get_name())
				if (eu==null) {
					externalUserList.push(convertToExternal(cu));
				}
				//LOG(2, 'addUsers('+u.getTextRepresentation()+') - user is already in the external user list', 1);
				return;
			}
			//LOG(0,'user not found, creating new',1);
			cu=new DUChatUser(
				u.get_name()
				,u.get_displayName()
				,u.get_avatarPictureSmall()
				,u.get_avatarPicture()
				,u.get_isLector()
				,true
			);
			
			internalUserList.push(cu);
			externalUserList.push(convertToExternal(cu));
		}
		
		private function processMessagesList(a:Array):void {
			// NOTE: process list before displaying
			chatMessagesList=a;
			el(this, ID_E_NEW_MESSAGES_LIST, null);
		}
		
		
		//{ =*^_^*= id
		/**
		 * failed to connect to shared object
		 */
		public static const ID_E_FAILED_TO_CONNECT:uint=3;
		/**
		 * data has been updated - user list has been changed
		 */
		public static const ID_E_NEW_USER_LIST:uint=1;
		/**
		 * messages list has been changed(new messages)
		 */
		public static const ID_E_NEW_MESSAGES_LIST:uint=0;
		/**
		 * all incoming data has been processed
		 */
		public static const ID_E_END_PROCESS:uint=2;
		//} =*^_^*= END OF id
		
		
		//{ =*^_^*= events
		//public function setListener(a:Function):void {el=a;}
		private var el:Function;
		//} =*^_^*= END OF events
		
		//{ =*^_^*= private 
		private var so:SharedObject;
		
		/**
		* ^_^ can do something( valid data)
		* used at event dispatch
		*/
		private var dataIsReady:Boolean;
		private var serverUserListRaw:Array;
		/**
		 * DUChatUser internal user list
		 */
		private var internalUserList:Array;
		/**
		 * DUChatAdaptorUser external list
		 */
		private var externalUserList:Array;
		/**
		 * DUChatAdaptorMessage
		 */
		private var chatMessagesList:Array;
		//} =*^_^*= END OF private
		
		private static var defaultUserList:Array;
		private static const ID_DEFAULTUSERLIST_FMS:int=0;
		
		//{ =*^_^*= data
		private function convertToExternal(a:DUChatUser):DUChatAdaptorUser {
			var b:DUChatAdaptorUser=new DUChatAdaptorUser();
			b.construct(a.get_name(), a.get_displayName(), a.get_avatarPictureSmall(), a.get_isLector());
			return b;
		}
		/**
		 * internal list
		 * @param	name
		 * @return
		 */
		private function getUserById(name:String):DUChatUser {
			for each(var i:DUChatUser in internalUserList) {
				if (i.get_name()==name) {return i;}
			}
			if (name=='FMS') {
				return defaultUserList[ID_DEFAULTUSERLIST_FMS];
			}
			return null;
		}
		
		/**
		 * internal list
		 * @param	name
		 * @return
		 */
		private function getExtUserById(name:String):DUChatUser {
			for each(var i:DUChatAdaptorUser in externalUserList) {
				if (i.get_name()==name) {return i;}
			}
			return null;
		}
		
		/**
		 * external list
		 * @return removed
		 */
		private function removeChatUserByName(name:String):Boolean {
			//for each(var i:DUChatAdaptorUser in externalUserList) {
			var l:uint = externalUserList.length;
			for (var i:int = 0;i < l;i++ ) {
				if (DUChatAdaptorUser(externalUserList[i]).get_name()==name) {
					externalUserList.splice(i, 1);
					return true;
				}
			}
			return false;
		}
		
		//} =*^_^*= END OF data
		
		//{ =*^_^*= =*^_^*= low level -- shared object
		private function SO_parseUserList(rawServerData:Array):Array {
			if (rawServerData&&rawServerData.length) {
				var res:Array=[];
					
				for each(var i:Object in rawServerData) {
					res.push(convertRawToDUChatUser(null, i, false));
				}
				
				return res;
			}
			return null;
		}
		
		private function SO_parseMessagesList(ml:Array):Array {
			if (ml!=null&&ml.length>0) {
				var res:Array=[];
				
				for each(var i:Object in ml) {
					if (i) {res.push(convertRawToDUMessage(null, i));}
				}
				
				return res;
			}
			return null;
		}
		
		/**
		 * 
		 * @param	du WARNING: du!=null is not supported
		 * @param	online user is online
		 * @param	raw
		 * @return
		 */
		private function convertRawToDUChatUser(du:DUChatUser, raw:Object, online:Boolean):DUChatUser {
			if (!du) {
				return new DUChatUser(
					raw.username
					,raw.username2
					,raw.ava_small
					,raw.ava
					,raw.lector
					,online
					,raw.lastMsg
				);
			}
			return du;
		}
		
		private function convertRawToDUMessage(du:DUChatAdaptorMessage, raw:Object):DUChatAdaptorMessage {
			if (du==null) {
				// TODO: add islector property to DUChatAdaptorMessage instead of '<b>'
				return new DUChatAdaptorMessage(
					raw.type
					, raw.user
					, getUserById(raw.user).get_displayName()
					, (getUserById(raw.user).get_isLector())?('<b>'+raw.text+'</b>'):raw.text
					, raw.time
				);
			}
			
			du.set_type(raw.type);
			du.set_userID(raw.user);
			du.set_text(raw.text);
			du.set_time(raw.time);
			
			return du;
		}
		
		//} =*^_^*= =*^_^*= END OF low level -- shared object
		
	}
}

class DUChatUser  {
	function DUChatUser (name:String, displayName:String, avatarPictureSmall:String, avatarPicture:String, isLector:Boolean, online:Boolean, lastMessage:String=null):void {
		this.online=online;
		this.name = name;
		this.displayName = displayName;
		this.avatarPictureSmall = avatarPictureSmall;
		this.avatarPicture = avatarPicture;
		this.isLector = isLector;
		this.lastMessage = lastMessage;
	}

	public function get_name():String {return name;}
	//public function set_name(a:String):void {name = a;}
	public function get_isLector():Boolean {return isLector;}
	//public function set_isLector(a:Boolean):void {isLector = a;}
	public function get_displayName():String {return displayName;}
	//public function set_displayName(a:String):void {displayName = a;}
	public function get_avatarPictureSmall():String {return avatarPictureSmall;}
	//public function set_avatarPictureSmall(a:String):void {avatarPictureSmall = a;}
	public function get_avatarPicture():String {return avatarPicture;}
	//public function set_avatarPicture(a:String):void {avatarPicture = a;}
	public function get_lastMessage():String {return lastMessage;}
	public function set_lastMessage(a:String):void {lastMessage = a;}

	public function get_online():Boolean {return online;}
	public function set_online(a:Boolean):void {online = a;}
	
	private var name:String;//"username"
	private var isLector:Boolean;//"lector"
	private var displayName:String;//"username2"
	private var avatarPictureSmall:String;//"ava_small"
	private var avatarPicture:String;//"ava"
	private var lastMessage:String;//"lastMsg"
	private var online:Boolean;

}


//{ =*^_^*= History
/* > (timestamp) [ ("+" (added) ) || ("-" (removed) ) || ("*" (modified) )] (text)
 * > 
 */
//} =*^_^*= END OF History

// template last modified:11.03.2011_[18#51#40]_[5]