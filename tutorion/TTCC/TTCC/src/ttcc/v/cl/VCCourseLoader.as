package ttcc.v.cl {
	
	//{ =*^_^*= import
	import flash.display.Sprite;
	import org.aswing.CustomJFrame;
	import ttcc.LOG;
	import ttcc.v.AVCWW;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import org.aswing.AssetIcon;
	import org.aswing.BorderLayout;
	import org.aswing.event.TreeSelectionEvent;
	import org.aswing.JButton;
	import org.aswing.JFrame;
	import org.aswing.JScrollPane;
	import org.aswing.JTree;
	import org.aswing.tree.DefaultTreeModel;
	import ttcc.v.cl.d.DUTreeNode;
	//} =*^_^*= END OF import
	
	
	
	/**
	 * 
	 * @author Jinanoimatey Dragoncat
	 * @version 0.0.0
	 * @created 12.05.2012 14:37
	 */
	public class VCCourseLoader extends AVCWW {
		
		//{ =*^_^*= CONSTRUCTOR
		public function setResources(windowTitle:String, windowIconImage:DisplayObject, wndMinW:uint=300, wndMinH:uint=200):void {
			wnd_title=windowTitle;
			wnd_minH=wndMinH;
			wnd_minW=wndMinW;
			this.windowIconImage=windowIconImage;
		}
		
		public function construct(eventsPipe:Function):void {
			listenerRef=eventsPipe;
			
			
			configureVC();
			configureControll();
		}
		//} =*^_^*= END OF CONSTRUCTOR
		
		
		//{ =*^_^*= user access
		public function setData(data:DUTreeNode):void {
			// convert data, fill tree
			var n:TN = new TN(data.get_name(), uint.MAX_VALUE);
			
			var stackP:Array=[];
			var stackT:Vector.<DUTreeNode>=data.get_content().slice();
			var ct:DUTreeNode;
			var cp:TN;
			var cn:TN;
			for (var ii:uint in data.get_content()) {stackP.push(n);}
			for (;;) {
				if (stackT.length<1) {break;}
				ct=stackT.shift();
				cp=stackP.shift();
				cn=new TN(ct.get_name(), ct.get_id());
				cp.append(cn);
				if (ct.get_content()!=null) {
					for (ii in ct.get_content()) {stackP.unshift(cn);}//parents
					for each(var i:DUTreeNode in ct.get_content().slice().reverse()) {stackT.unshift(i);}//childrens
				}
			}
			
			var model:DefaultTreeModel = new DefaultTreeModel(n);		
			tree.setModel(model);
		}
		
		//} =*^_^*= END OF user access
		
		//{ =*^_^*= view
		private function configureVC():void {
			// prepare frame
			vc=new CustomJFrame(null, wnd_title);
			vc.construct(NAME);
			//addToContainer();
			vc.setIcon(new AssetIcon(windowIconImage,-1,-1,true));
			vc.getContentPane().setLayout(new BorderLayout(0,0));
			var titlebarH:uint=vc.getTitleBar().getSelf().getInsets().getMarginHeight();
			vc.setMinimumWidth(wnd_minW);
			vc.setMinimumHeight(wnd_minH+titlebarH);
			vc.setSizeWH(wnd_minW,wnd_minH+titlebarH);
			
			//tree
			tree = new JTree();
			//tree.setModel(model);
			tree.addSelectionListener(el_tree);
			//tree.setRootVisible(false);
			
			
			vc.getContentPane().append(new JScrollPane(tree), BorderLayout.CENTER);
			
			
			//c
			vc.show();
		}
		
		
		public function get_displayObject():DisplayObject {return container;}
		
		private var wnd_title:String;
		private var windowIconImage:DisplayObject;
		
		
		private function addToContainer():void {
			container.parent.addChild(vc);
			container.parent.swapChildren(container, vc);
			container.parent.removeChild(container);
			container=vc;
		}
		private var container:Sprite=new Sprite;
		private var tree:JTree;
	
		//} =*^_^*= END OF view
		
		
		//{ =*^_^*= controll
		private function configureControll():void {
		}
		
		private function el_tree(e:TreeSelectionEvent):void {
			listenerRef(this, ID_E_ITEM_SELECTED, e.getPath().getLastPathComponent().get_i());
		}
		//} =*^_^*= END OF controll
		
		
		//{ =*^_^*= events
		/**
		 * @param	listener function (target:VCCourseLoader, eventType:String, details:Object=null):void;
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
		/**
		 * sectedElement_id:uint
		 */
		public static const ID_E_ITEM_SELECTED:String = '>ID_E_ITEM_SELECTED';
		//} =*^_^*= END OF id
		
		public static const NAME:String='VCCourseLoader';
		
		
	}
}

import org.aswing.tree.DefaultMutableTreeNode;

class TN extends DefaultMutableTreeNode {
    
	public function TN(n:String, i:uint) {
		super(n);
		this.i=i;
    }
	
	public override function toString():String {return getUserObject();}
	
	public function get_i():uint {return i;}
	private var i:uint;
	
 }

//{ =*^_^*= History
/* > (timestamp) [ ("+" (added) ) || ("-" (removed) ) || ("*" (modified) )] (text)
 * > 
 */
//} =*^_^*= END OF History

// template last modified:11.03.2011_[18#51#40]_[5]