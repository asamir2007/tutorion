// Project TTCC
package ttcc.d.s {
	
	//{ =*^_^*= import
	//} =*^_^*= END OF import
	
	
	/**
	 * 
	 * @author Jinanoimatey Dragoncat
	 * @version 0.0.0
	 * @created 14.08.2012 4:23
	 */
	public class DUResource {
		
		//{ =*^_^*= CONSTRUCTOR
		function DUResource (filename:String, groupID:String, groupIsCritical:Boolean):void {
			this.filename = filename;
			this.groupID = groupID;
			this.groupIsCritical = groupIsCritical;
		}
		//} =*^_^*= END OF CONSTRUCTOR
		
		public function get_filename():String {return filename;}
		public function set_filename(a:String):void {filename = a;}
		public function get_groupID():String {return groupID;}
		public function set_groupID(a:String):void {groupID = a;}
		public function get_groupIsCritical():Boolean {return groupIsCritical;}
		public function set_groupIsCritical(a:Boolean):void {groupIsCritical = a;}
		public function get_loaded():Boolean {return loaded;}
		public function set_loaded(a:Boolean):void {loaded = a;}
		
		private var filename:String;
		private var groupID:String;
		private var groupIsCritical:Boolean;
		private var loaded:Boolean;
		
		public function toString():String {
			return "filename:"+filename+";groupID="+groupID+";groupIsCritical="+groupIsCritical;
		}
		
	}
}

//{ =*^_^*= History
/* > (timestamp) [ ("+" (added) ) || ("-" (removed) ) || ("*" (modified) )] (text)
 * > 
 */
//} =*^_^*= END OF History

// template last modified:11.03.2011_[18#51#40]_[5]