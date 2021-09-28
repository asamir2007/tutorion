// Project TTCC
package ttcc.c.vcm {
	
	//{ =*^_^*= import
	import flash.display.Sprite;
	import ttcc.APP;
	import ttcc.Application;
	import ttcc.cfg.AppCfg;
	import ttcc.cfg.SP;
	import ttcc.LOG;
	import ttcc.media.Text;
	import ttcc.n.loaders.Im;
	import ttcc.v.cl.VCCourseLoader;
	import ttcc.v.cl.d.DUTreeNode;
	//} =*^_^*= END OF import
	
	/**
	 * display manager - controlls interface
	 * @author Jinanoimatey Dragoncat
	 * @version 0.0.0
	 * @created 21.06.2012 3:10
	 */
	public class VCMCourseLoader extends AVCM {
		
		//{ =*^_^*= CONSTRUCTOR
		
		function VCMCourseLoader (a:Application) {
			this.a=a;
			super(NAME);
		}
		//} =*^_^*= END OF CONSTRUCTOR
		
		
		public override function listen(eventType:String, details:Object):void {
			
			switch (eventType) {
			
			case ID_A_REGISTER_SINGLETON_VC:
				vc=details;
				configureVC();
				displayLoadingScreen();
				loadData();
				break;
				
			case ID_A_SET_VISIBILITY:
				vc.set_visible((details<2)?Boolean(details):!vc.get_visible());
				// clear vc, display "loading.." text
				if (vc.get_visible()) {
					displayLoadingScreen();
					loadData();
				}
				break;
			case ID_A_SET_WINDOW_XYWH:
				vc.setXY(details[0],details[1]);
				vc.setWH(details[2],details[3]);
				break;
				
			}
		}
		
		private function configureVC():void {
			vc.construct(el_tree);
			displayLoadingScreen();
			/*var id:uint=1;
			var data:DUTreeNode=new DUTreeNode(id++, 'загрузка данных с сервера ...');
			var folder:DUTreeNode;
			
			data.addContent(new DUTreeNode(id++, ''));
			data.addContent(new DUTreeNode(id++, 'file two'));
			
			folder=data.addContent(new DUTreeNode(id++, 'folder two'));
			folder.addContent(new DUTreeNode(id++, 'file one'));
			folder.addContent(new DUTreeNode(id++, 'file two'));
			folder.addContent(new DUTreeNode(id++, 'file thee'));
			folder.addContent(new DUTreeNode(id++, 'file four'));
			
			folder=data.addContent(new DUTreeNode(id++, 'folder three'));
			folder.addContent(new DUTreeNode(id++, 'file one'));
			folder.addContent(new DUTreeNode(id++, 'file with very very very very very very very very long name'));
			folder.addContent(new DUTreeNode(id++, 'file thee'));
			folder.addContent(new DUTreeNode(id++, 'file four'));
			folder=folder.addContent(new DUTreeNode(id++, 'folder 444444444444'));
			
			folder.addContent(new DUTreeNode(id++, 'file with very very very very very very very very long name'));
			folder.addContent(new DUTreeNode(id++, 'file thee 333'));
			folder.addContent(new DUTreeNode(id++, 'file four 4'));
			vc.setData(data);
			*/
			
		}
		
		private function loadData():void {
			return;
			a.get_fileServerAdaptor().request(
				SP.ID_METHOD_FILE_SERVER_COURSE_LOADER_GET_TREE
				,function (cmd:String, r:String):void {
					//LOG(0, "get_tree req responce:"+r);
					processTreeData(r);
				}
				,{node_typ:"course"}
			);
		}
		
		private function processTreeData(a:String):void {
			var folder:DUTreeNode=new DUTreeNode(uint.MAX_VALUE, '');
			
			var l:Array;
			try {
				l=JSON.parse(a);
			} catch (e:Object) {
				LOG(2,NAME+'>processTreeData()>tree data is invalid, expected JSON', 2);
				return;
			}
			loadedList=l;
			var processedList:Array=[];
			// preprocess
			function placeNodes(parent:DUTreeNode, data:Object, processedList:Array):void {
				var fdname:String=data.name;
				//var fdname:String=(data.typ=="folder")?"[":""+data.name+(((data.typ=="folder")?"]":""));
				if (data.typ=="folder") {
					fdname="["+fdname+"]";
				}
				
				var target:DUTreeNode=parent.addContent(new DUTreeNode(data.id, fdname));
				processedList.push(data);
				
				for each(var i:Object in l) {
					//if ((i!=null)&&(i.typ=="folder")&&(i.id!=0)&&(processedList.indexOf(i.id)==-1)) {
					if ((i!=null)&&(i.id!=0)&&(i.parent_id==data.id)&&(processedList.indexOf(i.id)==-1)) {
						if ((i.typ!="folder")) {
							target.addContent(new DUTreeNode(i.id, ((i.typ=="folder")?"[":"")+i.name+((i.typ=="folder")?"]":"")));
							processedList.push(i);
						} else {
							placeNodes(target, i, processedList);
						}
					}
				}
			}
			
			for each(var i:Object in l) {
				if ((i.typ=="folder")&& firstLoad) {
					firstLoad=false;
					get_envRef().listen(ID_E_FIRST_FREE_FOLDER_ID, i.id);
				}
				
				if ((i.typ=="folder")&&(i.parent_id==0)) {
					placeNodes(folder, i, processedList);
				}/* else {
					folder.addContent(new DUTreeNode(i.id, ((i.typ=="folder")?"[":""+i.name+((i.typ=="folder")?"]":""))));
				}*/
			}
			/*{"id":"136","parent_id":"0","name":"private_folder","typ":"folder",
				"fname":null//file name
				,"dir":null// file directory
			}*/
			vc.setData(folder);
		}
		
		private function displayLoadingScreen():void {
			var id:uint=1;
			var data:DUTreeNode=new DUTreeNode(id++, "загрузка данных с сервера");
			var folder:DUTreeNode;
			
			data.addContent(new DUTreeNode(id++, ""));
			vc.setData(data);
		}
		
		private function el_tree(target:VCCourseLoader, eventType:String, details:Object=null):void {
			var file:Object=getFileById(details);
			if (!file) {LOG(4, "!file",0);return;}
			LOG(4, NAME+">FILE SELECTED, id="+file.id+' fname:'+ file.fname+' dir:'+file.dir, 2);
			//LOG(0, NAME+'>tree event, type:'+eventType+'; details:'+details);
			get_envRef().listen(ID_E_FILE_SELECTED, {id:file.id, fname:file.fname, dir:file.dir});
		}
		
		private function getFileById(id:uint):Object {
			for each(var i:Object in loadedList) {
				if (i.id==id) {
					if (i.typ=="folder") {return null;}
					return i;
				}
			}
		}
		
		//{ =*^_^*= private 
		private var loadedList:Array;
		private var firstLoad:Boolean=true;
		
		private var vc:VCCourseLoader;
		private var a:Application;
		//} =*^_^*= END OF private
		
		
		//{ =*^_^*= id
		/**
		 * data:uint
		 * 0 false, 1 true, 2 toggle
		 */
		public static const ID_A_SET_VISIBILITY:String=NAME+'>ID_A_SET_VISIBILITY';
		/**
		 * data:[x,y,w,h]
		 */
		public static const ID_A_SET_WINDOW_XYWH:String=NAME+'>ID_A_SET_WINDOW_XYWH';
		/**
		 * data:VCCourseLoader
		 */
		public static const ID_A_REGISTER_SINGLETON_VC:String = NAME + '>ID_A_REGISTER_SINGLETON_VC';
		
		//public static const ID_E_:String = NAME + '>';
		public static const ID_E_FIRST_FREE_FOLDER_ID:String = NAME + '>ID_E_FIRST_FREE_FOLDER_ID';
		/**
		 * {id:file.id, fname:file.fname, dir:file.dir}
		 */
		public static const ID_E_FILE_SELECTED:String = NAME + '>ID_E_FILE_SELECTED';
		//} =*^_^*= END OF id
		
		public override function autoSubscribeEvents():Array {
			return [
				ID_A_REGISTER_SINGLETON_VC
				,ID_A_SET_VISIBILITY
				,ID_A_SET_WINDOW_XYWH
			];
		}
		
		public static const NAME:String = 'VCMCourseLoader';
	}
}


//{ =*^_^*= History
/* > (timestamp) [ ("+" (added) ) || ("-" (removed) ) || ("*" (modified) )] (text)
 * > 
 */
//} =*^_^*= END OF History

// template last modified:11.03.2011_[18#51#40]_[5]