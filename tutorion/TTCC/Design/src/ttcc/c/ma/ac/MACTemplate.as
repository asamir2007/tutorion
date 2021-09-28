// Project TTCC
package ttcc.c.ma.ac {
	
	//{ =*^_^*= import
	import ttcc.Application;
	import ttcc.c.ae.AEApp;
	import ttcc.c.ma.ac.MAPPComponent;
	import ttcc.c.vcm.d.DUMPButton;
	import ttcc.c.ma.ac.MACMP;
	import ttcc.cfg.AppCfg;
	import ttcc.d.a.ARO;
	import ttcc.d.a.DUAppComponentCfg;
	//} =*^_^*= END OF import
	
	
	/**
	 * application component
	 * @author Jinanoimatey Dragoncat
	 * @version 0.0.0
	 * @created 28.06.2012 13:42
	 */
	public class MACTemplate extends MAPPComponent {
		
		//{ =*^_^*= CONSTRUCTOR
		
		function MACTemplate (app:Application) {
			super(NAME, COMPONENT_ID, [], []);
			a=app;
		}
		//} =*^_^*= END OF CONSTRUCTOR
		
		
		public override function listen(eventType:String, details:Object):void {
			super.listen(eventType, details);
			switch (eventType) {
			
			case ID_A_CHECK_CFG:
				checkCFG(details);
				break;
				
			case ID_A_APPLY_CFG:
				applyCFG(details);
				break;
				
			case ID_A_RUN_COMPONENT:
				runComponent();
				break;
				
			//case MChat.ID_E_CONNECTED:
				//componentStartedUp=true;
				// tell about
				//e.listen(ID_E_COMPONENT_IS_READY, null);
				//break;
				
			//case MChat.ID_E_CONNECTION_ERROR:
				// tell about
				//if (componentStartedUp) {
					//e.listen(ID_E_OPERATION_ERROR, null);
				//} else {
					//e.listen(ID_E_FAILED_TO_RUN_COMPONENT, null);
				//}
				//break;
				
			}
		}
		
		protected override function runComponent():void {
			super.runComponent();
			// NOTE: place your code here
		}
		
		protected override function checkCFG(cfg:DUAppComponentCfg):void {
			super.checkCFG(cfg);
			//cfg.setBoolean(ID_AC_CFG_P_MPBUTTON_PRESENT, true);
		}
		
		protected override function applyCFG(cfg:DUAppComponentCfg):void {
			super.applyCFG(cfg);
			// prepare window
			//e.listen(VCMChat.ID_A_SET_WINDOW_XYWH, 
				//[
					//cfg.getNumber(ID_AC_CFG_P_W_X)
					//,cfg.getNumber(ID_AC_CFG_P_W_Y)
					//,cfg.getNumber(ID_AC_CFG_P_W_W)
					//,cfg.getNumber(ID_AC_CFG_P_W_H)
				//]);
			//e.listen(VCMChat.ID_A_SET_VISIBILITY, cfg.getBoolean(ID_AC_CFG_P_W_V));
		}
		
		protected override function displayMPButton():void {
			super.displayMPButton();
			e.listen(MACMP.ID_A_ADD_BUTTON, new DUMPButton(
				COMPONENT_ID
				,-1
				,"default button icon"
				,"default button icon"
				,"default button icon"
			));
		}
		
		//{ =*^_^*= private 
		private var componentStartedUp:Boolean;
		//} =*^_^*= END OF private
		
		private function get e():AEApp {return get_envRef();}
		private var a:Application;		
		
		//{ =*^_^*= id
		/**
		 * fill component cfg with default values if needed so
		 * data:DUAppComponentCfg
		 */
		public static const ID_A_CHECK_CFG:String=NAME+'>ID_A_CHECK_CFG';
		/**
		 * store and apply cfg
		 * data:DUAppComponentCfg
		 */
		public static const ID_A_APPLY_CFG:String=NAME+'>ID_A_APPLY_CFG';
		/**
		 * run
		 * data:
		 */
		public static const ID_A_RUN_COMPONENT:String=NAME+'>ID_A_RUN_COMPONENT';
		//} =*^_^*= END OF id
		
		//{ =*^_^*= =*^_^*= component cfg properties list
		public static const ID_AC_CFG_P_W_X:String='x';
		public static const ID_AC_CFG_P_W_Y:String='y';
		public static const ID_AC_CFG_P_W_W:String='l';
		public static const ID_AC_CFG_P_W_H:String='h';
		public static const ID_AC_CFG_P_W_V:String='show';
		
		public static const COMPONENT_ID:String = 'place component id here';
		//} =*^_^*= =*^_^*= END OF component cfg properties list
		
		
		//{ =*^_^*= events
		public static const ID_E_COMPONENT_IS_READY:String=NAME+'>ID_E_COMPONENT_IS_READY';
		public static const ID_E_OPERATION_ERROR:String=NAME+'>ID_E_OPERATION_ERROR';
		public static const ID_E_FAILED_TO_RUN_COMPONENT:String=NAME+'>ID_E_FAILED_TO_RUN_COMPONENT';
		//} =*^_^*= END OF events
		
		public static const NAME:String = 'MACTemplate';
		
		
		public override function autoSubscribeEvents():Array {
			return [
				ID_A_APPLY_CFG
				,ID_A_CHECK_CFG
				,ID_A_RUN_COMPONENT
			];
		}
		
	}
}

//{ =*^_^*= History
/* > (timestamp) [ ("+" (added) ) || ("-" (removed) ) || ("*" (modified) )] (text)
 * > 
 */
//} =*^_^*= END OF History

// template last modified:11.03.2011_[18#51#40]_[5]