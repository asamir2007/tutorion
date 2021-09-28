package org.jinanoimateydragoncat.works.tutorion.v {
	
	//{ =^_^= import
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.events.Event;
	
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
	 * @created 11.05.2012 16:24
	 */
	public class VCMainPanelContactsList extends JPanel {
		
		//{ =^_^= CONSTRUCTOR
		
		/**
		 * 
		 * @param	eventsPipe see VCMainPanelContactsListElement. сылка на метод для приема сообщений от элементов
		 */
		function VCMainPanelContactsList (eventsPipe:Function, elementWidth:uint=40, elementHeight:uint=10) {
			eW=elementWidth;
			eH=elementHeight;
			defaultEventsPipe = eventsPipe;
			super(new BoxLayout(BoxLayout.Y_AXIS,0));
			//setOpaque(true);
		}
		//} =^_^= END OF CONSTRUCTOR
		
		public function addElement(displayName:String, avatarImage:DisplayObject, id:uint, selected:Boolean):void {
			item = new VCMainPanelContactsListElement(id, defaultEventsPipe, eW, eH, avatarImage, displayName, selected);
			itemsList.push(item);
			append(item);
		}
		
		public function setContent(displayName:Vector.<String>, avatarImage:Vector.<DisplayObject>, id:Vector.<uint>, selected:Vector.<Boolean>):void {
			var item:VCMainPanelContactsListElement;
			for (var i:uint in displayObject) {
				item = new VCMainPanelContactsListElement(id[i], defaultEventsPipe, eW, eH, avatarImage[i], displayName[i], selected[i]);
				itemsList.push(item);
				append(item);
			}
		}
		
		public function clearContent():void {
			for each(var i:VCMainPanelContactsListElement in itemsList) {
				remove(i);
			}
		}
		
		private var itemsList:Array = [];
		private var defaultEventsPipe:Function;
		
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