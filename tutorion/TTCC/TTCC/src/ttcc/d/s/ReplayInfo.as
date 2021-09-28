// Project TTCC
package ttcc.d.s {
	
	//{ =*^_^*= import
	import ttcc.d.a.DUUD;
	import ttcc.d.dsp.DUAppEnvData;
	//} =*^_^*= END OF import
	
	
	/**
	 * 
	 * @author Jinanoimatey Dragoncat
	 * @version 0.0.0
	 * @created 08.08.2012 12:31
	 */
	public class ReplayInfo {
		
		//{ =*^_^*= CONSTRUCTOR
		function ReplayInfo (duration:Number, appEnvData:DUAppEnvData, clientUserData:DUUD, startMarkerSN:uint, endMarkerSN:uint, replayID:String):void {
			this.replayID = replayID;
			this.duration = duration;
			this.appEnvData = appEnvData;
			this.clientUserData = clientUserData;
			
			this.startMarkerSN = startMarkerSN;
			this.endMarkerSN = endMarkerSN;
		}
		public function construct():void {
		}
		public function destruct():void {
		}
		//} =*^_^*= END OF CONSTRUCTOR
		
		public function get_duration():Number {return duration;}
		//public function set_duration(a:Number):void {duration = a;}
		public function get_appEnvData():DUAppEnvData {return appEnvData;}
		//public function set_appEnvDaata(a:DUAppEnvData):void {appEnvDaata = a;}
		public function get_clientUserData():DUUD {return clientUserData;}
		//public function set_clientUserData(a:DUUD):void {clientUserData = a;}
		
		public function get_startMarkerSN():uint {return startMarkerSN;}
		//public function set_startMarkerSN(a:uint):void { startMarkerSN = a;}
		public function get_endMarkerSN():uint {return endMarkerSN;}
		//public function set_endMarkerSN(a:uint):void {endMarkerSN = a;}
		
		public function get_replayID():String {return replayID;}
		//public function set_replayID(a:String):void {replayID = a;}
		
		
		private var replayID:String;
		
		private var startMarkerSN:uint;
		private var endMarkerSN:uint;
		
		private var duration:Number;
		private var appEnvData:DUAppEnvData;
		private var clientUserData:DUUD;
		
		public function toObject():Object {
			return {d:duration, aed:appEnvData.toObject(), cud:clientUserData.toObject(), smsn:startMarkerSN, emsn:endMarkerSN, rids:replayID};
		}
		public static function fromObject (o:Object):ReplayInfo {
			return new ReplayInfo(o.d, DUAppEnvData.fromObject(o.aed), DUUD.fromObject(o.cud), o.smsn, o.emsn, o.rids);
		}
		
		public static const NAME:String='ReplayInfo';
		
	}
}

//{ =*^_^*= History
/* > (timestamp) [ ("+" (added) ) || ("-" (removed) ) || ("*" (modified) )] (text)
 * > 
 */
//} =*^_^*= END OF History

// template last modified:11.03.2011_[18#51#40]_[5]