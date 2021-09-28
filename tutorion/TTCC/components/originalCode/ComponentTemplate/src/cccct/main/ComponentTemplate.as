// Project ComponentTemplate
package cccct.main {
	
	//{ =*^_^*= import
	import cccct.data.ApplicationConstants;
	import cccct.LOGGER;
	import cccct.LOGGER0;
	import flash.display.Sprite;
	import flash.events.Event;
	import cccct.lib.Library;
	import org.aswing.AsWingManager;
	//} =*^_^*= END OF import
	
	
	/**
	 * Main
	 * @author Jinanoimatey Dragoncat
	 * @version 0.0.0
	 * @created 
	 */
	public class ComponentTemplate extends Sprite {
		
		//{ =*^_^*= CONSTRUCTOR
		
		function ComponentTemplate () {
			if (stage) {init();}
			else {addEventListener(Event.ADDED_TO_STAGE, init);}
		}
		
		private function init(e:Event=null):void {
			//{ ^_^ prepare
			Library.initialize(libraryInitialized);
			if (e) {removeEventListener(e.type, arguments.callee);}
			//} ^_^ END OF prepare
		}
		private function libraryInitialized():void {
			// entry point
			
			prepareLoggingAndConsole();
			prepareView();
			prepareControl();
			return;
			prepareData();
			prepareNetwork();
			run();
		}
		
		//} =*^_^*= END OF CONSTRUCTOR
		
		
		
		//{ =*^_^*= run application
		private function run():void {
			
		}
		//} =*^_^*= END OF run application
		
		
		
		//{ =*^_^*= view
		private function prepareView():void {
			AsWingManager.initAsStandard(this, true, false);
		}
		//} =*^_^*= END OF view
		
		
		
		//{ =*^_^*= control
		private function prepareControl():void {
			
		}
		//} =*^_^*= END OF control
		
		
		
		//{ =*^_^*= data
		private function prepareData():void {
			
		}
		//} =*^_^*= END OF data
		
		
		
		//{ =*^_^*= network
		private function prepareNetwork():void {
			
		}
		//} =*^_^*= END OF network
		
		
		//{ =*^_^*= logging and console
		private function prepareLoggingAndConsole():void {
			// tip: press "`" button to display/hide console
			LOGGER0.prepareConsole(ApplicationConstants.appW, ApplicationConstants.appH, ApplicationConstants.appH/3);
			LOGGER0.prepareLogging();
			// show console:
			addChild(LOGGER0.getConsoleDisplayObject());
			LOGGER0.getConsoleDisplayObject().visible=true;
		}
		//} =*^_^*= END OF logging and console
		
	}
}

//{ =*^_^*= History
/* > (timestamp) [ ("+" (added) ) || ("-" (removed) ) || ("*" (modified) )] (text)
 * > 
 */
//} =*^_^*= END OF History

// template last modified:11.03.2011_[18#55#10]_[5]