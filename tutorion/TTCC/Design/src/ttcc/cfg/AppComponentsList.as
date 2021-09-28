// Project TTCC
package ttcc.cfg {
	
	//{ =*^_^*= import
	import ttcc.c.ma.ac.MACChat;
	import ttcc.c.ma.ac.MACConsole;
	import ttcc.c.ma.ac.MACAV;
	import ttcc.c.ma.ac.MACCourseLoader;
	import ttcc.c.ma.ac.MACMP;
	import ttcc.c.ma.ac.MACPresentationLoader;
	import ttcc.c.ma.ac.MACReplay;
	import ttcc.c.ma.ac.MACWhiteboard;
	//} =*^_^*= END OF import
	
	
	/**
	 * 
	 * @author Jinanoimatey Dragoncat
	 * @version 0.0.0
	 * @created 29.06.2012 2:24
	 */
	public class AppComponentsList {
		
		//{ =*^_^*= CONSTRUCTOR
		function AppComponentsList () {}
		//} =*^_^*= END OF CONSTRUCTOR
		
		public function getComponentsIDsList():Array {return list_componentID;}
		
		public function getComponentsClassReferenceByID(componentID:String):Class {
			var i:int=list_componentID.indexOf(componentID);
			if (i==-1) {return null;}
			return list_componentClassReference[i];
		}
		
		private var list_componentID:Array=[
			MACMP.COMPONENT_ID
			,MACChat.COMPONENT_ID
			,MACPresentationLoader.COMPONENT_ID
			,MACConsole.COMPONENT_ID
			,MACAV.COMPONENT_ID
			,MACReplay.COMPONENT_ID
			,MACWhiteboard.COMPONENT_ID
			,MACCourseLoader.COMPONENT_ID
		];
		private var list_componentClassReference:Array=[
			MACMP
			,MACChat
			,MACPresentationLoader
			,MACConsole
			,MACAV
			,MACReplay
			,MACWhiteboard
			,MACCourseLoader
		];
		
	}
}

//{ =*^_^*= History
/* > (timestamp) [ ("+" (added) ) || ("-" (removed) ) || ("*" (modified) )] (text)
 * > 
 */
//} =*^_^*= END OF History

// template last modified:11.03.2011_[18#51#40]_[5]