// Project MainPanelComponent
package org.jinanoimateydragoncat.works.tutorion.v {
	
	//{ =*^_^*= import
	import flash.display.DisplayObject;
	import org.aswing.AssetIcon;
	import org.aswing.JButton;
	import org.jinanoimateydragoncat.works.tutorion.v.VCMainPanelIPanelElement;
	//} =*^_^*= END OF import
	
	
	/**
	 * 
	 * @author Jinanoimatey Dragoncat
	 * @version 0.0.0
	 * @created 14.05.2012 21:56
	 */
	public class VCMainPanelButtonElement extends VCMainPanelBasePanelElement implements VCMainPanelIPanelElement {
		
		//{ =*^_^*= CONSTRUCTOR
		/**
		 * use construct method
		 */
		function VCMainPanelButtonElement () {
		}
		public function construct(icon:DisplayObject, text:String=null):void {
			com=new JButton(text, new AssetIcon(icon));
		}
		public function destruct():void {
		}
		//} =*^_^*= END OF CONSTRUCTOR
		
		
		private function v():JButton {return com;}
		
	}
}

//{ =*^_^*= History
/* > (timestamp) [ ("+" (added) ) || ("-" (removed) ) || ("*" (modified) )] (text)
 * > 
 */
//} =*^_^*= END OF History

// template last modified:11.03.2011_[18#51#40]_[5]