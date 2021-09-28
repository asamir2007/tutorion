package org.jinanoimateydragoncat.works.cyber_modules.v.vc {
	
	//{ =*^_^*= import
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	//} =*^_^*= END OF import
	
	
	/**
	 * optimized (object pool)
	 * @author Jinanoimatey Dragoncat
	 * @version 0.0.0
	 * @created 05.03.2012 23:22
	 */
	public class VCSimpleChart {
		
		//{ =*^_^*= CONSTRUCTOR
		
		function VCSimpleChart (physicalW:uint, physicalH:uint, vpW:uint, vpH:uint, bgColor:uint=0, transparent:Boolean=false) {
			this.bgColor=bgColor;
			this.transparent=transparent;
			this.vpW=vpW;
			this.vpH=vpH;
			this.pW=physicalW;
			this.pH=physicalH;
			
			d=new Sprite();
			s=d.addChild(new Sprite());
			sg=s.graphics;
			m=d.addChild(new Sprite());
			sh=d.addChild(new Shape());
			m.graphics.beginFill(0);
			m.graphics.drawRect(0,0,vpW,vpH);
			s.mask=m;
			set_displayStyleNodeCircleRadius(displayStyleNodeCircleRadius);
		}
		//} =*^_^*= END OF CONSTRUCTOR
		
		//{ =*^_^*= user access
		public function drawBorder(lineWeight:Number=Number.NaN, color:uint=0x00ff00):void {
			borderLineWeight=lineWeight;
			//recalc border
			set_displayStyleNodeCircleRadius(displayStyleNodeCircleRadius);
			//display
			d.graphics.clear();
			if (isNaN(lineWeight)) {return;}
			sh.graphics.beginFill(color);
			sh.graphics.drawRect(0,0,vpW,vpH);
			sh.graphics.drawRect(lineWeight,lineWeight,vpW-lineWeight*2,vpH-lineWeight*2);
		}
		
		/**
		 * 
		 * @param	physicalPositionX 0...1
		 * @param	physicalPositionY 0...1
		 * @param	dataX any
		 * @param	dataY any
		 * @param	color
		 * @param	groupID
		 * @param	displayLevel
		 */
		public function addNode(physicalPositionX:Number, physicalPositionY:Number, dataX:Number, dataY:Number, color:uint, lineWeight:Number, groupID:uint, displayLevel:uint):void {
			if (!lNodes[groupID]) {lNodes[groupID]=[];}
			var i:Node=Node.getInstance(
				pWG*physicalPositionX
				,pHG*(1-physicalPositionY)
				,dataX,dataY,color, lineWeight,groupID,displayLevel);
			lNodes[groupID][lNodes[groupID].length]=i;
			usedNodes[usedNodes.length]=i;
			if (data_minX>dataX) {data_minX=dataX;}else if (data_maxX<dataX) {data_maxX=dataX;}
			if (data_minY>dataY) {data_minY=dataY;}else if (data_maxY<dataY) {data_maxY=dataY;}
			data_valueX=data_maxX-data_minX;
			data_valueY=data_maxY-data_minY;
		}
		
		public function clear():void {
			//delete
			s.graphics.clear();
			if (bd) {bd.fillRect(bd.rect,bgColor);}
			for each(var i:Node in usedNodes) {i.destroy();}
			usedNodes.splice(0, usedNodes.length);
			for each(var ii:Array in lNodes) {ii.splice(0, ii.length);}
			lNodes.splice(0, lNodes.length);
			data_minX=Number.MAX_VALUE;data_valueX=0;data_maxY=0;
			data_minY=Number.MAX_VALUE;data_valueY=0;data_maxX=0;
		}
		
		public function redraw():void {
			s.graphics.clear();
			var il:uint;
			var a:Node;
			var b:Node;
			var dr:uint=displayStyleNodeCircleRadius;
			for each(var i:Array in lNodes) {
				if (i) {
					il=i.length;
					if (il>0) {
						for (var ni:uint=0;ni<il;ni+=1) {
							a=((ni>0)?i[ni-1]:null);
							b=i[ni];
							//dn(((ni>0)?i[ni-1]:null), i[ni]);
/**
 * INLINE
 * draw nodes
 */
//private function dn(a:Node, b:Node):void {
	// connect
	if (a) {
		sg.lineStyle(b.get_lw(), b.get_c());
		sg.moveTo(a.get_pX(),a.get_pY());
		sg.lineTo(b.get_pX(),b.get_pY());
		// draw
		sg.lineStyle();
		sg.beginFill(a.get_c());
		sg.drawCircle(a.get_pX(),a.get_pY(),dr);
	}
	// draw
	sg.lineStyle();
	sg.beginFill(b.get_c());
	sg.drawCircle(b.get_pX(),b.get_pY(),dr);
// }
						}
					}
				}
			}
		}
		
		
		public function redrawBD():void {
			if (!bd) {bd=new BitmapData(pW, pH, transparent, bgColor);}
			bd.fillRect(bd.rect,bgColor);
			redraw();
			bd.draw(d);
		}
		
		/**
		 * @param	a 0...1
		 */
		public function setScrollH(a:Number):void {s.x=-(pW-vpW)*a;}
		/**
		 * @param	a 0...1
		 */
		public function setScrollV(a:Number):void {s.y=-(pH-vpH)*a;}
		
		public function getBitmap(redraw:Boolean=true):Bitmap {
			if (redraw) {redrawBD();}
			return new Bitmap(bd.clone());
		}
		
		public function getDataX(physicalX:Number):Number {
			physicalX=Math.max(bW, Math.min(pW-bW,physicalX));
			return (physicalX/pWG)*data_valueX+data_minX;
		}
		public function getDataY(physicalY:Number):Number {
			physicalY=Math.max(bW, Math.min(pH-bW,physicalY));
			return (1-physicalY/pHG)*data_valueY+data_minY;
		}
		
		public function get_bitmapData():BitmapData {return bd;}
		public function get_displayObject():Sprite {return d;}
		//} =*^_^*= END OF user access
		
		//{ =*^_^*= data
		private var usedNodes:Array=[];
		private var lNodes:Array=[];
		private var data_valueX:Number=0;
		private var data_valueY:Number=0;
		private var data_minX:Number=Number.MAX_VALUE;
		private var data_maxX:Number=0;
		private var data_minY:Number=Number.MAX_VALUE;
		private var data_maxY:Number=0;
		
		private var bgColor:uint;
		private var vpW:uint;
		private var vpH:uint;
		private var pW:uint;
		private var pH:uint;
		private var pWG:uint;
		private var bW:uint;
		private var pHG:uint;
		private var borderLineWeight:Number;
		private var transparent:Boolean;
		
		private var bd:BitmapData;
		private var s:Sprite;
		private var sh:Shape;
		private var sg:Graphics;
		private var m:Sprite;
		private var d:Sprite;
		
		/**
		 * use before addNode() and redraw() or use clear() 
		 * @param	a
		 */
		public function set_displayStyleNodeCircleRadius(a:uint):void {
			displayStyleNodeCircleRadius = a;
			bW=Math.max(displayStyleNodeCircleRadius, borderLineWeight);
			pWG=pW-bW*2;
			pHG=pH-bW*2;
		}
		private var displayStyleNodeCircleRadius:uint=4;
		//} =*^_^*= END OF data
		
		//{ =*^_^*= id
		//public static const ID_DISPLAY_NODE_LEVEL_NONE:uint=0;
		//public static const ID_DISPLAY_NODE_LEVEL_X:uint=1;
		//public static const ID_DISPLAY_NODE_LEVEL_Y:uint=2;
		//public static const ID_DISPLAY_NODE_LEVEL_X_AND_Y:uint=3;
		//} =*^_^*= END OF id
	}
}

