// Project TTCC
package ttcc.c.v {
	
	//{ =*^_^*= import
	import flash.events.TimerEvent;
	import flash.media.Camera;
	import flash.media.Microphone;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.utils.Timer;
	import ttcc.APP;
	import ttcc.c.v.AVGUIController;
	import ttcc.cfg.AppCfg;
	import ttcc.d.a.DUUD;
	import ttcc.d.i.ISerializable;
	import ttcc.LOG;
	import ttcc.media.Text;
	import ttcc.n.connectors.NetStreamConnector;
	//} =*^_^*= END OF import
	
	
	/**
	 * 
	 * @author Jinanoimatey Dragoncat
	 * @version 0.0.0
	 * @created 02.08.2012 3:28
	 */
	public class AVUser implements ISerializable {
		
		//{ =*^_^*= CONSTRUCTOR
		function AVUser (u:DUUD, fmsNetConnectorRef:NetConnection):void {
			this.fmsNetConnectorRef=fmsNetConnectorRef;
			constructNC();
			ud=u;
			video=new Video(AppCfg.AV_VIDEO_DEFAULT_W, AppCfg.AV_VIDEO_DEFAULT_H);
			var un:String=u.get_displayName();
			if (un==null) {un=APP.lText().get_TEXT(Text.ID_TEXT_VIDEO_CL_USER_NAME_IS_EMPTY);}
			guiController=new AVGUIController(u.get_id(), null, u.get_avatarPicture(), un);
		}
		public function destruct():void {
			stopAndDisposeTimer();
			guiController.destruct();
			guiController=null;video=null;ud=null;fmsNetConnectorRef=null;
			destructNC();
		}
		
		
		public function destructNC():void {
			nsc.destruct();
			nsc=null;
		}
		public function constructNC():void {
			nsc=new NetStreamConnector;
			nsc.constuct(el_nsc, fmsNetConnectorRef);
		}
		//} =*^_^*= END OF CONSTRUCTOR
		
		/**
		 * @param playing - pause() || resume()
		 */
		public function setPlaybackState(playing:Boolean):void {
			//LOG(0,'setPlaybackState>'+playing,1);
			if (playing) {nsc.get_ns().resume();}
			else {nsc.get_ns().pause();}
		}
		public function seek(currentSystemTime:Number):void {
			//LOG(0, 'seek>currentSystemTime:'+currentSystemTime,1);
			//LOG(0, 'seek>replayTimeOffset:'+replayTimeOffset,0);
			//LOG(0, 'seek>ud.get_streamAddedTime():'+ud.get_streamAddedTime(),0);
			var sTime:uint=Math.max(0, (currentSystemTime+replayTimeOffset-
				Math.max(replayTimeOffset,ud.get_streamAddedTime())
			))
			//LOG(0, 'nsc.get_ns().seek('+sTime+');',0);
			nsc.get_ns().seek(sTime);
		}
		public function setReplayTimeOffset(a:uint):void {
			replayTimeOffset=a;
		}
		
		public function recordStart():void {
			//nsc.get_ns().close();
			publishToStream(camera,microphone,true);
		}
		public function recordEnd():void {
			//nsc.get_ns().close();
			publishToStream(camera,microphone,false);
		}
		
		public function playFromStream(replayID:String):void {
			streamDirectionIsIncoming=true;
			video.attachNetStream(nsc.get_ns());
			// TODO: 
			//nsc.get_ns().bufferTime=vlist.styl["bufferTimeIn"];
			// TODO: 
			//nsc.get_ns().bufferTimeMax=vlist.styl["bufferTimeInMax"];
			//nsc.get_ns().bufferTimeMax=1;
			//nsc.get_ns().bufferTime=1;
			
			nsc.get_ns().client={streamState:el_s_streamState};
			nsc.ns_play(replayID+ud.get_streamName());
			//LOG(0, 'nsc.ns_play>'+ud.get_streamName());
			
			updateView(true);
		}
	
		public function publishToStream(camera:Camera, microphone:Microphone, streamrecordMode:Boolean=false):void {
			this.camera=camera;this.microphone=microphone;
			streamDirectionIsIncoming=false;
			nsc.get_ns().audioReliable=false;nsc.get_ns().videoReliable=false;nsc.get_ns().dataReliable=true;
			// TODO: 
			//ns.bufferTime=ns2.bufferTime=vs.styl["bufferTimeOut"];
			nsc.get_ns().bufferTimeMax=1;
			nsc.get_ns().bufferTime=1;
			// TODO: 
			//ns.bufferTimeMax=ns2.bufferTimeMax=vs.styl["bufferTimeOutMax"];
			
			nsc.get_ns().publish(ud.get_streamName(), (streamrecordMode)?"record":"live");
			
			//ssi_videoIsOn=true;//already configured before method invocation
			//ssi_audioIsOn=true;//already configured before method invocation
			
			prepareAndRunTimer();
			updateView(true);
		}
	
		private var camera:Camera;
		private var microphone:Microphone;
		
		
		//{ =*^_^*= stream state information exchange
		private function stopAndDisposeTimer():void {
			if (!timer) {return;}
			timer.removeEventListener(TimerEvent.TIMER, el_timer);
			timer.stop();timer = null;
		}
		private function prepareAndRunTimer():void {
			timer = new Timer(500);
			timer.addEventListener(TimerEvent.TIMER, el_timer);
			timer.start();
		}
		
		private function el_s_streamState(o:Object):void {
			//LOG(0,'str state for id#'+ud.get_name()+':'+o.videoAvailable+'/'+o.audioAvailable,2);
			if (!override_ssi_videoIsOn) {set_ssi_videoIsOn(o.videoAvailable);}
			if (!override_ssi_audioIsOn) {set_ssi_audioIsOn(o.audioAvailable);}
			//set_ssi_audioIsOn((o.audioAvailable)?a.microphoneActivityLevel:0);
			if (!o.audioAvailable||isNaN(o.microphoneActivityLevel)) {o.microphoneActivityLevel=0;}
			
			var volumeLevel:Number;
			//volumeLevel=Math.max(0,(o.microphoneActivityLevel+1)/(prevVolumeLevel+1));
			volumeLevel=Math.log(o.microphoneActivityLevel)*10;
			
			//prevVolumeLevel=o.microphoneActivityLevel;
			
			guiController.set_volumeLevel(volumeLevel);//0..100
			
			if (auxController) {auxController.set_volumeLevel(o.microphoneActivityLevel/4);}
		}
		//private var prevVolumeLevel:uint=0;
		
		private function el_timer(e:TimerEvent):void {
			if (!nsc || !nsc.get_ns()) {LOG(5,'!nsc || !nsc.get_ns()', 1);return;}
			var microphone_activityLevel:Number=0;
			if (microphone) {microphone_activityLevel=microphone.activityLevel;}
			nsc.get_ns().send("@setDataFrame", "streamState", {
					videoAvailable:ssi_videoIsOn
					,audioAvailable:(ssi_audioIsOn&&(microphone!=null))
					,microphoneActivityLevel:microphone_activityLevel
			});
			guiController.set_volumeLevel(Math.log(microphone_activityLevel)*10);
			if (auxController) {auxController.set_volumeLevel(microphone_activityLevel/4);}
		}
		
		private var timer:Timer;
		//} =*^_^*= END OF stream state information exchange
		
		//{ =*^_^*= stream state information
		public function get_ssi_videoIsOn():Boolean {return ssi_videoIsOn;}
		public function get_ssi_audioIsOn():Boolean {return ssi_audioIsOn;}
		public function set_ssi_videoIsOn(a:Boolean):void {ssi_videoIsOn = a;updateView();}
		public function set_ssi_audioIsOn(a:Boolean):void {ssi_audioIsOn = a;updateView();}
	
		//public function get_override_ssi_audioIsOn():Boolean {return override_ssi_audioIsOn;}
		//public function get_override_ssi_videoIsOn():Boolean {return override_ssi_videoIsOn;}
		/**
		* when set to true, ssi_audioIsOn value will not be synced with one in incoming stream state data
		*/
		public function set_override_ssi_audioIsOn(a:Boolean):void {override_ssi_audioIsOn = a;}
		/**
		* when set to true, ssi_audioIsOn value will not be synced with one in incoming stream state data
		*/
		public function set_override_ssi_videoIsOn(a:Boolean):void {override_ssi_videoIsOn = a;}
		
		//public function get_videoReceptionState():uint {return videoReceptionState;}
		//public function set_videoReceptionState(a:uint):void {videoReceptionState = a;}
		//private var videoReceptionState:uint=2;
		
		private var ssi_videoIsOn:Boolean=true;//default setting
		private var ssi_last_videoIsOn:Boolean;
		private var ssi_audioIsOn:Boolean=true;//default setting
		private var ssi_last_audioIsOn:Boolean;
		
		private var override_ssi_audioIsOn:Boolean;
		private var override_ssi_videoIsOn:Boolean;
		//} =*^_^*= END OF stream state information
		
		private function updateView(firstRun:Boolean=false):void {
			if ((ssi_videoIsOn!=ssi_last_videoIsOn)||firstRun) {ssi_last_videoIsOn=ssi_videoIsOn;
				if (streamDirectionIsIncoming) {
					//LOG(0,'>>>>>nsc.ns_receiveVideo('+ssi_videoIsOn+')',0);
					nsc.ns_receiveVideo(ssi_videoIsOn);
				} else {
					video.attachCamera((ssi_videoIsOn)?camera:null);
					nsc.get_ns().attachCamera((ssi_videoIsOn)?camera:null);
				}
				
				if (auxController) {/*LOG(0,'auxController present in:'+ud.get_id(),2);*/
					if (ssi_videoIsOn) {auxController.displayVideo();
					} else {auxController.displayUserpic();}
				}
				guiController.displayUserpic();
			}
			
			if ((ssi_audioIsOn!=ssi_last_audioIsOn)||firstRun) {ssi_last_audioIsOn=ssi_audioIsOn;
				guiController.set_hasAudio(ssi_audioIsOn);
				if (auxController) {auxController.set_hasAudio(ssi_audioIsOn);}
				if (streamDirectionIsIncoming) {
					nsc.ns_receiveAudio(ssi_audioIsOn);
					//LOG(0,'>>>>>nsc.ns_receiveAudio('+ssi_audioIsOn+')',0);
				} else {
					nsc.get_ns().attachAudio((ssi_audioIsOn)?microphone:null);
					guiController.set_hasAudio(ssi_audioIsOn);
					if (auxController) {auxController.set_hasAudio(ssi_audioIsOn);}
				}
			}
			
			if (firstRun) {guiController.notifyReady();if (auxController) {auxController.notifyReady();}}
		}
		
		private function el_nsc(target:NetStreamConnector, eventType:String, eventData:Object):void {
			//LOG(0,'el_nsc:'+eventType+'ed='+eventData,1);
		}
		
		
		//{ =*^_^*= general
		public function set_auxController(a:AVGUIController):void {
			auxController = a;
			if (!auxController) {return;}
			auxController.set_userDisplayName(ud.get_displayName());
			auxController.set_video(video);
			auxController.set_userAvatarPath(ud.get_avatarPicture());
			auxController.displayVideo();
			auxController.set_volumeLevel(0);
			//auxController.set_hasAudio(ssi_audioIsOn);
			updateView(true);
		}
		
		public function get_guiController():AVGUIController {return guiController;}
		public function get_video():Video {return video;}
		public function get_nsc():NetStreamConnector {return nsc;}
		public function get_ud():DUUD {return ud;}
		/**
		 * true - play, false - publish
		 */
		public function get_streamDirectionIsIncoming():Boolean {return streamDirectionIsIncoming;}
		
		private var nsc:NetStreamConnector;
		private var video:Video;
		private var ud:DUUD;
		private var guiController:AVGUIController;
		private var auxController:AVGUIController;
		private var streamDirectionIsIncoming:Boolean;
		private var fmsNetConnectorRef:NetConnection;
		private var replayTimeOffset:Number=0;
		//} =*^_^*= END OF general
		
		//{ =*^_^*= serialization
		public function toObject():Object {
			return {
				ud:ud.toObject()
			};
		}
		public static function fromObject(o:Object, fmsNetConnectorRef:NetConnection):AVUser {
			return new AVUser(DUUD.fromObject(o.ud), fmsNetConnectorRef);
		}
		//} =*^_^*= END OF serialization
			
	}
}

//{ =*^_^*= History
/* > (timestamp) [ ("+" (added) ) || ("-" (removed) ) || ("*" (modified) )] (text)
 * > 
 */
//} =*^_^*= END OF History

// template last modified:11.03.2011_[18#51#40]_[5]