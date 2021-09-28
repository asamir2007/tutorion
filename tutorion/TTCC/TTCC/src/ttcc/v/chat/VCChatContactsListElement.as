package ttcc.v.chat {
	
	//{ =^_^= import
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.text.TextFormatAlign;
	import org.aswing.ASColor;
	import org.aswing.border.EmptyBorder;
	import org.aswing.JTextArea;
	import org.aswing.SolidBackground;
	
	
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
		function VCChatContactsListElement (id_:uint, eventsPipe:Function, w:uint, h:uint, avatarImg:DisplayObject, displayName:String, selected:Boolean, userID:String) {
			setSizeWH(w,h);
			defaultEventsPipe = eventsPipe;
			id = id_;
			this.userID = userID;
			setLayout(new BorderLayout(0,1));
			
			img = new JButton('',new AssetIcon(avatarImg, -1,-1,true));
			img.setToolTipText(displayName+'\nотображать/скрывать сообщения этого пользователя\n(убрать этот текст из кода)');
			img.addActionListener(imageButtonPressed);
			img.pack();
			append(img, BorderLayout.WEST);
			
			//if (displayName.length>20) {displayName=displayName.substr(0,20)+'\n'+displayName.substr(21);}
			//var buttonText:JTextArea=new JTextArea('',2,20);
			var buttonText:JTextArea=new JTextArea();
			//buttonText.setAlignmentY(TextFormatAlign.CENTER);
			buttonText.setBackgroundDecorator(new SolidBackground(color));
			buttonText.setBackground(color);
			buttonText.setBorder(new EmptyBorder());
			buttonText.setHtmlText(displayName);
			buttonText.setSizeWH(w-img.getWidth(), h);
			//buttonText.setMaximumWidth(w);
			//buttonText.setMaximumHeight(h);
			buttonText.pack();
			
			//setMaximumWidth(w);
			
			button0=new JButton('', new AssetIcon(buttonText));
			//button0=createHTMLButton('<html>'+displayName+'</html>', buttonPressed, w-img.getWidth());
			button0.setToolTipText(displayName+'\nвставить имя пользователя в сообщение\n(убрать этот текст из кода)');
			
			button0.addActionListener(buttonPressed);
			
			append(button0, BorderLayout.CENTER);
			updateStateDisplay();
		}
		//} =^_^= END OF CONSTRUCTOR
		
		public function get_userID():String {return userID;}
		public function get_id():uint {return id;}
		public function get_selected():Boolean {return state;}
		public function get_state():Boolean {return state;}
		public function set_state(a:Boolean):void {state = a;updateStateDisplay()}
		
		private static const color:ASColor=new ASColor(0,0);
		
		private function updateStateDisplay():void {
			img.setAlpha((state)?1:0.35);
		}
		
		//{ EVENTS
		public static const EVENT_ELEMENT_SELECTED:String = 'event_element_selected';
		public static const EVENT_ELEMENT_STATE_CHANGED:String = 'event_element_state_changed';
		
		
		private function buttonPressed(e:Event=null):void {
			defaultEventsPipe(this, EVENT_ELEMENT_SELECTED);
		}
		
		private function imageButtonPressed(e:Event):void {
			defaultEventsPipe(this, EVENT_ELEMENT_STATE_CHANGED);
		}
		//} END OF EVENTS
		
		private var state:Boolean = true;
		private var img:JButton;
		private var button0:JButton;
		private var id:uint;
		private var userID:String;
		private var defaultEventsPipe:Function;
		
	}
}

//{ =^_^= History
/* > (timestamp) [ ("+" (added) ) || ("-" (removed) ) || ("*" (modified) )] (text)
 * > 
 */
//} =^_^= END OF History

// template last modified:03.05.2010_[22#42#27]_[1]