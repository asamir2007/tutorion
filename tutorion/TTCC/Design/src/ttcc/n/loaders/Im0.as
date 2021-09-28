package ttcc.n.loaders {
	
	//{ =^_^= import
	import flash.display.Loader;
	import flash.errors.IOError;
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.utils.Dictionary;
	import ttcc.LOG;
	//} =^_^= END OF import
	
	
	/**
	 * @author Jinanoimatey Dragoncat
	 * function err (target, true) {}</code>
	 */
	public class Im0 extends Loader {
		
		//{ =^_^= CONSTRUCTOR
		
		/**
		 * automatically removes itself if error occured
		 * @param	path_ image path
		 * @param	name_ loader name
		 * @param init (this)
		 * @param complete (this)
		 * @param err (this,true)
		 * @param progress progress(im:Im0, e:ProgressEvent)
		 */
		function Im0(path_:String=null, name_:String=null, complete:Function=null, err:Function=null, progress:Function=null) {
			trace("Im0>path_ = " + path_);
			
			if (name_ != null)  {name = name_;}
			
			onLoadComplete = complete;
			onLoadError = err;
			path = path_;
			onProgress = progress;
			
			contentLoaderInfo.addEventListener(Event.COMPLETE, c);
			contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, onLoadingProgress);
			contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, er);
			contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, er);
			l(path_);
		}
		//} =^_^= END OF CONSTRUCTOR
		
		
		
		/**
		 * load image
		 * @param	p image path
		 */
		public function l(p:String):void {
			path = p;
			
			loadB(p);
		}
		
		private function onLoadingProgress(e:ProgressEvent):void {
			hasProgress();
			if (onProgress!=null) {onProgress(this, e);}
		}
		
		private function c(e:Event):void {
			removeListeners();
			if (onLoadComplete != null) {
				onLoadComplete(this);
			}
			onLoadComplete = null;
		}
		
		
		private function er(e:Event):void {
			if (e!=null) {
				tr("Im0>er> error loading: "+
				traceObject(e)
				+'\n'
				+'e.toString:'+e.toString()
				+'is SecurityErrorEvent:'+(e is SecurityErrorEvent)
				+'is IOErrorEvent:'+(e is IOErrorEvent)
				+'\nurl='+p
				);
			} else {
				tr('loading error:uncknown error( error object is null)');
			}
			
			removeListeners();
			
			if (onLoadError != null) {
				onLoadError(this, true);
			} else if (parent != null){
				parent.removeChild(this);
				onLoadError = null;
			}
		}
		
		private function hasProgress(e:Object=null):void {
			// cancel timer
		}
		
		
		private function removeListeners():void {
			contentLoaderInfo.removeEventListener(Event.COMPLETE,c);
			contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS,onLoadingProgress);
			contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, er);
			contentLoaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, er);
			onProgress = null;
		}
		
		
		public function get_path():String {return path;}
		private var path:String;
		private var onLoadError:Function;
		private var onLoadComplete:Function;
		private var onProgress:Function;
		
		
		// caching
		private function loadB(path:String):void {
			// add to list
			if (path == null) {
				tr('Im0>ERROR>path==null');
				if (onLoadError!=null) {onLoadError(this, true);}
				return;
			}
			
			loadTexture(path);
		}
		
		private function loadTexture(pt:String):void {
			path=pt;
			loadNextTexture();
		}
		
		private function addTo_texturesToLoad(path:String):void {
			// ++try count
			//trace('1141 addTo_texturesToLoad>'+path);
			/*if (!lTryCount[path]) {
				//trace('1141 !lTryCount['+path+'] set to 1')
				lTryCount[path]=1;
			} else if (lTryCount[path]>MAX_TEXTURE_LOAD_TRY_COUNT) {
				//dont
				trace('1141 lTryCount['+path+']>MAX_TEXTURE_LOAD_TRY_COUNT')
				removeFrom_texturesToLoad(path, true);
				return;
			} else {
				trace('1141 lTryCount['+path+']+=1')
				lTryCount[path]+=1;
			}*/
			
			if (texturesToLoad.indexOf(path) == -1)
				texturesToLoad.push(path);
		}
		
		private function removeFrom_texturesToLoad(path:String, error:Boolean=false):void {
			//trace('1141 removeFrom_texturesToLoad>'+path)
			// clear try count
			lTryCount[path]=null;
			if (texturesToLoad.indexOf(path)) {
				texturesToLoad.splice(texturesToLoad.indexOf(path), 1);
			}
			
			if (error) {
				if (reqP.indexOf(path)!=-1) {
					reqI.splice(reqP.indexOf(path) ,1);
					reqP.splice(reqP.indexOf(path) ,1);
				}
			}
			
		}
		private const lTryCount:Dictionary=new Dictionary();
		
		private function loadNextTexture():void {
			loader_ = new URLLoader();
			loader_.dataFormat = URLLoaderDataFormat.BINARY;
			
			loader_.addEventListener(Event.COMPLETE, l_complete);
			loader_.addEventListener(IOErrorEvent.IO_ERROR, l_err);
			loader_.addEventListener(SecurityErrorEvent.SECURITY_ERROR, l_err);
			loader_.addEventListener(HTTPStatusEvent.HTTP_STATUS, l_responce_status);
			
			tr('Im0> >>> loading from:' + p);
			
			loader_.load(new URLRequest(path));
		}
		
		
		
		private function l_err(e:Event):void {
			//LOG(4,'l_err',2);
			if (e!=null) {
				tr("Im0>l_err>error loading: "+
				traceObject(e)
				+'\n'
				+'e.toString:'+e.toString()
				+'is SecurityErrorEvent:'+(e is SecurityErrorEvent)
				+'is IOErrorEvent:'+(e is IOErrorEvent)
				);
			} else {
				tr('loading error:uncknown error( error object is null)');
			}
			
			loader_.removeEventListener(Event.COMPLETE, l_complete);
			loader_.removeEventListener(IOErrorEvent.IO_ERROR, l_err);
			loader_.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, l_err);
			loader_.removeEventListener(HTTPStatusEvent.HTTP_STATUS, l_responce_status);
			loader_ = null;
			
		}
		
		private function l_responce_status(e:HTTPStatusEvent):void {
			//LOG(0,'l_responce_status>>>status='+e.status+'\nraw data:'+e.toString(), 1);
			if (e.status==304/* || e.status==200*/) {
				LOG(0,'STATUS 304, manually invoke complete()', 2);
				l_complete();
			}
		}
		
		private function l_complete(e:Event = null):void {
			//LOG(4,'l_complete ^_^',1);
			if (!loader_) {return;}
			if (loader_.data==null) {
				tr('Im0>ERR:'+'loader_.data==null');
				return;
			}
				loader_.removeEventListener(Event.COMPLETE, l_complete);
				loader_.removeEventListener(IOErrorEvent.IO_ERROR, l_err);
				loader_.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, l_err);
				loader_.removeEventListener(HTTPStatusEvent.HTTP_STATUS, l_responce_status);
				
			
			tr('Im0> <<<<< loaded from url:'+p);
			
			var context:LoaderContext = new LoaderContext(false);
			
			loadBytes(loader_.data, context);
			loader_ = null;
		}
		
		
		private function tr(...args):void {
			LOG(5, 'Im0 trace>'+traceObject(args));
		}
		
		private var p:String;
		private var loader_:URLLoader;
		
		
		
	}
}

//{ =^_^= History
/* > (timestamp) [ ("+" (added) ) || ("-" (removed) ) || ("*" (modified) )] (text)
 */
//} =^_^= END OF History

// template last modified:03.05.2010_[22#42#27]_[1]