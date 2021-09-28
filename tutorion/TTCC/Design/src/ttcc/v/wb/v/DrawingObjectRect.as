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
	 * @created 20.09.2012 21:40
	 */
	public class DrawingObjectRect extends DrawingObjectOneClick {
		
		//{ =*^_^*= CONSTRUCTOR
		function DrawingObjectRect (owner:WhiteboardMainPage) {
			LOG(0,'rect')
			super(owner);
		}
		//} =*^_^*= END OF CONSTRUCTOR
		protected override function project(displayMode:int=0):void {
			r.x=Math.min(x, x1);r.y=Math.min(y, y1);
			r.width=Math.abs(x1-x);r.height=Math.abs(y1-y);
			displayObject.graphics.clear();
			displayObject.graphics.lineStyle(thickness/2, color);
			displayObject.graphics.drawRect(r.x, r.y, r.width, r.height);
			
			if (editMode||removeMode) {
				displayObject.graphics.lineStyle(selectedLineThickness, 0,0);
				displayObject.graphics.drawRect(r.x, r.y, r.width, r.height);
			}
		}
		
		private var r:Rectangle=new Rectangle();
		
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
		
		public static const TYPE_NAME:String="rect";
		
	}
}

//{ =*^_^*= History
/* > (timestamp) [ ("+" (added) ) || ("-" (removed) ) || ("*" (modified) )] (text)
 * > 
 */
//} =*^_^*= END OF History

// template last modified:11.03.2011_[18#51#40]_[5]