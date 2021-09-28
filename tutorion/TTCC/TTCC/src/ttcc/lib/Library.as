// Project TTCC
package ttcc.lib {
	
	//{ =*^_^*= imports
	import flash.display.BitmapData;
	import flash.utils.ByteArray;
	//} =*^_^*= END OF import
	
	
	/**
	 * Library contains image BitmapData available through public static properties. Call "initializeLibrary" static method before using Library.
	 * @author Jinanoimatey Dragoncat
	 * @version 0.0.0
	 * @created 26.05.2012_02#54#22
	 */
	public class Library {
		
		private static const usingLibProcessor:Boolean=false;
		
		//{ =*^_^*= EMBED AND PREPARE
		
		//{ =*^_^*= =*^_^*= templates
		
		//embedding font notice: use additional parameters when encountering errors 
		// fontWeight="bold", fontStyle="italic",
		
		//[Embed(source="../../../res/images/swf.swf",mimeType="application/octet-stream")]
		//public static const swf:Class;
		
		//[Embed(source="../../../res/images/image0.jpg")]private static const image0_jpg:Class;
		//public static var image0:BitmapData;
		
		//[Embed(source="../../../res/swfLibs/library.swf", symbol="symbol0")]
		//public static const symbol0:Class;
		
		//[Embed(source="../../../res/sounds/sound0.mp3")]
		//public static const sound0:Class;
		
		//[Embed(source='../../../res/fonts/FONT.ttf', fontName="Font", mimeType="application/x-font-truetype")]
		//public static const font0:String;
		
		//[Embed(systemFont='Verdana', fontName="Verdana", mimeType="application/x-font-truetype")] 
		//public static const font_verdana:String; 
		
		//} =*^_^*= =*^_^*= END OF templates
		
		[Embed(source="../../../build.txt",mimeType="application/octet-stream")]
		private static const build_txt:Class;
		public static var build:String;
		
		// default picture, do not remove
		[Embed(source="../../../res/images/im0.PNG")]public static const im0_PNG:Class;
		public static var im0:BitmapData;
		
// 
/*		[Embed(source="../../../res/images/flashIcons/tut/headers/_h.png")]private static const r_wi_:Class;
		public static var wi_:BitmapData;
		
		[Embed(source="../../../res/images/flashIcons/tut/menu/menu_white/_w.png")]private static const r_up_:Class;
		public static var up_:BitmapData;
		
*/		

		//[Embed(source="../../../res/images/flashIcons/")]private static const :Class;
		//public static var :BitmapData;
		
		
		//} =*^_^*= END OF EMBED AND PREPARE
		
		
		//{ =*^_^*= CONSTRUCTOR
		function Library () {throw(new ArgumentError('Library contains images that available through public static properties. Invoke "initialize" static method before using Library.'));}
		//} =*^_^*= END OF CONSTRUCTOR
		
		
		
		
		/**
		 * prepare library for using
		 */
		public static function initialize(completeRef:Function=null):void{
			completeRef_ = completeRef;
			parseBuildNum();
			
			createBitmaps();
		}
		private static function initialized():void {
			if (completeRef_ != null) {completeRef_();}
		}
		
		private static function parseBuildNum():void {
			var buildFile:ByteArray = ByteArray(new build_txt());
			build = buildFile.readUTFBytes(buildFile.length);
		}
		
		
		private static function createBitmaps():void {
			//image0 = new image0_jpg().bitmapData;
			im0 = new im0_PNG().bitmapData;			
			
			if (!usingLibProcessor) {
				initialized();
				return;
			}
			
			
			new LibProcessor(
				[
					//new lib_swf()
				]
				,[
					// ======== lib_swf ========
					[
					"Symbol0"
					//,"Symbol1"
					]
				]
				,function (a:LibProcessor):void {
					// assign
					var d:Array;
					
					// ======== lib_swf ========
					d = a.get_definitions().shift();
					
					//Symbol0 = d.shift();
					//Symbol1 = d.shift();
					
					// end
					initialized();
				}
			);
			
		}
		
		private static var completeRef_:Function;
		
	}
}


import flash.display.DisplayObject;
import flash.display.Loader;
import flash.display.Sprite;
import flash.events.Event;
import flash.system.ApplicationDomain;
import flash.system.LoaderContext;
import flash.utils.ByteArray;

/**
 * attention: no error or exception wrapping(!) pay attention to input.
 * @author Jinanoimatey Dragoncat
 * @version 0.0.0
 */
class LibProcessor {
	
	/**
	 * @param	definitionNames[[String, ...], ...]
	 * @param	libData [ByteArray, ...]
	 * @param	callback (this):void
	 * @param	name
	 */
	public function LibProcessor(libData:Array, definitionNames:Array, callback:Function, name:String=null):void {
		this.definitionNames = definitionNames;
		this.libData = libData;
		this.name = name;
		this.callback = callback;
		
		process_swf();
	}
	
	private function process_swf():void {
		if (libData.length<1) {
			callback(this);
		} else {
			currentLibData = libData.shift();
			currentLibNames = definitionNames.shift();
			loader0 = new Loader();
			loader0.loadBytes(currentLibData, new LoaderContext(false, ApplicationDomain.currentDomain));
			loader0.contentLoaderInfo.addEventListener(Event.COMPLETE, l0);
		}
	}
	
	private function l0 (e:Event):void {
		var d:Array = [];
		for each(var i:String in currentLibNames) {
			d.push(e.target.content.loaderInfo.applicationDomain.getDefinition(i));
		}
		definitions.push(d);
		
		process_swf();
	}
		
	private var loader0:Loader;
		
	/**
	 * [[Class, ...], ...]
	 */
	public function get_definitions():Array {return definitions;}
	
	private var definitions:Array = [];
	private var libData:Array;
	private var currentLibNames:Array;
	private var currentLibData:ByteArray;
	private var name:String;
	private var callback:Function;
	private var definitionNames:Array;
}


//{ =*^_^*= History
/* > (timestamp) [ ("+" (added) ) || ("-" (removed) ) || ("*" (modified) )] (text)
 * > 
 */
//} =*^_^*= END OF History

// template last modified:11.03.2011_[18#55#10]_[5]]