import flash.utils.Dictionary;

class Node  {
	
	public function get_dX():Number {return dX;}
	public function get_dY():Number {return dY;}
	public function get_c():uint {return c;}
	public function get_gi():uint {return gi;}
	public function get_dl():uint {return dl;}
	public function get_pX():uint {return pX;}
	public function get_pY():uint {return pY;}
	public function get_lw():Number {return lw;}

	private var dX:Number;
	private var dY:Number;
	private var c:uint;
	private var lw:Number;
	private var gi:uint;
	private var dl:uint;
	private var pX:uint;
	private var pY:uint;
	
	public function destroy():void {
		returnInstance(this);
	}
	
	//{ =*^_^*= pool
	public static function getInstance(physicalPositionX:uint, physicalPositionY:uint, dataX:Number, dataY:Number, color:uint, lineWeight:Number, groupID:uint, displayLevel:uint):Node {
		var i:Node=pool;
		if (!i) {i=new Node();}
		pool=poolNext[i];
		poolNext[i]=null;
		
		i.pX=physicalPositionX;
		i.pY=physicalPositionY;
		i.dX=dataX;
		i.dY=dataY;
		i.c=color;
		i.lw=lineWeight;
		i.gi=groupID;
		i.dl=displayLevel;
		
		return i;
	}
	
	public static function returnInstance(a:Node):void {
		poolNext[a]=pool;
		pool=a;
	}
	
	private static var pool:Node;
	private static var poolNext:Dictionary=new Dictionary();
	//} =*^_^*= END OF pool
	
}

//{ =*^_^*= History
/* > (timestamp) [ ("+" (added) ) || ("-" (removed) ) || ("*" (modified) )] (text)
 * > 
 */
//} =*^_^*= END OF History

// template last modified:11.03.2011_[18#51#40]_[5]