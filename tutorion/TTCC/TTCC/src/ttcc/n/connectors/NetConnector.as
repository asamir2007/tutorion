// Project Connect
package ttcc.n.connectors {
	
	//{ =*^_^*= import
	import flash.errors.IOError;
	import flash.events.AsyncErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.NetStatusEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.TimerEvent;
	import flash.net.NetConnection;
	import flash.net.Responder;
	import flash.utils.Timer;
	//} =*^_^*= END OF import
	
	
	/**
	 * 
	 * @author Jinanoimatey Dragoncat
	 * @version 0.0.0
	 * @created 18.05.2012 0:59
	 */
	public class NetConnector {
		
		//{ =*^_^*= CONSTRUCTOR
		/**
		 * 
		 * @param	listenerRef function(target:NetConnector, eventType:String, eventData:Object):void;
		 */
		public function constuct (listenerRef:Function):void {
			el=listenerRef;
			nc=new NetConnection;
			nc.addEventListener(NetStatusEvent.NET_STATUS, el_nc);
			nc.addEventListener(SecurityErrorEvent.SECURITY_ERROR, el_nc_e);
			nc.addEventListener(IOErrorEvent.IO_ERROR, el_nc_e);
			nc.addEventListener(AsyncErrorEvent.ASYNC_ERROR, el_nc_e);
		}
		//} =*^_^*= END OF CONSTRUCTOR
		
		
		//{ =*^_^*= =*^_^*= user interface
		
		/**
		 * ATTENTION: NO DIRECT ACCESS TO THE NetConnection INSTANCE ALLOWED! - use NetConnector's proxy methods
		 * ATTENTION: the reference to the instance SHOULD be used ONLY as_ a reference - for example in cases such: SharedObject.getRemote(); or <SharedObject instance>.connect();
		 */
		public function get_nc():NetConnection {return nc;}
		
		
		/**
		 * see flash.net.NetConnection.connect() method info for details
		 */
		public function connect(connectionTimeout:int=7000, command:String='', ...rest):void {
			rest.unshift(command);
			try {
				nc.connect.apply(nc, rest);
				runTimer(connectionTimeout);
			} catch (e:Error) {
				er(e);
			}
		}
		
		/**
		 * see flash.net.NetConnection.close() method info for details
		 */
		public function close():void {
			if (nc.connected) {nc.close();}
			stopTimer();
		}
		
		/**
		 * see flash.net.NetConnection.close() method info for details
		 */
		public function addHeader (operation:String, mustUnderstand:Boolean=false, param:Object=null):void {
			nc.addHeader(operation, mustUnderstand, param);
		}
		
		/**
		 * see flash.net.NetConnection.call() method info for details
		 */
		public function call (command:String, responder:Responder, ...rest):void {
			rest.unshift(command, responder);
			nc.call.apply(nc, rest);
		}
		
		/**
		 * see flash.net.NetConnection.get client() method info for details
		 * returns null instead of throwing Error
		 */
		public function get client():Object {
			try {return nc.client;}
			catch (e:Error){
				log('error in nc.get client()', 2);
				return null;
			}
			return null;
		}
		/**
		 * see flash.net.NetConnection.set client() method info for details
		 */
		public function set client(object:Object):void {nc.client=object;}
		/**
		 * see flash.net.NetConnection.get connected() method info for details
		 */
		public function get connected():Boolean {return nc.connected;}
		/**
		 * see flash.net.NetConnection.get connectedProxyType() method info for details
		 * returns null instead of throwing Error
		 */
		public function get connectedProxyType():String {
			try {return nc.connectedProxyType;} catch (e:Error){
				log('error in nc.get connectedProxyType()', 2);
				return null;}return null;
		}
		/**
		 * see flash.net.NetConnection.get defaultObjectEncoding() method info for details
		 */
		public static function get defaultObjectEncoding():uint {return NetConnection.defaultObjectEncoding;}
		/**
		 * see flash.net.NetConnection.set defaultObjectEncoding() method info for details
		 */
		public static function set defaultObjectEncoding(version:uint):void {NetConnection.defaultObjectEncoding=version;}
		/**
		 * see flash.net.NetConnection.get farID () method info for details
		 */
		public function get farID ():String{return nc.farID;}
		/**
		 * see flash.net.NetConnection.get farNonce() method info for details
		 */
		public function get farNonce ():String{return nc.farNonce;}
		/**
		 * see flash.net.NetConnection.get maxPeerConnections() method info for details
		 */
		public function get maxPeerConnections ():uint{return nc.maxPeerConnections;}
		/**
		 * see flash.net.NetConnection.set maxPeerConnections() method info for details
		 */
		public function set maxPeerConnections (maxPeers:uint):void {nc.maxPeerConnections=maxPeers;}
		/**
		 * see flash.net.NetConnection.get nearID() method info for details
		 */
		public function get nearID ():String {return nearID;}
		/**
		 * see flash.net.NetConnection.get nearNonce() method info for details
		 */
		public function get nearNonce ():String {return nearNonce;}
		/**
		 * see flash.net.NetConnection.get objectEncoding() method info for details
		 * returns uint.MAX_VALUE instead of throwing Error
		 */
		public function get objectEncoding ():uint {
			try {return nc.objectEncoding;} catch (e:Error){
				log('error in nc.get objectEncoding', 2);
				return uint.MAX_VALUE;}return uint.MAX_VALUE;
		}
		/**
		 * see flash.net.NetConnection.set objectEncoding() method info for details
		 */
		public function set objectEncoding (version:uint):void {nc.objectEncoding=version;}
		/**
		 * see flash.net.NetConnection.get protocol() method info for details
		 * returns null instead of throwing Error
		 */
		public function get protocol ():String {
			try {return nc.protocol;} catch (e:Error){
				log('error in nc.get protocol', 2);
				return null;}return null;
		}
		/**
		 * see flash.net.NetConnection.get proxyType() method info for details
		 */
		public function get proxyType ():String {return nc.proxyType;}
		/**
		 * see flash.net.NetConnection.set proxyType() method info for details
		 */
		public function set proxyType (ptype:String):void {nc.proxyType=ptype;}
		/**
		 * see flash.net.NetConnection.get unconnectedPeerStreams() method info for details
		 */
		public function get unconnectedPeerStreams ():Array {return nc.unconnectedPeerStreams;}
		/**
		 * see flash.net.NetConnection.get uri() method info for details
		 */
		public function get uri ():String {return nc.uri;}
		/**
		 * see flash.net.NetConnection.get usingTLS() method info for details
		 * returns false instead of throwing Error
		 */
		public function get usingTLS ():Boolean {
			try {return nc.usingTLS;} catch (e:Error) {
				log('error in nc.get usingTLS', 2);
				return false;}return false;
		}
		
		
		//{ =*^_^*= id
		/**
		 * connection succeed
		 * see flash.events.NetStatusEvent info for details
		 */
		public static const ID_E_SUCCESS:String="ID_E_SUCCESS";
		/**
		 * connection closed
		 * see flash.events.NetStatusEvent info for details
		 */
		public static const ID_E_CLOSED:String="ID_E_CLOSED";
		/**
		 * connection rejected
		 * see flash.events.NetStatusEvent info for details
		 */
		public static const ID_E_ER_REJECTED:String="ID_E_ER_REJECTED";
		/**
		 * connection failed
		 * see flash.events.NetStatusEvent info for details
		 */
		public static const ID_E_ER_FAILED:String="ID_E_ER_FAILED";
		/**
		 * connection failed
		 */
		public static const ID_E_ER_TIMED_OUT:String="ID_E_ER_TIMED_OUT";
		
		/**
		 * see flash.net.NetConnection.connect() method info for details
		 */
		private static const ID_ER_URI_MALFORMED:String='ID_ER_URI_MALFORMED';
		/**
		 * see flash.net.NetConnection.connect() method info for details
		 */
		private static const ID_ER_CONNECTION_FAILED:String='ID_ER_CONNECTION_FAILED';
		/**
		 * see flash.net.NetConnection.connect() method info for details
		 */
		private static const ID_ER_SECURITY_ERROR:String='ID_ER_SECURITY_ERROR';
		//} =*^_^*= END OF id
		
		//} =*^_^*= =*^_^*= END OF user interface
		
		private function er(e:Error):void {
			el(this, 
				(e is ArgumentError)?ID_ER_URI_MALFORMED:
				(e is IOError)?ID_ER_CONNECTION_FAILED:
				ID_ER_SECURITY_ERROR
			,null);
		}
		
		private function le_ncTimeout(e:Event):void	{
			closedInternally=true;
			nc.close();
			el(this, ID_E_ER_TIMED_OUT, null);
		}
		private var closedInternally:Boolean;
		
		private function el_nc(e:NetStatusEvent):void {
			switch(e.info.code) {
				case "NetConnection.Connect.Success":
					stopTimer();
					el(this, ID_E_SUCCESS, null);
					break;
				case "NetConnection.Connect.Rejected":           		
					stopTimer();
					log('FMS conector>NetConnection.Connect.Rejected>description:\n'+e.info.description,2);
					el(this, ID_E_ER_REJECTED, null);
					break;
				case "NetConnection.Connect.Failed":
					stopTimer();
					log('FMS conector>NetConnection.Connect.Failed>description:\n'+traceObject(e.info),2);
					el(this, ID_E_ER_FAILED, null);
					break;
				case "NetConnection.Connect.Closed":
					if (closedInternally) {closedInternally=false;return;}
					stopTimer();
					el(this, ID_E_CLOSED, null);
					break;
					
				case "NetConnection.Connect.NetworkChange":
					//el(this, ID_E_network_changed, null);
					break;
					
				default:
					log('unexpected e.info.code>>'+e.info.code, 1);
					break;
			}		
		}
		
		private function el_nc_e(e:Event):void {
			stopTimer();
			el(this, 
				(e is SecurityErrorEvent)?ID_E_ER_SANDBOX_VIOLATION:
				(e is IOErrorEvent)?ID_E_ER_IO_ERROR:
				//(e is AsyncErrorEvent)?ID_E_ER_ASYNC_ERROR:
				ID_E_ER_ASYNC_ERROR
			,null);
		
		}
		
		/**
		 * see flash.net.NetConnection info for details
		 */
		private static const ID_E_ER_SANDBOX_VIOLATION:String="ID_E_ER_SANDBOX_VIOLATION";
		/**
		 * see flash.net.NetConnection info for details
		 */
		private static const ID_E_ER_IO_ERROR:String="ID_E_ER_IO_ERROR";
		/**
		 * see flash.net.NetConnection info for details
		 */
		private static const ID_E_ER_ASYNC_ERROR:String="ID_E_ER_ASYNC_ERROR";
		
		
		private function runTimer(timeout:Number):void {
			if (ncTimeout) {stopTimer();}
			ncTimeout=new Timer(timeout, 1);
			ncTimeout.addEventListener(TimerEvent.TIMER_COMPLETE, le_ncTimeout);
			ncTimeout.start();
		}
		private function stopTimer():void {
			if (ncTimeout){
				ncTimeout.removeEventListener(TimerEvent.TIMER_COMPLETE, le_ncTimeout);
				if (ncTimeout.running) {ncTimeout.stop();}
				ncTimeout=null;
			}
		}
		
		
		private var el:Function;
		private var nc:NetConnection;
		private var ncTimeout:Timer;
		
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