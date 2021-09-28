// Project TTCC
package ttcc.c.ma.ac {
	
	//{ =*^_^*= import
	import ttcc.c.ma.ac.MACChat;
	import ttcc.Application;
	import ttcc.c.ae.AEApp;
	import ttcc.c.ma.ac.MACMP;
	import ttcc.c.ma.AM;
	import ttcc.c.op.ac.OPrepareAppComponentsCfgData;
	import ttcc.cfg.AppCfg;
	import ttcc.cfg.AppComponentsList;
	import ttcc.d.a.ARO;
	import ttcc.d.a.DUAppComponentCfg;
	//} =*^_^*= END OF import
	
	
	/**
	 * 
	 * @author Jinanoimatey Dragoncat
	 * @version 0.0.0
	 * @created 18.06.2012 23:59
	 */
	public class MAPPComponents extends AM {
		
		//{ =*^_^*= CONSTRUCTOR
		
		function MAPPComponents (app:Application, appComponentsList:AppComponentsList) {
			super(NAME);
			a=app;
			acl=appComponentsList;
		}
		//} =*^_^*= END OF CONSTRUCTOR
		
		
		public override function listen(eventType:String, details:Object):void {
			var r:ARO;
			switch (eventType) {
			
			case ID_A_PREPARE_COMPONENTS:
				//store
				var op:OPrepareAppComponentsCfgData=new OPrepareAppComponentsCfgData(el_op0, a.get_ds().get_duAppComponentsCfg());
				op.startOperation();
			break;
			
			
			case ID_E_CFG_PREPARED:
				createComponentsList();
				break;
				
				
			case ID_E_C_LIST_PREPARED:
				// boot sequentially
				log(7, 'starting component boot sequence, components list:'+componentsToBoot, 0);
				bootNextComponent();
				break;
			
			case ID_E_LAST_COMPONENT_STARTED_UP:
				e.listen(ID_E_COMPONENTS_ARE_READY, null);
				break;
				
			default:
				checkEnvMessageForComponentEvent(eventType, details)
				break;
				
			}
		}
		
		private function el_op0(o:OPrepareAppComponentsCfgData):void {
			if (o.get_resultCode()==OPrepareAppComponentsCfgData.OPERATION_RESULT_CODE_SUCCESS) {
				listen(ID_E_CFG_PREPARED, null);
				return;
			}
			e.listen(ID_E_FAILED_TO_PREPARE_COMPONENT, null);
		}
		
		private function createComponentsList():void {
			var originalDUList:Array=a.get_ds().get_duAppComponentsCfg().get_componentList();
			var enabledComponentsList:Array=acl.getComponentsIDsList();
			
			/**
			 * present in cfg
			 */
			var componentsIDsList:Array=[];
			// create list of components whose CFGs are present in components cfg
			var cid:String;
			for each(var i:DUAppComponentCfg in originalDUList) {
				cid=i.get_id();
				if (enabledComponentsList.indexOf(cid)!=-1) {
					componentsIDsList.push(cid);
					log(7, 'component present: '+cid, 0);
				}
			}
			// check whether components are implemented
			var activeComponentsList:Array=[];
			var activeComponentsIDList:Array=[];
			var notImplementedComponentsIDs:Array=[];
			var ci:MAPPComponentInfo;
			var ccc:Class;
			for each(var j:String in componentsIDsList) {
				//register component class
				ccc=acl.getComponentsClassReferenceByID(j);
				if (ccc) {//component Class exists, register it in the system by creating instance, also place instance to env
					log(7, 'component implemented: '+j, 0);
					e.placeAgent(new ccc(a));
					ci=MAPPComponent.getComponentInfoByID(j);
					activeComponentsList.push(ci);
					activeComponentsIDList.push(ci.getID());
				} else {notImplementedComponentsIDs.push(j);}
			}
			if (notImplementedComponentsIDs.length>0) {
				log(7, 'FATAL ERROR:components with following IDs are not implemented in current application build.IDs:\n'+notImplementedComponentsIDs.join('\n'), 2);
				cfgIsNotAcceptable();
				return;
			}
			// check dependencies
			var k:MAPPComponentInfo;
			var m:String;
			var notFoundDependencies:Array=[];//{targetID:String, missedForID:String}
			for each(k in activeComponentsList) {
				if (k.getDependenciesList().length>0) {
					for each(m in k.getDependenciesList()) {
						if (activeComponentsIDList.indexOf(m)==-1) {// component that other component is relying on, is missing in cfg
							notFoundDependencies.push("ID:"+k.getID()+"is missing for ID:"+m);// add to list
						}
					}
				}
			}
			if (notFoundDependencies.length>0) {
				log(7, 'FATAL ERROR:some components that other components are relying on, are missing in cfg. details:\n'+			notFoundDependencies.join('\n'), 2);
				cfgIsNotAcceptable();
				return;
			}
			
			// create groups accordingly to dependencies specified
			/**
			 * [[{r:component, p:int}], ...]
			 */
			var groups:Array=[];
			var currentGroup:Array;
			const FG:String='first group';
			var lastGroupIDs:Array=[FG];
			// firstly search completely independent components, store them to the list
			
			// create list of components which are dependent, repeat until no parent components left
			var l:TTCCCGI ;
			//log(0, 'activeComponentsList.length>'+activeComponentsList.length);
			var rrr:int=0;
			var toRemove:Array;
			while (activeComponentsList.length>0&&rrr<22) {
				rrr+=1;
				//log(0, 'lastGroupIDs>'+lastGroupIDs);
				currentGroup=[];
				toRemove=[];
				//log(0, '>>>>>>>>>>for in :['+activeComponentsList+']',0);
				for each(k in activeComponentsList) {
					//log(0, 'for each in :['+lastGroupIDs+']',2);
					a112: for each(m in lastGroupIDs) {
						//log(0, 'm==FG:'+(m==FG)+' /k.getDependenciesList():'+k.getDependenciesList()+'.indexOf('+m+')',1)
						if ((m==FG && k.getDependenciesList().length<1)
							|| k.getDependenciesList().indexOf(m)!=-1) {//root component or parent found
							//log(0, 'added>'+k.getID());
							currentGroup.push(new TTCCCGI(k));
							toRemove.push(k);
						}
					}
				}
				//remove from list - don't (!) do it in a112
				if (toRemove.length>0) {
					for each(k in toRemove) {
						activeComponentsList.splice(activeComponentsList.indexOf(k), 1);
					}
				}
				//log(0, 'after removed>'+activeComponentsList);
				
				groups.push(currentGroup);
				//log(0, 'new group>'+currentGroup);
				lastGroupIDs=[];//reset parents
				for each(l in currentGroup) {lastGroupIDs.push(l.get_cr().getID());}//fill parents
				//log(0, 'new lastGroupIDs>'+lastGroupIDs);
			}
			
			// order components inside groups by bootPrioity and fill boot queue
			var n:Array;
			for each(n in groups) {
				n.sortOn('bootPriority', Array.NUMERIC);
				bootQueue=bootQueue.concat(n);
			}
			componentsToBoot=bootQueue.slice();
			listen(ID_E_C_LIST_PREPARED, null);
		}
		
		private function bootNextComponent():void {
			//if (!currentComponent) {
				if (bootQueue.length>0) {
					currentComponent=bootQueue.shift();
				} else {
					listen(ID_E_LAST_COMPONENT_STARTED_UP, null);
					return;
				}
			//}
			var cfg:DUAppComponentCfg=a.get_ds().get_duAppComponentsCfg().getComponentCfgById(currentComponent.get_cr().getID());
			
			
			var agentName:String=currentComponent.get_cr().getAgentName();
			//subscribe first
			e.subscribe(this, agentName+MAPPComponent.S_ID_E_COMPONENT_IS_READY);
			bootFaultEventNamesList.push(agentName+MAPPComponent.S_ID_E_COMPONENT_IS_READY);
			e.subscribe(this, agentName+MAPPComponent.S_ID_E_OPERATION_ERROR);
			bootFaultEventNamesList.push(agentName+MAPPComponent.S_ID_E_OPERATION_ERROR);
			e.subscribe(this, agentName+MAPPComponent.S_ID_E_FAILED_TO_RUN_COMPONENT);
			bootFaultEventNamesList.push(agentName+MAPPComponent.S_ID_E_FAILED_TO_RUN_COMPONENT);
			
			//perform actions
			e.listen(agentName+MAPPComponent.S_ID_A_CHECK_CFG, cfg);
			e.listen(agentName+MAPPComponent.S_ID_A_APPLY_CFG, cfg);
			e.listen(agentName+MAPPComponent.S_ID_A_RUN_COMPONENT, null);
			
		}
		
		private function checkEnvMessageForComponentEvent(eventType:String, details:Object):void {
			// check for errors, end if found
			if (bootFaultEventNamesList.indexOf(eventType)!=-1) {//error occured while startingup come component
				// determine which
				var errorMessages:Array=[];
				for each(var i:TTCCCGI in componentsToBoot) {
					errorMessages[0]=i.get_cr().getAgentName()+MAPPComponent.S_ID_E_FAILED_TO_RUN_COMPONENT;
					errorMessages[1]=i.get_cr().getAgentName()+MAPPComponent.S_ID_E_OPERATION_ERROR;
					if (errorMessages.indexOf(eventType)!=-1) {//found
						componentReportedErrorWhileTryingToStartup(i);
						return;
					}
				}
			}
			// check for current, boot next
			if (eventType==currentComponent.get_cr().getAgentName()+MAPPComponent.S_ID_E_COMPONENT_IS_READY) {
				bootNextComponent();
			}
		}
		
		private function componentReportedErrorWhileTryingToStartup(c:TTCCCGI):void {
			// threat component startup or operation error as critical, stop process, block main screen with "reboot app" or "reboot component" message 
			e.listen(ID_E_FAILED_TO_PREPARE_COMPONENT, c.get_cr().getID());
		}
		
		private function cfgIsNotAcceptable():void {
			e.listen(ID_E_FAILED_TO_PREPARE_CFG, null);
		}
		
		/**
		 * TTCCCGI
		 */
		private var componentsToBoot:Array=[];
		/**
		 * TTCCCGI
		 */
		private var bootQueue:Array=[];
		private var currentComponent:TTCCCGI;
		/**
		 * [String]
		 */
		private var bootFaultEventNamesList:Array=[]
		//{ =*^_^*= private 
		private function get e():AEApp {return get_envRef();}
		private var a:Application;
		private var acl:AppComponentsList;
		//} =*^_^*= END OF private
		
		
		
		//{ =*^_^*= actions 
		/**
		 * data:
		 */
		public static const ID_A_PREPARE_COMPONENTS:String=NAME+'>ID_A_PREPARE_COMPONENTS';
		//} =*^_^*= END OF actions 
		
		//{ =*^_^*= events
		private static const ID_E_CFG_PREPARED:String='>ID_E_CFG_PREPARED';
		private static const ID_E_C_LIST_PREPARED:String='>ID_E_C_LIST_PREPARED';
		private static const ID_E_LAST_COMPONENT_STARTED_UP:String='>ID_E_LAST_COMPONENT_STARTED_UP';
		
		public static const ID_E_FAILED_TO_PREPARE_CFG:String='>ID_E_FAILED_TO_PREPARE_CFG';
		/**
		 * data:{componentID:String}
		 */
		public static const ID_E_FAILED_TO_PREPARE_COMPONENT:String='>ID_E_FAILED_TO_PREPARE_COMPONENT';
		/**
		 * data:
		 */
		public static const ID_E_COMPONENTS_ARE_READY:String='>ID_E_COMPONENTS_ARE_READY';
		//} =*^_^*= END OF events
		
		public static const NAME:String = 'MAPPComponents';
		
		public override function autoSubscribeEvents():Array {
			return [
				ID_A_PREPARE_COMPONENTS
			];
		}
		
	}
}


//{ =*^_^*= import 
import ttcc.c.ma.ac.MAPPComponentInfo;
//} =*^_^*= END OF import

/**
 * component group item
 */
class TTCCCGI {
	function TTCCCGI (cr:MAPPComponentInfo):void {
		this.cr = cr;
		this.bootPriority = cr.getBootPriority();
	}
	public function get_cr():MAPPComponentInfo {return cr;}
	
	private var cr:MAPPComponentInfo;
	public var bootPriority:int;
	
	public function toString():String {
		return cr.getID();
	}
}

//{ =*^_^*= History
/* > (timestamp) [ ("+" (added) ) || ("-" (removed) ) || ("*" (modified) )] (text)
 * > 
 */
//} =*^_^*= END OF History

// template last modified:11.03.2011_[18#51#40]_[5]