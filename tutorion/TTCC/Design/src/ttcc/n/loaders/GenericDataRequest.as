// Project Connect
package ttcc.n.loaders {
	
	//{ =*^_^*= import
	import flash.errors.MemoryError;
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	//} =*^_^*= END OF import
	
	
	/**
	 * 
	 * @author Jinanoimatey Dragoncat
	 * @version 0.0.0
	 * @created 16.05.2012 23:07
	 */
	public class GenericDataRequest {
		
		//{ =*^_^*= CONSTRUCTOR
		/**
		 * 
		 * @param	listenerRef function(operationResultData:Object, operationResultCode:uint):void
		 * @param	url
		 * @param	data (for POST only)
		 * @param	method 0-POST, 1-GET
		 * @param	timeLimit 0-unlimited
		 */
		function GenericDataRequest (listenerRef:Function, url:String, method:uint=0, data:Object=null, timeLimit:uint = 0) {
			if (timeLimit>0) {throw new ArgumentError("feature not implemented yet");}
			s=s_;//sign with valid signature
			c=listenerRef;
			
			var l:URLRequest = new URLRequest(url);
			var r:JURLLoader = new JURLLoader();
			l.method=(method==0)?URLRequestMethod.POST:URLRequestMethod.GET;
			l.data=data;
			prepareURLLoader(r);
			
			r.addEventListener(IOErrorEvent.IO_ERROR, el_er);
			r.addEventListener(SecurityErrorEvent.SECURITY_ERROR, el_er);
			r.addEventListener(Event.COMPLETE, el_c);
			//r.addEventListener(HTTPStatusEvent.HTTP_RESPONSE_STATUS, el_c);
			
			try {
				r.load(l);
			} catch (e:Error) {
				er(e, r);
			}
		}
		//} =*^_^*= END OF CONSTRUCTOR
		
		protected function prepareURLLoader(a:JURLLoader):void {
			// override and place your code here
		}
		
		//{ =*^_^*= id
		/**
		 * result:JURLLoader
		 */
		public static const ID_ER_NO_ERROR:uint=0;
		/**
		 * result:JURLLoader
		 * see flash.net.URLLoader.load() method doc for details
		 */
		public static const ID_ER_SECURITY_ERROR:uint=1;
		/**
		 * result:JURLLoader
		 * see flash.net.URLLoader.load() method doc for details
		 */
		public static const ID_ER_INVALID_REQUEST_HEADER:uint=2;
		/**
		 * result:JURLLoader
		 * url is null
		 * see flash.net.URLLoader.load() method doc for details
		 */
		public static const ID_ER_WRONG_URL:uint=3;
		/**
		 * result:JURLLoader
		 * see flash.net.URLLoader.load() method doc for details
		 */
		public static const ID_ER_MEMORY_ERROR:uint=3;
		/**
		 * result:null
		 */
		public static const ID_ER_EXPIRED:uint=4;
		/**
		 * result:JURLLoader
		 */
		public static const ID_ER_IO_ERROR:uint=5;
		//} =*^_^*= END OF id
		
		
		private function el_c(e:Event):void {
			if (k()) {return;}
			cb(e.target, ID_ER_NO_ERROR);
		}
		
		private function er(e:Error, t:JURLLoader):void {
			if (k()) {return;}
			cb(t, 
				(e is ArgumentError)?ID_ER_INVALID_REQUEST_HEADER:
				(e is TypeError)?ID_ER_WRONG_URL:
				(e is MemoryError)?ID_ER_MEMORY_ERROR:
				ID_ER_SECURITY_ERROR
			);
		}
		
		private function el_er(e:Event):void {
			if (k()) {return;}
			cb(e.target, (e is IOErrorEvent)?ID_ER_IO_ERROR:ID_ER_SECURITY_ERROR);
		}
		
		/**
		 * @param	l 
		 * @param	e error id
		 */
		protected function cb(l:JURLLoader, e:uint=0):void {
			// override and place your code here
			c(l.data, e);
		}
		
		
		/**
		 * complete ref
		 */
		protected var c:Function;
		
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
			loggerRef(m, l);
		}
		/**
		 * @param	a function(message:String, level:uint=0):void;
			errorLevel: 0-INFO, 1-WARNING, 2-ERROR
		 */
		private static var loggerRef:Function;
		//} =*^_^*= END OF logging
		
		
		//{ =*^_^*= signature
		public static function changeSignature():void {s_+=1;}
		/**
		 * check signature
		 * @return error present
		 */
		private function k():Boolean {
			if (s!=s_) {
				//loggerRef(0, 'request signature is invalid ('+s + '!=' + s_')');
				cb(null, ID_ER_EXPIRED);
				return true;
			}
			return false;
		}
		/**
		 * instance signature
		 */
		private var s:uint;
		/**
		 * valid signature
		 */
		private static var s_:uint = 0;
		//} =*^_^*= END OF signature
		
		
	}
}

//{ =*^_^*= History
/* > (timestamp) [ ("+" (added) ) || ("-" (removed) ) || ("*" (modified) )] (text)
 * > 
 */
//} =*^_^*= END OF History

// template last modified:11.03.2011_[18#51#40]_[5]