// Project ComponentTemplate
package cccct.main {
	
	//{ =*^_^*= import
	import cccct.data.ApplicationConstants;
	import cccct.LOGGER0;
	import cccct.LOG;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import cccct.lib.Library;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import org.aswing.AsWingManager;
	import org.jinanoimateydragoncat.works.tutorion.v.VCPresentationLoader;
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
			
			cs=new VCPresentationLoader;
			cs.set_text_b_apply('apply');
			cs.set_text_b_load('load');
			cs.construct(el_vc, 'Presentation loader');
		}
		
		/**
		 * pages to display in VC
		 */
		private function setPages():void {
			var numPages:uint=20;
			var pages:Array=[];
			var page:BookPage;
			var imu:BitmapData;
			for (var i:uint = 0; i < numPages;i++) {
				imu=(Math.random()>.5)?Library.image0:Library.image1;
				page=new BookPage(imu, 350,550);
				bookPages.push(page);
				pages.push(page.get_vc());
			}
			cs.setImageListOutput(VCPresentationLoader.ID_OUT_IMAGE_PAGES, pages);
		}
		
		private function clearPages():void {
			maxScrollA=0;
			bookPages=new Vector.<BookPage>;
			cs.setImageListOutput(VCPresentationLoader.ID_OUT_IMAGE_PAGES, null);
		}
		
		private var bookPages:Vector.<BookPage>=new Vector.<BookPage>;
		private var cs:VCPresentationLoader=new VCPresentationLoader;
		//} =*^_^*= END OF view
		
		
		
		//{ =*^_^*= control
		private function prepareControl():void {
			//display load button
			cs.setTextOutput(VCPresentationLoader.ID_OUT_TEXT_STATE, 'press load button to select a file');
			cs.setUintOutput(VCPresentationLoader.ID_OUT_UINT_DISPLAY_MODE, VCPresentationLoader.ID_MODE_LOAD);
			pbTimer.addEventListener(TimerEvent.TIMER, el_pbTimer);
		}
		
		private function el_vc(target:VCPresentationLoader, eventType:String, details:Object=null):void {
			LOG(LOGGER0.C_V, 'event, type:'+eventType+'; details:'+details);
			switch (eventType) {
			
			case VCPresentationLoader.ID_E_B_LOAD:
				cs.setTextOutput(VCPresentationLoader.ID_OUT_TEXT_STATE, 'loading file...');
				cs.setUintOutput(VCPresentationLoader.ID_OUT_UINT_DISPLAY_MODE, VCPresentationLoader.ID_MODE_PROGRESS_BAR);
				//set progressbar value to 0
				cs.setNumberOutput(VCPresentationLoader.ID_OUT_NUMBER_PROGRESS ,0);
				//increase progressbar value
				pbTimer.start();
				break;
			case VCPresentationLoader.ID_E_B_APPLY:
				//wait for user clics aply button
				cs.setTextOutput(VCPresentationLoader.ID_OUT_TEXT_STATE, 'file has been uploaded to the server, load another one?');
				cs.setUintOutput(VCPresentationLoader.ID_OUT_UINT_DISPLAY_MODE, VCPresentationLoader.ID_MODE_LOAD);
				clearPages();
			break;
			
			case VCPresentationLoader.ID_E_SCROLL:	
				var numToLoad:uint=Math.min(bookPages.length, uint(Math.round(details*bookPages.length))+2);
				if (numToLoad<maxScrollA) {break;}
				maxScrollA=numToLoad;
				for (var i:uint = 0; i < numToLoad;i++) {
					bookPages[i].loadImage();
				}
			break;
			
			}
		}
		
		
		private function el_pbTimer(e:Event):void {
			bpVal+=.05;
			cs.setNumberOutput(VCPresentationLoader.ID_OUT_NUMBER_PROGRESS ,bpVal);
			if (bpVal>=1) {
				pbTimer.stop();pbTimer.reset();bpVal=0;
				// display apply button
				cs.setUintOutput(VCPresentationLoader.ID_OUT_UINT_DISPLAY_MODE, VCPresentationLoader.ID_MODE_LOADED);
				cs.setTextOutput(VCPresentationLoader.ID_OUT_TEXT_STATE, 'file has been loaded successfully, press apply button');
				setPages();
			}
		}
		
		private var maxScrollA:uint;
		private var bpVal:Number=0;
		private var pbTimer:Timer=new Timer(100, 21);
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

import cccct.lib.Library;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.DisplayObject;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.TimerEvent;
import flash.utils.Timer;
import org.jinanoimateydragoncat.display.utils.Utils;

class BookPage {
	function BookPage (bdRef:BitmapData, pageW:uint, pageH:uint):void {
		this.pageW=pageW;
		this.pageH=pageH;
		this.bdRef=bdRef;
		d=new Sprite();
		d.graphics.lineStyle(3,0x00ff00);
		d.graphics.beginFill(0x88aaaa);
		d.graphics.drawRect(0,0,pageW, pageH);
		//"loading" animation substitute
		loaderIm=d.addChild(new Bitmap(Library.loaderIm));
		t.addEventListener(TimerEvent.TIMER_COMPLETE, el_t);
	}
	public function get_vc():Sprite {return d;}
	
	public function loadImage():void {
		if (startedLoading) {return;}startedLoading=true;
		t.start();
	}
	
	/**
	 * simulate loading
	 */
	private function el_t(e:Event):void {
		t.reset();
		//loaded
		//remove loader im
		d.removeChild(loaderIm);

		var b:Bitmap=new Bitmap(bdRef);
		//resize
		Utils.resizeDO(b, pageW, pageH);
		Utils.centerDO(b, d.getBounds(d));
		//add loaded im
		d.addChild(b);
	}
	
	private var pageW:uint;
	private var pageH:uint;
	
	private var t:Timer=new Timer(750,1);
	
	private var loaderIm:DisplayObject;
	private var startedLoading:Boolean;
	private var d:Sprite;
	private var bdRef:BitmapData;
}

//{ =*^_^*= History
/* > (timestamp) [ ("+" (added) ) || ("-" (removed) ) || ("*" (modified) )] (text)
 * > 
 */
//} =*^_^*= END OF History

// template last modified:11.03.2011_[18#55#10]_[5]