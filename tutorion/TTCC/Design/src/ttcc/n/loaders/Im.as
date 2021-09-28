package ttcc.n.loaders {
	
	//{ =^_^= import
	import flash.display.Loader;
	import flash.errors.IOError;
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.TimerEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	import ttcc.LOG;
	//} =^_^= END OF import
	
	
	/**
	 * image loader
	 * load image to cache
	 * @author Jinanoimatey Dragoncat
	 * @version 0.2.0
	 * @created 28.10.2010 21:58
	 * @usage <code>addChild(new im('\image1.jpg', 'instance name'[err, init, complete]));
	 * function err (target, true) {}</code>
	 */
	public class Im extends Loader {
		
		/**
		 * макс колво попыток загрузки для одного пути
		 */
		//private static const MAX_TEXTURE_LOAD_TRY_COUNT:uint = 20;
		
		
		//{ =^_^= CONSTRUCTOR
		
		/**
		 * automatically removes itself if error occured
		 * @param	path_ image path
		 * @param	name_ loader name
		 * @param init (this)
		 * @param complete (this)
		 * @param err (this,true)
		 * @param progress progress(im:Im, e:ProgressEvent)
		 */
		function Im(path_:String=null, name_:String=null, init:Function=null/*init first*/, complete:Function=null, err:Function=null, progress:Function=null, timeout:Number=0) {
			trace("Im>path_ = " + path_);
			
			if (name_ != null)  {name = name_;}
				
			onLoadComplete = complete;
			onLoadInit = init;
			onLoadError = err;
			path = path_;
			onProgress = progress;
			
			contentLoaderInfo.addEventListener(Event.COMPLETE, c);
			contentLoaderInfo.addEventListener(Event.INIT, i);
			contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, onLoadingProgress);
			contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, er);
			contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, er);
			
			if (path_ != null && path_.length > 0) {
				initTimer((timeout==0)?defaultTimeout:timeout);
				l(path_);
			}
			
		}
		//} =^_^= END OF CONSTRUCTOR
		
		
		
		/**
		 * load image
		 * @param	p image path
		 */
		public function l(p:String):void {
			path = p;
			
			loadB(p, this);
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
			slc();
		}
		
		private function i(e:Event):void {
			if (onLoadInit != null) {onLoadInit(this);}
			onLoadInit = null;
		}
		
		private function er(e:Event):void {
			if (e!=null) {
				tr("Im>er> error loading: "+
				traceObject(e)
				+'\n'
				+'e.toString:'+e.toString()
				+'is SecurityErrorEvent:'+(e is SecurityErrorEvent)
				+'is IOErrorEvent:'+(e is IOErrorEvent)
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
		
		/**
		 * @param	timeout 	in milliseconds
		 */
		private function initTimer(timeout:Number):void {
			timedoutTimer=new Timer(timeout, 1);
			timedoutTimer.addEventListener(TimerEvent.TIMER, el_timedoutTimer);
			timedoutTimer.start();
		}
		private function hasProgress(e:Object=null):void {
			// cancel timer
			if (!timedoutTimer) {return;}
			timedoutTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, el_timedoutTimer);
			timedoutTimer.stop();
			timedoutTimer=null;
		}
		private function el_timedoutTimer(e:Object):void {
			hasProgress(null);
			LOG(5,'timed out error, p='+p,1);
			er(null);
		}
		
		
		private function removeListeners():void {
			contentLoaderInfo.removeEventListener(Event.COMPLETE,c);
			contentLoaderInfo.removeEventListener(Event.INIT,i);
			contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS,onLoadingProgress);
			contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, er);
			contentLoaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, er);
			onProgress = null;
		}
		
		
		public function get_path():String {return path;}
		private var path:String;
		private var onLoadError:Function;
		private var onLoadInit:Function;
		private var onLoadComplete:Function;
		private var onProgress:Function;
		private var timedoutTimer:Timer;
		public static function set_defaultTimeout(a:Number):void {defaultTimeout = a;}
		private static var defaultTimeout:Number=20000;
		
		
		// caching
		private static function loadB(path:String, instance:Im):void {
			// add to list
			if (path == null) {
				tr('Im>ERROR>path==null');
				if (instance && instance.onLoadError!=null) {instance.onLoadError();}
				return;
			}
			
			if (/*reqI.indexOf(instance)==-1 || */true || reqP.indexOf(path)==-1) {
				reqI.push(instance);
				path = preprocessPath(path);
				reqP.push(path);
			} else {
				tr('Im>NOT ADDED! >'+path);
			}
			
			loadTexture(path, instance);
		}
		
		private static function preprocessPath(p:String):String {
			//if (p && (p.indexOf('vkontakte.ru/images/question') != -1 || p.indexOf('vk.com/images/question') != -1)) {
				//p = SP.get_imageURL('images/question_c.gif');
			//}
			/*if (p.indexOf('?')!=-1) {
				p+='&rnd='+uint(1000*Math.random());
			} else {
				p+='?rnd='+uint(1000*Math.random());
			}*/
			return p;
		}
		
		private static function loadTexture(pt:String, i:Im):void {
			if (loadedPaths.indexOf(pt) != -1) {
				//in cache, loadbytes
				if (texturesToLoad.length < 1) {
					textureLoaded();
				}
			} else if (p!=pt && texturesToLoad.indexOf(pt)==-1) {//return to queue and load texture from server
				addTo_texturesToLoad(pt);
				loadNextTexture();
			}
		}
		
		private static function addTo_texturesToLoad(path:String):void {
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
		
		private static function removeFrom_texturesToLoad(path:String, error:Boolean=false):void {
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
		private static const lTryCount:Dictionary=new Dictionary();
		
		private static function textureLoaded():void {
			//tr('\ntextureLoaded()');
			if (lb_current) {
				//tr('lb_current');
				return;
			}
			// load next texture with path
			var rm:Array=[];
			var tl:Array=[];
			var i:String;
			
			for (i in reqP) {
				if (loadedPaths.indexOf(reqP[i])!=-1) {//found in cache
					//tr('Im>found for:'+reqP[i]);
					lb_current = reqI[i];
					lb(reqI[i], reqP[i]);
					//tr('Im>removing from list:'+reqP[i]);
					reqI.splice(i ,1);
					reqP.splice(i ,1);
					break;
				} else {//not found
					//tr('Im>NOT found for:'+reqP[i]);
					tl.push(i);
				}
			}
			
			//tr('Im> textures left to load>'+tl.length);
			for each(var ii:uint in tl) {
				loadTexture(reqP[ii], reqI[ii]);
			}
			
		}
		
		private static function loadNextTexture():void {
			if (loader_) {
				//tr('Im>busy....');
				return;
			}
			
			if (texturesToLoad.length < 1) {
				//tr('Im>nothing to load(texturesToLoad.length<1) reqP.l='+reqP.length+' reqP:['+reqP.join(' ,')+']');
				textureLoaded();
				return;
			}
			
			p = texturesToLoad.shift();
			
			if (p == null) {
				tr('Im>p==null');
				return;
			}
			
			//var context:LoaderContext = new LoaderContext(); 
			//context.securityDomain = SecurityDomain.currentDomain; 
			//context.applicationDomain = ApplicationDomain.currentDomain; 
			//var urlReq:URLRequest = new URLRequest("http://www.[your_domain_here].com/library.swf"); 
			//var ldr:Loader = new Loader(); 
			
			loader_ = new URLLoader();
			loader_.dataFormat = URLLoaderDataFormat.BINARY;
			
			loader_.addEventListener(Event.COMPLETE, l_complete);
			loader_.addEventListener(IOErrorEvent.IO_ERROR, l_err);
			loader_.addEventListener(SecurityErrorEvent.SECURITY_ERROR, l_err);
			loader_.addEventListener(HTTPStatusEvent.HTTP_STATUS, l_responce_status);
			
			tr('Im> >>> loading from:' + p);
			
			loader_.load(new URLRequest(p));
		}
		
		
		
		private static function l_err(e:Event):void {
			//LOG(4,'l_err',2);
			if (e!=null) {
				tr("Im>l_err>error loading: "+
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
			
			//add to end
			/*if (texturesToLoad.indexOf(p) == -1) { 
				addTo_texturesToLoad(p);
			}*/
			
			//tr('Im>IO_ERROR url:'+p, LOGGER.LEVEL_ERROR);
			
			removeFrom_texturesToLoad(p, true);
			
			loadNextTexture();
		}
		
		private static function l_responce_status(e:HTTPStatusEvent):void {
			//LOG(0,'l_responce_status>>>status='+e.status+'\nraw data:'+e.toString(), 1);
			if (e.status==304/* || e.status==200*/) {
				LOG(0,'STATUS 304, manually invoke complete()', 2);
				l_complete();
			}
		}
		
		private static function l_complete(e:Event = null):void {
			//LOG(4,'l_complete ^_^',1);
			if (!loader_) {return;}
			removeFrom_texturesToLoad(p, loader_.data==null);
			if (loader_.data==null) {
				loader_ = null;
				p = null;
				tr('Im>ERR:'+'loader_.data==null');
				
				loadNextTexture();
				return;
			}
			
			loadedBytes.push(loader_.data);
			loadedPaths.push(p);
			
			tr('Im> <<<<< loaded from url:'+p+' left:'+texturesToLoad.length);
			
			loader_ = null;
			p = null;
			
			textureLoaded();
			loadNextTexture();
		}
		
		private static function lb(instance:Im, path:String):void {
			tr('Im>load bytes url:'+path);//, ApplicationDomain.currentDomain
			var context:LoaderContext = new LoaderContext(false);
			
			instance.loadBytes(loadedBytes[loadedPaths.indexOf(path)], context);	
		}
		
		/**
		 * bytes load complete
		 */
		private static function slc():void {
			//load next from cache
			lb_current = null;
			textureLoaded();
		}
		private static var lb_current:Im;
		
		private static function tr(...args):void {
			//return;
			//trace.apply(null, args);
			LOG(5, 'Im trace>'+traceObject(args));
		}
		
		private static var p:String;
		private static var loader_:URLLoader;
		private static var texturesToLoad:Array=[];
		
		private static var reqP:Array = [];
		private static var reqI:Array = [];
		private static var loadedPaths:Array = [];
		private static var loadedBytes:Array=[];
		
		
	}
}

//{ =^_^= History
/* > (timestamp) [ ("+" (added) ) || ("-" (removed) ) || ("*" (modified) )] (text)
 */
//} =^_^= END OF History

// template last modified:03.05.2010_[22#42#27]_[1]