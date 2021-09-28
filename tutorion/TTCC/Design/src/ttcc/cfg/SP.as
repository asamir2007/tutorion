// Project OilG
package ttcc.cfg {
	
	//{ =*^_^*= import
	//} =*^_^*= END OF import
	
	
	/**
	 * server protocol
	 * @author Jinanoimatey Dragoncat
	 * @version 0.0.0
	 * @created 25.05.2012 20:16
	 */
	public class SP {
		
		/**
		 * максимальное количество повторов при неудачной попытке запроса
		 */
		//public static const SERVER_SETTING_MAX_RETRY_COUNT:uint = 1;
		
		/**
		 * transmission protocol
		 */
		public static const TP:String = "http://";
		
		/**
		 * url server
		 */
		private static var US:String = '213.239.231.140/';
		public static function set_US(a:String):void {US = a+'/';}
		
		public static function get_AP():String {return AP;}
		public static function set_AP(a:String):void {AP = a;}
		/**
		 * application/api path
		 */
		private static var AP:String = "api/api.php";
		
		
		//{ =*^_^*= default paths
		/*public static function get_defPath_image0(relative:Boolean=true):String {
			var p:String='images/default.png';
			if (!relative) {return getRoot()+p;}
			return p;
		}*/
		//{ =*^_^*= END OF default paths
		
		
		/**
		 * "http://server.com/"
		 */
		private static function getRoot():String {
			return TP+US;
		};
		
		/**
		 * "http://server.com/api.php"
		 */
		public static function getApiUrl():String {
			return AP;
		};
		/**
		 * "http://server.com/"
		 */
		public static function getServerUrl():String {
			return TP+US;
		};
		
		/**
		 * @param n image name
		 *  getRoot()+n
		 * server/+n
		 */
		public static function get_imageURL(n:String):String {
			return getRoot()+n;
		}
		
		
		/**
		 * 
		 * @param	path without ext
		 * @return path.substr(path.lastIndexOf('/')+ 1)
		 */
		public static function getImageName(path:String):String {
			if (path.lastIndexOf('/')!=-1) {
				path = path.substr(path.lastIndexOf('/') + 1);
			}
			if (path.indexOf(".") != -1) {
				path = path.substring(0, path.indexOf("."));
			}
			return path;
		}
		
		//{ =*^_^*= =*^_^*= methods and arguments
		
		//{ =*^_^*= template
		/**
		 * METHOD_ARGUMENT_NAME0, METHOD_ARGUMENT_NAME1
		 */
		//public static const METHOD_NAME:String = 'method.name';
		//public static const METHOD_ARGUMENT_NAME0:String = 'argument';
		//public static const METHOD_ARGUMENT_NAME1:String = 'argument1';
		//} =*^_^*= END OF template
		
		/**
		 * out:[userID:String, propertyName:String, propertyValue:Object]
		 * in:nothing
		 */
		public static const METHOD_RTMP_SET_USER_DATA_PROPERTY:String = 'setUserAttrib';
		/**
		 * out:[messageText:String]
		 * in:nothing
		 */
		public static const METHOD_RTMP_CHAT_SEND_MSG:String = 'SendMsg';
		public static const METHOD_RTMP_AUDIO_VIDEO_RECORD_START:String = 'startCapture';
		public static const METHOD_RTMP_AUDIO_VIDEO_RECORD_END:String = 'stopCapture';
		/**
		 * out:[lastPacketIndex:int, lastPacketTm:int]
		 * in:nothing
		 */
		public static const METHOD_RTMP_PING:String = 'pingAndStats';
		/**
		 * out:[wbPageSN, imageURL]
		 * in:nothing
		 */
		public static const METHOD_RTMP_WHITEBOARD_ADD_PAGE_BG:String = 'AddBG2WB';
		/**
		 * out:[Object]
		 * in:nothing
		 */
		public static const METHOD_RTMP_WHITEBOARD_LOAD_WB_DATA:String = 'LoadWB';
		/**
		 * out:[wbPageSN]
		 * in:nothing
		 */
		public static const METHOD_RTMP_WHITEBOARD_SELECT_PAGE:String = 'SelectPgWB';
		
		public static const ID_METHOD_FILE_SERVER_ADD_REPLAY:String="add_replay";
		public static const ID_METHOD_FILE_SERVER_ADD_WB_DATA:String="add_tree_file";
		/**
		 * {node_typ:"course"}
		 */
		public static const ID_METHOD_FILE_SERVER_COURSE_LOADER_GET_TREE:String="get_tree";
		/**
		 * startup data(used if no demo present)
		 * out:{link:settingsXML}
		 * in:xml
		 */
		public static const ID_METHOD_HTTP_GET_APP_COMPONENTS_CFG_DATA:String='get_moddata';
		/**
		 * out:null
		 * in:xml
		 */
		public static const ID_METHOD_HTTP_GET_USER_DATA:String='get_userdata';
		/**
		 * send ping, fps and so on
		 * out:{userdata:"JSON data", item_id:int}
		 * in:"ok"
		 */
		public static const ID_METHOD_HTTP_SEND_STATS:String='swf_send_graph_data';
		
		//} =*^_^*= =*^_^*= END OF methods and arguments
		
		
		//{ =*^_^*= =*^_^*= server events
		/**
		 * 
		 */
		public static const ID_EVENT_UNKNOWN_EVENT:String="UNKNOWN SERVER EVENT";
		/**
		 * user(ANY) logged in 
		 */
		public static const ID_EVENT_USER_LOGIN:String="user_in";
		/**
		 * user(ANY) logged out
		 */
		public static const ID_EVENT_USER_LOGOUT:String="user_out";
		/**
		 * some user(ANY) data updated
		 */
		public static const ID_EVENT_USER_DATA_UPDATED:String="attrib_update";
		//} =*^_^*= =*^_^*= END OF server events
		
		//{ =*^_^*= =*^_^*= fms protocol settings
		public static const SHARED_OBJECT_NAME_USER_DATA_AND_EVENTS:String='usr_adm';
		public static const SHARED_OBJECT_NAME_CHAT:String='chat';
		public static const SHARED_OBJECT_NAME_WHITEBOARD:String='whiteboard';
		
		public static const SHARED_OBJECT_USER_PROPERTY_STREAM_ON:String='streamingUser';
		public static const SHARED_OBJECT_USER_PROPERTY_STREAM_NAME:String='streamName';
		public static const SHARED_OBJECT_USER_PROPERTY_SOUND_ON:String='streamMuted';
		public static const SHARED_OBJECT_USER_PROPERTY_CHAT_TYPING:String='chatTyping';
		public static const SHARED_OBJECT_USER_PROPERTY_HAND_UP:String='handUp';
		public static const SHARED_OBJECT_USER_PROPERTY_CHAT_BANNED:String='chatBan';
		//} =*^_^*= =*^_^*= END OF fms protocol settings
		
	}
}

//{ =*^_^*= History
/* > (timestamp) [ ("+" (added) ) || ("-" (removed) ) || ("*" (modified) )] (text)
 * > 
 */
//} =*^_^*= END OF History

// template last modified:11.03.2011_[18#51#40]_[5]