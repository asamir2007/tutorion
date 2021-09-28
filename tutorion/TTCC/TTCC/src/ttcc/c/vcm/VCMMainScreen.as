// Project TTCC
package ttcc.c.vcm {
	
	//{ =*^_^*= import
	import flash.display.DisplayObject;
	import ttcc.v.VCMainScreen;
	//} =*^_^*= END OF import
	
	/**
	 * display manager - controlls main interface
	 * @author Jinanoimatey Dragoncat
	 * @version 0.0.0
	 * @created 26.05.2012_02#54#22
	 */
	public class VCMMainScreen extends AVCM {
		
		//{ =*^_^*= CONSTRUCTOR
		
		function VCMMainScreen () {
			super(NAME);
		}
		//} =*^_^*= END OF CONSTRUCTOR
		
		
		public override function listen(eventType:String, details:Object):void {
			switch (eventType) {
			
			case ID_A_REGISTER_SINGLETON_VC:
				vc=details;
				configureVC();
				break;
			case ID_A_POSITION_COMPONENTS:
				vc.positionComponents();
				break;
			case ID_A_SET_MAIN_SCREEN_VISIBILITY:
				vc.get_displayObject().visible = details;
				break;
				
			}
		}
		
		private function setVisibility(target:DisplayObject, a:Boolean):void {
			if (!target) {return;}target.visible = a;
		}
		
		private function configureVC():void {
			vc.positionComponents();
		}
		
		
		//{ =*^_^*= private 
		private var vc:VCMainScreen;
		//} =*^_^*= END OF private
		
		
		//{ =*^_^*= id
		/**
		 * data:VCMainScreen
		 */
		public static const ID_A_REGISTER_SINGLETON_VC:String = NAME + '>ID_A_REGISTER_SINGLETON_VC';
		/**
		 * data:Boolean
		 */
		public static const ID_A_SET_MAIN_SCREEN_VISIBILITY:String=NAME+'>ID_A_SET_MAIN_SCREEN_VISIBILITY';
		public static const ID_A_POSITION_COMPONENTS:String=NAME+'>ID_A_POSITION_COMPONENTS';
		//} =*^_^*= END OF id
		
		public override function autoSubscribeEvents():Array {
			return [
				ID_A_REGISTER_SINGLETON_VC
				,ID_A_SET_MAIN_SCREEN_VISIBILITY
				,ID_A_POSITION_COMPONENTS
			];
		}
		
		public static const NAME:String = 'VCMMainScreen';
	}
}

//{ =*^_^*= History
/* > (timestamp) [ ("+" (added) ) || ("-" (removed) ) || ("*" (modified) )] (text)
 * > 
 */
//} =*^_^*= END OF History

// template last modified:11.03.2011_[18#51#40]_[5]