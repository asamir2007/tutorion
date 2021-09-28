// Project TTCC
package ttcc.c.vcm {
	
	//{ =*^_^*= import
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import ttcc.APP;
	import ttcc.Application;
	import ttcc.cfg.AppCfg;
	import ttcc.LOG;
	import ttcc.media.Text;
	import ttcc.v.msg.VCMessageBox;
	import ttcc.v.msg.VCMessageBoxWithButtons;
	import ttcc.v.VCMainScreen;
	//} =*^_^*= END OF import
	
	/**
	 * display manager - controlls main interface
	 * @author Jinanoimatey Dragoncat
	 * @version 0.0.0
	 * @created 26.05.2012_02#54#22
	 */
	public class VCMMainScreen extends AVCM {
		
		//{ =*^_^*= CONSTRUCTOR
		
		function VCMMainScreen (app:Application) {
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
			case ID_A_POSITION_COMPONENTS:
				vc.positionComponents();
				break;
				
			case ID_A_DISPLAY_QUERY:
				displayQuery(details.title, details.text, details.buttons);
				break;
			case ID_A_DISPLAY_NOTIFICATION:
				displayMessage(details.title, details.text);
				break;
				
				var mb:VCMessageBox = new VCMessageBox();
				mb.setAppRef_(a);
				var ww:int=300;
				var wh:int=300;
				var ico:DisplayObject;
				if (details.hasOwnProperty('ico')) {ico=details.ico;}
				if (details.hasOwnProperty('w')) {ww=details.w;}
				if (details.hasOwnProperty('h')) {ww=details.h;}
				mb.setAppRef_(a);
				mb.setResources('msgboxid',details.title,ico,ww,wh);
				mb.construct(null);
				mb.setHtmlText(details.text);
				break;
				
			case ID_A_SET_MAIN_SCREEN_VISIBILITY:
				vc.get_displayObject().visible = details;
				break;
				
			case ID_A_DISPLAY_DISCONNECTED_MESSAGE:
				setVisibilityBlockingMessage(true,1);
				break;
			case ID_A_DISPLAY_SUSPEND_MESSAGE:
				setVisibilityBlockingMessage(details,2);
				break;
			case ID_A_DISPLAY_NO_LECTOR_MESSAGE:
				setVisibilityBlockingMessage(details,3);
				break;
				

			}
		}
		
		private function setVisibility(target:DisplayObject, a:Boolean):void {
			if (!target) {return;}target.visible = a;
		}
		
		private function configureVC():void {
			vc.orderLayers();
			//vc.positionComponents();
			vc.setListener(el_vc);
		}
		
		private function el_vc (target:VCMainScreen, eventType:String, details:Object=null):void {
			switch (eventType) {
			
			case VCMainScreen.ID_E_STAGE_RESIZE:
				if (AppCfg.appScreenW<AppCfg.appScreenMinW||AppCfg.appScreenH<AppCfg.appScreenMinH) {
					// block & message
					setVisibilityBlockingMessage(true,0);
					return;
				}
				setVisibilityBlockingMessage(false,0);
				break;
			
			}
		}
		
		/**
		 * 
		 * @param	title
		 * @param	text
		 * @param	buttons [{text:String, type:messageToSend, details:messageToSend}]
		 */
		private function displayQuery(title:String, text:String, buttons:Array):void {
			var mb:VCMessageBoxWithButtons=new VCMessageBoxWithButtons;
			mb.setAppRef_(this.a);
			mb.setResources(
				'infomsgboxid'
				,title
				,null
				,Math.min(AppCfg.appScreenW, 400)
				,Math.min(AppCfg.appScreenH, 200)
			);
			mb.construct(null, vc.get_popupLayer(), buttons);
			mb.setHtmlText(text);
		}
		
		private function displayMessage(title:String, text:String):void {
			var mb:VCMessageBox=new VCMessageBox;
			mb.setAppRef_(this.a);
			mb.setResources(
				'infomsgboxid'
				,title
				,null
				,Math.min(AppCfg.appScreenW, 400)
				,Math.min(AppCfg.appScreenH, 200)
			);
			mb.construct(null, vc.get_popupLayer());
			mb.setHtmlText(text);
		}
		
		/**
		 * 
		 * @param	a
		 * @param	messageType 0-min screen size 1-disconnected 2-suspend, 3-no lector
		 */
		private function setVisibilityBlockingMessage(a:Boolean, messageType:int=0):void {
			LOG(3, 'setVisibilityBlockingMessage>'+a+',messageType='+messageType, 2);
			//if (vc.get_blockingMessage()==null) {
			var mb:VCMessageBox;
			
			mb = vc.get_blockingMessage();
			if (mb) {mb.destruct();mb.setAppRef_(null);vc.set_blockingMessage(null)}
			mb = vc.get_blockingSuspendMessage();
			if (mb) {mb.destruct();mb.setAppRef_(null);vc.set_blockingSuspendMessage(null)}
			mb = vc.get_blockingNoLectorMessage();
			if (mb) {mb.destruct();mb.setAppRef_(null);vc.set_blockingNoLectorMessage(null)}
			
			if ((messageType==0)&&a&&!disconnected) {
				mb=new VCMessageBox;
				mb.setAppRef_(this.a);
				mb.setResources(
					'msgboxid'
					,APP.lText().get_TEXT(Text.ID_TEXT_MIN_RESOLUTION_NOTIFICATION_TITLE)
					,null
					,Math.min(AppCfg.appScreenW, 400)
					,Math.min(AppCfg.appScreenH, 200)
				);
				mb.construct(null, vc.get_blockingMessageLayer());
				mb.setHtmlText(
					APP.lText().get_TEXT(Text.ID_TEXT_MIN_RESOLUTION_NOTIFICATION_TEXT)
					+AppCfg.appScreenMinW+'x'+AppCfg.appScreenMinH+' '
					+APP.lText().get_TEXT(Text.ID_TEXT_PIXELS)+'\n'
					+APP.lText().get_TEXT(Text.ID_TEXT_MIN_RESOLUTION_NOTIFICATION_CURRENT)
					+AppCfg.appScreenW+'x'+AppCfg.appScreenH
				);
				vc.set_blockingMessage(mb);
				//vc.get_blockingMessageLayer().visible=false;
			}
			
			if (messageType==1 && vc.get_blockingDisconnectMessage()==null) {
				mb=new VCMessageBox;
				mb.setAppRef_(this.a);
				mb.setResources(
					'msgboxid'
					,APP.lText().get_TEXT(Text.ID_TEXT_ERROR)
					,null
					,Math.min(AppCfg.appScreenW, 400)
					,Math.min(AppCfg.appScreenH, 200)
				);
				mb.construct(null, vc.get_blockingMessageLayer());
				mb.setHtmlText(APP.lText().get_TEXT(Text.ID_TEXT_DISCONNECTED_MSG_TEXT));
			//}
				vc.set_blockingDisconnectMessage(mb);
				//vc.get_blockingMessageLayer().visible=true;
			}
			
			if (messageType==2 && vc.get_blockingSuspendMessage()==null) {
				mb=new VCMessageBox;
				mb.setAppRef_(this.a);
				mb.setResources(
					'msgboxid'
					,APP.lText().get_TEXT(Text.ID_TEXT_ERROR)
					,null
					,Math.min(AppCfg.appScreenW, 400)
					,Math.min(AppCfg.appScreenH, 200)
				);
				mb.construct(null, vc.get_blockingMessageLayer());
				mb.setHtmlText(APP.lText().get_TEXT(Text.ID_TEXT_SUSPEND_MSG_TEXT));
			//}
				vc.set_blockingSuspendMessage(mb);
				//vc.get_blockingMessageLayer().visible=true;
			}
			
			if (messageType==3 && vc.get_blockingNoLectorMessage()==null) {
				mb=new VCMessageBox;
				mb.setAppRef_(this.a);
				mb.setResources(
					'msgboxid'
					,APP.lText().get_TEXT(Text.ID_TEXT_PLEASE_WAIT)
					,null
					,Math.min(AppCfg.appScreenW, 400)
					,Math.min(AppCfg.appScreenH, 200)
				);
				mb.construct(null, vc.get_blockingMessageLayer());
				mb.setHtmlText(APP.lText().get_TEXT(Text.ID_TEXT_NO_LECTOR));
			//}
				vc.set_blockingNoLectorMessage(mb);
				//vc.get_blockingMessageLayer().visible=true;
			}
			
			if (!disconnected&&vc.get_blockingDisconnectMessage()) {
				disconnected=true
				vc.get_blockingDisconnectMessage().get_displayObject().visible=true;
				vc.get_blockingDisconnectMessage().centerOnScreen(true);
			}
			if (messageType==0) {
				if (vc.get_blockingMessage()) {
					if (disconnected) {
						vc.get_blockingMessage().get_displayObject().visible=false;
					} else {
						vc.get_blockingMessage().get_displayObject().visible=a;
					}
					vc.get_blockingMessage().centerOnScreen(true);
				}
			}
			//if (screenBlocked==a) {return;}
			//screenBlocked=a;
			
			var dddd:DisplayObject=vc.get_blockingMessageLayer();
			vc.get_blockingMessageLayer().visible=disconnected||a;
			vc.setEnabled(!(a||disconnected));
		}
		private var disconnected:Boolean;
		
		//{ =*^_^*= private 
		private var a:Application;
		private var vc:VCMainScreen;
		//} =*^_^*= END OF private
		
		
		//{ =*^_^*= id
		/**
		 * data:VCMainScreen
		 */
		public static const ID_A_REGISTER_SINGLETON_VC:String = NAME + '>ID_A_REGISTER_SINGLETON_VC';
		/**
		 * data:Boolean
		 */
		public static const ID_A_DISPLAY_DISCONNECTED_MESSAGE:String=NAME+'>ID_A_DISPLAY_DISCONNECTED_MESSAGE';
		/**
		 * data:Boolean
		 */
		public static const ID_A_DISPLAY_SUSPEND_MESSAGE:String=NAME+'>ID_A_DISPLAY_SUSPEND_MESSAGE';
		public static const ID_A_DISPLAY_NO_LECTOR_MESSAGE:String=NAME+'>ID_A_DISPLAY_NO_LECTOR_MESSAGE';
		public static const ID_A_SET_MAIN_SCREEN_VISIBILITY:String=NAME+'>ID_A_SET_MAIN_SCREEN_VISIBILITY';
		public static const ID_A_POSITION_COMPONENTS:String=NAME+'>ID_A_POSITION_COMPONENTS';
		/**
		 * {text:String, title:String [,w:int//width//, h:int, ico:DisplayObject]}
		 */
		public static const ID_A_DISPLAY_NOTIFICATION:String=NAME+'>ID_A_DISPLAY_NOTIFICATION';
		/**
		 * {text:String, title:String, buttons:Array[{text:String, type:messageToSend, details:messageToSend}] [,w:int//width//, h:int, ico:DisplayObject]}
		 */
		public static const ID_A_DISPLAY_QUERY:String=NAME+'>ID_A_DISPLAY_QUERY';
		//} =*^_^*= END OF id
		
		public override function autoSubscribeEvents():Array {
			return [
				ID_A_REGISTER_SINGLETON_VC
				,ID_A_SET_MAIN_SCREEN_VISIBILITY
				,ID_A_POSITION_COMPONENTS
				,ID_A_DISPLAY_NOTIFICATION
				,ID_A_DISPLAY_QUERY
				,ID_A_DISPLAY_DISCONNECTED_MESSAGE
				,ID_A_DISPLAY_SUSPEND_MESSAGE
				,ID_A_DISPLAY_NO_LECTOR_MESSAGE
			];
		}
		
		public static const NAME:String = 'VCMMainScreen';
	}
}

//{ =*^_^*= History
/* > (timestamp) [ ("+" (added) ) || ("-" (removed) ) || ("*" (modified) )] (text)
 * > 
 */
//} =*^_^*= END OF History

// template last modified:11.03.2011_[18#51#40]_[5]