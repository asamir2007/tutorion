// Project TTCC
package ttcc.c.ma.mp {
	
	//{ =*^_^*= import
	import flash.events.Event;
	import ttcc.APP;
	import ttcc.Application;
	import ttcc.c.ae.AEApp;
	import ttcc.c.vcm.d.DUMPButton;
	import ttcc.c.vcm.d.DUMPElement;
	import ttcc.c.vcm.VCMMainPanel;
	import ttcc.LOG;
	import ttcc.LOGGER;
	import ttcc.media.Text;
	//} =*^_^*= END OF import
	
	
	/**
	 * main panel 
	 * @author Jinanoimatey Dragoncat
	 * @version 0.0.0
	 * @created 23.08.2012 0:06
	 */
	public class MMPUserList extends AM {
		
		//{ =*^_^*= CONSTRUCTOR
		
		function MMPUserList (app:Application) {
			super(NAME);
			a=app;
		}
		//} =*^_^*= END OF CONSTRUCTOR
		
		public override function listen(eventType:String, details:Object):void {
			//var r:ARO;
			
			switch (eventType) {
				
				case ID_A_RUN:
					// TODO: add user list
					break;
					
				
			}
		}
		
		
		
		private function get e():AEApp {return get_envRef();}
		private var a:Application;		
		
		//{ =*^_^*= id
		public static const ID_A_RUN:String=NAME+'>ID_A_RUN';
		//} =*^_^*= END OF id
		
		//{ =*^_^*= events
		//public static const ID_E_PLAYBACK_RESUME:String=NAME+'>ID_E_PLAYBACK_RESUME';
		//} =*^_^*= END OF events
		
		
		public static const NAME:String = 'MMPUserList';
		
		public override function autoSubscribeEvents():Array {
			return [
				ID_A_RUN
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