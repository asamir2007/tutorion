// Project TTCC
package ttcc.c.ma.ac {
	
	//{ =*^_^*= import
	import ttcc.APP;
	import ttcc.Application;
	import ttcc.c.ae.AEApp;
	import ttcc.c.ma.ac.MAPPComponent;
	import ttcc.c.ma.MDocumentLoader;
	import ttcc.c.vcm.d.DUMPButton;
	import ttcc.c.ma.ac.MACMP;
	import ttcc.c.vcm.VCMPresentationLoader;
	import ttcc.cfg.AppCfg;
	import ttcc.d.a.ARO;
	import ttcc.d.a.DUAppComponentCfg;
	import ttcc.media.PictureStoreroom;
	import ttcc.media.Text;
	import ttcc.v.pl.VCPresentationLoader;
	//} =*^_^*= END OF import
	
	
	/**
	 * application component
	 * @author Jinanoimatey Dragoncat
	 * @version 0.0.0
	 * @created 29.06.2012 6:58
	 */
	public class MACPresentationLoader extends MAPPComponent {
		
		//{ =*^_^*= CONSTRUCTOR
		
		function MACPresentationLoader (app:Application) {
			super(NAME, COMPONENT_ID, 104000, [MACMP.COMPONENT_ID]);
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
			e.listen(MDocumentLoader.ID_A_RUN, null);
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
			e.placeAgent(new MDocumentLoader(a));
			e.placeAgent(new VCMPresentationLoader());
			//prepare view
			var pl:VCPresentationLoader=new VCPresentationLoader;
			pl.set_de(a.get_de());
			pl.setResources(
				APP.lText().get_TEXT(Text.ID_TEXT_PRESENTATION_LOADER_WINDOW_TITLE)
				,APP.lText().get_TEXT(Text.ID_TEXT_PRESENTATION_LOADER_B_APPLY)
				,APP.lText().get_TEXT(Text.ID_TEXT_PRESENTATION_LOADER_B_LOAD)
				,PictureStoreroom.getPicture('pres_h')
			);
			pl.construct();
			a.get_mainScreen().set_pl(pl);
			e.listen(VCMPresentationLoader.ID_A_REGISTER_SINGLETON_VC, a.get_mainScreen().get_pl());
		}
		
		protected override function window__setXYWH(x:Number, y:Number, w:Number, h:Number):void {
			super.window__setXYWH(x,y,w,h);
			e.listen(VCMPresentationLoader.ID_A_SET_WINDOW_XYWH, [x,y,w,h]);
		}
		
		protected override function window__setInitialVisibility(a:Boolean):void {
			super.window__setInitialVisibility(a);
			e.listen(VCMPresentationLoader.ID_A_SET_VISIBILITY, a);
		}
		
		protected override function displayMPButton():void {
			super.displayMPButton();
			e.listen(MACMP.ID_A_ADD_BUTTON, new DUMPButton(
				COMPONENT_ID
				,52000
				,"presentation_w"
				,"presentation_w"
				,"presentation_w"
			));
		}
		
		//{ =*^_^*= private 
		private var componentStartedUp:Boolean;
		//} =*^_^*= END OF private
		
		private function get e():AEApp {return get_envRef();}
		private var a:Application;		
		
		//{ =*^_^*= id
		//} =*^_^*= END OF id
		
		//{ =*^_^*= =*^_^*= component cfg properties list
		public static const COMPONENT_ID:String = 'presentation_loader';
		//} =*^_^*= =*^_^*= END OF component cfg properties list
		
		
		//{ =*^_^*= events
		//} =*^_^*= END OF events
		
		public static const NAME:String = 'MACPresentationLoader';
		
		
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