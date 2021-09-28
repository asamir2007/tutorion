package ttcc.v.av {
	
	//{ =^_^= import
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextFormatAlign;
	
	import org.aswing.ASColor;
	import org.aswing.AssetIcon;
	import org.aswing.BorderLayout;
	import org.aswing.JButton;
	import org.aswing.JLabel;
	import org.aswing.JPanel;
	import org.aswing.JProgressBar;
	import org.aswing.JTextArea;
	import org.aswing.SolidBackground;
	import org.aswing.border.EmptyBorder;
	import org.aswing.border.LineBorder;
	import org.jinanoimateydragoncat.display.utils.Utils;
	
	import ttcc.c.v.AVGUIController;
	import ttcc.n.loaders.Im;
	//} =^_^= END OF import
	
	
	/**
	 * 
	 * @author Jinanoimatey Dragoncat
	 * @version 0.0.0
	 * @created 04.07.2012 2:59
	 */
	public class VCAVContactsListElement extends JPanel {
		
		//{ =^_^= CONSTRUCTOR
		
		/**
		 * 
		 * @param	videoVP user's avatar or video image
		 * @param	id_
		 * @param	eventsPipe function (target:VCAVContactsListElement, eventType:String):void; see events section for more details
		 */
		public function construct(id_:String, eventsPipe:Function, w:uint, h:uint, selected:Boolean, data:AVGUIController):void {
			//setBackground(new ASColor(0x555555));
			//setBackgroundDecorator(new SolidBackground(new ASColor(0xa1a1a1)));
			//setBorder(new LineBorder(null, new ASColor(0x999999), 3, 5));
			userpicW=w;
			userpicH=h;
			setSizeWH(w,h);
			defaultEventsPipe = eventsPipe;
			id = id_;
			setLayout(new BorderLayout(1,1));
			
			//pb=new JProgressBar(JProgressBar.VERTICAL);
			//append(pb, BorderLayout.WEST);
			
			var rp:JPanel=new JPanel(new BorderLayout(1,1));
			append(rp, BorderLayout.CENTER);
			
			img = new JButton();
			//default image for size
			img.setBackgroundDecorator(null);
			
			var volumeIndicatorWidth:Number=3;
			volumeIndicator=new Sprite();
			volumeIndicator.graphics.lineStyle(volumeIndicatorWidth, 0x0000ff, 1);
			volumeIndicator.graphics.moveTo(0,0);
			volumeIndicator.graphics.lineTo(0,w);
			volumeIndicator.graphics.lineTo(h,w);
			volumeIndicator.graphics.lineTo(h,0);
			volumeIndicator.graphics.lineTo(0,0);
			volumeIndicator.alpha=0;
			//volumeIndicator.graphics.lineTo(-volumeIndicatorWidth*2,-volumeIndicatorWidth*2,w+volumeIndicatorWidth*2,h+volumeIndicatorWidth*2);
			
			mainContainer=new Sprite();
			mainContainer.graphics.beginFill(0xffffff,1);mainContainer.graphics.drawRect(0,0,w,h);
			userPictureContainer=mainContainer.addChild(new Sprite());
			mainContainer.addChild(volumeIndicator);
			mainContainer.addChild(icon_hasNoAudio);
			
			///
			/*label=new JTextArea('',2,13);
			//buttonText.setAlignmentY(TextFormatAlign.CENTER);
			label.setBackgroundDecorator(new SolidBackground(new ASColor(0,0)));
			label.setBackground(color);
			label.setBorder(new EmptyBorder());
			label.setHtmlText('test<br>test');
			label.setEditable(false);
			label.getTextField().mouseEnabled=false;
			label.setWordWrap(true);
			
			label.setSizeWH(w-img.getWidth(), h);
			//label.setMaximumWidth(w);
			//label.setMaximumHeight(h);
			rp.append(label, BorderLayout.SOUTH);
			*/
			///
			
			setImage(mainContainer);
			
			img.addActionListener(imageButtonPressed);
			img.pack();
			rp.append(img, BorderLayout.CENTER);
			
			//if (displayName.length>20) {displayName=displayName.substr(0,20)+'\n'+displayName.substr(21);}
			//var buttonText:JTextArea=new JTextArea('',2,20);
			/*label=new JLabel();
			label.setBackgroundDecorator(new SolidBackground(color));
			label.setBackground(color);
			label.setBorder(new EmptyBorder());
			label.setWidth(img.getWidth());
			label.setMinimumWidth(img.getWidth());
			label.pack();
			rp.append(label, BorderLayout.NORTH);
			*/
			
			//setVolume(volumeLevel);
			//setDisplayName(displayName);
			
			
			
			state=selected;
			this.data=data;
			data.set_el(el_data);
			
			
			updateStateDisplay();
		}
		//} =^_^= END OF CONSTRUCTOR
		
		private function el_data(target:AVGUIController, eventType:int):void {
			switch (eventType) {
			
			case AVGUIController.ID_E_UNIT_READY:
				setDisplayName(target.get_userDisplayName());
				break;
			
			case AVGUIController.ID_E_UPDATED_VOLUME_LEVEL:
				setVolume(target.get_volumeLevel());
				break;
				
			case AVGUIController.ID_E_DISPLAY_VIDEO:
				Utils.resizeDO(target.get_video(), userpicW, userpicH);
				Utils.centerDO(target.get_video(), mainContainer.getRect(mainContainer));
				setUserpic(target.get_video());
				break;
				
			case AVGUIController.ID_E_DISPLAY_USER_PICTURE:
				// TODO: dispose previous picture
				userPicture=createAvatarSmallPicture(target.get_userAvatarPath());
				// TODO: set 2 layers instead of one(upper is GUI such as indicators)
				setUserpic(userPicture);
				break;
				
			case AVGUIController.ID_E_DISPLAY_DEFAULT_USER_PICTURE:
				Utils.resizeDO(defaultUserpic, userpicW, userpicH);// TODO: [LOW] [PERFORMANCE] dont resize each time
				Utils.centerDO(defaultUserpic, mainContainer.getRect(mainContainer));
				setUserpic(defaultUserpic);
				break;
				
			case AVGUIController.ID_E_UPDATED_HAS_AUDIO:
				icon_hasNoAudio.visible=!target.get_hasAudio();
				break;
				
			}
		}
		private var mainContainer:Sprite;
		private var volumeIndicator:Sprite;
		private var userPictureContainer:DisplayObjectContainer;
		private var userPicture:DisplayObject;
		
		private function createAvatarSmallPicture(a:String):DisplayObject {
			var s:Sprite=new Sprite;
			s.graphics.beginFill(0,0);
			s.graphics.drawRect(0, 0, userpicW, userpicH);
			s.addChild(new Im(a, null, null
				,function(a:Im):void {
					Utils.resizeDO(a, userpicW, userpicH)
					Utils.centerDO(a, mainContainer.getRect(mainContainer));
				}
				,function(a:Im, errorOccured:Boolean):void {
					data.set_userAvatarPath(null);
					el_data(data, AVGUIController.ID_E_DISPLAY_DEFAULT_USER_PICTURE);
				}
			));
			return s;
		}
		
		/**
		 * 0..100
		 */
		public function setVolume(a:int):void {
			//pb.setValue(a);
			volumeIndicator.alpha=Math.max(0,(a-30)/25);
		}
		
		public function setImage(a:DisplayObject):void {
			img.setIcon(new AssetIcon(a));
		}
		
		private function setUserpic(a:DisplayObject):void {
			while(userPictureContainer.numChildren>0) {userPictureContainer.removeChildAt(0);}
			userPictureContainer.addChild(a);
		}
		
		public function setDisplayName(a:String):void {
			//label.setText(a);
			//label.setHtmlText(a);
			img.setToolTipText(a);
		}
		
		public function get_id():String {return id;}
		public function set_selected(a:Boolean):void {
			state=a;
			updateStateDisplay();
		}
		public function get_selected():Boolean {return state;}
		
		private static const color:ASColor=new ASColor(0,0);
		
		private function updateStateDisplay():void {
			if (state) {
				img.setBorder(new LineBorder(null, new ASColor(0x0000ff), 2, 2));
			} else {
				img.setBorder(new EmptyBorder());
			}
		}
		
		//{ EVENTS
		public static const EVENT_ELEMENT_SELECTED:String = 'event_element_selected';
		
		
		private function imageButtonPressed(e:Event):void {
			defaultEventsPipe(this, EVENT_ELEMENT_SELECTED);
		}
		//} END OF EVENTS
		
		private var state:Boolean = false;
		private var label:JTextArea;
		private var img:JButton;
		private var pb:JProgressBar;
		private var id:String;
		private var data:AVGUIController ;
		private var defaultEventsPipe:Function;
		private var defaultUserpic:Bitmap;
		private var icon_hasNoAudio:Bitmap;
		private var userpicW:int;
		private var userpicH:int;
		
		//{ =*^_^*= =*^_^*= id
		private static var nextID:uint=1;
		/**
		 * BitmapData
		 */
		public static const ID_ELEMENT_DEFAULT_USER_PICTURE:uint=nextID++;
		/**
		 * BitmapData
		 */
		public static const ID_ELEMENT_ICON_HAS_NO_AUDIO:uint=nextID++;
		//} =*^_^*= =*^_^*= END OF id
		
		//{ =*^_^*= resources
		// TODO: convert this code to separate class then use in other duplicate places
		public function resourcesAreConfigured():void {
			defaultUserpic=new Bitmap(resO[ID_ELEMENT_DEFAULT_USER_PICTURE]);
			icon_hasNoAudio=new Bitmap(resO[ID_ELEMENT_ICON_HAS_NO_AUDIO]);
		}
		public function setResourceO(id:uint, a:Object):void {resO[id]=a;}
		/**
		 * [Object]
		 */
		private var resO:Array=[];
		//} =*^_^*= END OF resources
		
		
	}
}

//{ =^_^= History
/* > (timestamp) [ ("+" (added) ) || ("-" (removed) ) || ("*" (modified) )] (text)
 * > 
 */
//} =^_^= END OF History

// template last modified:03.05.2010_[22#42#27]_[1]