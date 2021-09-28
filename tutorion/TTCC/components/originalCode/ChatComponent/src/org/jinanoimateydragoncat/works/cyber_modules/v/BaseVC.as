package org.jinanoimateydragoncat.works.cyber_modules.v {
	
	//{ =*^_^*= import
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	//} =*^_^*= END OF import
	
	
	/**
	 * 
	 * @author Jinanoimatey Dragoncat
	 * @version 0.0.0
	 * @created 27.02.2012 19:48
	 */
	public class BaseVC {
		
		//{ =*^_^*= CONSTRUCTOR
		
		function BaseVC () {}
		//} =*^_^*= END OF CONSTRUCTOR
		
		
		//{ =*^_^*= user access
		
		//{ =*^_^*= prepared
		/**
		 * @param	listener function(instance:BaseVC, buttonId:uint)
		 */
		public function set_el_buttonInput(listener:Function):void {
			// override and place your code here
			el_b_in = listener;
		}
		public function setTextOutput(outputID:uint, text:String):void {
			// override and place your code here
			setDT(outputID, text);
		}
		public function setTextInput(inputID:uint, text:String):void {
			// override and place your code here
			setIT(inputID, text);
		}
		public function getTextInput(inputID:uint):String {
			// override and place your code here
			return getIT(inputID).text;
		}
		//} =*^_^*= END OF prepared
		
		//{ =*^_^*= override
		public function set_el_UintListInputSelected(listener:Function):void {
			// override and place your code here
		}
		public function setImageOutput(outputID:uint, image:DisplayObject):void {
			// override and place your code here
		}
		public function setNumberOutput(outputID:uint, value:Number):void {
			// override and place your code here
		}
		public function setBooleanOutput(outputID:uint, value:Boolean):void {
			// override and place your code here
		}
		public function setUintOutput(outputID:uint, value:uint):void {
			// override and place your code here
		}
		
		public function setTextListOutput(outputID:uint, text:Array):void {
			// override and place your code here
		}
		public function setTextListInput(inputID:uint, text:Array):void {
			// override and place your code here
		}
		public function setImageListOutput(outputID:uint, image:Array):void {
			// override and place your code here
		}
		public function setNumberListOutput(outputID:uint, value:Array):void {
			// override and place your code here
		}
		public function setBooleanListOutput(outputID:uint, value:Array):void {
			// override and place your code here
		}
		public function setUintListOutput(outputID:uint, value:Array):void {
			// override and place your code here
		}
		public function setEnabled(value:Boolean):void {
			// override and place your code here
		}
		
		public function getBooleanInput(inputID:uint):Boolean {
			return false;// override and place your code here
		}
		public function getNumberInput(inputID:uint):Number {
			return 0;// override and place your code here
		}
		public function getUintInput(inputID:uint):uint {
			return 0;// override and place your code here
		}
		
		public function getBooleanListInput(inputID:uint):Array {
			return null;// override and place your code here
		}
		public function getNumberListInput(inputID:uint):Array {
			return null;// override and place your code here
		}
		public function getUintListInput(inputID:uint):Array {
			return null;// override and place your code here
		}
		public function getTextListInput(inputID:uint):Array {
			return null;// override and place your code here
		}
		
		public function update():void {
			// override and place your code here
		}
		//} =*^_^*= END OF override
		
		//{ =*^_^*= tools
		
		/**
		 * affects button listeners
		 */
		public function set_enabled(a:Boolean):void {
			var i:uint=0;
			var b:DisplayObject=getB(i);
			while (b!=null) {
				configureSpriteAsButton(b, el_bPressed, a);
				i+=1;
				b=getB(i);
			}
		}
		
		//} =*^_^*= END OF tools
		
		//} =*^_^*= END OF user access
		
		/**
		 * use this method in your custom class implementation
		 * @param	buttonId
		 */
		protected function buttonPressed(buttonId:uint):void {
			if (el_b_in!=null) {
				el_b_in(this, buttonId);
			}
		}
		
		private function el_bPressed(e:Event):void {
			var n:Number=parseInt(String(e.target.name).substr(1));
			if (!isNaN(n)) {buttonPressed(n);} else {trace('BaseVC>'+'isNaN(e.target.name.substr(1))');}
		}
		
		public function getID():uint {
			// override and place your code here
			return 0;
		}
		public function get_container():DisplayObjectContainer {return container;}
		public function set_container(a:DisplayObjectContainer ):void {container = a;}
		protected var el_b_in:Function;
		private var container:DisplayObjectContainer;
		
		/**
		 * example - place controll descr here
		 */
		//public static const ID_TEXT_OUT_0:uint=0;
		
		//{ =*^_^*= Helpers
		protected function setDT(id:uint, text:String):void {getDT(id).text = text;}
		protected function setIT(id:uint, text:String):void {getIT(id).text = text;}
		
		protected function getDT(id:uint):TextField {return container.getChildByName('dt'+id);}
		protected function getPM(id:uint):DisplayObject {return container.getChildByName('pm'+id);}
		protected function getIT(id:uint):TextField {return container.getChildByName('it'+id);}
		protected function getST(id:uint):TextField {return container.getChildByName('st'+id);}
		protected function getB(id:uint):DisplayObject {return container.getChildByName('b'+id);}
		
		/**
		 * mouseChildren, buttonMode, useHandCursor; MOUSE_DOWN
		 * @param onPressEventListener (e:Event)
		 */
		public static function configureSpriteAsButton(targetSprite:DisplayObject, onPressEventListener:Function, add:Boolean=true):void {
			if (targetSprite is DisplayObjectContainer) {DisplayObjectContainer(targetSprite).mouseChildren = !add;}
			
			if (targetSprite.hasOwnProperty("buttonMode")) {
				targetSprite["buttonMode"] = add;
			}
			if (targetSprite.hasOwnProperty("useHandCursor")) {
				targetSprite["useHandCursor"] = add;
			}
			
			if (add) {
				targetSprite.addEventListener(MouseEvent.MOUSE_DOWN, onPressEventListener);
			} else {
				targetSprite.removeEventListener(MouseEvent.MOUSE_DOWN, onPressEventListener);
			}
		}
		//} =*^_^*= END OF Helpers
		
	}
}

//{ =*^_^*= History
/* > (timestamp) [ ("+" (added) ) || ("-" (removed) ) || ("*" (modified) )] (text)
 * > 
 */
//} =*^_^*= END OF History

// template last modified:11.03.2011_[18#51#40]_[5]