// Project FMSSOTest
package fms_so_test.main {
	
	//{ =*^_^*= import
	import com.junkbyte.console.Console;
	import com.junkbyte.console.ConsoleChannel;
	import com.junkbyte.console.ConsoleConfig;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.FileReference;
	import flash.utils.ByteArray;
	import fms_so_test.data.ApplicationConstants;
	import fms_so_test.lib.Library;
	import fms_so_test.LOG;
	import fms_so_test.LOGGER;
	import org.aswing.JButton;
	
	import flash.net.NetConnection;
	import flash.net.SharedObject;

	import flash.events.NetStatusEvent;
	import flash.events.SyncEvent;
	//} =*^_^*= END OF import
	
	
	/**
	 * Main
	 * @author Jinanoimatey Dragoncat
	 * @version 0.0.0
	 * @created 
	 */
	public class FMSSOTest extends Sprite {
		
		//{ =*^_^*= CONSTRUCTOR
		
		function FMSSOTest () {
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
			
			// tip: press "`" button to display/hide console
			prepareConsole(ApplicationConstants.AppW, ApplicationConstants.AppH, ApplicationConstants.AppH/3);
			// show console:
			c.visible=true;
			
			prepareLogging();
			prepareView();
			prepareControl();
			prepareNetwork();
			run();
		}
		
		//} =*^_^*= END OF CONSTRUCTOR
		
		
		
		//{ =*^_^*= run application
		private function run():void {
			LOG(LOGGER.C_OP, 'run',0);
			
			nc.connect("rtmp://localhost/SharedData/instance0");
			//LOG(LOGGER.C_A, 'ag agent 404',1);
			//LOG(LOGGER.C_DS, 'ds missing DU',2);
			//LOG(LOGGER.C_DT, 'dt data trace',0);
			//LOG(LOGGER.C_OP, 'op operation started',0);
			//LOG(LOGGER.C_R, 'r realtime msg',1);
			
		}
		//} =*^_^*= END OF run application
		
		
		//{ =*^_^*= view
		private function prepareView():void {
			LOG(LOGGER.C_OP, 'prepareView',0);
			
			//uploadButton
			uploadButton=addChild(new JButton('Upload'));
			uploadButton.pack();
			uploadButton.addActionListener(function (e:Event):void {viewAction(ID_VIEW_BUTTON_UPLOAD);});
			//clear button
			clearButton=addChild(new JButton('Clear'));
			clearButton.pack();
			clearButton.addActionListener(function (e:Event):void {viewAction(ID_VIEW_BUTTON_CLEAR);});
			clearButton.y=uploadButton.getHeight();
		}
		
		private function removeAllButtons():void {
			for each(var ii:JButton in imageButtons) {if (ii.parent) {ii.parent.removeChild(ii);}}
		}
		
		private function addImageButton(id:uint):void {
			var b:JButton=addChild(new JButton('Data#'+id));
			b.name='Data#'+id;
			b.x=uploadButton.getWidth()*(uint(id/13)+1)*2;
			b.y=(uploadButton.getHeight()+5)*(id%13);
			b.pack();
			b.addActionListener(el_b_images);
			imageButtons.push(b);
		}
		private var imageButtons:Array=[];
		private function el_b_images(e:Event):void {
			var s:String=e.target.name;
			viewAction(ID_VIEW_BUTTON_IMAGE, parseInt(s.substr(s.indexOf('#')+1)));
		}
		private function displayUpload():void {
			var fr:FileReference=new FileReference();
			fr.addEventListener(Event.SELECT, function(e:Object):void {
				fr.load();
			});
			//fr.addEventListener(Event.CANCEL, function(e:Object):void {sl('U have to edit them manually');});
			fr.addEventListener(Event.COMPLETE, function(e:Object):void {
					viewAction(ID_VIEW_UPLOAD_FILE_DATA, fr.data);
				}
			);
			//fr.browse([new FileFilter('BGTileMapEditorFile map data files', '*.BGTileMapEditorFile')]);	
			fr.browse();
		}
		private function displayDownload(b:ByteArray):void {
			var fr0:FileReference =new FileReference();
			fr0.addEventListener(Event.SELECT, function(e:Object):void {
				LOG(3,'SaveData>Saving');});
			fr0.addEventListener(Event.COMPLETE, function(e:Object):void {
				LOG(3,'SaveData>Complete');});
			fr0.addEventListener(Event.CANCEL, function(e:Object):void {
				LOG(3,'SaveData>Cancelled by user');});
			
			fr0.save(b, 'File');
		}
		
		private var uploadButton:JButton;
		private var clearButton:JButton;
		//} =*^_^*= END OF view
		
		
		//{ =*^_^*= control
		private function prepareControl():void {
			LOG(LOGGER.C_OP, 'prepareControl',0);
			
		}
		
		private function viewAction(actionID:String, actionDetails:Object=null):void {
			var n:uint;
			var b:ByteArray;
			LOG(3,'viewAction>'+actionID);
			switch (actionID) {
			
			case ID_VIEW_BUTTON_CLEAR:
				if (!so.data) {numFiles=0;return;}
				for (var name:String in so.data) {
					if (so.data[name]&&(so.data[name] is ByteArray)) {
						ByteArray(so.data[name]).clear();
					}
					so.setProperty(name,null);
				}
				for each(var i:JButton in imageButtons) {removeChild(i);}
				numFiles=0;
				break;
			
			case ID_VIEW_BUTTON_UPLOAD:
				displayUpload();
				break;
			
			case ID_VIEW_BUTTON_IMAGE:
				if (!so.data['file'+actionDetails]) {
					LOG(LOGGER.C_DS, 'NO DATA IN file#'+actionDetails+' (data is null)', 2);
					return;
				}
				displayDownload(so.data['file'+actionDetails]);
				break;
			
			case ID_VIEW_UPLOAD_FILE_DATA:
				b=actionDetails;
				n=so.data.numFiles;
				LOG(LOGGER.C_DS, 'so.data.numFiles = '+so.data.numFiles);
				numFiles+=1;
				so.setProperty('file'+n, b);
				addImageButton(n);
				n+=1;
				so.setProperty('numFiles', n);
				LOG(2, 'so.data.numFiles+1 = '+so.data.numFiles);
				break;
				
			}
		}
		// TODO: REPLACE WITH ARRAY (file content)
		private function networkAction(actionID:String, actionDetails:Object=null):void {
			switch (actionID) {
			
			case ID_NETWORK_SYNC:
				LOG(5,'sync');
				if(!bFirstSync){initSO();}
				if (!so.data.hasOwnProperty('numFiles')) {
					// remove all
					numFiles=0;
					removeAllButtons();
					return;
				}
				LOG(5,'so.data.numFiles = '+so.data.numFiles);
				
				var n:uint=so.data.numFiles;
				if (n==0) {
					removeAllButtons();
					numFiles=0;
				}
				if (numFiles!=n) {
					if (numFiles<n) {//add
						for (var i:uint = 0; i < n;i++) {
							if (i>=imageButtons.length) {
								addImageButton(i);
							}
						}
					}
				}
				numFiles=n;
				break;
			
			
			}
		}
		
		private static const ID_VIEW_UPLOAD_FILE_DATA:String='ID_VIEW_UPLOAD_FILE_DATA';
		private static const ID_VIEW_BUTTON_UPLOAD:String='ID_VIEW_BUTTON_UPLOAD';
		private static const ID_VIEW_BUTTON_CLEAR:String='ID_VIEW_BUTTON_CLEAR';
		private static const ID_VIEW_BUTTON_IMAGE:String='ID_VIEW_BUTTON_IMAGE';
		private static const ID_NETWORK_SYNC:String='ID_NETWORK_SYNC';
		//} =*^_^*= END OF control
		
		
		//{ =*^_^*= data
		private function prepareData():void {
			so = SharedObject.getRemote("A", nc.uri, true);
			if (!so) {
				LOG(2,'prepareData>'+'shared object is null', LOGGER.LEVEL_ERROR);
				return;
			}
			so.addEventListener(SyncEvent.SYNC, syncHandler);
			so.connect(nc);
		}
		private function initSO():void {
			bFirstSync=true;
			//check whether initialized
			if (so.data.hasOwnProperty('numFiles')) {
				LOG(LOGGER.C_DS, 'prepareData>'+'shared object already initialized');
				return;
			}
			so.setProperty('numFiles', 0);
			LOG(2,'prepareData>'+'shared object is now initialized');
			LOG(2,'data.numFiles:'+so.data.numFiles);
		
		}
		private var bFirstSync:Boolean;
		private var numFiles:uint=0;
		//} =*^_^*= END OF data
		
		
		//{ =*^_^*= network
		private function prepareNetwork():void {
			nc = new NetConnection();
			nc.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
		}
		private function syncHandler(e:SyncEvent):void {
			networkAction(ID_NETWORK_SYNC, e);
		}
		public function netStatusHandler(event:NetStatusEvent):void {
            LOG(5,"connected is: " + nc.connected );
			LOG(5,"event.info.level: " + event.info.level);
			LOG(5,"event.info.code: " + event.info.code);
			
            switch (event.info.code) {
                
				case "NetConnection.Connect.Success":
	                LOG(5,"connected");
					prepareData();
		    		break;
                
				case "NetConnection.Connect.Rejected":
				case "NetConnection.Connect.Failed":
	                LOG(5,"failed to connect");
	                break;
	        }
        }

		
		private var so:SharedObject;
		private var nc:NetConnection;
		//} =*^_^*= END OF network
		
		
		//{ =*^_^*= console
		private function prepareConsole(appW:uint, appH:uint, consoleH:uint=400, consoleAlpha:Number=1, consoleBGAlpha:Number=.65):void {
			var cc:ConsoleConfig=new ConsoleConfig;
			cc.alwaysOnTop=false;
			cc.style.traceFontSize=18;
			cc.style.menuFontSize=18;
			cc.style.backgroundAlpha=consoleBGAlpha;
			c = new Console('`', cc);
			addChild(c);
			c.height=consoleH;c.width=appW;
			c.y=appH-consoleH;
			c.alpha=consoleAlpha;
		}
		public static var c:Console;
		//} =*^_^*= END OF console
		
		
		//{ =*^_^*= Logging
		private function prepareLogging():void {
			LOGGER.setL(logMessage);
			LOG_CL.push(
				new ConsoleChannel(LOGGER._CHANNEL_DISPLAY_NAMES[LOGGER.C_R], c)
				,new ConsoleChannel(LOGGER._CHANNEL_DISPLAY_NAMES[LOGGER.C_DT], c)
				,new ConsoleChannel(LOGGER._CHANNEL_DISPLAY_NAMES[LOGGER.C_DS], c)
				,new ConsoleChannel(LOGGER._CHANNEL_DISPLAY_NAMES[LOGGER.C_V], c)
				,new ConsoleChannel(LOGGER._CHANNEL_DISPLAY_NAMES[LOGGER.C_OP], c)
				,new ConsoleChannel(LOGGER._CHANNEL_DISPLAY_NAMES[LOGGER.C_NET], c)
				,new ConsoleChannel(LOGGER._CHANNEL_DISPLAY_NAMES[LOGGER.C_A], c)
			);
			
		}
		/**
		 * 
		 * @param	c channel id
		 * @param	a message
		 * @param	b level
		 */
		private function logMessage(c:uint, a:String, b:uint=0):void {
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
		//} =*^_^*= END OF Logging
		
		
	}
}

//{ =*^_^*= History
/* > (timestamp) [ ("+" (added) ) || ("-" (removed) ) || ("*" (modified) )] (text)
 * > 
 */
//} =*^_^*= END OF History

// template last modified:11.03.2011_[18#55#10]_[5]