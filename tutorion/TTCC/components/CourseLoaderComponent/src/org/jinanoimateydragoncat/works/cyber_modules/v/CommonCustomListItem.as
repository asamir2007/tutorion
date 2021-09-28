package org.jinanoimateydragoncat.works.cyber_modules.v {
	
	//{ =*^_^*= import
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.text.TextField;
	import org.jinanoimateydragoncat.works.cyber_modules.v.Helpers;
	import org.jinanoimateydragoncat.works.cyber_modules.v.ICustomListItem;
	//} =*^_^*= END OF import
	
		/**
		* 
		* @author Jinanoimatey Dragoncat
		* @version 0.0.0
		* @created 27.02.2012 12:59
		*/
		public class CommonCustomListItem extends BaseVC implements ICustomListItem {
			
		//{ =*^_^*= CONSTRUCTOR
		/**
		* @param	target controlled DisplayObject
		* @param	onActivate function (item:ICustomListItem):void;
		*/
		function CommonCustomListItem (target:DisplayObject, onActivate:Function) {
			this.target = target;
			el = onActivate;
			prepareVC();
		}
		//} =*^_^*= END OF CONSTRUCTOR
		
		
		public function set_visible(a:Boolean):void {
			// override and place your code here
		}
		
		
		protected function setText(targetSN:uint, a:String):void {dt[targetSN].text = a;}
		
		protected function getPm(targetSN:uint):DisplayObject {return pm[targetSN];}
		
		protected function prepareVC(configureContainerAsButton:Boolean=true):void {
			if (configureContainerAsButton) {
				Helpers.configureSpriteAsButton(target, target_onPress);
				target.mouseChildren = false;
			}
			var i:String;
			for each(i in get_dts()) {dt.push(target.getChildByName(i));}
			for each(i in get_pms()) {
				pm.push(target.getChildByName(i));
				target.getChildByName(i).visible = false;
			}
		}
		
		/**
		 * denamic text fields
		 */
		protected function get_dts():Array {
			// override and place your code here
		}
		/**
		 * position markers
		 */
		protected function get_pms():Array {
			// override and place your code here
		}
		
		
		private function target_onPress(e:Event):void {activate();}
		protected final function activate():void {el(this);}
		
		private var el:Function;
		
		private var d:Object;
		private var dt:Vector.<TextField> = new Vector.<TextField>();
		private var pm:Vector.<DisplayObject> = new Vector.<DisplayObject>();
		protected function get_target():DisplayObjectContainer {return target;}
		private var target:DisplayObjectContainer;
		
		public function get_data():Object {return d;}
		public function set_data(data:Object):void {
			this.d = data;
			// override and place your code here
		}
		
		
	}
}

//{ =*^_^*= History
/* > (timestamp) [ ("+" (added) ) || ("-" (removed) ) || ("*" (modified) )] (text)
 * > 
 */
//} =*^_^*= END OF History

// template last modified:11.03.2011_[18#51#40]_[5]