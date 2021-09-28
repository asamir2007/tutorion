// Project Connect
package ttcc.n.loaders {
	
	//{ =*^_^*= import
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	//} =*^_^*= END OF import
	
	
	/**
	 * 
	 * @author Jinanoimatey Dragoncat
	 * @version 0.0.0
	 * @created 17.05.2012 1:09
	 */
	public class JURLLoader extends URLLoader {
		
		//{ =*^_^*= CONSTRUCTOR
		/**
		 * 
		 * @param	a request
		 */
		function JURLLoader (a:URLRequest=null) {
			r=a;
			super(a);
		}
		//} =*^_^*= END OF CONSTRUCTOR
		
		
		/**
		 * @param	a request
		 */
		public override function load(a:URLRequest):void {
			r=a;
			super.load(a);
		}
		
		/**
		 * request
		 */
		public function get_r():URLRequest {return r;}
		private var r:URLRequest;
		
	}
}

//{ =*^_^*= History
/* > (timestamp) [ ("+" (added) ) || ("-" (removed) ) || ("*" (modified) )] (text)
 * > 
 */
//} =*^_^*= END OF History

// template last modified:11.03.2011_[18#51#40]_[5]