// Project TTCC
package ttcc.c.ma.ac {
	
	//{ =*^_^*= import
	import org.jinanoimateydragoncat.utils.flow.agents.AbstractAgent;
	import ttcc.c.ma.AM;
	import ttcc.cfg.AppCfg;
	import ttcc.d.a.DUAppComponentCfg;
	import ttcc.d.a.DULayoutComponentInfo;
	import ttcc.LOG;
	//} =*^_^*= END OF import
	
	
	/**
	 * 
	 * @author Jinanoimatey Dragoncat
	 * @version 0.0.0
	 * @created 19.06.2012 0:20
	 */
	public class MAPPComponent extends AM {
		
		//{ =*^_^*= CONSTRUCTOR
		/**
		 * @param	bootPriority 0-highest, 100000 - initial (first)
		 */
		function MAPPComponent (name:String, id:String, bootPriority:int=100000, dependenciesList:Array=null) {
			super(name);
			cacheActionsNames(name);
			registerComponent(name, id, bootPriority, dependenciesList);
		}
		//} =*^_^*= END OF CONSTRUCTOR
		
		//{ =*^_^*= =*^_^*= service
		private static function registerComponent(agentName:String, componentID:String, bootPriority:int=100000, dependenciesList:Array=null):void {
			if (getComponentInfoByID(componentID)) {return;}
				s_list_componentInfo.push(new MAPPComponentInfo(
					agentName
					,componentID
					,bootPriority
					,dependenciesList
			));
		}
		public static function getComponentInfoByID(componentID:String):MAPPComponentInfo {
			for each(var i:MAPPComponentInfo in s_list_componentInfo) {
				if (i.getID()==componentID) {return i;}
			}
			return null;
		}
		/**
		 * MAPPComponentInfo
		 */
		private static const s_list_componentInfo:Array=[];
		
		//{ =*^_^*= service actions id
		/**
		 * fill component cfg with default values if needed so
		 * data:DUAppComponentCfg
		 */
		public static const S_ID_A_CHECK_CFG:String='>ID_A_CHECK_CFG';
		private var ID_A_CHECK_CFG:String;
		/**
		 * store and apply cfg
		 * data:DUAppComponentCfg
		 */
		public static const S_ID_A_APPLY_CFG:String='>ID_A_APPLY_CFG';
		private var ID_A_APPLY_CFG:String;
		/**
		 * data:null
		 */
		public static const S_ID_A_RUN_COMPONENT:String='>ID_A_RUN_COMPONENT';
		private var ID_A_RUN_COMPONENT:String;
		/**
		 * data:DULayoutComponentInfo
		 */
		public static const S_ID_A_APPLY_WINDOW_SETTINGS:String='>S_ID_A_APPLY_WINDOW_SETTINGS';
		private var ID_A_APPLY_WINDOW_SETTINGS:String;
		//} =*^_^*= END OF service actions id
		
		//{ =*^_^*= service events
		public static const S_ID_E_COMPONENT_IS_READY:String='>ID_E_COMPONENT_IS_READY';
		public static const S_ID_E_OPERATION_ERROR:String='>ID_E_OPERATION_ERROR';
		public static const S_ID_E_FAILED_TO_RUN_COMPONENT:String='>ID_E_FAILED_TO_RUN_COMPONENT';
		//} =*^_^*= END OF service events
		
		private function cacheActionsNames(name:String):void {
			ID_A_APPLY_CFG=name+S_ID_A_APPLY_CFG;
			ID_A_CHECK_CFG=name+S_ID_A_CHECK_CFG;
			ID_A_RUN_COMPONENT=name+S_ID_A_RUN_COMPONENT;
			ID_A_APPLY_WINDOW_SETTINGS=name+S_ID_A_APPLY_WINDOW_SETTINGS;
		}
		
		/**
		 * @param	action S_ID
		 * @return actionID+NAME
		 */
		protected final function getServiceActionName(action_SID:String):String {
			return get_name()+action_SID;
		}
		//} =*^_^*= =*^_^*= END OF service
		
		//{ =*^_^*= =*^_^*= component	private
		protected function applyWindowSettings(a:DULayoutComponentInfo):void {
			//log(0,'applyWindowSettings>'+[a.get_id(),a.get_wx(),a.get_wy(),a.get_ww(),a.get_wh(),a.get_windowIsVisible()],0);
			if (cfg.getBoolean(ID_AC_CFG_P_WINDOW_PRESENT)) {
				// TODO: AppCfg.appScreenW
				window__setInitialVisibility(a.get_windowIsVisible());
				/*var wx:uint=AppCfg.appScreenW*a.get_px();
				var ww:uint=AppCfg.appScreenW*a.get_pw();
				var wy:uint=AppCfg.appScreenH*a.get_py();
				var wh:uint=AppCfg.appScreenH*a.get_ph();
				*/
				/*LOG(3,'x,y,w,h>'+[a.get_px()
					,AppCfg.appScreenW/100*a.get_pw()
					,AppCfg.appScreenH/100*a.get_py()
					,AppCfg.appScreenH/100*a.get_ph()]
				);*/
				
				
				window__setXYWH(
					AppCfg.appScreenW/100*a.get_px()
					,AppCfg.appScreenH/100*a.get_py()
					,AppCfg.appScreenW/100*a.get_pw()
					,AppCfg.appScreenH/100*a.get_ph()
				);
					/*a.get_wx()
					,a.get_wy()
					,a.get_ww()
					,a.get_wh()
				);*/
			}
		}
		protected function runComponent():void {
			prepareBeforeStartup();
			window__prepare();
		}
		protected function checkCFG(cfg:DUAppComponentCfg):void {
			this.cfg=cfg;
		}
		protected function applyCFG(cfg:DUAppComponentCfg):void {
			this.cfg=cfg;
		}
		
		public function get_cfg():DUAppComponentCfg {return cfg;}
		private var cfg:DUAppComponentCfg;
		//} =*^_^*= =*^_^*= END OF component private
		
		public override function listen(eventType:String, details:Object):void {
			super.listen(eventType, details);
			switch (eventType) {
			
			case ID_A_CHECK_CFG:
				checkCFG(details);
				break;
				
			case ID_A_APPLY_CFG:
				applyCFG(details);
				break;
				
			case ID_A_RUN_COMPONENT:
				runComponent();
				break;
				
			case ID_A_APPLY_WINDOW_SETTINGS:
				applyWindowSettings(details);
				break;
				
			}
		}
		
		public override function autoSubscribeEvents():Array {
			return [
				ID_A_CHECK_CFG
				,ID_A_APPLY_CFG
				,ID_A_RUN_COMPONENT
				,ID_A_APPLY_WINDOW_SETTINGS
			]
		}
		
		//{ =*^_^*= =*^_^*= override
		protected function prepareBeforeStartup():void {
			// override and place your code here
		}
		//} =*^_^*= =*^_^*= END OF override
		
		//{ =*^_^*= =*^_^*= component configuration details: GUI
		/**
		 * component has main panel button
		 */
		public static const ID_AC_CFG_P_MPBUTTON_PRESENT:String='mp_button_present';
		public static const ID_AC_CFG_P_WINDOW_PRESENT:String='window_present';
		
		//{ =*^_^*= window
		public static const ID_AC_CFG_P_WINDOW_IS_VISIBLE:String='window_is_visible';
		public static const ID_AC_CFG_P_W_X:String='wx';
		public static const ID_AC_CFG_P_W_Y:String='wy';
		public static const ID_AC_CFG_P_W_W:String='ww';
		public static const ID_AC_CFG_P_W_H:String='wh';		
		//} =*^_^*= END OF window
		
		//{ =*^_^*= main panel
		/**
		 * main panel button is visible
		 */
		public static const ID_AC_CFG_P_MPBUTTON_IS_VISIBLE:String='mp_button_is_visible';
		//} =*^_^*= END OF main panel
		
		//} =*^_^*= =*^_^*= END OF component configuration details: GUI
		
		//{ =*^_^*= =*^_^*= actions: window
		private function window__prepare():void {
			//configure window if present
			if (cfg.getBoolean(ID_AC_CFG_P_WINDOW_PRESENT)) {
				window__setXYWH(
					cfg.getNumber(ID_AC_CFG_P_W_X)
					,cfg.getNumber(ID_AC_CFG_P_W_Y)
					,cfg.getNumber(ID_AC_CFG_P_W_W)
					,cfg.getNumber(ID_AC_CFG_P_W_H)
				);
				window__setInitialVisibility(cfg.getBoolean(ID_AC_CFG_P_WINDOW_IS_VISIBLE));
			}
			//display main panel button if present & visible
			//log(0, 'display button for['+get_name()+'] :'+cfg.getBoolean(ID_AC_CFG_P_MPBUTTON_PRESENT)+'&&'+cfg.getBoolean(ID_AC_CFG_P_MPBUTTON_IS_VISIBLE),2);
			if (cfg.getBoolean(ID_AC_CFG_P_MPBUTTON_PRESENT)&&cfg.getBoolean(ID_AC_CFG_P_MPBUTTON_IS_VISIBLE)) {
				displayMPButton();
			}
		}
		
		/**
		 * display component main panel button
		 */
		protected function displayMPButton():void {
			// override and place your code here
		}
		protected function window__setXYWH(x:Number, y:Number, w:Number, h:Number):void {
			// override and place your code here
		}
		protected function window__setInitialVisibility(a:Boolean):void {
			// override and place your code here
		}
		//} =*^_^*= =*^_^*= END OF actions: window
		
		//{ =*^_^*= =*^_^*= logging
		/**
		* @param	c channel id(see LOGGER)
			0-"R"
			1-"DT"
			2-"DS"
			3-"V"
			4-"OP"
			5-"NET"
			6-"AG"
			7-"AF"
		* @param	m msg
		* @param	l level
			0-INFO
			1-WARNING
			2-ERROR
		*/
		protected override function log(c:uint, m:String, l:uint=0):void {// flash develop code autocomplete bug
			LOG(c, m, l);
		}
		//} =*^_^*= =*^_^*= END OF logging
		
		
	}
}

//{ =*^_^*= History
/* > (timestamp) [ ("+" (added) ) || ("-" (removed) ) || ("*" (modified) )] (text)
 * > 
 */
//} =*^_^*= END OF History

// template last modified:11.03.2011_[18#51#40]_[5]