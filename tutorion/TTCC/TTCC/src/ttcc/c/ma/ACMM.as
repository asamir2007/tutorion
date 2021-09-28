// Project TTCC
package ttcc.c.ma {
	
	//{ =*^_^*= import
	import org.jinanoimateydragoncat.utils.flow.agents.AbstractAgent;
	import ttcc.Application;
	import ttcc.c.ae.DE;
	import ttcc.d.m.AbstractModel;
	import ttcc.LOG;
	//} =*^_^*= END OF import
	
	
	/**
	 * Abstract Component Main Manager
	 * @author Jinanoimatey Dragoncat
	 * @version 0.0.0
	 * @created 06.08.2012 0:28
	 */
	public class ACMM extends AM {
		
		//{ =*^_^*= CONSTRUCTOR
		function ACMM (name:String) {
			super(name);
		}
		//} =*^_^*= END OF CONSTRUCTOR
		
		protected function registerModel(a:Application, m:AbstractModel):void {
			a.get_de().listen(DE.ID_A_REGISTER_MODEL, m);
		}
		
		
	}
}

//{ =*^_^*= History
/* > (timestamp) [ ("+" (added) ) || ("-" (removed) ) || ("*" (modified) )] (text)
 * > 
 */
//} =*^_^*= END OF History

// template last modified:11.03.2011_[18#51#40]_[5]