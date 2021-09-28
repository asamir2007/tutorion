// Project TTCC
package ttcc.c.ma {
	
	//{ =*^_^*= import
	import org.jinanoimateydragoncat.utils.flow.agents.AbstractAgent;
	import ttcc.LOG;
	//} =*^_^*= END OF import
	
	
	/**
	 * Abstract Manager
	 * @author Jinanoimatey Dragoncat
	 * @version 0.0.0
	 * @created 19.01.2012 21:09
	 */
	public class AM extends AbstractAgent {
		
		//{ =*^_^*= CONSTRUCTOR
		function AM (name:String) {
			super(name);
		}
		//} =*^_^*= END OF CONSTRUCTOR
		
		/**
	 * @param	c channel id(see LOGGER)
		0-"R" realtime debugging
		1-"DT" data trace
		2-"DS" data storage
		3-"V" view
		4-"OP" operations
		5-"NET" network
		6-"AG" agent environment
		7-"AF" application flow
	 * @param	m msg
	 * @param	l level
		0-INFO
		1-WARNING
		2-ERROR
	 */
		protected function log(c:uint, m:String, l:uint=0):void {
			LOG(c,m,l);
		}
		
	}
}

//{ =*^_^*= History
/* > (timestamp) [ ("+" (added) ) || ("-" (removed) ) || ("*" (modified) )] (text)
 * > 
 */
//} =*^_^*= END OF History

// template last modified:11.03.2011_[18#51#40]_[5]