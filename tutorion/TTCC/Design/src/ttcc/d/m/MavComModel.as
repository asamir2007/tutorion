// Project TTCC
package ttcc.d.m {
	
	//{ =*^_^*= import
	import ttcc.Application;
	import ttcc.c.v.AVUser;
	import ttcc.d.a.DUUD;
	import ttcc.d.i.ISerializable;
	import ttcc.d.m.AbstractModel;
	import ttcc.LOG;
	//} =*^_^*= END OF import
	
	
	/**
	 * 
	 * @author Jinanoimatey Dragoncat
	 * @version 0.0.0
	 * @created 02.08.2012 2:42
	 */
	public class MavComModel extends AbstractModel {
		
		//{ =*^_^*= CONSTRUCTOR
		function MavComModel (a:Application) {
			this.a=a;
		}
		public override function destruct():void {
			super.destruct();
		}
		//} =*^_^*= END OF CONSTRUCTOR
		
		//{ =*^_^*= write access
		public function set_settings_VideoReceptionState(a:Boolean):void {
			settings_VideoReceptionState=a;
			transfer(ID_P_SETTINGS_VIDEO_RECEPTION_STATE);reflect(ID_P_SETTINGS_VIDEO_RECEPTION_STATE);
		}
		
		public function set_settings_AudioReceptionState(a:Boolean):void {
			settings_AudioReceptionState=a;
			transfer(ID_P_SETTINGS_AUDIO_RECEPTION_STATE);reflect(ID_P_SETTINGS_AUDIO_RECEPTION_STATE);
		}
		
		public function set_settings_VideoTransmissionState(a:Boolean):void {
			settings_VideoTransmissionState=a;
			transfer(ID_P_SETTINGS_VIDEO_TRANSMISSION_STATE);reflect(ID_P_SETTINGS_VIDEO_TRANSMISSION_STATE);
		}
		
		public function set_settings_AudioTransmissionState(a:Boolean):void {
			settings_AudioTransmissionState=a;
			transfer(ID_P_SETTINGS_AUDIO_TRANSMISSION_STATE);reflect(ID_P_SETTINGS_AUDIO_TRANSMISSION_STATE);
		}
		
		public function set_settings_StreamState(a:Boolean):void {
			settings_StreamState=a;
			transfer(ID_P_SETTINGS_STREAM_STATE);reflect(ID_P_SETTINGS_STREAM_STATE);
		}
		
		public function setCurrentUser(u:DUUD):void {
			currentUser=u;
			transfer(ID_P_A_SET_CURRENT_USER);
			reflect(ID_P_A_SET_CURRENT_USER);
		}
		
		/**
		 * this method automatically detects new and missing users(by id)
		 * @param	a [DUUD]
		 */
		public function set_usersList(a:Array):void {
			//LOG(0,'moel>et_usersList',1);
			//{ refresh userlist
			var uk:DUUD;
			var uk0:DUUD;
			for (var ik:int in usersList) {
				uk=usersList[ik];
				uk0=getUserById(a, uk.get_id());
				if (uk0!=null) {usersList[ik]=uk0;}
			}
			//}
			
			newUsers=getDifference(usersList, a);
			missingUsers=getDifference(a, usersList);
			usersList = a.slice();
			if (newUsers.length>0) {
				//LOG(0, 'ID_P_A_ADD_USERS',1);
				transfer(ID_P_A_ADD_USERS);
				
				//newStreams=constructStremInfo(newUsers);
				//transfer(ID_P_A_ADD_STREAMINFO);
				
				//LOG(0,'new users:'+newUsers,1);
			}
			if (missingUsers.length>0) {
				//LOG(0, 'ID_P_A_REMOVE_USERS',1);
				transfer(ID_P_A_REMOVE_USERS);
				//LOG(0,'missingUsers:'+missingUsers,1);
			}
			reflect(ID_P_USERS);
		}
		//} =*^_^*= END OF write access
		
		
		//{ =*^_^*= read access
		public function get_settings_VideoReceptionState():Boolean {return settings_VideoReceptionState;}
		public function get_settings_AudioReceptionState():Boolean {return settings_AudioReceptionState;}
		public function get_settings_VideoTransmissionState():Boolean {return settings_VideoTransmissionState;}
		public function get_settings_AudioTransmissionState():Boolean {return settings_AudioTransmissionState;}
		public function get_settings_StreamState():Boolean {return settings_StreamState;}
		public function get_usersList():Array {return usersList;}
		public function get_currentUser():DUUD {return currentUser;}
		
		/*public function get_StreamTimestamp(streamName:String):int {
			for each(var i:DUStream in streamInfoList) {
				if (i.get_name()==streamName) {return i.get_timestamp();}
			}
			return 0;
		}*/
		//} =*^_^*= END OF read access
		
		//{ =*^_^*= model content
		/**
		 * [DUUD]
		 */
		private var usersList:Array=[];
		private var newUsers:Array=[];
		private var missingUsers:Array=[];
		private var currentUser:DUUD;
		/**
		 * DUStream
		 */
		//private var streamInfoList:Array=[];
		/**
		 * DUStream
		 */
		//private var newStreams:Array=[];
		
		private var settings_VideoReceptionState:Boolean;
		private var settings_AudioReceptionState:Boolean;
		private var settings_VideoTransmissionState:Boolean;
		private var settings_AudioTransmissionState:Boolean;
		private var settings_StreamState:Boolean;
		//} =*^_^*= END OF model content
		
		//{ =*^_^*= reflection
		protected override function resetModel(updateFromDataport:Boolean=false):void {
			usersList=[];
			newUsers=[];
			missingUsers=[];
			
			markForReflect(ID_P_USERS);
		}
		private function removeUsers(a:Array):void {
			for each(var i:DUUD in a) {
				if (getUserById(usersList, i.get_id())!=null) {
					usersList.splice(usersList.indexOf(i), 1);
				}
			}
			reflect(ID_P_USERS);
		}
		private function addUsers(l:Array):void {
			usersList.push.apply(usersList, l);// concat is not working according to docs - bitch.. fuck adobe.
			reflect(ID_P_USERS);
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
		public static const ID_P_SETTINGS_VIDEO_RECEPTION_STATE:uint=0;
		public static const ID_P_SETTINGS_AUDIO_RECEPTION_STATE:uint=1;
		public static const ID_P_SETTINGS_VIDEO_TRANSMISSION_STATE:uint=2;
		public static const ID_P_SETTINGS_AUDIO_TRANSMISSION_STATE:uint=3;
		public static const ID_P_SETTINGS_STREAM_STATE:uint=4;
		public static const ID_P_USERS:uint=5;
		public static const ID_P_A_ADD_USERS:uint=6;
		public static const ID_P_A_REMOVE_USERS:uint=7;
		public static const ID_P_A_SET_CURRENT_USER:uint=8;
		//} =*^_^*= END OF property id
		
		//{ =*^_^*= working with data
		/**
		 * override and place your code here
		 * @param	elementID
		 * @return rawData
		 */
		protected override function serialize(elementID:uint):Object {
			switch (elementID) {
			
			case ID_P_SETTINGS_VIDEO_RECEPTION_STATE:return int(settings_VideoReceptionState);
			case ID_P_SETTINGS_AUDIO_RECEPTION_STATE:return int(settings_AudioReceptionState);
			case ID_P_SETTINGS_VIDEO_TRANSMISSION_STATE:return int(settings_VideoTransmissionState);
			case ID_P_SETTINGS_AUDIO_TRANSMISSION_STATE:return int(settings_AudioTransmissionState);
			case ID_P_SETTINGS_STREAM_STATE:return int(settings_StreamState);
		
			case ID_P_A_ADD_USERS:return serializeArray(newUsers);
			case ID_P_A_REMOVE_USERS:return serializeArray(missingUsers);
			
			case ID_P_USERS:return serializeArray(usersList);
			
			case ID_P_A_SET_CURRENT_USER:return (currentUser!=null)?currentUser.toObject():null;
			
			//case ID_P_A_ADD_STREAMINFO:return serializeArray(newStreams);
			
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
			
			case ID_P_SETTINGS_VIDEO_RECEPTION_STATE:settings_VideoReceptionState=Boolean(rawData);break;
			case ID_P_SETTINGS_AUDIO_RECEPTION_STATE:settings_AudioReceptionState=Boolean(rawData);break;
			case ID_P_SETTINGS_VIDEO_TRANSMISSION_STATE:settings_VideoTransmissionState=Boolean(rawData);break;
			case ID_P_SETTINGS_AUDIO_TRANSMISSION_STATE:settings_AudioTransmissionState=Boolean(rawData);break;
			case ID_P_SETTINGS_STREAM_STATE:settings_StreamState=Boolean(rawData);break;
			
			case ID_P_A_ADD_USERS:addUsers(deserializeArray(rawData, DUUD));break;
			case ID_P_A_REMOVE_USERS:removeUsers(deserializeArray(rawData, DUUD));break;
			
			case ID_P_USERS:usersList = deserializeArray(rawData, DUUD);break;
			
			case ID_P_A_SET_CURRENT_USER:currentUser = (rawData!=null)?DUUD.fromObject(rawData):null;
			
			//case ID_P_A_ADD_STREAMINFO:addStreams(deserializeArray(rawData, DUStream));break;
			
			}
		}
		//} =*^_^*= END OF working with data
		
		
	}
}

/*import ttcc.d.i.ISerializable;

class DUStream implements ISerializable {
	
	function DUStream (timestamp:int, name:String):void {
		this.name = name;
		this.data = data;
	}
	public function get_timestamp():int {return timestamp;}
	public function get_name():String{return name;}
	
	private var timestamp:int;
	private var name:String;
}*/
//{ =*^_^*= History
/* > (timestamp) [ ("+" (added) ) || ("-" (removed) ) || ("*" (modified) )] (text)
 * > 
 */
//} =*^_^*= END OF History

// template last modified:11.03.2011_[18#51#40]_[5]