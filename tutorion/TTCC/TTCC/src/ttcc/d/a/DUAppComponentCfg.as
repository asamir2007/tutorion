// Project TTCC
package ttcc.d.a {
	
	//{ =*^_^*= import
	import ttcc.d.ADU;
	//} =*^_^*= END OF import
	
	
	/**
	 * 
	 * @author Jinanoimatey Dragoncat
	 * @version 0.0.0
	 * @created 20.06.2012 23:57
	 */
	public class DUAppComponentCfg extends ADU {
		
		//{ =*^_^*= CONSTRUCTOR
		function DUAppComponentCfg () {
		}
		public function construct(id:String, rawDataObject:Object):void {
			this.id = id;
			this.rawDataObject = rawDataObject;
		}
		public function destruct():void {
		}
		//} =*^_^*= END OF CONSTRUCTOR
		
		public function get_id():String {return id;}
		public function set_id(a:String):void {id = a;}
		
		public function hasPropertyDefined(pn:String):Boolean {return rawDataObject.hasOwnProperty(pn);}
		public function getString(pn:String):String {return rawDataObject[pn];}
		public function getNumber(pn:String):Number {return parseFloat(rawDataObject[pn]);}
		public function getBoolean(pn:String):Boolean {return Boolean(parseInt(rawDataObject[pn]));}
		public function getObject(pn:String):Object {return rawDataObject[pn];}
		
		public function setString(pn:String, pv:String):void {rawDataObject[pn]=pv;}
		public function setNumber(pn:String, pv:Number):void {rawDataObject[pn]=pv;}
		public function setBoolean(pn:String, pv:Boolean):void {rawDataObject[pn]=(pv)?1:0;}
		public function setObject(pn:String, pv:Object):void {rawDataObject[pn]=pv;}
		
		
		
		private var id:String;
		private var rawDataObject:Object;
		
		private var fieldsList:Array=[
			"id"
			,'rawDataObject'
		];
		
		public function toString():String {
			var s:Array=[];
			for each(var i:String in fieldsList) {
				s.push(i.concat('=').concat(this[i]));
			}
			return '{'.concat(s.join(', ')).concat('}');
		}
		
	}
}

//{ =*^_^*= History
/* > (timestamp) [ ("+" (added) ) || ("-" (removed) ) || ("*" (modified) )] (text)
 * > 
 */
//} =*^_^*= END OF History

// template last modified:11.03.2011_[18#51#40]_[5]