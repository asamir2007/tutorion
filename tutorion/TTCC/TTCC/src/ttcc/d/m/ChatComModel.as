// Project TTCC
package ttcc.d.m {
	
	//{ =*^_^*= import
	import ttcc.d.a.DUChatAdaptorMessage;
	import ttcc.d.a.DUChatAdaptorUser;
	import ttcc.d.i.ISerializable;
	import ttcc.d.m.AbstractModel;
	import ttcc.d.v.DUChatMessage;
	import ttcc.LOG;
	//} =*^_^*= END OF import
	
	
	/**
	 * 
	 * @author Jinanoimatey Dragoncat
	 * @version 0.0.0
	 * @created 01.08.2012 15:26
	 */
	public class ChatComModel extends AbstractModel {
		
		//{ =*^_^*= CONSTRUCTOR
		function ChatComModel () {
		}
		public override function destruct():void {
			super.destruct();
		}
		//} =*^_^*= END OF CONSTRUCTOR
		
		//{ =*^_^*= write access
		private function addMessages(a:Array):void {
			newMessagesList.push.apply(newMessagesList, a);
			messagesList.push.apply(messagesList, a);
			reflect(ID_P_MESSAGES);
		}
		public function addMessage(a:DUChatMessage):void {
			newMessagesList.push(a);
			messagesList.push(a);
			transfer(ID_P_A_ADD_MESSAGES);
			//transfer(ID_P_MESSAGES); 31.08.2012_00#57#22 maybe wrong
			reflect(ID_P_MESSAGES);
		}
		/**
		 * this method automatically detects new and missing users(by id)
		 * @param	a [DUChatAdaptorUser]
		 */
		public function set_usersList(a:Array):void {
			newUsers=getDifference(usersList, a);
			missingUsers=getDifference(a, usersList);
			usersList = a.slice();
			if (newUsers.length>0) {transfer(ID_P_A_ADD_USERS);}
			if (missingUsers.length>0) {transfer(ID_P_A_REMOVE_USERS);}
			transfer(ID_P_USERS);
			reflect(ID_P_USERS);
		}
		//} =*^_^*= END OF write access
		
		
		//{ =*^_^*= read
		//public function get_messagesList():Array {return messagesList;}//not used
		public function get_newMessagesList():Array {
			var l:Array=newMessagesList;newMessagesList=[];return l;
		}
		public function get_usersList():Array {return usersList;}
		//} =*^_^*= END OF read
		
		//{ =*^_^*= =*^_^*= private 
		private function removeUsers(a:Array):void {
			for each(var i:DUChatAdaptorUser in a) {
				if (getUserById(usersList, i.get_name())!=null) {
					usersList.splice(usersList.indexOf(i),1);
				}
			}
		}
		private function addUsers(l:Array):void {
			usersList.push.apply(usersList, l);// concat is not working according to docs - bitch.. fuck adobe.
		}
		/**
		 * find elements that are present only in b list
		 */
		private function getDifference(a:Array, b:Array):Array {
			var r:Array=[];
			for each(var i:DUChatAdaptorUser in b) {if (getUserById(a, i.get_name())==null) {r.push(i);}}return r;
		}
		private function getUserById(list:Array, id:String):DUChatAdaptorUser {
			// TODO: LOW; OPTIMIZATION; use hashmap
			for each(var i:DUChatAdaptorUser in list) {if (i.get_name()==id) {return i;}}return null;
		}
		//} =*^_^*= =*^_^*= END OF private
		
		
		//{ =*^_^*= model contens
		/**
		 * [DUChatMessage]
		 */
		private var messagesList:Array=[];
		/**
		 * [DUChatMessage]
		 */
		private var newMessagesList:Array=[];
		/**
		 * [DUChatAdaptorUser]
		 */
		private var usersList:Array=[];
		/**
		 * [DUChatAdaptorUser]
		 */
		private var newUsers:Array=[];
		/**
		 * [DUChatAdaptorUser]
		 */
		private var missingUsers:Array=[];
		//} =*^_^*= END OF model contens
		
		//{ =*^_^*= property id
		public static const ID_P_A_ADD_MESSAGES:uint=0;
		public static const ID_P_A_ADD_USERS:uint=1;
		public static const ID_P_A_REMOVE_USERS:uint=2;
		public static const ID_P_MESSAGES:uint=6;
		public static const ID_P_USERS:uint=7;
		public static const ID_P_CLEAR_MESSAGES:uint=8;
		//} =*^_^*= END OF property id
		
		
		//{ =*^_^*= reflection
		protected override function resetModel(updateFromDataport:Boolean=false):void {
			newMessagesList=[];
			messagesList=[];
			usersList=[];
			newUsers=[];
			missingUsers=[];
			
			markForReflect(ID_P_CLEAR_MESSAGES);
			markForReflect(ID_P_USERS);
		}
		//} =*^_^*= END OF reflection
		
		//{ =*^_^*= working with data
		/**
		 * override and place your code here
		 * @param	elementID
		 * @return rawData
		 */
		protected override function serialize(elementID:uint):Object {
			switch (elementID) {
			
			case ID_P_A_ADD_MESSAGES:return serializeArray(newMessagesList);newMessagesList=[];break;
			
			case ID_P_A_ADD_USERS:return serializeArray(newUsers);break;
			case ID_P_A_REMOVE_USERS:return serializeArray(missingUsers);break;
			
			case ID_P_USERS:return serializeArray(usersList);break;
			case ID_P_MESSAGES:return /*serializeArray(messagesList)*/null;break;
			
			case ID_P_CLEAR_MESSAGES:return null;break;
			
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
			
			case ID_P_A_ADD_MESSAGES:addMessages(deserializeArray(rawData, DUChatMessage));break;
			
			case ID_P_A_ADD_USERS:addUsers(deserializeArray(rawData, DUChatAdaptorUser));break;
			case ID_P_A_REMOVE_USERS:removeUsers(deserializeArray(rawData, DUChatAdaptorUser));break;
			
			case ID_P_MESSAGES:/*messagesList=deserializeArray(rawData, DUChatMessage);*/break;
			case ID_P_USERS:usersList = deserializeArray(rawData, DUChatAdaptorUser);break;
			
			case ID_P_CLEAR_MESSAGES:break;
			
			}
		}
		//} =*^_^*= END OF working with data
		
		
		
		
	}
}

//{ =*^_^*= History
/* > (timestamp) [ ("+" (added) ) || ("-" (removed) ) || ("*" (modified) )] (text)
 * > 
 */
//} =*^_^*= END OF History

// template last modified:11.03.2011_[18#51#40]_[5]