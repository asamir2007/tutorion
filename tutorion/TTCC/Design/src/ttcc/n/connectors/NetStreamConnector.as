// Project Connect
package ttcc.n.connectors {
	
	//{ =*^_^*= import
	import flash.events.AsyncErrorEvent;
	import flash.events.IOErrorEvent;
	import flash.events.NetStatusEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import ttcc.LOG;
	//} =*^_^*= END OF import
	
	
	/**
	 * 
	 * @author Jinanoimatey Dragoncat
	 * @version 0.0.0
	 * @created 05.07.2012 19:32
	 */
	public class NetStreamConnector {
		
		//{ =*^_^*= CONSTRUCTOR
		/**
		 * 
		 * @param	listenerRef function(target:NetStreamConnector, eventType:String, eventData:Object):void;
		 */
		public function constuct (listenerRef:Function, nc:NetConnection, peerID:String="connectToFMS"):void {
			el=listenerRef;
			this.nc=nc;
			ns=new NetStream(nc, peerID);
			ns.addEventListener(AsyncErrorEvent.ASYNC_ERROR, el_AsyncError);
			ns.addEventListener(NetStatusEvent.NET_STATUS, el_NetStatus);
			ns.addEventListener(IOErrorEvent.IO_ERROR, el_IOError);
		}
		
		public function destruct():void {
			ns.removeEventListener(AsyncErrorEvent.ASYNC_ERROR, el_AsyncError);
			ns.removeEventListener(NetStatusEvent.NET_STATUS, el_NetStatus);
			ns.removeEventListener(IOErrorEvent.IO_ERROR, el_IOError);			
			ns.close();
			ns=null;
			el=null;
			c=null;
		}
		//} =*^_^*= END OF CONSTRUCTOR 
		
		
		//{ =*^_^*= =*^_^*= user interface
		public function setClientRef(a:Object):void {
			this.c=a;
			nc.client=a;
		}
		
		
		public function ns_receiveAudio(a:Boolean):void {ns.receiveAudio(a);}
		public function ns_receiveVideo(a:Boolean):void {ns.receiveVideo(a);}
		public function ns_play(...rest):void {ns.play.apply(ns, rest);}
		
		public function ns_send(handlerName:String, ...rest):void {
			rest.unshift(handlerName);
			ns.send.apply(ns, rest);
		}
		
		/**
		 * only for use as reference
		 * @return
		 */
		public function get_ns():NetStream {return ns;}
		//} =*^_^*= =*^_^*= END OF user interface
		
		//{ =*^_^*= private
		
		
		protected function el_SecurityError(evt:SecurityErrorEvent):void {
			//trace("AbstractStream.securityError:"+evt.text);
				// when this happens, you don't have security rights on the server containing the FLV file
				// a crossdomain.xml file would fix the problem easily
			el(this, ID_SECURITY_ERROR, null);
		}
		
		protected function el_IOError(evt:IOErrorEvent):void {
			trace("IOErrorEvent.ioError:"+evt.text);
				// there was a connection drop, a loss of internet connection, or something else wrong. 404 error too.
			el(this, ID_IO_ERROR, null);
		}
		
		protected function el_AsyncError(evt:AsyncErrorEvent):void {
			trace("AsyncError:"+evt.text);
				// this is more related to streaming server from my experience, but you never know
			el(this, ID_ASYNC_ERROR, null);
		}
		
		protected function el_NetStatus(evt:NetStatusEvent):void {
			//LOG(0, "el_NetStatus="+evt.info.code,2);
				// this will eventually let us know what is going on.. is the stream loading, empty, full, stopped?
		}
		
		public function onMetaData(infoObject:Object):void {
			// TODO: process this
			//LOG(0, "onMetaData="+infoObject,2);
			
			//if(infoObject.duration != null) {
				//trace("our video is "+infoObject.duration+" seconds long");
			//}
			
			if (infoObject.height != null && infoObject.width != null) {
				//trace("our video is "+infoObject.height+"x"+infoObject.width+" pixels");
				// here you want to resize your video object to match there dimensions
				//video.height = infoObject.height;
				//video.width = infoObject.width;
			}
		}
		
		private var el:Function;
		private var nc:NetConnection;
		private var ns:NetStream;
		private var c:Object;
		//} =*^_^*= END OF private
		
		//{ =*^_^*= id
		private static const ID_SECURITY_ERROR:String='ID_SECURITY_ERROR';
		private static const ID_IO_ERROR:String='ID_IO_ERROR';
		private static const ID_ASYNC_ERROR:String='ID_ASYNC_ERROR';
		//} =*^_^*= END OF id
		
		
		//{ =*^_^*= logging
		/**
		 * @param	a function(message:String, level:uint):void;//0-INFO, 1-WARNING, 2-ERROR
		 */
		public static function set_loggerRef(a:Function):void {loggerRef = a;}
		/**
		 * @param	m message
		 * @param	l level 0-INFO, 1-WARNING, 2-ERROR
		 */
		protected final function log(m:String, l:uint=0):void {
			if (loggerRef==null) {return;}
			loggerRef(m, l);
		}
		/**
		 * @param	a function(message:String, level:uint=0):void;
			errorLevel: 0-INFO, 1-WARNING, 2-ERROR
		 */
		private static var loggerRef:Function;
		//} =*^_^*= END OF logging
		
	}
}

//{ =*^_^*= History
/* > (timestamp) [ ("+" (added) ) || ("-" (removed) ) || ("*" (modified) )] (text)
 * > 
 */
//} =*^_^*= END OF History

// template last modified:11.03.2011_[18#51#40]_[5]