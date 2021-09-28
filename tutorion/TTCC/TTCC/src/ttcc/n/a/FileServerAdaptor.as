// Project TTCC
package ttcc.n.a {
	
	//{ =*^_^*= import
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.utils.ByteArray;
	import ru.inspirit.net.MultipartURLLoader;
	import ttcc.cfg.SP;
	import ttcc.LOG;
	import ttcc.n.loaders.BinaryDataRequest;
	import ttcc.n.loaders.GenericDataRequest;
	import ttcc.n.loaders.JURLLoader;
	//} =*^_^*= END OF import
	
	
	/**
	 * 
	 * @author Jinanoimatey Dragoncat
	 * @version 0.0.0
	 * @created 08.08.2012 4:56
	 */
	public class FileServerAdaptor {
		
		//{ =*^_^*= CONSTRUCTOR
		function FileServerAdaptor () {
		}
		public function construct(httpXMLServerAdaptor:HTTPXMLServerAdaptor, serverUrl:String):void {
			this.httpXMLServerAdaptor = httpXMLServerAdaptor;
			this.serverUrl = serverUrl;
		}
		
		public function destruct():void {
		}
		//} =*^_^*= END OF CONSTRUCTOR
		
		public function request(commandName:String, callback:Function=null, args:Object=null, fileName:String=null, fileData:ByteArray=null):void {
			if (!args) {args={};}
			
			var mul:MultipartURLLoader = new MultipartURLLoader();
			
			mul.addEventListener(Event.COMPLETE, 
				function (e:Event):void {
					var mul:MultipartURLLoader=e.target;
					var textData:String=mul.loader.data;
					var cn:String=mul.getVar("cmd").toString();
					LOG(5, "FileServer response:"+" commandName:"+cn+" data:"+textData);
					if (callback!=null) {callback(cn, textData);}
				}
			);
			
			if (fileName) {args["node_name"]=fileName;}
			var ao:Object=httpXMLServerAdaptor.signData(httpXMLServerAdaptor.constructInitialReqDataObject(commandName, args));
			for(var s:String in ao) {mul.addVariable(s, ao[s]);}
			if (fileName!=null){
				fileData.position=0;
				mul.addFile(fileData, fileName+"."+(args["node_typ"]?args["node_typ"]:"xz"), "Filedata");
			}
			//mul.addFile(data2, 'test2.txt', 'Filedata[]', 'text/plain');
			mul.load(serverUrl);
		}
		/**
		* @param	handler function(data:Object, errorOccurred:Boolean):void
		* @param dataFormat 0 binary 1 text
		*/
		public function getFileByID(id:String, handler:Function, dataFormat:uint=1):void {
			var gdr:GenericDataRequest;
			
			var urlLoader:JURLLoader;
			var urlRequest:URLRequest;
			
			var elFS:Function=function (commandName:String, data:String):void {
				var lrr:Function=function(operationResultData:Object, operationResultCode:uint):void {
					switch (operationResultCode) {
						case GenericDataRequest.ID_ER_NO_ERROR:handler(operationResultData, false);break;
						default:handler(null, true);break;
					}
				};
				switch (dataFormat) {
					case 1:gdr = new GenericDataRequest(lrr,data,1);break;
					case 0:gdr = new BinaryDataRequest(lrr,data,1);break;
				}
				LOG(5, "getFileByID:elFS commandName:"+commandName +" data:"+data);
			}
			
			request("get_url_by_id", elFS, {node_name:id});
		}
		
		
		private var httpXMLServerAdaptor:HTTPXMLServerAdaptor;
		private var serverUrl:String;
	}
}

//{ =*^_^*= History
/* > (timestamp) [ ("+" (added) ) || ("-" (removed) ) || ("*" (modified) )] (text)
 * > 
 */
//} =*^_^*= END OF History

// template last modified:11.03.2011_[18#51#40]_[5]