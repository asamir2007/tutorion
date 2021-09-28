// Project TTCC
package ttcc.c.op.a {
	
	//{ =*^_^*= import
	import org.jinanoimateydragoncat.utils.flow.operations.Operation;
	import ttcc.Application;
	import ttcc.c.ma.MApp;
	import ttcc.c.ma.MAppStartup;
	import ttcc.c.op.AO;
	import ttcc.c.op.d.OPreapareData;
	import ttcc.c.op.v.OPreapareView;
	//} =*^_^*= END OF import
	
	
	/**
	 * 
	 * @author Jinanoimatey Dragoncat
	 * @version 0.0.0
	 * @created 26.05.2012_02#54#22
	 */
	public class OStartup extends AO {
		
		//{ =*^_^*= CONSTRUCTOR
		
		function OStartup (onComplete:Function, applicationRef:Application) {
			super(null, NAME, onComplete);
			appRef=applicationRef;
			start();
		}
		//} =*^_^*= END OF CONSTRUCTOR
		
		protected override function start():void {
			//0 
			operations.push(new OPrepareLogging(completed, appRef));
			//1
			operations.push(new OPreapareData(completed, appRef));
			//2
			operations.push(new OPreapareView(completed, appRef));
			//3
			operations.push(new OPrepareAgents(completed, appRef));
			completed(null);
		}
		
		private var operations:Vector.<Operation>=new Vector.<Operation>;
		
		private function completed(operation:Operation):Boolean {
			if (operations.length>0) {
				operations.shift().startOperation();
				return false;
			}
			
			appRef.get_ae().listen(MAppStartup.ID_A_STARTEDUP, null);
			end(OPERATION_RESULT_CODE_SUCCESS);
			return false;
		}
		
		private var appRef:Application;
		
		//{ =*^_^*= =*^_^*= ID
		/**
		 * data:
		 */
		public static const OPERATION_RESULT_CODE_SUCCESS:uint = 0;
		/**
		 * data:
		 */
		public static const OPERATION_RESULT_CODE_FAILURE:uint = 1;
		
		//} =*^_^*= =*^_^*= END OF ID
		
		public static const NAME:String='OStartup';
		
	}
}

//{ =*^_^*= History
/* > (timestamp) [ ("+" (added) ) || ("-" (removed) ) || ("*" (modified) )] (text)
 * > 
 */
//} =*^_^*= END OF History

// template last modified:11.03.2011_[18#51#40]_[5]