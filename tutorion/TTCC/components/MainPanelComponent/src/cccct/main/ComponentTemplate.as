// Project ComponentTemplate
package cccct.main {
	
	//{ =*^_^*= import
	import cccct.data.ApplicationConstants;
	import cccct.LOG;
	import cccct.LOGGER0;
	import org.jinanoimateydragoncat.works.tutorion.v.VCMainPanel;
	import org.jinanoimateydragoncat.works.tutorion.v.VCMainPanelButtonElement;
	import org.jinanoimateydragoncat.works.tutorion.v.VCMainPanelClassroomInfoElement;
	import org.jinanoimateydragoncat.works.tutorion.v.VCMainPanelContactsList;
	import org.jinanoimateydragoncat.works.tutorion.v.VCMainPanelContactsListElement;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import cccct.lib.Library;
	import org.aswing.AsWingManager;
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
		}
		
		private var ch:VCMainPanel;
		//} =*^_^*= END OF view
		
		
		
		//{ =*^_^*= control
		private function prepareControl():void {
			
			//button images
			var cI:Bitmap=new Bitmap(new BitmapData(15,15,false, 0x00ff00));
			var eI:Bitmap=new Bitmap(new BitmapData(20,20,false, 0x00ffff));
			
			//user avatars
			var bmM:BitmapData=new BitmapData(30,30,false, 0x00ff00);
			var bm0:BitmapData=new BitmapData(30,30,false, 0x1144ee);
			var bm1:BitmapData=new BitmapData(30,30,false, 0xee44ee);
			var bm2:BitmapData=new BitmapData(30,30,false, 0xee4400);
			
			
			var vc:VCMainPanel=new VCMainPanel;
			vc.construct(el_mp, 3);
			vc.setBGColor(0x0088aa);
			
			var mainB:VCMainPanelButtonElement=new VCMainPanelButtonElement();
			mainB.construct(new Bitmap(bmM), 'Вид');
			
			
			var b0:VCMainPanelButtonElement=new VCMainPanelButtonElement();
			b0.construct(new Bitmap(bm0));
			var b1:VCMainPanelButtonElement=new VCMainPanelButtonElement();
			b1.construct(new Bitmap(bm1));
			var b2:VCMainPanelButtonElement=new VCMainPanelButtonElement();
			b2.construct(new Bitmap(bm2));
			
			var t0:VCMainPanelClassroomInfoElement=new VCMainPanelClassroomInfoElement;
			t0.construct();
			t0.set_dt0W(50);
			t0.set_dt1W(50);
			t0.setTextOutput(VCMainPanelClassroomInfoElement.ID_OUT_TEXT_0, 'Класс:');
			t0.setTextOutput(VCMainPanelClassroomInfoElement.ID_OUT_TEXT_1, 'первый А');
			
			vc.addElement(mainB);
			vc.addElement(b0);
			vc.addElement(b1);
			vc.addElement(b2);
			vc.addElement(t0);
			
			addChild(vc.get_displayObject());
		}
		
		private function el_mp(target:VCMainPanel, eventType:String, eventDetails:Object):void {
			LOG(3,'vc action:eventType='+eventType+'details'+eventDetails, 0);
			
			/*switch (eventType) {
			
			case VCMainPanel.ID_E_BUTTON_SEND:
				break;
			
			
			}*/
			
		}
		
		
		/*private function contactAction (target:VCMainPanelContactsListElement, eventType:String):void {
			LOG(3,'contact action:id='+target.get_id()+' eventType='+eventType, 0);
			
			switch (eventType) {
			
			case VCMainPanelContactsListElement.EVENT_ELEMENT_SELECTED:
				ch.setTextInput(VCMainPanel.ID_TEXT_IN_0, 'Dear '+list_userNames[target.get_id()]+', ');
				break;
			
			}
		}*/
		
		
		private var list_userNames:Array=[
			'userOne'
			,'userTwo'
			,'user3'
			,'user4'
			,'user5'
			,'user6'
			,'user7'
			,'user8'
			,'user9'
			,'user10'
			,'user11'
			,'user12'
			,'user13'
			,'user14'
			,'user15'
			,'user16'
		];
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