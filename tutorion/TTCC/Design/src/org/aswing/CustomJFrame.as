// Project TTCC
package org.aswing {
	
	//{ =*^_^*= import
	import flash.events.Event;
	import org.aswing.event.FrameEvent;
	import org.aswing.event.MovedEvent;
	import org.aswing.event.ResizedEvent;
	import org.aswing.event.WindowEvent;
	import org.aswing.geom.IntRectangle;
	import org.jinanoimateydragoncat.works.cyber_modules.d.SSTM;
	import ttcc.cfg.AppCfg;
	import ttcc.d.m.GUIWindowModel;
	import ttcc.LOG;
	import ttcc.v.VCMainScreen;
	//} =*^_^*= END OF import
	
	
	/**
	 * 
	 * @author Jinanoimatey Dragoncat
	 * @version 0.0.0
	 * @created 22.06.2012 0:53
	 */
	public class CustomJFrame extends JFrame {
		
		//{ =*^_^*= CONSTRUCTOR
		function CustomJFrame (mainScreenRef:VCMainScreen, owner:*=null, title:String="", modal:Boolean=false) {
			super(owner, title, modal);
			//setDragDirectly(true);
			this.mainScreenRef=mainScreenRef;
			// listeners
			addEventListener(ResizedEvent.RESIZED, el_vc);
			addEventListener(MovedEvent.MOVED, el_vc);
			addEventListener(FrameEvent.FRAME_CLOSING, el_vc);
			addEventListener(WindowEvent.WINDOW_ACTIVATED, el_vc);
			addEventListener(WindowEvent.WINDOW_DEACTIVATED, el_vc);
			//addEventListener(FrameEvent.FRAME_RESTORED, el_vc);
			//addEventListener(FrameEvent.FRAME_MAXIMIZED, el_vc);
			mainScreenRef.get_displayObject().stage.addEventListener(Event.MOUSE_LEAVE, controllResizeAndPosition);
			
			getTitleBar().setIconifiedButton(null);
		}
		
		public function construct(id:String):void {
			M=new GUIWindowModel();
			M.construct(id);
			M.setViewUpdatesListener(el_M);
		}
		public function destruct():void {
		}
		//} =*^_^*= END OF CONSTRUCTOR
		
		public function regiterScrollBar(id:uint, s:JScrollBar):void {
			scrollers.push(new ScrollBarSteward(id, s, el_s));
		}
		
		//{ =*^_^*= model
		/**
		 * @param	a updatedPropertiesIDList
		 */
		private function el_M(targetModel:SSTM, elementID:uint, updateFromDataport:Boolean=false):void {
			switch (elementID) {
			
			case SSTM.ID_P_A_RESET_MODEL:
				//some special actions
				break;
			
			case GUIWindowModel.ID_P_XY:
				writePositionAndSizeToModelLock=true;
				setX(M.get_x());
				setY(M.get_y());
				writePositionAndSizeToModelLock=false;
				break;
			
			case GUIWindowModel.ID_P_WH:
				writePositionAndSizeToModelLock=true;
				setWidth(M.get_w());
				setHeight(M.get_h());
				writePositionAndSizeToModelLock=false;
				break;
			
			case GUIWindowModel.ID_P_V:
				writePositionAndSizeToModelLock=true;
				setVisible(M.get_visible());
				writePositionAndSizeToModelLock=false;
				break;
			
			case GUIWindowModel.ID_P_A:
				writePositionAndSizeToModelLock=true;
				setActive(M.get_activated());
				writePositionAndSizeToModelLock=false;
				if (M.get_activated()) {show();}
				break;
			
			case GUIWindowModel.ID_P_SSV_0:
			case GUIWindowModel.ID_P_SSV_1:
			case GUIWindowModel.ID_P_SSV_2:
				if (!canUpdateModel_scrollers) {break;}
				set_scrollerScrollValue(elementID, M.get_scrollerScrollValue(elementID));
				break;
			
			case GUIWindowModel.ID_P_C_V_0:
			case GUIWindowModel.ID_P_C_V_1:
			case GUIWindowModel.ID_P_C_V_2:
			case GUIWindowModel.ID_P_C_V_3:
				writePositionAndSizeToModelLock=true;
				set_containerVisibility(elementID, M.get_containerVisibility(elementID));
				writePositionAndSizeToModelLock=false;
				break;
			
			}
		}
		
		public function getModel():GUIWindowModel {return M;}
		private var M:GUIWindowModel;
		//} =*^_^*= END OF model
		
		//{ =*^_^*= view controller
		private function set_scrollerScrollValue(elementID:uint, value:Number):void {
			if (!getScrollerByID(elementID)) {/*LOG(0,'no such scroller:'+elementID,1);*/return;}//no such scroller
			getScrollerByID(elementID).setValue(value);
		}
		
		private function set_containerVisibility(elementID:uint, value:Boolean):void {
			if (el_c==null) {return;}
			el_c(elementID, value);
			// override and place your code here
		}
		//} =*^_^*= END OF view controller
		
		//{ =*^_^*= private 
		private function getScrollerByID(id:uint):ScrollBarSteward {
			for each(var i:ScrollBarSteward in scrollers) {
				if (i.get_id()==id) {return i;}
			}
			return null;
		}
		private var scrollers:Array=[];
		
		private function el_s(id:uint, value:Number):void {
			M.set_scrollerScrollValue(id, value, false);
		}
		
		/**
		 * (id:uint, visibility:Boolean):void
		 */
		public function set_el_containerVisibilityChanged(a:Function):void {el_c = a;}
		private var el_c:Function;
		
		private function el_vc(e:Event):void {
			if (positionAndSizeListenerInternalLock) {return;}
			
			controllResizeAndPosition(null, e.type==MovedEvent.MOVED);
			
			
			switch (e.type) {
			
			case ResizedEvent.RESIZED:
				if (writePositionAndSizeToModelLock) {break;}
				//LOG(3,'window resized:'+ ResizedEvent(e).getNewSize().width+', '+ ResizedEvent(e).getNewSize().height,0);
				M.set_wh(ResizedEvent(e).getNewSize().width, ResizedEvent(e).getNewSize().height, false);
				break;
			case MovedEvent.MOVED:
				if (writePositionAndSizeToModelLock) {break;}
				//LOG(3,'window moved:'+ MovedEvent(e).getNewLocation().x+', '+ MovedEvent(e).getNewLocation().y,0);
				M.set_xy(getX(), getY(), false);
				break;
			case FrameEvent.FRAME_CLOSING:
				//LOG(0,'closing',1);
				M.set_visible(false, false);
				break;
			case WindowEvent.WINDOW_ACTIVATED:
				M.set_activated(true, false);
				break;
			case WindowEvent.WINDOW_DEACTIVATED:
				M.set_activated(false, false);
				break;
				
			//case FrameEvent.FRAME_MAXIMIZED:
				//LOG(0,'MAXIMIZED',1);
				//break;
			//case FrameEvent.FRAME_RESTORED:
				//LOG(0,'RESTORED',1);
				//break;
			
			}
			
			if (e.type==WindowEvent.WINDOW_ACTIVATED) {
				LOG(3,'Window "'+getTitle()+'"\n+++|x,y,w,h||,px,py,pw,ph| :>'+ [
					getX()
					,getY()
					,getWidth()
					,getHeight()
					+' || '+
					"px=\""+getX()/AppCfg.appScreenW*100+"\""
					+" py=\""+getY()/AppCfg.appScreenH*100+"\""
					+" pw=\""+getWidth()/AppCfg.appScreenW*100+"\""
					+" ph=\""+getHeight()/AppCfg.appScreenH*100+"\""
				]
				,0);
				
			}
			
		}
		
		private function controllResizeAndPosition(e:Event=null, moving:Boolean=false):void {
			if (stage) {
				positionAndSizeListenerInternalLock=true;
				
				var mph:int=mainScreenRef.get_mainPanel().getHeight();
				var stw:int=stage.stageWidth;
				var sth:int=stage.stageHeight;
				
				if (!moving) {
					setMaximizedBounds(new IntRectangle(0, 15, stw, sth-mph));
					if (getY()>sth-50) {setY(sth-50);}
				}
				
				//position
				//return;
				//LOG(0, 'loc='+getInsets().getMarginHeight());
				//LOG(0, 'zise='+getInsets().getInsideSize().height);
				//if (getWidth()>stw) {setWidth(stw);}
				//if (getHeight()>sth+mph) {setHeight(sth+mph);}
				//if (getY()<15) {setY(15);}
				
				if (getX()+30>stw) {setX(stw-30);}
				if (getX()<-getWidth()+30) {setX(-getWidth()+30);}
				if (getY()<14) {setY(14);}
				positionAndSizeListenerInternalLock=false;
			}
		}
		
		public override function setX(x:int):void {super.setX(x);
			if (positionAndSizeListenerInternalLock) {return;}controllResizeAndPosition(null, true);
		}
		
		public override function setY(x:int):void {super.setY(x);
			if (positionAndSizeListenerInternalLock) {return;}controllResizeAndPosition(null, true);
		}
		
		public override function setWidth(x:int):void {super.setWidth(x);
			if (positionAndSizeListenerInternalLock) {return;}controllResizeAndPosition(null, false);
		}
		
		public override function setHeight(x:Number):void {super.setHeight(x);
			if (positionAndSizeListenerInternalLock) {return;}controllResizeAndPosition(null, false);
		}
		
		
		
		public function get_canUpdateModel_scrollers():Boolean {return canUpdateModel_scrollers;}
		public function set_canUpdateModel_scrollers(a:Boolean):void {canUpdateModel_scrollers = a;}
		private var canUpdateModel_scrollers:Boolean=true;
		private var writePositionAndSizeToModelLock:Boolean;
		private var positionAndSizeListenerInternalLock:Boolean;
		private var mainScreenRef:VCMainScreen;
		//} =*^_^*= END OF private
		
	}
}

import org.aswing.JScrollBar;
import ttcc.LOG;

class ScrollBarSteward {
	/**
	 * @param	el (id:uint, a:Number):void;
	 */
	function ScrollBarSteward (id:uint, r:JScrollBar, el:Function):void {
		this.id = id;this.r = r;this.el=el;
		r.addStateListener(el_s);
	}
	
	private function el_s(e:Object):void {
		if (!r.getValueIsAdjusting()) {
			//LOG(0, 'model event:'+' s='+r.getValue()/(r.getMaximum()-r.getVisibleAmount()-r.getMinimum()), 2);
			el(id, r.getValue()/(r.getMaximum()-r.getVisibleAmount()-r.getMinimum()));
		}
	}

	public function setValue(a:Number):void {
		r.setValue((r.getMaximum()-r.getVisibleAmount()-r.getMinimum())*a);
	}

	public function get_id():uint {return id;}
	
	private var id:uint;
	private var r:JScrollBar;
	private var el:Function;
}

//{ =*^_^*= History
/* > (timestamp) [ ("+" (added) ) || ("-" (removed) ) || ("*" (modified) )] (text)
 * > 
 */
//} =*^_^*= END OF History

// template last modified:11.03.2011_[18#51#40]_[5]