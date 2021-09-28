package ttcc.v.msg {
	
	//{ =*^_^*= import
	import flash.display.Sprite;
	import org.aswing.AsWingUtils;
	import org.aswing.CustomJFrame;
	import org.aswing.geom.IntPoint;
	import org.aswing.JPanel;
	import org.aswing.JScrollPane;
	import org.aswing.JTextArea;
	import ttcc.Application;
	import ttcc.cfg.AppCfg;
	import ttcc.LOG;
	import ttcc.v.AVCWW;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import org.aswing.AssetIcon;
	import org.aswing.BorderLayout;
	import org.aswing.JButton;
	import org.aswing.JFrame;
	import ttcc.v.Lib;
	//} =*^_^*= END OF import
	
	
	
	/**
	 * 
	 * @author Jinanoimatey Dragoncat
	 * @version 0.0.0
	 * @created 04.10.2012 1:35
	 */
	public class VCMessageBox {
		
		//{ =*^_^*= CONSTRUCTOR
		public function setResources(id:String, windowTitle:String, windowIconImage:DisplayObject, wndMinW:uint=300, wndMinH:uint=300):void {
			this.id=id;
			wnd_title=windowTitle;
			wnd_minH=wndMinH;
			wnd_minW=wndMinW;
			this.windowIconImage=windowIconImage;
		}
		
		public function construct(eventsPipe:Function, owner:DisplayObject=null):void {
			listenerRef=eventsPipe;
			
			configureVC(owner);
			configureControll();
		}
		public function destruct():void {
			if (vc) {vc.dispose();}
			this.vc=null;
		}
		
		//} =*^_^*= END OF CONSTRUCTOR
		
		
		
		//{ =*^_^*= user access
		//} =*^_^*= END OF user access
		
		//{ =*^_^*= view
		private function configureVC(owner:DisplayObject):void {
			// prepare frame
			if (!owner) {owner=appRef().get_mainScreen().get_popupLayer();}
			vc=new JFrame(owner, wnd_title);
			vc.getTitleBar().setIconifiedButton(null);
			//addToContainer();
			vc.setIcon(new AssetIcon(windowIconImage,-1,-1,true));
			vc.getContentPane().setLayout(new BorderLayout(0,0));
			var titlebarH:uint=vc.getTitleBar().getSelf().getInsets().getMarginHeight();
			vc.setMinimumWidth(wnd_minW);
			vc.setMinimumHeight(wnd_minH+titlebarH);
			vc.setSizeWH(wnd_minW,wnd_minH+titlebarH);
			
			//text field
			dt=new JTextArea;
			dt.setEditable(false);dt.setWordWrap(true);
			dtScrollPane=new JScrollPane(dt, JScrollPane.SCROLLBAR_AS_NEEDED, JScrollPane.SCROLLBAR_AS_NEEDED);
			vc.getContentPane().append(dt, BorderLayout.CENTER);
			
			//ok
			/*bOk=Lib.createSimpleButton('ok', el_b, 'OK',true,false,null);
			vc.getContentPane().append(bOk, BorderLayout.PAGE_END);
			vc.setDefaultCloseOperation(JFrame.DISPOSE_ON_CLOSE);*/
			// center
			centerOnScreen();
			//c
			vc.show();
		}
		
		public function centerOnScreen(useCFGValue:Boolean=false):void {
			var location:IntPoint;
			if (useCFGValue) {
				location = new IntPoint(AppCfg.appScreenW/2,AppCfg.appScreenH/2);
			} else {
				location = new IntPoint(
					appRef.get_mainScreen().get_displayObject().width/2
					,appRef.get_mainScreen().get_displayObject().height/2
				);
			}
			
			location.x -= vc.getWidth()/2;
			location.y -= vc.getHeight()/2;
			vc.setLocation(location);
		}
		
		public function addHtmlText(text:String):void {
			dt.setHtmlText(dt.getHtmlText().concat(text));
		}
		
		public function setHtmlText(text:String):void {
			dt.setHtmlText(text);
		}
		
		
		private function el_b(e:Event):void {
			vc.dispose();
		}
		
		public function get_displayObject():DisplayObject {return container;}
		public function setAppRef_(a:Application):void {appRef=a;}
		private var appRef:Application;		
		
		private var id:String;
		private var wnd_title:String;
		private var windowIconImage:DisplayObject;
		private var dt:JTextArea;
		private var bOk:JButton;
		private var dtScrollPane:JScrollPane;
		private var vc:JFrame=new JFrame;
		
		
		private function addToContainer():void {
			container.parent.addChild(vc);
			container.parent.swapChildren(container, vc);
			container.parent.removeChild(container);
			container=vc;
		}
		private var container:Sprite=new Sprite;
	
		//} =*^_^*= END OF view
		
		
		//{ =*^_^*= controll
		private function configureControll():void {
		}
		//} =*^_^*= END OF controll
		
		
		//{ =*^_^*= events
		/**
		 * @param listener function (target:VCMessageBox, eventType:String, details:Object=null):void;
		 */
		public function setListener(listener:Function):void {
			listenerRef = listener;
		}
		private var listenerRef:Function;
		//} =*^_^*= END OF events
		
		
		//{ =*^_^*= data
		private var wnd_minH:uint;
		private var wnd_minW:uint;
		//} =*^_^*= END OF data
		
		//{ =*^_^*= id
		//public static const ID_E_ITEM_SELECTED:String = '>ID_E_ITEM_SELECTED';
		//} =*^_^*= END OF id
		
		public static const NAME:String='VCMessageBox';
		
		
	}
}


//{ =*^_^*= History
/* > (timestamp) [ ("+" (added) ) || ("-" (removed) ) || ("*" (modified) )] (text)
 * > 
 */
//} =*^_^*= END OF History

// template last modified:11.03.2011_[18#51#40]_[5]