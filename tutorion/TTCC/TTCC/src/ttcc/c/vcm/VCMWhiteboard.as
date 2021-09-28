// Project TTCC
package ttcc.c.vcm {
	
	//{ =*^_^*= import
	import flash.display.Sprite;
	import ttcc.Application;
	
	import ttcc.APP;
	import ttcc.LOG;
	import ttcc.cfg.AppCfg;
	import ttcc.media.Text;
	import ttcc.v.wb.VCWB;
	//} =*^_^*= END OF import
	
	/**
	 * display manager - controlls interface
	 * @author Jinanoimatey Dragoncat
	 * @version 0.0.0
	 * @created 21.08.2012 10:46
	 */
	public class VCMWhiteboard extends AVCM {
		
		//{ =*^_^*= CONSTRUCTOR
		
		function VCMWhiteboard (app:Application) {
			super(NAME);
			a=app;
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
				
				
			}
		}
		
		private function configureVC():void {
			vc.setListener(el_vc);
			vc.construct();
			vc.setUintOutput(VCWB.ID_OUT_UINT_DISPLAY_MODE, uint(a.get_ds().get_replayMode()));
		}
		
		
		private function el_vc(target:VCWB, eventType:String, details:Object=null):void {
			var s:String='event, type:'+eventType+'; details:'+details;
			LOG(3, 'event, type:'+eventType+'; details:'+details);
			
			switch (eventType) {
			
			/*case VCWB.ID_E_B_DEBUG_CHANGE_MODE:
				Model_displayMode = !Boolean(Model_displayMode);
				vc.setUintOutput(VCWB.ID_OUT_UINT_DISPLAY_MODE, Model_displayMode);
				s+='\nтекущий режим отображения:'+['полный','режим реплей'][Model_displayMode];
				break;
			*/
			case VCWB.ID_E_SELECT_PAGE:
				//  TODO: Check if page not exists. Update model.
				Model_selectedPage=details.page;
				//vc.setSelPage(details.page);
				//s+='\nтекущий режим отображения:'+['полный','режим реплей'][Model_displayMode];
				get_envRef().listen(ID_E_SELECT_PAGE, Model_selectedPage);
				break;
			
			case VCWB.ID_E_SEND_DATA:
				get_envRef().listen(ID_E_SEND_DATA, details);
				break;
			
			case VCWB.ID_E_B_WB_SAVE:
				get_envRef().listen(ID_E_SAVE_WB_DATA, details);
				break;
			case VCWB.ID_E_B_WB_LOAD:
				get_envRef().listen(ID_E_LOAD_WB_DATA, details);
				break;
			//case VCWB.ID_E_B_NEXT_PAGE:
				//not used
				//break;
			
			//case VCWB.ID_E_B_PREV_PAGE:
				//not used
				//break;
			
			//case VCWB.ID_E_SELECT_PAGE:
				//not used
				//break;
			
			//case VCWB.ID_E_REQ_GET_IMAGE_BD_BY_URL:
				// not used in the application
				//break;
			
			}
			vc.setStringOutput(VCWB.ID_OUT_STRING_TEST_PAGE_TEXT, s);
		}
		
		
		//{ =*^_^*= private 
		private var Model_displayMode:uint=0;
		private var Model_selectedPage:int=-1;
		private var vc:VCWB;
		private var a:Application;		
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
		 * data:VCWB
		 */
		public static const ID_A_REGISTER_SINGLETON_VC:String = NAME + '>ID_A_REGISTER_SINGLETON_VC';
		
		//public static const ID_E_:String = NAME + '>';
		/**
		 * data:{cmdName:String, param:Array}
		 */
		public static const ID_E_SEND_DATA:String = NAME + '>ID_E_SEND_DATA';
		/**
		 * data:{page:int}
		 */
		public static const ID_E_SELECT_PAGE:String = NAME + '>ID_E_SELECT_PAGE';
		public static const ID_E_SAVE_WB_DATA:String = NAME + '>ID_E_SAVE_WB_DATA';
		public static const ID_E_LOAD_WB_DATA:String = NAME + '>ID_E_LOAD_WB_DATA';
		//} =*^_^*= END OF id
		
		
		public override function autoSubscribeEvents():Array {
			return [
				ID_A_REGISTER_SINGLETON_VC
				,ID_A_SET_VISIBILITY
				,ID_A_SET_WINDOW_XYWH
			];
		}
		
		public static const NAME:String = 'VCMWhiteboard';
	}
}


//{ =*^_^*= History
/* > (timestamp) [ ("+" (added) ) || ("-" (removed) ) || ("*" (modified) )] (text)
 * > 
 */
//} =*^_^*= END OF History

// template last modified:11.03.2011_[18#51#40]_[5]