package ttcc.v.r {
	
	//{ =*^_^*= import
	import flash.events.MouseEvent;
	import org.aswing.CustomJFrame;
	import org.aswing.JSlider;
	import org.aswing.JTextArea;
	import org.aswing.JTextField;
	import ttcc.APP;
	import ttcc.LOG;
	import ttcc.v.AVCWW;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import org.aswing.AssetIcon;
	import org.aswing.border.EmptyBorder;
	import org.aswing.BorderLayout;
	import org.aswing.BoxLayout;
	import org.aswing.colorchooser.VerticalLayout;
	import org.aswing.FlowLayout;
	import org.aswing.JButton;
	import org.aswing.JFrame;
	import org.aswing.JTextArea;
	import org.aswing.JPanel;
	import org.aswing.JProgressBar;
	import org.aswing.JScrollBar;
	import org.aswing.JScrollPane;
	import org.aswing.SoftBoxLayout;
	//} =*^_^*= END OF import
	
	
	
	/**
	 * 
	 * @author Jinanoimatey Dragoncat
	 * @version 0.0.0
	 * @created 05.08.2012 17:54
	 */
	public class VCReplayManager extends AVCWW {
		
		//{ =*^_^*= CONSTRUCTOR
		
		public function setResources(windowTitle:String, labelButtonRecord:String, labelButtonStop:String, labelButtonPlay:String, windowIconImage:DisplayObject, wndMinW:uint=300, wndMinH:uint=100):void {
			this.labelButtonRecord = labelButtonRecord;
			this.labelButtonStop = labelButtonStop;
			this.labelButtonPlay = labelButtonPlay;
			
			wnd_title=windowTitle;
			wnd_minH=wndMinH;
			wnd_minW=wndMinW;
			this.windowIconImage=windowIconImage;
		}
		
		public function construct(eventsPipe:Function, owner:DisplayObjectContainer):void {
			listenerRef=eventsPipe;
			
			configureVC(owner);
			configureControll();
		}
		//} =*^_^*= END OF CONSTRUCTOR
		
		
		//{ =*^_^*= user access
		
		
		/*public function setTextOutput(outputID:uint, text:String):void {
			switch (outputID) {
			
			case ID_OUT_TEXT_TIME:
				if (text==null) {text='';}
				dtTime.setText(text);
				break;
			
			
			}
		}
		*/
		
		public function setUintOutput(outputID:uint, value:uint):void {
			switch (outputID) {
			
			case ID_OUT_UINT_DURATION:
				duration=value;
				setDuration(value);
				break;
				
			case ID_OUT_UINT_DISPLAY_MODE:
				mode=value;
				changeDisplayMode();
				break;
			
			}
		}
		
		public function setNumberInput(id:uint, value:Number):void {
			switch (id) {
			
			case ID_IN_NUMBER_POSITION:
				currentPostionSeconds=value;
				currentPostion=currentPostionSeconds/duration;
				slider.setValue(currentPostion*100);
				setCurrentPostitionText(currentPostionSeconds);
				break;
			
			}
		}
		
		public function getNumberInput(id:uint):Number {
			switch (id) {
			
			case ID_IN_NUMBER_POSITION:
				return currentPostion;
				break;
			
			}
		}
		
		public function getUintInput(id:uint):uint {
			switch (id) {
			
			case ID_IN_UINT_POSITION_SECONDS:
				return currentPostionSeconds;
				break;
			
			}
		}
		
		//{ =*^_^*= id
		public static const ID_E_B_RECORD:String = '>ID_E_B_RECORD';
		public static const ID_E_B_RECORD_STOP:String = '>ID_E_B_RECORD_STOP';
		public static const ID_E_B_PLAY:String = '>ID_E_B_PLAY';
		public static const ID_E_B_STOP:String = '>ID_E_B_STOP';
		public static const ID_E_START_SEEK:String = '>ID_E_START_SEEK';
		public static const ID_E_END_SEEK:String = '>ID_E_END_SEEK';
		
		public static const ID_OUT_UINT_DISPLAY_MODE:uint=0;
		/**
		 * seconds
		 */
		public static const ID_OUT_UINT_DURATION:uint=1;
		/**
		 * seconds
		 */
		public static const ID_IN_NUMBER_POSITION:uint=0;
		public static const ID_IN_UINT_POSITION_SECONDS:uint=1;
		/**
		 * state text
		 */
		//public static const ID_OUT_TEXT_TIME:uint=0;
		
		/// display modes:
		public static const ID_MODE_STOPPED:uint=0;
		public static const ID_MODE_PLAY:uint=1;
		public static const ID_MODE_RECORD:uint=2;
		public static const ID_MODE_RECORD_STOPPED:uint=3;
		//} =*^_^*= END OF id
		
		
		//} =*^_^*= END OF user access
		
		/*public function get_replayRawData():String {
			return replayRawData.getText();
		}*/
		
		//{ =*^_^*= view
		private function configureVC(owner:DisplayObjectContainer):void {
			// prepare frame
			vc=new CustomJFrame(getAppRef_().get_mainScreen(), owner, wnd_title);
			vc.construct(NAME);
			//registerGUIWindowModel(vc.getModel());
			//addToContainer();
			vc.setIcon(new AssetIcon(windowIconImage,-1,-1,true));
			vc.getContentPane().setLayout(new BorderLayout(0,0));
			var titlebarH:uint=vc.getTitleBar().getSelf().getInsets().getMarginHeight();
			vc.setMinimumWidth(wnd_minW);
			vc.setMinimumHeight(wnd_minH+titlebarH);
			vc.setSizeWH(wnd_minW,wnd_minH+titlebarH);
			
			//buttons panel
			panelButtons=new JPanel(new SoftBoxLayout(SoftBoxLayout.X_AXIS, 2, SoftBoxLayout.CENTER));
			vc.getContentPane().append(panelButtons, BorderLayout.SOUTH);
			
			panelSeekbar=new JPanel(new BorderLayout(2));
			//state text
			dtTime=new JTextField('00:00:00');
			//dtTime.mouseChildren=false;
			dtTime.pack();
			dtTime.setMaximumHeight(dtTime.getHeight());dtTime.setMaximumWidth(dtTime.getWidth());
			//dtTime.setMinimumHeight(dtTime.getHeight());dtTime.setMinimumWidth(dtTime.getWidth());
			dtTime.setOpaque(false);dtTime.setBorder(new EmptyBorder());
			panelSeekbar.append(dtTime, BorderLayout.EAST);
			
			
			//scroll pane with custom elements
			slider = new JSlider(JSlider.HORIZONTAL);
			//hSlider.setEnabled(false);
			//vSlider.setInverted(true);
			//hSlider.setPaintTrack(true);
			//hSlider.setPaintTicks(false);
			//hSlider.setMajorTickSpacing(25);
			//hSlider.setMinorTickSpacing(5);
			
			slider.setValue(slider.getMinimum());
			panelSeekbar.append(slider, BorderLayout.CENTER);
			
			changeDisplayMode();
			
			//others
			/*panelOthers=new JPanel(new SoftBoxLayout(SoftBoxLayout.X_AXIS, 2, SoftBoxLayout.CENTER));
			vc.getContentPane().append(panelOthers, BorderLayout.NORTH);
			replayRawData=new JTextArea('',1,30);
			panelOthers.append(replayRawData);
			*/
			//c
			vc.show();
		}
		
		private function createButton(id:String, el:Function, text:String, icon:DisplayObject, fixH:Boolean=false, fixW:Boolean=false, textHint:String=null):JButton {
			var sb:JButton=new JButton(text, (icon!=null)?new AssetIcon(icon):null);sb.name=id;
			sb.addActionListener(el);sb.pack();
			if (fixH) {sb.setMaximumHeight(sb.getHeight());}
			if (fixW) {sb.setMaximumWidth(sb.getWidth());}
			if (textHint) {sb.setToolTipText(textHint);}
			return sb;
		}
		
		
		private function setDuration(seconds:uint):void {
			setCurrentPostitionText(0);
		}
		
		private function setCurrentPostitionText(seconds:uint):void {
			dtTime.setText(APP.lText().secondsToCurrentTime(seconds));
		}
		
		public function get_displayObject():DisplayObject {return container;}
		
		private var wnd_title:String;
		private var windowIconImage:DisplayObject;
		
		private var labelButtonRecord:String;
		private var labelButtonStop:String;
		private var labelButtonPlay:String;
		
		private var container:Sprite=new Sprite;
		private var bPlay:JButton;
		private var panelButtons:JPanel
		//private var panelOthers:JPanel
		private var panelSeekbar:JPanel;
		private var bStop:JButton;
		private var bRecord:JButton;
		private var dtTime:JTextField;
		//private var replayRawData:JTextArea;
		private var slider:JSlider;
		//} =*^_^*= END OF view
		
		
		//{ =*^_^*= controll
		private function configureControll():void {
			slider.addStateListener(el_slider);
		}
		
		private function el_mouseUpScroll(e:MouseEvent):void {
			// NOTE: makeshift aswing bug fix:
			slider.removeEventListener(MouseEvent.MOUSE_UP, el_mouseUpScroll);
			slider.stage.removeEventListener(MouseEvent.MOUSE_UP, el_mouseUpScroll);
			slider.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_DOWN, true, true, 0, 0, slider));
			slider.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_UP, true, true, 0, 0, slider));
		}
		
		private function el_slider(e:Event):void {
			currentPostion=slider.getValue()/(slider.getMaximum()-slider.getMinimum())
			currentPostionSeconds=duration*currentPostion;
			setCurrentPostitionText(currentPostionSeconds);
			var a:Boolean=slider.getValueIsAdjusting();
			if (slider_valueIsAdjusting!=a) {
				slider_valueIsAdjusting=a;
				if (slider_valueIsAdjusting) {
					// NOTE: makeshift aswing bug fix:
					slider.addEventListener(MouseEvent.MOUSE_UP, el_mouseUpScroll);
					slider.stage.addEventListener(MouseEvent.MOUSE_UP, el_mouseUpScroll);
					//
					listenerRef(this, ID_E_START_SEEK, null);
				} else {
					listenerRef(this, ID_E_END_SEEK, null);
				}
			}
		}
		private var slider_valueIsAdjusting:Boolean=false;
		
		private function changeDisplayMode():void {
			panelButtons.removeAll();
			vc.getContentPane().remove(panelSeekbar);
			
			switch (mode) {
			
			case ID_MODE_STOPPED:
				panelButtons.append(createButton('p', el_b, labelButtonPlay,null, true, true));
				vc.getContentPane().append(panelSeekbar, BorderLayout.CENTER);
				break;
			case ID_MODE_PLAY:
				panelButtons.append(createButton('ps', el_b, labelButtonStop,null, true, true));
				vc.getContentPane().append(panelSeekbar, BorderLayout.CENTER);
				break;
			case ID_MODE_RECORD:
				panelButtons.append(createButton('rs', el_b, labelButtonStop,null, true, true));
				break;
			case ID_MODE_RECORD_STOPPED:
				panelButtons.append(createButton('r', el_b, labelButtonRecord,null, true, true));
				break;
			}
		}
		
		
		private function el_b(e:Event):void {
			switch (e.target.name) {
			
			case 'p':
				listenerRef(this, ID_E_B_PLAY);
				break;
			case 'ps':
				listenerRef(this, ID_E_B_STOP);
				break;
			case 'r':
				listenerRef(this, ID_E_B_RECORD);
				break;
			case 'rs':
				listenerRef(this, ID_E_B_RECORD_STOP);
				break;
			
			}
		}
		
		//} =*^_^*= END OF controll
		
		
		//{ =*^_^*= events
		/**
		 * @param	listener function (target:VCReplayManager, eventType:String, details:Object=null):void;
		 */
		public function setListener(listener:Function):void {
			listenerRef = listener;
		}
		private var listenerRef:Function;
		//} =*^_^*= END OF events
		
		
		//{ =*^_^*= data
		private var wnd_minH:uint;
		private var wnd_minW:uint;
		private var duration:uint=60*60*11;
		private var currentPostionSeconds:uint=12+60+60*60;
		private var currentPostion:Number;
		private var mode:uint=ID_MODE_STOPPED;
		//} =*^_^*= END OF data
		
		public static const NAME:String='VCReplayManager';
		
		
	}
}
	
//{ =*^_^*= History
/* > (timestamp) [ ("+" (added) ) || ("-" (removed) ) || ("*" (modified) )] (text)
 * > 
 */
//} =*^_^*= END OF History

// template last modified:11.03.2011_[18#51#40]_[5]