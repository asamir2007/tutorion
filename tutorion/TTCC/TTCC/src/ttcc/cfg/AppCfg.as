// Project TTCC
package ttcc.cfg {

	//{ =*^_^*= import
	//} =*^_^*= END OF import
	
	
	/**
	 * application configuration
	 * @author Jinanoimatey Dragoncat
	 * @version 0.0.0
	 * @created 26.05.2012_02#54#22
	 */
	public class AppCfg {
		
		public static const developmentWithReleaseServer:Boolean=Boolean(0);
		
		//{ =*^_^*= CONSTRUCTOR
		
		public static var offlineMode:Boolean=Boolean(1);
		
		public static var appScreenW:uint = 800;
		public static var appScreenH:uint = 600;
		
		// TODO: move to style
		public static const CHAT_CL_CONTACT_AVATAR_W:uint=20;
		// TODO: move to style
		public static const CHAT_CL_CONTACT_AVATAR_H:uint=20;
		// TODO: move to style
		public static const MAIN_PANEL_CL_CONTACT_AVATAR_W:uint=20;
		// TODO: move to style
		public static const MAIN_PANEL_CL_CONTACT_AVATAR_H:uint=30;
		// TODO: move to style
		public static const MAIN_PANEL_CL_CONTACT_STATE_ICON_W:uint=10;
		// TODO: move to style
		public static const MAIN_PANEL_CL_CONTACT_STATE_ICON_H:uint=10;
		
		// TODO: move to style
		/**
		 * stream avatar viewport width
		 */
		public static const AV_SL_STREAM_VP_W:uint=50;
		// TODO: move to style
		public static const AV_SL_STREAM_VP_H:uint=50;
		public static const AV_VIDEO_DEFAULT_W:int=320/2;
		public static const AV_VIDEO_DEFAULT_H:int=240/2;
		
		
		// TODO: move to style
		public static const AV_SL_CONTACT_VP_W:uint=50;
		// TODO: move to style
		public static const AV_SL_CONTACT_VP_H:uint=50;
		// TODO: move to style
		public static const STYLE_CHAT_OUTGOING_MSG_TEXT_COLOR:String='00ff00';
		// TODO: move to style
		public static const STYLE_CHAT_INCOMING_MSG_TEXT_COLOR:String='0000ff';
		public static const STYLE_CHAT_CLIENT_MSG_TEXT_COLOR:String='000000';
		
		public static const NET_FMS_CONNECTION_TIMEOUT:int=7000;
		public static const DOCUMENT_LOADER_MAX_FILESIZE:Number=1024*1024*5;
		
		
	}
}

//{ =*^_^*= History
/* > (timestamp) [ ("+" (added) ) || ("-" (removed) ) || ("*" (modified) )] (text)
 * > 
 */
//} =*^_^*= END OF History

// template last modified:11.03.2011_[18#51#40]_[5]