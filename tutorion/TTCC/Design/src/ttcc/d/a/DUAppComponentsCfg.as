package ttcc.d.a {
	
	//{ =*^_^*= import
	import ttcc.d.ADU;
	import ttcc.media.Text;
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
		public function construct(componentsList:Array, resourcesPathsList:Array, mainMenuRawData:Object, layoutsList:Array, buffer_time_in:Number, buffer_time_in_max:Number, buffer_time_out:Number, buffer_time_out_max:Number, video_resolution_w:Number, video_resolution_h:Number, freeze_timeout:Number, disconnect_timeout:Number):void {
			this.layoutsList=layoutsList;
			this.mainMenuRawData=mainMenuRawData;
			this.componentsList=componentsList;
			this.resourcesPathsList=resourcesPathsList;
			
			this.buffer_time_in = buffer_time_in;
			this.buffer_time_in_max = buffer_time_in_max;
			this.buffer_time_out = buffer_time_out;
			this.buffer_time_out_max = buffer_time_out_max;
			this.video_resolution_w = video_resolution_w;
			this.video_resolution_h = video_resolution_h;
			this.freeze_timeout = freeze_timeout;
			this.disconnect_timeout = disconnect_timeout;
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
		
		public function get_uiText():Text {return uiText;}
		public function set_uiText(a:Text):void {uiText = a;}
		private var uiText:Text;
		
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
		
		public function get_buffer_time_in():Number {return buffer_time_in;}
		//public function set_buffer_time_in(a:Number):void {buffer_time_in = a;}
		public function get_buffer_time_in_max():Number {return buffer_time_in_max;}
		//public function set_buffer_time_in_max(a:Number):void {buffer_time_in_max = a;}
		public function get_buffer_time_out():Number {return buffer_time_out;}
		//public function set_buffer_time_out(a:Number):void {buffer_time_out = a;}
		public function get_buffer_time_out_max():Number {return buffer_time_out_max;}
		//public function set_buffer_time_out_max(a:Number):void {buffer_time_out_max = a;}
		public function get_video_resolution_w():Number {return video_resolution_w;}
		//public function set_video_resolution_w(a:Number):void {video_resolution_w = a;}
		public function get_video_resolution_h():Number {return video_resolution_h;}
		//public function set_video_resolution_h(a:Number):void {video_resolution_h = a;}
		public function get_freeze_timeout():Number {return freeze_timeout;}
		//public function set_freeze_timeout(a:Number):void {freeze_timeout = a;}
		public function get_disconnect_timeout():Number {return disconnect_timeout;}
		//public function set_disconnect_timeout(a:Number):void {disconnect_timeout = a;}
		
		private var freeze_timeout:Number;
		private var disconnect_timeout:Number;
		private var buffer_time_in:Number;
		private var buffer_time_in_max:Number;
		private var buffer_time_out:Number;
		private var buffer_time_out_max:Number;
		private var video_resolution_w:Number;
		private var video_resolution_h:Number;
		
		
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