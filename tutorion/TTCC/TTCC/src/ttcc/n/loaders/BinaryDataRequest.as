// Project Connect
package ttcc.n.loaders {
	import flash.net.URLLoaderDataFormat;
	import ttcc.LOG;
	
	//{ =*^_^*= import
	//} =*^_^*= END OF import
	
	
	/**
	 * 
	 * @author Jinanoimatey Dragoncat
	 * @version 0.0.0
	 * @created 04.09.2012 23:22
	 */
	public class BinaryDataRequest extends GenericDataRequest {
		
		//{ =*^_^*= CONSTRUCTOR
		/**
		 * 
		 * @param	listenerRef function(operationResultData:Object, operationResultCode:uint):void
		 * @param	url
		 * @param	method 0-POST, 1-GET
		 * @param	data (for POST only)
		 * @param	timeLimit 0-unlimited
		 */
		function BinaryDataRequest (listenerRef:Function, url:String, method:uint=0, data:Object=null, timeLimit:Number = 0) {
			super(listenerRef, url, method, data, timeLimit);
		}
		//} =*^_^*= END OF CONSTRUCTOR
		
		protected override function prepareURLLoader(a:JURLLoader):void {
			a.dataFormat=URLLoaderDataFormat.BINARY;
		}
		
		//{ =*^_^*= id
		/**
		 * operationResultData:ByteArray
		 */
		public static const ID_ER_NO_ERROR:uint=0;
		//} =*^_^*= END OF id
		
		
	}
}

//{ =*^_^*= History
/* > (timestamp) [ ("+" (added) ) || ("-" (removed) ) || ("*" (modified) )] (text)
 * > 
 */
//} =*^_^*= END OF History

// template last modified:11.03.2011_[18#51#40]_[5]