// Project TTCC
package ttcc.v.wb.v {
	
	//{ =*^_^*= import
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.PixelSnapping;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Rectangle;
	import flash.utils.Timer;
	import org.aswing.AssetPane;
	import org.aswing.BorderLayout;
	import org.aswing.geom.IntDimension;
	import org.aswing.JPanel;
	import org.jinanoimateydragoncat.display.utils.Utils;
	//} =*^_^*= END OF import
	
	
	/**
	 * 
	 * @author Jinanoimatey Dragoncat
	 * @version 0.0.0
	 * @created 20.09.2012 19:05
	 */
	public class WhiteboardListElement extends JPanel {
		
		//{ =*^_^*= CONSTRUCTOR
		function WhiteboardListElement (owner:WhiteboardMainPage, w:uint, h:uint, listener:Function,  pageName:String) {
			this.owner=owner;
			this.el=listener;
			this.rect=new Rectangle(0,0,w,h);
			// draw bg
			b=new Bitmap(null, PixelSnapping.ALWAYS);
			mc.graphics.beginFill(0xeeeeee, 0);
			mc.graphics.lineStyle(0, 0xbbbbbb, 1);
			mc.graphics.drawRect(-1,-1,w+2,h+2);
			mc.addChild(b);
			
			//updataAniDO
			updataAniDO.graphics.lineStyle(w/5, 0x0000ff, 1);
			updataAniDO.graphics.drawRoundRect(-w/2+w/10,-h/2+h/10,w-w/5,h-h/5,w/5,h/5);
			updataAniDO.x=w/2;updataAniDO.y=h/2;
			updataAniDO.alpha=0;
			aniT.addEventListener(TimerEvent.TIMER, el_aniT);
			
			mc.addChild(updataAniDO);
			var ap:AssetPane=new AssetPane(mc, AssetPane.SCALE_NONE);
			append(ap, BorderLayout.CENTER);
			setSizeWH(w,h);
			
			setToolTipText(pageName);
			mouseChildren=false;
			buttonMode=true;
			addEventListener(MouseEvent.MOUSE_DOWN, el_mouse);
		}
		public function construct():void {
		}
		public function destruct():void {
			b=null;
		}
		//} =*^_^*= END OF CONSTRUCTOR
		
		
		public function setData(bd:BitmapData):void {
			b.bitmapData=bd;
			Utils.resizeDO(b, rect.width, rect.height);
			Utils.centerDO(b, rect);
			
			// update ani
			startUpdateAnimation();
		}
		
		private function el_mouse(e:MouseEvent):void {
			el(this, 0, null);
		}
		
		private function startUpdateAnimation():void {
			updataAniDO.alpha=0;
			updataAniDO.scaleX=1;
			updataAniDO.scaleY=1;
			aniT.reset();aniT.start();
		}
		private function el_aniT(e:TimerEvent):void {
			if (e.type==TimerEvent.TIMER) {
				updataAniDO.alpha+=1/aniTNumSteps;
				updataAniDO.scaleX-=1/aniTNumSteps;
				updataAniDO.scaleY=updataAniDO.scaleX;
			}
		}
		private var aniT:Timer=new Timer(50, aniTNumSteps);
		private var aniTNumSteps:int=500/50;
		
		public function get_owner():WhiteboardMainPage {return owner;}
		
		private var rect:Rectangle;
		private var b:Bitmap;
		private var updataAniDO:Sprite=new Sprite;
		private var mc:Sprite=new Sprite;
		private var owner:WhiteboardMainPage;
		private var el:Function;
		
	}
}

//{ =*^_^*= History
/* > (timestamp) [ ("+" (added) ) || ("-" (removed) ) || ("*" (modified) )] (text)
 * > 
 */
//} =*^_^*= END OF History

// template last modified:11.03.2011_[18#51#40]_[5]