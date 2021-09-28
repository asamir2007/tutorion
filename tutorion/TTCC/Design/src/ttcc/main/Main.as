// Project TTCC
package ttcc.main {
	
	//{ =*^_^*= import
	import flash.display.StageAlign;
	import ttcc.cfg.AppComponentsList;
	import ttcc.IApplication;
	import ttcc.Application;
	import flash.display.Sprite;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import ttcc.lib.Library;
	//} =*^_^*= END OF import
	
	
	/**
	 * Main
	 * @author Jinanoimatey Dragoncat
	 * @version 0.0.0
	 * @created 26.05.2012_02#54#22
	 */
	public class Main extends Sprite {
		
		//{ =*^_^*= CONSTRUCTOR
		
		function Main () {
			if (stage) {init();}
			else {addEventListener(Event.ADDED_TO_STAGE, init);}
		}
		
		private function init(e:Event=null):void {
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			//{ ^_^ prepare
			Library.initialize(libraryInitialized);
			if (e) {removeEventListener(e.type, arguments.callee);}
			//} ^_^ END OF prepare
		}
		private function libraryInitialized():void {
			// entry point
			app = new Application(this, new AppComponentsList());
			app.set_localeId(ID_LOCALE_RUSSIAN);
			app.run();
		}
		
		//} =*^_^*= END OF CONSTRUCTOR
		
		//{ =*^_^*= id
		public static const ID_LOCALE_RUSSIAN:uint=1;
		public static const ID_LOCALE_ENGLISH:uint=0;
		//} =*^_^*= END OF id
		
		
		private var app:IApplication;
		
	}
}

//{ =*^_^*= History
/* > (timestamp) [ ("+" (added) ) || ("-" (removed) ) || ("*" (modified) )] (text)
 * > 
 */
//} =*^_^*= END OF History

// template last modified:11.03.2011_[18#55#10]_[5]