// Project TTCC
package ttcc.d.dsp {
	
	//{ =*^_^*= import
	//} =*^_^*= END OF import
	
	
	/**
	 * 
	 * @author Jinanoimatey Dragoncat
	 * @version 0.0.0
	 * @created 26.05.2012 4:01
	 */
	public class DUApiAndStoragePaths {
		
		//{ =*^_^*= CONSTRUCTOR
		function DUApiAndStoragePaths () {
			
		}
		public function construct(userName:String, fmsRtmpURL:String, fmsRtmfpURL:String, contentPath:String, helpPath:String, p2pPath:String,		penSocketServerPath:String, roomTitle:String, fullUserName:String, userAvatarPath:String, userAvatarPathSmall:String):void {
			this.userName=userName;
			this.fmsRtmpURL=fmsRtmpURL;
			this.fmsRtmfpURL=fmsRtmfpURL;
			this.contentPath=contentPath;
			this.helpPath=helpPath;
			this.p2pPath=p2pPath;
			this.penSocketServerPath = penSocketServerPath;
			this.roomTitle = roomTitle;
			this.fullUserName = fullUserName;
			this.userAvatarPath = userAvatarPath;
			this.userAvatarPathSmall = userAvatarPathSmall;
		}
		
		public function destruct():void {
		}
		//} =*^_^*= END OF CONSTRUCTOR
		

		public function get_userName():String {return userName;}
		public function set_userName(a:String):void {userName = a;}
		public function get_fmsRtmpURL():String {return fmsRtmpURL;}
		public function set_fmsRtmpURL(a:String):void {fmsRtmpURL = a;}
		public function get_fmsRtmfpURL():String {return fmsRtmfpURL;}
		public function set_fmsRtmfpURL(a:String):void {fmsRtmfpURL = a;}
		public function get_fileServerRoot():String {return contentPath.substr(0, contentPath.lastIndexOf('/'));}
		public function get_fileServerPath():String {return contentPath;}
		public function get_contentPath():String {return contentPath;}
		public function set_contentPath(a:String):void {contentPath = a;}
		public function get_helpPath():String {return helpPath;}
		public function set_helpPath(a:String):void {helpPath = a;}
		public function get_p2pPath():String {return p2pPath;}
		public function set_p2pPath(a:String):void {p2pPath = a;}
		public function get_penSocketServerPath():String {return penSocketServerPath;}
		public function set_penSocketServerPath(a:String):void {penSocketServerPath = a;}
		public function get_roomTitle():String {return roomTitle;}
		public function set_roomTitle(a:String):void {roomTitle = a;}
		public function get_fullUserName():String {return fullUserName;}
		public function set_fullUserName(a:String):void {fullUserName = a;}
		public function get_userAvatarPath():String {return userAvatarPath;}
		public function set_userAvatarPath(a:String):void {userAvatarPath = a;}
		public function get_userAvatarPathSmall():String {return userAvatarPathSmall;}
		public function set_userAvatarPathSmall(a:String):void {userAvatarPathSmall = a;}
		
		
		
		
		private var userName:String;			
		private var fmsRtmpURL:String;
		private var fmsRtmfpURL:String;
		private var contentPath:String;
		private var helpPath:String;
		private var p2pPath:String;
		
		private var penSocketServerPath:String;
		private var roomTitle:String;
		private var fullUserName:String;
		private var userAvatarPath:String;
		private var userAvatarPathSmall:String;
		
		
	}
}

//{ =*^_^*= History
/* > (timestamp) [ ("+" (added) ) || ("-" (removed) ) || ("*" (modified) )] (text)
 * > 
 */
//} =*^_^*= END OF History

// template last modified:11.03.2011_[18#51#40]_[5]