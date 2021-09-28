// Project TTCC
package ttcc.c.op.s {
	
	//{ =*^_^*= import
	import flash.events.ProgressEvent;
	import flash.utils.ByteArray;
	import ttcc.c.op.AO;
	import ttcc.cfg.SP;
	import ttcc.d.dsp.DUAppEnvData;
	import ttcc.d.s.DUResource;
	import ttcc.n.a.HTTPXMLServerAdaptor;
	import ttcc.n.loaders.Im;
	//} =*^_^*= END OF import
	
	
	/**
	 * 
	 * @author Jinanoimastey Dragoncat
	 * @version 0.0.0
	 * @created 29.06.2012 10:51
	 */
	public class OLoadResources extends AO {
		
		//{ =*^_^*= CONSTRUCTOR
		
		function OLoadResources (onComplete:Function, resourcesPathsList:Array, envData:DUAppEnvData, appLoadedFrom:String) {
			super(null, NAME, onComplete);
			this.resList=resourcesPathsList;
			this.envData=envData;
			this.appLoadedFrom=appLoadedFrom;
		}
		//} =*^_^*= END OF CONSTRUCTOR
		
		protected override function start():void {
			// detect groups
			var gi:String;
			for each(var i:DUResource in resList) {
				gi=i.get_groupID();
				if (groupsList[gi]==null) {groupsList[gi]=[];}
				groupsList[gi].push(i);
			}
			data=[];
			loadNextRes();
			//var p:String=resourcesPathsList[0]+'?'+uint(Math.random()*uint.MAX_VALUE);
			//log('loading res from:'+p);
			//	new Im(resourcesPathsList[0]+'?'+p, 'aacb', null, onC, onC, onP);
		}
		
		private function loadNextRes():void {
			checkLoadedResources(false);
			if (resList.length<1) {checkLoadedResources(true);return;}
			currentRes=resList.shift();
			
			var p:String=currentRes.get_filename()+'?'+uint(Math.random()*uint.MAX_VALUE);
			if (p.indexOf('http') ==-1) {
				p=appLoadedFrom+'/'+p;
			}
			new Im(p, 'aaa', null, onC, onC, onP);
			log('loading res:'+currentRes);
		}
		
		private function checkLoadedResources(loadingComplete:Boolean):void {
			var criticalGroupIsValid:Boolean=true;
			var j:DUResource;
			var i:Array;
			
			aaa: for (var gname:String in groupsList) {
				i=groupsList[gname];
				//log('checking'+gname+' l='+i.length,2);
				j=i[0];
				
				bbb: for each(j in i) {
					//log('j.get_groupIsCritical:'+j.get_groupIsCritical());
					//log('j.get_filename:'+j.get_filename());
					if (j.get_loaded()) {//at least one
						//log('atleast one:'+j.get_filename());	
						// remove remaining from queue
						for each(var tr:DUResource in i) {resList.splice(resList.indexOf(tr),1);}
						break bbb;
					} else if (criticalGroupIsValid&&j.get_groupIsCritical()) {
						//atleast one critical group not loaded
						criticalGroupIsValid=false;
					}
				}
				if (!criticalGroupIsValid&&loadingComplete) {
					end(OPERATION_RESULT_CODE_FAILURE);
					break aaa;
				}
			}
			if (loadingComplete) {end(OPERATION_RESULT_CODE_SUCCESS);}
		}
		
		private function onP(t:Im, e:ProgressEvent):void {
			//log('ProgressEvent:'+[e, e.type, e.target]);
		}
		
		private function onC(t:Im, errorOccured:Boolean=false):void {
			currentRes.set_loaded(!errorOccured);
			log('res loaded:'+currentRes.get_loaded(),1);
			if (!errorOccured) {
				data.push(t.getChildAt(0));
			}
			loadNextRes();
			
			/*if (errorOccured) {
				end(OPERATION_RESULT_CODE_FAILURE);
				return;
			}
			data=t.getChildAt(0);
			end(OPERATION_RESULT_CODE_SUCCESS);
		*/
		}
		
		
		
		//{ =*^_^*= =*^_^*= ID
		/**
		 * data:[DisplayObject]
		 */
		public static const OPERATION_RESULT_CODE_SUCCESS:uint=0;
		//} =*^_^*= =*^_^*= END OF ID
		
		private var groupsList:Object={};
		private var resList:Array=[];
		private var currentRes:DUResource;
		private var envData:DUAppEnvData;
		private var appLoadedFrom:String;
		
		public static const NAME:String='OLoadResources';
		
	}
}


//{ =*^_^*= History
/* > (timestamp) [ ("+" (added) ) || ("-" (removed) ) || ("*" (modified) )] (text)
 * > 
 */
//} =*^_^*= END OF History

// template last modified:11.03.2011_[18#51#40]_[5]