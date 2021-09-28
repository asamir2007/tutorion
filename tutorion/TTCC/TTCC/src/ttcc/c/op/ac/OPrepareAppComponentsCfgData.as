// Project TTCC
package ttcc.c.op.ac {
	
	//{ =*^_^*= import
	import ttcc.c.ma.ac.MACMP;
	import ttcc.c.ma.ac.MAPPComponent;
	import ttcc.c.op.AO;
	import ttcc.d.a.DUAppComponentsCfg;
	import ttcc.d.a.DUAppComponentCfg;
	//} =*^_^*= END OF import
	
	
	/**
	 * 
	 * @author Jinanoimatey Dragoncat
	 * @version 0.0.0
	 * @created 26.06.2012 1:53
	 */
	public class OPrepareAppComponentsCfgData extends AO {
		
		//{ =*^_^*= CONSTRUCTOR
		
		function OPrepareAppComponentsCfgData (onComplete:Function, cfg:DUAppComponentsCfg) {
			super(null, NAME, onComplete);
			this.cfg=cfg;
		}
		//} =*^_^*= END OF CONSTRUCTOR
		
		protected override function start():void {
			try {
				// TODO: add console component config to the list
				//cfg.getComponentCfgById(MACMP.COMPONENT_ID).setObject(MACMP.ID_AC_CFG_P_COMPONENTS_MPBUTTONS_ORDER, [
				
			} catch (e:Error) {
				end(OPERATION_RESULT_CODE_FAILURE);
				return;
			}
			end(OPERATION_RESULT_CODE_SUCCESS);
		}
		
		private var cfg:DUAppComponentsCfg;
		
		//{ =*^_^*= =*^_^*= ID
		/**
		 * data:null
		 */
		public static const OPERATION_RESULT_CODE_SUCCESS:uint=0;
		//} =*^_^*= =*^_^*= END OF ID
		
		public static const NAME:String='OPrepareAppComponentsCfgData';
		
	}
}

//{ =*^_^*= History
/* > (timestamp) [ ("+" (added) ) || ("-" (removed) ) || ("*" (modified) )] (text)
 * > 
 */
//} =*^_^*= END OF History

// template last modified:11.03.2011_[18#51#40]_[5]