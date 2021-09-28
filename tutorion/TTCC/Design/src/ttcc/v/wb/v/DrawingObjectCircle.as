// Project TTCC
package ttcc.v.wb.v {
	
	//{ =*^_^*= import
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import ttcc.LOG;
	//} =*^_^*= END OF import
	
	
	/**
	 * 
	 * @author Jinanoimatey Dragoncat
	 * @version 0.0.0
	 * @created 20.09.2012 22:15
	 */
	public class DrawingObjectCircle extends DrawingObjectOneClick {
		
		//{ =*^_^*= CONSTRUCTOR
		function DrawingObjectCircle (owner:WhiteboardMainPage) {
			super(owner);
		}
		//} =*^_^*= END OF CONSTRUCTOR
		
		protected override function project(displayMode:int=0):void {
			//rect.x=Math.min(x, x1);rect.y=Math.min(y, y1);
			//rect.width=Math.abs(x1-x);rect.height=Math.abs(y1-y);
			
			
			
			var r:Number=Math.sqrt((x1-x)*(x1-x)+(y1-y)*(y1-y));
			if ((x-r)<1) {r=x-1;}
			if ((x+r+1>drawingArea.width)) {r=drawingArea.width-1-x;}
			
			if ((y-r)<1) {r=y-1;}
			if ((y+r+1>drawingArea.height)) {r=drawingArea.height-1-y;}
			
			
			/*rect.x=Math.min(x1, x);rect.y=Math.min(y1, y);
			rect.width=Math.abs(x-x1);
			rect.height=Math.abs(y-y1);
			if (rect.width>rect.height) {
				rect.x+=(rect.width-rect.height)/2;
			} else {
				rect.y+=(rect.height-rect.width)/2;
			}
			rect.width=Math.min(rect.width, rect.height);
			*/
			
			displayObject.graphics.clear();
			displayObject.graphics.lineStyle(thickness/2, color);
			displayObject.graphics.drawCircle(x, y, r);
			//displayObject.graphics.drawEllipse(rect.x, rect.y, rect.width, rect.width);
			
			if (editMode||removeMode) {
				displayObject.graphics.lineStyle(selectedLineThickness, 0,0);
				displayObject.graphics.drawCircle(x, y, r);
				//displayObject.graphics.drawEllipse(x, y, x1-x, y1-y);
			}
			
			/*
			rect.x=Math.min(x1, x);rect.y=Math.min(y1, y);
			rect.width=Math.abs(x-x1);
			rect.height=Math.abs(y-y1);
			if (rect.width>rect.height) {
				rect.x+=(rect.width-rect.height)/2;
			} else {
				rect.y+=(rect.height-rect.width)/2;
			}
			rect.width=Math.min(rect.width, rect.height);
			
			
			displayObject.graphics.clear();
			displayObject.graphics.lineStyle(thickness/2, color);
			//displayObject.graphics.drawCircle(x, y, r);
			displayObject.graphics.drawEllipse(rect.x, rect.y, rect.width, rect.width);
			
			if (editMode||removeMode) {
				displayObject.graphics.lineStyle(selectedLineThickness, 0,0);
				displayObject.graphics.drawEllipse(x, y, x1-x, y1-y);
			}
			*/
		}
		
		private var rect:Rectangle=new Rectangle;
		
		//{ =*^_^*= model
		public override function deserialize(a:Object):Object {
			super.deserialize(a);
			x=a.x0;y=a.y0;x1=a.x1;y1=a.y1;color=a.c;thickness=a.t;uid=a.uid;
			drawing=true;project();drawing=false;
		}
		public override function serialize(a:Object=null):Object {
			var a:Object=(a)?a:{};
			a={type:TYPE_NAME, x0:x, y0:y, x1:x1, y1:y1, c:color, t:thickness};
			super.serialize(a);
			return a;
		}
		//} =*^_^*= END OF model
		public static const TYPE_NAME:String="circle";
		
	}
}

//{ =*^_^*= History
/* > (timestamp) [ ("+" (added) ) || ("-" (removed) ) || ("*" (modified) )] (text)
 * > 
 */
//} =*^_^*= END OF History

// template last modified:11.03.2011_[18#51#40]_[5]