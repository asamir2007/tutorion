package org.jinanoimateydragoncat.works.tutorion.v {
	
	//{ =*^_^*= import
	import cccct.LOG;
	import ccct.v.AVC;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import org.aswing.AssetIcon;
	import org.aswing.BorderLayout;
	import org.aswing.JButton;
	import org.aswing.JPanel;
	import org.aswing.JScrollPane;
	import org.aswing.JTextArea;
	import org.aswing.JFrame;
	import org.aswing.JTextField;
	import org.jinanoimateydragoncat.works.cyber_modules.v.Helpers;
	import org.jinanoimateydragoncat.works.tutorion.v.AVC;
	//} =*^_^*= END OF import
	
	
	
	/**
	 * 
	 * @author Jinanoimatey Dragoncat
	 * @version 0.0.0
	 * @created 01.03.2012 1:29
	 */
	public class VCChat extends AVC {
		
		//{ =*^_^*= CONSTRUCTOR
		
		public function construct(eventsPipe:Function, windowTitle:String, contactsButtonImage:DisplayObject, enterButtonImage:DisplayObject, contactsList:VCChatContactsList, wndMinW:uint=300, wndMinH:uint=200, inputTextMinH:uint=25,inputTextMaxH:uint=50):void {
			if (!contactsList) {
				throw new ArgumentError('!contactsList');
			}
			wnd_title=windowTitle;
			this.contactsList=contactsList;
			listenerRef=eventsPipe;
			enterButtonImg=enterButtonImage;
			contactsButtonImg=contactsButtonImage;
			
			wnd_minH=wndMinH;
			wnd_minW=wndMinW;
			leftBlock_minW=wnd_minW/2;
			leftBlock_minH=wnd_minH;
			dt_minW=leftBlock_minW;
			it_minH=inputTextMinH;
			it_maxH=inputTextMaxH;
			dt_minH=leftBlock_minH-it_minH;
			b_width = it_minH;
			
			configureVC();
			configureControll();
			//test
			//dt.setHtmlText('text <i>italic</i><b>bold</b>');
			
		}
		//} =*^_^*= END OF CONSTRUCTOR
		
		
		//{ =*^_^*= user access
		public override function getTextInput(inputID:uint):String {
			switch (inputID) {
			
			case ID_TEXT_IN_0:
				return it.getText();
				break;
			}
		}
		
		/*public override function setTextOutput(outputID:uint, text:String):void {
			switch (inputID) {
			
			case ID_TEXT_OUT_0:
				dt.setHtmlText(text);
				break;
			}
		}
		*/
		
		public function setOutText(text:String):void {
			dt.setHtmlText(text);
		}
		
		public function addToOutText(text:String):void {
			dt.appendText(text);
		}
		
		public override function setTextInput(inputID:uint, text:String):void {
			switch (inputID) {
			
			case ID_TEXT_IN_0:
				it.setText(text);
				break;
			}
		}
		//} =*^_^*= END OF user access
		
		//{ =*^_^*= id
		/**
		 * отображаемый в чате html в поле вывода
		 */
		public static const ID_TEXT_OUT_0:uint=0;
		/**
		 * текст вводимый пользователем
		 */
		public static const ID_TEXT_IN_0:uint=0;
		//} =*^_^*= END OF id
		
		
		//{ =*^_^*= view
		private function configureVC():void {
			// prepare frame
			vc=new JFrame(null, wnd_title);
			vc.getContentPane().setLayout(new BorderLayout(0,0));
			var titlebarH:uint=vc.getTitleBar().getSelf().getInsets().getMarginHeight();
			vc.setMinimumWidth(wnd_minW);
			vc.setMinimumHeight(wnd_minH+titlebarH);
			vc.setSizeWH(wnd_minW,wnd_minH+titlebarH);
			
			
			//L
			var leftBlock:JPanel = new JPanel(new BorderLayout(0,0));
			leftBlock.setMinimumWidth(leftBlock_minW);leftBlock.setMinimumHeight(leftBlock_minH);
			// dt
			dt=new JTextArea;
			dt.setEditable(false);dt.setWordWrap(true);
			leftBlock.append(new JScrollPane(dt, JScrollPane.SCROLLBAR_AS_NEEDED, JScrollPane.SCROLLBAR_NEVER), BorderLayout.CENTER);
			
			var leftBlockInput:JPanel = new JPanel(new BorderLayout(0,0));
			leftBlockInput.setMinimumWidth(dt_minW);
			leftBlockInput.setMinimumHeight(it_minH);
			
			//it
			it=new JTextField('');
			//var sc:JScrollPane=new JScrollPane(it, JScrollPane.SCROLLBAR_AS_NEEDED, JScrollPane.SCROLLBAR_NEVER);
			
			leftBlockInput.append(it, BorderLayout.CENTER);
			
			
			//enter b
			b= new JButton('',new AssetIcon(enterButtonImg));b.name='bSend';
			b.addActionListener(el_buttons);
			b.setMaximumWidth(b_width);
			//b.setMaximumHeight(it_minH);
			leftBlockInput.append(b, BorderLayout.EAST);
			
			leftBlock.append(leftBlockInput, BorderLayout.SOUTH);
			
			vc.getContentPane().append(leftBlock, BorderLayout.CENTER);
			
			//R
			rightBlock = new JPanel(new BorderLayout());
			
			//contacts b
			bContacts = new JButton('',new AssetIcon(contactsButtonImg));bContacts.name='bContacts';
			bContacts.addActionListener(el_buttons);
			rightBlock.append(bContacts, BorderLayout.CENTER);
			
			//list
			contactsListContainer=new JScrollPane(contactsList, JScrollPane.SCROLLBAR_ALWAYS, JScrollPane.SCROLLBAR_NEVER);
			
			rightBlock.append(contactsListContainer, BorderLayout.EAST);
			
			vc.getContentPane().append(rightBlock, BorderLayout.EAST);
			
			
			//c
			vc.show();
		}
		
		public function set_visible(a:Boolean):void {
			if (a) {
				vc.show();
			} else {
				vc.hide();
			}
		}
		
		public function get_displayObject():DisplayObject {return vc;}
		
		private var wnd_title:String;
		
		private var vc:JFrame;
		private var dt:JTextArea;
		private var it:JTextField;
		private var b:JButton;
		private var bContacts:JButton;
		private var rightBlock:JPanel;
		
		public function get_contactsList():VCChatContactsList {return contactsList;}
		private var contactsList:VCChatContactsList;
		private var contactsListContainer:JScrollPane;
		//} =*^_^*= END OF view
		
		
		//{ =*^_^*= controll
		private function configureControll():void {
		}
		private function el_buttons(e:Event):void {
			switch (e.target.name) {
			
			case 'bContacts':
				if (rightBlock.contains(contactsListContainer)) {
					rightBlock.remove(contactsListContainer);
				} else {
					rightBlock.append(contactsListContainer, BorderLayout.EAST);
				}
				break;
			case 'bSend':
				listenerRef(this, ID_E_BUTTON_SEND);
				break;
			
			}
		}
		//} =*^_^*= END OF controll
		
		
		//{ =*^_^*= events
		/**
		 * @param	listener function (target:VCChat, eventType:String, details:Object=null):void;
		 */
		public function setListener(listener:Function):void {
			this.listener = listener;
		}
		private var listener:Function;
		//} =*^_^*= END OF events
		
		
		//{ =*^_^*= data
		private var enterButtonImg:DisplayObject;
		private var contactsButtonImg:DisplayObject;
		
		private var wnd_minH:uint;
		private var wnd_minW:uint;
		private var leftBlock_minH:uint;
		private var leftBlock_minW:uint;
		private var dt_minW:uint;
		private var dt_minH:uint;
		private var it_minH:uint;
		private var it_maxH:uint;
		private var b_width:uint;
		//} =*^_^*= END OF data
		
		//{ =*^_^*= id
		public static const ID_E_BUTTON_SEND:String = '>ID_E_BUTTON_SEND';
		//} =*^_^*= END OF id
		
		
	}
}

//{ =*^_^*= History
/* > (timestamp) [ ("+" (added) ) || ("-" (removed) ) || ("*" (modified) )] (text)
 * > 
 */
//} =*^_^*= END OF History

// template last modified:11.03.2011_[18#51#40]_[5]