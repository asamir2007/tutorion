// Project TTCC
package ttcc.c.ma {
	
	//{ =*^_^*= import
	import flash.utils.ByteArray;
	import ttcc.APP;
	import ttcc.Application;
	import ttcc.c.ae.AEApp;
	import ttcc.c.vcm.VCMMainScreen;
	import ttcc.cfg.AppCfg;
	import ttcc.cfg.SP;
	import ttcc.d.a.ARO;
	//} =*^_^*= END OF import
	
	
	/**
	 * application(game) manager - ctrl ALL
	 * @author Jinanoimatey Dragoncat
	 * @version 0.0.0
	 * @created 26.05.2012_02#54#22
	 */
	public class MApp extends AM {
		
		//{ =*^_^*= CONSTRUCTOR
		
		function MApp (app:Application) {
			super(NAME);
			a=app;
		}
		//} =*^_^*= END OF CONSTRUCTOR
		
		
		public override function listen(eventType:String, details:Object):void {
			var r:ARO;
			switch (eventType) {
			
			case MAppStartup.ID_E_STARTEDUP:
				// Entry point
				
				break;
				
			case ID_A_SAVE_REPLAY:
				var baData:ByteArray=details.ba;
				if (!baData) {
					log(7, 'failed to save replay, data ByteArray is null', 2);break;
				}
				
				var d:Date=new Date();
				var date:String="_"+d.date+"."+d.month+"."+d.fullYear+"_"+d.toLocaleTimeString();
				
				var replayFileTitle:String="Replay"+"_"+a.get_ds().get_clientUserId()+"_"+a.get_ds().get_startupEnvData().get_roomID()+date;
				
				a.get_fileServerAdaptor().request(
					SP.ID_METHOD_FILE_SERVER_ADD_REPLAY
					,function (cmd:String, rt:String):void {
						log(7, "save replay req responce:"+r);
						if (rt.toLowerCase()!="ok") {
							log(7, "MApp>save replay req>FAILED TO SAVE replay data, details:"+rt, 1);
						}
					}
					,{node_name:replayFileTitle, node_typ:"replay"}
					,replayFileTitle
					,details.ba
				);
				break;
			
			case ID_A_SAVE_BOARD_DATA:
				saveWBData(details);
				break;
			
			}
		}
		
		
		private function saveWBData(details:Object):void {
			var baData:ByteArray=details.ba;
			var folder:Object=details.folder;
			var folderID:int;
			if (!baData) {
				log(7, 'failed to save wb, data ByteArray is null', 2);return;
			}
			
			var d:Date=new Date();
			var date:String="_"+d.date+"."+d.month+"."+d.fullYear+"_"+d.toLocaleTimeString();
			
			var whiteboardFileTitle:String="Whiteboard"+"_"+a.get_ds().get_clientUserId()+"_"+a.get_ds().get_startupEnvData().get_roomID()+date;
			/*Network.fsCall("add_tree_file", onReply, 
   {nodeme:s, node_typ:"course", node_id:privId},
   s,b);*/
			
			a.get_fileServerAdaptor().request(
				SP.ID_METHOD_FILE_SERVER_ADD_WB_DATA
				,function (cmd:String, rt:String):void {
					log(7, "save wb req responce:"+rt);
					/*if (rt.toLowerCase()!="ok") {
						log(7, "MApp>save wb  req>FAILED TO SAVE replay data, details:"+rt, 1);
					}*/
				}
				,{node_name:whiteboardFileTitle, node_typ:"course", node_id:folder}
				,whiteboardFileTitle
				,details.ba
			);
		}
		
		//{ =*^_^*= private 
		private function get e():AEApp {return get_envRef();}
		private var a:Application;
		//} =*^_^*= END OF private
		
		
		//{ =*^_^*= id
		/**
		 * {ba:ByteArray}
		 */
		public static const ID_A_SAVE_REPLAY:String=NAME+"ID_A_SAVE_REPLAY";
		/**
		 * {ba:ByteArray, folder:Object}
		 */
		public static const ID_A_SAVE_BOARD_DATA:String=NAME+"ID_A_SAVE_BOARD_DATA";
		//} =*^_^*= END OF id
		
		//{ =*^_^*= events
		//} =*^_^*= END OF events
		
		public static const NAME:String = 'MApp';
		
		public override function autoSubscribeEvents():Array {
			return [
				MAppStartup.ID_E_STARTEDUP
				,ID_A_SAVE_REPLAY
				,ID_A_SAVE_BOARD_DATA
			];
		}
		
	}
}

//{ =*^_^*= History
/* > (timestamp) [ ("+" (added) ) || ("-" (removed) ) || ("*" (modified) )] (text)
 * > 
 */
//} =*^_^*= END OF History

// template last modified:11.03.2011_[18#51#40]_[5]