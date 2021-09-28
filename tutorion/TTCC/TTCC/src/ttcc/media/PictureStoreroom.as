// Project TTCC
package ttcc.media {
	
	//{ =*^_^*= import
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.utils.ByteArray;
	import ttcc.lib.Library;
	import ttcc.LOG;
	//} =*^_^*= END OF import
	
	
	/**
	 * 
	 * @author Jinanoimatey Dragoncat
	 * @version 0.0.0
	 * @created 20.06.2012 0:27
	 */
	public class PictureStoreroom {
		
		//{ =*^_^*= CONSTRUCTOR
		function PictureStoreroom () {
			throw new ArgumentError('static container only');
		}
		//} =*^_^*= END OF CONSTRUCTOR
		
		public static function prepare():void {
			defaultPicture=Library.im0_PNG;
			
			/*//copy references
			var l:Array=Library.imagesList;
			for each(var i:String in l) {
				bitmaps[i] = Library[i];
			}*/
			
		}
		
		public static function getPictureClass(id:String):Class {
			var c:Class=searchForClassByName(id);
			if (!c) {
				return defaultPicture;
				LOG(0, 'picture with id="%0", not found in lists'.replace('%0', id), 1);
			}
			return c;
		}
		
		public static function getPicture(id:String):DisplayObject {
			var p:DisplayObject;
			var c:Class=searchForClassByName(id);
			
			if (!c) {
				c=defaultPicture;
				LOG(0, 'picture with id="%0", not found in lists'.replace('%0', id), 1);
			}
			
			p=new c();
			
			return p;
		}
		
		private static function searchForClassByName(n:String):Class {
			for each(var i:Object in resList) {
				if (i.hasOwnProperty(n)) {
					return i[n];
				}
			}
			return null;
		}
		
		
		public static function connectResources(res:DisplayObject):void {
			//res[image name]:Class
			if (resList.indexOf(res)!=-1) {return;}//already present
			resList.push(res);
		}
		
		/**
		 * [{property0:Class, ...}]
		 */
		private static var resList:Array=[];
		
		//{ =*^_^*= groups
		//public static const GROUP_BUTTON_UP:String='up_';
		//public static const GROUP_WINDOW_ICON:String='wi_';
		//public static const GROUP_NONE:String='';
		//} =*^_^*= END OF groups
		
		//private static var bitmaps:Object={};
		private static var defaultPicture:Class;
		
	}
}

//{ =*^_^*= History
/* > (timestamp) [ ("+" (added) ) || ("-" (removed) ) || ("*" (modified) )] (text)
 * > 
 */
//} =*^_^*= END OF History

// template last modified:11.03.2011_[18#51#40]_[5]