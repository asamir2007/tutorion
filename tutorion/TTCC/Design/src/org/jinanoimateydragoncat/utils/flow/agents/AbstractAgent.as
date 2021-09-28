package org.jinanoimateydragoncat.utils.flow.agents {
	
	//{ =*^_^*= import
	import org.jinanoimateydragoncat.utils.flow.agents.AbstractAgentEnvironment;
	//} =*^_^*= END OF import
	
	public class AbstractAgent {
		
		//{ =*^_^*= CONSTRUCTOR
		
		function AbstractAgent (name:String) {
			this.name = name;
		}
		//} =*^_^*= END OF CONSTRUCTOR
		
		//{ =*^_^*= input 
		
		public function listen(eventType:String, details:Object):void {
			// override and place your code here
		}
		
		// TODO: envName for multi env agents
		// TODO: envName for multi env agents
		// TODO: envName for multi env agents
		// TODO: envName for multi env agents
		// TODO: envName for multi env agents
		// TODO: envName for multi env agents
		// TODO: envName for multi env agents
		// TODO: envName for multi env agents
		// TODO: envName for multi env agents
		// TODO: envName for multi env agents
		// TODO: envName for multi env agents
		// TODO: envName for multi env agents
		// TODO: envName for multi env agents
		// TODO: envName for multi env agents
		// TODO: envName for multi env agents
		// TODO: envName for multi env agents
		// TODO: envName for multi env agents
		// TODO: envName for multi env agents
		//public function autoSubscribeEvents(envName:String):Array {
		public function autoSubscribeEvents():Array {
			// override and place your code here
			return [];
		}
		//} =*^_^*= END OF input
		
		internal final function placed(env:AbstractAgentEnvironment):void {
			envRef = env;
			if (enableAfterPlacement) {alive = true;}
		}
		
		public function get_envRef():AbstractAgentEnvironment {return envRef;}
		
		public function isAlive():Boolean {return alive;}
		public function setAlive(a:Boolean):void {alive=a;}
		
		protected var alive:Boolean;
		protected var enableAfterPlacement:Boolean=true;
		private var envRef:AbstractAgentEnvironment;
		/**
		 * agent name
		 */
		public function get_name():String {return name;}
		private var name:String;
	}
}

//{ =*^_^*= History
/* > (timestamp) [ ("+" (added) ) || ("-" (removed) ) || ("*" (modified) )] (text)
 * > 31.08.2012 0:51 * get_envRef():AbstractAgent-->AbstractAgentEnvironment
 * > 
 */
//} =*^_^*= END OF History

// template last modified:11.03.2011_[18#51#40]_[5]