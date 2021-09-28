// Project TTCC
package ttcc.c.v {
	
	//{ =*^_^*= import
	import flash.media.Video;
	//} =*^_^*= END OF import
	
	
	/**
	 * 
	 * @author Jinanoimatey Dragoncat
	 * @version 0.0.0
	 * @created 11.07.2012 18:58
	 */
	public class AVGUIController {
		
		//{ =*^_^*= CONSTRUCTOR
		function AVGUIController (id:String, video:Video, userAvatarPath:String, userDisplayName:String) {
			this.id = id;
			this.video = video;
			this.userAvatarPath = userAvatarPath;
			this.userDisplayName = userDisplayName;
		}
		
		public function destruct():void {
			this.id = null;
			this.video = null;
			this.userAvatarPath = null;
			this.userDisplayName = null;	
		}
		//} =*^_^*= END OF CONSTRUCTOR
		
		
		//{ =*^_^*= user interface
		
		public function displayUserpic():void {notifyReset();
			var def:Boolean=(userAvatarPath==null||userAvatarPath.length==0);
			// dertermine which picture to show
			if (def==ID_NO_USERS_AVATAR) {
				el(this, ID_E_DISPLAY_NO_USERS_PICTURE);
				return;
			}
			el(this, (def)?ID_E_DISPLAY_DEFAULT_USER_PICTURE:ID_E_DISPLAY_USER_PICTURE);
		}
		public function displayVideo():void {displayUserpic();return;notifyReset();el(this, ID_E_DISPLAY_VIDEO);}
		/**
		 * display username, other initial info
		 */
		public function notifyReady():void {el(this, ID_E_UNIT_READY);}
		/**
		 * free interface from avatar images that are currently loading interfering with new user data(video or avatar)
		 */
		public function notifyReset():void {el(this, ID_E_UNIT_RESET);}
		
		public function get_video():Video {return video;}
		public function get_userAvatarPath():String {return userAvatarPath;}
		public function get_userDisplayName():String {return userDisplayName;}
		public function get_volumeLevel():int {return volumeLevel;}
		public function get_id():String {return id;}
		
		public function set_video(a:Video):void {video = a;}
		public function set_userAvatarPath(a:String):void {userAvatarPath = a;}
		public function set_userDisplayName(a:String):void {userDisplayName = a;el(this, ID_E_UPDATED_DISPLAY_NAME);}
		public function set_volumeLevel(a:int):void {
			volumeLevel = a;
			el(this, ID_E_UPDATED_VOLUME_LEVEL);
		}
		public function set_hasAudio(a:Boolean):void {
			hasAudio = a;
			el(this, ID_E_UPDATED_HAS_AUDIO);
		}
		public function get_hasAudio():Boolean {return hasAudio;}
		//} =*^_^*= END OF user interface
		
		private var id:String;
		private var video:Video;
		private var userAvatarPath:String;
		private var userDisplayName:String;
		private var volumeLevel:int;
		private var hasAudio:Boolean;
		
		/**
		 * 
		 * @param	a function(target:AVGUIController, eventType:int):void;
		 */
		public function set_el(a:Function):void {el = a;}
		private var el:Function;
		
		//{ =*^_^*= events
		private static var nextID:uint=1;
		
		public static const ID_E_DISPLAY_VIDEO:int=nextID++;
		public static const ID_E_DISPLAY_USER_PICTURE:int=nextID++;
		public static const ID_E_DISPLAY_DEFAULT_USER_PICTURE:int=nextID++;
		public static const ID_E_DISPLAY_NO_USERS_PICTURE:int=nextID++;
		public static const ID_E_UPDATED_VOLUME_LEVEL:int=nextID++;
		public static const ID_E_UPDATED_HAS_AUDIO:int=nextID++;
		public static const ID_E_UPDATED_DISPLAY_NAME:int=nextID++;
		/**
		 * basic data ready for usage
		 */
		public static const ID_E_UNIT_READY:int=nextID++;
		public static const ID_E_UNIT_RESET:int=nextID++;
		//} =*^_^*= END OF events
		
		public static const ID_NO_USERS_AVATAR:String='>>ID_NO_USERS_AVATAR<<';
		
	}
}

//{ =*^_^*= History
/* > (timestamp) [ ("+" (added) ) || ("-" (removed) ) || ("*" (modified) )] (text)
 * > 
 */
//} =*^_^*= END OF History

// template last modified:11.03.2011_[18#51#40]_[5]