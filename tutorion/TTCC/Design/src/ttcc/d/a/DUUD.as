package ttcc.d.a {
	
	//{ =*^_^*= import
	import ttcc.d.ADU;
	import ttcc.d.i.ISerializable;
	//} =*^_^*= END OF import
	
	
	/**
	 * DUUserData
	 * user data data unit
	 * not intended for direct access, access through accessor only (DUA)
	 * @author Jinanoimatey Dragoncat
	 * @version 0.0.0
	 * @created 23.05.2012 02:01
	 */
	public class DUUD extends ADU implements ISerializable {
		
		//{ =*^_^*= CONSTRUCTOR
		function DUUD () {
		}
		public function construct(name:String):void {
			this.name=name;
			loggedIn=true;
		}
		public function destruct():void {
		}
		//} =*^_^*= END OF CONSTRUCTOR
		
		
		public function get_streamingIsOn():Boolean {return streamingIsOn;}
		public function set_streamingIsOn(a:Boolean):void {streamingIsOn = a;}
		public function get_streamName():String {return streamName;}
		public function set_streamName(a:String):void {streamName = (a=='')?null:a;}
		public function get_streamSoundIsOn():Boolean {return streamSoundIsOn;}
		public function set_streamSoundIsOn(a:Boolean):void {streamSoundIsOn = a;}
		public function get_chatIsTyping():Boolean {return chatIsTyping;}
		public function set_chatIsTyping(a:Boolean):void {chatIsTyping = a;}
		public function get_handIsUp():Boolean {return handIsUp;}
		public function set_handIsUp(a:Boolean):void {handIsUp = a;}
		
		/**
		 * same as get_id
		 */
		public function get_name():String {return name;}
		/**
		 * same as get_name
		 */
		public function get_id():String {return name;}
		
		public function get_loggedIn():Boolean {return loggedIn;}
		public function set_loggedIn(a:Boolean):void {loggedIn = a;}
		
		public function get_isLector():Boolean {return isLector;}
		public function set_isLector(a:Boolean):void {isLector = a;}
		public function get_displayName():String {return displayName;}
		public function set_displayName(a:String):void {displayName = (a=='')?null:a;}
		public function get_avatarPictureSmall():String {return avatarPictureSmall;}
		public function set_avatarPictureSmall(a:String):void {avatarPictureSmall = a;}
		public function get_avatarPicture():String {return avatarPicture;}
		public function set_avatarPicture(a:String):void {avatarPicture = a;}
		public function get_isBannedChat():Boolean {return isBannedChat;}
		public function set_isBannedChat(a:Boolean):void {isBannedChat = a;}
		public function get_streamAddedTime():int {return streamAddedTime;}
		public function set_streamAddedTime(a:int):void {streamAddedTime = a;}
		
		private var streamingIsOn:Boolean;
		private var streamName:String;
		private var streamSoundIsOn:Boolean;
		private var chatIsTyping:Boolean;
		private var handIsUp:Boolean;
		
		private var isLector:Boolean;//"lector"
		private var isBannedChat:Boolean;//"chatBan"
		private var displayName:String;//"username2"
		private var avatarPictureSmall:String;//"ava_small"
		private var avatarPicture:String;//"ava"
		
		private var name:String;
		
		private var loggedIn:Boolean;
		
		private var streamAddedTime:int;
		
		//{ =*^_^*= serialization
		public function toObject():Object {
			return {
				 streamingIsOn:int(streamingIsOn)
				, streamName:streamName
				, streamSoundIsOn:int(streamSoundIsOn)
				, chatIsTyping:int(chatIsTyping)
				, handIsUp:int(handIsUp)
				
				, isLector:int(isLector)
				, isBannedChat:int(isBannedChat)
				, displayName:displayName
				, avatarPictureSmall:avatarPictureSmall
				, avatarPicture:avatarPicture
				
				, name:name
				
				, loggedIn:int(loggedIn)
				
				, streamAddedTime:streamAddedTime
				
			};
		}
		
		public static function fromObject(a:Object):DUUD {
			if (a==null) {return null;}
			var o:DUUD=new DUUD;
			
			o.streamingIsOn = Boolean(parseInt(a.streamingIsOn));
			o.streamName = a.streamName;
			o.streamSoundIsOn = Boolean(parseInt(a.streamSoundIsOn));
			o.chatIsTyping = Boolean(parseInt(a.chatIsTyping));
			o.handIsUp = Boolean(parseInt(a.handIsUp));
			
			o.isLector = Boolean(parseInt(a.isLector));
			o.isBannedChat = Boolean(parseInt(a.isBannedChat));
			o.displayName = a.displayName;
			o.avatarPictureSmall = a.avatarPictureSmall;
			o.avatarPicture = a.avatarPicture;
			
			o.name = a.name;
			
			o.loggedIn = Boolean(parseInt(a.loggedIn));
			o.streamAddedTime = parseInt(a.streamAddedTime);
				
			return o;
		}
		
		public static function getLectorSample():DUUD {
			var o:DUUD=new DUUD;
			
			o.streamingIsOn = false;
			o.streamName = '';
			o.streamSoundIsOn = false;
			o.chatIsTyping = false;
			o.handIsUp = false;
			
			o.isLector = true;
			o.isBannedChat = false;
			o.displayName = 'User Display Name';
			o.avatarPictureSmall = "brother-sharp-promo.jpg";
			o.avatarPicture = "brother-sharp-promo.jpg";
			
			o.name = 'sample_user_ame';
			
			o.loggedIn = true;
			o.streamAddedTime = 0;
			
			return o;
		}
		
		//} =*^_^*= END OF serialization
		
		public function getTextRepresentation():String {
			var s:String='';
			var f:Array=[
				"streamingIsOn"
				,"streamName"
				,"streamSoundIsOn"
				,"chatIsTyping"
				,"handIsUp"
				,"name"
				,"loggedIn"
				,"isLector"
				,"isBannedChat"
				,"displayName"
				,"avatarPictureSmall"
				,"avatarPicture"
				,"streamAddedTime"
			];
			for each(var i:String in f) {
				s=s.concat(i+'='+this[i]+', ');
			}
			return s;
		}
		public function toString():String {
			return '|>userID='+name+'<|';
		}
	}
}

//{ =*^_^*= History
/* > (timestamp) [ ("+" (added) ) || ("-" (removed) ) || ("*" (modified) )] (text)
 * > 
 */
//} =*^_^*= END OF History

// template last modified:11.03.2011_[18#51#40]_[5]