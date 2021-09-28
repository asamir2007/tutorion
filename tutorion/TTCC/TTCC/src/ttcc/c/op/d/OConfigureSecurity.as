// Project TTCC
package ttcc.c.op.d {
	
	//{ =*^_^*= import
	import flash.system.Security;
	import ttcc.c.op.AO;
	//} =*^_^*= END OF import
	
	
	/**
	 * 
	 * @author Jinanoimatey Dragoncat
	 * @version 0.0.0
	 * @created 26.05.2012_02#50#23
	 */
	public class OConfigureSecurity extends AO {
		
		//{ =*^_^*= CONSTRUCTOR
		
		function OConfigureSecurity (onComplete:Function) {
			super(null, NAME, onComplete);
		}
		//} =*^_^*= END OF CONSTRUCTOR
		
		protected override function start():void {
			for each(var i:String in [
				"vashrepetitor.org"
				,"tutorion.ru"
				,"tutorion.com"
				,"tutorion.fr"
				]) {
				Security.allowDomain(i);
			}
			
			end(AO.OPERATION_RESULT_CODE_SUCCESS);
		}
		
		private var appRef:Application;
		
		//{ =*^_^*= =*^_^*= ID
		//} =*^_^*= =*^_^*= END OF ID
		
		public static const NAME:String='OConfigureSecurity';
		
	}
}

//{ =*^_^*= History
/* > (timestamp) [ ("+" (added) ) || ("-" (removed) ) || ("*" (modified) )] (text)
 * > 
 */
//} =*^_^*= END OF History

// template last modified:11.03.2011_[18#51#40]_[5]