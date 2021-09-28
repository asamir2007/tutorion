package ttcc.v.av {
	
	//{ =^_^= import
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.PixelSnapping;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.text.TextFormatAlign;
	import org.aswing.AssetPane;
	import org.aswing.event.ResizedEvent;
	import ttcc.LOG;
	
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
	 * @created 05.09.2012 19:40
	 */
	public class VCAVVideoWindow extends JPanel {
		
		//{ =^_^= CONSTRUCTOR
		
		/**
		 * 
		 * @param	videoVP user's avatar or video image
		 * @param	id_
		 * @param	eventsPipe function (target:VCAVVideoWindow, eventType:String):void; see events section for more details
		 */
		public function construct(id_:String, eventsPipe:Function, w:uint, h:uint, selected:Boolean, data:AVGUIController):void {
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
			
			imgP=new JPanel(new BorderLayout(0,0));
			imgP.addEventListener(ResizedEvent.RESIZED, el_videoFrameResized);
			
			//default image for size
			mainContainer=new Sprite();
			userPictureContainer=new Sprite();
			videoContainer=new Sprite();
			mainContainer.addChild(userPictureContainer);
			mainContainer.addChild(videoContainer);
			img=new AssetPane(mainContainer, AssetPane.SCALE_NONE);
			imgP.append(img);
			rp.append(imgP, BorderLayout.CENTER);
			
			//if (displayName.length>20) {displayName=displayName.substr(0,20)+'\n'+displayName.substr(21);}
			//var buttonText:JTextArea=new JTextArea('',2,20);
			label=new JLabel();
			label.setBackgroundDecorator(new SolidBackground(color));
			label.setBackground(color);
			label.setText('user 0');
			//label.setBorder(new EmptyBorder());
			//label.setWidth(img.getWidth());
			//label.setMinimumWidth(img.getWidth());
			label.pack();
			
			//setVolume(volumeLevel);
			//setDisplayName(displayName);
			
			
			rp.append(label, BorderLayout.NORTH);
			
			state=selected;
			this.data=data;
			data.set_el(el_data);
			
			updateStateDisplay();
		}
		//} =^_^= END OF CONSTRUCTOR
		
		private function el_data(target:AVGUIController, eventType:int):void {
			switch (eventType) {
			case AVGUIController.ID_E_UNIT_RESET:
				changeStateSignature();
			break;
			
			case AVGUIController.ID_E_UPDATED_DISPLAY_NAME:
			case AVGUIController.ID_E_UNIT_READY:
				setDisplayName(target.get_userDisplayName());
				break;
			
			case AVGUIController.ID_E_UPDATED_VOLUME_LEVEL:
				setVolume(target.get_volumeLevel());
				break;
				
			case AVGUIController.ID_E_DISPLAY_VIDEO:
				videoRef=target.get_video();
				setVideo(videoRef);
				setUserpic(null);
				el_videoFrameResized();
				break;
				
			case AVGUIController.ID_E_DISPLAY_USER_PICTURE:
				// TODO: dispose previous picture
				userPicture=createAvatarSmallPicture(target.get_userAvatarPath());
				// TODO: set 2 layers instead of one(upper is GUI such as indicators)
				setUserpic(userPicture);
				setVideo(null);
				el_videoFrameResized();
				break;
				
			case AVGUIController.ID_E_DISPLAY_DEFAULT_USER_PICTURE:
				//Utils.resizeDO(defaultUserpic, userpicW, userpicH);// TODO: [LOW] [PERFORMANCE] dont resize each time
				//Utils.centerDO(defaultUserpic, mainContainer.getRect(mainContainer));
				setUserpic(defaultUserpic);
				setVideo(null);
				el_videoFrameResized();
				el_videoFrameResized();
				break;
				
			case AVGUIController.ID_E_DISPLAY_NO_USERS_PICTURE:
				//setUserpic(defaultUserpic);
				setVideo(new Shape());
				el_videoFrameResized();
				el_videoFrameResized();
				break;
				
			case AVGUIController.ID_E_UPDATED_HAS_AUDIO:
				icon_hasNoAudio.visible=!target.get_hasAudio();
				break;
				
			}
		}
		private var mainContainer:Sprite;
		private var videoContainer:DisplayObjectContainer;
		private var userPictureContainer:DisplayObjectContainer;
		private var userPicture:DisplayObject;
		
		private function el_videoFrameResized(e:ResizedEvent=null):void {
			//LOG(0,'el_videoFrameResized'+e.getNewSize(),2);
			var w:Number=(e!=null)?e.getNewSize().width:imgP.getWidth();
			var h:Number=(e!=null)?e.getNewSize().height:imgP.getHeight();
			
			/*mainContainer.graphics.clear();
			mainContainer.graphics.beginFill(0x000000,.4);
			mainContainer.graphics.drawRect(0,0,w, h);
			mainContainer.graphics.beginFill(0x00ff00,.8);
			mainContainer.graphics.drawRect(20,20,w-40,h-40);
			*/
			if (!videoRef) {return;}
			//videoRef.alpha=.5
			Utils.resizeDO(videoRef, w, h);
			Utils.centerDO(videoRef, new Rectangle(0,0,w,h));
			if (!userPicture) {return;}
			Utils.resizeDO(userPicture, w, h);
			Utils.centerDO(userPicture, new Rectangle(0,0,w,h));
			if (!defaultUserpic) {return;}
			Utils.resizeDO(defaultUserpic, w, h);
			Utils.centerDO(defaultUserpic, new Rectangle(0,0,w,h));
			
		}
		
		private function createAvatarSmallPicture(a:String):DisplayObject {
			if (a==AVGUIController.ID_NO_USERS_AVATAR) {return;}
			
			var stateID:uint=validStateSignature;
			var s:Sprite=new Sprite;
			s.graphics.beginFill(0,0);
			s.graphics.drawRect(0, 0, userpicW, userpicH);
			s.addChild(new Im(a, null, null
				,function(a:Im):void {if (stateID!=validStateSignature) {return;}
					Utils.resizeDO(a, userpicW, userpicH)
					el_videoFrameResized();
				}
				,function(a:Im, errorOccured:Boolean):void {if (stateID!=validStateSignature) {return;}
					data.set_userAvatarPath(null);
					el_data(data, AVGUIController.ID_E_DISPLAY_DEFAULT_USER_PICTURE);
				}
			));
			return s;
		}
		
		public function setVolume(a:int):void {
			//pb.setValue(a);
		}
		
		private function setUserpic(a:DisplayObject):void {
			//userPictureContainer.visible=a!=null;
			while(userPictureContainer.numChildren>0) {userPictureContainer.removeChildAt(0);}
			if (!a) {return;}
			userPictureContainer.addChild(a);
		}
		private function setVideo(a:DisplayObject):void {
			videoContainer.visible=a!=null;
			while(videoContainer.numChildren>0) {videoContainer.removeChildAt(0);}
			if (!a) {return;}
			videoContainer.addChild(a);
		}
		
		public function setDisplayName(a:String):void {
			label.setText(a);
		}
		
		public function get_id():String {return id;}
		public function set_selected(a:Boolean):void {
			state=a;
			updateStateDisplay();
		}
		public function get_selected():Boolean {return state;}
		
		private static const color:ASColor=new ASColor(0,0);
		
		private function updateStateDisplay():void {
			/*if (state) {
				img.setBorder(new LineBorder(null, new ASColor(0x0000ff), 2, 2));
			} else {
				img.setBorder(new EmptyBorder());
			}*/
		}
		
		private function changeStateSignature():void {
			if (validStateSignature==uint.MAX_VALUE) {validStateSignature=0;}
			validStateSignature+=1;
		}
		
		private var validStateSignature:uint=0;
		
		//{ EVENTS
		public static const EVENT_ELEMENT_SELECTED:String = 'event_element_selected';
		
		
		private function imageButtonPressed(e:Event):void {
			defaultEventsPipe(this, EVENT_ELEMENT_SELECTED);
		}
		//} END OF EVENTS
		
		private var state:Boolean = false;
		private var label:JLabel;
		private var imgP:JPanel;
		private var img:AssetPane;
		//private var pb:JProgressBar;
		private var id:String;
		private var data:AVGUIController ;
		private var defaultEventsPipe:Function;
		private var defaultUserpic:Bitmap;
		private var icon_hasNoAudio:Bitmap;
		private var userpicW:int;
		private var userpicH:int;
		private var videoRef:DisplayObject
		
		
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
		public function get_defaultUserpic():Bitmap {return defaultUserpic;}
		public function set_defaultUserpic(a:Bitmap):void {defaultUserpic = a;}
		public function get_icon_hasNoAudio():Bitmap {return icon_hasNoAudio;}
		public function set_icon_hasNoAudio(a:Bitmap):void {icon_hasNoAudio = a;}
		
		public function resourcesAreConfigured():void {
			defaultUserpic=new Bitmap(resO[ID_ELEMENT_DEFAULT_USER_PICTURE], PixelSnapping.ALWAYS);
			icon_hasNoAudio=new Bitmap(resO[ID_ELEMENT_ICON_HAS_NO_AUDIO], PixelSnapping.ALWAYS);
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