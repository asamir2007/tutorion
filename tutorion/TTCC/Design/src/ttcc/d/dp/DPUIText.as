// Project TTCC
package ttcc.d.dp {
	
	//{ =*^_^*= import
	import ttcc.LOG;
	import ttcc.media.Text;
	//} =*^_^*= END OF import
	
	
	/**
	 * 
	 * @author Jinanoimatey Dragoncat
	 * @version 0.0.0
	 * @created 02.11.2012 23:41
	 */
	public class DPUIText {
		
		//{ =*^_^*= CONSTRUCTOR
		function DPUIText (x:XML) {
			construct(x);
		}
		public function construct(x:XML):void {
			processXML(x);
		}
		public function destruct():void {
		}
		//} =*^_^*= END OF CONSTRUCTOR
		
		private function processXML(x:XML):void {
			//{convert styles tree from xml
			//id:String(x.main_menu.menuitem[i].@id)
			if (!x.hasOwnProperty('ui_text')) {
				// TODO: use default
				LOG(0, 'no ui text found in xml, // TODO: use default?',1);
			}
			d=new Text(x.ui_text);
		}
		
		/*private function copyObject(from:Object):Object {
			var o:Object={};
			//if (from) {
				for each(var i:String in from) {o[i]=from[i];}
			//}
			return o;
		}
		private function convertXMLToSimpleObject(x:XML, o:Object=null):Object {
			if (!o) {o={};}
			for each(var k:XML in x.attributes()) {
				o[String(k.name())]=k.valueOf();
			}
			return o;
		}*/
		
		
		public function get_data():Text {return d;}
		private var d:Text;
		
	}
}

//{ =*^_^*= History
/* > (timestamp) [ ("+" (added) ) || ("-" (removed) ) || ("*" (modified) )] (text)
 * > 
 */
//} =*^_^*= END OF History

// template last modified:11.03.2011_[18#51#40]_[5]