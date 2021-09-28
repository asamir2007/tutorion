// Project TTCC
package ttcc.d.dsp {
	import ttcc.d.i.ISerializable;
	
	//{ =*^_^*= import
	//} =*^_^*= END OF import
	
	
	/**
	 * 
	 * @author Jinanoimatey Dragoncat
	 * @version 0.0.0
	 * @created 26.05.2012 3:00
	 */
	public class DUAppEnvData implements ISerializable {
		
		//{ =*^_^*= CONSTRUCTOR
		function DUAppEnvData () {
		}
		public function construct(appPageURL:String, reqURL:String, userID:String, roomID:String, sessionID:String, token:String, settingsXML:String, repID:String):void {
			this.appPageURL=appPageURL;
			this.reqURL=reqURL;
			this.userID=userID;
			this.roomID=roomID;
			this.sessionID=sessionID;
			this.token=token;
			this.settingsXML=settingsXML;
			this.repID=repID;
		}
		public function destruct():void {
		}
		//} =*^_^*= END OF CONSTRUCTOR
		
		public function get_appPageURL():String {return appPageURL;}
		public function set_appPageURL(a:String):void {appPageURL = a;}
		public function get_reqURL():String {return reqURL;}
		public function set_reqURL(a:String):void {reqURL = a;}
		public function get_userID():String {return userID;}
		public function set_userID(a:String):void {userID = a;}
		public function get_roomID():String {return roomID;}
		public function set_roomID(a:String):void {roomID = a;}
		public function get_sessionID():String {return sessionID;}
		public function set_sessionID(a:String):void {sessionID = a;}
		public function get_token():String {return token;}
		public function set_token(a:String):void {token = a;}
		public function get_settingsXML():String {return settingsXML;}
		public function set_settingsXML(a:String):void {settingsXML = a;}
		public function get_repID():String {return repID;}
		public function set_repID(a:String):void {repID = a;}
		
		private var appPageURL:String;
		private var reqURL:String;
		private var userID:String;
		private var roomID:String;
		private var sessionID:String;
		private var token:String;
		private var settingsXML:String;
		private var repID:String;
		
		public function toObject():Object {
			return {
				pu:appPageURL
				,ru:reqURL
				,uid:userID
				,roid:roomID
				,sid:sessionID
				,t:token
				,sxml:settingsXML
				,reid:repID
			};
		}
		public static function fromObject(o:Object):DUAppEnvData {
			var i:DUAppEnvData=new DUAppEnvData;
			i.appPageURL=o.pu;
			i.reqURL=o.ru;
			i.userID=o.uid;
			i.roomID=o.roid;
			i.sessionID=o.sid;
			i.token=o.t;
			i.settingsXML=o.sxml;
			i.repID=o.reid;
			return i;
		}
		
	}
}

//{ =*^_^*= History
/* > (timestamp) [ ("+" (added) ) || ("-" (removed) ) || ("*" (modified) )] (text)
 * > 
 */
//} =*^_^*= END OF History

// template last modified:11.03.2011_[18#51#40]_[5]