// Project Connect
package ttcc.n.loaders {
	
	//{ =*^_^*= import
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	//} =*^_^*= END OF import
	
	
	/**
	 * binary data loader
	 * @author Jinanoimatey Dragoncat
	 * @version 0.0.0
	 * @created 29.06.2012 10:54
	 */
	public class RAWDataLoader {
		
		//{ =*^_^*= CONSTRUCTOR
		/**
		 * 
		 * @param	listenerRef function(instance:RAWDataLoader, data:ByteArray, errorCode:uint):void
		 * @param	url
		 * @param	timeLimit 0-unlimited
		 */
		function RAWDataLoader (listenerRef:Function, url:String, timeLimit:Number=0) {
			this.listenerRef = listenerRef;
			this.url = url;
			this.timeLimit = timeLimit;
			load(url);
		}
		
		//public function get_listenerRef():Function {return listenerRef;}
		public function get_url():String {return url;}
		//public function get_timeLimit():Number {return timeLimit;}
		
		private var listenerRef:Function;
		private var url:String;
		private var timeLimit:Number;		
		//} =*^_^*= END OF CONSTRUCTOR
		
		
		//{ =*^_^*= id
		/**
		 * data:ByteArray
		 */
		public static const ID_ER_NO_ERROR:uint=0;
		/**
		 * data:null
		 */
		public static const ID_ER_ERROR:uint=1;
		//} =*^_^*= END OF id
		
		private function load(p:String):void {
			loader_ = new URLLoader();
			loader_.dataFormat = URLLoaderDataFormat.BINARY;
			
			loader_.addEventListener(Event.COMPLETE, l_complete);
			loader_.addEventListener(IOErrorEvent.IO_ERROR, l_err);
			loader_.addEventListener(SecurityErrorEvent.SECURITY_ERROR, l_err);
			
			//tr('Im> >>> loading from:' + p);
			
			loader_.load(new URLRequest(p));
		}
		
		private function l_err(e:Event):void {
			loader_.removeEventListener(Event.COMPLETE, l_complete);
			loader_.removeEventListener(IOErrorEvent.IO_ERROR, l_err);
			loader_.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, l_err);
			loader_ = null;
			//tr('Im> ERR:' + e.toString());
			listenerRef(this, ID_ER_ERROR, null);
		}
		
		private function l_complete(e:Event = null):void {
			this.data=e.target.data;
			listenerRef(this, ID_ER_NO_ERROR, e.target.data);
		}
		
		public function get_data():ByteArray {return data;}
		private var data:ByteArray;
		private var loader_:URLLoader;
		
		
	}
}

//{ =*^_^*= History
/* > (timestamp) [ ("+" (added) ) || ("-" (removed) ) || ("*" (modified) )] (text)
 * > 
 */
//} =*^_^*= END OF History

// template last modified:11.03.2011_[18#51#40]_[5]