// Project TTCC
package ttcc.v {
	
	//{ =^_^= import
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import ttcc.cfg.AppCfg;
	import ttcc.v.av.VCAV;
	import ttcc.v.chat.VCChat;
	import ttcc.v.cl.VCCourseLoader;
	import ttcc.v.mp.VCMainPanel;
	import ttcc.v.pl.VCPresentationLoader;
	import ttcc.v.r.VCReplayManager;
	import ttcc.v.wb.VCWB;
	//} =^_^= END OF import
	
	
	
	/**
	 * main app window
	 * @author Jinanoimatey Dragoncat
	 * @version 0.0.0
	 * @created 26.05.2012_02#54#22
	 */
	public class VCMainScreen extends AVC {
		
		//{ =^_^= CONSTRUCTOR
		
		function VCMainScreen (w:uint, h:uint) {
			this.w = w;
			this.h = h;
			prepareContainer();
		}
		//} =^_^= END OF CONSTRUCTOR
		
		public function addInterface(a:DisplayObject):DisplayObject {
			return interfaceLayer.addChild(a);
		}
		
		public function removeInterface(a:DisplayObject):void {
			if (interfaceLayer.contains(a)) {interfaceLayer.removeChild(a);}
		}
		
		//{ =*^_^*= sort layers
		public function orderLayers():void {
			container.addChild(componentsLayer);
			if (mainPanel) {
				container.addChild(mainPanel.get_displayObject());
			}
			
			//if (chat) {componentsLayer.addChild(chat.get_displayObject());}
			//if (cl) {componentsLayer.addChild(cl.get_displayObject());}
			//if (pl) {componentsLayer.addChild(pl.get_displayObject());}
			
			container.addChild(interfaceLayer);
			container.addChild(mouseCursorLayer);
			positionComponents();
		}
		//} =*^_^*= END OF sort layers
		
		public function positionComponents():void {
			if (!container || !container.stage) {return;}
			if (mainPanel) {mainPanel.setW(container.stage.stageWidth);}
		}
		
		public function setEnabled(a:Boolean):void {
			get_displayObject().mouseEnabled=a;
			get_displayObject().mouseChildren=a;
		}
		
		
		public function get_chat():VCChat {return chat;}
		public function set_chat(a:VCChat):void {chat = a;/*orderLayers();*/}
		private var chat:VCChat;
		
		public function get_av():VCAV {return av;}
		public function set_av(a:VCAV):void {av = a;}
		private var av:VCAV;
		
		public function get_cl():VCCourseLoader {return cl;}
		public function set_cl(a:VCCourseLoader):void {cl = a;/*orderLayers();*/}
		private var cl:VCCourseLoader;
		
		public function get_pl():VCPresentationLoader {return pl;}
		public function set_pl(a:VCPresentationLoader):void {pl = a;/*orderLayers();*/}
		private var pl:VCPresentationLoader;
		
		public function get_wb():VCWB {return wb;}
		public function set_wb(a:VCWB):void {wb = a;/*orderLayers();*/}
		private var wb:VCWB;
		
		public function get_rm():VCReplayManager {return rm;}
		public function set_rm(a:VCReplayManager):void {rm = a;}
		private var rm:VCReplayManager;
		
		public function get_mainPanel():VCMainPanel {return mainPanel;}
		public function set_mainPanel(a:VCMainPanel):void {mainPanel = a;orderLayers();}
		private var mainPanel:VCMainPanel;
		
		/**
		 * dialog widows, other popups
		 */
		private var interfaceLayer:Sprite=new Sprite();

		public function get_componentsLayer():Sprite {return componentsLayer;}
		private var componentsLayer:Sprite=new Sprite();
		/**
		 * cursors
		 */
		private var mouseCursorLayer:Sprite=new Sprite();
		
		public function centerOnScreen(target:DisplayObject, ignoreObjectSize:Boolean = false):DisplayObject {
			if (!target) {return target;}
			if (ignoreObjectSize) {target.x = w/2;target.y = h/2;
			} else {target.x = w/2- target.width/2;target.y = h/2- target.height/2;}
			return target;
		}
		
		
		/**
		 * width
		 */
		private var w:uint;
		/**
		 * height
		 */
		private var h:uint;
		
		//{ =*^_^*= container
		private function prepareContainer():void {
			container = new Sprite();
			if (!container.stage) {container.addEventListener(Event.ADDED_TO_STAGE, el_addedToStage);} else {el_addedToStage();};
		}
		private function el_addedToStage(e:Event=null):void {
			container.stage.addEventListener(Event.RESIZE, el_StageResize);
			positionComponents();
		}
		private function el_StageResize(e:Event):void {
			AppCfg.appScreenW=container.stage.stageWidth;
			AppCfg.appScreenH=container.stage.stageHeight;
			positionComponents();
		}
		
		public function get_displayObject():Sprite {return container;}
		private var container:Sprite;
		//} =*^_^*= END OF container
		
		
		public static const NAME:String = 'VCMainScreen';
		
	}
}

//{ =^_^= History
/* > (timestamp) [ ("+" (added) ) || ("-" (removed) ) || ("*" (modified) )] (text)
 * > 
 */
//} =^_^= END OF History

// template last modified:15.01.2011_[00#08#13]_[6]