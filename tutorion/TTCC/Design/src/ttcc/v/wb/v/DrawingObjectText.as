// Project TTCC
package ttcc.v.wb.v {
	
	//{ =*^_^*= import
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import ttcc.LOG;
	//} =*^_^*= END OF import
	
	
	/**
	 * 
	 * @author Jinanoimatey Dragoncat
	 * @version 0.0.0
	 * @created 20.09.2012 21:48
	 */
	public class DrawingObjectText extends DrawingObject {
		
		//{ =*^_^*= CONSTRUCTOR
		function DrawingObjectText (owner:WhiteboardMainPage) {
			super(owner);
		}
		public override function construct():void {
			
		}
		public override function destruct():void {
			setMouseListenersState(false);
			//owner.setMouseEnabled(true);
			super.destruct();
		}
		//} =*^_^*= END OF CONSTRUCTOR
		
		public override function onMouseMove(x:uint, y:uint):void {
			super.onMouseMove(x,y);
			if ((drawingStage==DRAWINGSTAGE_DRAW_TF) && drawing) {
				r.x=Math.min(this.x, x);r.y=Math.min(this.y, y);
				r.width=Math.abs(x-this.x);r.height=Math.abs(y-this.y);
				displayObject.graphics.clear();
				displayObject.graphics.beginFill(0x999999);
				displayObject.graphics.lineStyle(1, 0,.7);
				displayObject.graphics.drawRect(r.x, r.y, r.width, r.height);
				dt.x=r.x;dt.y=r.y;dt.width=r.width;dt.height=r.height;
			}
		}
		public override function onMouseDown(x:uint, y:uint):void {
			super.onMouseDown(x,y);
			focusOut();
		}
		public override function onMouseUp(x:uint, y:uint):void {
			super.onMouseUp(x,y);
			if (removeMode) {setHighlight(false);}
			//LOG(0,'onMouse up, drawing='+drawing+'dt:'+dt)
			
			if (drawing) {
				if (drawingStage==DRAWINGSTAGE_DRAW_TF) {
					prepareTF(displayObject.mouseX-x, displayObject.mouseY-y);
					owner.setMouseEnabled(false);
					drawingStage=DRAWINGSTAGE_EDIT_TF;
					return;
				}
				// else: DRAWINGSTAGE_EDIT_TF
				if (!displayObject.getRect(displayObject).contains(displayObject.mouseX, displayObject.mouseY)) {
					drawingStage=DRAWINGSTAGE_END;
					stopDraw();
				}
			}
			
		}
		public override function onMouseOut():void {
			super.onMouseOut();
			if ((drawingStage==DRAWINGSTAGE_DRAW_TF)||(drawingStage==DRAWINGSTAGE_EDIT_TF)) {return;}
			focusOut();
		}
		
		public override function cancelDrawing():void {
			// remove listeners
			setMouseListenersState(false);
			super.cancelDrawing();
		}
		
		protected function project(displayMode:int=0):void {
			prepareTF(x1,y1,true);
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
		}
		protected override function stopDraw():void {
			dt.type=TextFieldType.DYNAMIC;
			dt.selectable=false;
			dt.background=false;
			dt.width=dt.textWidth+5;
			dt.height=dt.textHeight+5;
			owner.setMouseEnabled(true);
			super.stopDraw();
		}
		
		public override function startDraw(startX:uint, startY:uint):void {
			super.startDraw(startX, startY);
			prepareTF(drawingArea.width-x,drawingArea.height-y,true);
			prepareTF(1,1,false);
			owner.setMouseEnabled(false);
			drawingStage=DRAWINGSTAGE_EDIT_TF;
		}
		
		private function el_mouse(e:MouseEvent):void {
			//if (e.target==dt) {e.stopImmediatePropagation();return;}
			//if (drawing) {return;}
			if ((drawingStage==DRAWINGSTAGE_DRAW_TF)||(drawingStage==DRAWINGSTAGE_EDIT_TF)) {return;}
			
			if (e.type==MouseEvent.MOUSE_DOWN) {
				//owner.setMouseEnabled(false);
				notifySelected();
				return;
			}
			if (e.type==MouseEvent.MOUSE_OVER) {
				setHighlight(true);
				return;
			}
			focusOut();
		}
		
		private function prepareTF(w:int, h:int, firstStage:Boolean=false):void {
			if (firstStage) {
				this.dt=new TextField();
				dt.background=false;
				dt.multiline=true;
				//dt.wordWrap=true;
				dt.defaultTextFormat=new TextFormat(null, Math.max(14,thickness), color);
				
				dt.x=x;dt.y=y;
				//dt.width=25;
				//dt.height=25;
				dt.autoSize=TextFieldAutoSize.LEFT;
				dt.addEventListener(Event.CHANGE, function (e:Event):void {
					dt.width=Math.min(drawingArea.width-x, dt.textWidth+25);
					dt.height=Math.min(drawingArea.height-y, dt.textHeight+25);
				}, false, 0, true);
				displayObject.addChild(dt);
				dt.text=text;
				return;
			}
			displayObject.graphics.clear();
			
			dt.addEventListener(MouseEvent.MOUSE_DOWN, el_mouse);
			dt.type=TextFieldType.INPUT;
			//dt.background=true;
			//dt.backgroundColor=0xffffff;
			if (displayObject.stage) {displayObject.stage.focus=dt;}
			dt.setSelection(0, dt.text.length);
		}
		private var dt:TextField;
		
		
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
		
		private static const DRAWINGSTAGE_DRAW_TF:uint=1;
		private static const DRAWINGSTAGE_EDIT_TF:uint=2;
		private static const DRAWINGSTAGE_END:uint=3;
		
		private var x1:int;
		private var y1:int;
		private var text:String='text';
		private var r:Rectangle=new Rectangle();
		
		//{ =*^_^*= model
		public override function deserialize(a:Object):Object {
			super.deserialize(a);
			
			x=a.x;y=a.y;x1=a.x1;y1=a.y1;color=a.c;thickness=a.t;text=a.text;uid=a.uid;
			project();
			drawingStage=DRAWINGSTAGE_END;
		}
		public override function serialize(a:Object=null):Object {
			var a:Object=(a)?a:{};
			a={type:TYPE_NAME, x:dt.x, y:dt.y, x1:dt.width, y1:dt.height, c:color, t:thickness, text:dt.text};
			super.serialize(a);
			return a;
		}
		//} =*^_^*= END OF model
		public static const TYPE_NAME:String="text";
	}
}

//{ =*^_^*= History
/* > (timestamp) [ ("+" (added) ) || ("-" (removed) ) || ("*" (modified) )] (text)
 * > 
 */
//} =*^_^*= END OF History

// template last modified:11.03.2011_[18#51#40]_[5]