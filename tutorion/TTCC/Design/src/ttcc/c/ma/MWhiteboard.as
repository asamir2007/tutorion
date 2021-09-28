// Project TTCC
package ttcc.c.ma {
	
	//{ =*^_^*= import
	import flash.geom.Point;
	import flash.utils.ByteArray;
	import ttcc.c.vcm.VCMMainScreen;
	
	import org.jinanoimateydragoncat.works.cyber_modules.d.SSTM;
	
	import ttcc.APP;
	import ttcc.Application;
	import ttcc.LOG;
	import ttcc.LOGGER;
	import ttcc.c.ae.AEApp;
	import ttcc.c.ma.pen.PenEvent;
	import ttcc.c.ma.pen.PenSocketHelper;
	import ttcc.c.vcm.VCMCourseLoader;
	import ttcc.c.vcm.VCMWhiteboard;
	import ttcc.cfg.AppCfg;
	import ttcc.cfg.SP;
	import ttcc.d.m.AbstractModel;
	import ttcc.d.m.WBComModel;
	import ttcc.d.s.WBUpdateModelMessage;
	import ttcc.media.Text;
	import ttcc.n.a.FMSSOWBAdaptor;
	import ttcc.n.a.FMSServerAdaptor;
	import ttcc.n.loaders.GenericDataRequest;
	import ttcc.v.wb.VCWB;

	//} =*^_^*= END OF import
	
	
	/**
	 * @author Jinanoimatey Dragoncat
	 * @version 0.0.0
	 * @created 29.08.2012 17:53
	 */
	public class MWhiteboard extends ACMM {
		
		//{ =*^_^*= CONSTRUCTOR
		
		function MWhiteboard (app:Application) {
			super(NAME);
			a=app;
		}
		//} =*^_^*= END OF CONSTRUCTOR
		
		public override function listen(eventType:String, details:Object):void {
			//var r:ARO;
			
			switch (eventType) {
				
				case ID_A_RUN:
					//  prepare model
					M=new WBComModel();
					M.construct(NAME+'ComModel');
					M.setViewUpdatesListener(el_M);
					registerModel(a, M);
					break;
					
				case ID_A_CONNECT:
					// prepare fms server adaptor
					//nca=new FMSServerAdaptor();
					//nca.construct(el_nca, a.get_fmsNetConnectorRef());
					// construct adapter, listen for first "ID_E_END_PROCESS" event,  then send "ID_E_CONNECTED" to env
					//soa=new FMSSOWBAdaptor();
					//soa.construct(el_soa);
					//soa.preapareAndConnectSharedObject(a.get_fmsNetConnectorRef().get_nc());
					//subscribe
					e.subscribe(this, MDocumentLoader.ID_E_ADD_PAGES);
					e.subscribe(this, VCMWhiteboard.ID_E_SELECT_PAGE);
					//e.subscribe(this, VCMWhiteboard.ID_E_SELECT_THICKNESS);
					//e.subscribe(this, VCMWhiteboard.ID_E_SELECT_COLOR);
					e.subscribe(this, VCMWhiteboard.ID_E_SEND_DATA);
					e.subscribe(this, ID_A_SEND_DATA);
					e.subscribe(this, VCMWhiteboard.ID_E_LOAD_WB_DATA);
					e.subscribe(this, VCMWhiteboard.ID_E_SAVE_WB_DATA);
					e.subscribe(this, VCMWhiteboard.ID_E_SET_ZOOM);
					e.subscribe(this, VCMWhiteboard.ID_E_SET_POSITION);
					e.subscribe(this, VCMCourseLoader.ID_E_FILE_SELECTED);
					
					break;
				
				case VCMWhiteboard.ID_A_REGISTER_SINGLETON_VC:
					vcRef=details;
					break;
					
				case VCMCourseLoader.ID_E_FIRST_FREE_FOLDER_ID:
					firstFreeFolder=details;
					break;
					
					//
				case MDocumentLoader.ID_E_ADD_PAGES:
					var currentWBPage:uint=0;
					var pages:Array=details;
					for(var i:int=0;i<pages.length;i++) {
						nca.call(SP.METHOD_RTMP_WHITEBOARD_ADD_PAGE_BG, [i+currentWBPage, pages[i]]);	
					}
					//log(0,'wb>added pages>'+details,0);
					break;
					
				case VCMWhiteboard.ID_E_SELECT_PAGE:
					//nca.call(SP.METHOD_RTMP_WHITEBOARD_SELECT_PAGE, [details]);
					Model_selectedPage=details as int;
					//if (a.get_ds().get_clientUserData().get_isLector()) {
						vcRef.setSelPage(details);
					//}
					break;
				case VCMWhiteboard.ID_E_SELECT_THICKNESS:
					Model_selectedThickness=details as int;
					break;
				case VCMWhiteboard.ID_E_SELECT_COLOR:
					Model_selectedColor=details as int;
					break;
					
				case VCMWhiteboard.ID_E_SEND_DATA:		// from vcm
				case ID_A_SEND_DATA:					// or from high-level managers
					//log(5, 'server:VCMWhiteboard.ID_E_SEND_DATA:'+'details.cmdName:'+details.cmdName+', details.param:'+details.param,1);
					//nca.call(details.cmdName, details.param);
					break;
					
				case VCMWhiteboard.ID_E_LOAD_WB_DATA:
					e.listen(VCMCourseLoader.ID_A_SET_VISIBILITY, 1);
					break;
					
				case VCMWhiteboard.ID_E_SET_POSITION:
					M.set_zoomPosition(details[0], details[1]);
					break;
				case VCMWhiteboard.ID_E_SET_ZOOM:
					M.set_zoom(details);
					break;
					
				case VCMWhiteboard.ID_E_SAVE_WB_DATA :
					break;
					// save to file server
					var data:String=JSON.stringify(soa.getWBFullData().pages);
					log(1,'saving data to wb fs:'+data);
					var ba0:ByteArray=new ByteArray();
					ba0.writeUTFBytes(data);
					e.listen(MApp.ID_A_SAVE_BOARD_DATA, {ba:ba0, folder:firstFreeFolder});
					break;
				
				case VCMCourseLoader.ID_E_FILE_SELECTED:
					loadWBDataFromFS(details);
					break;
					
				case ID_A_UI_QUERY_RECONNECT_PEN_SEVER:
					if (details) {
						PenSocketHelper.connect();
					}
					break;
			}
		}
		
		//{ =*^_^*= =*^_^*= real pen interface			
		private function prepareRealPenInterace():void {
			//
			// TODO: get SOCKET_ADDR and SOCKET_PORT from config !!!
			//
//			var sAddr:String=mstr.userxml.user.@pen_socket_addr;
//			var aAddr:Array=sAddr.split(":");
//			PenSocketHelper.SOCKET_ADDR=aAddr[0];
//			PenSocketHelper.SOCKET_PORT=aAddr[1]?aAddr[1]:PenSocketHelper.SOCKET_PORT;
			PenSocketHelper.SOCKET_ADDR="localhost";
			PenSocketHelper.SOCKET_PORT=1843;
			PenSocketHelper.POLICY_RQ_ADDR="xmlsocket://"+PenSocketHelper.SOCKET_ADDR+":"+PenSocketHelper.SOCKET_PORT;
			PenSocketHelper.addBunchListeners(penEvts, penEvtHandler);
			// TODO: remove listeners !!!
			PenSocketHelper.connect();
		}
		
		/** events to listen **/
		private var penEvts:Array=[
			PenEvent.PEN_CONNECT, PenEvent.PEN_DISCONNECT, 
			PenEvent.PEN_NO_SERVER, PenEvent.PEN_SERVER_CONNECT, PenEvent.PEN_SERVER_DISCONNECT,
			PenEvent.PEN_DATA, PenEvent.PEN_ERROR];
		
		/** penEvtHandler() -- processing events from PenSocketHelper **/		
		private function penEvtHandler(e:PenEvent):void
			{
			switch(e.type)
				{
				case PenEvent.PEN_ERROR:				// something wrong in communications
					get_envRef().listen(VCMMainScreen.ID_A_DISPLAY_NOTIFICATION, 
						{text:"Continue without pen support.", title:"Pen error detected!"/*,w:int, h:int, ico:DisplayObject*/}
					);
					LOG(5,"Pen error detected! Continue without pen support.",2);
					//if(msg)
					//	//PopUpManager.removePopUp(msg);
					//	msg.close();
					//msg=MyAlert2.show("Continue without pen support.","Pen error detected!",MyAlert2.OK);	
					break;
				case PenEvent.PEN_NO_SERVER:			// no server -- nothing to do
					LOG(5,"PenSocketServer not available.",2);
					break;
				case PenEvent.PEN_SERVER_DISCONNECT:	// user has stopped the server (or has firewalled it)! 
					LOG(5,"PenSocketServer is disconnected. Asking for reconnect.",2);
					get_envRef().listen(VCMMainScreen.ID_A_DISPLAY_QUERY, 
						{text:"Reconnect?", title:"PenSocketServer is disconnected", buttons:[
							{text:'Yes', type:ID_A_UI_QUERY_RECONNECT_PEN_SEVER, details:true}
							,{text:'No', type:ID_A_UI_QUERY_RECONNECT_PEN_SEVER, details:false}
							]
							/*,w:int, h:int, ico:DisplayObject*/}
					);
				
					
										//var f:Function=function (b:int):void
					//	{
					//	if(b==MyAlert2.YES)
					//		PenSocketHelper.connect();
					//	}
					//if(msg)PopUpManager.removePopUp(msg);
					//msg=MyAlert2.show("Reconnect?","PenSocketServer is disconnected.",MyAlert2.YES|MyAlert2.NO,null,f);
					break;
				case PenEvent.PEN_SERVER_CONNECT:			// pen server connected. wait for pen device info.
					LOG(5,"PenSocketServer connected",2);
					break;
				case PenEvent.PEN_CONNECT:					// pen device is ready
					LOG(5,"Pen device connected",2);
					get_envRef().listen(VCMMainScreen.ID_A_DISPLAY_NOTIFICATION, 
						{text:"Pen device connected.", title:"Pen connected"/*,w:int, h:int, ico:DisplayObject*/}
					);
					
										//if(msg)PopUpManager.removePopUp(msg);
					//msg=MyAlert2.show("Pen device connected.","Pen connected.",MyAlert2.OK);	
					break;
				case PenEvent.PEN_DISCONNECT:				// pen device disconnected.
					LOG(5,"Pen device disconnected!",2);
					get_envRef().listen(VCMMainScreen.ID_A_DISPLAY_NOTIFICATION, 
						{text:"Pen device disconnected.", title:"Pen disconnected"/*,w:int, h:int, ico:DisplayObject*/}
					);
					
										//if(msg)PopUpManager.removePopUp(msg);
					//msg=MyAlert2.show("Pen device disconnected.","Pen disconnected.",MyAlert2.OK);	
					break;
				case PenEvent.PEN_DATA:						// some graphic data from pen
					var lnObj:Object=
						PenSocketHelper.getLineObj(Model_selectedThickness, Model_selectedColor);
					if(!lnObj)break;
					//LOG(5,"PEN_DATA: np="+lnObj.npoints);
					//lnObj.w=Model_selectedThickness;
					//lnObj.c=Model_selectedColor;					
					draw_addNewObject(lnObj);
					break;
				}
			}
		/** call Send2WB() on fms **/
		private function draw_addNewObject(rawData:Object):void {
			sendFmsCommand("Send2WB", [rawData, Model_selectedPage]);
		}
		/** direct calls on fms **/
		private function sendFmsCommand(cmdName:String, param:Array=null):void{
			LOG(3,"WB::sendFmsCommand("+cmdName+"): param="+traceObject(param),0);
			listen(ID_A_SEND_DATA, {cmdName:cmdName, param:param});	
		}
		//} =*^_^*= =*^_^*= END OF real pen interface
		
		private function loadWBDataFromFS(file:Object):void {
			//{id:file.id, fname:file.fname, dir:file.dir}
			var fileURL:String=a.get_ds().get_startupPathsList().get_fileServerRoot()+'/'+file.dir+'/'+file.fname;
			log(3, 'loadWBDataFromFS>fileURL='+fileURL, 0);
			new GenericDataRequest(
				function (data:Object, errorOccurred:Boolean):void {
					if (errorOccurred) {
						log(5, 'loadWBDataFromFS>failed to load wb file data, url='+fileURL, 2);
						return;
					}
					//
					var wbData:Object=JSON.parse(data);
					log(3, 'parsed successfully, data:', LOGGER.traceObject(wbData));
					// load to fms
					nca.call(SP.METHOD_RTMP_WHITEBOARD_LOAD_WB_DATA, [wbData]);	
				}
				,fileURL
				,1
			);
			
			
		}
		
		private var firstFreeFolder:Object;
		
		
		
		private function el_soa(target:FMSSOWBAdaptor, eventType:uint, eventData:Object):void {
			//log(0,'el_soa>'+['ID_E_FAILED_TO_CONNECT','ID_E_CONNECTED','ID_E_REACT'][eventType],2)
			// forward events to the system
			switch (eventType) {
			
			case FMSSOWBAdaptor.ID_E_FAILED_TO_CONNECT:
				e.listen(ID_E_CONNECTION_ERROR, null);
				break;
				
			case FMSSOWBAdaptor.ID_E_CONNECTED:
				e.listen(ID_E_CONNECTED, null);
				break;
			
			case FMSSOWBAdaptor.ID_E_REACT:
				// reroute to model
				
				if (eventData[0]==FMSSOWBAdaptor.ID_M_SELECTPAGE && (eventData[2]!=a.get_ds().get_clientUserId()) && a.get_ds().get_clientUserData().get_isLector()) {break;}
				M.addUpdate(new WBUpdateModelMessage(eventData[0], eventData[1], eventData[2], parseInt(soa.getWBFullData().pages.length)));
				//projectDataUpdatePacket(eventData);
				break;
			
			}
		}
		
		private function projectDataUpdatePacket(a:WBUpdateModelMessage):void {
			//log(2, 'projectDataUpdatePacket>'+LOGGER.traceObject(a.toObject()),0);
			var methodName:String=a.getMethodName();
			
			
			// exception 1:
			if (methodName==FMSSOWBAdaptor.ID_M_INITALL) {
				vcRef.fromData(a.getArgument0());
				vcRef.setSelPage(a.getArgument1());
				return;
			}
			var ar:Array=[a.getArgument0()];
			if (a.getArgument1()!=null) {ar.push(a.getArgument1());}
			
			/**
			 * makeshift^_^
			 * source, dest
			 */
			var routeTable:Array = [ 
				[FMSSOWBAdaptor.ID_M_ADDBG, vcRef.addBG]
				,[FMSSOWBAdaptor.ID_M_ADDDATA, vcRef.addDataItem]
				,[FMSSOWBAdaptor.ID_M_ADDPAGE, vcRef.addPage]
				//,[FMSSOWBAdaptor.ID_M_DELDATA, vcRef.delDataItemS]
				,[FMSSOWBAdaptor.ID_M_NEW_OBJECTS_LIST, vcRef.fromServer__removeObject]
				,[FMSSOWBAdaptor.ID_M_DELPAGE, vcRef.delPage]
				//,[FMSSOWBAdaptor.ID_M_INITALL, vcRef.fromData] vcRef.selPage
				,[FMSSOWBAdaptor.ID_M_SELECTPAGE, vcRef.setSelPage]
				,[FMSSOWBAdaptor.ID_M_UNDODATA, vcRef.undo]
				,[FMSSOWBAdaptor.ID_M_CLEAR_PAGE, vcRef.clearPage]
			];
			
			var mN:String;
			var mR:Function;
			//var mA:Function;
			try {
				for each(var i:Array in routeTable) {
					mN=i[0];
					if (methodName!=mN) {continue;}
					mR=i[1];
					mR.apply(vcRef, ar);
				}
			} catch (e:Error) {
				log(0,'wb>'+e.getStackTrace(),1);
			}
		}
		
		
		private function el_nca(target:FMSServerAdaptor, eventType:String, eventData:Object):void {
		/*	if (eventType==FMSServerAdaptor.ID_E_RESULT_SUCCESS) {
				//clear text field
				e.listen(VCMChat.ID_A_SET_TEXT_INPUT, "");
				return;
			}
			//error occured
			log(5, NAME+'>some error occured at el_nca() - responder error', 2);
		*/}
		
		//{ =*^_^*= private 
		/**
		 * initialize after fms connector is ready
		 */
		private var soa:FMSSOWBAdaptor;
		private var nca:FMSServerAdaptor;
		private var vcRef:VCWB;
		//} =*^_^*= END OF private
		
		
		//{ =*^_^*= model
		/**
		 * @param	a updatedPropertiesIDList
		 */
		private function el_M(targetModel:SSTM, elementID:uint, updateFromDataport:Boolean=false):void {
			switch (elementID) {
			
			case SSTM.ID_P_A_RESET_MODEL:
				//some special actions
				vcRef.clearWBCompletely();
				break;
			
			case WBComModel.ID_P_ZOOM_POSITION:
				var p:Point=M.get_zoomPosition();
				e.listen(VCMWhiteboard.ID_A_SET_POSITION, [p.x, p.y]);
				break;
				
			case WBComModel.ID_P_ZOOM:
				e.listen(VCMWhiteboard.ID_A_SET_ZOOM, M.get_zoom());
				break;
				
			case WBComModel.ID_P_UPDATES:
				var nm:Array=M.get_newUpdatesList();
				for each(var i:WBUpdateModelMessage in nm) {
					projectDataUpdatePacket(i);
				}
				break;
				
			}
		}
		
		private var M:WBComModel;
		// TODO: Сделать нормальную модель.
		private var Model_selectedPage:int=-1;
		private var Model_selectedThickness:int=3;
		private var Model_selectedColor:int=0;
		
		//} =*^_^*= END OF model
		
		private function get e():AEApp {return get_envRef();}
		private var a:Application;		
		
		//{ =*^_^*= id
		public static const ID_A_RUN:String=NAME+'>ID_A_RUN';
		public static const ID_A_CONNECT:String=NAME+'>ID_A_CONNECT';
		public static const ID_A_SEND_DATA:String=NAME+'>ID_A_SEND_DATA';
		/**
		 * details:Boolean
		 */
		public static const ID_A_UI_QUERY_RECONNECT_PEN_SEVER:String=NAME+'>ID_A_UI_QUERY_RECONNECT_PEN_SEVER';
		//} =*^_^*= END OF id
		
		//{ =*^_^*= events
		public static const ID_E_CONNECTED:String=NAME+'>ID_E_CONNECTED';
		public static const ID_E_FAILED_TO_CONNECT:String=NAME+'>ID_E_FAILED_TO_CONNECT';
		//} =*^_^*= END OF events
		
		
		public static const NAME:String = 'MWhiteboard';
		
		public override function autoSubscribeEvents():Array {
			return [
				ID_A_RUN
				,ID_A_CONNECT
				,ID_A_UI_QUERY_RECONNECT_PEN_SEVER
				,VCMWhiteboard.ID_A_REGISTER_SINGLETON_VC
				,VCMCourseLoader.ID_E_FIRST_FREE_FOLDER_ID
				,VCMWhiteboard.ID_E_SELECT_THICKNESS
				,VCMWhiteboard.ID_E_SELECT_COLOR
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