// Project TTCC
package ttcc.d.m {
	
	//{ =*^_^*= import
	import ttcc.Application;
	import ttcc.d.a.DUUD;
	import ttcc.d.i.ISerializable;
	import ttcc.d.m.AbstractModel;
	import ttcc.LOG;
	//} =*^_^*= END OF import
	
	
	/**
	 * 
	 * @author Jinanoimatey Dragoncat
	 * @version 0.0.0
	 * @created 26.08.2012 8:37
	 */
	public class MPUsersListComModel extends AbstractModel {
		
		//{ =*^_^*= CONSTRUCTOR
		function MPUsersListComModel (a:Application) {
			this.a=a;
		}
		public override function destruct():void {
			super.destruct();
		}
		//} =*^_^*= END OF CONSTRUCTOR
		
		//{ =*^_^*= write access
		/**
		 * this method automatically detects new and missing users(by id)
		 * @param	a [DUUD]
		 */
		public function set_usersPropertiesHandChatStream(u:DUUD):void {
			// create properties instance
			userPropertiesUpdateUnit=new DUUserProperties(u);
			// transfer, reflect
			transfer(ID_P_USER_PROPERTIES_UPDATE_);
			// update data
			applyUserPropertiesUpdate(userPropertiesUpdateUnit);
			userPropertiesUpdateUnit=null;
			reflect(ID_P_USER_PROPERTIES_UPDATE);
		}
		private var userPropertiesUpdateUnit:DUUserProperties;
		
		/**
		 * this method automatically detects new and missing users(by id)
		 * @param	a [DUUD]
		 */
		public function set_usersList(a:Array):void {
			//LOG(0,'model>et_usersList',1);
			newUsers=getDifference(usersList, a);
			missingUsers=getDifference(a, usersList);
			usersList = a.slice();
			if (newUsers.length>0) {
				//LOG(0, 'ID_P_A_ADD_USERS',1);
				transfer(ID_P_A_ADD_USERS);
			}
			if (missingUsers.length>0) {
				//LOG(0, 'ID_P_A_REMOVE_USERS',1);
				transfer(ID_P_A_REMOVE_USERS);
			}
			reflect(ID_P_USERS);
		}
		//} =*^_^*= END OF write access
		
		
		//{ =*^_^*= read access
		public function get_usersList():Array {return usersList;}
		//} =*^_^*= END OF read access
		
		//{ =*^_^*= model content
		/**
		 * [DUUD]
		 */
		private var usersList:Array=[];
		private var newUsers:Array=[];
		private var missingUsers:Array=[];
		//} =*^_^*= END OF model content
		
		//{ =*^_^*= reflection
		protected override function resetModel(updateFromDataport:Boolean=false):void {
			usersList=[];
			newUsers=[];
			missingUsers=[];
			userPropertiesUpdateUnit=null;
			markForReflect(ID_P_USERS);
		}
		private function removeUsers(a:Array):void {
			//LOG(0,'REFLECT>before:'+usersList, 1);
			//LOG(0,'REFLECT>removeUser:'+DUUD(a[0]).get_id(), 0);
			var tu:DUUD;
			for each(var i:DUUD in a) {
				tu=getUserById(usersList, i.get_id());
				if (tu!=null) {
					usersList.splice(usersList.indexOf(tu), 1);
					//LOG(0,'>removed: '+i.get_id(), 0);
				}
			}
			//LOG(0,'REFLECT>after:'+usersList, 0);
			reflect(ID_P_USERS);
		}
		private function addUsers(a:Array):void {
			var uu:DUUD=a[0];
			if (!uu) {LOG(2,'MPUserList>addUsers()>!u',2);return;}
			//LOG(0,'REFLECT>addUser:id='+uu.get_id()+'<', 1);
			usersList.push.apply(usersList, a);// concat is not working as said in docs - report adobe.
			reflect(ID_P_USERS);
		}
		
		private function applyUserPropertiesUpdate(a:DUUserProperties):void {
			var user:DUUD=getUserById(usersList, a.get_id());
			if (!user) {LOG(0, 'applyUserPropertiesUpdate>no such user with id='+a.get_id()+'<', 1);return;}
			//if (!user) {LOG(0, 'applyUserPropertiesUpdate>in:'+usersList.join(',')+'<', 1);return;}
			user.set_chatIsTyping(a.get_chatIsTyping());
			user.set_handIsUp(a.get_handIsUp());
			user.set_streamingIsOn(a.get_streamingIsOn());
			if (!a.get_streamingIsOn()) {user.set_streamName(null);}
			reflect(ID_P_USER_PROPERTIES_UPDATE);
		}
		//} =*^_^*= END OF reflection
		
		//{ =*^_^*= private 
		/**
		 * find elements that are present only in b list
		 */
		private function getDifference(a:Array, b:Array):Array {
			var r:Array=[];
			for each(var i:DUUD in b) {if (getUserById(a, i.get_id())==null) {r.push(i);}}return r;
		}
		private function getUserById(list:Array, id:String):DUUD {
			// TODO: LOW; OPTIMIZATION; use hashmap
			for each(var i:DUUD in list) {if (i.get_id()==id) {return i;}}return null;
		}
		
		private var a:Application;
		//} =*^_^*= END OF private
		
		//{ =*^_^*= property id
		public static const ID_P_USERS:uint=0;
		public static const ID_P_A_ADD_USERS:uint=1;
		public static const ID_P_A_REMOVE_USERS:uint=2;
		private static const ID_P_USER_PROPERTIES_UPDATE_:uint=3;
		public static const ID_P_USER_PROPERTIES_UPDATE:uint=4;
		//} =*^_^*= END OF property id
		
		//{ =*^_^*= working with data
		/**
		 * override and place your code here
		 * @param	elementID
		 * @return rawData
		 */
		protected override function serialize(elementID:uint):Object {
			switch (elementID) {
			
			case ID_P_A_ADD_USERS:return serializeArray(newUsers);
			case ID_P_A_REMOVE_USERS:return serializeArray(missingUsers);
			
			//case ID_P_USERS:return serializeArray(usersList);
			case ID_P_USER_PROPERTIES_UPDATE_:return serializeArray([userPropertiesUpdateUnit]);break;
			
			}
			return null;
		}
		
		/**
		 * 
		 * @param	elementID
		 * @param	rawData
		 */
		protected override function deserializeAndStore(elementID:uint, rawData:Object):void {
			switch (elementID) {
			
			case ID_P_A_ADD_USERS:addUsers(deserializeArray(rawData, DUUD));break;
			case ID_P_A_REMOVE_USERS:removeUsers(deserializeArray(rawData, DUUD));break;
			
			//case ID_P_USERS:usersList = deserializeArray(rawData, DUUD);break;
			case ID_P_USER_PROPERTIES_UPDATE_:applyUserPropertiesUpdate(deserializeArray(rawData, DUUserProperties)[0]);break;
			
			}
		}
		//} =*^_^*= END OF working with data
		
		
	}
}


