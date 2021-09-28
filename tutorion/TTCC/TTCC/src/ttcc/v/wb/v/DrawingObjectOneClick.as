// Project TTCC
package ttcc.v.wb.v {
	
	//{ =*^_^*= import
	import flash.events.MouseEvent;
	import ttcc.LOG;
	//} =*^_^*= END OF import
	
	
	/**
	 * 
	 * @author Jinanoimatey Dragoncat
	 * @version 0.0.0
	 * @created 21.09.2012 14:05
	 */
	public class DrawingObjectOneClick extends DrawingObject {
		
		//{ =*^_^*= CONSTRUCTOR
		function DrawingObjectOneClick (owner:WhiteboardMainPage) {
			super(owner);
		}
		public override function construct():void {
			
		}
		public override function destruct():void {
			setMouseListenersState(false);
		}
		//} =*^_^*= END OF CONSTRUCTOR
		
		public override function onMouseMove(x:uint, y:uint):void {
			super.onMouseMove(x,y);
			if (drawingStage!=1) {return;}
			x1=x;y1=y;
			project();
		}
		public override function onMouseDown(x:uint, y:uint):void {
			super.onMouseDown(x,y);
		}
		public override function onMouseUp(x:uint, y:uint):void {
			super.onMouseUp(x,y);
			focusOut();
		}
		public override function onMouseOut():void {
			super.onMouseOut();
			stopDraw();
		}
		
		public function project(displayMode:int=0):void {
			// override and place your code here
		}
		
		public override function setEditDisplayMode(a:Boolean):void {
			super.setEditDisplayMode(a);
		}
		public override function setRemoveDisplayMode(a:Boolean):void {
			super.setRemoveDisplayMode(a);
			setMouseListenersState(a);
			project(1);
		}
		
		public override function focusOut():void {
			super.focusOut();
			setHighlight(false);
			if (drawing) {stopDraw();}
		}
		public override function startDraw(startX:uint, startY:uint):void {
			super.startDraw(startX, startY);
			x1=startX;
			y1=startY;
			drawingStage=1;
		}
		
		private function el_mouse(e:MouseEvent):void {
			if (e.type==MouseEvent.MOUSE_DOWN) {
				notifySelected();
				return;
			}
			if (e.type==MouseEvent.MOUSE_OVER) {
				setHighlight(true);
				return;
			}
			focusOut();
		}
		
		private function setMouseListenersState(listen:Boolean):void {
			if (listen) {
				displayObject.addEventListener(MouseEvent.MOUSE_OVER, el_mouse);
				displayObject.addEventListener(MouseEvent.MOUSE_OUT, el_mouse);
				displayObject.addEventListener(MouseEvent.MOUSE_DOWN, el_mouse);
			} else {
				displayObject.removeEventListener(MouseEvent.MOUSE_OVER, el_mouse);
				displayObject.removeEventListener(MouseEvent.MOUSE_OUT, el_mouse);
				displayObject.removeEventListener(MouseEvent.MOUSE_DOWN, el_mouse);
			}
		}
		
		protected var x1:int;
		protected var y1:int;
	}
}

//{ =*^_^*= History
/* > (timestamp) [ ("+" (added) ) || ("-" (removed) ) || ("*" (modified) )] (text)
 * > 
 */
//} =*^_^*= END OF History

// template last modified:11.03.2011_[18#51#40]_[5]