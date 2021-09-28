package ttcc.v.pl {
	
	//{ =*^_^*= import
	import org.aswing.CustomJFrame;
	import ttcc.LOG;
	import ttcc.v.AVCWW;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import org.aswing.AssetIcon;
	import org.aswing.border.EmptyBorder;
	import org.aswing.BorderLayout;
	import org.aswing.BoxLayout;
	import org.aswing.colorchooser.VerticalLayout;
	import org.aswing.FlowLayout;
	import org.aswing.JButton;
	import org.aswing.JFrame;
	import org.aswing.JLabel;
	import org.aswing.JPanel;
	import org.aswing.JProgressBar;
	import org.aswing.JScrollBar;
	import org.aswing.JScrollPane;
	import org.aswing.JTextField;
	import org.aswing.SoftBoxLayout;
	//} =*^_^*= END OF import
	
	
	
	/**
	 * 
	 * @author Jinanoimatey Dragoncat
	 * @version 0.0.0
	 * @created 12.05.2012 14:37
	 */
	public class VCPresentationLoader extends AVCWW {
		
		//{ =*^_^*= CONSTRUCTOR
		
		public function setResources(windowTitle:String, labelButtonLoad:String, labelButtonApply:String, windowIconImage:DisplayObject, wndMinW:uint=300, wndMinH:uint=300):void {
			text_b_apply=labelButtonApply;
			text_b_load=labelButtonLoad;
			wnd_title=windowTitle;
			wnd_minH=wndMinH;
			wnd_minW=wndMinW;
			this.windowIconImage=windowIconImage;
		}
		
		public function construct():void {
			configureVC();
			configureControll();
		}
		//} =*^_^*= END OF CONSTRUCTOR
		
		
		//{ =*^_^*= user access
		/**
		 * @param	outputID
		 * @param	image [DisplayObject]
		 */
		public function setImageListOutput(outputID:uint, images:Array):void {
			switch (outputID) {
			
			case ID_OUT_IMAGE_PAGES:
				sb.setValue(0);
				if (images==null) {
					contentPane.removeAll(); 
					return;
				}
				
				/*var longPage:Sprite=new Sprite();
				var im:DisplayObject;
				var imp:DisplayObject;
				for (var i:uint in image) {
					imp=im;
					im=image[i];
					if (i>0) {im.y=imp.y+imp.height;}
					longPage.addChild(im);
				}
				contentPane.append(new PresentationPage(longPage));
				*/
				for each(var i:DisplayObject in images) {
					contentPane.append(new PresentationPage(i));
				}
				el_sb(null);
				break;
			
			}
		}
		
		
		public function setTextOutput(outputID:uint, text:String):void {
			switch (outputID) {
			
			case ID_OUT_TEXT_STATE:
				if (text==null) {text='';}
				dtState.setText(text);
				break;
			
			
			}
		}
		
		
		public function setUintOutput(outputID:uint, value:uint):void {
			switch (outputID) {
			
			case ID_OUT_UINT_DISPLAY_MODE:
				switch (value) {
				
				case ID_MODE_LOAD:
					bApply.setEnabled(false);
					p0.remove(pb0);
					p0.append(bljp, BorderLayout.NORTH);
					bLoad.setEnabled(true);
					break;
				case ID_MODE_PROGRESS_BAR:
					bApply.setEnabled(false);
					p0.remove(bljp);
					p0.append(pb0, BorderLayout.NORTH);
					break;
				case ID_MODE_LOADED:
					bApply.setEnabled(true);
					p0.remove(pb0);
					p0.remove(bljp);
					p0.append(bljp, BorderLayout.NORTH);
					bLoad.setEnabled(true);
					break;
				case ID_MODE_READY:
					bApply.setEnabled(true);
					p0.remove(pb0);
					p0.remove(bljp);
					break;
				
				}
				break;
			
			}
		}
		public function setNumberOutput(outputID:uint, value:Number):void {
			switch (outputID) {
			
			case ID_OUT_NUMBER_PROGRESS:
				pb0.setValue(Math.round(100*Math.max(0, Math.min(1, value))));
				break;
			
			
			}
		}
		
		//{ =*^_^*= id
		public static const ID_E_B_UPLOAD:String = '>ID_E_B_UPLOAD';
		public static const ID_E_B_SELECT_FILE:String = '>ID_E_B_SELECT_FILE';
		/**
		 * data:0...1
		 */
		public static const ID_E_SCROLL:String = '>ID_E_SCROLL';
		
		/**
		 * show load button or progressbar, set apply button enabled or disabled
		 */
		public static const ID_OUT_UINT_DISPLAY_MODE:uint=0;
		/**
		 * progress bar value 0...1
		 */
		public static const ID_OUT_NUMBER_PROGRESS:uint=0;
		/**
		 * state text
		 */
		public static const ID_OUT_TEXT_STATE:uint=0;
		/**
		 * pages to scroll, pass null to clear
		 */
		public static const ID_OUT_IMAGE_PAGES:uint=0;
		
		/// display modes:
		public static const ID_MODE_LOAD:uint=0;
		public static const ID_MODE_PROGRESS_BAR:uint=1;
		public static const ID_MODE_READY:uint=2;
		public static const ID_MODE_LOADED:uint=3;
		//} =*^_^*= END OF id
		
		
		//} =*^_^*= END OF user access
		
		//{ =*^_^*= view
		private function configureVC():void {
			// prepare frame
			vc=new CustomJFrame(null, wnd_title);
			vc.construct(NAME);
			registerGUIWindowModel(vc.getModel());
			//addToContainer();
			vc.setIcon(new AssetIcon(windowIconImage,-1,-1,true));
			vc.getContentPane().setLayout(new BorderLayout(0,0));
			var titlebarH:uint=vc.getTitleBar().getSelf().getInsets().getMarginHeight();
			vc.setMinimumWidth(wnd_minW);
			vc.setMinimumHeight(wnd_minH+titlebarH);
			vc.setSizeWH(wnd_minW,wnd_minH+titlebarH);
			
			//0
			p0=new JPanel(new BorderLayout());
			vc.getContentPane().append(p0, BorderLayout.NORTH);
			
			//bLoad
			bLoad=new JButton(text_b_load);
			bljp=new JPanel(new FlowLayout(FlowLayout.LEFT,0,0,false));
			bljp.append(bLoad);
			//p0.append(bljp, BorderLayout.NORTH);
			
			// progress bar
			pb0=new JProgressBar(JProgressBar.HORIZONTAL);
			//p0.append(pb0, BorderLayout.NORTH);pb0.setValue(55);
			
			
			//state text
			dtState=new JTextField('state:press load button');
			dtState.setEditable(false);dtState.mouseChildren=false;
			dtState.setOpaque(false);dtState.setBorder(new EmptyBorder());
			p0.append(dtState, BorderLayout.CENTER);
			
			//scroll pane with custom elements
			contentPane=new JPanel(new BoxLayout(BoxLayout.Y_AXIS, 5));
			contentScrollPane=new JScrollPane(contentPane, JScrollPane.SCROLLBAR_AS_NEEDED, JScrollPane.SCROLLBAR_NEVER);
			sb=contentScrollPane.getVerticalScrollBar();
			contentScrollPane.getVerticalScrollBar().addStateListener(el_sb);
			
			vc.getContentPane().append(contentScrollPane, BorderLayout.CENTER);
			
			//bApply
			bApply=new JButton(text_b_apply);
			var bajp:JPanel=new JPanel(new FlowLayout(FlowLayout.LEFT,0,0,false));
			bajp.append(bApply);
			vc.getContentPane().append(bajp, BorderLayout.SOUTH);
			
			//c
			vc.show();
		}
		
		private function addToContainer():void {
			container.parent.addChild(vc);
			container.parent.swapChildren(container, vc);
			container.parent.removeChild(container);
			container=vc;
		}
		
		public function get_displayObject():DisplayObject {return container;}
		
		private var wnd_title:String;
		private var windowIconImage:DisplayObject;
		
		public function set_text_b_load(a:String):void {text_b_load = a;}
		public function set_text_b_apply(a:String):void {text_b_apply = a;}
		private var text_b_load:String;
		private var text_b_apply:String;
		
		private var container:Sprite=new Sprite;
		private var p0:JPanel;
		private var bLoad:JButton;
		private var bljp:JPanel;//load button panel
		private var bApply:JButton;
		private var dtState:JTextField;
		private var pb0:JProgressBar;
		private var contentScrollPane:JScrollPane;
		private var sb:JScrollBar;
		private var contentPane:JPanel;
		//} =*^_^*= END OF view
		
		
		//{ =*^_^*= controll
		private function configureControll():void {
			bLoad.addActionListener(el_b);
			bApply.addActionListener(el_b);
		}
		
		private function el_b(e:Event):void {
			switch (e.target) {
			
			case bLoad:
				listenerRef(this, ID_E_B_UPLOAD);
				break;
			case bApply:
				listenerRef(this, ID_E_B_SELECT_FILE);
				break;
			
			}
		}
		
		private function el_sb(e:Object):void {
			listenerRef(this, ID_E_SCROLL, sb.getValue()/(sb.getMaximum()-sb.getMinimum()));
			//var yy:Number = sb.getValue()/(sb.getMaximum()-sb.getMinimum());
			//trace("vscroll value : " + sb.getValue()+'cc='+yy);
			//LOG(3,['scroll calc='+uint(yy*100)+'; cur,max,min:',sb.getValue(), sb.getMaximum(),sb.getMinimum()])
		}
		//} =*^_^*= END OF controll
		
		
		//{ =*^_^*= events
		/**
		 * @param	listener function (target:VCPresentationLoader, eventType:String, details:Object=null):void;
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
		
		public static const NAME:String='VCPresentationLoader';
		
		
	}
}

//{ =*^_^*= import
import flash.display.DisplayObject;
import org.aswing.AssetPane;
import org.aswing.BorderLayout;
import org.aswing.JPanel;
//} =*^_^*= END OF import

class PresentationPage extends AssetPane {
		
	//{ =*^_^*= CONSTRUCTOR
	function PresentationPage (d:DisplayObject) {
		super(d, AssetPane.CENTER);
	}
	//} =*^_^*= END OF CONSTRUCTOR
	
}
	
//{ =*^_^*= History
/* > (timestamp) [ ("+" (added) ) || ("-" (removed) ) || ("*" (modified) )] (text)
 * > 
 */
//} =*^_^*= END OF History

// template last modified:11.03.2011_[18#51#40]_[5]