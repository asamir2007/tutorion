package ttcc.d {
	
	//{ =*^_^*= import
	//} =*^_^*= END OF import
	
	
	/**
	 * DataUnitAccessor
	 * serves as proxy between data and "user". Firstly user provides its DUAI(permissions), than tries to perform read or write operations on the data segment through DataUnitAccessor. DataUnitAccessor checks whether pending data access operation violates data access rools described in DUAI. Depending on check result, dispatches "access denied" or accesses data unit and than dispatches "write data" or "read data" event(depending on access type).
	 * This class is not intended for direct use - subclass it instead
	 * @author Jinanoimatey Dragoncat
	 * @version 0.0.0
	 * @created 22.05.2012 19:09
	 */
	public class DUA {
		
		//{ =*^_^*= CONSTRUCTOR		
		/**
		 * @param eventListener function(target:DUA, eventType:uint, eventData:Object):void
		 * @param	password password for direct data unit access(feature employed against noob class users attempting access data directly(thus not reading class's description or not understanding its purpose))
		 * @param	target target DataUnit being accessed through DUA
		 */
		public function construct(eventListener:Function,  target:ADU/*, password:String=null*/):void {
			//p=password;
			//if (target) {set_target(password, target);}
			t_=target;
			el=eventListener;
		}
		public function destruct():void {
			throw new ArgumentError('not implemented yet');
		}
		//} =*^_^*= END OF CONSTRUCTOR
		
		
		/**
		 * check permission to perform action with id, and execute it no access violation attempt detected
		 * @param	a DUAI
		 * @param	id data segment id
		 * @return can proceed
		 */
		public function cpex(a:DUAI, id:uint):Boolean {
			switch (a.gp(id)) {
				
			case DUAI.ID_ACCESS_ALLOW_AND_LOG:
				el(this, ID_E_ACCESS_GRANTED, {i:a, t:t_, a:id});
			case DUAI.ID_ACCESS_ALLOW:
				return true;
				
			case DUAI.ID_ACCESS_DISALLOW_AND_LOG:
				// dispatch "access denied" event
				el(this, ID_E_ACCESS_DENIED, {i:a, t:t_, a:id});
			case DUAI.ID_ACCESS_DISALLOW:
				return false;
				
			}
			return false;
		}
		
		
		/**
		 * check permission to perform action with id
		 * @param	a DUAI
		 * @param	id action id
		 * @return can proceed
		 * @example if (!cp(AI, action_id)) {return;} ...
		 */
		protected function cp(a:DUAI, id:uint):Boolean {
			switch (a.gp(id)) {
			
			case DUAI.ID_ACCESS_ALLOW_AND_LOG:
			case DUAI.ID_ACCESS_ALLOW:
				return true;
				
			case DUAI.ID_ACCESS_DISALLOW_AND_LOG:
				// dispatch "access denied" event
				el(this, ID_E_ACCESS_DENIED, {i:a, t:t_, a:id});
			case DUAI.ID_ACCESS_DISALLOW:
				return false;
			
			}
			return false;
		}
		
		/**
		 * notify listeners if need to, according by DUAI
		 * @param	a DUAI
		 * @param	id action id
		 */
		protected function ex(a:DUAI, id:uint):void {
			if (a.gp(id)==DUAI.ID_ACCESS_ALLOW_AND_LOG) {
				// dispatch "accessed" event
				el(this, ID_E_ACCESS_GRANTED, {i:a, t:t_, a:id});
			}
		}
		
		
		/*public function get_target(password:String):ADU {
			if (password!=p) {throw new ArgumentError('wrong password');}
			return t_;
		}*/
		/*public function set_target(password:String, a:ADU):void {
			if (password!=p) {throw new ArgumentError('wrong password');}
			t_ = a;
		}*/
		
		//{ =*^_^*= id
		/**
		 * data:{i:DUAI, t:ADU, a:uint//actionID//}
		 */
		public static const ID_E_ACCESS_GRANTED:uint=0;
		/**
		 * data:{i:DUAI, t:ADU, a:uint//actionID//}
		 */
		public static const ID_E_ACCESS_DENIED:uint=1;
		//} =*^_^*= END OF id
		
		//{ =*^_^*= events
		//public function setListener(a:Function):void {el=a;}
		private var el:Function;
		//} =*^_^*= END OF events
		
		
		/**
		 * target
		 */
		protected final function t():ADU {return t_;}
		private var t_:ADU;
		private var p:String;
		
	}
}

//{ =*^_^*= History
/* > (timestamp) [ ("+" (added) ) || ("-" (removed) ) || ("*" (modified) )] (text)
 * > 
 */
//} =*^_^*= END OF History

// template last modified:11.03.2011_[18#51#40]_[5]