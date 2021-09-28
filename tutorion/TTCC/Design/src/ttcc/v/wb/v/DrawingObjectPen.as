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
	 * @created 23.09.2012 22:05
	 */
	public class DrawingObjectPen extends DrawingObjectOneClick {
		
		//{ =*^_^*= CONSTRUCTOR
		function DrawingObjectPen (owner:WhiteboardMainPage) {
			super(owner);
		}
		//} =*^_^*= END OF CONSTRUCTOR
		
		public override function onMouseMove(x:uint, y:uint):void {
			if (Math.abs(Math.max(x-lastX, y-lastY))>smoothness) {
				xy.push(int(Math.round(x)),int(Math.round(y)));
				lastX=x;lastY=y;
				displayObject.graphics.lineTo(x, y);
			}
		}
		protected override function project(displayMode:int=0):void {
			// redraw all
			displayObject.graphics.clear();
			displayObject.graphics.lineStyle(thickness/2, color);
			displayObject.graphics.moveTo(x, y);
			
			
			var l:int=xy.length-1;
			for (var i:int=0; i<l; i+=2) {
				displayObject.graphics.lineTo(xy[i], xy[i+1]);
			}
			
			if (editMode||removeMode) {
				displayObject.graphics.moveTo(x, y);
				displayObject.graphics.lineStyle(selectedLineThickness, 0,0);
				for (i=0; i<l; i+=2) {
					displayObject.graphics.lineTo(xy[i], xy[i+1]);
				}
			}
		}
		public override function startDraw(startX:uint, startY:uint):void {
			super.startDraw(startX, startY);
			lastX=startX;lastY=startY;
			project();
		}
		
		private var xy:Array=[];
		private var lastY:uint;
		private var lastX:uint;
		
		//{ =*^_^*= model
		public override function deserialize(a:Object):Object {
			super.deserialize(a);
			// override and place your code here
			x=a.x;y=a.y;color=a.c;thickness=a.t;xy=a.xy;uid=a.uid;
			drawing=true;project();drawing=false;
		}
		public override function serialize(a:Object=null):Object {
			var a:Object=(a)?a:{};
			a={type:TYPE_NAME, xy:xy, c:color, t:thickness, x:x, y:y};
			super.serialize(a);
			return a;
		}
		//} =*^_^*= END OF model
		public static const TYPE_NAME:String="pen";
		public static const smoothness:uint=2;
		
	}
}

//{ =*^_^*= History
/* > (timestamp) [ ("+" (added) ) || ("-" (removed) ) || ("*" (modified) )] (text)
 * > 
 */
//} =*^_^*= END OF History

// template last modified:11.03.2011_[18#51#40]_[5]