// Project MainPanelComponent
package ttcc.v.mp {
	
	//{ =*^_^*= import
	import flash.display.DisplayObject;
	import flash.events.Event;
	import org.aswing.ASColor;
	import org.aswing.AssetIcon;
	import org.aswing.Component;
	import org.aswing.JButton;
	import org.aswing.SolidBackground;
	import ttcc.v.mp.VCMainPanelIPanelElement;
	import ttcc.v.Lib;
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
		
		/**
		 * 
		 * @param	id
		 * @param	el (target:VCMainPanelButtonElement, eventType:String, details:Object):void
		 * @param	icon
		 * @param	text
		 */
		public function construct(id:String, el:Function, icons:Array, textHint:String=''):void {
			this.el=el;
			this.id=id;
			
			com=Lib.createIconifiedButton(id, el_b, '', icons);
		}
		public function destruct():void {
		}
		//} =*^_^*= END OF CONSTRUCTOR
		public function setToolTipText(a:String):void {
			v().setToolTipText(a);
		}
		
		public function setIcons(icons:Array):void {
			Lib.modifyIconifiedButton(com,icons);
		}
		
		//{ =*^_^*= actions
		public static const ID_A_PRESS:String='ID_A_PRESS';
		//} =*^_^*= END OF actions
		
		private function el_b(e:Event):void {
			de(ID_A_PRESS, null);
		}
		
		private function v():JButton {return com;}
		
	}
}

//{ =*^_^*= History
/* > (timestamp) [ ("+" (added) ) || ("-" (removed) ) || ("*" (modified) )] (text)
 * > 
 */
//} =*^_^*= END OF History

// template last modified:11.03.2011_[18#51#40]_[5]