import ttcc.d.a.DUUD;
import ttcc.d.i.ISerializable;

class DUUserProperties implements ISerializable {
	
	function DUUserProperties (u:DUUD):void {
		if (!u) {return;}
		this.streamingIsOn = u.get_streamingIsOn();
		this.chatIsTyping = u.get_chatIsTyping();
		this.handIsUp = u.get_handIsUp();
		this.id = u.get_id();
	}
	
	//{ =*^_^*= serialization
	public function toObject():Object {
		return {
			 streamingIsOn:int(streamingIsOn)
			, chatIsTyping:int(chatIsTyping)
			, handIsUp:int(handIsUp)
			, id:id
			
		};
	}
	
	public static function fromObject(a:Object):DUUserProperties {
		var o:DUUserProperties=new DUUserProperties(null);
		
		o.streamingIsOn = Boolean(parseInt(a.streamingIsOn));
		o.chatIsTyping = Boolean(parseInt(a.chatIsTyping));
		o.handIsUp = Boolean(parseInt(a.handIsUp));
		o.id = a.id;
		
		return o;
	}
	//} =*^_^*= END OF serialization
	

	
	public function get_streamingIsOn():Boolean {return streamingIsOn;}
	//public function set_streamingIsOn(a:Boolean):void {streamingIsOn = a;}
	public function get_chatIsTyping():Boolean {return chatIsTyping;}
	//public function set_chatIsTyping(a:Boolean):void {chatIsTyping = a;}
	public function get_handIsUp():Boolean {return handIsUp;}
	//public function set_handIsUp(a:Boolean):void {handIsUp = a;}
	public function get_id():String {return id;}
	//public function set_id(a:String):void {id = a;}
	
	private var streamingIsOn:Boolean;
	private var chatIsTyping:Boolean;
	private var handIsUp:Boolean;
	private var id:String;
	
}

//{ =*^_^*= History
/* > (timestamp) [ ("+" (added) ) || ("-" (removed) ) || ("*" (modified) )] (text)
 * > 
 */
//} =*^_^*= END OF History

// template last modified:11.03.2011_[18#51#40]_[5]