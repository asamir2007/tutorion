// Project TTCC
package ttcc.c.ae {
	
	//{ =*^_^*= import
	import ttcc.Application;
	//} =*^_^*= END OF import
	
	
	/**
	 * Abstract Agent Environment
	 * @author Jinanoimatey Dragoncat
	 * @version 0.0.0
	 * @created 05.08.2012 8:26
	 */
	public class DE extends AE {
		
		//{ =*^_^*= CONSTRUCTOR
		
		function DE () {
			super(NAME);
		}
		//} =*^_^*= END OF CONSTRUCTOR
		
		/**
		 * AbstractModel
		 */
		public static const ID_A_REGISTER_MODEL:String=NAME+"ID_A_REGISTER_MODEL";
		
		public static const NAME:String ='DE';
		
	}
}

//{ =*^_^*= History
/* > (timestamp) [ ("+" (added) ) || ("-" (removed) ) || ("*" (modified) )] (text)
 * > 
 */
//} =*^_^*= END OF History

// template last modified:11.03.2011_[18#51#40]_[5]