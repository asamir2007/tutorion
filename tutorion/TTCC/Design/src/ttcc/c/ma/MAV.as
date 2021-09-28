// Project TTCC
package ttcc.c.ma {
	
	//{ =*^_^*= import
	import flash.events.StatusEvent;
	import flash.media.Camera;
	import flash.media.Microphone;
	import flash.system.SecurityPanel;
	import ttcc.APP;
	import ttcc.Application;
	import ttcc.c.ae.AEApp;
	import ttcc.c.v.AVGUIController;
	import ttcc.c.v.AVUser;
	import ttcc.c.vcm.VCMAV;
	import ttcc.c.vcm.VCMMainScreen;
	import ttcc.cfg.SP;
	import ttcc.d.a.ARO;
	import ttcc.d.a.DUAIUserAccessInfo;
	import ttcc.d.a.DUAUserInfo;
	import ttcc.d.a.DUUD;
	import ttcc.d.m.MavComModel;
	import ttcc.media.Text;
	import ttcc.n.a.FMSServerAdaptor;
	import ttcc.n.connectors.NetStreamConnector;
	//} =*^_^*= END OF import
	
	
	/**
	 * audio video manager
	 * @author Jinanoimatey Dragoncat
	 * @version 0.0.0
	 * @created 28.05.2012 21:04
	 */
	public class MAV extends ACMM {
		
		//{ =*^_^*= CONSTRUCTOR
		
		function MAV (app:Application) {
			super(NAME);
			a=app;
		}
		//} =*^_^*= END OF CONSTRUCTOR
		
		
		public override function listen(eventType:String, details:Object):void {
			var r:ARO;
			switch (eventType) {
				/**
				 * executed before ID_A_PREPARE
				 */
				case ID_A_PREPARE_MODEL:
					M=new MavComModel(a);
					M.setViewUpdatesListener(el_M);
					M.construct(NAME+'ComModel');
					registerModel(a, M);
					//default settings:
					M.set_settings_AudioReceptionState(true);
					M.set_settings_VideoReceptionState(true);
					
					M.set_settings_StreamState(true);
					
					//M.set_settings_AudioTransmissionState(true);
					//M.set_settings_VideoTransmissionState(a.get_ds().get_clientUserData().get_isLector());
				break;
				
				case ID_A_PREPARE:
					a.get_aer().subscribe(this, ID_A_GET_STREAM_INFO);
					
					this.replayMode=details.replayMode;
					prepareCamAndMic();
					videoGUIController=new AVGUIController(null, null, null, '<пользователь не выбран>');
					e.listen(VCMAV.ID_A_SET_PRIMARY_VIDEO, videoGUIController);
					
					//reflect default av permission state in gui
					e.listen(VCMAV.ID_A_SET_STATE_AU_OUT, M.get_settings_AudioTransmissionState());
					e.listen(VCMAV.ID_A_SET_STATE_V_OUT, M.get_settings_VideoTransmissionState());
					e.listen(ID_E_PREPARED, null);
					break;
				
				case ID_A_CONNECT:
					e.listen(MUserData.ID_A_REQUEST_USER_DATA_ACCESS_MEANS, {customer:NAME, ownerID:a.get_ds().get_clientUserId(), targetID:a.get_ds().get_clientUserId()});
					nca=new FMSServerAdaptor();
					nca.construct(el_nca, a.get_fmsNetConnectorRef());				
					
					e.listen(ID_E_CONNECTED, null);
					
					var c0:AVGUIController=new AVGUIController('str0', null, 'user3.jpg', 'user 0');
					e.listen(VCMAV.ID_A_SET_PRIMARY_VIDEO, c0);
					c0.displayUserpic();
					
					
					var c1:AVGUIController=new AVGUIController('str1', null, 'user3.jpg', 'user 1');
					e.listen(VCMAV.ID_A_ADD_VIDEO, c1);
					c1.displayUserpic();
					c1.set_hasAudio(true);
					
					var c2:AVGUIController=new AVGUIController('str2', null, 'user3.jpg', 'user 2');
					e.listen(VCMAV.ID_A_ADD_VIDEO, c2);
					c2.displayUserpic();
					c2.set_hasAudio(true);
					
					var c3:AVGUIController=new AVGUIController('str4', null, 'user3.jpg', 'user 6');
					e.listen(VCMAV.ID_A_ADD_VIDEO, c3);
					c3.displayUserpic();
					c3.set_hasAudio(true);
					
					var c4:AVGUIController=new AVGUIController('str3', null, 'user3.jpg', 'user 7');
					e.listen(VCMAV.ID_A_ADD_VIDEO, c4);
					c4.displayUserpic();
					c4.set_hasAudio(true);
					
					break;
					
				case MUserData.ID_E_USER_DATA_ACCESS_MEANS:
					if (details.customer==NAME) {
						// store
						duai=details.duai;
						dua=details.dua;
						e.listen(MUserData.ID_A_GET_USER_LIST_REF, null);
					}
					break;
					
				case MUserData.ID_E_USER_STREAM_NAME_PRESENT:
				case MUserData.ID_E_USER_STREAM_NAME_IS_EMPTY:
				case MUserData.ID_E_USER_LOGIN:
					processUser(details);
					break;
				case MUserData.ID_E_USER_LOGOUT:
					processUser(details, true);
					break;
					
				case MUserData.ID_E_USER_SOUND_OFF:
					//if (DUUD(details).get_id()!=a.get_ds().get_clientUserId()) {break;}
					e.listen(VCMAV.ID_A_SET_STATE_AU_OUT, false);
					break;
				case MUserData.ID_E_USER_SOUND_ON:
					//if (DUUD(details).get_id()!=a.get_ds().get_clientUserId()) {break;}
					e.listen(VCMAV.ID_A_SET_STATE_AU_OUT, true);
					break;
				case MUserData.ID_E_USER_STREAM_IS_OFF:
					//if (DUUD(details).get_id()!=a.get_ds().get_clientUserId()) {break;}
					e.listen(VCMAV.ID_A_SET_STATE_V_OUT, false);
					break;
				case MUserData.ID_E_USER_STREAM_IS_ON:
					//if (DUUD(details).get_id()!=a.get_ds().get_clientUserId()) {break;}
					e.listen(VCMAV.ID_A_SET_STATE_V_OUT, true);
					break;
				
				case MUserData.ID_E_USER_LIST_REF:
					processExistedUsers(details);
					break;
					
				case VCMAV.ID_E_B_SETTINGS:
					e.listen(MFlashPlatform.ID_A_SHOW_SECURITY_SETTINGS_CAMERA, null);
					break;
					
				case VCMAV.ID_E_B_TAU_OUT:
					if (microphone) {
						if (microphone.muted) {
							e.listen(MFlashPlatform.ID_A_SHOW_SECURITY_SETTINGS_PRIVACY, null);
						} else {
							M.set_settings_AudioTransmissionState(details);
						}
						return;
					}
					// show"has no mic message"
					e.listen(VCMMainScreen.ID_A_DISPLAY_NOTIFICATION, 
					{text:APP.lText().get_TEXT(Text.ID_TEXT_HAS_NO_MIC), title:APP.lText().get_TEXT(Text.ID_TEXT_ERROR)});
					break;	
					
				case VCMAV.ID_E_B_TV_OUT:
					if (camera) {
						if (camera.muted) {
							e.listen(MFlashPlatform.ID_A_SHOW_SECURITY_SETTINGS_PRIVACY, null);
						} else {
							M.set_settings_VideoTransmissionState(details);
						}
						return;
					}
					// show"has no cam message"
					e.listen(VCMMainScreen.ID_A_DISPLAY_NOTIFICATION, 
					{text:APP.lText().get_TEXT(Text.ID_TEXT_HAS_NO_CAM), title:APP.lText().get_TEXT(Text.ID_TEXT_ERROR)});
					break;
					
				case VCMAV.ID_E_B_TAU_IN:
					M.set_settings_AudioReceptionState(details);
					break;
					
				case VCMAV.ID_E_B_TV_IN:
					M.set_settings_VideoReceptionState(details);
					break;
					
				case VCMAV.ID_E_USER_SELECTED:
					var avu:AVUser=getUserByID(details);
					if (!avu) {log(3,'!avu',1);break;}
					setCurrentUser(avu);
					break;
					
				case VCMAV.ID_E_B_STREAM:
					// set
					// this code is not connected to M
					//dua.set_StreamingOn(details, duai);
					//no further actions are needed here - stream will be shuted down as soon server will return empy stream name
					break;
					
//{ ^_^ replay manager
				case MReplay.ID_E_RECORD_START:
					recordStart(details);
					break;
				case MReplay.ID_E_RECORD_END:
					recordEnd();
					break;
					
				case MReplay.ID_E_PLAYBACK_PAUSE:
					replayPlaybackPlaying=false;
				case MReplay.ID_E_SEEK_START:
					// pause all streams
					playbackPauseAllStreams();
					break;
					
				case MReplay.ID_E_PLAYBACK_RESUME:
					replayPlaybackPlaying=true;
					playbackResumeAllStreams();
					break;
					
				case MReplay.ID_E_SEEK_END:
					// resume all streams (if not playing)
					playbackSeekAllStreams(details);
					if (replayPlaybackPlaying) {
						playbackResumeAllStreams();
					}
					break;
				case MReplay.ID_E_SET_REPLAY_ID:
					currentReplayID="rep_"+details+'_';
					break;
				case MReplay.ID_E_SET_REPLAY_STARTS_AT:
					setReplayTimeOffset(details);
					break;
//} ^_^ END OF replay manager
					
				case MServerMonitor.ID_E_RESUME_APPLICATION:
					playbackReconnectAllStreams();
					break;
					
				case ID_A_GET_STREAM_INFO:
					a.get_aer().listen(MServerMonitor.ID_E_STREAM_INFO, getStreamInfo());
					break;
			}
		}
		
		//{ =*^_^*= private
		
		private function getStreamInfo():Object
			{
			var lag:Number=-1;
			var o:Object=
				{
				aSent:0, vSent:0,
				aRecv:0, vRecv:0,
				lag:-1
				};			
			for each(var i:AVUser in avUserList) 
				{
				var oo:Object=i.getStreamStats();
				if(!oo)continue;
				o.aSent+=oo.aSent;
				o.vSent+=oo.vSent;
				o.aRecv+=oo.aRecv;
				o.vRecv+=oo.vRecv;
				if(o.lag<oo.lag)o.lag=oo.lag;
				}
			return o;			
			}
		
		private function prepareCamAndMic():void {
			if (Camera.names.length<1) {
				// show"has no cam message"
				//e.listen(VCMMainScreen.ID_A_DISPLAY_NOTIFICATION, 
				//{text:APP.lText().get_TEXT(Text.ID_TEXT_HAS_NO_CAM), title:APP.lText().get_TEXT(Text.ID_TEXT_ERROR)});
			}
			
			if (Microphone.names.length<1) {
				// show"has no mic message"
				//e.listen(VCMMainScreen.ID_A_DISPLAY_NOTIFICATION, 
				//{text:APP.lText().get_TEXT(Text.ID_TEXT_HAS_NO_MIC), title:APP.lText().get_TEXT(Text.ID_TEXT_ERROR)});
			}
			
			camera=Camera.getCamera();
			microphone=Microphone.getMicrophone();
			
			if (microphone) {
				M.set_settings_AudioTransmissionState(!microphone.muted);
			} else {
				log(7, 'user has no microphone', 1);
			}
			
			if (camera) {
				M.set_settings_VideoTransmissionState((a.get_ds().get_clientUserData().get_isLector())?!camera.muted:false);
			} else {
				log(7, 'user has no camera', 1);
			}
			
			if (camera) {
				camera.addEventListener(StatusEvent.STATUS, el_camMicStatus);
			} else if (microphone) {
				microphone.addEventListener(StatusEvent.STATUS, el_camMicStatus);
			}
			
		}
		
		private function el_camMicStatus(event:StatusEvent):void {
			switch (event.code) {
				case "Camera.Muted":
				case "Microphone.Muted":
					log(0,"User clicked Deny.");
					M.set_settings_VideoTransmissionState(!microphone.muted);
					M.set_settings_AudioTransmissionState(!microphone.muted);
					break;
				
				case "Camera.Unmuted":
				case "Microphone.Unmuted":
					log(0,"User clicked Accept.");
					break;
			}
		}
		
		/**
		 * 
		 * @param	usersList [DUUD]
		 */
		private function processExistedUsers(usersList:Array):void {
			for each(var i:DUUD in usersList) {processUser(i);}
		}
		
		private function processUser(u:DUUD, loggedOut:Boolean=false):void {
			//log(0, 'processUser',1);
			//determine whether user has stream name, if logged out - consider as has not
			var uStreamPresent:Boolean=(loggedOut)?false:(u.get_streamName()!=null)?(u.get_streamName().length>0):false;
			//log(0, 'uStreamPresent:'+uStreamPresent,1);
			//determine whether user is in list
			var index:int=-1;
			for each(var i:AVUser in avUserList) {if (i.get_ud()==u) {index=avUserList.indexOf(i);break;}}
			//log(0, 'user index:'+index,1);
			
			var newList:Array;
			
			if (uStreamPresent) {
				//if has -
				if (index==-1) {// add if not found in list
					if (u.get_id()==a.get_ds().get_clientUserId() && u.get_streamName()==null) {
						// NOTE: if this client user and not publishing - do not add in list
					} else {
						// add to model
						newList=M.get_usersList().slice();
						u.set_streamAddedTime(a.getCurrentTime());
						newList.push(u);
						M.set_usersList(newList);
						//addUserToList(u);//- old way before new model format
					}
				}//else {return;}//already in list, do nothing
			} else {//if has not -
				if (index!=-1) {//remove if found
					// remove from model
					newList=M.get_usersList().slice();
					newList.splice(newList.indexOf(getDUUDById(newList, i.get_ud().get_id())), 1);
					M.set_usersList(newList);	
					//removeUserFromList(i); //- old way before new model format
				}//else {return;}//not found in list, do nothing
			}
			
			if (u.get_id()==a.get_ds().get_clientUserId()) {
				// update interface and configure publishing
				M.set_settings_StreamState(uStreamPresent);
			}
			
		}
		
		private function removeUserFromList(u:AVUser):void {
			usersList.splice(usersList.indexOf(u.get_ud()), 1);
			// remove from list
			avUserList.splice(avUserList.indexOf(u), 1);
			// remove from current
			var nextPresentUser:AVUser;
			if (currentUser==u) {
				for each(var i:Object in avUserList) {if (i) {nextPresentUser=i;break;}}
				//setCurrentUser(i, true);27.10.2012
				setCurrentUser(i);
			}
			// deal with GUI
			e.listen(VCMAV.ID_A_REMOVE_VIDEO, u.get_guiController());
			// free memory used by and disconnect from interface
			u.destruct();
		}
		
		private function getUserByID(id:String):AVUser {
			for each(var i:AVUser in avUserList) {if (i.get_ud().get_id()==id) {return i;}}return null;
		}
		
		private function addUserToList(u:DUUD):void {
			usersList.push(u);
			var avu:AVUser=new AVUser(
				u
				, a.get_fmsNetConnectorRef().get_nc()
				, a.get_ds().get_duAppComponentsCfg().get_video_resolution_w()
				, a.get_ds().get_duAppComponentsCfg().get_video_resolution_h()
				, el_AVUser
			);
			avu.set_replayMode(replayMode);
			log(3,'new video object:'+a.get_ds().get_duAppComponentsCfg().get_video_resolution_w()+
			'x'+a.get_ds().get_duAppComponentsCfg().get_video_resolution_h(),0);
			avUserList.push(avu);
			// deal with GUI
			e.listen(VCMAV.ID_A_ADD_VIDEO, avu.get_guiController());
			// alaways play stream in replay mode
			//log(0, 'about to publish or play:',1);
			//log(0, 'replayMode:'+replayMode,1);
			//log(0, 'u.get_id():'+u.get_id(),1);
			//log(0, 'a.get_ds().get_clientUserId():'+a.get_ds().get_clientUserId(),1);
			/*if (!replayMode&& (u.get_id()==a.get_ds().get_clientUserId()) ) {// this client user, update interface and publish to stream 
				publishToStream(avu);
			} else {// other user
				playFromStream(avu);
			}
			*/
			//if (replayMode) {	
			/*} else */if (u.get_id()==a.get_ds().get_clientUserId()&&!replayMode) {// this client user, update interface and publish to stream 
				publishToStream(avu, true);
			} else {
				playFromStream(avu);	
			}
			
			
			//if (!currentUser&&!replayMode) {setCurrentUser(avu);}
			//if (!currentUser) {setCurrentUser(avu, true);}27.10.2012
			if (!currentUser) {setCurrentUser(avu);}
		}
		
		private function el_AVUser(target:AVUser, type:String, details:Object):void {
			log(3,'switch to user>'+target.get_ud().get_displayName(),0)
			setCurrentUser(target);
		}
		
		/**
		 * from model
		 * @param	a [DUUD]
		 */
		private function setUsers(a:Array):void {
			var newUsers:Array=getDifference(usersList, a);
			var missingUsers:Array=getDifference(a, usersList);
			//log(0,'setUsers:',1);
			
			//{ check for new streams, refresh
			var nu:DUUD;
			for each(var j:DUUD in usersList) {
				nu=getDUUDById(a, j.get_id());
				if  (nu) {
					if (nu.get_streamName()!=j.get_streamName()) {//stream changed
						if (getDUUDById(missingUsers, j.get_id()==null)) {//exists in current list
							missingUsers.push(j);
							if (getDUUDById(newUsers, j.get_id()==null)) {//do not add duplicate
								newUsers.push(nu);
							}
						}
					}
				}
			}
			//}
			
			
			// remove
			var avu:AVUser;
			if (missingUsers.length>0) {
				//log(0,'missingUsers:'+missingUsers,1);
				for each(var iu:DUUD in missingUsers) {
					avu=getUserByID(iu.get_id());
					if (avu) {removeUserFromList(avu);}
				}
			}
			// add
			if (newUsers.length>0) {
				//log(0,'new users:'+newUsers,1);
				for each(var i:DUUD in newUsers) {
					if (!getUserByID(i.get_id())) {addUserToList(i);}
				}
			}
		}
		
		/**
		 * find elements that are present only in b list
		 */
		private function getDifference(a:Array, b:Array):Array {
			var r:Array=[];
			for each(var i:DUUD in b) {if (getDUUDById(a, i.get_id())==null) {r.push(i);}}return r;
		}
		private function getDUUDById(list:Array, id:String):DUUD {
			// TODO: LOW; OPTIMIZATION; use hashmap
			for each(var i:DUUD in list) {if (i.get_id()==id) {return i;}}return null;
		}
		
		private function setOutgoingAudioTransmissionState(enabled:Boolean, cu:AVUser=null):void {
			if (!cu) {cu=getUserByID(a.get_ds().get_clientUserId());}
			if (!cu) {return;}
			log(0,'setOutgoingAudioTransmissionState>state:'+enabled+' ;uid='+cu.get_ud().get_id(),1);
			cu.set_ssi_audioIsOn(enabled);
		}
		private function setOutgoingVideoTransmissionState(enabled:Boolean, cu:AVUser=null):void {
			if (!cu) {cu=getUserByID(a.get_ds().get_clientUserId());}
			if (!cu) {/*log(0,'(!cu), id',2);*/return;}
			log(0,'setOutgoingVideoTransmissionState>state:'+enabled+' ;uid='+cu.get_ud().get_id(),1);
			//log(0,'for:'+cu.get_ud().get_displayName(),2);
			cu.set_ssi_videoIsOn(enabled);
		}
		
		
		private function setIncomingAudioReceptionState(i:AVUser, enabled:Boolean):void {
			log(0,'setIncomingAudioReceptionState>state:'+enabled+' ;uid='+i.get_ud().get_id(),1);
			i.set_override_ssi_audioIsOn(!enabled);
			if (!enabled) {i.set_ssi_audioIsOn(enabled);}
		}
		
		private function setIncomingVideoReceptionStateForAllStreams(enabled:Boolean):void {
			/*var cuid:String=a.get_ds().get_clientUserId();
			for each(var i:AVUser in avUserList) {
				//if (i.get_ud().get_id()==cuid) {continue;}
				if (!i.get_streamDirectionIsIncoming()) {continue;}
				setIncomingVideoReceptionState(i, enabled);
			}*/
			//setCurrentUser(currentUser, true);27.10.2012
			setCurrentUser(currentUser);
		}
		private function setIncomingAudioReceptionStateForAllStreams(enabled:Boolean):void {
			var cuid:String=a.get_ds().get_clientUserId();
			for each(var i:AVUser in avUserList) {
				//if (!i.get_streamDirectionIsIncoming()) {continue;}
				if (i.get_ud().get_id()==cuid) {continue;}
				setIncomingAudioReceptionState(i, enabled);
			}
			
			//setCurrentUser(currentUser, true);
		}
		private function setIncomingVideoReceptionState(i:AVUser, enabled:Boolean):void {
			log(0,'setIncomingVideoReceptionState>state:'+enabled+' ;uid='+i.get_ud().get_id(),1);
			//if (i==currentUser) {return;}
			
			i.set_override_ssi_videoIsOn(!enabled);
			if (!enabled) {i.set_ssi_videoIsOn(enabled);}
		}
		
		/**
		 * @param	seek do seek
		 */
		private function playbackResumeAllStreams():void {
			//log(0,'playbackResumeAllStreams>',1);
			for each(var i:AVUser in avUserList) {i.setPlaybackState(true);}
		}
		/**
		 * @param	seek do seek
		 */
		private function playbackSeekAllStreams(currentSystemTime:Number):void {
			//log(0,'playbackSeekAllStreams>'+currentSystemTime,1);
			for each(var i:AVUser in avUserList) {i.seek(currentSystemTime);}
		}
		private function playbackReconnectAllStreams():void {
			for each(var i:AVUser in avUserList) {i.reconnect();}
			setCurrentUser(currentUser);
		}
		private function playbackPauseAllStreams():void {
			//log(0,'playbackPauseAllStreams>',1);
			for each(var i:AVUser in avUserList) {i.setPlaybackState(false);}
		}
		private function setReplayTimeOffset(a:Number):void {
			for each(var i:AVUser in avUserList) {i.setReplayTimeOffset(a/1000);}
		}
		
		private function recordStart(replayID:String):void {
			//currentReplayID=replayID;
			log(7,'recordStart>currentReplayID='+replayID,0);
			nca.call(SP.METHOD_RTMP_AUDIO_VIDEO_RECORD_START, [replayID]);
			//var cu:AVUser;
			//if (!cu) {cu=getUserByID(a.get_ds().get_clientUserId());}
			//if (!cu) {log(0,'(!cu), id',2);return;}
			//cu.recordStart();
		}
		
		private function recordEnd():void {
			nca.call(SP.METHOD_RTMP_AUDIO_VIDEO_RECORD_END, []);
			//var cu:AVUser;
			//if (!cu) {cu=getUserByID(a.get_ds().get_clientUserId());}
			//if (!cu) {/*log(0,'(!cu), id',2);*/return;}
			//cu.recordEnd();
		}
		
		private function playFromStream(avu:AVUser, execPlay:Boolean=true):void {
			log(0,'playFromStream, streamName='+currentReplayID+avu.get_ud().get_streamName(),1);
			// apply default settings
			setIncomingVideoReceptionState(avu, M.get_settings_VideoReceptionState());
			setIncomingAudioReceptionState(avu, M.get_settings_AudioReceptionState());
			//log(0, 'setIncomingVideoReceptionState>'+M.get_settings_VideoReceptionState(),1);
			//log(0, 'setIncomingAudioReceptionState>'+M.get_settings_AudioReceptionState(),1);
			if (execPlay) {
				avu.playFromStream(
					currentReplayID
					,a.get_ds().get_duAppComponentsCfg().get_buffer_time_in()
					,a.get_ds().get_duAppComponentsCfg().get_buffer_time_in()
				);
			}
			if (a.get_ds().get_replayMode()&&!replayPlaybackPlaying) {
				avu.seek(0);avu.setPlaybackState(true);avu.setPlaybackState(false);
			} else {avu.setPlaybackState(true);}
		}
		
		private function publishToStream(avu:AVUser, streamrecordMode:Boolean=false):void {
			//log(0, 'publishToStream, streamName='+avu.get_ud().get_streamName(),1);
			// apply default settings
			avu.publishToStream(
				camera
				, microphone
				, false
				,a.get_ds().get_duAppComponentsCfg().get_buffer_time_out()
				,a.get_ds().get_duAppComponentsCfg().get_buffer_time_out_max()
			);
			setOutgoingVideoTransmissionState(M.get_settings_VideoTransmissionState(), avu);
			setOutgoingAudioTransmissionState(M.get_settings_AudioTransmissionState(), avu);
		}
		
		private function setCurrentUser(avu:AVUser, directly:Boolean=false):void {
			if (directly) {
				if (!avu) {setCurrentUserIS(null);return;}
				setCurrentUserIS(avu.get_ud());
			} else {
				if (!avu) {M.setCurrentUser(null);return;}
				M.setCurrentUser(avu.get_ud());
			}
		}
		
		private function setCurrentUserIS(cUser:DUUD):void {
			var userID:String=(cUser!=null)?cUser.get_id():null;
			var avu:AVUser = getUserByID(userID);
			log(0,'setCurrentUser()>');
			//if (cUser!=null&&(currentUser==avu)) {log(0,'currentUser==avu',0);return;}
			var uiid:String;
			/*for each(var i:AVUser in avUserList) {
				uiid=i.get_ud().get_id();
				if (uiid==a.get_ds().get_clientUserData().get_id()) {//current user
					if (!replayMode) {continue;}// don't touch(outgoing stream)
				}
				if (replayMode) {
					//setIncomingVideoReceptionState(true);
					//i.set_videoReceptionState(true);//current selection
					i.set_videoReceptionState(uint(i.get_ud().get_id()==userID));//current selection
				} else {
					setIncomingVideoReceptionState(i, M.get_settings_VideoReceptionState()&&(uiid==userID));//current selection
				}
			}
			*/
			var uiidSelected:Boolean;
			for each(var i:AVUser in avUserList) {
				uiid=i.get_ud().get_id();
				uiidSelected = uiid==userID;
				if (i.get_streamDirectionIsIncoming()) {//incoming stream
					if (replayMode) {
						//setIncomingVideoReceptionState(i, (uiidSelected)?M.get_settings_VideoTransmissionState():M.get_settings_VideoReceptionState());
						setIncomingVideoReceptionState(i, (uiidSelected)?M.get_settings_VideoTransmissionState():M.get_settings_VideoReceptionState());
					} else {
						setIncomingVideoReceptionState(i, (uiidSelected)?M.get_settings_VideoReceptionState():false);
					}
					
				} else/* if (currentUser!=null&&(currentUser!=i))*/ {//publishing user(client user )
					setOutgoingVideoTransmissionState(M.get_settings_VideoTransmissionState(), i);
					setOutgoingAudioTransmissionState(M.get_settings_AudioTransmissionState(), i);
				}
			}
			
			if (currentUser!=avu&&(currentUser!=null)) {currentUser.set_auxController(null);}
			currentUser=avu;
			if (!currentUser) {
				log(0,'!currentUser')
				if (videoGUIController) {
					//videoGUIController.set_userDisplayName('no user selected(probably no straming users present)');
					videoGUIController.set_userDisplayName('нет пользователей передающих аудио или видео');
					videoGUIController.set_userAvatarPath(AVGUIController.ID_NO_USERS_AVATAR);
					videoGUIController.set_video(null);
					videoGUIController.set_volumeLevel(0);
					videoGUIController.displayUserpic();
					videoGUIController.set_hasAudio(true);
				}
				return;
			}
			if (videoGUIController) {
				currentUser.set_auxController(videoGUIController);
			}
			log(0,'setCurrentUser>'+avu.get_ud().get_id(),0);
			
			//return;
			//if current user is client user, dot't force video settings because they are for transmission
			/*if (currentUser&&(currentUser!=getUserByID(a.get_ds().get_clientUserData().get_id()))) {
				currentUser.set_auxController(null);
				//currentUser.set_override_ssi_videoIsOn(true);
				//currentUser.set_ssi_videoIsOn(false);
				currentUser.set_videoReceptionState(false);
			}
			
			//if current user is client user, dot't force video settings because they are for transmission
			if (currentUser!=getUserByID(a.get_ds().get_clientUserData().get_id())) {
				//currentUser.set_override_ssi_videoIsOn(false);
				//currentUser.set_ssi_videoIsOn(M.get_settings_VideoReceptionState());
				currentUser.set_videoReceptionState(M.get_settings_VideoReceptionState());
			}
			*/
		}
		private var currentUser:AVUser;
		
		private function el_nca(target:FMSServerAdaptor, eventType:String, eventData:Object):void {
			if (eventType==FMSServerAdaptor.ID_E_RESULT_SUCCESS) {
				return;
			}
			//error occured
			log(5, NAME+'>some error occured at el_nca() - responder error', 2);
		}
		
		
		
		private var usersList:Array=[];
		/**
		 * [AVUser]
		 */
		private var avUserList:Array=[];
		private var camera:Camera;
		private var microphone:Microphone;
		private var nca:FMSServerAdaptor;
		private var currentReplayID:String="";
		private var videoGUIController:AVGUIController;
		//} =*^_^*= END OF private
		
		
		//{ =*^_^*= model
		private function el_M(targetModel:MavComModel, elementID:uint, updateFromDataport:Boolean=false):void {
			switch (elementID) {
			case MavComModel.ID_P_SETTINGS_AUDIO_RECEPTION_STATE:
				setIncomingAudioReceptionStateForAllStreams(M.get_settings_AudioReceptionState());
				e.listen(VCMAV.ID_A_SET_STATE_AU_IN, M.get_settings_AudioReceptionState());
				break;
			case MavComModel.ID_P_SETTINGS_AUDIO_TRANSMISSION_STATE:
				setOutgoingAudioTransmissionState(M.get_settings_AudioTransmissionState());
				e.listen(VCMAV.ID_A_SET_STATE_AU_OUT, M.get_settings_AudioTransmissionState());
				break;
			case MavComModel.ID_P_SETTINGS_VIDEO_RECEPTION_STATE:
				setIncomingVideoReceptionStateForAllStreams(M.get_settings_VideoReceptionState());
				e.listen(VCMAV.ID_A_SET_STATE_V_IN, M.get_settings_VideoReceptionState());
				break;
			case MavComModel.ID_P_SETTINGS_VIDEO_TRANSMISSION_STATE:
				setOutgoingVideoTransmissionState(M.get_settings_VideoTransmissionState());
				e.listen(VCMAV.ID_A_SET_STATE_V_OUT, M.get_settings_VideoTransmissionState());
				break;
			case MavComModel.ID_P_SETTINGS_STREAM_STATE:
				e.listen(VCMAV.ID_A_SET_STATE_S, M.get_settings_StreamState());
				break;
			case MavComModel.ID_P_USERS:
				//log(0,'MavComModel.ID_P_USERS',2);
				setUsers(M.get_usersList());
				break;
			case MavComModel.ID_P_A_SET_CURRENT_USER:
				setCurrentUserIS(M.get_currentUser());
				break;
			
			}
			
		}
		
		private var M:MavComModel;
		//} =*^_^*= END OF model
		
		
		private var duai:DUAIUserAccessInfo;
		private var dua:DUAUserInfo;
		
		
		private function get e():AEApp {return get_envRef();}
		private var a:Application;
		private var replayMode:Boolean;
		private var replayPlaybackPlaying:Boolean;
		
		//{ =*^_^*= id
		/**
		 * prepare connection to the network
		 * data:
		 */
		public static const ID_A_CONNECT:String=NAME+'>ID_A_CONNECT';
		/**
		 * {replayMode:Boolean}
		 */
		public static const ID_A_PREPARE:String=NAME+'>ID_A_PREPARE';
		public static const ID_A_PREPARE_MODEL:String=NAME+'>ID_A_PREPARE_MODEL';
		/**
		 * data:{?}
		 */
		public static const ID_A_SET_CFG:String=NAME+'>ID_A_SET_CFG';
		/**
		 * data:{streamName:String, v:Boolean}
		 */
		public static const ID_A_STREAM_AU_SET_ENABLED:String=NAME+'>ID_A_STREAM_AU_SET_ENABLED';
		/**
		 * data:{streamName:String, v:Boolean}
		 */
		public static const ID_A_STREAM_V_SET_ENABLED:String=NAME+'>ID_A_STREAM_V_SET_ENABLED';
		/**
		 * data:{streamName:String, volume:int}
		 */
		public static const ID_A_STREAM_AU_SET_VOLUME:String=NAME+'>ID_A_STREAM_AU_SET_VOLUME';
		/**
		 * data:{streamName:String}
		 */
		public static const ID_A_STREAM_CONNECT:String=NAME+'>ID_A_STREAM_IN_CONNECT';
		/**
		 * data:{streamName:String}
		 */
		public static const ID_A_STREAM_DISCONNECT:String=NAME+'>ID_A_STREAM_IN_DISCONNECT';
		/**
		 * AER
		 * data:{streamName:String}
		 */
		public static const ID_A_GET_STREAM_INFO:String=NAME+'>ID_A_GET_STREAM_INFO';
		/**
		 * data:String//userName(id)
		 */
		public static const ID_A_SET_REQUIRED_DATA:String=NAME+'>ID_A_SET_REQUIRED_DATA';
		//} =*^_^*= END OF id
		
		
		//{ =*^_^*= events
		/**
		 * data:{streamName:String}
		 */
		public static const ID_E_STREAM_CONNECTED:String=NAME+'>ID_E_STREAM_CONNECTED';
		/**
		 * data:{streamName:String}
		 */
		public static const ID_E_STREAM_DISCONNECTED:String=NAME+'>ID_E_STREAM_DISCONNECTED';
		/**
		 * data:DU?
		 */
		public static const ID_E_STREAM_INFO:String=NAME+'>ID_E_STREAM_INFO';
		
		public static const ID_E_CONNECTED:String=NAME+'>ID_E_CONNECTED';
		public static const ID_E_PREPARED:String=NAME+'>ID_E_PREPARED';
		public static const ID_E_CONNECTION_ERROR:String=NAME+'>ID_E_CONNECTION_ERROR';
		//} =*^_^*= END OF events
		
		public static const NAME:String = 'MAV';
		
		public override function autoSubscribeEvents():Array {
			return [
				,ID_A_CONNECT
				,ID_A_PREPARE
				,ID_A_PREPARE_MODEL
				,MUserData.ID_E_USER_LOGIN
				,MUserData.ID_E_USER_LOGOUT
				,MUserData.ID_E_USER_SOUND_OFF
				,MUserData.ID_E_USER_SOUND_ON
				,MUserData.ID_E_USER_STREAM_OFF
				,MUserData.ID_E_USER_STREAM_ON
				,MUserData.ID_E_USER_STREAM_NAME_IS_EMPTY
				,MUserData.ID_E_USER_STREAM_NAME_PRESENT
				,MUserData.ID_E_USER_LIST_REF
				,VCMAV.ID_E_B_SETTINGS
				,VCMAV.ID_E_B_TV_OUT
				,VCMAV.ID_E_B_TV_IN
				,VCMAV.ID_E_B_TAU_OUT
				,VCMAV.ID_E_B_TAU_IN
				,VCMAV.ID_E_B_STREAM
				,VCMAV.ID_E_USER_SELECTED
				,MUserData.ID_E_USER_DATA_ACCESS_MEANS
				,MReplay.ID_E_PLAYBACK_PAUSE
				,MReplay.ID_E_PLAYBACK_RESUME
				,MReplay.ID_E_RECORD_START
				,MReplay.ID_E_RECORD_END
				,MReplay.ID_E_SEEK_START
				,MReplay.ID_E_SEEK_END
				,MReplay.ID_E_SET_REPLAY_STARTS_AT
				,MReplay.ID_E_SET_REPLAY_ID
				,MServerMonitor.ID_E_SUSPEND_APPLICATION
				,MServerMonitor.ID_E_RESUME_APPLICATION
				];
		}
		
	}
}



//{ =*^_^*= History
/* > (timestamp) [ ("+" (added) ) || ("-" (removed) ) || ("*" (modified) )] (text)
 * > 02.08.2012_03#31#29 - AVUser implementation relocated to separate file
 * > 
 */
//} =*^_^*= END OF History

// template last modified:11.03.2011_[18#51#40]_[5]