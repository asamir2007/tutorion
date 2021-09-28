// Project MainPanelComponent
package org.jinanoimateydragoncat.works.tutorion.v {
	
	//{ =*^_^*= import
	import flash.display.DisplayObject;
	import org.aswing.JPanel;
	import org.aswing.JTextField;
	import org.jinanoimateydragoncat.works.tutorion.v.VCMainPanelIPanelElement;
	//} =*^_^*= END OF import
	
	
	/**
	 * 
	 * @author Jinanoimatey Dragoncat
	 * @version 0.0.0
	 * @created 14.05.2012 21:56
	 */
	public class VCMainPanelClassroomInfoElement extends VCMainPanelBasePanelElement implements VCMainPanelIPanelElement {
		
		//{ =*^_^*= CONSTRUCTOR
		/**
		 * use construct method
		 */
		function VCMainPanelClassroomInfoElement () {
		}
		public function construct():void {
			prepareView();
		}
		public function destruct():void {
		}
		//} =*^_^*= END OF CONSTRUCTOR
		
		//{ =*^_^*= user interface
		public function setTextOutput(outputID:uint, text:String):void {
			switch (outputID) {
			
			case ID_OUT_TEXT_0:
				dt0.setHtmlText(text);
				break;
				
			case ID_OUT_TEXT_1:
				dt1.setHtmlText(text);
				break;
			
			}
		}
		
		//{ =*^_^*= ID
		/**
		 * "Class:" text 
		 */
		public static const ID_OUT_TEXT_0:uint=0;
		/**
		 * classroom name text
		 */
		public static const ID_OUT_TEXT_1:uint=1;
		//} =*^_^*= END OF ID
		
		//} =*^_^*= END OF user interface
		
		
		private function prepareView():void {
			com=new JPanel();
			dt0 = new JTextField();dt0.setEditable(false);dt0.mouseChildren=false;
			v().append(dt0);
			dt0.setWidth(dt0W);
			
			dt1 = new JTextField();dt1.setEditable(false);dt1.mouseChildren=false;
			v().append(dt1);
			dt1.setWidth(dt1W);
		}
		
		private function v():JPanel {return com;}
		
		
		private var dt0:JTextField;
		private var dt1:JTextField;
		
		/**
		 * @param	a "Class:" text TextArea.width
		 */
		public function set_dt0W(a:uint):void {dt0W = a;}
		/**
		 * 
		 * @param	a classroom name TextArea.width
		 */
		public function set_dt1W(a:uint):void {dt1W = a;}		
		
		private var dt0W:uint;
		private var dt1W:uint;
	}
}

//{ =*^_^*= History
/* > (timestamp) [ ("+" (added) ) || ("-" (removed) ) || ("*" (modified) )] (text)
 * > 
 */
//} =*^_^*= END OF History

// template last modified:11.03.2011_[18#51#40]_[5]