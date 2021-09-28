package ttcc.v.c {
	
	//{ =*^_^*= import
	import flash.events.MouseEvent;
	import org.aswing.Container;
	import org.aswing.JPanel;
	import org.aswing.SoftBoxLayout;
	import ttcc.APP;
	import ttcc.LOG;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	//} =*^_^*= END OF import
	
	
	
	/**
	 * 
	 * @author Jinanoimatey Dragoncat
	 * @version 0.0.0
	 * @created 26.11.2012 14:35
	 */
	public class VCConsole {
		
		//{ =*^_^*= CONSTRUCTOR
		
		
		public function construct(eventsPipe:Function, console:DisplayObject):void {
			listenerRef=eventsPipe;
			
			configureVC(console);
			configureControll();
		}
		//} =*^_^*= END OF CONSTRUCTOR
		
		//{ =*^_^*= view
		private function configureVC(consoleDO:DisplayObjectContainer):void {
			container=new Sprite();
			container.graphics.beginFill(0x00aa00);
			container.graphics.drawRect(0,0,500,20);
			controlsContainer=new Sprite();
			container.addChild(consoleDO).y=20;
			container.addChild(controlsContainer).y=20;
			
			vc=new JPanel(new SoftBoxLayout(SoftBoxLayout.X_AXIS,2,SoftBoxLayout.LEFT));//eleminates initial resize bug
		}
		
		
		public function get_displayObject():DisplayObject {return container;}
		
		private var vc:Container;
		private var container:Sprite=new Sprite;
		private var controlsContainer:Sprite=new Sprite;
		//} =*^_^*= END OF view
		
		
		//{ =*^_^*= controll
		private function configureControll():void {
			container.addEventListener(MouseEvent.MOUSE_DOWN, el_mouse);
			container.addEventListener(MouseEvent.MOUSE_UP, el_mouse);
			container.addEventListener(MouseEvent.MOUSE_OUT, el_mouse);
			container.buttonMode=true;
		}
		
		private function el_mouse(e:MouseEvent):void {
			if (e.type==MouseEvent.MOUSE_DOWN) {
				container.startDrag();dragging=true;
			} else if ((e.type==MouseEvent.MOUSE_UP)||(e.type==MouseEvent.MOUSE_OUT&&dragging)) {
				container.stopDrag();dragging=false;
			}
		}
		
		private var dragging:Boolean;
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
		//} =*^_^*= END OF data
		
		public static const NAME:String='VCConsole';
		
		
	}
}
	
//{ =*^_^*= History
/* > (timestamp) [ ("+" (added) ) || ("-" (removed) ) || ("*" (modified) )] (text)
 * > 
 */
//} =*^_^*= END OF History

// template last modified:11.03.2011_[18#51#40]_[5]