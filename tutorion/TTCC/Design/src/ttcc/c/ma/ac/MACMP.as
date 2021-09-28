// Project TTCC
package ttcc.c.ma.ac {
	
	//{ =*^_^*= import
	import ttcc.Application;
	import ttcc.c.ae.AEApp;
	import ttcc.c.ma.ac.MAPPComponent;
	import ttcc.c.ma.MMP;
	import ttcc.c.vcm.VCMMainPanel;
	import ttcc.cfg.AppCfg;
	import ttcc.d.a.ARO;
	import ttcc.d.a.DUAppComponentCfg;
	import ttcc.d.a.DUAppComponentsCfg;
	import ttcc.v.mp.VCMainPanel;
	//} =*^_^*= END OF import
	
	
	/**
	 * application component main panel
	 * @author Jinanoimatey Dragoncat
	 * @version 0.0.0
	 * @created 21.06.2012 1:32
	 */
	public class MACMP extends MAPPComponent {
		
		//{ =*^_^*= CONSTRUCTOR
		
		function MACMP (app:Application) {
			super(NAME, COMPONENT_ID, 90000);
			a=app;
		}
		//} =*^_^*= END OF CONSTRUCTOR
		
		public override function listen(eventType:String, details:Object):void {
			super.listen(eventType, details);
			switch (eventType) {
				
			case ID_A_ADD_BUTTON:
				e.listen(VCMMainPanel.ID_A_ADD_BUTTON, details);
				break;
				
			}
		}
		
		protected override function checkCFG(cfg:DUAppComponentCfg):void {
			super.checkCFG(cfg);
			cfg.setBoolean(ID_AC_CFG_P_MPBUTTON_PRESENT, false);
		}
		
		protected override function applyCFG(cfg:DUAppComponentCfg):void {
			super.applyCFG(cfg);
		}
		
		protected override function prepareBeforeStartup():void {
			super.prepareBeforeStartup();
			//prepare view
			var mp:VCMainPanel=new VCMainPanel;
			a.get_mainScreen().set_mainPanel(mp);
			
			e.placeAgent(new VCMMainPanel());
			e.listen(VCMMainPanel.ID_A_REGISTER_SINGLETON_VC, mp);
			
			e.placeAgent(new MMP(a));
		}
		
		protected override function runComponent():void {
			super.runComponent();
			e.listen(MMP.ID_A_RUN, null);
			e.listen(getServiceActionName(S_ID_E_COMPONENT_IS_READY), null);
		}
		
		
		//{ =*^_^*= private 
		private var componentStartedUp:Boolean;
		//} =*^_^*= END OF private
		
		private function get e():AEApp {return get_envRef();}
		private var a:Application;		
		
		//{ =*^_^*= id
		/**
		 * data:DUMPButton
		 */
		public static const ID_A_ADD_BUTTON:String = NAME + '>ID_A_ADD_BUTTON';
		//} =*^_^*= END OF id
		
		//{ =*^_^*= events
		//public static const :String=NAME+;
		//} =*^_^*= END OF events
		
		//{ =*^_^*= =*^_^*= component cfg properties list
		public static const COMPONENT_ID:String = 'taskbar';
		//} =*^_^*= =*^_^*= END OF component cfg properties list
		
		public static const NAME:String = 'MACMP';
		
		public override function autoSubscribeEvents():Array {
			var events:Array=super.autoSubscribeEvents();if (!events) {events=[];}
			return events.concat(
				ID_A_ADD_BUTTON
			);
		}
		
	}
}

//{ =*^_^*= History
/* > (timestamp) [ ("+" (added) ) || ("-" (removed) ) || ("*" (modified) )] (text)
 * > 
 */
//} =*^_^*= END OF History

// template last modified:11.03.2011_[18#51#40]_[5]