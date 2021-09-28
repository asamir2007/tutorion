// Project TTCC
package ttcc.c.vcm.d {
	
	//{ =*^_^*= import
	//} =*^_^*= END OF import
	
	
	/**
	 * 
	 * @author Jinanoimatey Dragoncat
	 * @version 0.0.0
	 * @created 20.08.2012 10:37
	 */
	public interface IDUMPElement {
		
		/**
		 * @param	position -1 = any; 333333 = middle; 666666 = end;
		 */
		function get_position():int;
		function set_position(a:int):void;
		function get_id():String;
		function set_id(a:String):void;
		
		
	}
}

//{ =*^_^*= History
/* > (timestamp) [ ("+" (added) ) || ("-" (removed) ) || ("*" (modified) )] (text)
 * > 
 */
//} =*^_^*= END OF History

// template last modified:11.03.2011_[18#51#40]_[5]