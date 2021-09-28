package ttcc.d.a {
	
	//{ =*^_^*= import
	import ttcc.d.ADU;
	//} =*^_^*= END OF import
	
	
	/**
	 * 
	 * @author Jinanoimatey Dragoncat
	 * @version 0.0.0
	 * @created 09.06.2012 19:14
	 */
	public class DUChatAdaptorMessage extends ADU {
		
		//{ =*^_^*= CONSTRUCTOR
		function DUChatAdaptorMessage (type:String, userID:String, userDisplayName:String, text:String ,time:String):void {
			this.type = type;
			this.userDisplayName = userDisplayName;
			this.userID = userID;
			this.text = text;
			this.time = time;
		}
		//} =*^_^*= END OF CONSTRUCTOR
		public function get_type():String {return type;}
		public function set_type(a:String):void {type = a;}
		public function get_userID():String {return userID;}
		public function set_userID(a:String):void {userID = a;}
		public function get_text():String {return text;}
		public function set_text(a:String):void {text = a;}
		public function get_time():String {return time;}
		public function set_time(a:String):void {time = a;}
		public function get_userDisplayName():String {return userDisplayName;}
		public function set_userDisplayName(a:String):void {userDisplayName = a;}
		
		private var type:String;
		private var userID:String;
		private var userDisplayName:String;
		private var text:String;
		private var time:String;
		
			
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