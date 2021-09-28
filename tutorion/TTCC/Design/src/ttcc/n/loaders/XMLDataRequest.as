// Project Connect
package ttcc.n.loaders {
	import ttcc.LOG;
	
	//{ =*^_^*= import
	//} =*^_^*= END OF import
	
	
	/**
	 * 
	 * @author Jinanoimatey Dragoncat
	 * @version 0.0.0
	 * @created 17.05.2012 0:31
	 */
	public class XMLDataRequest extends GenericDataRequest {
		
		//{ =*^_^*= CONSTRUCTOR
		/**
		 * 
		 * @param	listenerRef function(operationResultData:Object, operationResultCode:uint):void
		 * @param	url
		 * @param	method 0-POST, 1-GET
		 * @param	data (for POST only)
		 * @param	timeLimit 0-unlimited
		 */
		function XMLDataRequest (listenerRef:Function, url:String, method:uint=0, data:Object=null, timeLimit:Number = 0) {
			super(listenerRef, url, method, data, timeLimit);
		}
		//} =*^_^*= END OF CONSTRUCTOR
		
		//{ =*^_^*= id
		/**
		 * operationResultData:XML
		 */
		public static const ID_ER_NO_ERROR:uint=0;
		/**
		 * operationResultData:*(raw data)
		 */
		public static const ID_ER_PARSE_ERROR:uint=100;
		//} =*^_^*= END OF id
		
		
		/**
		 * @param	l instance for garbage collection
		 * @param	e error id
		 */
		protected override function cb(l:JURLLoader, e:uint=0):void {
			if (e==GenericDataRequest.ID_ER_NO_ERROR) {
				pd(l);
				return;
			}
			c(l, e);
		}
		
		/**
		 * process data
		 * @param	d
		 */
		private function pd(l:JURLLoader):void {
			if (sm) {
				LOG(5,'LOADED DATA FROM:'+l.get_r().url+'>\n'
					+"=============== >>>RESPONSE DATA<<< ======\n"
					+String(l.data).split('><').join('>\n<')
					+"\n=============== >>>END OF RESPONSE DATA<<< ======\n\n\n"
				);
			}
			
			var x:XML;
			/*if (String(l.data).indexOf('<?')!=0) {
				throw new Error('xml is invalid!'+"String(l.data).indexOf('<?')!=0");
			}*/
			//LOG(5, 'xml file loaded, content:\n'+l.data);
			try {
				x = XML(l.data);
			} catch (e:Error) {
				c(l.data, ID_ER_PARSE_ERROR);
				/*if (String(r.data).indexOf('<?xml')>0) {
					r.data = String(r.data).substr(String(r.data).indexOf('<?xml'));
					try {
						x = XML(r.data);
					} catch (e:Error) {
						
					}
				}*/
			}
			
			//LOG(5, 'xml file loaded, parsed:\n'+x.toXMLString());
			c(x, ID_ER_NO_ERROR);
		}
		
		
		
		public static function set_showXMLDataRequestMessages(a:Boolean):void {sm=a;}
		private static var sm:Boolean;
		
	}
}

//{ =*^_^*= History
/* > (timestamp) [ ("+" (added) ) || ("-" (removed) ) || ("*" (modified) )] (text)
 * > 
 */
//} =*^_^*= END OF History

// template last modified:11.03.2011_[18#51#40]_[5]