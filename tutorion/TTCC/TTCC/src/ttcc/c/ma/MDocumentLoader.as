// Project TTCC
package ttcc.c.ma {
	
	//{ =*^_^*= import
	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.utils.ByteArray;
	import ttcc.APP;
	import ttcc.Application;
	import ttcc.c.ae.AEApp;
	import ttcc.c.vcm.VCMPresentationLoader;
	import ttcc.cfg.AppCfg;
	import ttcc.cfg.SP;
	import ttcc.d.m.AbstractModel;
	import ttcc.LOGGER;
	import ttcc.media.Text;
	//} =*^_^*= END OF import
	
	
	/**
	 * chat manager - ctrl chat
	 * @author Jinanoimatey Dragoncat
	 * @version 0.0.0
	 * @created 29.08.2012 0:30
	 */
	public class MDocumentLoader extends AM {
		
		//{ =*^_^*= CONSTRUCTOR
		
		function MDocumentLoader (app:Application) {
			super(NAME);
			a=app;
		}
		//} =*^_^*= END OF CONSTRUCTOR
		
		public override function listen(eventType:String, details:Object):void {
			//var r:ARO;
			
			switch (eventType) {
				
				case ID_A_RUN:
					setUIMode(3);
						setStateText('выберите файл для загрузки.');
					break;
					
				case VCMPresentationLoader.ID_E_REQ_SELECT_FILE:
					fr = new FileReference();
					fr.addEventListener(Event.SELECT, onFileSelect);
					fr.addEventListener(Event.CANCEL, function (e:Event):void {
						setStateText('выберите файл для загрузки.');
					});
					//setStateText('select file to upload');
					fr.browse([new FileFilter("Файл презентации, документ или изображение", "*.txt;*.doc;*.xls;*.ppt;*.pptx;*.pdf;*.jpg;*.jpeg;*.gif;*.png")]);	
					break;
					
				case VCMPresentationLoader.ID_E_REQ_UPLOAD:
					// send url list
					e.listen(ID_E_ADD_PAGES, selectedPagesURLsList);
					setUIMode(3);
						setStateText('выберите файл для загрузки.');
					e.listen(VCMPresentationLoader.ID_A_SET_PAGES, null);
					break;
					
			}
		}
		
		private function onFileSelect(e:Event):void{
			//log(7, "File selected:"+fr.name+" size:"+fr.size+" max filesize:"+AppCfg.DOCUMENT_LOADER_MAX_FILESIZE);
			if(fr.size>AppCfg.DOCUMENT_LOADER_MAX_FILESIZE) {
				setStateText("файл слишком большой:"+uint(fr.size/1024/1024)+"мб, макс:"+AppCfg.DOCUMENT_LOADER_MAX_FILESIZE/1024/1024);
				return;
			}
			setUIMode(1);
			setProgressBar(0);
			setStateText("загрузка файла на сервер...");
			// upload to server
			upload();
		}
		
		//{ =*^_^*= =*^_^*= working with server
		private function upload():void{
			fr.addEventListener(ProgressEvent.PROGRESS, onProgress);
			fr.addEventListener(DataEvent.UPLOAD_COMPLETE_DATA,uploadComplete);
			fr.addEventListener(HTTPStatusEvent.HTTP_STATUS, onHttpStatus);
			fr.addEventListener(SecurityErrorEvent.SECURITY_ERROR,onFail);
			fr.addEventListener(IOErrorEvent.IO_ERROR, onFail);		
			//log(0,"start upload to "+url,0);
			var request:URLRequest;
			request = new URLRequest(a.get_ds().get_startupPathsList().get_contentPath());
			request.data=a.get_httpXMLAdaptor().constructAndSignInitialReqDataObject("convert_presenatation", null);
			//Network.authObj("convert_presenatation");
			request.method=URLRequestMethod.POST;		         
			fr.upload(request);
		}
		private function onProgress(e:ProgressEvent):void {
			//status("onProgress:"+e.bytesLoaded+" of "+e.bytesTotal, 0);
			setProgressBar(e.bytesLoaded/e.bytesTotal);		
			setStateText('загрузка... '+int(e.bytesLoaded/1024)+"кб из "+int(e.bytesTotal/1024));
			
			if (e.bytesLoaded!=e.bytesTotal) {return;}
			setStateText("обработка файла на сервере...");
		}
		private function onFail(e:Event):void{
			//status("onFail:"+e,3);
			setStateText("не удалось загрузить файл");
			setUIMode(0);
		}
		private function onHttpStatus(e:HTTPStatusEvent):void {
			//status("onHttpStatus:"+e,2);
		}
		private function uploadComplete(e:DataEvent):void {
			setStateText("загрузка на сервер завершена");
			setUIMode(2);
			
			var s:String=e.data;
			//log(0,'response:'+s,1);
			//return;
			
			var a:int,b:int,n:int;
			var urls:Array=new Array();
			for(n=0;;n++) {
				a=s.indexOf("\n");
				if(a<0)break;	// '<' must be first (if any)			
				//b=s.indexOf("\n");
				//if(b<2)break;	// empty url or '>' missed
				urls.push(s.substring(0,a));
				s=s.substring(a+1);
				//status("url"+n+":"+urls[n]);
			}
			if (!n) {
				log(5,"No URLs found!",0);
				log(5,"server response: "+e.data,0);
				setStateText("не найдено картинок в файле. попробуйте снова.");
				setUIMode(3);
				return;
			}
			//{test
			/*if (urls.length<5) {
				urls.push(urls[0]);
				urls.push(urls[0]);
				urls.push(urls[0]);
				urls.push(urls[0]);
				urls.push(urls[0]);
			}*/
			//}test
			
			selectedPagesURLsList=urls;
			setUIMode(0);
			get_envRef().listen(VCMPresentationLoader.ID_A_SET_PAGES, selectedPagesURLsList);
		}
		//} =*^_^*= =*^_^*= END OF working with server		
		
		
		private function setStateText(text:String):void {
			e.listen(VCMPresentationLoader.ID_A_SET_TEXT_STATE, text);
		}
		private function setProgressBar(a:Number):void {
			e.listen(VCMPresentationLoader.ID_A_SET_LOADED_PERCENT, a);
		}
		/**
		 * 0,1,2,3-ready
		 */
		private function setUIMode(a:uint):void {
			e.listen([
				VCMPresentationLoader.ID_A_SET_DISPLAY_MODE_SELECT
				,VCMPresentationLoader.ID_A_SET_DISPLAY_MODE_PROGRESS_BAR
				,VCMPresentationLoader.ID_A_SET_DISPLAY_MODE_UPLOAD
				,VCMPresentationLoader.ID_A_SET_DISPLAY_MODE_READY
				][a],a);
		}
		
		//{ =*^_^*= private 
		private var fr:FileReference;
		private var selectedPagesURLsList:Array;
		//} =*^_^*= END OF private
		
		private function get e():AEApp {return get_envRef();}
		private var a:Application;		
		
		//{ =*^_^*= id
		public static const ID_A_RUN:String=NAME+'>ID_A_RUN';
		//} =*^_^*= END OF id
		
		//{ =*^_^*= events
		/**
		 * [String]
		 */
		public static const ID_E_ADD_PAGES:String=NAME+'>ID_E_ADD_PAGES';
		//} =*^_^*= END OF events
		
		
		public static const NAME:String = 'MDocumentLoader';
		
		public override function autoSubscribeEvents():Array {
			return [
				ID_A_RUN
				,VCMPresentationLoader.ID_E_REQ_SELECT_FILE
				,VCMPresentationLoader.ID_E_REQ_UPLOAD
			];
		}
		
		
	}
}


//{ =*^_^*= History
/* > (timestamp) [ ("+" (added) ) || ("-" (removed) ) || ("*" (modified) )] (text)
 * > 
 */
//} =*^_^*= END OF History

// template last modified:11.03.2011_[18#51#40]_[5]