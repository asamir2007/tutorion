// Project TTCC
package  ttcc.c.vcm.d {
	
	//{ =*^_^*= import
	//} =*^_^*= END OF import
	
	
	/**
	 * 
	 * @author Jinanoimatey Dragoncat
	 * @version 0.0.0
	 * @created 26.06.2012 20:09
	 */
	public class DUMPButton implements IDUMPElement {
		
		//{ =*^_^*= CONSTRUCTOR
		/**
		 * 
		 * @param	id
		 * @param	position -1 = any; 333333 = middle; 666666 = end;
		 * @param	iconUp
		 * @param	iconOver
		 * @param	iconDown
		 * @param	textTip
		 */
		function DUMPButton (id:String, position:int, iconUp:String, iconOver:String, iconDown:String, textTip:String=null) {
			this.id = id;
			this.position = position;
			this.iconUp = iconUp;
			this.iconOver = iconOver;
			this.iconDown = iconDown;
			this.textTip = textTip;
		}
		public function construct():void {
		}
		public function destruct():void {
		}
		//} =*^_^*= END OF CONSTRUCTOR
		
		
		
		public function get_textTip():String {return textTip;}
		public function set_textTip(a:String):void {textTip = a;}		
		public function get_iconUp():String {return iconUp;}
		public function set_iconUp(a:String):void {iconUp = a;}
		public function get_iconOver():String {return iconOver;}
		public function set_iconOver(a:String):void {iconOver = a;}
		public function get_iconDown():String {return iconDown;}
		public function set_iconDown(a:String):void {iconDown = a;}
		public function get_position():int {return position;}
		public function set_position(a:int):void {position = a;}
		public function get_id():String {return id;}
		public function set_id(a:String):void {id = a;}
				
		
		
		private var id:String;
		private var position:int;
		private var iconUp:String;
		private var iconOver:String;
		private var iconDown:String;		
		private var textTip:String;		
	}
}

//{ =*^_^*= History
/* > (timestamp) [ ("+" (added) ) || ("-" (removed) ) || ("*" (modified) )] (text)
 * > 
 */
//} =*^_^*= END OF History

// template last modified:11.03.2011_[18#51#40]_[5]