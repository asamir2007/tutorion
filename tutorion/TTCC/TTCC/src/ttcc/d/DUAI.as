// Project Connect
package ttcc.d {
	
	//{ =*^_^*= import
	//} =*^_^*= END OF import
	
	
	/**
	 * DataUnitAccessInformation
	 * @author Jinanoimatey Dragoncat
	 * @version 0.0.0
	 * @created 23.05.2012 18:31
	 */
	public class DUAI {
		
		//{ =*^_^*= CONSTRUCTOR
		function DUAI():void {
		}
		public function construct(ownerID:String):void {
			oID=ownerID;
			at=[];
		}
		public function destruct():void {
			at.splice(0, at.length);
			at=null;
		}
		//} =*^_^*= END OF CONSTRUCTOR
		
		/**
		 * setPermissionInformation
		 * @param	i actionID
		 * @param	p permission
		 */
		public function sp(i:uint, p:uint):void {
			at[i]=p;
		}
		
		/**
		 * getPermissionInformation
		 * @param	i actionID
		 * @return p
		 */
		public function gp(i:uint):uint {
			return at[i];
		}
		
		
		//{ =*^_^*= id
		public static const ID_ACCESS_DISALLOW:uint=0;
		public static const ID_ACCESS_ALLOW:uint=1;
		public static const ID_ACCESS_DISALLOW_AND_LOG:uint=10;
		public static const ID_ACCESS_ALLOW_AND_LOG:uint=11;
		//} =*^_^*= END OF id
		
		
		//{ =*^_^*= private
		public function get_ownerID():String {return oID;}
		public function set_ownerID(a:String):void {oID = a;}
		/**
		 * access table: [action id]=allow/disallow
		 */
		private var at:Array;
		private var oID:String;
		//} =*^_^*= END OF private
		
	}
}

//{ =*^_^*= History
/* > (timestamp) [ ("+" (added) ) || ("-" (removed) ) || ("*" (modified) )] (text)
 * > 08.06.2012_15#02#38 * bug
 * > 
 */
//} =*^_^*= END OF History

// template last modified:11.03.2011_[18#51#40]_[5]