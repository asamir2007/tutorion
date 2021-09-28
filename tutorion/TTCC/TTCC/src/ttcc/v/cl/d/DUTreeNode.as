// Project CourseLoaderComponent
package ttcc.v.cl.d {
	
	//{ =*^_^*= import
	//} =*^_^*= END OF import
	
	
	/**
	 * 
	 * @author Jinanoimatey Dragoncat
	 * @version 0.0.0
	 * @created 12.05.2012 19:18
	 */
	public class DUTreeNode {
		
		//{ =*^_^*= CONSTRUCTOR
		function DUTreeNode (id:uint, name:String) {
			this.id=id;
			this.name=name;
		}
		//} =*^_^*= END OF CONSTRUCTOR
		
		public function get_id():uint {return id;}
		public function set_id(a:uint):void {id = a;}
		public function get_name():String {return name;}
		public function set_name(a:String):void {name = a;}
		public function get_content():Vector.<DUTreeNode> {return content;}
		public function addContent(a:DUTreeNode):DUTreeNode {
			if (!content) {content = new Vector.<DUTreeNode>;}
			content.push(a);
			return a;
		}

		private var id:uint;
		private var name:String;
		private var content:Vector.<DUTreeNode>;
		
	}
}

//{ =*^_^*= History
/* > (timestamp) [ ("+" (added) ) || ("-" (removed) ) || ("*" (modified) )] (text)
 * > 
 */
//} =*^_^*= END OF History

// template last modified:11.03.2011_[18#51#40]_[5]