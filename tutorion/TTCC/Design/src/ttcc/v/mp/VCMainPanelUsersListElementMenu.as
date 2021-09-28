// Project TTCC
package ttcc.v.mp {
	
	//{ =*^_^*= import
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.utils.Timer;
	import org.aswing.ASColor;
	import org.aswing.AssetIcon;
	import org.aswing.AssetPane;
	import org.aswing.border.EmptyBorder;
	import org.aswing.BorderLayout;
	import org.aswing.BoxLayout;
	import org.aswing.colorchooser.VerticalLayout;
	import org.aswing.FlowLayout;
	import org.aswing.JButton;
	import org.aswing.JFrame;
	import org.aswing.JLabel;
	import org.aswing.JLabelButton;
	import org.aswing.JPanel;
	import org.aswing.JPopup;
	import org.aswing.JWindow;
	import org.aswing.SoftBoxLayout;
	import org.aswing.SolidBackground;
	import org.jinanoimateydragoncat.display.utils.Utils;
	import ttcc.APP;
	import ttcc.d.a.DUUD;
	import ttcc.media.PictureStoreroom;
	import ttcc.media.Text;
	import ttcc.v.Lib;
	//} =*^_^*= END OF import
	
	
	/**
	 * 
	 * @author Jinanoimatey Dragoncat
	 * @version 0.0.0
	 * @created 26.08.2012 18:40
	 */
	public class VCMainPanelUsersListElementMenu {
		
		//{ =*^_^*= CONSTRUCTOR
		public function VCMainPanelUsersListElementMenu(clientUD:DUUD, targetUD:DUUD, w:uint=0, h:uint=0):void {
			this.clientUD=clientUD;
			this.targetUD=targetUD;
			this.w=w;
			this.h=h;
			//var wnd:JPopup=new JPopup();
			//vc=new JPanel(new BorderLayout());
			vc=new Sprite;
			//wnd.append(vc, "CONTENT");
			//pm=new JPanel(new SoftBoxLayout(SoftBoxLayout.Y_AXIS,0, SoftBoxLayout.CENTER));
			pm=new Sprite;
			//pb=new JPanel(new SoftBoxLayout(SoftBoxLayout.X_AXIS, 0, SoftBoxLayout.LEFT));
			pb=new Sprite;
			//vc.append(pm, BorderLayout.NORTH);
			//vc.append(pb, BorderLayout.SOUTH);
			vc.addChild(pm);
			vc.addChild(pb);
			//vc.setBackgroundDecorator(new SolidBackground(new ASColor(0x999999,1)));
			
			prepareView();
			prepareControl();
		}
		public function construct():void {
		}		
		public function destruct():void {
		}
		//} =*^_^*= END OF CONSTRUCTOR
		
		public function updateView():void {
			if (!vc) {return;}
			while(pb.numChildren>0){pb.removeChildAt(0);}
			while(pm.numChildren>0){pm.removeChildAt(0);}
			prepareView();
		}
		
		private function prepareView():void {
			var un:String=targetUD.get_displayName();
			if (un==null || un.length<1) {un=APP.lText().get_TEXT(Text.ID_TEXT_VIDEO_CL_USER_NAME_IS_EMPTY);}
			addTextItem(un+((targetUD.get_id()==clientUD.get_id())?' (это вы)':""));
			if (targetUD.get_id()==clientUD.get_id()) {
				if (!clientUD.get_handIsUp()) {
					addButtonItem('handOn', [
						PictureStoreroom.getPicture('ruka_1'),
						PictureStoreroom.getPicture('ruka_2'),
						PictureStoreroom.getPicture('ruka_3')], 'поднять руку'); 
				} else {
					addButtonItem('handOff', [
						PictureStoreroom.getPicture('ruka_6'),
						PictureStoreroom.getPicture('ruka_5'),
						PictureStoreroom.getPicture('ruka_4')], 'опустить руку');
				}
			}
			
			if (clientUD.get_isLector()) {
				var streamIsOn:Boolean=false;
				if ((targetUD.get_streamName()!=null)&&(targetUD.get_streamName().length>0)&&targetUD.get_streamingIsOn()) {
					streamIsOn=true;
				}
				
				
				if (!streamIsOn) {
					addButtonItem('streamOn', [
						PictureStoreroom.getPicture('sp_off_w'),
						PictureStoreroom.getPicture('sp_off_b'),
						PictureStoreroom.getPicture('sp_off_p')], 'дать слово'); 
				} else {
					addButtonItem('streamOff', [
						PictureStoreroom.getPicture('sp_on_w'),
						PictureStoreroom.getPicture('sp_on_b'),
						PictureStoreroom.getPicture('sp_on_p')], 'не дать слово');
				}
			}
			//addButtonItem('streamOn', PictureStoreroom.getPicture('sp_on_b'), 'дать слово' );
			//addButtonItem('streamOff', PictureStoreroom.getPicture('sp_off_b'), 'не дать слово');
			
			
		}
		
/*		public function addMenuItem(id:String, icon:DisplayObject, text:String):void {
			pm.append(createMenuItem(id, icon, text));
			pm.pack();
			vc.pack();
		}
*/		
		public function addButtonItem(id:String, icons:Array, hint:String):void {
			//pb.append(createButtonItem(id, icon, hint));
			pb.addChild(Lib.createIconifiedButton(id, el_menuItem, '',icons,false,false,hint));
			redraw();
		}
		
		public function addTextItem(text:String):void {
			//pm.append(createTextItem(text));
			pm.addChild(createTextItem(text));
			redraw();
		}
		
		private function redraw():void {
			//pb.pack();
			//pm.pack();
			var nc:uint;
			var w:uint;
			var i:int;
			if (pm.numChildren>0) {
				nc=pm.numChildren;
				//w=pm.getChildAt(0).height;
				for (i = 0; i < nc;i++) {
					pm.getChildAt(i).y=20*i;
				}
			}
			
			pb.y=20*i;
			
			if (pb.numChildren>0) {
				nc=pb.numChildren;
				w=pb.getChildAt(0).width;
				for (i = 0; i < nc;i++) {
					pb.getChildAt(i).x=w*i;
				}
			}
			timer.reset();timer.start();
			vc.graphics.clear();
			vc.graphics.beginFill(0xbbbbbb);
			vc.graphics.drawRoundRect(0,0,Math.max(pm.width,vc.width)+10,vc.height+10,3,3);
			
		}
		
		private function el_timerRedraw(e:TimerEvent):void {
			vc.graphics.clear();
			vc.graphics.beginFill(0xbbbbbb);
			vc.graphics.drawRoundRect(0,0,Math.max(pm.width,vc.width)+10,vc.height+10,3,3);
		}
		private var timer:Timer=new Timer(300, 1);
		
		private function createTextItem(text:String):DisplayObject {
			var l:TextField=new TextField();
			l.autoSize=TextFieldAutoSize.LEFT;
			l.text=text;
			return l;	
		}
		
/*		private function createMenuItem(id:String, icon:DisplayObject, text:String):JPanel {
			var p:JPanel=new JPanel;
			var b:JLabelButton=new JLabelButton(text, new AssetIcon(icon));
			b.name=id;
			b.addActionListener(el_menuItem);
			p.append(b, BorderLayout.CENTER);
			p.pack();
			return p;
		}
*/		
		private function createButtonItem(id:String, icon:DisplayObject, text:String):JButton {
			var b:JButton=new JButton('', new AssetIcon(icon));
			b.setBackgroundDecorator(new SolidBackground(new ASColor(0,0)));
			b.name=id;
			b.setToolTipText(text);
			b.addActionListener(el_menuItem);
			b.pack();
			return b;
		}
		
		private function el_menuItem(e:Event):void {
			el(this, e.target.name);
		}
		
		/**
		 * @param	a (this, id:String)
		 */
		public function setEventListener(a:Function):void {this.el=a;}
		private var el:Function;
		
		
		//public function get_clientUD():DUUD {return clientUD;}
		public function get_targetUD():DUUD {return targetUD;}
		//public function get_w():uint {return w;}
		//public function get_h():uint {return h;}
		public function get_vc():Sprite {return vc;}
		
		//private var vc:JPanel;
		private var vc:Sprite;
		//private var pm:JPanel;
		//private var pb:JPanel;
		private var pm:Sprite;
		private var pb:Sprite;
		private var clientUD:DUUD;
		private var targetUD:DUUD;
		private var w:uint;
		private var h:uint;
		
		
		private function prepareControl():void {
			if (!vc.stage) {
				vc.addEventListener(Event.ADDED_TO_STAGE, el_vcADDED_TO_STAGE);
				return;
			}
			timer.addEventListener(TimerEvent.TIMER, el_timerRedraw);
			el_vcADDED_TO_STAGE();
		}
		
		private function el_vcADDED_TO_STAGE(e:Event=null):void {
			vc.removeEventListener(Event.ADDED_TO_STAGE, el_vcADDED_TO_STAGE);
			//vc.addEventListener(MouseEvent.MOUSE_UP, el_vcROLL_OUT);
			vc.addEventListener(MouseEvent.MOUSE_OUT, el_vcROLL_OUT);
		}
		private function el_vcROLL_OUT(e:Event=null):void {
			if (new Rectangle(vc.x, vc.y, vc.width, vc.height).contains(vc.parent.mouseX, vc.parent.mouseY)) {return;}
			//vc.removeEventListener(MouseEvent.MOUSE_UP, el_vcROLL_OUT);
			vc.removeEventListener(MouseEvent.MOUSE_OUT, el_vcROLL_OUT);
			vc.parent.removeChild(vc);
			vc=null;
		}

	}
}


//{ =*^_^*= import
import flash.display.DisplayObject;
import flash.display.Sprite;
//} =*^_^*= END OF import

class UIcon {
	function UIcon (image0:DisplayObject, image1:DisplayObject):void {
		this.image0 = image0;
		this.image1 = image1;
		
		vc=new Sprite();
		vc.addChild(image0);
		vc.addChild(image1);
		setFrame(0);
	}
	
	public function setFrame(sn:uint):void {
		image0.visible=sn==0;
		image1.visible=!image0.visible;
	}
	
	public function get_vc():Sprite {return vc;}
	
	private var image0:DisplayObject;
	private var image1:DisplayObject;
	private var vc:Sprite;
}

//{ =*^_^*= History
/* > (timestamp) [ ("+" (added) ) || ("-" (removed) ) || ("*" (modified) )] (text)
 * > 
 */
//} =*^_^*= END OF History

// template last modified:11.03.2011_[18#51#40]_[5]