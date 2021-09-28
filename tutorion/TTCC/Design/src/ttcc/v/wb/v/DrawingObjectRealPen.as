// Project TTCC
package ttcc.v.wb.v {
	
	//{ =*^_^*= import
	import com.dynamicflash.util.Base64;
	
	import flash.display.GraphicsPathCommand;
	import flash.events.MouseEvent;
	import flash.utils.ByteArray;
	
	import ttcc.LOG;

	//} =*^_^*= END OF import
	
	//drawingArea - содержит размер области рисования доски
	//stopDraw - вызвать метод в конце рисования для отправки данных на сервер
	
	/**
	 * 
	 * @author Jinanoimatey Dragoncat
	 * @version 0.0.0
	 * @created 01.10.2012 16:29
	 */
	public class DrawingObjectRealPen extends DrawingObjectOneClick {
		
		//{ =*^_^*= CONSTRUCTOR
		function DrawingObjectRealPen (owner:WhiteboardMainPage) {
			super(owner);
		}
		//} =*^_^*= END OF CONSTRUCTOR
				
		//{ =*^_^*= interface for PenSocketHelper
		public function start(x0:Number, y0:Number, col:uint=0x00ff00, wid:Number=10):void
			{
			c=col;	w=wid;
			//x=x0; y=y0;
			commands.splice(1,commands.length-1);      // delete all but first MOVE_TO
			commands[0]=(GraphicsPathCommand.MOVE_TO);
			pointdata.splice(0,pointdata.length);      // delete all
			pointdata.push(x0, y0);  // starting point
			npoints=1;
			lastGap=0;
			}
		public function setThicknessColor(thickness:int=-1, color:int=-1):void
			{
			if(thickness!=-1)w=thickness;
			if(color!=-1)c=color;
			}	
		public function trim(n:int):void // kill points after n-th
			{
			pointdata.splice(n*2,(npoints-n)*2);
			commands.splice(n,npoints-n);
			npoints=n;   
			lastGap=0;
			uid=getUID();
			}	
		public function add(x:Number,y:Number):void // add point
			{
			npoints++;
			commands.push(GraphicsPathCommand.LINE_TO);
			pointdata.push(x,y);
			}
		public function addGap(x:Number,y:Number):void // add point
			{
			lastGap=npoints++;
			commands.push(GraphicsPathCommand.MOVE_TO);
			pointdata.push(x,y);
			}		
		//} =*^_^*= interface for PenSocketHelper
		
		
		public override function onMouseDown(x:uint, y:uint):void {
			super.onMouseDown(x,y);
			focusOut();// это нужно для того чтобы убрать свечение красным при выделении стеркой посмотри этот метод кстати, он завершает рисование если был включен режим рисования(переменная) 
			// JD: не подразумевалось что могут быть активны режим рисования и стерки. может быть только один. потому когда идут данные от ручки необходимо принудительно выключать режим стерки и включать режим рисования
		}
		
		protected override function project(displayMode:int=0):void {
			//здесь отрисовка линии из данных находящихся в полях(модели) этого класса. данные в полях в любом виде.
			
			displayObject.graphics.clear();
			displayObject.graphics.lineStyle(w, c);
			displayObject.graphics.drawPath(commands,Vector.<Number>(pointdata));
			
			//var l:int=xy.length-1;
			//for (var i:int=0; i<l; i+=2) {
				//displayObject.graphics.lineTo(xy[i], xy[i+1]);
			//}
			
			
			if (editMode||removeMode) {
				//здесь отрисовка более толстой прозрачной линии поверх существующей чтобы можно было ее выделить и удалить при удалении
				
				//displayObject.graphics.moveTo(x, y);
				//displayObject.graphics.lineStyle(selectedLineThickness, 0,0);
				//for (i=0; i<l; i+=2) {
					//displayObject.graphics.lineTo(xy[i], xy[i+1]);
				//}
			}
			
		}
//		public override function startDraw(startX:uint, startY:uint):void {
//			super.startDraw();//нужно для получения цвета итд
//			drawing=false;// чтоьбы при нажатии по доске рисование не закончилось автоматом
//			
//			// object just paced on wb page, visible
//			// объект помещен на доску, видимый, можн начать рисование.
//			//координаты любого объекта на доске - 0.0: x, y поля этого класса хранят координаты мышы в момент нажатия при рисовании. для реальной ручки они не нужны
//			//тест:
//			displayObject.graphics.clear();
//			displayObject.graphics.lineStyle(25, 0xff0000);
//			x=55;
//			y=66;
//			displayObject.graphics.moveTo(10, 10);
//			displayObject.graphics.lineTo(x+92, y+132);
//			
//		}
		
		//{ =*^_^*= model
		public override function deserialize(a:Object):Object {
			super.deserialize(a);
			npoints=a.np;
			pointdata=new Vector.<int>(npoints*2);
			commands=new Vector.<int>(npoints);
			bytes2vec(Base64.decodeToByteArray(a.pts),pointdata,commands);
			c=a.c;
    	   	w=a.w;
			drawing=true;project();drawing=false;
			return a;
		}
		public override function serialize(a:Object=null):Object {
			var a:Object=(a)?a:{};
			super.serialize(a);
			a.type=TYPE_NAME;
			a.np=npoints;
			a.w=w;
			a.c=c;
	       	a.pts=Base64.encodeByteArray(vec2bytes(pointdata,commands));
			//o.compressed=1;								// version of data format: 1 -- compressed ByteArray
			return a;
		}
		//} =*^_^*= END OF model
		
		/** packs commands and pointdata into ByteArray **/
		private function vec2bytes(v:Vector.<int>, cm:Vector.<int>):ByteArray
			{
			var b:ByteArray=new ByteArray();
			var i:int, j:int;
			for(i=j=0;i<cm.length;i++)
				{
				b.writeShort(v[j++] | ((cm[i]==GraphicsPathCommand.MOVE_TO)?MOVETO_MASK:0));
				b.writeShort(v[j++]);
				}
			b.compress();
			//LOG(1,"vec2bytes: l="+v.length+" compressed="+b.length);
			return b;
			}
		/** unpacks commands and pointdata into ByteArray **/
		private function bytes2vec(bb:ByteArray, v:Vector.<int>, cm:Vector.<int>):void
			{
			var b:ByteArray=new ByteArray;
			bb.position=0;
			bb.readBytes(b);
			b.position=0;
//			//status("bytes2vec: l_compressed="+b.length);
			b.uncompress();
			var x:int, y:int, i:int, j:int;
			for(i=j=0; i<npoints; i++)
				{
				x=b.readShort();
				y=b.readShort();
				cm[i]=((x&MOVETO_MASK) || !i) ? GraphicsPathCommand.MOVE_TO : GraphicsPathCommand.LINE_TO;
				v[j++]=x&XY_MASK;
				v[j++]=y;
				}
			b=null;
			}

		public static const TYPE_NAME:String="realPen";
		
		static public const MOVETO_MASK:int=0x4000;		// mark for gaps in line
		static public const XY_MASK:int=0xfff;			// range [0..4096]
		
		public var w:int=1;										// width
		public var c:int=0;										// color
		public var commands:Vector.<int>=new Vector.<int>();
		public var pointdata:Vector.<int>=new Vector.<int>();
		public var npoints:int=0;
		public var lastGap:int=0;
//		public var bytes:ByteArray;
		
		
	}
}

//{ =*^_^*= History
/* > (timestamp) [ ("+" (added) ) || ("-" (removed) ) || ("*" (modified) )] (text)
 * > 
 */
//} =*^_^*= END OF History

// template last modified:11.03.2011_[18#51#40]_[5]