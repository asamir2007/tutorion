// Project MainPanelComponent
package ttcc.v.mp {
	
	//{ =*^_^*= import
	import flash.display.DisplayObject;
	import flash.text.TextFormat;
	import org.aswing.ASColor;
	import org.aswing.ASFont;
	import org.aswing.JPanel;
	import org.aswing.JTextField;
	import ttcc.v.mp.VCMainPanelIPanelElement;
	//} =*^_^*= END OF import
	
	
	/**
	 * 
	 * @author Jinanoimatey Dragoncat
	 * @version 0.0.0
	 * @created 23.08.2012 0:19
	 */
	public class VCMainPanelUsersOnlineElement extends VCMainPanelBasePanelElement implements VCMainPanelIPanelElement {
		
		//{ =*^_^*= CONSTRUCTOR
		/**
		 * use construct method
		 */
		function VCMainPanelUsersOnlineElement () {
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
				
			}
		}
		
		//{ =*^_^*= ID
		public static const ID_OUT_TEXT_0:uint=0;
		//} =*^_^*= END OF ID
		
		//} =*^_^*= END OF user interface
		
		
		private function prepareView():void {
			com=new JPanel();
			
			dt0 = new JTextField();dt0.setEditable(false);dt0.mouseChildren=false;
			dt0.setFont(new ASFont('Verdana', 15));
			var dtf:TextFormat=new TextFormat('Verdana', 15, 0x000000);
			dt0.setDefaultTextFormat(dtf);
			//dt0.setForeground(new ASColor(0xeeeeee,1));
			//dt0.setBackground(new ASColor(0x999999,1));
			//dt0.setOpaqque(true);
			dt0.setWidth(dt0W);
			com.append(dt0);
			
			com.setMaximumWidth(dt0W);
			com.setWidth(dt0W);
		}
		
		private function v():JPanel {return com;}
		
		
		private var dt0:JTextField;
		
		/**
		 * @param	a "online:" text TextArea.width
		 */
		public function set_dt0W(a:uint):void {dt0W = a;}
		
		private var dt0W:uint;
	}
}

//{ =*^_^*= History
/* > (timestamp) [ ("+" (added) ) || ("-" (removed) ) || ("*" (modified) )] (text)
 * > 
 */
//} =*^_^*= END OF History

// template last modified:11.03.2011_[18#51#40]_[5]