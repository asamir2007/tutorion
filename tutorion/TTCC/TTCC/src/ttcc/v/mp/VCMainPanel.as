package ttcc.v.mp {
	
	//{ =*^_^*= import
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import org.aswing.ASColor;
	import org.aswing.BorderLayout;
	import org.aswing.colorchooser.ColorRectIcon;
	import org.aswing.Container;
	import org.aswing.FlowLayout;
	import org.aswing.JFrame;
	import org.aswing.JMenu;
	import org.aswing.JMenuItem;
	import org.aswing.JPanel;
	import org.aswing.JPopupMenu;
	import org.aswing.SoftBoxLayout;
	import org.aswing.SolidBackground;
	import ttcc.APP;
	import ttcc.d.a.DULayoutInfo;
	import ttcc.LOG;
	import ttcc.v.AVC;
	//} =*^_^*= END OF import
	
	
	
	/**
	 * 
	 * @author Jinanoimatey Dragoncat
	 * @version 0.0.0
	 * @created 01.03.2012 1:29
	 */
	public class VCMainPanel extends AVC {
		
		//{ =*^_^*= CONSTRUCTOR
		
		public function VCMainPanel():void {
			vcContainer=new Sprite();
			vcPopupContainer=new Sprite();
		}
		
		/**
		 * 
		 * @param	eventsPipe
		 * @param	panelH not used
		 * @param	distanceBetweenElements
		 */
		public function construct(eventsPipe:Function/*, panelH:uint=200*/, distanceBetweenElements:uint=3):void {
			listenerRef=eventsPipe;
			//wnd_H=panelH;
			gap=distanceBetweenElements;
			
			configureVC();
			configureControll();
		}
		//} =*^_^*= END OF CONSTRUCTOR
		
		
		//{ =*^_^*= user access
		public function redraw():void {
			vc.pack();
		}
		
		public function setBGColor(color:uint):void {
			vc.setBackgroundDecorator(new SolidBackground(new ASColor(color)));
		}
		
		public function removeAllElements():void {
			for each(var i:VCMainPanelIPanelElement in elementsList) {removeElement(i);}
		}
		public function addElement(element:VCMainPanelIPanelElement):void {
			// add element to list
			//if (elementsList.indexOf(element)!=-1) {return;}//already present
			elementsList.push(element);
			// add element's component
			vc.append(element.getComponent());
			// tell element about panel(owner)
			element.setOwner(this);
			
			redraw();
		}
		
		public function removeElement(element:VCMainPanelIPanelElement):void {
			if (elementsList.indexOf(element)==-1) {return;}//not found
			// set element's panel(owner) ref to null
			element.setOwner(null);
			// remove element from list
			elementsList.splice(elementsList.indexOf(element), 1);
			// remove component
			vc.remove(element.getComponent());
			
			redraw();
		}
		
		public function addPopupElement(target:DisplayObject, anchor:DisplayObject):void {
			vcPopupContainer.addChild(target);
		}
		public function removePopupElement(a:DisplayObject):void {
			while(vcPopupContainer.numChildren>0) {vcPopupContainer.removeChild(vcPopupContainer.getChildAt(0));}
		}
		//} =*^_^*= END OF user access
		
		//{ =*^_^*= id
		//} =*^_^*= END OF id
		
		
		//{ =*^_^*= view
		private function configureVC():void {
			// prepare frame
			vc=new JPanel(new FlowLayout(FlowLayout.LEFT, gap, 0));
			vcContainer.addChild(vc);
			vcContainer.addChild(vcPopupContainer);
			//vc.setPreferredHeight(wnd_H);
			//vc.setHeight(wnd_H);
			
		}
		/**
		 * @param	a 0-true, 1-false, 2-toggle
		 */
		public function setMenuVisibility(a:int):void {
			if (a==2) {a=int(!popupMenu.isVisible());}
			if (a==0) {popupMenu.setVisible(false);}
			if (a==1) {popupMenu.show(vc, 0, 30);}
		}
		
		public function prepareMenu(rawMenuData:Object, layoutsMenuData:Array):void {
			popupMenu = new JPopupMenu();
			popupMenu.setInvoker(vc);
			
			var mr:JMenuItem;
			var menu:JMenu;
			for each(var i:Object in rawMenuData.items) {
				switch (i.type) {
				
				case "command":
					mr=popupMenu.addMenuItem(APP.lText().get_MainMenuItemLabel(i.id))
					mr.name=i.id;
					menuItemActionsList.push(i.id, {id:i.id, details:i.id});
					mr.addActionListener(el_menuItemAction);
					break;
					
				case "customMenu":
					switch (i.id) {
					
					case "windowsLayouts":
						menu = new JMenu(APP.lText().get_MainMenuItemLabel(i.id));
						//test
						//layoutsMenuData=[{id:"one", displayName:"dn one"}, {id:"two", displayName:"dn two"}]
						for each(var j:DULayoutInfo in layoutsMenuData) {
							mr=menu.addMenuItem(APP.lText().get_MainMenuItemLabel(j.get_labelID()));
							mr.name=j.get_id();
							menuItemActionsList.push(j.get_id(), {id:i.id, details:j.get_id()});
							mr.addActionListener(el_menuItemAction);
						}
						popupMenu.append(menu);
						break;
					}
					break;
				}
			}
			
			//var iconItem:JMenuItem = new JMenuItem("Has Icon Long Long Long item", new ColorRectIcon(20,20,ASColor.RED));
			//iconItem.addActionListener(el_menuItemAction);
			//popupMenu.append(iconItem);
		}
		
		
		private function el_menuItemAction(e:Event):void{
			var source:JMenuItem = e.target;
			//LOG(3,"el_menuItemAction>id:" + source.getName()+'/details:'+traceObject(menuItemActionsList[menuItemActionsList.indexOf(source.getName())+1]));
			listenerRef(this, ID_E_MENU_ACTION, menuItemActionsList[menuItemActionsList.indexOf(source.getName())+1]);
		}
		
		private var menuItemActionsList:Array=[];
		
		
		public function setW(w:int):void {
			if (!vc) {return;}
			vc.setWidth(w);
		}
		public function set_visible(a:Boolean):void {
			if (a) {
				//vcContainer.show();
			} else {
				//vcContainer.hide();
			}
		}
		
		public function getHeight():uint {return vcContainer.height;}
		
		public function get_displayObject():DisplayObject {return vcContainer;}
		
		private var wnd_title:String;
		
		private var vc:Container;
		private var popupMenu:JPopupMenu;
		private var vcContainer:Sprite;
		private var vcPopupContainer:Sprite;
		//} =*^_^*= END OF view
		
		
		//{ =*^_^*= controll
		private function configureControll():void {}
		//private function el_buttons(e:Event):void {}
		//} =*^_^*= END OF controll
		
		
		//{ =*^_^*= events
		/**
		 * @param	listener private function (target:VCMainPanel, eventType:String, details:Object=null):void {
		 */
		public function setListener(listener:Function):void {
			this.listenerRef = listener;
		}
		private var listenerRef:Function;
		//} =*^_^*= END OF events
		
		
		//{ =*^_^*= data
		private var wnd_H:uint;
		private var gap:uint;
		private var elementsList:Vector.<VCMainPanelIPanelElement>=new Vector.<VCMainPanelIPanelElement>;
		//} =*^_^*= END OF data
		
		//{ =*^_^*= id
		/**
		 * {id:String, details:String}
		 */
		public static const ID_E_MENU_ACTION:String="ID_E_MENU_ACTION";
		//} =*^_^*= END OF id
		
		
	}
}

//{ =*^_^*= History
/* > (timestamp) [ ("+" (added) ) || ("-" (removed) ) || ("*" (modified) )] (text)
 * > 
 */
//} =*^_^*= END OF History

// template last modified:11.03.2011_[18#51#40]_[5]