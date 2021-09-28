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
		
		public override function project(displayMode:int=0):void {
			var r:Number=Math.sqrt((x1-x)*(x1-x)+(y1-y)*(y1-y));
			if ((x-r)<1) {r=x-1;} else if ((x+r+1>drawingArea.width)) {r=drawingArea.width-1-x;}
			if ((y-r)<1) {r=y-1;} else if ((y+r+1>drawingArea.height)) {r=drawingArea.height-1-y;}
			/*r.x=Math.min(x1, x);r.y=Math.min(y1, y);
			r.width=Math.abs(x-x1);
			r.height=Math.abs(y-y1);
			if (r.width>r.height) {
				r.x+=(r.width-r.height)/2;
			} else {
				r.y+=(r.height-r.width)/2;
			}
			r.width=Math.min(r.width, r.height);
			*/
			displayObject.graphics.clear();
			displayObject.graphics.lineStyle(thickness/2, color);
			displayObject.graphics.drawCircle(x, y, r);
			//displayObject.graphics.drawEllipse(r.x, r.y, r.width, r.width);
			
			if (editMode||removeMode) {
				displayObject.graphics.lineStyle(9, 0,0);
				displayObject.graphics.drawEllipse(x, y, x1-x, y1-y);
			}
		}
		
		//private var r:Rectangle=new Rectangle;
		
		//{ =*^_^*= model
		public override function deserialize(a:Object):void {
			x=a.x0;y=a.y0;x1=a.x1;y1=a.y1;color=a.c;thickness=a.t;
			drawing=true;project();drawing=false;
		}
		public override function serialize():Object {
			return {type:TYPE_NAME, x0:x, y0:y, x1:x1, y1:y1, c:color, t:thickness};
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