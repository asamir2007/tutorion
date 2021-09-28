// Project TTCC
package ttcc.n.a {
	
	//{ =*^_^*= import
	import com.adobe.crypto.MD5;
	
	import flash.net.URLVariables;
	
	import ttcc.n.loaders.XMLDataRequest;
	//} =*^_^*= END OF import
	
	
	/**
	 * 
	 * @author Jinanoimatey Dragoncat
	 * @version 0.0.0
	 * @created 28.05.2012 14:10
	 */
	public class HTTPXMLServerAdaptor {
		
		//{ =*^_^*= CONSTRUCTOR
		function HTTPXMLServerAdaptor () {}
		public function construct():void {}
		public function destruct():void {}
		//} =*^_^*= END OF CONSTRUCTOR
		
		public function setSignatureData(userID:String, roomID:String, sessionID:String,  token:String):void {
			this.userID=userID;
			this.roomID=roomID;
			this.sessionID=sessionID;
			this.token=token;
		}
		
		/**
		 * 
		 * @param	methodName
		 * @param	methodArguments
		 * @param	listener function(data:XML, errorOccured:Boolean):void;
		 */
		public function reqXML(reqURL:String, methodName:String, methodArguments:Object, listener:Function):void {
			new XMLDataRequest(
				function(d:Object, e:uint):void {
					if (e) {
						listener(null, true);
						//LOG(5, 'error occured');
						return;
					}
					listener(d, false);//d is XML
				}
				,reqURL
				,0
				,signData(constructInitialReqDataObject(methodName, methodArguments))
			);
		}
		
		/**
		 * @param	n methodName
		 * @param	a methodArguments
		 */
		public function constructInitialReqDataObject(n:String, a:Object):URLVariables {
			var r:URLVariables=new URLVariables();
			var so:Object={
				id:"swf_1"
				,hsh:"xxxyyyzzz"
				,cmd:n
				,usr:userID
				,room:roomID
				,sess:sessionID
				,token:token
			};
			
			for(var s:String in so) {r[s]=so[s];}//add
			if (a) {
				for(s in a) {
					if (a[s]) {r[s]=String(a[s]);}
				}
			}
			return r;
		}
		public function signData(d:Object):Object {
			// NOTE: for performance reasons signature data check will not be performed here
			const g:Array=reqStdFields;
			var h:String="";
			for each(var s:String in g) {
				if (d[s]){h=h.concat(d[s]);}
			}
			d.hsh=MD5.hash("swf"+h);
			return d;
		}
		
		/**
		 * @param	n methodName
		 * @param	a methodArguments
		 */
		public function constructAndSignInitialReqDataObject(n:String, a:Object):URLVariables {
			return signData(constructInitialReqDataObject(n, a));
		}
		
		private static const reqStdFields:Array=[//{
			"id"
			,"cmd"
			,"usr"
			,"room"
			,"sess"
			,"token"
			,"node_id"
			,"node_name"
			,"node_typ"//^_^ correct, its "typ", not "type"
			,"replay"
			,"link"
		];//}
		
		
		//{ =*^_^*= data
		private var userID:String;
		private var roomID:String;
		private var sessionID:String;
		private var token:String;
		//} =*^_^*= END OF data
		
		
	}
}

//{ =*^_^*= History
/* > (timestamp) [ ("+" (added) ) || ("-" (removed) ) || ("*" (modified) )] (text)
 * > 
 */
//} =*^_^*= END OF History

// template last modified:11.03.2011_[18#51#40]_[5]