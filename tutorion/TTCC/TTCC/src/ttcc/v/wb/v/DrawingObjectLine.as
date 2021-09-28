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
	 * @created 20.09.2012 17:05
	 */
	public class DrawingObjectLine extends DrawingObjectOneClick {
		
		//{ =*^_^*= CONSTRUCTOR
		function DrawingObjectLine (owner:WhiteboardMainPage) {
			super(owner);
		}
		//} =*^_^*= END OF CONSTRUCTOR
		
		public override function project(displayMode:int=0):void {
			displayObject.graphics.clear();
			displayObject.graphics.lineStyle(thickness/2, color);
			displayObject.graphics.moveTo(x, y);
			displayObject.graphics.lineTo(x1, y1);
			
			if (editMode||removeMode) {
				displayObject.graphics.moveTo(x, y);
				displayObject.graphics.lineStyle(9, 0,0);
				displayObject.graphics.moveTo(x, y);
				displayObject.graphics.lineTo(x1, y1);
			}
		}
		
		//{ =*^_^*= model
		public override function deserialize(a:Object):void {
			// override and place your code here
			x=a.x0;y=a.y0;x1=a.x1;y1=a.y1;color=a.c;thickness=a.t;
			drawing=true;project();drawing=false;
		}
		public override function serialize():Object {
			return {type:TYPE_NAME, x0:x, y0:y, x1:x1, y1:y1, c:color, t:thickness};
		}
		//} =*^_^*= END OF model
		public static const TYPE_NAME:String="line";
		
	}
}

//{ =*^_^*= History
/* > (timestamp) [ ("+" (added) ) || ("-" (removed) ) || ("*" (modified) )] (text)
 * > 
 */
//} =*^_^*= END OF History

// template last modified:11.03.2011_[18#51#40]_[5]