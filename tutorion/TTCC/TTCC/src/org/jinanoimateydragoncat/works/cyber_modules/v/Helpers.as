package org.jinanoimateydragoncat.works.cyber_modules.v {
	
	//{ =*^_^*= import
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	//} =*^_^*= END OF import
	
	
	/**
	 * 
	 * @author Jinanoimatey Dragoncat
	 * @version 0.0.0
	 * @created 04.02.2012 20:40
	 */
	public class Helpers {
		
		//{ =*^_^*= CONSTRUCTOR
		
		function Helpers () {
		}
		//} =*^_^*= END OF CONSTRUCTOR
		
				//{ =^_^= =^_^= Helpers
		/**
		 * mouseChildren, buttonMode, useHandCursor; MOUSE_DOWN
		 * @param onPressEventListener (e:Event)
		 */
		public static function configureSpriteAsButton(targetSprite:DisplayObject, onPressEventListener:Function, add:Boolean=true):void {
			if (targetSprite is DisplayObjectContainer) {DisplayObjectContainer(targetSprite).mouseChildren = !add;}
			if (targetSprite is Sprite) {
				Sprite(targetSprite).buttonMode = add;
				Sprite(targetSprite).useHandCursor = add;
			}
			if (add) {
				targetSprite.addEventListener(MouseEvent.MOUSE_DOWN, onPressEventListener);
			} else {
				targetSprite.removeEventListener(MouseEvent.MOUSE_DOWN, onPressEventListener);
			}
		}
		//} =^_^= =^_^= END OF Helpers
	}
}

//{ =*^_^*= History
/* > (timestamp) [ ("+" (added) ) || ("-" (removed) ) || ("*" (modified) )] (text)
 * > 
 */
//} =*^_^*= END OF History

// template last modified:11.03.2011_[18#51#40]_[5]