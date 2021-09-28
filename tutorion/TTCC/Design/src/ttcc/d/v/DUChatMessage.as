package ttcc.d.v {
	
	//{ =*^_^*= import
	import ttcc.d.ADU;
	import ttcc.d.i.ISerializable;
	//} =*^_^*= END OF import
	
	
	/**
	 * 
	 * @author Jinanoimatey Dragoncat
	 * @version 0.0.0
	 * @created 10.06.2012 17:15
	 */
	public class DUChatMessage extends ADU implements ISerializable {
		
		//{ =*^_^*= CONSTRUCTOR
		function DUChatMessage (userID:String, userDisplayName:String, time:String, text:String):void {
			this.userDisplayName = userDisplayName;
			this.userID = userID;
			this.time = time;
			this.text = text;
		}
		//} =*^_^*= END OF CONSTRUCTOR
		public function get_userID():String {return userID;}
		public function set_userID(a:String):void {userID = a;}
		public function get_text():String {return text;}
		public function set_text(a:String):void {text = a;}
		public function get_userDisplayName():String {return userDisplayName;}
		public function set_userDisplayName(a:String):void {userDisplayName = a;}
		public function get_time():String {return time;}
		public function set_time(a:String):void {time = a;}
		
		private var userID:String;
		private var userDisplayName:String;
		private var text:String;
		private var time:String;
		
		public function toObject():Object {
			return {
				userID:userID
				, userDisplayName:userDisplayName
				, text:text
				, time:time
			};
		}
		
		public static function fromObject(a:Object):DUChatMessage {
			return new DUChatMessage(
				a.userID
				, a.userDisplayName
				, a.time
				, a.text
			);
		}
	
		
		/*public function toString():String {
			var s:String='';
			var f:Array=["streamingIsOn", "streamName", "streamSoundIsOn", "chatIsTyping", "handIsUp", "name", "loggedIn"];
			for each(var i:String in f) {
				s=s.concat(i+'='+this[i]+', ');
			}
			return s;
		}*/
		
	}
}

//{ =*^_^*= History
/* > (timestamp) [ ("+" (added) ) || ("-" (removed) ) || ("*" (modified) )] (text)
 * > 
 */
//} =*^_^*= END OF History

// template last modified:11.03.2011_[18#51#40]_[5]