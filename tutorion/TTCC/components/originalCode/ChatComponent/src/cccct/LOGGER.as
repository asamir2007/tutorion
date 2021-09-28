package cccct {
	
	//{ =*^_^*= import
	//} =*^_^*= END OF import
	
	
	/**
	 * 
	 * @author Jinanoimatey Dragoncat
	 * @version 0.0.0
	 * @created 25.01.2012 18:25
	 */
	public class LOGGER {
		
		/**
		* @param	m msg
		* @param	l level
		*/
		public static function log(m:String, i:uint=0):void {
			l(m, i);
		}
		
		/**
		 * function (m:String, i:uint)
		 */
		public static function setL(a:Function):void {l=a;}
		private static var l:Function;
		public static const LEVEL_INFO:uint = 0;
		public static const LEVEL_WARNING:uint = 1;
		public static const LEVEL_ERROR:uint = 2;
	}
}

//{ =*^_^*= History
/* > (timestamp) [ ("+" (added) ) || ("-" (removed) ) || ("*" (modified) )] (text)
 * > 
 */
//} =*^_^*= END OF History

// template last modified:11.03.2011_[18#51#40]_[5]