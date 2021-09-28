// Project TTCC
package ttcc.d.dp {
	
	//{ =*^_^*= import
	import ttcc.cfg.AppCfg;
	import ttcc.d.a.DUAppComponentCfg;
	import ttcc.d.a.DUAppComponentsCfg;
	import ttcc.d.a.DULayoutComponentInfo;
	import ttcc.d.a.DULayoutInfo;
	import ttcc.d.s.DUResource;
	import ttcc.LOG;
	//} =*^_^*= END OF import
	
	
	/**
	 * 
	 * @author Jinanoimatey Dragoncat
	 * @version 0.0.0
	 * @created 18.06.2012 22:14
	 */
	public class DPAppComponentsCfg {
		
		//{ =*^_^*= CONSTRUCTOR
		function DPAppComponentsCfg (x:XML) {
			construct(x);
		}
		public function construct(x:XML):void {
			processXML(x);
		}
		public function destruct():void {
		}
		//} =*^_^*= END OF CONSTRUCTOR
		
		private function processXML(x:XML):void {
			var defaultComponentStyleName:String=x.styles.mod_def_styl.@name;
			
			//{convert styles tree from xml
			var stylesList:Object;
			var i:int, j:int;
			var s:String;
			
			var st:Object;
			var st0:XML;
			
			stylesList={};
			for(i=0;x.styles.styl[i];i++) {
				st0=x.styles.styl[i];
				s=st0.@name;
				st={};
				for(j=0;st0.p[j];j++) {
					st[st0.p[j].@name]=st0.p[j].@value;
				}
				if (st0.@base){st["base"]=st0.@base;}
				stylesList[s]=st;
			}
			for(s in stylesList) {inheritStyles(stylesList[s], stylesList);}
			var currentStyle:Object=stylesList[defaultComponentStyleName];
			//}
			
			//{ modules
			var mod:Array=[];
			var modIndex:Array=[];
			var o:XML;
			var oid:String;
			for(i=0; x.mod[i]; i++){			
				s=x.mod[i].@ID;
				o=x.mod[i];
				oid=o.@ID;
				mod[oid]={styl : ( (o.@styl&&stylesList[o.@styl])?stylesList[o.@styl]:stylesList[defaultComponentStyleName])};//if style is null or not in list, set default style
				modIndex[i]=oid;
			}
			//}
			
			//{ resources
			var resourcesPathsList:Array=[];
			for(i=0; x.resources.res[i]; i++){
				resourcesPathsList.push(new DUResource(
					x.resources.res[i].@filename
					,x.resources.res[i].@group_id
					,Boolean(parseInt(x.resources.res[i].@group_critical))
				));
			}
			//}
			
			//{componentsList
			var componentsList:Array=[];
			var l:uint = modIndex.length;
			var mnr:Object;
			var mr:XML;
			var mdu:DUAppComponentCfg;
			var ro:Object;
			var styleNameO:String;
			for(i=0; x.mod[i]; i++){
				mr=x.mod[i];
				mnr=mod[modIndex[i]];
				styleNameO=((mr.@styl!=null&&stylesList[mr.@styl])?mr.@styl:defaultComponentStyleName);
				mdu=new DUAppComponentCfg;
				// create empty object, copy properties from style
				ro=copyObject(stylesList[styleNameO]);
				// then copy properties from component info
				mdu.construct(modIndex[i], convertXMLToSimpleObject(mr, ro));
				componentsList.push(mdu);
			}
			//LOG(0, componentsList.join('\n'), 2);
			
			//{ =*^_^*= =*^_^*= RUNNING WITH RELEASE SERVER
			if (AppCfg.developmentWithReleaseServer) {
				componentsList=[];
				resourcesPathsList=[];
				
				resourcesPathsList.push(new DUResource("resources0.swf", 'one', false));
				
				/// ======= components list
				// ======= COMPONENT CFG ======
				mdu=new DUAppComponentCfg;
				mdu.construct("taskbar", 
					{ID:"taskbar", wx:0, wy:0, ww:450, wh:33, window_is_visible:true}
				);
				componentsList.push(mdu);
				
				// ======= COMPONENT CFG ======
				mdu=new DUAppComponentCfg;
				mdu.construct("whiteboard", 
					{ID:"whiteboard", test_mode:false, wx:305, wy:252, ww:500, wh:500, window_is_visible:true, mp_button_is_visible:true}
				);
				componentsList.push(mdu);
				
				// ======= COMPONENT CFG ======
				mdu=new DUAppComponentCfg;
				mdu.construct("course_loader", 
					{ID:"course_loader", wx:330, wy:248, ww:416, wh:449, window_is_visible:false, mp_button_is_visible:true}
				);
				componentsList.push(mdu);
				
				// ======= COMPONENT CFG ======
				mdu=new DUAppComponentCfg;
				mdu.construct("text_chat", 
					{ID:"text_chat", wx:252, wy:150, ww:110, wh:111, window_is_visible:false, mp_button_is_visible:true}
				);
				componentsList.push(mdu);
				
				/// ======= components list
				
				d = new DUAppComponentsCfg;
				d.construct(componentsList, resourcesPathsList, mainMenu, layoutsList);
				return;
			}
			//} =*^_^*= =*^_^*= END OF RUNNING WITH RELEASE SERVER
			//}
			
			//{layoutsList
			var layoutsList:Array=[];
			var layoutComponentsList:Array=[];
			//layoutsList=[{id:"one", displayName:"dn one"}, {id:"two", displayName:"dn two"}];
			for(i=0; x.mode[i]!=null; i++) {
				layoutComponentsList=[];
				var dui:DULayoutComponentInfo=null;
				for(var iclc:int=0; x.mode[i].mod[iclc]!=null; iclc++){
					
					dui=new DULayoutComponentInfo({
						id:String(x.mode[i].mod[iclc].@ID)
						,wx:x.mode[i].mod[iclc].@wx
						,wy:x.mode[i].mod[iclc].@wy
						,ww:x.mode[i].mod[iclc].@ww
						,wh:x.mode[i].mod[iclc].@wh
						
						,px:x.mode[i].mod[iclc].@px
						,py:x.mode[i].mod[iclc].@py
						,pw:x.mode[i].mod[iclc].@pw
						,ph:x.mode[i].mod[iclc].@ph
						,window_is_visible:x.mode[i].mod[iclc].@window_is_visible
					});
					//LOG(3,'dui:\n'+dui.toString(), 2);
					layoutComponentsList.push(dui);
				}
				layoutsList.push(new DULayoutInfo(String(x.mode[i].@ID), String(x.mode[i].@label), layoutComponentsList));
			}
			//LOG(0,'DULayoutInfo id:'+DULayoutComponentInfo(DULayoutInfo(layoutsList[0]).get_componentsList()[1]).get_id());
			//}END OF layoutsList
			
			//{main menu
			var mainMenu:Object={items:[]};
			var mainMenuItem:Object;
			for(i=0; x.main_menu.menuitem[i]; i++){
				mainMenuItem={
					id:String(x.main_menu.menuitem[i].@id)
					,type:String(x.main_menu.menuitem[i].@type)
				};
				mainMenu.items[x.main_menu.menuitem[i].@position]=mainMenuItem;
				//LOG(0, 'menu>>>>>>>>> item>'+traceObject(mainMenuItem));
				
				//menu>>>>>>>>> item>{type:customMenu, id:windowsLayouts}
				//menu>>>>>>>>> item>{type:command, id:securitySettings}
				//menu>>>>>>>>> item>{type:command, id:toggleFullscreen}
			}
			//}
			
			var buffer_time_in:Number = x.modeSettings.@buffer_time_in;
			var buffer_time_in_max:Number = x.modeSettings.@buffer_time_in_max;
			var buffer_time_out:Number = x.modeSettings.@buffer_time_out;
			var buffer_time_out_max:Number = x.modeSettings.@buffer_time_out_max;
			var video_resolution_w:Number = x.modeSettings.@video_resolution_w;
			var video_resolution_h:Number = x.modeSettings.@video_resolution_h;
			
			// TODO:  remove makeshift
			var freeze_timeout:Number = x.modeSettings.@freeze_timeout;
			if (!x.modeSettings.hasOwnProperty('@freeze_timeout')) {
				freeze_timeout=3000;
				LOG(7, 'freeze_timeout'+' is not defined in config, using default value:'+freeze_timeout,1);
			}
			// TODO:  remove makeshift
			var disconnect_timeout:Number = x.modeSettings.@disconnect_timeout;
			if (!x.modeSettings.hasOwnProperty('@disconnect_timeout')) {
				disconnect_timeout=5000;
				LOG(7, 'disconnect_timeout'+' is not defined in config, using default value:'+disconnect_timeout,1);
			}
			
			
			//<modeSettings buffer_time_in="0"  buffer_time_in_max="1"  buffer_time_out="0"  buffer_time_out_max="1" freeze_timeout="5000" disconnect_timeout/>
			
			
			
			d = new DUAppComponentsCfg;
			d.construct(
				componentsList
				, resourcesPathsList
				, mainMenu
				, layoutsList
				, buffer_time_in
				, buffer_time_in_max
				, buffer_time_out
				, buffer_time_out_max
				, video_resolution_w
				, video_resolution_h
				, freeze_timeout
				, disconnect_timeout
			);
			
		}
		
		private function inheritStyles(st:Object, styles:Object):void{
			var b:String=st["base"];
			if(!b){return;}
			var stb:Object=styles[b];
			inheritStyles(stb,styles);
			for(var s:String in stb) {
				if(!st[s]) {st[s]=stb[s];}
			}
		}
		
		private function copyObject(from:Object):Object {
			var o:Object={};
			//if (from) {
				for each(var i:String in from) {o[i]=from[i];}
			//}
			return o;
		}
		private function convertXMLToSimpleObject(x:XML, o:Object=null):Object {
			if (!o) {o={};}
			for each(var k:XML in x.attributes()) {
				o[String(k.name())]=k.valueOf();
			}
			return o;
		}
		
		
		public function get_data():DUAppComponentsCfg {return d;}
		private var d:DUAppComponentsCfg;
		
	}
}

//{ =*^_^*= History
/* > (timestamp) [ ("+" (added) ) || ("-" (removed) ) || ("*" (modified) )] (text)
 * > 
 */
//} =*^_^*= END OF History

// template last modified:11.03.2011_[18#51#40]_[5]