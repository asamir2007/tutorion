// Project Connect
package ttcc.n.a {
	
	//{ =*^_^*= import
	import flash.events.NetStatusEvent;
	import flash.events.SyncEvent;
	import flash.net.NetConnection;
	import flash.net.Responder;
	import flash.net.SharedObject;
	import ttcc.cfg.SP;
	import ttcc.LOG;
	import ttcc.LOGGER;
	//} =*^_^*= END OF import
	
	
	/**
	 * FMSSharedObjectWhiteboardAdaptor
	 * listens to server's events and sends it to app without data conversion
	 * @author Jinanoimatey Dragoncat
	 * @version 0.0.0
	 * @created 30.08.2012 20:12
	 */
	public class FMSSOWBAdaptor {
		
		//{ =*^_^*= CONSTRUCTOR
		function FMSSOWBAdaptor () {
		}
		/**
		 * 
		 * @param	eventListener function(target:FMSSOWBAdaptor, eventType:uint, eventData:Object):void
		 */
		public function construct(eventListener:Function):void {
			if (eventListener==null) {throw new ArgumentError('eventListener==null');}
			
			el=eventListener;
		}
		public function destruct():void {
		}
		//} =*^_^*= END OF CONSTRUCTOR
		
		//{ =*^_^*= user access
		public function getWBFullData():Object {
			return so.data;
		}
		
		public function preapareAndConnectSharedObject(ncReference:NetConnection):void {
			//LOG(0, 'try connect',0);
			try {
				so=SharedObject.getRemote(SP.SHARED_OBJECT_NAME_WHITEBOARD, ncReference.uri, true);//throw
				so.addEventListener(SyncEvent.SYNC, el_so);
				so.addEventListener(NetStatusEvent.NET_STATUS, el_netStatus);
				so.connect(ncReference);//throw
				//LOG(0, 'try connect success',1);
			} catch (e:Error) {
				//LOG(0, 'error while try connect:'+e.getStackTrace(),2);
				if (so) {so.removeEventListener(SyncEvent.SYNC, el_so);}
				el(this, ID_E_FAILED_TO_CONNECT, null);
			}
		}
		
		//} =*^_^*= END OF user access
		
		private function el_netStatus(e:NetStatusEvent):void {
			LOG(0, 'wb so net status:'+e.info,1);
		}
		
		/**
		* el_so() -- handle changes on fms
		**/
		private function el_so(e:SyncEvent):void {
			LOG(1, 'so resopnonce'+LOGGER.traceObject(so.data), 0);
			if (!so.data.ready||!so.data.pages||!so.data.pages.length) {
				LOG(1, '!so.data.ready||!so.data.pages||!so.data.pages.length', 1);
				return;
			}
			
			if (firstTime) {
				firstTime=false;
				el(this, ID_E_CONNECTED, null);
				//tn.initAll(so.data.pages,so.data.sel);
				el(this, ID_E_REACT, [ID_M_INITALL, so.data.pages,so.data.sel]);
				//status("Whiteboard[connected!",2);
				return;
			}
			
			var l:Object=so.data.last;
			switch (l.type) {
				case "clearall":
				case "clearpage":
				case "load":
					//wbvp.initAll(so.data.pages,so.data.sel);	
					el(this, ID_E_REACT, [ID_M_INITALL, so.data.pages, so.data.sel]);
					break;
				case "add_bg": 
					//wbvp.addBG([so.data.pages[l.p].url], l.p);
					el(this, ID_E_REACT, [ID_M_ADDBG, l.p, so.data.pages[l.p].url]);
					break;
				case "add_data":
					//wbvp.addData(so.data.pages[l.p].draw.slice(-1), l.p);	// draw new data
					var lastDDD:Array=so.data.pages[l.p].draw;
					
					el(this, ID_E_REACT, [ID_M_ADDDATA, l.p, lastDDD[lastDDD.length-1]]);
					break;
				case "undo":
					//wbvp.undoData([], l.p);	// undo data
					el(this, ID_E_REACT, [ID_M_UNDODATA, l.p]);
					break;
				case "del_item":
					//wbvp.delData([], l.p, l.it);	// del data
					el(this, ID_E_REACT, [ID_M_DELDATA, l.p, l.it]);
					break;
				case "add_page":
					//wbvp.addPage([so.data.pages[l.p]], l.p);
					el(this, ID_E_REACT, [ID_M_ADDPAGE, l.p, [so.data.pages[l.p]]]);
					break;
				case "del_page":
					//wbvp.delPage(/*so.data.pages*/[], l.p);
					el(this, ID_E_REACT, [ID_M_DELPAGE, l.p]);
					break;
				case "select_page":
					el(this, ID_E_REACT, [ID_M_SELECTPAGE, l.p]);
					break;		
				default:
					//err("sync():Unknown type ("+l.type+")");					
					break;
			}
			
		}
		
		//{ =*^_^*= id
		/**
		 * wbvp.initAll(so.data.pages,so.data.sel);
		 */
		public static const ID_M_INITALL:String="ID_M_INITALL";
		/**
		 * wbvp.addData(so.data.pages[l.p].draw.slice(-1), l.p);	// draw new data
		 */
		public static const ID_M_ADDDATA:String="ID_M_ADDDATA";
		/**
		 * wbvp.undoData(l.p);	// undo data
		 */
		public static const ID_M_UNDODATA:String="ID_M_UNDODATA";
		/**
		 * wbvp.delData(l.p, l.it);	// del data
		 */
		public static const ID_M_DELDATA:String="ID_M_DELDATA";
		/**
		 * wbvp.addPage([so.data.pages[l.p]], l.p);
		 */
		public static const ID_M_ADDPAGE:String="ID_M_ADDPAGE";
		/**
		 * wbvp.delPage(l.p);
		 */
		public static const ID_M_DELPAGE:String="ID_M_DELPAGE";
		/**
		 * wbvp.addBG(so.data.pages[l.p].url, l.p);
		 */
		public static const ID_M_ADDBG:String="ID_M_ADDBG";
		/**
		 * wbvp.selectPage(l.p);
		 */
		public static const ID_M_SELECTPAGE:String="ID_M_SELECTPAGE";
		//} =*^_^*= END OF id
		
		
		//{ =*^_^*= events
		//public function setListener(a:Function):void {el=a;}
		private var el:Function;
		
		public static const ID_E_FAILED_TO_CONNECT:uint=0;
		public static const ID_E_CONNECTED:uint=1;
		/**
		 * [methodName, ...arguments]
		 */
		public static const ID_E_REACT:uint=2;
		//} =*^_^*= END OF events
		
		//{ =*^_^*= private 
		private var so:SharedObject;
		
		/**
		* ^_^ can do something( valid data)
		* used at event dispatch
		*/
		private var firstTime:Boolean=true;
		//} =*^_^*= END OF private
		
	}
}



//{ =*^_^*= History
/* > (timestamp) [ ("+" (added) ) || ("-" (removed) ) || ("*" (modified) )] (text)
 * > 
 */
//} =*^_^*= END OF History

// template last modified:11.03.2011_[18#51#40]_[5]