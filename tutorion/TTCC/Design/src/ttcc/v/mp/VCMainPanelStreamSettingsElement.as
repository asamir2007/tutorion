// Project MainPanelComponent
package ttcc.v.mp {
	
	//{ =*^_^*= import
	import flash.display.DisplayObject;
	import org.aswing.AssetPane;
	import org.aswing.BorderLayout;
	import org.aswing.JAdjuster;
	import org.aswing.JSlider;
	import org.aswing.SoftBoxLayout;
	import ttcc.media.PictureStoreroom;
	
	import org.aswing.ASColor;
	import org.aswing.JPanel;
	
	import ttcc.v.mp.VCMainPanelIPanelElement;
	//} =*^_^*= END OF import
	
	
	/**
	 * 
	 * @author Jinanoimatey Dragoncat
	 * @version 0.0.0
	 * @created 01.12.2012 2:58
	 */
	public class VCMainPanelStreamSettingsElement extends VCMainPanelBasePanelElement implements VCMainPanelIPanelElement {
		
		//{ =*^_^*= CONSTRUCTOR
		/**
		 * use construct method
		 */
		public function VCMainPanelStreamSettingsElement ():void {
			prepareView();
		}
		public function construct():void {
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
			com=new JPanel(new BorderLayout());
			
			var panel0:JPanel=new JPanel(new SoftBoxLayout(SoftBoxLayout.X_AXIS,0,SoftBoxLayout.LEFT));
			var ap:AssetPane=new AssetPane(PictureStoreroom.getPicture('voice_1'), AssetPane.SCALE_NONE);panel0.append(ap);
			
			var hSlider:JSlider = new JSlider(JSlider.HORIZONTAL);
			hSlider.setMaximum(100);hSlider.setMinimum(0);
			hSlider.setValue(20);
			hSlider.setToolTipText('громкость микрофона');
			ap.setToolTipText('громкость микрофона');
			
			
			var panel1:JPanel=new JPanel(new SoftBoxLayout(SoftBoxLayout.X_AXIS,0,SoftBoxLayout.LEFT));
			var ap0:AssetPane=new AssetPane(PictureStoreroom.getPicture('voice_0'), AssetPane.SCALE_NONE);panel1.append(ap0);
			
			var hSlider1:JSlider = new JSlider(JSlider.HORIZONTAL);
			hSlider1.setMaximum(100);hSlider1.setMinimum(0);
			hSlider1.setValue(65);
			hSlider1.setToolTipText('громкость входящего голоса');
			ap0.setToolTipText('громкость входящего голоса');
			
			
			panel0.append(hSlider, BorderLayout.NORTH);
			panel1.append(hSlider1, BorderLayout.SOUTH);
			
			com.append(panel0, BorderLayout.NORTH);
			com.append(panel1, BorderLayout.SOUTH);
			
			
			com.setMinimumWidth(100);
		}
		
		private function v():JPanel {return com;}
		
		
		
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