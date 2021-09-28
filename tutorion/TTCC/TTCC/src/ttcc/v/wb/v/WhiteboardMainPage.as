// Project TTCC
package ttcc.v.wb.v {
	
	//{ ^_^ import
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import org.aswing.AssetPane;
	import org.aswing.geom.IntDimension;
	import org.aswing.JScrollPane;
	import org.jinanoimateydragoncat.display.utils.Utils;
	import ttcc.LOG;
	import ttcc.n.loaders.Im;
	
	import ttcc.v.wb.VCWB;
	//} ^_^ END OF import
	
	
	/**
	 * contains interactive drawing elements
	 **/
	public class WhiteboardMainPage extends AssetPane {

		//private var t:TextField;
		
		
		//{ =*^_^*= CONSTRUCTOR
		function WhiteboardMainPage (vc:VCWB, w:uint=800, h:uint=600, index:int=0) {
			this.w=w;this.h=h;
			this.index=index;
			this.vc=vc;
			
			mainContainerContainer=new Sprite();
			super(mainContainerContainer, AssetPane.SCALE_NONE);
			setSizeWH(w,h);
			prepareView();
			//setNewSize(w,h);
		/*	t=new TextField();
			t.width=w;
			t.height=h/2;
			t.mouseEnabled=false;
			addChild(t);
		*/
		}
		
		//} =*^_^*= END OF CONSTRUCTOR
		
		public function get_miniPage():WhiteboardListElement {return miniPage;}
		public function set_miniPage(a:WhiteboardListElement):void {miniPage = a;}
		private var miniPage:WhiteboardListElement;
		
		//{ ^_^ drawing objects interface
		public function setMouseEnabled(a:Boolean):void {
			content.mouseChildren=!a;
			//bg.mouseChildren=!a;
			content.mouseEnabled=!a;
		}
		public function drawingObjectStopDraw(a:DrawingObject):void {
			//LOG(0,'add object'+traceObject(a.serialize()));
			var addedObjectData:Object=currentDrawingObject.serialize();
			// transfer to server
			drawing=false;
			currentDrawingObject=null;
			redrawBD();
			vc.draw_addNewObject(addedObjectData);
		}
		public function objectSelected(a:DrawingObject):void {
			// TODO: check mode(edit, remove, none), perform action
			if (operationMode==1) {
				LOG(0,'remove object'+a);
				LOG(0,'remove object'+vc.delDataItem(objectsList.indexOf(a)));
			} else if (operationMode==2) {
				LOG(0,'todo: remove object');
				LOG(0,'add new object'+traceObject(a.serialize()));
			}
		}
		public function get_currentColor():uint {return vc.get_currentColor();}
		public function get_currentThickness():uint {return vc.get_currentThickness();}
		public function get_bitmapData():BitmapData {return bitmapData;}
		//} ^_^ END OF drawing objects interface
		
		//public function set_currentColor(a:uint):void {}
		//public function set_currentThickness(a:uint):void {}
		
		//{ ^_^ wb interface
		public function get_id():int {return id;}
		public function set_id(a:int):void {id=a;}
		
		public function display():void {
			// TODO: maybe add listeners
		}
		public function hide():void {
			setZoom(100);
		}
		//} ^_^ END OF wb interface
		
		
		//{ ^_^ controll
		public function setCurrentTool(a:String):void {
			// TODO: if drawing right now (text) - discard object
			if (currentDrawingObject) {
				objectsList.splice(objectsList.indexOf(currentDrawingObject));
				currentDrawingObject.destruct();
				currentDrawingObject=null;
				drawing=false;
			}
			
			currentTool = a;
			switch (currentTool) {
			
			case ID_B_TOOL_EDIT:
			case ID_B_TOOL_ERASE:
				setMouseEnabled(false);
				setMode(currentTool);
				break;
			
			case ID_B_TOOL_TEXT:
			case ID_B_TOOL_ELLIPSE:
			case ID_B_TOOL_RECT:
			case ID_B_TOOL_CIRC:
			case ID_B_TOOL_DRAW:
			case ID_B_TOOL_LINE:
			case ID_B_TOOL_TEXT:
				setMouseEnabled(true);
				setMode(ID_OPERATION_MODE_DEFAULT);
				break;
			
			}
		}
		
		public function addObject(rawData:Object):void {
			// TODO: detect type
			var drawingObject:DrawingObject;
			switch (String(rawData.type)) {
			
			case DrawingObjectCircle.TYPE_NAME:
				drawingObject=new DrawingObjectCircle(this);
				break;
			case DrawingObjectEllipse.TYPE_NAME:
				drawingObject=new DrawingObjectEllipse(this);
				break;
			case DrawingObjectRect.TYPE_NAME:
				drawingObject=new DrawingObjectRect(this);
				break;
			case DrawingObjectPen.TYPE_NAME:
				drawingObject=new DrawingObjectPen(this);
				break;
			case DrawingObjectText.TYPE_NAME:
				drawingObject=new DrawingObjectText(this);
				break;
			case DrawingObjectLine.TYPE_NAME:
				drawingObject=new DrawingObjectLine(this);
				break;
			
			}
			drawingObject.set_drawingArea(w,h);
			drawingObject.deserialize(rawData);
			// add
			objectsList.push(drawingObject);
			redraw();
			redrawBD();
		}
		
		public function removeObject(id:int):void {
			// remove if found
			var o:DrawingObject=objectsList[id];
			if (o) {
				o.destruct();
				objectsList.splice(objectsList.indexOf(o), 1);
			}
			redraw();
			redrawBD();
		}
		
		
		
		private function el_bg(e:Event):void {
			if (operationMode>0 || zoom!=100) {//non drawing mode
				return;
			}
			
			switch (e.type) {
			
			case MouseEvent.MOUSE_MOVE:
				if (currentDrawingObject) {currentDrawingObject.onMouseMove(mainContainer.mouseX, mainContainer.mouseY);}
				break;
			case MouseEvent.MOUSE_DOWN:
				if (!drawing) {
					drawing=true;
					startDraw();
					break;
				}
				if (currentDrawingObject) {currentDrawingObject.onMouseDown(mainContainer.mouseX, mainContainer.mouseY);}
				break;
			case MouseEvent.MOUSE_OUT:
				if (currentDrawingObject) {currentDrawingObject.onMouseOut();}
				break;
			case MouseEvent.MOUSE_UP:
				if (currentDrawingObject) {currentDrawingObject.onMouseUp(mainContainer.mouseX, mainContainer.mouseY);}
				break;
			}
		}
		
		
		private function startDraw():void {
			//LOG(0,'startDraw');
			switch (currentTool) {
			
			case ID_B_TOOL_CIRC:
				currentDrawingObject=new DrawingObjectCircle(this);
				break;
			case ID_B_TOOL_ELLIPSE:
				currentDrawingObject=new DrawingObjectEllipse(this);
				break;
			case ID_B_TOOL_RECT:
				currentDrawingObject=new DrawingObjectRect(this);
				break;
			case ID_B_TOOL_DRAW:
				currentDrawingObject=new DrawingObjectPen(this);
				break;
			case ID_B_TOOL_TEXT:
				currentDrawingObject=new DrawingObjectText(this);
				break;
			case ID_B_TOOL_LINE:
				currentDrawingObject=new DrawingObjectLine(this);
				break;
			
			}
			objectsList.push(currentDrawingObject);
			redraw();
			currentDrawingObject.set_drawingArea(w,h);
			currentDrawingObject.startDraw(mainContainer.mouseX, mainContainer.mouseY);
		}
		
		private function setMode(modeID:String):void {
			operationMode=[ID_OPERATION_MODE_DEFAULT, ID_B_TOOL_ERASE, ID_B_TOOL_EDIT].indexOf(modeID);
			for each(var i:DrawingObject in objectsList) {
				i.setRemoveDisplayMode(modeID==ID_B_TOOL_ERASE);
				i.setEditDisplayMode(modeID==ID_B_TOOL_EDIT);
			}
		}
		/**
		 * 0 none 1 remove 2 edit
		 */
		private var operationMode:uint=0;
		
		/**
		 * DrawingObject
		 */
		private var objectsList:Array=[];
		private var currentTool:String;
		private var currentDrawingObject:DrawingObject;
		private var drawing:Boolean;
		//} ^_^ END OF controll
		
		private var id:int;
		public function get_pageName():String {return pageName;}
		//public function set_pageName(a:String):void {pageName = a;}
		private var pageName:String;
		
		//{ =*^_^*= =*^_^*= VIEW
		
		private function prepareView():void {
			//mainContainerContainer=addChild(new Sprite());
			mainContainer=mainContainerContainer.addChild(new Sprite());
			mainContainerMask=addChild(new Sprite());
			prepareBG();
			content=mainContainer.addChild(new Sprite);
			redrawBG(w,h);
			redrawBD();
			redrawMask(w,h);
		}
		public function destruct():void {
			while(numChildren!=0) {removeChildAt(0);}
			// TODO: clear data
		}
		
		public function redraw():void {
			// project
			while(content.numChildren>0) {content.removeChildAt(0);}
			for each(var i:DrawingObject in objectsList) {content.addChild(i.get_d());}
		}
		
		public function redrawBD():void {
			var imW:int=50;
			var imH:int=50*mainContainer.height/mainContainer.width;
			var scaleX:Number=imW/mainContainer.width;
			var scaleY:Number=imH/mainContainer.height;
			
			if (!bitmapData) {bitmapData=new BitmapData(50,50,false,0x00ff00);}
			// TODO: draw page contents (uncomment line v)
			mainContainer.cacheAsBitmap=true;
			Utils.getBitmapData(mainContainer, function(b:BitmapData):void {
					if (!miniPage) {b.dispose();return;}
					miniPage.setData(b);
					//LOG(0,'set');
					//bitmapData.copyPixels(b, b.rect, new Point(0,0));
					//b.dispose();
			}, false, 0x00ff00, 200, scaleX, scaleY, true);
			
		}
		
		
		public function getSizeW():Number {return mainContainerContainer.getBounds(this).width;}
		public function getSizeH():Number {return mainContainerContainer.getBounds(this).height;}
		public function setNewSize(w:uint, h:uint):void {
			newSizeW=w;newSizeH=h;
			setZoom(100);
			Utils.resizeDO(mainContainerContainer, w,h);
			//Utils.centerDO(mainContainerContainer, new Rectangle(0,0,w,h));
			redrawMask(w,h);
			setSizeWH(w,h);
		}
		
		private function redrawMask(w:uint, h:uint):void {
			mainContainerMask.graphics.clear();
			mainContainerMask.graphics.beginFill(0);
			mainContainerMask.graphics.drawRect(0,0,w, h);
			mainContainerContainer.mask=mainContainerMask;
		}
		private var newSizeW:int;
		private var newSizeH:int;
		/**
		 * 100...200
		 * @param	a
		 */
		public function getZoom():int {return zoom;}
		public function setZoom(a:int):void {
			zoom=a;
			//redrawMask();
			var dw:int=mainContainer.width;
			var dh:int=mainContainer.height;
			mainContainer.scaleX=a/100;
			mainContainer.scaleY=a/100;
			dw-=mainContainer.width;
			dh-=mainContainer.height;
			setZoomViewMode(zoom==100);
			if (a==100) {
				mainContainer.x=0;
				mainContainer.y=0;
			} else {
				mainContainer.x+=dw/2;
				mainContainer.y+=dh/2;
			}
		}
		private var zoom:int=100;
		
		private function setZoomViewMode(a:Boolean):void {
			//LOG(0,'setZoomViewMode '+a)
			if (a==elZoomMode) {return;}
			elZoomMode=a;
			mainContainer.mouseChildren=a;
			if (a) {
				mainContainer.removeEventListener(MouseEvent.MOUSE_DOWN, el_mainContainer_zoom);
				mainContainer.removeEventListener(MouseEvent.MOUSE_UP, el_mainContainer_zoom);
				removeEventListener(MouseEvent.MOUSE_OUT, el_mainContainer_zoom);
				//setNewSize(newSizeW,newSizeH);
			} else {
				mainContainer.addEventListener(MouseEvent.MOUSE_DOWN, el_mainContainer_zoom);
				mainContainer.addEventListener(MouseEvent.MOUSE_UP, el_mainContainer_zoom);
				addEventListener(MouseEvent.MOUSE_OUT, el_mainContainer_zoom);
			}
		}
		private var elZoomMode:Boolean=true;
		private function el_mainContainer_zoom(e:Event):void {
			//LOG(0,'type:'+e.type)
			if ((e.type==MouseEvent.MOUSE_UP)||(e.type==MouseEvent.MOUSE_OUT)) {
				mainContainer.stopDrag();
			} else {
				var hhh:Number=mainContainer.height;
				var www:Number=mainContainer.width;
				var dragRect:Rectangle=new Rectangle(-(www-w),-(hhh-h)
				,www-w,hhh-h);
				
				mainContainer.startDrag(false, dragRect);
			}
		}
		
		private function redrawBG(w:uint, h:uint):void {
			bg.graphics.clear();
			bg.graphics.beginFill(0xeeeeee);//bg
			bg.graphics.lineStyle(1,0x777777);
			bg.graphics.drawRect(0,0,w,h);
		}
		
		
		private function prepareBG():void {
			bg=mainContainer.addChild(new Sprite);
			mainContainer.addEventListener(MouseEvent.MOUSE_DOWN, el_bg);
			mainContainer.addEventListener(MouseEvent.MOUSE_UP, el_bg);
			mainContainer.addEventListener(MouseEvent.MOUSE_MOVE, el_bg);
			mainContainer.addEventListener(MouseEvent.MOUSE_OUT, el_bg);
		}
		
		private function loadBgIm():void {
			bg.addChild(createSmallPicture(url));
		}
		
		private function createSmallPicture(a:String):Sprite {
			var s:Sprite=new Sprite;
			s.mouseChildren=false;
			s.mouseEnabled=false;
			s.graphics.beginFill(0,0);
			s.graphics.drawRect(0, 0, w, h);
			s.addChild(new Im(a, null, null
				,function(a:Im):void {Utils.resizeDO(a, w, h);redrawBD();}
				,function(a:Im, errorOccured:Boolean):void {
					LOG(3,'failed to load wb page bg',1);
					// TODO: display brokenimage or try again
				}
			))
			return s;
		}
		
		
/*		private function prepareCPanel():void {
			panelContent=new AssetPane(mainContainer, AssetPane.SCALE_NONE);
			contentScrollPane = new JScrollPane(panelContent, JScrollPane.SCROLLBAR_ALWAYS, JScrollPane.SCROLLBAR_ALWAYS);
			contentScrollPane.setSizeWH(300, 300);// TODO: move wb size from here
			addChild(contentScrollPane);
		}
*/		
		
		public function get_index():int {return index;}
		
		//private var panelContent:AssetPane;
		//private var contentScrollPane:JScrollPane;
		private var bitmapData:BitmapData;
		private var vc:VCWB;
		private var bg:Sprite;
		private var mainContainerContainer:Sprite;
		private var mainContainer:Sprite;
		private var mainContainerMask:Sprite;
		private var content:Sprite;
		private var index:int;
		private var w:uint;
		private var h:uint;
		private var url:String;
		//} =*^_^*= =*^_^*= END OF VIEW
		
		
		//{ =*^_^*= id
		public static const ID_B_TOOL_DRAW:String='toolDraw';
		public static const ID_B_TOOL_LINE:String='toolLine';
		public static const ID_B_TOOL_CIRC:String='toolCirc';
		public static const ID_B_TOOL_ELLIPSE:String='toolEllipse';
		public static const ID_B_TOOL_RECT:String='toolRect';
		public static const ID_B_TOOL_TEXT:String='toolText';
		public static const ID_B_TOOL_ERASE:String='toolErase';
		public static const ID_B_TOOL_EDIT:String='toolEdit';
		public static const ID_OPERATION_MODE_DEFAULT:String='toolDefault';
		//} =*^_^*= END OF id
		
		
		
		//{ =*^_^*= model
		public function deserialize(a:Object):void {
			var dr:Array=a.draw;
			url=a.url;
			LOG(0,'url='+url);
			if (url.length>1) {loadBgIm();}
			pageName=String(a.txt);
			//LOG(0,'[>>] -> pageName='+pageName,0)
			//redraw();
			for each(var i:Object in dr) {
				addObject(i);
			}
			redrawBD();
		}
		public function serialize():Object {
		}
		//} =*^_^*= END OF model
		
		
	}
}