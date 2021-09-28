// Project TTCC
package ttcc.c.ma {
	
	//{ =*^_^*= import
	import flash.utils.ByteArray;
	import org.jinanoimateydragoncat.utils.flow.operations.Operation;
	import ttcc.Application;
	import ttcc.c.ae.AEApp;
	import ttcc.c.ma.ac.MAPPComponents;
	import ttcc.c.op.AO;
	import ttcc.c.op.d.OGetDataFromAppEnv;
	import ttcc.c.op.s.OLoadResources;
	import ttcc.c.vcm.VCMChat;
	import ttcc.c.vcm.VCMCourseLoader;
	import ttcc.c.vcm.VCMMainPanel;
	import ttcc.c.vcm.VCMMainScreen;
	import ttcc.c.vcm.VCMPresentationLoader;
	import ttcc.cfg.AppCfg;
	import ttcc.cfg.SP;
	import ttcc.d.a.ARO;
	import ttcc.d.a.DUUD;
	import ttcc.d.dsp.DUAppEnvData;
	import ttcc.d.s.ReplayInfo;
	import ttcc.d.s.UpdateDataEvent;
	import ttcc.LOGGER;
	import ttcc.media.PictureStoreroom;
	import ttcc.n.a.FileServerAdaptor;
	import ttcc.n.a.HTTPXMLServerAdaptor;
	//} =*^_^*= END OF import
	
	
	/**
	 * the only mission of this agent - startup application
	 * @author Jinanoimatey Dragoncat
	 * @version 0.0.0
	 * @created 26.05.2012_02#54#22
	 */
	public class MAppStartup extends AM {
		
		//{ =*^_^*= CONSTRUCTOR
		
		function MAppStartup (app:Application) {
			super(NAME);
			a=app;
		}
		//} =*^_^*= END OF CONSTRUCTOR
		
		
		public override function listen(eventType:String, details:Object):void {
			var r:ARO;
			
			switch (eventType) {
			
			case ID_A_STARTEDUP:
				// register main screen
				e.listen(VCMMainScreen.ID_A_REGISTER_SINGLETON_VC, a.get_mainScreen());
				
				listen(ID_A_PREPARE_APP_DATA, null);
				break;
				
			case ID_A_PREPARE_APP_DATA:
				e.listen(MAppData.ID_A_GET_ENV_DATA, null);
				break;
				
			case MAppData.ID_E_ENV_DATA:
				r=details;
				if (r.get_code()==ARO.ID_RESULT_CODE_FAILURE) {
					log(0, 'failed to get data from env, run swf in container', 2);
					break;
				}
				// store received data
				a.get_ds().set_startupEnvData(r.get_result());
				
				listen(ID_A_PREPARE_NETWORK0, null);
				break;
				
			case ID_A_PREPARE_NETWORK0:
				var sd:DUAppEnvData=a.get_ds().get_startupEnvData();
				// prepare paths
				SP.set_AP(sd.get_reqURL());
				
				// prepare adaptors
				var ad:HTTPXMLServerAdaptor=new HTTPXMLServerAdaptor;
				
				ad.setSignatureData(sd.get_userID(), sd.get_roomID(), sd.get_sessionID(), sd.get_token());
				a.set_httpXMLAdaptor(ad);
				
				e.listen(MAppData.ID_A_GET_PATHS_AND_USER_DATA, null);
				break;
				
			case MAppData.ID_E_PATHS_AND_USER_DATA:
				r=details;
				if (r.get_code()==ARO.ID_RESULT_CODE_FAILURE) {
					log(0, 'failed to get api paths list from server, restart client', 2);
					break;
				}
				// store received data
				a.get_ds().set_startupPathsList(r.get_result());
				
				var fsa:FileServerAdaptor=new FileServerAdaptor();
				fsa.construct(a.get_httpXMLAdaptor(), a.get_ds().get_startupPathsList().get_contentPath());
				a.set_fileServerAdaptor(fsa);
				
				//check for replay mode:
				var replayID:String = a.get_ds().get_startupEnvData().get_repID();
				if (replayID!=null&&replayID.length>0) {
					a.get_ds().set_replayMode(true);
					log(7, '\n\n\n\nreplay mode is >>ON<<, replayID='+replayID, 0);
					listen(LOAD_REPLAY_FILE_DATA, replayID);
				} else {
					log(7, '\n\n\n\nreplay mode is <<OFF>>', 0);
					e.listen(MAppData.ID_A_GET_APPLICATION_AND_COMPONENTS_CONFIG_DATA, null);
				}
				break;
				
			case LOAD_REPLAY_FILE_DATA:
				a.get_fileServerAdaptor().getFileByID(
					details
					,function (data:Object, errorOccurred:Boolean):void {
						if (errorOccurred) {
							log(7, 'failed to load replay file data, replayID='+details, 2);
							return;
						}
						//
						
						//events=MReplay.deserializeArray(JSON.parse(data), UpdateDataEvent);
						
						var ba0:ByteArray=data;
						ba0.uncompress();
						events=MReplay.deserializeArray(ba0.readObject(), UpdateDataEvent);
						
						replayInfo=ReplayInfo.fromObject(MReplay.getEventBySN(events, MReplay.S_REPLAY_INFO_PACKET_SN).get_rawData());
						
						//{ ^_^ debug
						//log(1,'replay data raw:\n\n'+data+'\n\n\n\n\n',0);
						/*var rawupdates:Array=[];
						for each(var i:UpdateDataEvent in events) {
							rawupdates.push(i.toObject());
						}
						log(1,'replay data parsed:\n\n'+LOGGER.traceObject(rawupdates)+'\n\n\n\n\n',0);
						trace('replay data parsed:\n\n'+LOGGER.traceObject(rawupdates)+'\n\n\n\n\n');
						*/
						//} ^_^ END OF debug
						
						if (replayInfo.get_appEnvData().get_roomID()!=a.get_ds().get_startupEnvData().get_roomID()) {
							// TODO: reload page message
							log(7, 'room id from server does not match one from replay data', 2);
							log(7, 'TODO: reload page message', 2);
							return;
						}
						a.get_ds().set_startupEnvDataReplay(replayInfo.get_appEnvData());
						a.get_ds().set_clientUserDataReplay(replayInfo.get_clientUserData());
						//
						e.listen(MAppData.ID_A_GET_APPLICATION_AND_COMPONENTS_CONFIG_DATA, null);
					}
					,0
				);
				break;
				
			case MAppData.ID_E_GET_APPLICATION_AND_COMPONENTS_CONFIG_DATA:
				// store duconfig
				r=details;
				a.get_ds().set_duAppComponentsCfg(r.get_result());
				listen(ID_A_PREPARE_NETWORK1, null);
				break;
				
			case ID_A_PREPARE_NETWORK1:
				var options:Object={};
				if (a.get_ds().get_replayMode()) {
					options.play_replay=true;
				}
				// establish connection
				e.listen(MFMSServerProxy.ID_A_SETUP_CONNECTION, 
					{
						duenv:a.get_ds().get_startupEnvData()
						,dupaths:a.get_ds().get_startupPathsList()
						,timeout:AppCfg.NET_FMS_CONNECTION_TIMEOUT
						,options:options
					}
				);
				// wait for "connected" event
				break;
				
			case MFMSServerProxy.ID_E_CONNECTION_ESTABLISHED:
				a.set_fmsNetConnectorRef(details);//store
				
				if (!a.get_ds().get_replayMode()) {
					e.listen(MUserData.ID_A_PREPARE_AND_CONNECT, null);
				} else {
					listen(M_USERDATA_CONNECTED, a.get_ds().get_clientUserDataReplay());
				}
				break;
				
			case M_USERDATA_CONNECTED:
			case MUserData.ID_E_CONNECTED:
				// store client user data
				//a.get_ds().set_clientUserData(details);
				a.get_ds().set_clientUserId(DUUD(details).get_name());
				a.get_ds().set_clientUserData(details);
				//log(1, 'client user data:'+details);
				
				if (!a.get_ds().get_replayMode()) {
					e.listen(MUIActions.ID_A_CONNECT, null);
				}
				listen(ID_A_LOAD_RESOURCES, null);
				break;
					
			case MUIActions.ID_E_CONNECTED:
			case ID_A_LOAD_RESOURCES:
				// load and connect resources here (run OP)
				var o:OLoadResources=new OLoadResources(
					el_op0, a.get_ds().get_duAppComponentsCfg().get_resourcesPathsList()
						,a.get_ds().get_startupEnvData());
				o.startOperation();
				break;
				
			case RESOURCES_ARE_LOADED:
				// run MAPPComponents
				e.listen(MAPPComponents.ID_A_PREPARE_COMPONENTS, null);
				break;
				
			case MFMSServerProxy.ID_E_CONNECTION_LOST:
				log(0, 'failed to establish connection to FMS server, try to reconnect?', 2);
				// NOTE: listen(ID_A_PREPARE_NETWORK0, null);// using maxTriesNum 
				log(0, 'TODO: block screen with appropriate message', 2);
				break;
				
			case MUserData.ID_E_FAILED_TO_CONNECT:
				log(0, 'failed to establish connection to FMS server, try to reconnect?', 2);
				log(0, 'TODO: block screen with appropriate message', 2);
				break;
				
			case MAPPComponents.ID_E_FAILED_TO_PREPARE_COMPONENT:
				log(7, "display \"failed to prepare component, componentID:"+details.componentID+" message\"", 2);
				break;
				
			case MAPPComponents.ID_E_FAILED_TO_PREPARE_CFG:
				log(7, "display \"failed to prepare cfg message\"", 2);
				break;
				
			case MAPPComponents.ID_E_COMPONENTS_ARE_READY:
				e.listen(MMP.ID_A_REGISTER_MODEL, null);
				listen(COMPLETED, null);
				break;
				
			case COMPLETED:
				//log(0,'a.get_ds().get_replayMode():'+a.get_ds().get_replayMode(),2);
				if (a.get_ds().get_replayMode()) {
					//log(0,'ID_A_PROCESS_LOADED_FILE_DATA', 2)
					e.listen(MReplay.ID_A_PROCESS_LOADED_FILE_DATA, {ri:replayInfo, evl:events});
				}
				e.listen(MUIActions.ID_A_APPLY_DEFAULT_WINDOWS_LAYOUT, null);
				//break;
				e.listen(ID_E_STARTEDUP, null);
				// will no longer listen to any events subscribed for in the past
				e.unsubscribeALL(this);
				// mission complete, detach from system environment
				e.removeAgent(this);
				break;
			
			}
		}
		
		
		private function el_op0(o:OLoadResources):void {
			switch (o.get_resultCode()) {
			
			case OLoadResources.OPERATION_RESULT_CODE_SUCCESS:
				//log(0, '>>>>'+o.get_data(), 2);
				for each(var i:Object in o.get_data()) {
					PictureStoreroom.connectResources(i);
				}
				listen(RESOURCES_ARE_LOADED, null);
				break;
			
			default:
				log(7, 'failed to load resources', 2);
				break;
			
			
			}
		}
		
		private var events:Array;
		private var replayInfo:ReplayInfo;
		
		//{ =*^_^*= private 
		private function get e():AEApp {return get_envRef();}
		private var a:Application;
		//} =*^_^*= END OF private
		
		
		//{ =*^_^*= id
		/**
		 * startup application
		 */
		public static const ID_A_STARTEDUP:String=NAME+'>ID_A_STARTEDUP';
		private static const ID_A_PREPARE_APP_DATA:String=NAME+'>ID_A_PREPARE_APP_DATA';
		private static const ID_A_PREPARE_NETWORK0:String=NAME+'>ID_A_PREPARE_NETWORK0';
		private static const ID_A_PREPARE_NETWORK1:String=NAME+'>ID_A_PREPARE_NETWORK1';
		private static const COMPLETED:String=NAME+'>COMPLETED';
		private static const ID_A_LOAD_RESOURCES:String=NAME+'>ID_A_LOAD_RESOURCES';
		private static const RESOURCES_ARE_LOADED:String=NAME+'>RESOURCES_ARE_LOADED';
		private static const LOAD_REPLAY_FILE_DATA:String=NAME+'>LOAD_REPLAY_FILE_DATA';
		/**
		 * used in replay mode
		 * data:DUUD// client user data
		 */
		private static const M_USERDATA_CONNECTED:String=NAME+'>M_USERDATA_CONNECTED';
		
		//} =*^_^*= END OF id
		
		//{ =*^_^*= events
		public static const ID_E_STARTEDUP:String=NAME+">ID_E_STARTEDUP";
		//} =*^_^*= END OF events
		
		public static const NAME:String = 'MAppStartup';
		
		public override function autoSubscribeEvents():Array {
			return [
				ID_A_STARTEDUP
				,MFMSServerProxy.ID_E_CONNECTION_ESTABLISHED
				,MFMSServerProxy.ID_E_CONNECTION_LOST
				,MUserData.ID_E_CONNECTED
				,MAppData.ID_E_ENV_DATA
				,MAppData.ID_E_PATHS_AND_USER_DATA
				,MAppData.ID_E_GET_APPLICATION_AND_COMPONENTS_CONFIG_DATA
				,MAPPComponents.ID_E_COMPONENTS_ARE_READY
				,MAPPComponents.ID_E_FAILED_TO_PREPARE_COMPONENT
				,MAPPComponents.ID_E_FAILED_TO_PREPARE_CFG
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