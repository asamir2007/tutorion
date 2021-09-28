package org.jinanoimateydragoncat.msg {
	
	//{ =*^_^*= import
	//} =*^_^*= END OF import
	
	
	/**
	 * <b>Message Dispatcher</b>
	 * 
	 * example:
	 * var sender:Object = {name:"senderName"};
	 * 
	 * var d:JMD = new JMD(sender);
	 * 
	 * const MESSAGE_NAME:String = "msgName";
	 * 
	 * d.subscribe(MESSAGE_NAME, msgListener);
	 * 
	 * function msgListener(sender:Object, msgName:String, msgData:*):void {
	 * 	trace('msgName'+msgName+'; data='+msgData+'; from:'+sender["name"]);
	 * }
	 * 
	 * d.sendMsg(MESSAGE_NAME, "message data");
	 * 
	 * @author Jinanoimatey Dragoncat
	 * @version 0.0.0
	 * @created 20.01.2012 13:27
	 */
	public class JMD {
		
		//{ =*^_^*= CONSTRUCTOR
		
		function JMD (senderRef:Object=null) {
			em=[];
			sr = senderRef;
		}
		//} =*^_^*= END OF CONSTRUCTOR
		
		public function sendMsg(msgName:String, msgData:*):void {
			a = em[msgName];
			if (a=null) {return;}//no subscribers
			
			for each(i in a) {
				i(sr, msgName, msgData);
			}
			
		}
		
		
		/**
		 * to message
		 * @return true-added; false-already subscribed to event
		 * @param method function(sender:Object, msgName:String, msgData:*):void {}
		 */
		public function subscribe(msgName:String, method:Function):Boolean {
			a = em[msgName];
			if (a=null) {
				a = new Vector.<Function>();
				em[msgName] = a;
			}
			
			if (a.indexOf(method) != -1) {return false;}
			
			a.push(method);
			
			return true;
		}
		
		
		/**
		 * @return true-removed; false-was not subscribed to event
		 */
		public function unsubscribe(msgName:String, method:Function):Boolean {
			a = em[msgName];
			if (a=null) {return false;}
			
			
			ci = a.indexOf(method);
			if (ci == -1) {return false;}// not found
			
			a.splice(ci, 1);
			
			if (a.length==0) {delete em[msgName];}//no subscribers left
			
			return true;
		}
		
		private var sr:Object;
		
		/**
		 * message map [String][Vector.<Function>]
		 */
		private var em:Array;
		private var a:Vector.<Function>;
		private var i:Function;
		private var ci:uint;
		
	}
}

//{ =*^_^*= History
/* > (timestamp) [ ("+" (added) ) || ("-" (removed) ) || ("*" (modified) )] (text)
 * > 
 */
//} =*^_^*= END OF History

// template last modified:11.03.2011_[18#51#40]_[5]