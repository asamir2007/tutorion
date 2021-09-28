package ttcc.d.a {
	
	//{ =*^_^*= import
	import ttcc.d.ADU;
	//} =*^_^*= END OF import
	
	
	/**
	 * 
	 * @author Jinanoimatey Dragoncat
	 * @version 0.0.0
	 * @created 18.06.2012 22:33
	 */
	public class DUAppComponentsCfg extends ADU {
		
		//{ =*^_^*= CONSTRUCTOR
		function DUAppComponentsCfg () {
		}
		public function construct(componentsList:Array, resourcesPathsList:Array, mainMenuRawData:Object, layoutsList:Array):void {
			this.layoutsList=layoutsList;
			this.mainMenuRawData=mainMenuRawData;
			this.componentsList=componentsList;
			this.resourcesPathsList=resourcesPathsList;
		}
		public function destruct():void {
		}
		//} =*^_^*= END OF CONSTRUCTOR
		
		
		/**
		 * DUAppComponentCfg
		 */
		public function get_componentList():Array {return componentsList;}
		public function set_componentList(a:Array):void {componentsList = a;}
		private var componentsList:Array;
		
		public function get_mainMenuRawData():Object {return mainMenuRawData;}
		//public function set_mainMenuRawData(a:Object):void {mainMenuRawData = a;}
		private var mainMenuRawData:Object;
		
		/**
		 * [DULayoutInfo]
		 */
		public function get_layoutsList():Array {return layoutsList;}
		public function get_layoutByID(id:String):DULayoutInfo {
			for each(var i:DULayoutInfo in layoutsList) {if (i.get_id()==id) {return i;}}
			return null;
		}
		//public function set_layoutsList(a:Array):void {layoutsList = a;}
		private var layoutsList:Array;
		
		/**
		 * [DUResource]
		 */
		public function get_resourcesPathsList():Array {return resourcesPathsList;}
		private var resourcesPathsList:Array;
		
		
		public function getComponentCfgById(comopnentID:String):DUAppComponentCfg {
			for each(var i:DUAppComponentCfg in componentsList) {
				if (i.get_id()==comopnentID) {return i;}
			}
			return null;
		}
		
		
		/*public function toString():String {
			var s:String='';
			var f:Array=["streamingIsOn", "streamName", "streamSoundIsOn", "chatIsTyping", "handIsUp", "name", "loggedIn"];
			for each(var i:String in f) {
				s=s.concat(i+'='+this[i]+', ');
			}
			return s;
		}*/
		
	}
}

//{ =*^_^*= History
/* > (timestamp) [ ("+" (added) ) || ("-" (removed) ) || ("*" (modified) )] (text)
 * > 
 */
//} =*^_^*= END OF History

// template last modified:11.03.2011_[18#51#40]_[5]