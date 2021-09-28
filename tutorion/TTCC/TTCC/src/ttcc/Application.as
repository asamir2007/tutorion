// Project TTCC
package ttcc {
	
	//{ =*^_^*= import
	import flash.utils.getTimer;
	import ttcc.c.ae.DE;
	import ttcc.cfg.AppComponentsList;
	import ttcc.media.Text;
	import ttcc.n.a.FileServerAdaptor;
	import ttcc.n.a.HTTPXMLServerAdaptor;
	import ttcc.n.connectors.NetConnector;
	import ttcc.v.VCMainScreen;
	import com.junkbyte.console.Console;
	import com.junkbyte.console.ConsoleChannel;
	import com.junkbyte.console.ConsoleConfig;
	import flash.display.DisplayObjectContainer;
	import ttcc.lib.Library;
	import org.jinanoimateydragoncat.utils.flow.operations.Operation;
	
	import ttcc.c.ae.AE;
	import ttcc.cfg.AppCfg;
	import ttcc.c.ae.AEApp;
	import ttcc.c.op.a.OStartup;
	import ttcc.d.a.DUApp;
	//} =*^_^*= END OF import
	
	
	/**
	 * Main Application Class
	 * contains refs to view objects, data storage
	 * @author Jinanoimatey Dragoncat
	 * @version 0.0.0
	 * @created 26.05.2012_02#54#22
	 */
	public class Application implements IApplication {
		
		//{ =*^_^*= CONSTRUCTOR
		function Application (appContainer:DisplayObjectContainer, appComponentsList:AppComponentsList) {
			ac = appContainer;
			this.appComponentsList=appComponentsList;
		}
		//} =*^_^*= END OF CONSTRUCTOR
		
		/**
		 * seconds
		 * @return
		 */
		public function getCurrentTime():int {
			return getTimer()/1000;
		}
		
		public function getComponentsList():AppComponentsList {return appComponentsList;}
		private var appComponentsList:AppComponentsList;
		
		public function run():void {
			prepareVCMainScreen();
			prepareConsole(AppCfg.appScreenW,  AppCfg.appScreenH, AppCfg.appScreenH/2);
			prepareLogging();
			startup();
		}
		
		private function startup():void {
			LOG(0, APP_NAME+'>build:'+Library.build);
			new OStartup(null, this);
		}
		private var ac:DisplayObjectContainer;
		
		//{ =*^_^*= network
		public function get_httpXMLAdaptor():HTTPXMLServerAdaptor {return httpXMLAdaptor;}
		public function set_httpXMLAdaptor(a:HTTPXMLServerAdaptor):void {httpXMLAdaptor = a;}
		private var httpXMLAdaptor:HTTPXMLServerAdaptor;
		
		public function get_fileServerAdaptor():FileServerAdaptor {return fileServerAdaptor;}
		public function set_fileServerAdaptor(a:FileServerAdaptor):void {fileServerAdaptor = a;}
		private var fileServerAdaptor:FileServerAdaptor;
		
		public function get_fmsNetConnectorRef():NetConnector {return fmsNetConnectorRef;}
		public function set_fmsNetConnectorRef(a:NetConnector):void {fmsNetConnectorRef = a;}
		private var fmsNetConnectorRef:NetConnector;
		//} =*^_^*= END OF network
		
		//{ =*^_^*= locale
		public function lText():Text {return localeText;}
		
		public function set_localeId(a:uint):void {
			localeText=new Text();
			APP.setlText(localeText);
		}
		private var localeText:Text;
		//} =*^_^*= END OF locale		
		
		//{ =*^_^*= Agents
		public function get_de():DE {return de;}
		public function set_de(a:DE):void {
			de = a;
			de.logMessages=de_logMessages;
			de.setL(log_agentEnv);
		}
		/**
		 * Main Agent Environment
		 */
		public function get_ae():AEApp {return ae;}
		public function set_ae(a:AEApp):void {
			ae = a;
			ae.logMessages=ae_logMessages;
			ae.setL(log_agentEnv);
		}
		private var ae:AEApp;
		private var de:DE;
		//} =*^_^*= END OF Agents
		
		
		//{ =*^_^*= Data
		/**
		 * Main Data Storage
		 */
		public function get_ds():DUApp {return ds;}
		public function set_ds(a:DUApp):void {ds = a;}
		private var ds:DUApp;
		//} =*^_^*= END OF Data
		
		
		//{ =*^_^*= VC MainScreen
		private function prepareVCMainScreen():void {
			ms = new VCMainScreen(AppCfg.appScreenW, AppCfg.appScreenH);
			ac.addChild(ms.get_displayObject());
		}
		public function get_mainScreen():VCMainScreen {return ms;}
		private var ms:VCMainScreen;
		//} =*^_^*= END OF VC MainScreen
		
		
		//{ =*^_^*= logging
		private function prepareLogging():void {
			LOGGER.setL(logMessage);
			
			Operation.setL(log_operation);
			
			LOG_CL.push(
				new ConsoleChannel(LOGGER._CHANNEL_DISPLAY_NAMES[LOGGER.C_R], c)
				,new ConsoleChannel(LOGGER._CHANNEL_DISPLAY_NAMES[LOGGER.C_DT], c)
				,new ConsoleChannel(LOGGER._CHANNEL_DISPLAY_NAMES[LOGGER.C_DS], c)
				,new ConsoleChannel(LOGGER._CHANNEL_DISPLAY_NAMES[LOGGER.C_V], c)
				,new ConsoleChannel(LOGGER._CHANNEL_DISPLAY_NAMES[LOGGER.C_OP], c)
				,new ConsoleChannel(LOGGER._CHANNEL_DISPLAY_NAMES[LOGGER.C_NET], c)
				,new ConsoleChannel(LOGGER._CHANNEL_DISPLAY_NAMES[LOGGER.C_A], c)
				,new ConsoleChannel(LOGGER._CHANNEL_DISPLAY_NAMES[LOGGER.C_AF], c)
			);
			LOG(4, 'starting Application name:"'+APP_NAME+'"');
		}
		
		private function log_operation(m:String, l:uint):void {
			logMessage(4, m, l);
		}
		private function log_agentEnv(m:String, l:uint):void {
			logMessage(7, m, l);
		}
		/**
		 * 
		 * @param	c channel id
		 * @param	a message
		 * @param	b level
		 */
		public function logMessage(c:uint, a:String, b:uint=0):void {
			var cc:ConsoleChannel=LOG_CL[c];
			if (!cc) {cc=LOG_CL[0];}
			
			switch (b) {
				
				case LOGGER.LEVEL_ERROR:
					cc.error(a);
					break;
					
				case LOGGER.LEVEL_WARNING:
					cc.warn(a);
					break;
					
				default:
				case LOGGER.LEVEL_INFO:
					cc.log(a);
					break;
					
			}
			
		}
		private static const LOG_CL:Vector.<ConsoleChannel>=new Vector.<ConsoleChannel>;
		
		private var ae_logMessages:Boolean=Boolean(1);
		private var de_logMessages:Boolean=Boolean(1);
		//} =*^_^*= END OF logging
		
		
		//{ =*^_^*= console
		private function prepareConsole(appW:uint, appH:uint, consoleH:uint=400, consoleAlpha:Number=1, consoleBGAlpha:Number=.85):void {
			var cc:ConsoleConfig=new ConsoleConfig;
			cc.alwaysOnTop=false;
			cc.displayRollerEnabled=false;
			cc.style.traceFontSize=18;
			cc.style.menuFontSize=18;
			cc.style.backgroundAlpha=consoleBGAlpha;
			c = new Console('`', cc);
			c.height=consoleH;c.width=appW;
			c.y=appH-consoleH;
			c.alpha=consoleAlpha;
			c.visible=true;//show console
			ac.addChild(c);
		}
		public static function setVisibilityConsole(a:Boolean):void {c.visible=a;}
		public static function getVisibilityConsole():Boolean {return c.visible;}
		private static var c:Console;
		//} =*^_^*= END OF console
		
		
		/**
		 * for app's logger
		 */
		private static const APP_NAME:String = "ttcc";
		
	}
}

//{ =*^_^*= History
/* > (timestamp) [ ("+" (added) ) || ("-" (removed) ) || ("*" (modified) )] (text)
 * > 
 */
//} =*^_^*= END OF History

// template last modified:11.03.2011_[18#51#40]_[5]