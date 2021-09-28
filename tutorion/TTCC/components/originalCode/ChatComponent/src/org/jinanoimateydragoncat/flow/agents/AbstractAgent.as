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
		
		public function autoSubscribeEvents():Array {
			// override and place your code here
		}
		//} =*^_^*= END OF input
		
		internal final function placed(env:AbstractAgentEnvironment):void {
			envRef = env;
			if (enableAfterPlacement) {alive = true;}
		}
		
		public function get_envRef():AbstractAgent {return envRef;}
		
		public function isAlive():Boolean {return alive;}
		public function setAlive(a:Boolean):void {alive=a;}
		
		protected var alive:Boolean;
		protected var enableAfterPlacement:Boolean;
		private var envRef:AbstractAgent;
		/**
		 * agent name
		 */
		public function get_name():String {return name;}
		private var name:String;
		
		protected function tr(...args):void {
			if (!traceEnabled) {return;}
			args.unshift('Agent:'+name+">");
			trace.apply(null, args);
		}
		protected var traceEnabled:Boolean=true;
		
	}
}

//{ =*^_^*= History
/* > (timestamp) [ ("+" (added) ) || ("-" (removed) ) || ("*" (modified) )] (text)
 * > 
 */
//} =*^_^*= END OF History

// template last modified:11.03.2011_[18#51#40]_[5]