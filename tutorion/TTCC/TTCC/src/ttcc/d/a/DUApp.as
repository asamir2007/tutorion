// Project TTCC
package ttcc.d.a {
	
	//{ =*^_^*= import
	import ttcc.d.ADU;
	import ttcc.d.dsp.DUApiAndStoragePaths;
	import ttcc.d.dsp.DUAppEnvData;
	//} =*^_^*= END OF import
	
	
	/**
	 * contains main application data storeroom
	 * @author Jinanoimatey Dragoncat
	 * @version 0.0.0
	 * @created 26.05.2012_02#54#22
	 */
	public class DUApp extends ADU {
		
		//{ =*^_^*= CONSTRUCTOR
		
		function DUApp () {
		}
		//} =*^_^*= END OF CONSTRUCTOR
		
		public function get_startupEnvData():DUAppEnvData {return startupEnvData;}
		public function set_startupEnvData(a:DUAppEnvData):void {startupEnvData = a;}
		public function get_clientUserDataReplay():DUUD {return clientUserDataReplay;}
		public function set_clientUserDataReplay(a:DUUD):void {clientUserDataReplay = a;}
		
		public function get_startupEnvDataReplay():DUAppEnvData {return startupEnvDataReplay;}
		public function set_startupEnvDataReplay(a:DUAppEnvData):void {startupEnvDataReplay = a;}
		
		public function get_startupPathsList():DUApiAndStoragePaths {return startupPathsList;}
		public function set_startupPathsList(a:DUApiAndStoragePaths):void {startupPathsList = a;}
		
		public function get_clientUserData():DUUD {return clientUserData;}
		public function set_clientUserData(a:DUUD):void {clientUserData = a;}
		public function get_clientUserId():String {return clientUserId;}
		public function set_clientUserId(a:String):void {clientUserId = a;}
		
		public function get_duAppComponentsCfg():DUAppComponentsCfg {return duAppComponentsCfg;}
		public function set_duAppComponentsCfg(a:DUAppComponentsCfg):void {duAppComponentsCfg = a;}
		
		public function get_replayMode():Boolean {return replayMode;}
		public function set_replayMode(a:Boolean):void {replayMode = a;}		
		
		public function get_userList():Array {return userList;}
		public function get_userDUByID(id:String):DUUD {
			for each(var i:DUUD in userList) {if (i.get_id()==id) {return i;}}
			return null;
		}
		//public function set_userList(a:Array):void {userList = a;}
		public function addUser(u:DUUD):void {
			for each(var i:DUUD in userList) {
				if (i.get_id()==u.get_id()) {
					userList.splice(userList.indexOf(i), 1, u);
					return;
				}
			}
			userList.push(u);
		}
		public function removeUser(u:DUUD):void {
			for each(var i:DUUD in userList) {
				if (i.get_id()==u.get_id()) {
					userList.splice(userList.indexOf(i), 1);
					return;
				}
			}
		}
		
		
		private var startupEnvData:DUAppEnvData;
		private var startupEnvDataReplay:DUAppEnvData;
		private var startupPathsList:DUApiAndStoragePaths;
		private var duAppComponentsCfg:DUAppComponentsCfg;
		
		private var clientUserData:DUUD;
		private var clientUserDataReplay:DUUD;
		private var userList:Array=[];
		private var clientUserId:String;
		private var replayMode:Boolean;
		
	}
}

//{ =*^_^*= History
/* > (timestamp) [ ("+" (added) ) || ("-" (removed) ) || ("*" (modified) )] (text)
 * > 
 */
//} =*^_^*= END OF History

// template last modified:11.03.2011_[18#51#40]_[5]// Project TTCC