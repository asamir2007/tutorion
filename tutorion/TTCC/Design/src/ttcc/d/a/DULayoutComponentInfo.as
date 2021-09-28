// Project TTCC
package ttcc.d.a {
	
	//{ =*^_^*= import
	import ttcc.d.ADU;
	//} =*^_^*= END OF import
	
	
	/**
	 * 
	 * @author Jinanoimatey Dragoncat
	 * @version 0.0.0
	 * @created 13.09.2012 11:24
	 */
	public class DULayoutComponentInfo extends ADU {
		
		//{ =*^_^*= CONSTRUCTOR
		function DULayoutComponentInfo(rawData:Object) {
			construct(rawData);
		}
		public function construct(rawData:Object):void {
			this.rawDataObject = rawData;
		}
		public function destruct():void {
		}
		//} =*^_^*= END OF CONSTRUCTOR
		
		
		public function get_id():String {return getString('id');}
		public function get_wx():Number {return getNumber("wx");}
		public function get_wy():Number {return getNumber("wy");}
		public function get_ww():Number {return getNumber("ww");}
		public function get_wh():Number {return getNumber("wh");}
		
		public function get_px():Number {return getNumber("px");}
		public function get_py():Number {return getNumber("py");}
		public function get_pw():Number {return getNumber("pw");}
		public function get_ph():Number {return getNumber("ph");}
		
		public function get_windowIsVisible():Boolean {return getBoolean("window_is_visible");}
		
		
		
		private function hasPropertyDefined(pn:String):Boolean {return rawDataObject.hasOwnProperty(pn);}
		private function getString(pn:String):String {return rawDataObject[pn];}
		private function getNumber(pn:String):Number {return parseFloat(rawDataObject[pn]);}
		private function getBoolean(pn:String):Boolean {return Boolean(parseInt(rawDataObject[pn]));}
		private function getObject(pn:String):Object {return rawDataObject[pn];}
		
		private function setString(pn:String, pv:String):void {rawDataObject[pn]=pv;}
		private function setNumber(pn:String, pv:Number):void {rawDataObject[pn]=pv;}
		private function setBoolean(pn:String, pv:Boolean):void {rawDataObject[pn]=(pv)?1:0;}
		private function setObject(pn:String, pv:Object):void {rawDataObject[pn]=pv;}
		
		private var rawDataObject:Object;
		
		public function toString():String {
			return '{id:'+get_id()+
				"px:"+getNumber("px")
				+"py:"+getNumber("py")
				+"pw:"+getNumber("pw")
				+"ph:"+getNumber("ph")
			'}';
		}
		
	}
}

//{ =*^_^*= History
/* > (timestamp) [ ("+" (added) ) || ("-" (removed) ) || ("*" (modified) )] (text)
 * > 
 */
//} =*^_^*= END OF History

// template last modified:11.03.2011_[18#51#40]_[5]