package ttcc.v.av {
	
	//{ =^_^= import
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import ttcc.LOG;
	
	import org.aswing.BoxLayout;
	import org.aswing.JButton;
	import org.aswing.JPanel;
	import org.aswing.JScrollBar;
	import org.aswing.JScrollPane;
	import org.aswing.JViewport;
	//} =^_^= END OF import
	
	
	/**
	 * 
	 * @author Jinanoimatey Dragoncat
	 * @version 0.0.0
	 * @created 04.07.2012 2:55
	 */
	public class VCAVContactsList extends JPanel {
		
		//{ =^_^= CONSTRUCTOR
		
		/**
		 * 
		 * @param	eventsPipe see VCAVContactsListElement. сылка на метод для приема сообщений от элементов
		 */
		function VCAVContactsList (eventsPipe:Function, elementWidth:uint=50, elementHeight:uint=50) {
			super(new BoxLayout(BoxLayout.X_AXIS, 1));
			eW=elementWidth;
			eH=elementHeight;
			defaultEventsPipe = eventsPipe;
			//setOpaque(true);
		}
		//} =^_^= END OF CONSTRUCTOR
		
		public function addElementLE(le:VCAVContactsListElement):void {
			for each(var i:VCAVContactsListElement in itemsList) {if (i==le) {LOG(3, 'addElementLE()>target element already present in list, element:'+le, 1);return;}}
			itemsList.push(le);
			append(le);
		}
		
		public function removeElementLEById(id:String):void {
			var found:Boolean;
			for each(var i:VCAVContactsListElement in itemsList) {
				if (i.get_id()==id) {itemsList.splice(itemsList.indexOf(i), 1);found=true;break;}
			}
			if (!found) {
				LOG(3, 'removeElementLE()>target element not found in list, element id:'+id,1);
				return;
			}
			remove(i);
		}
		
/*
		public function addElement(displayName:String, videoVP:DisplayObject, id:String, volumeLevel:int, selected:Boolean):VCAVContactsListElement {
			item = new VCAVContactsListElement(id, defaultEventsPipe, eW, eH, videoVP, displayName, volumeLevel, selected);
			itemsList.push(item);
			append(item);
			return item;
		}
*/		
/*		public function setContent(displayName:Vector.<String>, videoVP:Vector.<DisplayObject>, id:Vector.<uint>, volumLevel:Vector.<int>, selected:Vector.<Boolean>):void {
			var item:VCAVContactsListElement;
			for (var i:uint in displayObject) {
				item = new VCAVContactsListElement(id[i], defaultEventsPipe, eW, eH, videoVP[i], displayName[i], volumLevel[i], selected[i]);
				itemsList.push(item);
				append(item);
			}
		}
*/		
		public function clearContent():void {
			for each(var i:VCAVContactsListElement in itemsList) {
				remove(i);
			}
		}
		
		private var itemsList:Array = [];
		private var defaultEventsPipe:Function;
		
		public function get_elementWidth():uint {return eW;}
		public function get_elementHeight():uint {return eH;}
		
		/**
		 * element width
		 */
		private var eW:uint;
		/**
		 * element height
		 */
		private var eH:uint;
		
		
	}
}

//{ =^_^= History
/* > (timestamp) [ ("+" (added) ) || ("-" (removed) ) || ("*" (modified) )] (text)
 * > 
 */
//} =^_^= END OF History

// template last modified:03.05.2010_[22#42#27]_[1]