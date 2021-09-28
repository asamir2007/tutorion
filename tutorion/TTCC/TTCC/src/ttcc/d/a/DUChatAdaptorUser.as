package ttcc.d.a {
	
	//{ =*^_^*= import
	import ttcc.d.ADU;
	import ttcc.d.i.ISerializable;
	//} =*^_^*= END OF import
	
	
	/**
	 * 
	 * @author Jinanoimatey Dragoncat
	 * @version 0.0.0
	 * @created 09.06.2012 19:14
	 */
	public class DUChatAdaptorUser extends ADU implements ISerializable {
		
		//{ =*^_^*= CONSTRUCTOR
		function DUChatAdaptorUser () {
		}
		/**
		 * 
		 * @param	name user id
		 * @param	displayName 
		 * @param	avatarPictureSmall
		 * @param	forcedListPostion always display this item at specified position from the beginning of the list
		 */
		public function construct(name:String, displayName:String, avatarPictureSmall:String, isLector:Boolean, forcedListPostion:uint=FORCED_LIST_POSTION_NONE):void {
			this.name=name;
			this.isLector=isLector;
			this.displayName=displayName;
			this.avatarPictureSmall=avatarPictureSmall;
			this.forcedListPostion=forcedListPostion;
			modified=true;//data has been updated
		}
		public function destruct():void {
		}
		//} =*^_^*= END OF CONSTRUCTOR
		
		
		public function get_name():String {return name;}
		public function get_displayName():String {return displayName;}
		public function get_avatarPictureSmall():String {return avatarPictureSmall;}
		
		public function get_isLector():Boolean {return isLector;}
		public function set_isLector(a:Boolean):void {isLector = a;}
		
		public function get_forcedListPostion():uint {return forcedListPostion;}
		public function set_forcedListPostion(a:uint):void {forcedListPostion = a;}
		
		public function get_modified():Boolean {return modified;}
		public function set_modified(a:Boolean):void {modified = a;}
		//public function get_banned():Boolean {return banned;}
		//public function set_banned(a:Boolean):void {banned = a;}
		
		
		/// NOT USED YET typing icon
		private var chatIsTyping:Boolean;
		/// NOT USED YET hand icon
		private var handIsUp:Boolean;
		/// NOT USED YET pic
		private var avatarPicture:String;
		/// NOT USED YET client user
		private var isClientUser:Boolean;
		
		
		/// custom display
		private var forcedListPostion:uint=FORCED_LIST_POSTION_NONE;
		/// display name, html
		private var displayName:String;
		/// pic
		private var avatarPictureSmall:String;
		/// id
		private var name:String;
		private var isLector:Boolean;
		//private var banned:Boolean;
		
		/// data has been modified
		private var modified:Boolean;
		
		/**
		 * turn off custom positioning in items list
		 */
		public static const FORCED_LIST_POSTION_NONE:uint=uint.MAX_VALUE;

		public function toObject():Object {
			return {
				forcedListPostion:forcedListPostion
				, displayName:displayName
				, avatarPictureSmall:avatarPictureSmall
				, name:name
				, isLector:isLector
				, modified:modified
			};
		}
		
		public static function fromObject(a:Object):DUChatAdaptorUser {
			var u:DUChatAdaptorUser=new DUChatAdaptorUser;
			u.construct(
				a.name
				, a.displayName
				, a.avatarPictureSmall
				, Boolean(parseInt(a.isLector))
				, parseInt(a.forcedListPostion)
			);
			return u;
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