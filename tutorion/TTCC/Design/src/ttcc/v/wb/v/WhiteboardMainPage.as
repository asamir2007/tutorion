// Project TTCC
package ttcc.v.wb.v {
	
	//{ ^_^ import
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.PixelSnapping;
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
	import ttcc.n.loaders.Im0;
	
	import ttcc.v.wb.VCWB;
	//} ^_^ END OF import
	
	
	/**
	 * contains interactive drawing elements
	 **/
	public class WhiteboardMainPage extends AssetPane {

		//private var t:TextField;
		
		
		//{ =*^_^*= CONSTRUCTOR
		function WhiteboardMainPage (vc:VCWB, bg:Bitmap, w:uint=1024, h:uint=768, index:int=0) {
			this.w=w;this.h=h;
			this.index=index;
			this.vc=vc;
			this.bgImBitmap=new Bitmap(bg.bitmapData, PixelSnapping.ALWAYS);
			
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
			//LOG(0,'setMouseEnabled:'+a);
			content.mouseChildren=!a;
			//bg.mouseChildren=!a;
			content.mouseEnabled=!a;
		}
		public function cancelDrawing():void {
			if (!currentDrawingObject) {return;}
			currentDrawingObject.cancelDrawing();// TODO: implement this in all implemented drawing objects
			objectsList.splice(objectsList.indexOf(currentDrawingObject),1);
			drawing=false;
			currentDrawingObject=null;
			//redrawBD();
		}
		public function drawingObjectStopDraw(a:DrawingObject):void {
			objectsList.splice(objectsList.indexOf(a),1);
			//LOG(0,'add object'+traceObject(a.serialize()));
			var addedObjectData:Object=currentDrawingObject.serialize();
			// transfer to server
			drawing=false;
			currentDrawingObject=null;
			redrawBD();
			vc.draw_addNewObject(addedObjectData);
		}
		public function objectSelected(a:DrawingObject):void {
			//LOG(0,'objectSelectedoperationMode:'+operationMode);
			// TODO: check mode(edit, remove, none), perform action
			if (operationMode==ID_OPERATION_MODE_DELETE) {
				//LOG(0,'remove object:'+a+'/index='+objectsList.indexOf(a));
				vc.delDataItem(objectsList.indexOf(a))
			} else if (operationMode==ID_OPERATION_MODE_EDIT) {
				//LOG(0,'todo: remove object');
				//LOG(0,'add new object'+traceObject(a.serialize()));
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
			pageIsCurrent=true;
			bg.addChildAt(bgImBitmap, 0);
		}
		public function hide():void {
			pageIsCurrent=false;
			setZoom(100);
		}
		//} ^_^ END OF wb interface
		
		
		//{ ^_^ controll
		public function setCurrentTool(a:String):void {
			// if drawing right now (text) - discard object
			if (currentDrawingObject) {
				objectsList.splice(objectsList.indexOf(currentDrawingObject));
				currentDrawingObject.destruct();
				currentDrawingObject=null;
				drawing=false;
			}
			
			currentTool = a;
			switch (currentTool) {
			
			case ID_B_TOOL_EDIT:
				setMode(ID_OPERATION_MODE_EDIT);
				setMouseEnabled(false);
				break;
			case ID_B_TOOL_ERASE:
				setMouseEnabled(false);
				setMode(ID_OPERATION_MODE_DELETE);
				break;
			
			case ID_B_TOOL_TEXT:
			case ID_B_TOOL_ELLIPSE:
			case ID_B_TOOL_RECT:
			case ID_B_TOOL_CIRC:
			case ID_B_TOOL_DRAW:
			case ID_B_TOOL_REAL_PEN:
			case ID_B_TOOL_LINE:
			case ID_B_TOOL_TEXT:
				setMouseEnabled(true);
				setMode(ID_OPERATION_MODE_DEFAULT);
				if (getZoom()!=100) {
					setZoom(100);
				}
				break;
			
			}
		}
		
		public function addObject(rawData:Object):void {
			// check if already in list:
			if (getObjectByUID(rawData.uid)!=null) {return;}
			// detect type
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
			case DrawingObjectRealPen.TYPE_NAME:
				drawingObject=new DrawingObjectRealPen(this);
				break;
			
			}
			drawingObject.set_drawingArea(w,h);
			drawingObject.deserialize(rawData);
			// add
			objectsList.push(drawingObject);
			redraw();
			redrawBD();
			if (pageIsCurrent&&((operationMode==ID_OPERATION_MODE_DELETE)||(operationMode==ID_OPERATION_MODE_EDIT))) {
				setMode(operationMode);
			}
			//LOG(0, 'after add>>>>>>total'+objectsList.length);
		}
		
		
		public function fromServer__removeObject(newObjectsIUIDList:Array):void {
			newObjectsIUIDList=newObjectsIUIDList.slice();
			var present:Boolean;
			for each(var i:DrawingObject in objectsList) {
				present=false;
				for each(var ii:String in newObjectsIUIDList) {
					if (i.get_uid()==ii) {present=true;newObjectsIUIDList.splice(newObjectsIUIDList.indexOf(ii),1);break;}
				}
				if (!present) {removeObject(i);}
			}
			redraw();
		}
		
		public function removeObject(o:DrawingObject):void {
			// remove if found
			if (o) {
				o.destruct();
				//var objectsListOLDlength:int=objectsList.length;
				objectsList.splice(objectsList.indexOf(o), 1);
				//LOG(3,'removeObject>>complete, index:'+id+' objectsList old l/new l: '+[objectsListOLDlength, objectsList.length]);
			} else {
				LOG(3,'removeObject>>not found, sn='+id);
			}
				
			redraw();
			redrawBD();
		}
		public function clearContent():void {
			clearLoadedBG();
			
			if (objectsList.length<1) {LOG(3,'clearContent>>objectsList.length<1');
				redraw();
				redrawBD();
				return;
			}
			for each(var i:Object in objectsList) {
				i.destruct();	
			}
			objectsList=[];
			
			redraw();
			redrawBD();
		}
		
		public function undo():void {
			// remove if found
			LOG(3,'page undo>>pageSN');
			if (objectsList.length<1) {LOG(3,'page undo>>objectsList.length<1');return;}
			// check if drawing something
			if (currentDrawingObject!=null) {
				cancelDrawing();
			}
			removeObject(objectsList[objectsList.length-1]);
		}
		
		
		
		
		private function el_bg(e:Event):void {
			//non drawing mode
			if (operationMode!=ID_OPERATION_MODE_DEFAULT || zoom!=100) {return;}
			
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
			if (vc.get_controllDisabled()) {return;}
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
			case ID_B_TOOL_REAL_PEN:
				currentDrawingObject=new DrawingObjectRealPen(this);
				break;
			
			}
			objectsList.push(currentDrawingObject);
			redraw();
			//currentDrawingObject.set_drawingArea(w,h);
			currentDrawingObject.set_drawingArea(bgImBitmap.width, bgImBitmap.height);
			currentDrawingObject.startDraw(mainContainer.mouseX, mainContainer.mouseY);
		}
		
		private function getObjectByUID(uid:String):DrawingObject {
			for each(var i:DrawingObject in objectsList) {if (i.get_uid()==uid) {return i;}}
			return null;
		}
		
		private function setMode(modeID:String):void {
			//operationMode=[ID_OPERATION_MODE_DEFAULT, ID_B_TOOL_ERASE, ID_B_TOOL_EDIT].indexOf(modeID);
			operationMode=modeID;
			for each(var i:DrawingObject in objectsList) {
				i.setRemoveDisplayMode(modeID==ID_OPERATION_MODE_DELETE);
				i.setEditDisplayMode(modeID==ID_OPERATION_MODE_EDIT);
			}
		}
		private var operationMode:String;
		private var pageIsCurrent:Boolean;
		
		/**
		 * DrawingObject
		 */
		private var objectsList:Array=[];
		private var currentTool:String;
		private var currentDrawingObject:DrawingObject;
		private var drawing:Boolean;
		//} ^_^ END OF controll
		
		//{ =*^_^*= real pen
		public function startDrawRealPen():void {
			setCurrentTool(ID_B_TOOL_REAL_PEN);
			startDraw();
		}
		public function receiveDataFromRealPen(data:Object):void {
			if (currentDrawingObject) {DrawingObjectRealPen(currentDrawingObject).receiveDataFromRealPen(data);}
		}
		//} =*^_^*= END OF real pen
		
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
			contentMask=mainContainer.addChild(new Sprite);
			redrawBG(w,h);
			redrawMask(w,h);
			//redrawContentMask(bgImBitmap.width, bgImBitmap.height);
			setZoom(100);
			redrawBD();
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
			var imW:int=100;//подобрано опытным методом
			var imH:int=71;//подобрано опытным методом
			//var imH:int=60*mainContainer.height/mainContainer.width;
			//var imH:int=50*bgImBitmap.height/bgImBitmap.width;
			//var scaleX:Number=imW/bgImBitmap.width;
			//var scaleY:Number=imH/bgImBitmap.height;
			var scaleX:Number=imW/mainContainer.width*1.3;//подобрано опытным методом
			var scaleY:Number=imH/mainContainer.height*1.23;//подобрано опытным методом
			if (scaleX==Infinity|| isNaN(scaleX)||scaleY==Infinity|| isNaN(scaleY)) {scaleX=1;scaleY=1;}
			//LOG(0,'imW/mainContainer.width:'+imW+'/'+mainContainer.width,1);
			
			//if (!bitmapData) {bitmapData=new BitmapData(50,50,false,0x00ff00);}
			
			mainContainer.cacheAsBitmap=true;
			Utils.getBitmapData(mainContainer, function(b:BitmapData):void {
					if (!miniPage) {b.dispose();return;}
					miniPage.setData(b);
					//LOG(0,'set');
					//bitmapData.copyPixels(b, b.rect, new Point(0,0));
					//b.dispose();
			}, false, 0x00ff00, 200, scaleX, scaleY, false);
			
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
		
		private function redrawContentMask(w:uint, h:uint):void {
			contentMask.graphics.clear();
			contentMask.graphics.beginFill(0,0.4);
			contentMask.graphics.drawRect(0,0,w, h);
			content.mask=contentMask;
		}
		private function redrawMask(w:uint, h:uint):void {
			mainContainerMask.graphics.clear();
			mainContainerMask.graphics.beginFill(0,0.4);
			mainContainerMask.graphics.drawRect(0,0,w, h);
			mainContainerContainer.mask=mainContainerMask;
			//mainContainerContainer.addChildAt(mainContainerMask,0);
		}
		private var newSizeW:int;
		private var newSizeH:int;
		
		public function setZoomPosition(x:Number, y:Number):void {
			mainContainer.x=x;
			mainContainer.y=y;
		}
			
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
				vc.page_setZoomPosition(mainContainer.x, mainContainer.y);
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
			bg.addChildAt(bgImBitmap, 0);
		}
		
		private function loadBgIm():void {
			loadedBGIM=bg.addChildAt(createSmallPicture(url), 1);
		}
		private var loadedBGIM:DisplayObject;
		
		private function clearLoadedBG():void {
			if (loadedBGIM) {
				bg.removeChild(loadedBGIM);
				loadedBGIM=null;
			}
		}
		
		private function createSmallPicture(a:String):Sprite {
			var s:Sprite=new Sprite;
			s.mouseChildren=false;
			s.mouseEnabled=false;
			s.graphics.beginFill(0,0);
			s.graphics.drawRect(0, 0, w, h);
			LOG(3,'>>>loading wb page bg, from:'+a, 0);
			s.addChild(new Im0(a, null
				,function(b:Im0):void {Utils.resizeDO(b, w, h);redrawBD();}
				,function(b:Im0, errorOccured:Boolean):void {
					if (loadBGAttemptMaxNum<1) {return;}
					loadBGAttemptMaxNum-=1;
					LOG(3,'failed to load wb page bg, will try again, '+loadBGAttemptMaxNum+' tries left',1);
					createSmallPicture(a);
				}
			))
			return s;
		}
		
		private var loadBGAttemptMaxNum:int=8;
		
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
		private var bgImBitmap:Bitmap;
		private var bg:Sprite;
		private var mainContainerContainer:Sprite;
		private var mainContainer:Sprite;
		private var mainContainerMask:Sprite;
		private var content:Sprite;
		private var contentMask:Sprite;
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
		public static const ID_B_TOOL_REAL_PEN:String='toolRealPen';
		public static const ID_OPERATION_MODE_DEFAULT:String='toolDefault';
		public static const ID_OPERATION_MODE_DELETE:String='toolDelete';
		public static const ID_OPERATION_MODE_EDIT:String='toolEdit';
		//} =*^_^*= END OF id
		
		
		
		//{ =*^_^*= model
		public function deserialize(a:Object):void {
			var dr:Array=a.draw;
			url=a.url;
			//LOG(0,'url='+url);
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