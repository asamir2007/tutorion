// Project TTCC
package ttcc.c.op.s {
	
	//{ =*^_^*= import
	import ttcc.c.op.AO;
	import ttcc.cfg.SP;
	import ttcc.d.dp.DPAppComponentsCfg;
	import ttcc.n.a.HTTPXMLServerAdaptor;
	//} =*^_^*= END OF import
	
	
	/**
	 * 
	 * @author Jinanoimatey Dragoncat
	 * @version 0.0.0
	 * @created 18.06.2012 19:53
	 */
	public class OGetAppComponentsCfgData extends AO {
		
		//{ =*^_^*= CONSTRUCTOR
		
		function OGetAppComponentsCfgData (onComplete:Function, httpXMLAdaptor:HTTPXMLServerAdaptor) {
			super(null, NAME, onComplete);
			this.httpXMLAdaptor=httpXMLAdaptor;
		}
		//} =*^_^*= END OF CONSTRUCTOR
		
		protected override function start():void {
			httpXMLAdaptor.reqXML(SP.getApiUrl(), SP.ID_METHOD_HTTP_GET_APP_COMPONENTS_CFG_DATA, null, el_xmlData);
		}
		
		private function el_xmlData(d:XML, e:Boolean):void {
			if (e) {
				log('error occured');
				end(OPERATION_RESULT_CODE_FAILURE);
				return;
			}
			
			var dp:DPAppComponentsCfg=new DPAppComponentsCfg(d);
			data=dp.get_data();
			
			end(OPERATION_RESULT_CODE_SUCCESS);
		}
		
		private var httpXMLAdaptor:HTTPXMLServerAdaptor;
		
		//{ =*^_^*= =*^_^*= ID
		/**
		 * data:DUAppComponentsCfg
		 */
		public static const OPERATION_RESULT_CODE_SUCCESS:uint=0;
		//} =*^_^*= =*^_^*= END OF ID
		
		public static const NAME:String='OGetAppComponentsCfgData';
		
	}
}

//{ =*^_^*= History
/* > (timestamp) [ ("+" (added) ) || ("-" (removed) ) || ("*" (modified) )] (text)
 * > 
 */
//} =*^_^*= END OF History

// template last modified:11.03.2011_[18#51#40]_[5]