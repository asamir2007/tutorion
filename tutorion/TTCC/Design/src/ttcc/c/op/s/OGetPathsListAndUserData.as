// Project TTCC
package ttcc.c.op.s {
	
	//{ =*^_^*= import
	import ttcc.c.op.AO;
	import ttcc.cfg.SP;
	import ttcc.d.dsp.DUApiAndStoragePaths;
	import ttcc.n.a.HTTPXMLServerAdaptor;
	//} =*^_^*= END OF import
	
	
	/**
	 * 
	 * @author Jinanoimatey Dragoncat
	 * @version 0.0.0
	 * @created 28.05.2012 15:19
	 */
	public class OGetPathsListAndUserData extends AO {
		
		//{ =*^_^*= CONSTRUCTOR
		
		function OGetPathsListAndUserData (onComplete:Function, httpXMLAdaptor:HTTPXMLServerAdaptor, settingsXML:String) {
			super(null, NAME, onComplete);
			this.httpXMLAdaptor=httpXMLAdaptor;
			this.settingsXML=settingsXML;
		}
		//} =*^_^*= END OF CONSTRUCTOR
		
		protected override function start():void {
			var d:XML;
			var e:Boolean;
			
			data=new DUApiAndStoragePaths;
			DUApiAndStoragePaths(data).construct(
				'SampleUserName'
				,'fms path'
				,'fms path'.replace("rtmp:","rtmfp:")
				,''
				,''
				,'p2p p'
				,'ps'
				,'Sample Room Title'
				,'SampleUserName2'
				,"brother-sharp-promo.jpg"
				,"brother-sharp-promo.jpg"
			);
			
			end(OPERATION_RESULT_CODE_SUCCESS);
		}
		
		private var httpXMLAdaptor:HTTPXMLServerAdaptor;
		private var settingsXML:String;
		
		//{ =*^_^*= =*^_^*= ID
		/**
		 * data:DUApiAndStoragePaths
		 */
		public static const OPERATION_RESULT_CODE_SUCCESS:uint=0;
		//} =*^_^*= =*^_^*= END OF ID
		
		public static const NAME:String='OGetPathsListAndUserData';
		
	}
}

//{ =*^_^*= History
/* > (timestamp) [ ("+" (added) ) || ("-" (removed) ) || ("*" (modified) )] (text)
 * > 
 */
//} =*^_^*= END OF History

// template last modified:11.03.2011_[18#51#40]_[5]