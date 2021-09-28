// Project Connect
package ttcc.d.a {
	
	//{ =*^_^*= import
	import ttcc.d.ADU;
	import ttcc.d.DUA;
	import ttcc.d.DUAI;
	//} =*^_^*= END OF import
	
	
	/**
	 * 
	 * @author Jinanoimatey Dragoncat
	 * @version 0.0.0
	 * @created 23.05.2012 17:53
	 */
	public class DUAUserInfo extends DUA {
		
		//{ =*^_^*= CONSTRUCTOR
		public function construct_DUAUserInfo(eventListener:Function,  target:DUUD):void {
			super.construct(eventListener, target);
		}
		public override function destruct():void {
			throw new ArgumentError('not implemented yet');
		}
		//} =*^_^*= END OF CONSTRUCTOR
		
		
		public function get_StreamingOn(ai:DUAI):Boolean {
			if (cpex(ai, DUAIUserAccessInfo.ID_A_R__STREAMING_ON)) {return gt().get_streamingIsOn();}return false;
		}
		public function get_StreamingSoundOn(ai:DUAI):Boolean {
			if (cpex(ai, DUAIUserAccessInfo.ID_A_R__STREAM_SOUND_ON)) {return gt().get_streamSoundIsOn();}return false;
		}
		public function get_StreamName(ai:DUAI):String {
			if (cpex(ai, DUAIUserAccessInfo.ID_A_R__STREAMNAME)) {return gt().get_streamName();}return null;
		}
		public function get_ChatTyping(ai:DUAI):Boolean {
			if (cpex(ai, DUAIUserAccessInfo.ID_A_R__CHAT_TYPING)) {return gt().get_chatIsTyping();}return false;
		}
		public function get_chatBan(ai:DUAI):Boolean {
			if (cpex(ai, DUAIUserAccessInfo.ID_A_R__CHAT_BAN)) {return gt().get_isBannedChat();}return false;
		}
		public function get_HandUp(ai:DUAI):Boolean {
			if (cpex(ai, DUAIUserAccessInfo.ID_A_R__HAND_UP)) {return gt().get_handIsUp();}return false;
		}
		
		
		
		public function set_StreamingOn(a:Boolean, ai:DUAI):void {
			if (cp(ai, DUAIUserAccessInfo.ID_A_W__STREAMING_ON)) {
				gt().set_streamingIsOn(a);
				ex(ai, DUAIUserAccessInfo.ID_A_W__STREAMING_ON);
			}
		}
		public function set_StreamingSoundOn(a:Boolean, ai:DUAI):void {
			if (cp(ai, DUAIUserAccessInfo.ID_A_W__STREAM_SOUND_ON)) {
				gt().set_streamSoundIsOn(a);
				ex(ai, DUAIUserAccessInfo.ID_A_W__STREAM_SOUND_ON);
			}
		}
		public function set_StreamName(a:String, ai:DUAI):void {
			if (cp(ai, DUAIUserAccessInfo.ID_A_W__STREAMNAME)) {
				gt().set_streamName(a);
				ex(ai, DUAIUserAccessInfo.ID_A_W__STREAMNAME);
			}
		}
		public function set_ChatTyping(a:Boolean, ai:DUAI):void {
			if (cp(ai, DUAIUserAccessInfo.ID_A_W__CHAT_TYPING)) {
				gt().set_chatIsTyping(a);
				ex(ai, DUAIUserAccessInfo.ID_A_W__CHAT_TYPING);
			}
		}
		public function set_chatBan(a:Boolean, ai:DUAI):void {
			if (cp(ai, DUAIUserAccessInfo.ID_A_W__CHAT_BAN)) {
				gt().set_isBannedChat(a);
				ex(ai, DUAIUserAccessInfo.ID_A_W__CHAT_BAN);
			}
		}
		public function set_HandUp(a:Boolean, ai:DUAI):void {
			if (cp(ai, DUAIUserAccessInfo.ID_A_W__HAND_UP)) {
				gt().set_handIsUp(a);
				ex(ai, DUAIUserAccessInfo.ID_A_W__HAND_UP);
			}
		}
		
		
		private function gt():DUUD {return t();}
		
	}
}

//{ =*^_^*= History
/* > (timestamp) [ ("+" (added) ) || ("-" (removed) ) || ("*" (modified) )] (text)
 * > 
 */
//} =*^_^*= END OF History

// template last modified:11.03.2011_[18#51#40]_[5]