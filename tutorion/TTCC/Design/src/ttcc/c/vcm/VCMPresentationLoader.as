// Project TTCC
package ttcc.c.vcm {
	
	//{ =*^_^*= import
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.PixelSnapping;
	import flash.display.Sprite;
	import ttcc.APP;
	import ttcc.cfg.AppCfg;
	import ttcc.LOG;
	import ttcc.media.Text;
	import ttcc.n.loaders.Im;
	import ttcc.v.pl.VCPresentationLoader;
	//} =*^_^*= END OF import
	
	/**
	 * display manager - controlls interface
	 * @author Jinanoimatey Dragoncat
	 * @version 0.0.0
	 * @created 21.06.2012 3:41
	 */
	public class VCMPresentationLoader extends AVCM {
		
		//{ =*^_^*= CONSTRUCTOR
		
		function VCMPresentationLoader () {
			super(NAME);
		}
		//} =*^_^*= END OF CONSTRUCTOR
		
		
		public override function listen(eventType:String, details:Object):void {
			
			switch (eventType) {
			
			case ID_A_REGISTER_SINGLETON_VC:
				vc=details;
				cs=details;
				configureVC();
				break;
				
			case ID_A_SET_VISIBILITY:
				vc.set_visible((details<2)?Boolean(details):!vc.get_visible());
				break;
			case ID_A_SET_WINDOW_XYWH:
				vc.setXY(details[0],details[1]);
				vc.setWH(details[2],details[3]);
				break;
				
			case ID_A_SET_PAGES:
				setPages(details);
				break;
				
			case ID_A_SET_TEXT_STATE:
				vc.setTextOutput(VCPresentationLoader.ID_OUT_TEXT_STATE, details);
				break;
			case ID_A_SET_LOADED_PERCENT:
				vc.setNumberOutput(VCPresentationLoader.ID_OUT_NUMBER_PROGRESS, details);
				break;
			case ID_A_SET_DISPLAY_MODE_SELECT:
				vc.setUintOutput(VCPresentationLoader.ID_OUT_UINT_DISPLAY_MODE, VCPresentationLoader.ID_MODE_LOADED);
				break;
			case ID_A_SET_DISPLAY_MODE_READY:
				vc.setUintOutput(VCPresentationLoader.ID_OUT_UINT_DISPLAY_MODE, VCPresentationLoader.ID_MODE_READY);
				break;
			case ID_A_SET_DISPLAY_MODE_UPLOAD:
				vc.setUintOutput(VCPresentationLoader.ID_OUT_UINT_DISPLAY_MODE, VCPresentationLoader.ID_MODE_LOAD);
				break;
			case ID_A_SET_DISPLAY_MODE_PROGRESS_BAR:
				vc.setUintOutput(VCPresentationLoader.ID_OUT_UINT_DISPLAY_MODE, VCPresentationLoader.ID_MODE_PROGRESS_BAR);
				break;
				
			}
		}
		
		private function configureVC():void {
			vc.setListener(el_vc);
		}
		
		
		private function el_vc(target:VCPresentationLoader, eventType:String, details:Object=null):void {
			//LOG(3, 'event, type:'+eventType+'; details:'+details);
			switch (eventType) {
			
			case VCPresentationLoader.ID_E_B_SELECT_FILE:
				get_envRef().listen(ID_E_REQ_SELECT_FILE, null);
				break;
			case VCPresentationLoader.ID_E_B_UPLOAD:
				get_envRef().listen(ID_E_REQ_UPLOAD, null);
				break;
			case VCPresentationLoader.ID_E_SCROLL:
				// load visible pages
				//LOG(0, NAME+'>scroll:'+details);
				var numToLoad:uint=Math.min(bookPages.length, Math.max(1, uint(Math.round(details*bookPages.length))+2));
				if (numToLoad<maxScrollA) {/*LOG(0,'numToLoad<maxScrollA:'+numToLoad+'<'+maxScrollA,1);*/break;}
				maxScrollA=numToLoad;
				for (var i:uint = 0; i < numToLoad;i++) {
					bookPages[i].loadImage();
				}
				//LOG(0, 'load till:'+numToLoad,1);
			break;
			
			}
		}
		
		//{ =*^_^*= view
		private function setPages(pages:Array):void {
			// clear
			vc.setImageListOutput(VCPresentationLoader.ID_OUT_IMAGE_PAGES, null);
			//reset
			maxScrollA=0;
			// remove all pages
			for each(var i:BookPage in bookPages) {i.destroy();}
			bookPages=new Vector.<BookPage>;
			
			if (!pages) {return;}
			pagesURL=pages;
			// display empty pages awaiting user to scroll down to watch them
			placePages(pages.length);
		}
		
		/**
		 * pages to display in VC
		 */
		private function placePages(numPages:uint):void {
			var pagesDO:Array=[];
			var page:BookPage;
			for (var i:uint = 0; i < numPages;i++) {
				page=new BookPage(pagesURL[i], new Bitmap(loaderImBD, PixelSnapping.ALWAYS), new Bitmap(brokenImBD, PixelSnapping.ALWAYS), 210,300);
				bookPages.push(page);
				pagesDO.push(page.get_vc());
			}
			cs.setImageListOutput(VCPresentationLoader.ID_OUT_IMAGE_PAGES, pagesDO);
		}
		
		private var loaderImBD:BitmapData=new BitmapData(10,10,true,0x99aa00aa);
		private var brokenImBD:BitmapData=new BitmapData(22,44,true,0x99ff1100);
		private var bookPages:Vector.<BookPage>=new Vector.<BookPage>;
		private var cs:VCPresentationLoader;
		//} =*^_^*= END OF view
		
		
		
		//{ =*^_^*= private 
		private var pagesURL:Array;
		private var maxScrollA:uint;
		private var vc:VCPresentationLoader;
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
		 * data:VCPresentationLoader
		 */
		public static const ID_A_REGISTER_SINGLETON_VC:String = NAME + '>ID_A_REGISTER_SINGLETON_VC';
		/**
		 * data:[String//image URL//]
		 */
		public static const ID_A_SET_PAGES:String = NAME + '>ID_A_SET_PAGES';
		/**
		 * data:String
		 */
		public static const ID_A_SET_TEXT_STATE:String = NAME + '>ID_A_SET_TEXT_STATE';
		/**
		 * data:Number 0..1
		 */
		public static const ID_A_SET_LOADED_PERCENT:String = NAME + '>ID_A_SET_LOADED_PERCENT';
		public static const ID_A_SET_DISPLAY_MODE_SELECT:String = NAME + '>ID_A_SET_DISPLAY_MODE_SELECT';
		public static const ID_A_SET_DISPLAY_MODE_READY:String = NAME + '>ID_A_SET_DISPLAY_MODE_READY';
		public static const ID_A_SET_DISPLAY_MODE_UPLOAD:String = NAME + '>ID_A_SET_DISPLAY_MODE_UPLOAD';
		public static const ID_A_SET_DISPLAY_MODE_PROGRESS_BAR:String = NAME + '>ID_A_SET_DISPLAY_MODE_PROGRESS_BAR';
		
		
		public static const ID_E_REQ_SELECT_FILE:String = NAME + '>ID_E_REQ_SELECT_FILE';
		public static const ID_E_REQ_UPLOAD:String = NAME + '>ID_E_REQ_UPLOAD';
		//} =*^_^*= END OF id
		
		public override function autoSubscribeEvents():Array {
			return [
				ID_A_REGISTER_SINGLETON_VC
				,ID_A_SET_VISIBILITY
				,ID_A_SET_WINDOW_XYWH
				,ID_A_SET_PAGES
				,ID_A_SET_TEXT_STATE
				,ID_A_SET_LOADED_PERCENT
				,ID_A_SET_DISPLAY_MODE_SELECT
				,ID_A_SET_DISPLAY_MODE_READY
				,ID_A_SET_DISPLAY_MODE_UPLOAD
				,ID_A_SET_DISPLAY_MODE_PROGRESS_BAR
			];
		}
		
		public static const NAME:String = 'VCMPresentationLoader';
	}
}



