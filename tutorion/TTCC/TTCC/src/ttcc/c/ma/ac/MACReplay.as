// Project TTCC
package ttcc.c.ma.ac {
	
	//{ =*^_^*= import
	import ttcc.APP;
	import ttcc.Application;
	import ttcc.c.ae.AEApp;
	import ttcc.c.ae.DE;
	import ttcc.c.ma.ac.MAPPComponent;
	import ttcc.c.ma.MReplay;
	import ttcc.c.vcm.d.DUMPButton;
	import ttcc.c.ma.ac.MACMP;
	import ttcc.c.vcm.VCMReplay;
	import ttcc.cfg.AppCfg;
	import ttcc.d.a.ARO;
	import ttcc.d.a.DUAppComponentCfg;
	import ttcc.media.PictureStoreroom;
	import ttcc.media.Text;
	import ttcc.v.r.VCReplayManager;
	//} =*^_^*= END OF import
	
	
	/**
	 * application component
	 * @author Jinanoimatey Dragoncat
	 * @version 0.0.0
	 * @created 05.08.2012 17:47
	 */
	public class MACReplay extends MAPPComponent {
		
		//{ =*^_^*= CONSTRUCTOR
		
		function MACReplay (app:Application) {
			super(NAME, COMPONENT_ID, 100000, [MACMP.COMPONENT_ID]);
			a=app;
		}
		//} =*^_^*= END OF CONSTRUCTOR
		
		
		public override function listen(eventType:String, details:Object):void {
			super.listen(eventType, details);
			switch (eventType) {
			
			}
		}
		
		protected override function runComponent():void {
			super.runComponent();
			e.listen(getServiceActionName(S_ID_E_COMPONENT_IS_READY), null);
		}
		
		protected override function checkCFG(cfg:DUAppComponentCfg):void {
			super.checkCFG(cfg);
			cfg.setBoolean(ID_AC_CFG_P_MPBUTTON_PRESENT, true);
			cfg.setBoolean(ID_AC_CFG_P_WINDOW_PRESENT, true);
		}
		
		protected override function applyCFG(cfg:DUAppComponentCfg):void {
			super.applyCFG(cfg);
		}
		
		protected override function prepareBeforeStartup():void {
			super.prepareBeforeStartup();
			//prepare agents
 			var mr:MReplay = new MReplay(a, a.get_ds().get_replayMode());
			de.placeAgent(mr);e.placeAgent(mr);
			mr.subscribeForDE();
			
			e.placeAgent(new VCMReplay());
			//prepare view
			var pl:VCReplayManager=new VCReplayManager;
			pl.set_de(a.get_de());
			pl.setResources(
				APP.lText().get_TEXT(Text.ID_TEXT_REPLAY_MANAGER_WINDOW_TITLE)
				,APP.lText().get_TEXT(Text.ID_TEXT_REPLAY_MANAGER_B_RECORD)
				,APP.lText().get_TEXT(Text.ID_TEXT_REPLAY_MANAGER_B_STOP)
				,APP.lText().get_TEXT(Text.ID_TEXT_REPLAY_MANAGER_B_PLAY)
				,PictureStoreroom.getPicture('replay_h')
			);
			a.get_mainScreen().set_rm(pl);
			e.listen(VCMReplay.ID_A_REGISTER_SINGLETON_VC, pl);
			e.listen(MReplay.ID_A_RUN, null);
		}
		
		protected override function window__setXYWH(x:Number, y:Number, w:Number, h:Number):void {
			super.window__setXYWH(x,y,w,h);
			e.listen(VCMReplay.ID_A_SET_WINDOW_XYWH, [x,y,w,h]);
		}
		
		protected override function window__setInitialVisibility(a:Boolean):void {
			super.window__setInitialVisibility(a);
			e.listen(VCMReplay.ID_A_SET_VISIBILITY, a);
		}
		
		protected override function displayMPButton():void {
			super.displayMPButton();
			e.listen(MACMP.ID_A_ADD_BUTTON, new DUMPButton(
				COMPONENT_ID
				,54000
				,"replay_w"
				,"replay_w"
				,"replay_w"
			));
		}
		
		//{ =*^_^*= private 
		private var componentStartedUp:Boolean;
		//} =*^_^*= END OF private
		
		private function get e():AEApp {return get_envRef();}
		private function get de():DE {return a.get_de();}
		private var a:Application;		
		
		//{ =*^_^*= id
		//} =*^_^*= END OF id
		
		//{ =*^_^*= =*^_^*= component cfg properties list
		public static const COMPONENT_ID:String = 'replay_manager';
		//} =*^_^*= =*^_^*= END OF component cfg properties list
		
		public static const ID_AC_CFG_P_RECORD_MODE:String='record_mode';
		
		
		//{ =*^_^*= events
		//} =*^_^*= END OF events
		
		public static const NAME:String = 'MACReplay';
		
		
		public override function autoSubscribeEvents():Array {
			var events:Array=super.autoSubscribeEvents();if (!events) {events=[];}
			return events.concat([]
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