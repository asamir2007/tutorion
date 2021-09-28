// Project TTCC
package ttcc.v {
	
	//{ =^_^= import
	import org.aswing.CustomJFrame;
	import ttcc.c.ae.DE;
	import ttcc.d.m.GUIWindowModel;
	import ttcc.LOG;
	//} =^_^= END OF import
	
	
	/**
	 * abstract view component with window
	 * @author Jinanoimatey Dragoncat
	 * @version 0.0.0
	 * @created 29.06.2012 7:11
	 */
	public class AVCWW extends AVC {
		
		//{ =^_^= CONSTRUCTOR
		
		function AVCWW () {
			
		}
		//} =^_^= END OF CONSTRUCTOR
		
		public function set_de(a:DE):void {de = a;}
		private var de:DE;
		
		public function get_visible():Boolean {return vc.getModel().get_visible();}
		public function set_visible(a:Boolean):void {vc.getModel().set_visible(a);}
		
		public function setXY(x:Number, y:Number):void {vc.getModel().set_xy(x, y);}
		public function setWH(w:Number, h:Number):void {vc.getModel().set_wh(w,h);}
		
		public function getModel():GUIWindowModel {return vc.getModel();}
		
		
		protected function registerGUIWindowModel(m:GUIWindowModel):void {
			de.listen(DE.ID_A_REGISTER_MODEL, m);
		}
		
		protected var vc:CustomJFrame;
		
		
	}
}

//{ =^_^= History
/* > (timestamp) [ ("+" (added) ) || ("-" (removed) ) || ("*" (modified) )] (text)
 * > 
 */
//} =^_^= END OF History

// template last modified:15.01.2011_[00#08#13]_[6]