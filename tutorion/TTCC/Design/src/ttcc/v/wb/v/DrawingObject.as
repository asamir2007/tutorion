// Project TTCC
package ttcc.v.wb.v {
	
	//{ =*^_^*= import
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.filters.GlowFilter;
	import flash.geom.Rectangle;
	import flash.utils.getTimer;
	import ttcc.LOG;
	//} =*^_^*= END OF import
	
	
	/**
	 * 
	 * @author Jinanoimatey Dragoncat
	 * @version 0.0.0
	 * @created 20.09.2012 15:11
	 */
	public class DrawingObject {
		
		//{ =*^_^*= CONSTRUCTOR
		function DrawingObject (owner:WhiteboardMainPage) {
			this.owner=owner;
			displayObject=new Sprite();
			uid=getUID();
		}
		public function construct():void {
		}
		public function destruct():void {
			if (displayObject.parent) {displayObject.parent.removeChild(displayObject);}
			displayObject=null;
			// override and place your code here
			//super.destruct();
		}
		//} =*^_^*= END OF CONSTRUCTOR
		
		public final function get_d():DisplayObject {return displayObject;}
		
		public function set_drawingArea(w:uint, h:uint):void {
			drawingArea = new Rectangle(0,0,w,h);
		}
		
		public function onMouseMove(x:uint, y:uint):void {
			// override and place your code here
		}
		public function onMouseDown(x:uint, y:uint):void {
			// override and place your code here
		}
		public function onMouseUp(x:uint, y:uint):void {
			// override and place your code here
		}
		public function onMouseOut():void {
			// override and place your code here
		}
		
		public function setEditDisplayMode(a:Boolean):void {
			editMode=a;
			// override and place your code here
		}
		public function setRemoveDisplayMode(a:Boolean):void {
			removeMode=a;
			// override and place your code here
		}
		public function focusOut():void {
			// override and place your code here
		}
		public function cancelDrawing():void {
			destruct();
			// override and place your code here
			//super.cancelDrawing();
		}
		protected function stopDraw():void {
			drawing=false;
			owner.drawingObjectStopDraw(this);
			// override and place your code here
			// super() must reside
		}
		public function startDraw(startX:uint, startY:uint):void {
			drawing=true;
			color=owner.get_currentColor();
			thickness=owner.get_currentThickness();
			x=startX;y=startY;
			// override and place your code here
		}
		
		//{ =*^_^*= drawing object interface
		protected final function notifySelected(a:Boolean=true):void {
			owner.objectSelected(this);
		}
		protected final function setHighlight(a:Boolean):void {
			if(drawing) {return;}
			var filters:Array=(removeMode)?removeModeGlow:(editMode)?editModeGlow:[];
			displayObject.filters=(a)?filters:[];
			displayObject.mouseChildren=!a;
		}
		//} =*^_^*= END OF drawing object interface
		
		
		private var removeModeGlow:Array=[new GlowFilter(0xff0000, .5, 9, 9, 6, 1, false, false)];
		private var editModeGlow:Array=[new GlowFilter(0x00ff00, .5, 9, 9, 6, 1, false, false)];
		
		/**
		 * read only
		 */
		protected var editMode:Boolean;
		/**
		 * read only
		 */
		protected var removeMode:Boolean;
		protected var displayObject:Sprite;
		protected var owner:WhiteboardMainPage;
		
		protected var x:uint;
		protected var y:uint;
		protected var color:uint;
		protected var thickness:uint;
		protected var drawing:Boolean;
		protected var drawingStage:uint;
		protected var drawingArea:Rectangle;
		protected var id:String;
		
		
		//{ =*^_^*= model
		public function deserialize(a:Object):Object {
			uid=a.uid;
			//LOG(0,'deserialize:'+traceObject(a))
			// override and place your code here
			//super.deserialize(a);
		}
		public function serialize(a:Object=null):Object {
			a.uid=uid;
			//LOG(0,'serialize:'+traceObject(a))
			return a;
			
			// override and place your code here
			//var a:Object=(a)?a:{};
			//a=super.serialize(a);
		}
		//} =*^_^*= END OF model
		
		/**
		 * unique id
		 * @return
		 */
		public function get_uid():String {return uid;}
		private var uid:String;
		
		protected function getUID():String {
			var d:Date=new Date();
			cc+=1;
			if (cc>int.MAX_VALUE-4) {cc=1;}
			return int(Math.random()*9000)+'_'+d.setSeconds()+'_'+cc+'_'+getTimer();
		}
		private static var cc:int=1;
	}
}

//{ =*^_^*= History
/* > (timestamp) [ ("+" (added) ) || ("-" (removed) ) || ("*" (modified) )] (text)
 * > 
 */
//} =*^_^*= END OF History

// template last modified:11.03.2011_[18#51#40]_[5]