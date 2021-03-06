package org.jinanoimateydragoncat.utils.flow.agents {
	
	//{ =*^_^*= import
	//} =*^_^*= END OF import
	
	
	/**
	 * 
	 * @author Jinanoimatey Dragoncat
	 * @version 0.0.0
	 * @created 09.06.2011 2:38
	 */
	public interface AbstractAgent {
		
		function listen(eventType:String, details:Object):void;
		function get_envRef():AbstractAgent;
		function isAlive():Boolean;
		function setAlive(a:Boolean):void;
		
	}
}

//{ =*^_^*= History
/* > (timestamp) [ ("+" (added) ) || ("-" (removed) ) || ("*" (modified) )] (text)
 * > 09.06.2011_02#57#57 + get_envRef():AbstractAgent {return envRef;}
 * > 
 */
//} =*^_^*= END OF History

// template last modified:11.03.2011_[18#51#40]_[5]