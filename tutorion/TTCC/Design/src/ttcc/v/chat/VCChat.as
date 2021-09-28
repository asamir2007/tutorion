package ttcc.v.chat {
	
	//{ =*^_^*= import
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import org.aswing.ASColor;
	import org.aswing.AssetIcon;
	import org.aswing.BorderLayout;
	import org.aswing.CustomJFrame;
	import org.aswing.JButton;
	import org.aswing.JPanel;
	import org.aswing.JScrollPane;
	import org.aswing.JTextArea;
	import org.aswing.JFrame;
	import org.aswing.JTextField;
	import org.aswing.JViewport;
	import org.aswing.SoftBoxLayout;
	import org.aswing.SolidBackground;
	import ttcc.APP;
	import ttcc.d.m.GUIWindowModel;
	import ttcc.LOG;
	import ttcc.media.PictureStoreroom;
	import ttcc.media.Text;
	import ttcc.v.AVCWW;
	import ttcc.v.Lib;
	//} =*^_^*= END OF import
	
	
	
	/**
	 * 
	 * @author Jinanoimatey Dragoncat
	 * @version 0.0.0
	 * @created 01.03.2012 1:29
	 */
	public class VCChat extends AVCWW {
		
		//{ =*^_^*= CONSTRUCTOR
		
		public function setResources(windowTitle:String, contactsButtonImage:DisplayObject, enterButtonImage:Array, windowIconImage:DisplayObject, wndMinW:uint=350, wndMinH:uint=250, inputTextMinH:uint=20,inputTextMaxH:uint=50, sendButtonWidth:Number=-1):void {
			this.wnd_title=windowTitle;
			this.enterButtonImg=enterButtonImage;
			this.contactsButtonImg=contactsButtonImage;
			this.windowIconImage=windowIconImage;
			
			wnd_minH=wndMinH;
			wnd_minW=wndMinW;
			leftBlock_minW=wnd_minW/2;
			leftBlock_minH=wnd_minH;
			dt_minW=leftBlock_minW;
			it_minH=inputTextMinH;
			it_maxH=inputTextMaxH;
			dt_minH=leftBlock_minH-it_minH;
			b_width = sendButtonWidth;
		}
		public function construct(contactsList:VCChatContactsList):void {
			if (!contactsList) {
				throw new ArgumentError('!contactsList');
			}
			this.contactsList=contactsList;
			
			
			configureVC();
			//configureControll();
			//test
			//dt.setHtmlText('text <i>italic</i><b>bold</b>');
			
		}
		//} =*^_^*= END OF CONSTRUCTOR
		
		
		//{ =*^_^*= user access
		public function setItFocus(selectAll:Boolean=false):void {
			it.makeFocus();
			it.setSelection(it.getText().length, it.getText().length);
		}
		
		public function redraw():void {
			vc.revalidate();
		}
		
		public function getTextInput(inputID:uint):String {
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
			dt.setHtmlText(dt.getHtmlText().concat(text));
		}
		
		public function scrollMsgDTToBottom():void {
			vc.set_canUpdateModel_scrollers(false);
			dt.scrollToBottomRight();
			vc.set_canUpdateModel_scrollers(true);
		}
		
		public function setTextInput(inputID:uint, text:String):void {
			switch (inputID) {
			
			case ID_TEXT_IN_0:
				it.setText(text);
				el_itFocus(it.getTextField().text.length>3);
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
			vc=new CustomJFrame(getAppRef_().get_mainScreen(), null, wnd_title);
			vc.construct(NAME);
			vc.set_el_containerVisibilityChanged(el_cv);
			registerGUIWindowModel(vc.getModel());
			//addToContainer();
			vc.setIcon(new AssetIcon(windowIconImage,-1,-1,true));
			
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
			dtScrollPane=new JScrollPane(dt, JScrollPane.SCROLLBAR_AS_NEEDED, JScrollPane.SCROLLBAR_NEVER);
			leftBlock.append(dtScrollPane, BorderLayout.CENTER);
			
			var leftBlockInput:JPanel = new JPanel(new BorderLayout(0,0));
			leftBlockInput.setMinimumWidth(dt_minW);
			leftBlockInput.setMinimumHeight(it_minH);
			
			//it
			it=new JTextField('');
			//var sc:JScrollPane=new JScrollPane(it, JScrollPane.SCROLLBAR_AS_NEEDED, JScrollPane.SCROLLBAR_NEVER);
			leftBlockInput.append(it, BorderLayout.CENTER);
			//it.getTextField().addEventListener(FocusEvent.FOCUS_IN, el_itFocus);
			//it.getTextField().addEventListener(FocusEvent.FOCUS_OUT, el_itFocus);
			
			//user pressed enter key, it has focus
			var chatRef:VCChat=this;
			it.getTextField().addEventListener(Event.CHANGE, function(e:Event):void {
				el_itFocus(it.getTextField().text.length>3);
			});
			it.addEventListener(KeyboardEvent.KEY_DOWN, function(e:KeyboardEvent):void {
				if (KeyboardEvent(e).keyCode==Keyboard.ENTER) {
					dt.appendText('\nuser: '+it.getText());
					it.setText('');
				}
			});
			
			
			//enter b
			var settingsP:JPanel=new JPanel(new SoftBoxLayout(SoftBoxLayout.X_AXIS, 1, SoftBoxLayout.CENTER));
			var zbt:JButton;
			zbt=Lib.createIconifiedButton('toolZoomP', el_buttons, '', [
			PictureStoreroom.getPicture('zoom_p_w')
			,PictureStoreroom.getPicture('zoom_p_b')
			,PictureStoreroom.getPicture('zoom_p_p')
			],false,true,'шрифт +');
			settingsP.append(zbt);
			zbt=Lib.createIconifiedButton('toolZoomM', el_buttons, '', [
			PictureStoreroom.getPicture('zoom_m_w')
			,PictureStoreroom.getPicture('zoom_m_b')
			,PictureStoreroom.getPicture('zoom_m_p')
			],false,true,'шрифт -');
			settingsP.append(zbt);
			
			zbt=Lib.createIconifiedButton('toggle', el_buttons, '', [
				PictureStoreroom.getPicture('circle_w')
				,PictureStoreroom.getPicture('circle_b')
				,PictureStoreroom.getPicture('circle_p')
				],false,true,'показать/скрыть время');
			//zbt=Lib.createSimpleButton('toggleTime', el_buttons, 'T', true,true,'скрыть показать время');
			settingsP.append(zbt);
			
			
			//b= Lib.createIconifiedButton('bSend', el_buttons, '', enterButtonImg,false,true,APP.lText().get_TEXT(Text.ID_TEXT_CHAT_SEND_BUTTON));
			leftBlockInput.append(settingsP, BorderLayout.EAST);
			
			leftBlock.append(leftBlockInput, BorderLayout.SOUTH);
			
			vc.getContentPane().append(leftBlock, BorderLayout.CENTER);
			
			//R
			rightBlock = new JPanel(new BorderLayout());
			
			//contacts b
			bContacts = new JButton('', new AssetIcon(contactsButtonImg));bContacts.name='bContacts';
			bContacts.addActionListener(el_buttons);
			//rightBlock.append(bContacts, BorderLayout.WEST);
			
			//list
			//contactsListContainer0=new JViewport(contactsList, false, true);
			//contactsListContainer0.scro
			//rightBlock.append(contactsListContainer0, BorderLayout.CENTER);
			
			contactsListContainer=new JScrollPane(contactsList, JScrollPane.SCROLLBAR_AS_NEEDED, JScrollPane.SCROLLBAR_NEVER);
			JViewport(contactsListContainer.getViewport()).setVerticalAlignment(JViewport.TOP);
			
			//rightBlock.append(contactsListContainer, BorderLayout.CENTER);
			
			vc.getContentPane().append(rightBlock, BorderLayout.EAST);
			
			//register scroller
			vc.regiterScrollBar(GUIWindowModel.ID_P_SSV_0, dtScrollPane.getVerticalScrollBar());
			vc.regiterScrollBar(GUIWindowModel.ID_P_SSV_1, contactsListContainer.getVerticalScrollBar());
			
			//c
			vc.show();
		}
		
		private function addToContainer():void {
			container.parent.addChild(vc);
			container.parent.swapChildren(container, vc);
			container.parent.removeChild(container);
			container=vc;
		}
		
		
		public function get_displayObject():DisplayObject {return container;}
		
		private var wnd_title:String;
		
		private var container:Sprite=new Sprite;
		private var dt:JTextArea;
		private var dtScrollPane:JScrollPane
		private var it:JTextField;
		private var b:JButton;
		private var bContacts:JButton;
		private var rightBlock:JPanel;
		
		public function get_contactsList():VCChatContactsList {return contactsList;}
		private var contactsList:VCChatContactsList;
		private var contactsListContainer:JScrollPane;
		private var contactsListContainer0:JViewport;
		//} =*^_^*= END OF view
		
		
		//{ =*^_^*= controll
		private function configureControll():void {
		}
		
		//private function el_itFocus(e:FocusEvent):void {
		private function el_itFocus(e:Boolean):void {
			switch (int(e)) {
			
			case 0:
				if (lastFocus==0) {break;}lastFocus=0;
				listener(this, ID_E_IT_FOCUS_OUT);
				break;
			case 1:
				if (lastFocus==1) {break;}lastFocus=1;
				listener(this, ID_E_IT_FOCUS_IN);
				break;
			}
		}
		
		
		
		private function el_buttons(e:Event):void {
			switch (e.target.name) {
			
			case 'bContacts':
				vc.getModel().set_containerVisibility(GUIWindowModel.ID_P_C_V_0, !vc.getModel().get_containerVisibility(GUIWindowModel.ID_P_C_V_0));
				break;
			case 'bSend':
				listener(this, ID_E_BUTTON_SEND);
				break;
			
			}
		}
		
		private function el_cv(elementID:uint, value:Boolean):void {
			if (elementID!=GUIWindowModel.ID_P_C_V_0) {return;}
			
			if (value) {
				if (rightBlock.contains(contactsListContainer)) {rightBlock.remove(contactsListContainer);}
			} else {
				if (!rightBlock.contains(contactsListContainer)) {rightBlock.append(contactsListContainer, BorderLayout.EAST);}
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
		private var enterButtonImg:Array;
		private var contactsButtonImg:DisplayObject;
		private var windowIconImage:DisplayObject;
		
		private var wnd_minH:uint;
		private var wnd_minW:uint;
		private var leftBlock_minH:uint;
		private var leftBlock_minW:uint;
		private var dt_minW:uint;
		private var dt_minH:uint;
		private var it_minH:uint;
		private var it_maxH:uint;
		private var lastFocus:int=4;
		private var b_width:Number;
		//} =*^_^*= END OF data
		
		//{ =*^_^*= id
		public static const ID_E_BUTTON_SEND:String = '>ID_E_BUTTON_SEND';
		public static const ID_E_IT_FOCUS_IN:String = '>ID_E_IT_FOCUS_IN';
		public static const ID_E_IT_FOCUS_OUT:String = '>ID_E_IT_FOCUS_OUT';
		//} =*^_^*= END OF id
		
		public static const NAME:String='VCChat';
	}
}

//{ =*^_^*= History
/* > (timestamp) [ ("+" (added) ) || ("-" (removed) ) || ("*" (modified) )] (text)
 * > 
 */
//} =*^_^*= END OF History

// template last modified:11.03.2011_[18#51#40]_[5]