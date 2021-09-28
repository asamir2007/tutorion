// Project TestLab
package org.jinanoimateydragoncat.display.utils {
	
	//{ =^_^= import
	import flash.display.DisplayObject;
	import flash.geom.Rectangle;
	//} =^_^= END OF import
	
	/**
	 * 
	 * @author Jinanoimatey Dragoncat
	 * @version 0.0.0
	 * @created 03.12.2010 21:30
	 */
	public class Utils {
		
		//{ =^_^= CONSTRUCTOR
		
		function Utils () {
			throw new ArgumentError('static container only');
		}
		//} =^_^= END OF CONSTRUCTOR
		
		/**
		 * 
		 * @param	targetDisplayObject
		 * @param transparent BitmapData() argument
		 * @param fillColor BitmapData() argument
		 * @param	callBack function(bd:BitmapData)
		 * @param waitFor time(in milliseconds) to wait before execution (flash bug)
		 */
		public static function getBitmapData (targetDisplayObject:DisplayObject, callBack:Function, transparent:Boolean=true, fillColor:int=0xFFFFFF, waitFor:Number = 1, scaleX:Number=1, scaleY:Number=1, smoothing:Boolean=false):void {
			new GetBitmapDataOperation(targetDisplayObject, callBack, transparent, fillColor, waitFor, scaleX, scaleY, smoothing);
		}
		
		public static function resizeDO(target:DisplayObject, maxW:Number, maxH:Number):void {
			if (target.width/target.height>maxW/maxH) {
				target.width =maxW;
				target.scaleY = target.scaleX;
			} else {
				target.height = maxH;
				target.scaleX = target.scaleY;
			}
		}
		
		public static function centerDO(target:DisplayObject, container:Rectangle):void {
			target.x = container.x+container.width*.5-target.width*.5;
			target.y = container.y+container.height*.5-target.height*.5;
		}
	}
}
import flash.display.DisplayObject;
import flash.events.TimerEvent;
import flash.geom.Rectangle;
import flash.utils.Timer;
import flash.display.BitmapData;
import flash.geom.Matrix;
import flash.geom.ColorTransform;
import ttcc.LOG;


class GetBitmapDataOperation {
	function GetBitmapDataOperation(targetDisplayObject:DisplayObject, callBack:Function, transparent:Boolean=true, fillColor:int=0xFFFFFF, waitFor:Number=1, sx:Number=1, sy:Number=1, smoothing:Boolean=false) {
		this.sx=sx;
		this.sy=sy;
		this.smoothing=smoothing;
		this.targetDisplayObject = targetDisplayObject;
		this.callBack = callBack;
		this.fillColor = fillColor;
		this.transparent = transparent;
		
		timer = new Timer(waitFor, 0);
		timer.addEventListener(TimerEvent.TIMER, init);
		timer.start();
	}
	
	private var timer:Timer;
	
	private function init(e:TimerEvent):void {
		timer.stop();
		
		var bounds:Rectangle = getRealBounds(targetDisplayObject, sx, sy);
		var bd:BitmapData = new BitmapData(bounds.width, bounds.height, transparent, fillColor);
		
		var matrix:Matrix = new Matrix();
		matrix.scale(sx,sy);
		matrix.translate(-bounds.x, -bounds.y);
		
		bd.draw(targetDisplayObject, matrix, null, null, null, smoothing);
		
		callBack(bd);
	}
	
	private function getRealBounds(displayObject:DisplayObject, sx:Number, sy:Number):Rectangle {
		var bounds:Rectangle;
		var boundsDispO:Rectangle = displayObject.getBounds(displayObject);
		//LOG(0,boundsDispO+';sx='+sx)
		//LOG(0,Math.ceil((boundsDispO.width-1)*sx))
		var bitmapData:BitmapData = new BitmapData(Math.max(1, int((boundsDispO.width-1)*sx)), Math.max(int((boundsDispO.height-1))*sy), true, 0);
		var matrix:Matrix = new Matrix();
		//matrix.scale(sx,sy);
		matrix.translate(-boundsDispO.x+ 0.5, -boundsDispO.y+ 0.5);
		bitmapData.draw(displayObject, matrix, new ColorTransform( 1, 1, 1, 1, 255, -255, -255, 255 ) );
		bounds = bitmapData.getColorBoundsRect(0xFF000000, 0xFF000000);
		bounds.x += boundsDispO.x;
		bounds.y += boundsDispO.y;
		bitmapData.dispose();
		return bounds;
	}
	
	private var targetDisplayObject:DisplayObject;
	private var callBack:Function;
	private var transparent:Boolean;
	private var sx:Number;
	private var sy:Number;
	private var smoothing:Boolean;
	private var fillColor:int;
}

//{ =^_^= History
/* > (timestamp) [ ("+" (added) ) || ("-" (removed) ) || ("*" (modified) )] (text)
 * > 
 */
//} =^_^= END OF History

// template last modified:03.05.2010_[22#42#27]_[1]