// Project TTCC
package  ttcc.c.vcm.d {
	
	//{ =*^_^*= import
	//} =*^_^*= END OF import
	
	
	/**
	 * 
	 * @author Jinanoimatey Dragoncat
	 * @version 0.0.0
	 * @created 20.08.2012 10:49
	 */
	public class DUMPElement implements IDUMPElement {
		
		//{ =*^_^*= CONSTRUCTOR
		/**
		 * 
		 * @param	id
		 * @param	position -1 = any; 333333 = middle; 666666 = end;
		 */
		function DUMPElement (id:String, position:int) {
			this.id = id;
			this.position = position;
		}
		//} =*^_^*= END OF CONSTRUCTOR
		
		
		
		public function get_position():int {return position;}
		public function set_position(a:int):void {position = a;}
		public function get_id():String {return id;}
		public function set_id(a:String):void {id = a;}
		
		
		private var id:String;
		private var position:int;
	}
}

//{ =*^_^*= History
/* > (timestamp) [ ("+" (added) ) || ("-" (removed) ) || ("*" (modified) )] (text)
 * > 
 */
//} =*^_^*= END OF History

// template last modified:11.03.2011_[18#51#40]_[5]