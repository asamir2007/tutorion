// Project ComponentTemplate
package cccct.main {
	
	//{ =*^_^*= import
	import cccct.data.ApplicationConstants;
	import cccct.LOGGER0;
	import cccct.LOG;
	import flash.display.Sprite;
	import flash.events.Event;
	import cccct.lib.Library;
	import org.aswing.AsWingManager;
	import org.jinanoimateydragoncat.works.tutorion.v.d.DUTreeNode;
	import org.jinanoimateydragoncat.works.tutorion.v.VCCourseLoader;
	//} =*^_^*= END OF import
	
	
	/**
	 * Main
	 * @author Jinanoimatey Dragoncat
	 * @version 0.0.0
	 * @created 
	 */
	public class ComponentTemplate extends Sprite {
		
		//{ =*^_^*= CONSTRUCTOR
		
		function ComponentTemplate () {
			if (stage) {init();}
			else {addEventListener(Event.ADDED_TO_STAGE, init);}
		}
		
		private function init(e:Event=null):void {
			//{ ^_^ prepare
			Library.initialize(libraryInitialized);
			if (e) {removeEventListener(e.type, arguments.callee);}
			//} ^_^ END OF prepare
		}
		private function libraryInitialized():void {
			// entry point
			
			prepareLoggingAndConsole();
			prepareView();
			prepareControl();
			return;
			prepareData();
			prepareNetwork();
			run();
		}
		
		//} =*^_^*= END OF CONSTRUCTOR
		
		
		
		//{ =*^_^*= run application
		private function run():void {
			
		}
		//} =*^_^*= END OF run application
		
		
		
		//{ =*^_^*= view
		private function prepareView():void {
			AsWingManager.initAsStandard(this, true, false);
			
			var cs:VCCourseLoader=new VCCourseLoader;
			cs.construct(el_tree, 'select course');
			
			//fill with data:
			var id:uint=1;
			var data:DUTreeNode=new DUTreeNode(id++, 'folder one');
			var folder:DUTreeNode;
			
			data.addContent(new DUTreeNode(id++, 'file one'));
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
			
			
			cs.setData(data);
		}
		//} =*^_^*= END OF view
		
		
		
		//{ =*^_^*= control
		private function prepareControl():void {
			
		}
		private function el_tree(target:VCCourseLoader, eventType:String, details:Object=null):void {
			LOG(LOGGER0.C_V, 'tree event, type:'+eventType+'; details:'+details);
		}
		//} =*^_^*= END OF control
		
		
		
		//{ =*^_^*= data
		private function prepareData():void {
			
		}
		//} =*^_^*= END OF data
		
		
		
		//{ =*^_^*= network
		private function prepareNetwork():void {
			
		}
		//} =*^_^*= END OF network
		
		
		//{ =*^_^*= logging and console
		private function prepareLoggingAndConsole():void {
			// tip: press "`" button to display/hide console
			LOGGER0.prepareConsole(ApplicationConstants.appW, ApplicationConstants.appH, ApplicationConstants.appH/3);
			LOGGER0.prepareLogging();
			// show console:
			addChild(LOGGER0.getConsoleDisplayObject());
			LOGGER0.getConsoleDisplayObject().visible=true;
		}
		//} =*^_^*= END OF logging and console
		
	}
}

//{ =*^_^*= History
/* > (timestamp) [ ("+" (added) ) || ("-" (removed) ) || ("*" (modified) )] (text)
 * > 
 */
//} =*^_^*= END OF History

// template last modified:11.03.2011_[18#55#10]_[5]