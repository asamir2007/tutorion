// Project TTCC
package ttcc.c.ma.ac {
	
	//{ =*^_^*= import
	import ttcc.APP;
	import ttcc.Application;
	import ttcc.c.ae.AEApp;
	import ttcc.c.ma.ac.MAPPComponent;
	import ttcc.c.ma.MWhiteboard;
	import ttcc.c.vcm.d.DUMPButton;
	import ttcc.c.ma.ac.MACMP;
	import ttcc.c.vcm.VCMWhiteboard;
	import ttcc.cfg.AppCfg;
	import ttcc.d.a.ARO;
	import ttcc.d.a.DUAppComponentCfg;
	import ttcc.media.PictureStoreroom;
	import ttcc.media.Text;
	import ttcc.v.wb.VCWB;
	//} =*^_^*= END OF import
	
	
	/**
	 * application component
	 * @author Jinanoimatey Dragoncat
	 * @version 0.0.0
	 * @created 29.06.2012 6:58
	 */
	public class MACWhiteboard extends MAPPComponent {
		
		//{ =*^_^*= CONSTRUCTOR
		
		function MACWhiteboard (app:Application) {
			super(NAME, COMPONENT_ID, 107000, [MACMP.COMPONENT_ID]);
			a=app;
		}
		//} =*^_^*= END OF CONSTRUCTOR
		
		
		public override function listen(eventType:String, details:Object):void {
			super.listen(eventType, details);
			switch (eventType) {
				case MWhiteboard.ID_E_CONNECTED:
					reportReady();
					break;
				case MWhiteboard.ID_E_FAILED_TO_CONNECT:
					e.listen(getServiceActionName(S_ID_E_FAILED_TO_RUN_COMPONENT), null);
					break;
			}
		}
		
		private function reportReady():void {
			componentStartedUp=true;
			e.listen(getServiceActionName(S_ID_E_COMPONENT_IS_READY), null);
		}
		
		protected override function runComponent():void {
			super.runComponent();
			if (!a.get_ds().get_replayMode()) {
				e.listen(MWhiteboard.ID_A_CONNECT, null);
			}
			
			e.listen(MWhiteboard.ID_A_RUN, null);
			reportReady();
		}
		
		protected override function checkCFG(cfg:DUAppComponentCfg):void {
			super.checkCFG(cfg);
			cfg.setBoolean(ID_AC_CFG_P_MPBUTTON_PRESENT, true);//наличие у компонента кнопки на панели, не помню на что влияет
			cfg.setBoolean(ID_AC_CFG_P_WINDOW_PRESENT, true);//наличие у компонента окна, если есть будут пременены настройки окна
		}
		
		protected override function applyCFG(cfg:DUAppComponentCfg):void {
			super.applyCFG(cfg);
		}
		
		protected override function prepareBeforeStartup():void {
			super.prepareBeforeStartup();
			//prepare agents
			e.placeAgent(new MWhiteboard(a));
			e.placeAgent(new VCMWhiteboard(a));
			//prepare view
			var pl:VCWB=new VCWB(get_cfg().getBoolean(ID_AC_CFG_P_TEST_MODE));
			pl.setAppRef_(a);
			pl.set_de(a.get_de());
			pl.setResourceO(VCWB.ID_ELEMENT_ICON_WINDOW, PictureStoreroom.getPicture('board_h'));
			pl.setResourceS(VCWB.ID_ELEMENT_TEXT_WINDOW_TITLE, APP.lText().get_TEXT(Text.ID_TEXT_WB_WINDOW_TITLE));
			
			var reslist:Array=[
				[VCWB.ID_ELEMENT_ICON_B_DRAW, 'draw_w', 'draw_b', 'draw_p']
				,[VCWB.ID_ELEMENT_ICON_B_NEXT, 'next_w', 'next_b', 'next_p', 'next_p']
				,[VCWB.ID_ELEMENT_ICON_B_PREV, 'prev_w', 'prev_b', 'prev_p']
				
				,[VCWB.ID_ELEMENT_ICON_ADD_PAGE_W, 'add_page_w', 'add_page_b', 'add_page_p']
				,[VCWB.ID_ELEMENT_ICON_CLEAN_PAGE_W, 'clean_page_w', 'clean_page_w', 'clean_page_w']
				,[VCWB.ID_ELEMENT_ICON_COLOR, 'color_w', 'color_b', 'color_p']
				,[VCWB.ID_ELEMENT_ICON_DELETE_ALL_W, 'delete_all_w', 'delete_all_b', 'delete_all_p']
				,[VCWB.ID_ELEMENT_ICON_FONT, 'font_w', 'font_b', 'font_p']
				,[VCWB.ID_ELEMENT_ICON_NEXT_INACT_W, 'next_inact_w', 'next_inact_w', 'next_inact_w']
				,[VCWB.ID_ELEMENT_ICON_PREV_INACT_W, 'prev_inact_w', 'prev_inact_w', 'prev_inact_w']
				,[VCWB.ID_ELEMENT_ICON_REMOVE_PAGE_W, 'remove_page_w', 'remove_page_b', 'remove_page_p']
				,[VCWB.ID_ELEMENT_ICON_SAVE_W, 'save_w', 'save_b', 'save_p']
				
				,[VCWB.ID_ELEMENT_ICON_LINE_W, 'line_w', 'line_b', 'line_p']
				,[VCWB.ID_ELEMENT_ICON_CIRCLE_W, 'circle_w', 'circle_b', 'circle_p']
				,[VCWB.ID_ELEMENT_ICON_RECT_W, 'rect_w', 'rect_b', 'rect_p']
				,[VCWB.ID_ELEMENT_ICON_ELLIPSE_W, 'ellipse_w', 'ellipse_b', 'ellipse_p']
				,[VCWB.ID_ELEMENT_ICON_CLEAN_W, 'clean_w', 'clean_b', 'clean_p']
				,[VCWB.ID_ELEMENT_ICON_ERASE_W, 'erase_w', 'erase_b', 'erase_p']
				,[VCWB.ID_ELEMENT_ICON_TEXT_W, 'text_w', 'text_b', 'text_p']
				
				,[VCWB.ID_ELEMENT_ICON_UNDO_W, 'undo_w', 'undo_b', 'undo_p']
				,[VCWB.ID_ELEMENT_ICON_UPLOAD_W, 'upload_w', 'upload_b', 'upload_p']
				,[VCWB.ID_ELEMENT_ICON_ZOOM_M_W, 'zoom_m_w', 'zoom_m_b', 'zoom_m_p']
				,[VCWB.ID_ELEMENT_ICON_ZOOM_P_W, 'zoom_p_w', 'zoom_p_b', 'zoom_p_p']
				,[VCWB.ID_ELEMENT_ICON_B_CLEAR_PAGE, 'clean_page_w', 'clean_page_b', 'clean_page_p']
				,[VCWB.ID_ELEMENT_ICON_B_SETTINGS, 'settings_h', 'settings_h', 'settings_h']
				,[VCWB.ID_ELEMENT_PAGE_BG, 'list_4', '', '']
				
			];
			for each(var i:Array in reslist) {
				pl.setResourceO(i[0], [
					PictureStoreroom.getPicture(i[1])
					,PictureStoreroom.getPicture(i[2])
					,PictureStoreroom.getPicture(i[3])
					//,PictureStoreroom.getPicture(i[4])
				]);
			}
			/*pl.setResourceO(VCWB.ID_ELEMENT_ICON_B_DRAW, [
					PictureStoreroom.getPicture('draw_w')
					,PictureStoreroom.getPicture('draw_b')
					,PictureStoreroom.getPicture('draw_p')
			]);*/
			
			pl.resourcesAreConfigured();
			
			a.get_mainScreen().set_wb(pl);
			e.listen(VCMWhiteboard.ID_A_REGISTER_SINGLETON_VC, a.get_mainScreen().get_wb());
		}
		
		protected override function window__setXYWH(x:Number, y:Number, w:Number, h:Number):void {
			super.window__setXYWH(x,y,w,h);
			e.listen(VCMWhiteboard.ID_A_SET_WINDOW_XYWH, [x,y,w,h]);
		}
		
		protected override function window__setInitialVisibility(a:Boolean):void {
			super.window__setInitialVisibility(a);
			e.listen(VCMWhiteboard.ID_A_SET_VISIBILITY, a);
		}
		
		protected override function displayMPButton():void {
			super.displayMPButton();
			e.listen(MACMP.ID_A_ADD_BUTTON, new DUMPButton(
				COMPONENT_ID
				,55000
				,"board_w"
				,"board_b"
				,"board_p"
				,APP.lText().get_TEXT(Text.ID_TEXT_WB_WINDOW_TITLE)
			));
		}
		
		//{ =*^_^*= private 
		private var componentStartedUp:Boolean;
		//} =*^_^*= END OF private
		
		private function get e():AEApp {return get_envRef();}
		private var a:Application;
		
		//{ =*^_^*= id
		//} =*^_^*= END OF id
		
		//{ =*^_^*= =*^_^*= component cfg properties list
		public static const COMPONENT_ID:String = 'whiteboard';
		//} =*^_^*= =*^_^*= END OF component cfg properties list
		
		public static const ID_AC_CFG_P_TEST_MODE:String='test_mode';
		
		
		//{ =*^_^*= events
		//} =*^_^*= END OF events
		
		public static const NAME:String = 'MACWhiteboard';
		
		
		public override function autoSubscribeEvents():Array {
			var events:Array=super.autoSubscribeEvents();if (!events) {events=[];}
			return events.concat([
				MWhiteboard.ID_E_CONNECTED
				,MWhiteboard.ID_E_FAILED_TO_CONNECT
			]
			);
		}
	}
}

//{ =*^_^*= History
/* > (timestamp) [ ("+" (added) ) || ("-" (removed) ) || ("*" (modified) )] (text)
 * > 
 */
//} =*^_^*= END OF History

// template last modified:11.03.2011_[18#51#40]_[5]