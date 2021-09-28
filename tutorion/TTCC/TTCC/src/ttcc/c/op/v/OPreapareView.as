// Project TTCC
package ttcc.c.op.v {
	
	//{ =*^_^*= import
	import com.alvasun.laf.custom_blue.CustomBluenessLAF;
	import flash.display.Bitmap;
	import org.aswing.AsWingManager;
	import org.aswing.UIManager;
	import org.jinanoimateydragoncat.utils.flow.operations.Operation;
	import ttcc.APP;
	import ttcc.Application;
	import ttcc.c.op.AO;
	import ttcc.cfg.AppCfg;
	import ttcc.lib.Library;
	import ttcc.media.PictureStoreroom;
	import ttcc.media.Text;
	import ttcc.v.chat.VCChat;
	import ttcc.v.cl.VCCourseLoader;
	import ttcc.v.mp.VCMainPanel;
	import ttcc.v.pl.VCPresentationLoader;
	import ttcc.v.VCMainScreen;
	//} =*^_^*= END OF import
	
	
	/**
	 * 
	 * @author Jinanoimatey Dragoncat
	 * @version 0.0.0
	 * @created 26.05.2012_02#54#22
	 */
	public class OPreapareView extends AO {
		
		//{ =*^_^*= CONSTRUCTOR
		
		function OPreapareView (onComplete:Function, applicationRef:Application) {
			super(null, NAME, onComplete);
			//set_warningResultCode(OPERATION_RESULT_CODE_FAILURE);	
			appRef=applicationRef;
		}
		//} =*^_^*= END OF CONSTRUCTOR
		
		protected override function start():void {
			//prepare builtin library
			PictureStoreroom.prepare();
			
			var scr:VCMainScreen = appRef.get_mainScreen();
			scr.get_componentsLayer().y=20+2;// TODO: position components layer under main panel
			AsWingManager.initAsStandard(scr.get_componentsLayer(), true);
			//switch skin
			UIManager.setLookAndFeel(new CustomBluenessLAF());
			// prepare main screen
			
			
/*			var cl:VCCourseLoader=new VCCourseLoader;
			cl.setResources(
				APP.lText().get_TEXT(Text.ID_TEXT_COURSE_LOADER_WINDOW_TITLE)
				,PictureStoreroom.getPicture('manage_h')
			);
			scr.set_cl(cl);
			
*/			
			end(AO.OPERATION_RESULT_CODE_SUCCESS);
		}
		
		private var appRef:Application;
		
		public static const NAME:String='OPreapareView';
		
	}
}

//{ =*^_^*= History
/* > (timestamp) [ ("+" (added) ) || ("-" (removed) ) || ("*" (modified) )] (text)
 * > 
 */
//} =*^_^*= END OF History

// template last modified:11.03.2011_[18#51#40]_[5]