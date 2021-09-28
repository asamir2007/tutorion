// Project TTCC
package ttcc.c.op.d {
	
	//{ =*^_^*= import
	import ttcc.d.a.DUApp;
	import flash.net.registerClassAlias;
	import org.jinanoimateydragoncat.utils.flow.operations.Operation;
	import ttcc.Application;
	import ttcc.c.op.AO;
	//} =*^_^*= END OF import
	
	
	/**
	 * 
	 * @author Jinanoimatey Dragoncat
	 * @version 0.0.0
	 * @created 26.05.2012_02#54#22
	 */
	public class OPreapareData extends AO {
		
		//{ =*^_^*= CONSTRUCTOR
		
		function OPreapareData (onComplete:Function, applicationRef:Application) {
			super(null, NAME, onComplete);
			appRef=applicationRef;
		}
		//} =*^_^*= END OF CONSTRUCTOR
		
		protected override function start():void {
			appRef.set_ds(new DUApp());
			
			//registerClassAlias('', );
			
			end(AO.OPERATION_RESULT_CODE_SUCCESS);
		}
		
		private var appRef:Application;
		
		//{ =*^_^*= =*^_^*= ID
		//} =*^_^*= =*^_^*= END OF ID
		
		public static const NAME:String='OPreapareData';
		
	}
}

//{ =*^_^*= History
/* > (timestamp) [ ("+" (added) ) || ("-" (removed) ) || ("*" (modified) )] (text)
 * > 
 */
//} =*^_^*= END OF History

// template last modified:11.03.2011_[18#51#40]_[5]