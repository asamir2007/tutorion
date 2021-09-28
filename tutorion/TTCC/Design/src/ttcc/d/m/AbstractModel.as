// Project TTCC
package ttcc.d.m {
	
	//{ =*^_^*= import
	import org.jinanoimateydragoncat.works.cyber_modules.d.SSTM;
	import ttcc.d.i.ISerializable;
	//} =*^_^*= END OF import
	
	
	/**
	 * 
	 * @author Jinanoimatey Dragoncat
	 * @version 0.0.0
	 * @created 01.08.2012 14:35
	 */
	public class AbstractModel extends SSTM {
		
		//{ =*^_^*= CONSTRUCTOR
		function AbstractModel () {
			//set_rawDataReceiver(dataReceiver);
		}
		//} =*^_^*= END OF CONSTRUCTOR
		
		
		private function dataReceiver(modelID:String, elementID:uint, rawData:Object):void {
		}
		
		//{ =*^_^*= helpers
		protected function serializeArray(list:Array):Array {
			var b:Array=[];
			for each(var i:ISerializable in list) {b.push(i.toObject());}
			return b;
		}
		protected function deserializeArray(list:Array, c:Class):Array {
			var b:Array=[];
			for each(var i:Object in list) {b.push(c['fromObject'](i));}
			return b;
		}
		//} =*^_^*= END OF helpers
		
	}
}

//{ =*^_^*= History
/* > (timestamp) [ ("+" (added) ) || ("-" (removed) ) || ("*" (modified) )] (text)
 * > 
 */
//} =*^_^*= END OF History

// template last modified:11.03.2011_[18#51#40]_[5]