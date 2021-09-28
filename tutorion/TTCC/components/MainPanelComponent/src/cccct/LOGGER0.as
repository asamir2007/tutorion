package cccct {
	
	//{ =*^_^*= import
	import com.junkbyte.console.Console;
	import com.junkbyte.console.ConsoleChannel;
	import com.junkbyte.console.ConsoleConfig;
	import flash.display.DisplayObject;
	import org.jinanoimateydragoncat.utils.L;
	//} =*^_^*= END OF import
	
	
	/**
	 * 
	 * @author Jinanoimatey Dragoncat
	 * @version 0.0.0
	 * @created 25.01.2012 18:25
	 */
	public class LOGGER0 {
		
		/**
		* @param	m msg
		* @param	c channel id
		* @param	l level
		*/
		public static function log(c:uint, m:String, l:uint=0):void {
			i(c, m, l);
		}
		
		/**
		 * function (c:uint, m:String, l:uint=0):void//channel_id, message, level
		 */
		public static function setL(a:Function):void {i=a;}
		/**
		 * logger method ref
		 */
		private static var i:Function;
		public static const LEVEL_INFO:uint = 0;
		public static const LEVEL_WARNING:uint = 1;
		public static const LEVEL_ERROR:uint = 2;
		
		
		/**
		 * channel realtime
		 */
		public static const C_R:uint=0;
		/**
		 * channel data trace
		 */
		public static const C_DT:uint=1;
		/**
		 * channel data state and integrity
		 */
		public static const C_DS:uint=2;
		/**
		 * channel view
		 */
		public static const C_V:uint=3;
		/**
		 * channel operations
		 */
		public static const C_OP:uint=4;
		/**
		 * channel network
		 */
		public static const C_NET:uint=5;
		/**
		 * channel agents
		 */
		public static const C_A:uint=6;
		
		
		public static const _CHANNEL_DISPLAY_NAMES:Array=[
			"R"
			,"DT"
			,"DS"
			,"V"
			,"OP"
			,"NET"
			,"AG"
		];
		
		
		// should't be here:
		// should't be here:
		// should't be here:
		// should't be here:
		// should't be here:
		
		//{ =*^_^*= console
		public static function prepareConsole(appW:uint, appH:uint, consoleH:uint=400, consoleAlpha:Number=1, consoleBGAlpha:Number=.65):void {

/*
Usage example:
// tip: press "`" button to display/hide console
LOGGER0.prepareConsole(ApplicationConstants.AppW, ApplicationConstants.AppH, ApplicationConstants.AppH/3);
LOGGER0.prepareLogging();
// show console:
addChild(LOGGER0.getConsoleDisplayObject());
LOGGER0.getConsoleDisplayObject().visible=true;
*/

			var cc:ConsoleConfig=new ConsoleConfig;
			cc.alwaysOnTop=false;
			cc.style.traceFontSize=18;
			cc.style.menuFontSize=18;
			cc.style.backgroundAlpha=consoleBGAlpha;
			c = new Console('`', cc);
			c.height=consoleH;c.width=appW;
			c.y=appH-consoleH;
			c.alpha=consoleAlpha;
		}
		
		public static function getConsoleDisplayObject():DisplayObject {return c;}
		public static var c:Console;
		//} =*^_^*= END OF console
		
		
		//{ =*^_^*= Logging
		public static function prepareLogging():void {
			LOGGER0.setL(logMessage);
			LOG_CL.push(
				new ConsoleChannel(LOGGER0._CHANNEL_DISPLAY_NAMES[LOGGER0.C_R], c)
				,new ConsoleChannel(LOGGER0._CHANNEL_DISPLAY_NAMES[LOGGER0.C_DT], c)
				,new ConsoleChannel(LOGGER0._CHANNEL_DISPLAY_NAMES[LOGGER0.C_DS], c)
				,new ConsoleChannel(LOGGER0._CHANNEL_DISPLAY_NAMES[LOGGER0.C_V], c)
				,new ConsoleChannel(LOGGER0._CHANNEL_DISPLAY_NAMES[LOGGER0.C_OP], c)
				,new ConsoleChannel(LOGGER0._CHANNEL_DISPLAY_NAMES[LOGGER0.C_NET], c)
				,new ConsoleChannel(LOGGER0._CHANNEL_DISPLAY_NAMES[LOGGER0.C_A], c)
			);
			
		}
		/**
		 * 
		 * @param	c channel id
		 * @param	a message
		 * @param	b level
		 */
		public static function logMessage(c:uint, a:String, b:uint=0):void {
			var cc:ConsoleChannel=LOG_CL[c];
			if (!cc) {cc=LOG_CL[0];}
			
			switch (b) {
				
				case LOGGER0.LEVEL_ERROR:
					cc.error(a);
					break;
					
				case LOGGER0.LEVEL_WARNING:
					cc.warn(a);
					break;
					
				default:
				case LOGGER0.LEVEL_INFO:
					cc.log(a);
					break;
					
			}
			
		}
		private static const LOG_CL:Vector.<ConsoleChannel>=new Vector.<ConsoleChannel>;
		//} =*^_^*= END OF Logging
		
		public static function traceObject(a:Object, callMethods:Boolean=false):String {
			return L.traceObject(a, callMethods).replace('}, {', '}\n,{');
		}
		
		
	}
}

//{ =*^_^*= History
/* > (timestamp) [ ("+" (added) ) || ("-" (removed) ) || ("*" (modified) )] (text)
 * > 
 */
//} =*^_^*= END OF History

// template last modified:11.03.2011_[18#51#40]_[5]