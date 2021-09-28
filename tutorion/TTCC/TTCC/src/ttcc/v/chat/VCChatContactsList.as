package ttcc.v.chat {
	
	//{ =^_^= import
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import org.aswing.BorderLayout;
	import org.aswing.FlowLayout;
	
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
	public class VCChatContactsList extends JPanel {
		
		//{ =^_^= CONSTRUCTOR
		
		/**
		 * 
		 * @param	eventsPipe see VCChatContactsListElement. сылка на метод для приема сообщений от элементов
		 */
		function VCChatContactsList (eventsPipe:Function, elementWidth:uint=150, elementHeight:uint=20) {
			super(new BorderLayout());
			contentPane=new JPanel(new BoxLayout(BoxLayout.Y_AXIS,0));
			append(contentPane, BorderLayout.NORTH);
			
			eW=elementWidth;
			eH=elementHeight;
			defaultEventsPipe = eventsPipe;
			//setOpaque(true);
		}
		//} =^_^= END OF CONSTRUCTOR
		public function getElementById(userID:String):VCChatContactsListElement {
			for each(var i:VCChatContactsListElement in itemsList) {if (i.get_userID()==userID) {return i;}}
			return null;
		}
		
		public function addElement(displayName:String, avatarImage:DisplayObject, id:uint, selected:Boolean, userID:String):void {
			//var item:VCChatContactsListElement;
			//for (var i:int = 0; i < 24;i++) {
				var item:VCChatContactsListElement = new VCChatContactsListElement(id, defaultEventsPipe, eW, eH, avatarImage, displayName, selected, userID);
				itemsList.push(item);
				contentPane.append(item);
			//}
		}
		
		//not used yet
/*		public function setContent(displayName:Vector.<String>, avatarImage:Vector.<DisplayObject>, id:Vector.<uint>, selected:Vector.<Boolean>):void {
			var item:VCChatContactsListElement;
			for (var i:uint in displayObject) {
				item = new VCChatContactsListElement(id[i], defaultEventsPipe, eW, eH, avatarImage[i], displayName[i], selected[i]);
				itemsList.push(item);
				append(item);
			}
		}
*/		
		public function clearContent():void {
			/*for each(var i:VCChatContactsListElement in itemsList) {
				contentPane.remove(i);
			}
			*/
			contentPane.removeAll();
			itemsList = [];
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
		
		
		private var contentPane:JPanel;
		private var contentContentPane:JPanel;
	}
}

//{ =^_^= History
/* > (timestamp) [ ("+" (added) ) || ("-" (removed) ) || ("*" (modified) )] (text)
 * > 
 */
//} =^_^= END OF History

// template last modified:03.05.2010_[22#42#27]_[1]