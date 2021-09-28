// Project TTCC
package ttcc.d.s {
	
	//{ =*^_^*= import
	import flash.utils.ByteArray;
	import ttcc.d.i.ISerializable;
	//} =*^_^*= END OF import
	
	
	/**
	 * 
	 * @author Jinanoimatey Dragoncat
	 * @version 0.0.0
	 * @created 31.08.2012 1:05
	 */
	public class WBUpdateModelMessage implements ISerializable {
		
		//{ =*^_^*= CONSTRUCTOR
		function WBUpdateModelMessage (n:String, a0:Object, a1:Object, lastPageSN:int):void {
			this.mn=n;
			this.a0=a0;
			this.a1=a1;
			this.lp=lastPageSN;
		}
		//public function construct():void {}
		//public function destruct():void {}
		//} =*^_^*= END OF CONSTRUCTOR
		public function getMethodName():String {return mn;}
		public function getArgument0():Object {return a0;}
		public function getArgument1():Object {return a1;}
		public function get_lastPageSN():int {return lp;}
		
		private var mn:String;
		private var a0:Object;
		private var a1:Object;
		private var lp:int;
		
		public function toObject():Object {
			return {
				n:mn
				,a0:cloneObject(a0)
				,a1:cloneObject(a1)
				,lp:lp
			};
		}
		
		private static function cloneObject(value:Object):Object {
			if (value==null) {return null;}
			cba.clear();
			cba.writeObject(value);
			cba.position = 0;
			return cba.readObject();
		}
		private static const cba:ByteArray = new ByteArray();
		
		public static function fromObject(a:Object):WBUpdateModelMessage {
			return new WBUpdateModelMessage(
				a.n, a.a0, a.a1, a.lp
			);
		}
	
	}
}

//{ =*^_^*= History
/* > (timestamp) [ ("+" (added) ) || ("-" (removed) ) || ("*" (modified) )] (text)
 * > 
 */
//} =*^_^*= END OF History

// template last modified:11.03.2011_[18#51#40]_[5]