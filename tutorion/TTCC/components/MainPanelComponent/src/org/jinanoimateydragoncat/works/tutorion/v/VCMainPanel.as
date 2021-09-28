package org.jinanoimateydragoncat.works.tutorion.v {
	
	//{ =*^_^*= import
	import cccct.LOG;
	import ccct.v.AVC;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import org.aswing.ASColor;
	import org.aswing.JPanel;
	import org.aswing.SoftBoxLayout;
	import org.aswing.SolidBackground;
	import org.jinanoimateydragoncat.works.tutorion.v.AVC;
	//} =*^_^*= END OF import
	
	
	
	/**
	 * 
	 * @author Jinanoimatey Dragoncat
	 * @version 0.0.0
	 * @created 01.03.2012 1:29
	 */
	public class VCMainPanel extends AVC {
		
		//{ =*^_^*= CONSTRUCTOR
		
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
		public function setBGColor(color:uint):void {
			vc.setBackgroundDecorator(new SolidBackground(new ASColor(color)));
		}
		
		public function addElement(element:VCMainPanelIPanelElement):void {
			// add element to list
			if (elementsList.indexOf(element)!=-1) {return;}//already present
			elementsList.push(element);
			// add element's component
			vc.append(element.getComponent());
			// tell element about panel(owner)
			element.setOwner(this);
			
			vc.pack();vc.validate();
		}
		
		public function removeElement(element:VCMainPanelIPanelElement):void {
			if (elementsList.indexOf(element)==-1) {return;}//not found
			// set element's panel(owner) ref to null
			element.setOwner(null);
			// remove element from list
			elementsList.splice(elementsList.indexOf(element), 1);
			// remove component
			vc.remove(element.getComponent());
		}
		//} =*^_^*= END OF user access
		
		//{ =*^_^*= id
		//} =*^_^*= END OF id
		
		
		//{ =*^_^*= view
		private function configureVC():void {
			// prepare frame
			vc=new JPanel(new SoftBoxLayout(SoftBoxLayout.X_AXIS, gap, SoftBoxLayout.LEFT));
			//vc.setPreferredHeight(wnd_H);
			//vc.setHeight(wnd_H);
		}
		
		public function set_visible(a:Boolean):void {
			if (a) {
				vc.show();
			} else {
				vc.hide();
			}
		}
		
		public function get_displayObject():DisplayObject {return vc;}
		
		private var wnd_title:String;
		
		private var vc:JPanel;
		//} =*^_^*= END OF view
		
		
		//{ =*^_^*= controll
		private function configureControll():void {
		}
		private function el_buttons(e:Event):void {
			
		}
		//} =*^_^*= END OF controll
		
		
		//{ =*^_^*= events
		/**
		 * @param	listener function (target:VCMainPanel, eventType:String, details:Object=null):void;
		 */
		/*public function setListener(listener:Function):void {
			this.listener = listener;
		}
		private var listener:Function;
		*/
		//} =*^_^*= END OF events
		
		
		//{ =*^_^*= data
		private var wnd_H:uint;
		private var gap:uint;
		private var elementsList:Vector.<VCMainPanelIPanelElement>=new Vector.<VCMainPanelIPanelElement>;
		//} =*^_^*= END OF data
		
		//{ =*^_^*= id
		//} =*^_^*= END OF id
		
		
	}
}

//{ =*^_^*= History
/* > (timestamp) [ ("+" (added) ) || ("-" (removed) ) || ("*" (modified) )] (text)
 * > 
 */
//} =*^_^*= END OF History

// template last modified:11.03.2011_[18#51#40]_[5]