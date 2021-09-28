package org.jinanoimateydragoncat.works.tutorion.v {
	
	//{ =^_^= import
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.events.Event;
	
	
	import org.aswing.BorderLayout;
	import org.aswing.AssetIcon;
	import org.aswing.JButton;
	import org.aswing.JPanel;
	//} =^_^= END OF import
	
	
	/**
	 * 
	 * @author Jinanoimatey Dragoncat
	 * @version 0.0.0
	 * @created 11.05.2012 16:24
	 */
	public class VCChatContactsListElement extends JPanel {
		
		//{ =^_^= CONSTRUCTOR
		
		/**
		 * 
		 * @param	avatarImg user's avatar image
		 * @param	id_
		 * @param	eventsPipe function (target:VCChatContactsListElement, eventType:String):void; see events section for more details
		 */
		function VCChatContactsListElement (id_:uint, eventsPipe:Function, w:uint, h:uint, avatarImg:DisplayObject, displayName:String, selected:Boolean) {
			setSizeWH(w,h);
			defaultEventsPipe = eventsPipe;
			id = id_;
			setLayout(new BorderLayout(0,1));
			
			img = new JButton('',new AssetIcon(avatarImg));
			img.setToolTipText(displayName+'\nотображать/скрывать сообщения этого пользователя\n(убрать этот текст из кода)');
			img.addActionListener(imageButtonPressed);
			append(img, BorderLayout.WEST);
			
			button0=new JButton(displayName);
			button0.setToolTipText(displayName+'\nвставить имя пользователя в сообщение\n(убрать этот текст из кода)');
			
			button0.addActionListener(buttonPressed);
			append(button0, BorderLayout.CENTER);
			state=selected;
			updateStateDisplay();
		}
		//} =^_^= END OF CONSTRUCTOR
		
		public function get_id():uint {return id;}
		public function get_selected():Boolean {return state;}
		
		private function updateStateDisplay():void {
			img.setAlpha((state)?1:0.6);
		}
		
		//{ EVENTS
		public static const EVENT_ELEMENT_SELECTED:String = 'event_element_selected';
		public static const EVENT_ELEMENT_STATE_CHANGED:String = 'event_element_state_changed';
		
		private function buttonPressed(e:Event=null):void {
			defaultEventsPipe(this, EVENT_ELEMENT_SELECTED);
		}
		
		private function imageButtonPressed(e:Event):void {
			state = !state;
			updateStateDisplay();
			defaultEventsPipe(this, EVENT_ELEMENT_STATE_CHANGED);
		}
		//} END OF EVENTS
		
		private var state:Boolean = false;
		private var img:JButton;
		private var button0:JButton;
		private var id:uint;
		private var defaultEventsPipe:Function;
		
	}
}

//{ =^_^= History
/* > (timestamp) [ ("+" (added) ) || ("-" (removed) ) || ("*" (modified) )] (text)
 * > 
 */
//} =^_^= END OF History

// template last modified:03.05.2010_[22#42#27]_[1]