// Project TTCC
package ttcc.c.vcm {
	
	//{ =*^_^*= import
	import flash.display.DisplayObject;
	import ttcc.APP;
	import ttcc.c.vcm.d.DUMPButton;
	import ttcc.c.vcm.d.IDUMPElement;
	import ttcc.cfg.AppCfg;
	import ttcc.d.ADU;
	import ttcc.LOG;
	import ttcc.media.PictureStoreroom;
	import ttcc.media.Text;
	import ttcc.v.mp.VCMainPanel;
	import ttcc.v.mp.VCMainPanelButtonElement;
	import ttcc.v.mp.VCMainPanelIPanelElement;
	//} =*^_^*= END OF import
	
	/**
	 * display manager
	 * @author Jinanoimatey Dragoncat
	 * @version 0.0.0
	 * @created 20.06.2012 1:55
	 */
	public class VCMMainPanel extends AVCM {
		
		//{ =*^_^*= CONSTRUCTOR
		
		function VCMMainPanel () {
			super(NAME);
		}
		//} =*^_^*= END OF CONSTRUCTOR
		
		
		public override function listen(eventType:String, details:Object):void {
			
			switch (eventType) {
			
			case ID_A_ADD_ELEMENT:
				addComponent(details.e, details.d);
				orderAndDrawComponentButtons();
				break;
				
			case ID_A_ADD_BUTTON:
				addComponentButton(details);
				orderAndDrawComponentButtons();
				break;
				
			case ID_A_REGISTER_SINGLETON_VC:
				vc=details;
				configureVC();
				break;
				
			case ID_A_REDRAW_VC:
				orderAndDrawComponentButtons();
				break;
				
			case ID_A_ADD_POPUP:
				vc.addPopupElement(details.target, details.anchor);
				break;
			case ID_A_REMOVE_POPUP:
				vc.removePopupElement(details);
				break;
			
			case ID_A_SET_MENU_VISIBILITY:
				vc.setMenuVisibility(details);
				break;
				
			case ID_A_PREPARE_MENU:
				vc.prepareMenu(details.menuData, details.layoutsList);
				break;
				
			}
		}
		
		
		private function configureVC():void {
			vc.construct(el_mp, 1);
			vc.setBGColor(0x999999);
			vc.setW(AppCfg.appScreenW);
			vc.setListener(el_vc);
		}
		
		private function el_vc (target:VCMainPanel, eventType:String, details:Object=null):void {
			switch (eventType) {
			
				case VCMainPanel.ID_E_MENU_ACTION:
				get_envRef().listen(ID_E_MENU_ACTION, details);
				break;
			
			}
		}
		
		
		private function orderAndDrawComponentButtons():void {
			// sort by order
			var list:Array=[];
			//var listEnd:Array=[];
			//var listMiddle:Array=[];
			var listToSort:Array=[];
			var position:int;
			for each(var i:IDUMPElement in itemsDUs) {
				position=i.get_position();
				if (position==-1) {
					list.push({r:i, p:999999});
				/*if (position==333333) {
					listMiddle.push({r:i});
				if (position==666666) {
					listEnd.push({r:i});
				*/} else {
					listToSort.push({r:i, p:position});
				}
			}
			listToSort.sortOn('p', Array.NUMERIC);
			// add elements with any order
			listToSort=listToSort.concat(list);
			//listToSort.concat(listMiddle);
			//listToSort.concat(listEnd);
			// clear
			vc.removeAllElements();
			// draw
			for each(var j:Object in listToSort) {
				//LOG(0, '>>>>>>>>>>>>>>>>>>>>>>>>>>'+VCMainPanelIPanelElement(items[IDUMPElement(j.r).get_id()]).getComponent().getWidth(),2);
				vc.addElement(items[IDUMPElement(j.r).get_id()]);
			}
			vc.redraw();
			vc.setW(AppCfg.appScreenW);
		}
		
		
		private function addComponentButton(b:DUMPButton):void {
			var cB:VCMainPanelButtonElement=new VCMainPanelButtonElement();
			cB.construct(
				b.get_id()
				,el_c
				,PictureStoreroom.getPicture(b.get_iconUp())
			);
			if (b.get_textTip()) {cB.setToolTipText(b.get_textTip());}
			addComponent(cB, b)
		}
		
		private function addComponent(c:VCMainPanelIPanelElement, d:IDUMPElement):void {
			// store
			itemsDUs[d.get_id()]=d;
			items[d.get_id()]=c;
		}
		
		private function el_c(target:VCMainPanelIPanelElement, eventType:String, eventDetails:Object):void {
			// forward message to system
			get_envRef().listen(ID_E_BUTTON_PRESSED, target.getID());
		}
		
		private function el_mp(target:VCMainPanel, eventType:String, eventDetails:Object):void {
			LOG(3,'vc action:eventType='+eventType+'details'+eventDetails, 0);
			
			/*switch (eventType) {
			
			case VCMainPanel.:
				break;
			
			
			}*/
			
		}
		
		
		//{ =*^_^*= private 
		private var itemsDUs:Array=[];
		private var items:Array=[];
		private var vc:VCMainPanel;
		//} =*^_^*= END OF private
		
		
		//{ =*^_^*= d
		//} =*^_^*= END OF d
		
		//{ =*^_^*= event id
		/**
		 * data:buttonID:String
		 */
		public static const ID_E_BUTTON_PRESSED:String=NAME+'>ID_E_BUTTON_PRESSED';
		//} =*^_^*= END OF event id
		
		//{ =*^_^*= action id
		/**
		 * data:VCMainPanel
		 */
		public static const ID_A_REGISTER_SINGLETON_VC:String = NAME + '>ID_A_REGISTER_SINGLETON_VC';
		/**
		 * data:DUMPButton
		 */
		public static const ID_A_ADD_BUTTON:String = NAME + '>ID_A_ADD_BUTTON';
		/**
		 * {e:VCMainPanelIPanelElement, d:IDUMPElement}
		 */
		public static const ID_A_ADD_ELEMENT:String = NAME + '>ID_A_ADD_ELEMENT';
		/**
		 * data:DisplayObject
		 */
		public static const ID_A_ADD_POPUP:String = NAME + '>ID_A_ADD_POPUP';
		/**
		 * data:DisplayObject
		 */
		public static const ID_A_REMOVE_POPUP:String = NAME + '>ID_A_REMOVE_POPUP';
		public static const ID_A_REDRAW_VC:String=NAME+'>ID_A_REDRAW_VC';
		/**
		 * 0-true, 1-false, 2-toggle
		 */
		public static const ID_A_SET_MENU_VISIBILITY:String=NAME+'>ID_A_SET_MENU_VISIBILITY';
		/**
		 * {menuData:Object//raw menu data//, layoutsList:Array}
		 */
		public static const ID_A_PREPARE_MENU:String=NAME+'>ID_A_PREPARE_MENU';
		/**
		 * {id:String, details:String}
		 */
		public static const ID_E_MENU_ACTION:String="ID_E_MENU_ACTION";
		//} =*^_^*= END OF action id
		
		public override function autoSubscribeEvents():Array {
			return [
				ID_A_REGISTER_SINGLETON_VC
				,ID_A_ADD_BUTTON
				,ID_A_ADD_ELEMENT
				,ID_A_REDRAW_VC
				,ID_A_ADD_POPUP
				,ID_A_REMOVE_POPUP
				,ID_A_SET_MENU_VISIBILITY
				,ID_A_PREPARE_MENU
			];
		}
		
		public static const NAME:String = 'VCMMainPanel';
	}
}


//{ =*^_^*= History
/* > (timestamp) [ ("+" (added) ) || ("-" (removed) ) || ("*" (modified) )] (text)
 * > 
 */
//} =*^_^*= END OF History

// template last modified:11.03.2011_[18#51#40]_[5]