// Project TTCC
package ttcc.v.mp {
	
	//{ =*^_^*= import
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import org.aswing.AssetPane;
	import org.aswing.BorderLayout;
	import org.aswing.BoxLayout;
	import org.aswing.colorchooser.VerticalLayout;
	import org.aswing.FlowLayout;
	import org.aswing.JButton;
	import org.aswing.JPanel;
	import org.jinanoimateydragoncat.display.utils.Utils;
	//} =*^_^*= END OF import
	
	
	/**
	 * 
	 * @author Jinanoimatey Dragoncat
	 * @version 0.0.0
	 * @created 25.08.2012 11:09
	 */
	public class VCMainPanelUsersListElementElement {
		
		//{ =*^_^*= CONSTRUCTOR
		public function VCMainPanelUsersListElementElement(userID:String, avatarRef:DisplayObject, w:uint, h:uint):void {
			this.userID=userID;
			vc=new JPanel(new BorderLayout());
			vc.mouseEnabled=false;
			
			avatarContainer = new AssetPane(avatarRef, AssetPane.SCALE_NONE);
			vc.append(avatarContainer, BorderLayout.WEST);
			
			iconsContainer=new JPanel(new VerticalLayout(VerticalLayout.CENTER,0));
			
			vc.append(iconsContainer, BorderLayout.EAST);
			
			var b:Sprite=new Sprite;
			b.graphics.beginFill(0,0);
			b.graphics.drawRect(0,0,w,h);
			vc.addChild(b);
			b.buttonMode=true;
			b.addEventListener(MouseEvent.CLICK, el_b);
		}
		public function destruct():void {
		}
		//} =*^_^*= END OF CONSTRUCTOR
		
		private function el_b(e:Event):void {
			elb(userID, vc);
		}
		/**
		 * @param	a (userID, vc:JPanel)
		 */
		public function setEventListener(a:Function):void {this.elb=a;}
		private var elb:Function;
		
		public function setIconFrame(id:uint, frame:uint):void {
			UIcon(icons[id]).setFrame(frame);
		}
		public function addIcon(id:uint, image0:DisplayObject, image1:DisplayObject, w:uint, h:uint):void {
			Utils.resizeDO(image0, w,h);
			Utils.resizeDO(image1, w,h);
			
			var uicon:UIcon=new UIcon(image0, image1);
			icons[id]=uicon;
			var ap:AssetPane=new AssetPane(uicon.get_vc(), AssetPane.SCALE_NONE);
			iconsContainer.append(ap);
		}
		
		
		
		public function get_userID():String {return userID;}
		public function get_vc():JPanel {return vc;}
		private var vc:JPanel;
		private var icons:Array=[];
		private var iconsContainer:JPanel;
		private var avatarContainer:AssetPane;
		private var userID:String;
		
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