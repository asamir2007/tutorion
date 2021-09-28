// Project TTCC
package ttcc.c.ma.ac {
	
	//{ =*^_^*= import
	//} =*^_^*= END OF import
	
	
	/**
	 * DU
	 * @author Jinanoimatey Dragoncat
	 * @version 0.0.0
	 * @created 29.06.2012 3:46
	 */
	public class MAPPComponentInfo {
		
		//{ =*^_^*= CONSTRUCTOR
		function MAPPComponentInfo (agentName:String, componentID:String, bootPriority:int=100000, dependenciesList:Array=null) {
			this.bootPriority=bootPriority;
			this.agentName=agentName;
			this.id=componentID;
			this.dependenciesList=(dependenciesList==null)?[]:dependenciesList;
		}
		public function construct():void {
		}
		public function destruct():void {
		}
		//} =*^_^*= END OF CONSTRUCTOR
		
				
		public function getID():String {return id;}
		private var id:String;
		
		public function getAgentName():String {return agentName;}
		private var agentName:String;
		
		/**
		 * 0-highest, 100000 - initial (first)
		 */
		public function getBootPriority():int {return bootPriority;}
		private var bootPriority:int;
		
		/**
		 * list of components ID, after which this component should be started
		 * this variable list is always non-null(array is empty if no entries present)
		 * @return [componentID, ...]
		 */
		public function getDependenciesList():Array {return dependenciesList;}
		private var dependenciesList:Array;

	}
}

//{ =*^_^*= History
/* > (timestamp) [ ("+" (added) ) || ("-" (removed) ) || ("*" (modified) )] (text)
 * > 
 */
//} =*^_^*= END OF History

// template last modified:11.03.2011_[18#51#40]_[5]