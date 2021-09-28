package ttcc {
	
	//{ =*^_^*= import
	import flash.utils.Dictionary;
	//} =*^_^*= END OF import
	
	/**
	 * Object pool
	 */
	public class OP {
		/**
		 * recomended by JDItself:
		 * construct(...):void;
		 * destruct(...):void;
		 */
		
		 
		/**
		 * getInstance
		 */
		public static function g(c:Class):* {
			var i:*=pool[c];
			if (!i) {i=new c();}
			
			var cd:Dictionary=poolNext[c];
			if (!cd) {
				cd=new Dictionary();
				poolNext[c]=cd;
			}
			
			pool[c]=cd[i];
			cd[i]=null;
			
			return i;
		}
		
		/**
		 * returnInstance
		 */
		public static function r(c:Class, i:*):void {
			var cd:Dictionary=poolNext[c];
			if (!cd) {
				cd=new Dictionary();
				poolNext[c]=cd;
			}
			cd[i]=pool[c];
			pool[c]=i;
		}
		
		/**
		 * d[classname]d[instance]=*
		 */
		private static var pool:Dictionary=new Dictionary();
		/**
		 * d[classname]=*
		 */
		private static var poolNext:Dictionary=new Dictionary();
		
	}
}

//{ =*^_^*= History
/* > (timestamp) [ ("+" (added) ) || ("-" (removed) ) || ("*" (modified) )] (text)
 * > 
 */
//} =*^_^*= END OF History

// template last modified:11.03.2011_[18#51#40]_[5]