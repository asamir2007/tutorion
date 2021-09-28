package ttcc.v.av {
	
	//{ =*^_^*= import
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import org.aswing.AssetIcon;
	import org.aswing.BorderLayout;
	import org.aswing.BoxLayout;
	import org.aswing.CustomJFrame;
	import org.aswing.JButton;
	import org.aswing.JPanel;
	import org.aswing.JScrollPane;
	import org.aswing.JTextArea;
	import org.aswing.JViewport;
	import org.aswing.SoftBoxLayout;
	import ttcc.c.v.AVGUIController;
	import ttcc.d.m.GUIWindowModel;
	import ttcc.v.AVCWW;
	//} =*^_^*= END OF import
	
	
	
	/**
	 * 
	 * @author Jinanoimatey Dragoncat
	 * @version 0.0.0
	 * @created 04.07.2012 2:47
	 */
	public class VCAV extends AVCWW {
		
		//{ =*^_^*= CONSTRUCTOR
		
		public function setResources(windowTitle:String, windowIconImage:DisplayObject, wndMinW:uint=210, wndMinH:uint=250):void {
			this.wnd_title=windowTitle;
			this.windowIconImage=windowIconImage;
			
			wnd_minH=wndMinH;
			wnd_minW=wndMinW;
		}
		
		public function setStringResource(id:uint, a:String):void {bDisplayNames[id]=a;}
		public function setDOResource(id:uint, a:DisplayObject):void {bIcons[id]=a;}
		
		
		public function construct(contactsList:VCAVContactsList, videoContainer:JPanel):void {
			if (!contactsList||!videoContainer) {
				throw new ArgumentError('!contactsList');
			}
			this.contactsList=contactsList;
			this.videoContainer=videoContainer;
			
			
			configureVC();
			configureControll();
			//test
			
		}
		//} =*^_^*= END OF CONSTRUCTOR
		
		
		//{ =*^_^*= user access
		
		public function redraw():void {
			vc.revalidate();
			updateButtons();
		}
		
		public function deselectAll():void {
			for each(var i:VCAVContactsListElement in elementsList) {i.set_selected(false);}
		}
		
		//} =*^_^*= END OF user access
		
		//{ =*^_^*= id
		//} =*^_^*= END OF id
		
		
		//{ =*^_^*= view
		private function configureVC():void {
			// prepare frame
			vc=new CustomJFrame(null, wnd_title);
			vc.construct(NAME);
			registerGUIWindowModel(vc.getModel());
			//addToContainer();
			vc.setIcon(new AssetIcon(windowIconImage,-1,-1,true));
			
			
			vc.getContentPane().setLayout(new BorderLayout(0,0));
			var titlebarH:uint=vc.getTitleBar().getSelf().getInsets().getMarginHeight();
			vc.setMinimumWidth(wnd_minW);
			vc.setMinimumHeight(wnd_minH+titlebarH);
			vc.setSizeWH(wnd_minW,wnd_minH+titlebarH);
			
			
			//V
			videoBlock = new JPanel(new BorderLayout());
			
			//list
			contactsListContainer=new JScrollPane(contactsList, JScrollPane.SCROLLBAR_NEVER, JScrollPane.SCROLLBAR_AS_NEEDED);
			JViewport(contactsListContainer.getViewport()).setHorizontalAlignment(JViewport.LEFT);
			
			videoBlock.append(contactsListContainer, BorderLayout.SOUTH);
			vc.getContentPane().append(videoBlock, BorderLayout.CENTER);
			
			videoBlock.append(videoContainer, BorderLayout.CENTER);
			
			vc.regiterScrollBar(GUIWindowModel.ID_P_SSV_0, contactsListContainer.getHorizontalScrollBar());
			
			//buttons panel
			panelButtons=new JPanel(new SoftBoxLayout(SoftBoxLayout.X_AXIS, 2, SoftBoxLayout.CENTER));
			vc.getContentPane().append(panelButtons, BorderLayout.SOUTH);
			
			updateButtons();
			//{ =*^_^*= test
			/*
			var imv0:Sprite;
			imv0=new Sprite();
			imv0.graphics.beginFill(0x00ff00);
			imv0.graphics.drawRect(0,0,100,100);
			elementsList.push(contactsList.addElement('video stream 0', imv0, 0, 25+60*Math.random(), false));
			imv0=new Sprite();
			imv0.graphics.beginFill(0xff0000);
			imv0.graphics.drawRect(0,0,100,100);
			elementsList.push(contactsList.addElement('video stream 1', imv0, 1, 25+60*Math.random(), true));
			imv0=new Sprite();
			imv0.graphics.beginFill(0x0000ff);
			imv0.graphics.drawRect(0,0,100,100);
			elementsList.push(contactsList.addElement('video stream 2', imv0, 2, 25+60*Math.random(), false));
			*///} =*^_^*= END OF test
			
			//c
			vc.show();
			
		}
		
		//{ =*^_^*= buttons panel
		
		private function updateButtons():void {
			panelButtons.removeAll();
			panelButtons.append(createButton(S_ID_B_SETTINGS, el_b, "", bIcons[ID_B_SETTINGS], false, true, bDisplayNames[ID_B_SETTINGS], true));
			
			var stateID:Array=[
				ID_ST_AU_IS_ON_OUT
				,ID_ST_V_IS_ON_OUT
				,ID_ST_AU_IS_ON_IN
				,ID_ST_V_IS_ON_IN
				,ID_ST_S_IS_ON
			];
			var buttonID:Array=[//[[state0, state1]]
				[S_ID_B_TOGGLE_AU_OUT0, S_ID_B_TOGGLE_AU_OUT1]
				,[S_ID_B_TOGGLE_V_OUT0, S_ID_B_TOGGLE_V_OUT1]
				,[S_ID_B_TOGGLE_AU_IN0, S_ID_B_TOGGLE_AU_IN1]
				,[S_ID_B_TOGGLE_V_IN0, S_ID_B_TOGGLE_V_IN1]
				,[S_ID_B_TOGGLE_S0, S_ID_B_TOGGLE_S1]
			];
			var buttonResID:Array=[//[[state0, state1]]
				[ID_B_TOGGLE_AU_OUT_OFF, ID_B_TOGGLE_AU_OUT_ON]
				,[ID_B_TOGGLE_V_OUT_OFF, ID_B_TOGGLE_V_OUT_ON]
				,[ID_B_TOGGLE_AU_IN_OFF, ID_B_TOGGLE_AU_IN_ON]
				,[ID_B_TOGGLE_V_IN_OFF, ID_B_TOGGLE_V_IN_ON]
				,[ID_B_TOGGLE_S_OFF, ID_B_TOGGLE_S_ON]
			];
			
			var l:uint = stateID.length;
			var state:uint;
			for (var i:int = 0;i < l;i++) {
			state=uint(getStateFor(stateID[i]));
				panelButtons.append(createButton(
					buttonID[i][state]
					,el_b
					,""
					,bIcons[buttonResID[i][state]]
					,true, true
					,bDisplayNames[buttonResID[i][state]]
					)
				);
			}
		}
		
		private function createButton(id:String, el:Function, text:String, icon:DisplayObject, fixH:Boolean=false, fixW:Boolean=false, textHint:String=null, bgIsVisible:Boolean=false):JButton {
			var sb:JButton=new JButton(text, new AssetIcon(icon));sb.name=id;
			if (!bgIsVisible) {sb.setBackgroundDecorator(null);}
			sb.addActionListener(el);sb.pack();
			if (fixH) {sb.setMaximumHeight(sb.getHeight());}
			if (fixW) {sb.setMaximumWidth(sb.getWidth());}
			if (textHint) {sb.setToolTipText(textHint);}
			return sb;
		}
		
		public function setStateFor(id:int, state:Object):void {this.state[id]=state;}
		private function getStateFor(id:int):Boolean {return state[id];}
		private var state:Array=[];
		private var panelButtons:JPanel
		//} =*^_^*= END OF buttons panel
		
		
		
		public function get_displayObject():DisplayObject {return container;}
		
		private var wnd_title:String;
		
		private var bIcons:Array=[];
		private function get_bDisplayName(id:int):String {if (bDisplayNames==null) {return '';}}
		private var bDisplayNames:Array=[];
		
		private var resSettingsText:String;
		private var resSettingsIcon:DisplayObject;

		private var container:Sprite=new Sprite;
		private var videoBlock:JPanel;
		
		public function get_contactsList():VCAVContactsList {return contactsList;}
		private var contactsList:VCAVContactsList;
		/**
		 * [VCAVContactsList]
		 */
		private var elementsList:Array=[];
		private var contactsListContainer:JScrollPane;
		private var videoContainer:JPanel;
		//} =*^_^*= END OF view
		
		
		//{ =*^_^*= controll
		private function configureControll():void {
		}
		
		private function el_b(e:Event):void {
			switch (e.target.name) {
			
			case S_ID_B_SETTINGS:
				listener(this, ID_E_B_SETTINGS, null);
				break;
			case S_ID_B_TOGGLE_AU_OUT0:
				listener(this, ID_E_B_TAU_OUT, false);
				break;
			case S_ID_B_TOGGLE_AU_OUT1:
				listener(this, ID_E_B_TAU_OUT, true);
				break;
			case S_ID_B_TOGGLE_V_OUT0:
				listener(this, ID_E_B_TV_OUT, false);
				break;
			case S_ID_B_TOGGLE_V_OUT1:
				listener(this, ID_E_B_TV_OUT, true);
				break;
			case S_ID_B_TOGGLE_AU_IN0:
				listener(this, ID_E_B_TAU_IN, false);
				break;
			case S_ID_B_TOGGLE_AU_IN1:
				listener(this, ID_E_B_TAU_IN, true);
				break;
			case S_ID_B_TOGGLE_V_IN0:
				listener(this, ID_E_B_TV_IN, false);
				break;
			case S_ID_B_TOGGLE_V_IN1:
				listener(this, ID_E_B_TV_IN, true);
				break;
			
			case S_ID_B_TOGGLE_S0:
				listener(this, ID_E_B_STREAM, false);
				break;
			case S_ID_B_TOGGLE_S1:
				listener(this, ID_E_B_STREAM, true);
				break;
			
			}
		}
		
		public function addElement(id_:String, eventsPipe:Function, w:uint, h:uint, selected:Boolean, data:AVGUIController):void {
			var e:VCAVContactsListElement=new VCAVContactsListElement;
			e.setResourceO(VCAVContactsListElement.ID_ELEMENT_DEFAULT_USER_PICTURE, defaultUserpic);
			e.setResourceO(VCAVContactsListElement.ID_ELEMENT_ICON_HAS_NO_AUDIO, icon_hasNoAudio);
			e.resourcesAreConfigured();
			
			e.construct(id_, eventsPipe, w, h, selected, data);
			contactsList.addElementLE(e);
		}
		
		//{ ^_^ id
		private static const S_ID_B_SETTINGS:String='bSettings';
		private static const S_ID_B_TOGGLE_AU_OUT0:String='bTAU0';
		private static const S_ID_B_TOGGLE_AU_OUT1:String='bTAU1';
		private static const S_ID_B_TOGGLE_V_OUT0:String='bTV0';
		private static const S_ID_B_TOGGLE_V_OUT1:String='bTV1';

		private static const S_ID_B_TOGGLE_AU_IN0:String='bTAU0in';
		private static const S_ID_B_TOGGLE_AU_IN1:String='bTAU1in';
		private static const S_ID_B_TOGGLE_V_IN0:String='bTV0in';
		private static const S_ID_B_TOGGLE_V_IN1:String='bTV1in';
		
		private static const S_ID_B_TOGGLE_S0:String='bTS0';
		private static const S_ID_B_TOGGLE_S1:String='bTS1';
		
		/**
		 * Boolean
		 */
		public static const ID_ST_V_IS_ON_OUT:int=0;
		/**
		 * Boolean
		 */
		public static const ID_ST_AU_IS_ON_OUT:int=1;
		/**
		 * Boolean
		 */
		public static const ID_ST_AU_IS_ON_IN:int=2;
		/**
		 * Boolean
		 */
		public static const ID_ST_V_IS_ON_IN:int=3;
		/**
		 * stream
		 * Boolean
		 */
		public static const ID_ST_S_IS_ON:int=4;
		public static const ID_STATE_ON:Boolean=true;
		public static const ID_STATE_OFF:Boolean=false;
		//} ^_^ END OF id
		
		//} =*^_^*= END OF controll
		
		
		//{ =*^_^*= events
		/**
		 * @param	listener function (target:VCAV, eventType:String, details:Object=null):void;
		 */
		public function setListener(listener:Function):void {
			this.listener = listener;
		}
		private var listener:Function;
		//} =*^_^*= END OF events
		
		
		//{ =*^_^*= data
		public function get_defaultUserpic():BitmapData {return defaultUserpic;}
		public function set_defaultUserpic(a:BitmapData):void {defaultUserpic = a;}
		public function get_icon_hasNoAudio():BitmapData {return icon_hasNoAudio;}
		public function set_icon_hasNoAudio(a:BitmapData):void {icon_hasNoAudio = a;}
		
		
		private var windowIconImage:DisplayObject;
		
		private var wnd_minH:uint;
		private var wnd_minW:uint;
		private var defaultUserpic:BitmapData;
		private var icon_hasNoAudio:BitmapData;
		//} =*^_^*= END OF data
		
		//{ =*^_^*= id
		private static var id00:uint=1;
		public static const ID_B_SETTINGS:int=id00++;
		public static const ID_B_TOGGLE_AU_OUT_ON:int=id00++;
		public static const ID_B_TOGGLE_AU_OUT_OFF:int=id00++;
		public static const ID_B_TOGGLE_V_OUT_ON:int=id00++;
		public static const ID_B_TOGGLE_V_OUT_OFF:int=id00++;
		
		public static const ID_B_TOGGLE_AU_IN_ON:int=id00++;
		public static const ID_B_TOGGLE_AU_IN_OFF:int=id00++;
		public static const ID_B_TOGGLE_V_IN_ON:int=id00++;
		public static const ID_B_TOGGLE_V_IN_OFF:int=id00++;
		
		public static const ID_B_TOGGLE_S_ON:int=id00++;
		public static const ID_B_TOGGLE_S_OFF:int=id00++;
		//} =*^_^*= END OF id
		
		//{ =*^_^*= =*^_^*= id events
		/**
		 * data:
		 */
		public static const ID_E_B_SETTINGS:String='ID_E_SETTINGS_BUTTON';
		/**
		 * data:Boolean
		 */
		public static const ID_E_B_TAU_OUT:String='ID_E_B_TAU_OUT';
		/**
		 * data:Boolean
		 */
		public static const ID_E_B_TV_OUT:String='ID_E_B_TV_OUT';
		/**
		 * for all incoming streams
		 * data:Boolean
		 */
		public static const ID_E_B_TAU_IN:String='ID_E_B_TAU_IN';
		/**
		 * for all incoming streams
		 * data:Boolean
		 */
		public static const ID_E_B_TV_IN:String='ID_E_B_TV_IN';
		/**
		 * shut down streaming completely/resume streaming
		 * data:Boolean
		 */
		public static const ID_E_B_STREAM:String='ID_E_B_STREAM';
		//} =*^_^*= =*^_^*= END OF id events
		
		//{ =*^_^*= =*^_^*= id
		private static var nextID:uint=1;
		/**
		 * Class
		 */
		public static const ID_ELEMENT_DEFAULT_USER_PICTURE:uint=nextID++;
		/**
		 * Class
		 */
		public static const ID_ELEMENT_ICON_HAS_NO_AUDIO:uint=nextID++;
		//} =*^_^*= =*^_^*= END OF id
		
		//{ =*^_^*= resources
		// TODO: convert this class to separate class then use in other duplicate places
		public function resourcesAreConfigured():void {
			defaultUserpic=Bitmap(new resO[ID_ELEMENT_DEFAULT_USER_PICTURE]).bitmapData;
			icon_hasNoAudio=Bitmap(new resO[ID_ELEMENT_ICON_HAS_NO_AUDIO]).bitmapData;
		}
		public function setResourceO(id:uint, a:Object):void {resO[id]=a;}
		/**
		 * [Object]
		 */
		private var resO:Array=[];
		//} =*^_^*= END OF resources
		
		public static const NAME:String='VCAV';
		
	}
}

//{ =*^_^*= History
/* > (timestamp) [ ("+" (added) ) || ("-" (removed) ) || ("*" (modified) )] (text)
 * > 
 */
//} =*^_^*= END OF History

// template last modified:11.03.2011_[18#51#40]_[5]