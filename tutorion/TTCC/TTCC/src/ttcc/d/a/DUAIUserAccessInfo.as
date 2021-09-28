package ttcc.d.a {
	
	//{ =*^_^*= import
	import ttcc.d.DUAI;
	//} =*^_^*= END OF import
	
	
	/**
	 * describes how cpecific user can acces UserDataUnit
	 * details: contains list of access rights. Each right corresponds to each user data unit  object's property 
	 * @author Jinanoimatey Dragoncat
	 * @version 0.0.0
	 * @created 22.05.2012 19:42
	 */
	public class DUAIUserAccessInfo extends DUAI {
		
		//{ =*^_^*= id
		/**
		 * read
		 */
		public static const ID_A_R__STREAMING_ON:uint=nextID;
		/**
		 * read
		 */
		public static const ID_A_R__STREAM_SOUND_ON:uint=nextID;
		/**
		 * read
		 */
		public static const ID_A_R__STREAMNAME:uint=nextID;
		/**
		 * read
		 */
		public static const ID_A_R__CHAT_TYPING:uint=nextID;
		/**
		 * read
		 */
		public static const ID_A_R__HAND_UP:uint=nextID;
		public static const ID_A_R__CHAT_BAN:uint=nextID;
		
		
		
		/**
		 * write
		 */
		public static const ID_A_W__STREAMING_ON:uint=nextID;
		/**
		 * write
		 */
		public static const ID_A_W__STREAM_SOUND_ON:uint=nextID;
		/**
		 * write
		 */
		public static const ID_A_W__STREAMNAME:uint=nextID;
		/**
		 * write
		 */
		public static const ID_A_W__CHAT_TYPING:uint=nextID;
		/**
		 * write
		 */
		public static const ID_A_W__HAND_UP:uint=nextID;
		/**
		 * write
		 */
		public static const ID_A_W__CHAT_BAN:uint=nextID;
		//} =*^_^*= END OF id
		
		public static function get nextID():uint {lastID+=1;return lastID;}
		private static var lastID:uint=0;
		
	}
}

//{ =*^_^*= History
/* > (timestamp) [ ("+" (added) ) || ("-" (removed) ) || ("*" (modified) )] (text)
 * > 
 */
//} =*^_^*= END OF History

// template last modified:11.03.2011_[18#51#40]_[5]