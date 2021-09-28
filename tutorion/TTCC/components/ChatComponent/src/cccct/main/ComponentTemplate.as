// Project ComponentTemplate
package cccct.main {
	
	//{ =*^_^*= import
	import cccct.data.ApplicationConstants;
	import cccct.LOG;
	import cccct.LOGGER0;
	import org.jinanoimateydragoncat.works.tutorion.v.VCChat;
	import org.jinanoimateydragoncat.works.tutorion.v.VCChatContactsList;
	import org.jinanoimateydragoncat.works.tutorion.v.VCChatContactsListElement;
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
		
		private var ch:VCChat;
		//} =*^_^*= END OF view
		
		
		
		//{ =*^_^*= control
		private function prepareControl():void {
			//button images
			var cI:Bitmap=new Bitmap(new BitmapData(15,15,false, 0x00ff00));
			var eI:Bitmap=new Bitmap(new BitmapData(20,20,false, 0x00ffff));
			
			//user avatars
			var bm0:BitmapData=new BitmapData(20,20,false, 0x1144ee);
			var bm1:BitmapData=new BitmapData(20,20,false, 0xee44ee);
			var bm2:BitmapData=new BitmapData(20,20,false, 0x0044ff);
			function gb():Bitmap {return new Bitmap([bm0,bm1,bm2][uint(Math.round(Math.random()*2))]);}
			
			// user list
			var cl:VCChatContactsList=new VCChatContactsList(contactAction, 40, 10);
			//fill
			var l:uint = list_userNames.length;
			for (var i:uint = 0;i < l;i++ ) {
				cl.addElement(list_userNames[i], gb(), i, Boolean(uint(Math.round(Math.random()*2))));
			}
			
			//chat VC
			ch=new VCChat;
			ch.construct(chatAction, 'Chat.', cI, eI, cl, 400,200, 25, 30);
			addChild(ch.get_displayObject());
			
			ch.setOutText('<h><font color="#ff0000"><b><i>[admin]: </i></b></font></h> wellcome, %username%');
			
			ch.setTextInput(VCChat.ID_TEXT_IN_0, 'enter your message here, than press -->');
		}
		
		private function chatAction (target:VCChat, eventType:String):void {
			LOG(3,'chat action:eventType='+eventType, 0);
			switch (eventType) {
			
			case VCChat.ID_E_BUTTON_SEND:
				ch.addToOutText('\n'+ch.getTextInput(VCChat.ID_TEXT_IN_0));
				ch.setTextInput(VCChat.ID_TEXT_IN_0, '');
				break;
			
			
			}
		}
		
		private function contactAction (target:VCChatContactsListElement, eventType:String):void {
			LOG(3,'contact action:id='+target.get_id()+' eventType='+eventType, 0);
			
			switch (eventType) {
			
			case VCChatContactsListElement.EVENT_ELEMENT_SELECTED:
				ch.setTextInput(VCChat.ID_TEXT_IN_0, 'Dear '+list_userNames[target.get_id()]+', ');
				break;
			
			}
		}
		
		
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