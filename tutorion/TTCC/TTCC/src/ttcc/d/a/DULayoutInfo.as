// Project TTCC
package ttcc.d.a {
	
	//{ =*^_^*= import
	import ttcc.d.ADU;
	//} =*^_^*= END OF import
	
	
	/**
	 * 
	 * @author Jinanoimatey Dragoncat
	 * @version 0.0.0
	 * @created 13.09.2012 11:36
	 */
	public class DULayoutInfo extends ADU {
		
		//{ =*^_^*= CONSTRUCTOR
		function DULayoutInfo(id:String, labelID:String, componentsList:Array) {
			this.id = id;
			this.labelID = labelID;
			this.componentsList = componentsList;
		}
		public function destruct():void {
		}
		//} =*^_^*= END OF CONSTRUCTOR
		
		public function get_id():String {return id;}
		//public function set_id(a:String):void {id = a;}
		public function get_componentsList():Array {return componentsList;}
		//public function set_componentsList(a:Array):void {componentsList = a;}
		public function get_labelID():String {return labelID;}
		//public function set_id(a:String):void {id = a;}

		private var id:String;
		private var labelID:String;
		private var componentsList:Array;
		
		private var fieldsList:Array=[
			"id"
			,"labelID"
			,"componentsList"
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