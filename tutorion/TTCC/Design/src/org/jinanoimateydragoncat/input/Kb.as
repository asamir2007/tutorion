package org.jinanoimateydragoncat.input {
	
	//{ =^_^= import
	import flash.display.DisplayObject;
	import flash.events.KeyboardEvent;
	//} =^_^= END OF import
	
	
	/**
	 * Keyboard Input
	 * @author Jinanoimatey Dragoncat
	 * @version 0.0.0
	 * @created 04.11.2010 18:54
	 * @usage <code>import org.jinanoimateydragoncat.Kb;
	 * k:Kb = new Kb(this);
	 * if (k.s('a')) {trace('key "A" is down');}</code>
	 * onKeyDown(e.keyCode);
	 */
	public class Kb {
		
		//{ =^_^= CONSTRUCTOR
		
		/**
		 * @param displayObject DisplayObject(document class)
		 */
		function Kb (displayObject_:DisplayObject) {
			displayObject = displayObject_;
			enabled = true;
		}
		//} =^_^= END OF CONSTRUCTOR
		
		/**
		 * 
		 * @param	k keyCharCode
		 * @return is key's down
		 */
		public function c(k:int):Boolean {return key[k];}
		
		/**
		 * 
		 * @param	k keyChar
		 * @return is key's down
		 */
		public function s(k:String):Boolean {	return key[k.toUpperCase().charCodeAt()];}
		
		/**
		 * returns array containing pressed key's names
		 * @return null or String[]
		 */
		public function get ls():Array {
			var a:Array = [];
			for (var i:String in key) {
				if (key[int(i)]) {a.push(String.fromCharCode(int(i)));}
			}
			return (a.length > 0)?a:null;
		}
		
		/**
		 * returns array containing pressed key's codes
		 * @return null or String[]
		 */
		public function get lc():* {
			var a:Array = [];
			for (var i:String in key) {
				if (key[int(i)]) {a.push(int(i));}
			}
			return (a.length>0)?a:null;
		}
		
		public function set enabled(a:Boolean):void {
			if (displayObject == null || displayObject.stage == null) {return;}
			if (a) {
				displayObject.stage.addEventListener( KeyboardEvent.KEY_DOWN, down);
				displayObject.stage.addEventListener( KeyboardEvent.KEY_UP, up);
			} else {
				displayObject.stage.removeEventListener( KeyboardEvent.KEY_DOWN, down);
				displayObject.stage.removeEventListener( KeyboardEvent.KEY_UP, up);
			}
		}
		
		/**
		 * onKeyDown reference (keyCode:int)
		 */
		public var onKeyDown:Function;
		
		/**
		 * onKeyUp reference (keyCode:int)
		 */
		public var onKeyUp:Function;
		
		private function down (e:KeyboardEvent):void {
			key[e.keyCode] = true;
			if (onKeyDown != null) {onKeyDown(e.keyCode);}
		}
		
		private function up (e:KeyboardEvent):void {
			key[e.keyCode] = false;
			if (onKeyUp != null) {onKeyUp(e.keyCode);}
		}
		
		private var key:Array = [];
		
		private var displayObject:DisplayObject;
		
		
	}
}

//{ =^_^= History
/* > (timestamp) [ ("+" (added) ) || ("-" (removed) ) || ("*" (modified) )] (text)
 * > 
 */
//} =^_^= END OF History

// template last modified:03.05.2010_[22#42#27]_[1]