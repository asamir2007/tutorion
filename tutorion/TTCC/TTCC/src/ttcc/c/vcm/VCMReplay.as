// Project TTCC
package ttcc.c.vcm {
	
	//{ =*^_^*= import
	import flash.display.Sprite;
	import ttcc.APP;
	import ttcc.cfg.AppCfg;
	import ttcc.LOG;
	import ttcc.media.Text;
	import ttcc.n.loaders.Im;
	import ttcc.v.r.VCReplayManager;
	//} =*^_^*= END OF import
	
	/**
	 * display manager - controlls interface
	 * @author Jinanoimatey Dragoncat
	 * @version 0.0.0
	 * @created 05.08.2012 18:20
	 */
	public class VCMReplay extends AVCM {
		
		//{ =*^_^*= CONSTRUCTOR
		
		function VCMReplay () {
			super(NAME);
		}
		//} =*^_^*= END OF CONSTRUCTOR
		
		
		public override function listen(eventType:String, details:Object):void {
			
			switch (eventType) {
			
			case ID_A_REGISTER_SINGLETON_VC:
				vc=details;
				configureVC();
				break;
				
			case ID_A_SET_VISIBILITY:
				vc.set_visible((details<2)?Boolean(details):!vc.get_visible());
				break;
			case ID_A_SET_WINDOW_XYWH:
				vc.setXY(details[0],details[1]);
				vc.setWH(details[2],details[3]);
				break;
				
			case ID_A_SET_MODE_PLAY:
				vc.setUintOutput(VCReplayManager.ID_OUT_UINT_DISPLAY_MODE
					,(details.paused)?VCReplayManager.ID_MODE_STOPPED:VCReplayManager.ID_MODE_PLAY);
				break;
			case ID_A_SET_MODE_RECORD:
				vc.setUintOutput(VCReplayManager.ID_OUT_UINT_DISPLAY_MODE
					,(details.paused)?VCReplayManager.ID_MODE_RECORD_STOPPED:VCReplayManager.ID_MODE_RECORD);
				break;
			case ID_A_SET_RECORD_DURATION:
				vc.setUintOutput(VCReplayManager.ID_OUT_UINT_DURATION, details);
				break;
			case ID_A_SET_SEEKBAR_POSITION:
				vc.setNumberInput(VCReplayManager.ID_IN_NUMBER_POSITION, details);
				break;
				
			}
		}
		
		private function configureVC():void {
			vc.construct(el_vc);
		}
		
		
		private function el_vc(target:VCReplayManager, eventType:String, details:Object=null):void {
			switch (eventType) {
			case VCReplayManager.ID_E_B_PLAY:
				get_envRef().listen(ID_E_BUTTON_PLAY, /*vc.get_replayRawData()*/null);
				break;
			case VCReplayManager.ID_E_B_RECORD:
				get_envRef().listen(ID_E_BUTTON_RECORD, null);
				break;
			case VCReplayManager.ID_E_B_RECORD_STOP:
				get_envRef().listen(ID_E_BUTTON_RECORD_STOP, null);
				break;
			case VCReplayManager.ID_E_B_STOP:
				get_envRef().listen(ID_E_BUTTON_STOP, null);
				break;
			case VCReplayManager.ID_E_START_SEEK:
				//LOG(0, 'current position:'+ vc.getUintInput(VCReplayManager.ID_IN_UINT_POSITION_SECONDS));
				get_envRef().listen(ID_E_SEEK_START, vc.getUintInput(VCReplayManager.ID_IN_UINT_POSITION_SECONDS));
				break;
			case VCReplayManager.ID_E_END_SEEK:
				//LOG(0, 'current position:'+vc.getUintInput(VCReplayManager.ID_IN_UINT_POSITION_SECONDS));
				get_envRef().listen(ID_E_SEEK_END, vc.getUintInput(VCReplayManager.ID_IN_UINT_POSITION_SECONDS));
				break;
			
			}
		}
		
		
		//{ =*^_^*= private 
		private var vc:VCReplayManager;
		//} =*^_^*= END OF private
		
		
		//{ =*^_^*= id
		/**
		 * data:uint
		 * 0 false, 1 true, 2 toggle
		 */
		public static const ID_A_SET_VISIBILITY:String=NAME+'>ID_A_SET_VISIBILITY';
		/**
		 * data:[x,y,w,h]
		 */
		public static const ID_A_SET_WINDOW_XYWH:String=NAME+'>ID_A_SET_WINDOW_XYWH';
		/**
		 * data:VCReplayManager
		 */
		public static const ID_A_REGISTER_SINGLETON_VC:String = NAME + '>ID_A_REGISTER_SINGLETON_VC';
		
		/**
		 * {paused:Boolean}
		 */
		public static const ID_A_SET_MODE_RECORD:String = NAME + '>ID_A_SET_MODE_RECORD';
		/**
		 * {paused:Boolean}
		 */
		public static const ID_A_SET_MODE_PLAY:String = NAME + '>ID_A_SET_MODE_PLAY';
		/**
		 * uint//seconds//
		 */
		public static const ID_A_SET_RECORD_DURATION:String = NAME + '>ID_A_SET_RECORD_DURATION';
		/**
		 * Number//seconds//
		 */
		public static const ID_A_SET_SEEKBAR_POSITION:String = NAME + '>ID_A_SET_SEEKBAR_POSITION';
		
		public static const ID_E_SEEK_START:String = NAME + '>ID_E_SEEK_START';
		public static const ID_E_BUTTON_PLAY:String = NAME + '>ID_E_BUTTON_PLAY';
		public static const ID_E_BUTTON_RECORD:String = NAME + '>ID_E_BUTTON_RECORD';
		public static const ID_E_BUTTON_RECORD_STOP:String = NAME + '>ID_E_BUTTON_RECORD_STOP';
		public static const ID_E_BUTTON_STOP:String = NAME + '>ID_E_BUTTON_STOP';
		/**
		 * seconds
		 */
		public static const ID_E_SEEK_END:String = NAME + '>ID_E_SEEK_END';
		//} =*^_^*= END OF id
		
		public override function autoSubscribeEvents():Array {
			return [
				ID_A_REGISTER_SINGLETON_VC
				,ID_A_SET_VISIBILITY
				,ID_A_SET_WINDOW_XYWH
				,ID_A_SET_RECORD_DURATION
				,ID_A_SET_SEEKBAR_POSITION
				,ID_A_SET_MODE_RECORD
				,ID_A_SET_MODE_PLAY
			];
		}
		
		public static const NAME:String = 'VCMReplay';
	}
}


//{ =*^_^*= History
/* > (timestamp) [ ("+" (added) ) || ("-" (removed) ) || ("*" (modified) )] (text)
 * > 
 */
//} =*^_^*= END OF History

// template last modified:11.03.2011_[18#51#40]_[5]