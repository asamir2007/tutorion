// Project TTCC
package ttcc.c.ma {
	
	//{ =*^_^*= import
	import flash.desktop.Clipboard;
	import flash.desktop.ClipboardFormats;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.ByteArray;
	import flash.utils.getTimer;
	import flash.utils.Timer;
	import ttcc.APP;
	import ttcc.Application;
	import ttcc.c.ae.AEApp;
	import ttcc.c.ae.DE;
	import ttcc.c.vcm.VCMReplay;
	import ttcc.cfg.SP;
	import ttcc.d.a.ARO;
	import ttcc.d.m.AbstractModel;
	import ttcc.d.s.ReplayInfo;
	import ttcc.d.s.UpdateDataEvent;
	import ttcc.LOG;
	import ttcc.LOGGER;
	import ttcc.media.Text;
	//} =*^_^*= END OF import
	
	
	/**
	 * chat manager - ctrl chat
	 * @author Jinanoimatey Dragoncat
	 * @version 0.0.0
	 * @created 05.08.2012 22:51
	 */
	public class MReplay extends AM {
		
		//{ =*^_^*= CONSTRUCTOR
		
		function MReplay (app:Application, replayMode:Boolean) {
			super(NAME);
			a=app;
			this.recordMode=!replayMode;
		}
		//} =*^_^*= END OF CONSTRUCTOR
		
		public function subscribeForDE():void {
			de.subscribe(this, DE.ID_A_REGISTER_MODEL);			
		}
		
		public override function listen(eventType:String, details:Object):void {
			//var r:ARO;
			
			switch (eventType) {
				
				case ID_A_RUN:
					playTimerPrepare();
					if (recordMode) {startRecording();}
					break;
					
				case ID_A_PROCESS_LOADED_FILE_DATA:
					prepareReplayDataForPlaying(details.ri, details.evl);
					break;
					
				case DE.ID_A_REGISTER_MODEL:
					connectToModel(details);
					break;
					
				case VCMReplay.ID_E_BUTTON_RECORD:
					currentReplayID=uint(Math.random()*uint.MAX_VALUE)+'_'+new Date().setDate();
					startNewRecording();
					e.listen(VCMReplay.ID_A_SET_MODE_RECORD, {paused:!recording});
					e.listen(ID_E_RECORD_START, currentReplayID);
					break;
					
				case VCMReplay.ID_E_BUTTON_RECORD_STOP:
					endRecording();
					e.listen(ID_E_RECORD_END, null);
					break;
					
				case VCMReplay.ID_E_BUTTON_PLAY:
					//for testing purpose: first time run without system prepare
					/*if (events==null) {	clearState();reflectCurrentSate();}*/
					if (!playing) {
						play();
						e.listen(ID_E_PLAYBACK_RESUME, null);
					}
					break;
					
				case VCMReplay.ID_E_BUTTON_STOP:
					if (playing) {
						pause();
						e.listen(ID_E_PLAYBACK_PAUSE, null);
					}
					break;
					
				case VCMReplay.ID_E_SEEK_START:
					playTimeStartSeek=playbackCurrentTime;
					playbackPlayingAtStartSeek=playing;
					pause();
					e.listen(ID_E_SEEK_START, null);
					break;
					
				case VCMReplay.ID_E_SEEK_END:
					playbackCurrentTime=(details)*1000;
					skipTo(playbackCurrentTime);
					if (playbackPlayingAtStartSeek) {resumePlayback();}
					e.listen(ID_E_SEEK_END, details);
					break;
					
			}
		}
		
		
		//{ =*^_^*= =*^_^*= record
		/**
		 * first time
		 */
		private function startRecording():void {
			if (!prepared) {prepared=true;
				recordSN=77;
				events=[];
			}
			e.listen(VCMReplay.ID_A_SET_MODE_RECORD, {paused:true});
		}
		
		private function startNewRecording():void {
			// create start marker
			startMarkerSN=getNextSN();
			//log(0,'startNewRecording>',1);
			//log(0,'startNewRecording>startMarkerSN '+startMarkerSN,1);
			var em:UpdateDataEvent=new UpdateDataEvent;
			em.construct(null, startMarkerSN, getTimestamp(), NAME, 0);
			//em.set_markerType(UpdateDataEvent.ID_TYPE_MARKER_START);
			events.push(em.toObject());
			// end
			
			
			timeOffset=getTimer();
			recording=true;
			e.listen(VCMReplay.ID_A_SET_MODE_RECORD, {paused:true});
		}
		
		private function endRecording():void {
			recording=false;
			// create end marker, place it
			endMarkerSN=getNextSN();
			//log(0,'endRecording>'+endMarkerSN,1);
			
			var em:UpdateDataEvent=new UpdateDataEvent;
			em.construct(0, endMarkerSN, getTimestamp(), NAME, 0);
			//em.set_markerType(UpdateDataEvent.ID_TYPE_MARKER_END);
			events.push(em.toObject());
			// end
			
			//save
			// write duration as well as other replay info
			var replayInfoC:UpdateDataEvent=new UpdateDataEvent;
			var replayInfoIS:ReplayInfo=new ReplayInfo(
				getTimestamp()
				,a.get_ds().get_startupEnvData()
				,a.get_ds().get_clientUserData()
				,startMarkerSN
				,endMarkerSN
				,currentReplayID
			);
			
			replayInfoC.construct(
				replayInfoIS.toObject()
				, S_REPLAY_INFO_PACKET_SN
				, getTimestamp()
				, NAME
				, 0
			);
			
			//log(0,'from'+replayInfoIS.get_startMarkerSN()+' to:'+replayInfoIS.get_endMarkerSN(),1);
			
			// remove old replay info
			if (UpdateDataEvent.fromObject(events[0]).get_sn()==S_REPLAY_INFO_PACKET_SN) {events.shift();}
			
			events.unshift(replayInfoC.toObject());
			
			
			// save
			//var ba0:ByteArray=new ByteArray();
			//var data:String=JSON.stringify(events);
			//ba0.writeUTFBytes(data);
			//e.listen(MApp.ID_A_SAVE_REPLAY, {ba:ba0});
			//LOG(0, 'replay data has been dubbed to the clipboard', 0);
			//Clipboard.generalClipboard.setData(ClipboardFormats.TEXT_FORMAT, data);
			
			var baD:ByteArray=new ByteArray();
			baD.writeObject(events);
			baD.compress();
			baD.position=0;
			e.listen(MApp.ID_A_SAVE_REPLAY, {ba:baD});
			
			//LOG(1, 'REPLAY DATA:\n'+LOGGER.traceObject(events), 0);
			//LOG(0, 'replay data has been dubbed to the clipboard', 0);
			//Clipboard.generalClipboard.setData(ClipboardFormats.TEXT_FORMAT, LOGGER.traceObject(events));
			
			e.listen(VCMReplay.ID_A_SET_MODE_RECORD, {paused:!recording});
		}
		
		private function dataReceiver(modelID:String, elementID:uint, rawData:Object):void {
			if (/*!recording||*/!recordMode) {return;}
			if (rawData==null) {log(2,NAME+'>dataReceiver>null data received from model:'+modelID+'elementID='+elementID,1);}
			var dataEvent:UpdateDataEvent=new UpdateDataEvent;
			dataEvent.construct(rawData, getNextSN(), getTimestamp(), modelID, elementID);
			events.push(dataEvent.toObject());
			//getModelByID(modelID).receiveUpdate(elementID, rawData);
			//log(1, 'ModelUpdate:>'+[modelID+' ;elementID:', elementID+' ;rawData:', LOGGER.traceObject(rawData)], 2);
		}
		
		private function getNextSN():Number {recordSN+=1;return recordSN;}
		
		public static const S_REPLAY_INFO_PACKET_SN:Number=0;
		
		private var startMarkerSN:Number;
		private var endMarkerSN:Number;
		private var timeOffset:int;
		private var recordSN:Number;
		private var prepared:Boolean;
		private var recording:Boolean;
		private var events:Array;
		private var replayInfo:ReplayInfo;
		//} =*^_^*= =*^_^*= END OF record
		
		//{ =*^_^*= =*^_^*= playback
		private function skipTo(time:Number):void {
			log(4,'skipTo'+time,1);
			playbackEnded=false;
			setUpdateReflexBlock(true);
			clearState();
			loadState(time);
			setUpdateReflexBlock(false);
			reflectCurrentSate();
		}
		private function endReplay():void {
			pause();
			playbackCurrentTime=0;
			playbackEnded=true;
			e.listen(ID_E_PLAYBACK_PAUSE, null);
		}
		private function pause():void {
			playing=false;
			playTimerPause();
			e.listen(VCMReplay.ID_A_SET_MODE_PLAY, {paused:!playing});
		}
		private function play():void {
			if (playbackEnded) {
				playbackEnded=false;
				skipTo(playbackCurrentTime);
				e.listen(ID_E_SEEK_END, playbackCurrentTime);
			}
			playing=true;
			playTimerStart();
			e.listen(ID_E_SET_REPLAY_STARTS_AT, getEventBySN(events, startMarkerSN).get_timestamp());
			e.listen(ID_E_SET_REPLAY_ID, replayInfo.get_replayID());
			e.listen(VCMReplay.ID_A_SET_MODE_PLAY, {paused:!playing});
		}
		private function resumePlayback():void {
			if (playbackEnded) {
				playbackEnded=false;
				skipTo(playbackCurrentTime);
			}
			
			playing=true;
			playTimerResume();
			e.listen(ID_E_SET_REPLAY_STARTS_AT, getEventBySN(events, startMarkerSN).get_timestamp());
			e.listen(ID_E_SET_REPLAY_ID, replayInfo.get_replayID());
			e.listen(VCMReplay.ID_A_SET_MODE_PLAY, {paused:!playing});
			
		}
		private function prepareReplayDataForPlaying(ri:ReplayInfo, evl:Array):void {
			lastPlayedEventSN=0;
			playbackCurrentTime=0;
			
			//
			events=evl;
			replayInfo=ri;
			endMarkerSN=ri.get_endMarkerSN();
			startMarkerSN=ri.get_startMarkerSN();
			
			a.get_ds().set_startupEnvDataReplay(replayInfo.get_appEnvData());
			a.get_ds().set_startupEnvDataReplay(replayInfo.get_appEnvData());
			//
			
			e.listen(ID_E_SET_REPLAY_STARTS_AT, getEventBySN(events, startMarkerSN).get_timestamp());
			e.listen(ID_E_SET_REPLAY_ID, replayInfo.get_replayID());
			
			e.listen(VCMReplay.ID_A_SET_MODE_PLAY, {paused:!playing});
			e.listen(VCMReplay.ID_A_SET_RECORD_DURATION, replayInfo.get_duration()/1000);
			
			//seek to end
			loadState(0);
		}
		private function clearState():void {
			for each(var i:AbstractModel in modelsByID) {i.reset();}
		}
		private function loadState(timestamp:Number):void {
			var res:Array=[];
			lastPlayedEventSN=0;
			//log(0,'seek, record SN offset:'+startMarkerSN);
			//log(0,'seek, existing events:'+events.length);
			for each(var i:UpdateDataEvent in events) {
				//log(0,'event#'+i.get_sn(),0);
				// TODO: CHECK code: if start marker meet while seeking start of record - break;
				// TODO: CHECK code: check sn==replayInfoStartMarkerSN
				if (timestamp<=0 && i.get_sn()==startMarkerSN) {
					//log(0,'resetMode && i.get_sn()==startMarkerSN!, sn='+startMarkerSN, 2);
					break;
				}
				if (i.get_timestamp()<=timestamp||i.get_sn()<=startMarkerSN) {
					res.push(i);
					if (lastPlayedEventSN<i.get_sn()) {lastPlayedEventSN=i.get_sn();}
				} else {
					//log(0, 'no match:'+i.get_sn(),1);
				}
			}
			
			//log(0,'seek, total events:'+res.length);
			if (res.length>0) {
				processPlayEvents(res);
			}
		}
		private function reflectCurrentSate():void {
			for each(var i:AbstractModel in modelsByID) {i.reflectAll();}
		}
		private function setUpdateReflexBlock(block:Boolean):void {
			for each(var i:AbstractModel in modelsByID) {i.setUpdateReflexBlock(block);}	
		}
		
		private function processPlayEvents(a:Array):void {
			// feed to model
			for each(var i:UpdateDataEvent in a) {
				if (i.get_ownerID()==NAME) {continue;}//skip rep man events
				
				var m:AbstractModel=getModelByID(i.get_ownerID())
				if (!m) {log(4, 'no model found, id:'+i.get_ownerID(),1);continue;}
				
				m.receiveUpdate(i.get_propertyID(), i.get_rawData());
				log(2, '>receiveUpdate to: '+i.get_ownerID()+'::'+i.get_propertyID()+"\nDATA:\n"+LOGGER.traceObject(i.get_rawData())+'\n=====================', 0);
				/*if (i.get_ownerID()=='VCMainPanelUsersListElementComModel') {
					trace('>receiveUpdate to: '+'::'+i.get_propertyID()+"\nDATA:\n"+LOGGER.traceObject(i.get_rawData())+'\n=====================');
				}*/
			}
		}
		
		private function onPlayTimer():void {
			playbackCurrentTime+=getTimer()-timeOffset;
			timeOffset=getTimer();
			
			if (playbackCurrentTime>=replayInfo.get_duration()) {endReplay();return;}
			if (playbackSecondPassed!=uint(playbackCurrentTime/1000)) {
				playbackSecondPassed=getPlaybackCurrentTimeSeconds();
				e.listen(VCMReplay.ID_A_SET_SEEKBAR_POSITION, getPlaybackCurrentTimeSeconds());
			}
			
			var res:Array=[];
			for each(var i:UpdateDataEvent in events) {
				//{ case is only valid with multi record files
				//if (i.get_sn()==endMarkerSN) {break;}
				//}
				
				if (playbackCurrentTime>=i.get_timestamp() && i.get_sn()>lastPlayedEventSN) {
					res.push(i);
					if (lastPlayedEventSN<i.get_sn()) {lastPlayedEventSN=i.get_sn();}
				}
			}
			
			if (res.length>0) {
				processPlayEvents(res);
			}
		}
		
		
		//{ =*^_^*= timer
		private function playTimerPrepare():void {
			playTimer = new Timer(30);
			playTimer.addEventListener(TimerEvent.TIMER, el_playTimer);
		}
		private function playTimerStart():void {
			timeOffset=getTimer();
			playTimer.reset();playTimer.start();
		}
		private function playTimerPause():void {
			playbackCurrentTime+=getTimer()-timeOffset;
			playTimer.stop();
		}
		private function playTimerResume():void {
			timeOffset=getTimer();
			playTimer.reset();playTimer.start();
		}
		private function el_playTimer(e:Event):void {onPlayTimer();}
		private var playTimer:Timer;
		//} =*^_^*= END OF timer
		
		public function getPlaybackCurrentTimeSeconds():Number {return playbackCurrentTime/1000;}
		private var playTimeStartSeek:Number=0;
		private var playing:Boolean;
		private var playbackPlayingAtStartSeek:Boolean;
		private var lastPlayedEventSN:Number=0;
		private var playbackSecondPassed:uint;
		private var playbackCurrentTime:Number=0;
		private var playbackEnded:Boolean;
		private var currentReplayID:String;
		//} =*^_^*= =*^_^*= END OF playback
		
		
		//{ =*^_^*= =*^_^*= both
		public static function getEventBySN(events:Array, sn:Number):UpdateDataEvent {
			for each(var i:UpdateDataEvent in events) {
				if (i.get_sn()==sn) {return i;}
			}
			return null;
		}
		
		private function removeEvent(e:UpdateDataEvent):void {
			if (events.indexOf(e)==-1) {return;}
			events.splice(events.indexOf(e), 1);
		}
		
		private function getTimestamp():Number {return getTimer()-timeOffset;}
		//} =*^_^*= =*^_^*= END OF both
		
		
		private function connectToModel(m:AbstractModel):void {
			log(7,NAME+'>register model:'+m.get_id(),1);
			m.set_rawDataReceiver(dataReceiver);
			modelsByID[m.get_id()]=m;
		}
		
		//{ =*^_^*= private 
		private function getModelByID(id:String):AbstractModel {return modelsByID[id];}
		private var modelsByID:Array=[];
		private var recordMode:Boolean;
		//} =*^_^*= END OF private
		
		public static function deserializeArray(list:Array, c:Class):Array {
			var b:Array=[];
			for each(var i:Object in list) {b.push(c["fromObject"](i));}
			return b;
		}
		
		
		
		private function get e():AEApp {return get_envRef();}
		private function get de():DE {return a.get_de();}
		private var a:Application;		
		
		//{ =*^_^*= id
		public static const ID_A_RUN:String=NAME+'>ID_A_RUN';
		/**
		 * {ri:ReplayInfo, evl:[UpdateDataEvent]}
		 */
		public static const ID_A_PROCESS_LOADED_FILE_DATA:String=NAME+'>ID_A_PROCESS_LOADED_FILE_DATA';
		//} =*^_^*= END OF id
		
		//{ =*^_^*= events
		/**
		 * String//currentReplayID//
		 */
		public static const ID_E_RECORD_START:String=NAME+'>ID_E_RECORD_START';
		public static const ID_E_RECORD_END:String=NAME+'>ID_E_RECORD_END';
		public static const ID_E_SEEK_START:String=NAME+'>ID_E_SEEK_START';
		/**
		 * currentSystemTime
		 */
		public static const ID_E_SEEK_END:String=NAME+'>ID_E_SEEK_END';
		public static const ID_E_PLAYBACK_PAUSE:String=NAME+'>ID_E_PLAYBACK_PAUSE';
		public static const ID_E_PLAYBACK_RESUME:String=NAME+'>ID_E_PLAYBACK_RESUME';
		/**
		 * miliseconds
		 */
		public static const ID_E_SET_REPLAY_STARTS_AT:String = NAME + '>ID_E_SET_REPLAY_STARTS_AT';
		/**
		 * String//id//
		 */
		public static const ID_E_SET_REPLAY_ID:String = NAME + '>ID_E_SET_REPLAY_ID';
		//} =*^_^*= END OF events
		
		
		public static const NAME:String = 'MReplay';
		
		public override function autoSubscribeEvents():Array {
			return [
				ID_A_RUN
				,VCMReplay.ID_E_BUTTON_PLAY
				,VCMReplay.ID_E_BUTTON_RECORD
				,VCMReplay.ID_E_BUTTON_RECORD_STOP
				,VCMReplay.ID_E_BUTTON_STOP
				,VCMReplay.ID_E_SEEK_END
				,VCMReplay.ID_E_SEEK_START
				,ID_A_PROCESS_LOADED_FILE_DATA
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