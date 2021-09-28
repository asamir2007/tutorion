// Project TTCC
package ttcc.d.m {
	
	//{ =*^_^*= import
	import ttcc.d.i.ISerializable;
	import ttcc.d.m.AbstractModel;
	import ttcc.LOG;
	//} =*^_^*= END OF import
	
	
	/**
	 * 
	 * @author Jinanoimatey Dragoncat
	 * @version 0.0.0
	 * @created 02.08.2012 5:16
	 */
	public class GUIWindowModel extends AbstractModel {
		
		//{ =*^_^*= CONSTRUCTOR
		function GUIWindowModel () {
		}
		public override function destruct():void {
			super.destruct();
		}
		//} =*^_^*= END OF CONSTRUCTOR
		
		//{ =*^_^*= write access
		public function set_xy(x:Number, y:Number, reflect:Boolean=true):void {
			this.x=x;this.y=y;
			// TODO: controll logging from config
			//LOG(0,'model write'+((reflect)?"&reflect":"")+'>'+get_id()+'>x,y:>'+[this.x,this.y],2);
			transfer(ID_P_XY);
			if (reflect) {this.reflect(ID_P_XY);}
		}
		
		public function set_wh(w:Number, h:Number, reflect:Boolean=true):void {
			this.w=w;this.h=h;
			// TODO: controll logging from config
			//LOG(0,'model write'+((reflect)?"&reflect":"")+'>'+get_id()+'>w,h:>'+[this.w,this.h],2);
			transfer(ID_P_WH);
			if (reflect) {this.reflect(ID_P_WH);}
		}
		
		public function set_xywh(x:Number, y:Number, w:Number, h:Number, reflect:Boolean=true):void {
			set_xy(x,y,reflect);
			set_wh(w,h,reflect);
		}
		
		public function set_visible(a:Boolean, reflect:Boolean=true):void {
			v=a;transfer(ID_P_V);if (reflect) {this.reflect(ID_P_V);}
		}
		public function set_activated(a:Boolean, reflect:Boolean=true):void {
			this.a=a;transfer(ID_P_A);if (reflect) {this.reflect(ID_P_A);}
		}
			
		public function set_containerVisibility(elementID:uint, visibility:Boolean, reflect:Boolean=true):void {
			if ([ID_P_C_V_0, ID_P_C_V_1, ID_P_C_V_2, ID_P_C_V_3
			].indexOf(elementID)==-1) {throw new Error('not implemented');}
			
			cv[elementID]=visibility;
			transfer(elementID);if (reflect) {this.reflect(elementID);}
		}
			
		public function set_scrollerScrollValue(elementID:uint, value:Number, reflect:Boolean=true):void {
			if ([ID_P_SSV_0, ID_P_SSV_1, ID_P_SSV_2
			].indexOf(elementID)==-1) {throw new Error('not implemented');}
			ssp[elementID]=value;
			transfer(elementID);if (reflect) {this.reflect(elementID);}
		}
		//} =*^_^*= END OF write access
		
		
		//{ =*^_^*= read access
		public function get_x():Number {return x;}
		public function get_y():Number {return y;}
		public function get_w():Number {return w;}
		public function get_h():Number {return h;}
		public function get_visible():Boolean {return v;}
		public function get_activated():Boolean {return a;}
		/**
		 * @return {i:elementID, v:visibility}
		 */
		public function get_containerVisibility(elementID:uint):Boolean {return cv[elementID];}
		/**
		 * @return {i:elementID, v:value}
		 */
		public function get_scrollerScrollValue(elementID:uint):Number {
			if (ssp.length-1<elementID) {return 0;}
			return ssp[elementID];
		}
		//} =*^_^*= END OF read access
		
		//{ =*^_^*= model contens
		private var x:Number;
		private var y:Number;
		private var w:Number;
		private var h:Number;
		private var v:Boolean;
		private var a:Boolean;
		
		private var ssp:Array=[];
		private var cv:Array=[];
		//} =*^_^*= END OF model contens
		
		//{ =*^_^*= property id
		public static const ID_P_XY:uint=0;
		public static const ID_P_WH:uint=1;
		public static const ID_P_V:uint=2;
		public static const ID_P_A:uint=3;
		/**
		 * container visibility
		 */
		public static const ID_P_C_V_0:uint=400;
		/**
		 * container visibility
		 */
		public static const ID_P_C_V_1:uint=401;
		/**
		 * container visibility
		 */
		public static const ID_P_C_V_2:uint=402;
		/**
		 * container visibility
		 */
		public static const ID_P_C_V_3:uint=403;
		/**
		 * scroller scroll value
		 */
		public static const ID_P_SSV_0:uint=600;
		/**
		 * scroller scroll value
		 */
		public static const ID_P_SSV_1:uint=601;
		/**
		 * scroller scroll value
		 */
		public static const ID_P_SSV_2:uint=602;
		//} =*^_^*= END OF property id
		
		//{ =*^_^*= reflection
		protected override function resetModel(updateFromDataport:Boolean=false):void {
			a=false;x=0;y=0;w=0;h=0;ssp=[];cv=[];v=false;
			markForReflect(ID_P_WH);markForReflect(ID_P_XY);
			markForReflect(ID_P_V);markForReflect(ID_P_A);
			
			markForReflect(ID_P_SSV_0);markForReflect(ID_P_SSV_1);markForReflect(ID_P_SSV_2);
			markForReflect(ID_P_C_V_0);markForReflect(ID_P_C_V_1);
			markForReflect(ID_P_C_V_2);markForReflect(ID_P_C_V_3);
		}
		//} =*^_^*= END OF reflection
		
		//{ =*^_^*= working with data
		/**
		 * 
		 * @param	elementID
		 * @param	rawData
		 */
		protected override function deserializeAndStore(elementID:uint, rawData:Object):void {
			switch (elementID) {
			
			case ID_P_XY:x=parseInt(rawData.x);y=parseInt(rawData.y);break;
			case ID_P_WH:w=parseInt(rawData.w);h=parseInt(rawData.h);break;
			case ID_P_V:v=Boolean(parseInt(rawData));break;
			
			case ID_P_A:a=Boolean(parseInt(rawData));break;
			
			case ID_P_C_V_0:
			case ID_P_C_V_1:
			case ID_P_C_V_2:
			case ID_P_C_V_3:
				cv[elementID]=Boolean(parseInt(rawData));
			break;
			
			case ID_P_SSV_0:
			case ID_P_SSV_1:
			case ID_P_SSV_2:
				ssp[elementID]=parseInt(rawData)/1000000;
			break;
			
			}
		}
		/**
		 * override and place your code here
		 * @param	elementID
		 * @return rawData
		 */
		protected override function serialize(elementID:uint):Object {
			switch (elementID) {
			
			case ID_P_XY:return {x:x, y:y};break;
			case ID_P_WH:return {w:w, h:h};break;
			case ID_P_V:return int(v);break;
			
			case ID_P_A:return int(a);break;
			
			case ID_P_C_V_0:
			case ID_P_C_V_1:
			case ID_P_C_V_2:
			case ID_P_C_V_3:
				return int(cv[elementID]);break;
			
			case ID_P_SSV_0:
			case ID_P_SSV_1:
			case ID_P_SSV_2:return uint(ssp[elementID]*1000000);break;
			
			
			}
			return null;
		}
		//} =*^_^*= END OF working with data
		
	}
}

//{ =*^_^*= History
/* > (timestamp) [ ("+" (added) ) || ("-" (removed) ) || ("*" (modified) )] (text)
 * > 
 */
//} =*^_^*= END OF History

// template last modified:11.03.2011_[18#51#40]_[5]