//{ =*^_^*= import 
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.DisplayObject;
import flash.display.Sprite;
import flash.events.Event;
import org.jinanoimateydragoncat.display.utils.Utils;
import ttcc.LOG;
import ttcc.n.loaders.Im0;
//} =*^_^*= END OF import

class BookPage {
	function BookPage (imageURL:String, loaderIm:Bitmap, brokenIm:Bitmap, pageW:uint, pageH:uint):void {
		this.brokenIm=brokenIm;
		this.loaderIm=loaderIm;
		this.imageURL=imageURL;
		this.pageW=pageW;
		this.pageH=pageH;
		d=new Sprite();
		d.graphics.lineStyle(2,0x000000);
		d.graphics.beginFill(0xffffff);
		d.graphics.drawRect(0,0,pageW, pageH);
	}
	public function destroy():void {
		if (d.contains(loaderIm)) {d.removeChild(loaderIm);}
		if (imLoader&&d.contains(imLoader)) {d.removeChild(imLoader);}
		if (imLoader&&imLoader.content!=null) {imLoader.unloadAndStop();}
		imLoader=null;
		loaderIm=null;
		d=null;
	}
	
	public function get_vc():Sprite {return d;}
	
	public function loadImage():void {
		if (loadAttemptPerformed) {return;}
		loadAttemptPerformed=true;
		//"loading" animation substitute
		d.addChild(loaderIm);
		imLoader=new Im0(imageURL, null, el_ImCompleteError, el_ImCompleteError);
		//var s:Sprite = new Sprite();
		//s.graphics.beginFill(0x00ff00);
		//s.graphics.drawRect(3,3,35,35);
		//s.graphics.beginFill(0xff0000);
		//s.graphics.drawRect(15,15,15,15);
		//setImage(s);
	}
	
	private function el_ImCompleteError(target:Im0, errorOccured:Boolean=false):void {
		if (errorOccured) {
			// TODO: display broken im bitmap
			LOG(3, 'VCMPresentationLoader>TODO: display broken im bitmap',1);
			//setImage(brokenIm);
			return;
		}
		setImage(target);
	}
	
	public function setImage(im:DisplayObject):void {
		if (d.contains(loaderIm)) {d.removeChild(loaderIm);}
		//resize
		if (!im) {return;}
		Utils.resizeDO(im, pageW, pageH);
		Utils.centerDO(im, d.getBounds(d));
		//add loaded im
		d.addChild(im);
	}
	
	private var imLoader:Im0;
	private var imageURL:String;
	private var pageW:uint;
	private var pageH:uint;
	private var loaderIm:DisplayObject;
	private var brokenIm:DisplayObject;
	private var d:Sprite;
	private var loadAttemptPerformed:Boolean;
	
}


//{ =*^_^*= History
/* > (timestamp) [ ("+" (added) ) || ("-" (removed) ) || ("*" (modified) )] (text)
 * > 
 */
//} =*^_^*= END OF History

// template last modified:11.03.2011_[18#51#40]_[5]