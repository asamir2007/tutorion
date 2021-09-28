// Project TTCC
package ttcc.d.m {
	
	//{ =*^_^*= import
	import ttcc.Application;
	import ttcc.d.i.ISerializable;
	import ttcc.d.m.AbstractModel;
	import ttcc.LOG;
	//} =*^_^*= END OF import
	
	
	/**
	 * 
	 * @author Jinanoimatey Dragoncat
	 * @version 0.0.0
	 * @created 27.10.2012 0:16
	 */
	public class MPComModel extends AbstractModel {
		
		//{ =*^_^*= CONSTRUCTOR
		function MPComModel (a:Application) {
			this.a=a;
		}
		public override function destruct():void {
			super.destruct();
		}
		//} =*^_^*= END OF CONSTRUCTOR
		
		//{ =*^_^*= write access
		public function set_state_handUp(a:Boolean):void {
			state_handUp=a;
			transfer(STATE_HAND_UP);reflect(STATE_HAND_UP);
		}
		
		
		//{ =*^_^*= read access
		public function get_state_handUp():Boolean {return state_handUp;}
		//} =*^_^*= END OF read access
		
		//{ =*^_^*= model content
		private var state_handUp:Boolean;
		//} =*^_^*= END OF model content
		
		//{ =*^_^*= reflection
		protected override function resetModel(updateFromDataport:Boolean=false):void {
		}
		//} =*^_^*= END OF reflection
		
		//{ =*^_^*= private 
		private var a:Application;
		//} =*^_^*= END OF private
		
		//{ =*^_^*= property id
		public static const STATE_HAND_UP:uint=0;
		//} =*^_^*= END OF property id
		
		//{ =*^_^*= working with data
		/**
		 * override and place your code here
		 * @param	elementID
		 * @return rawData
		 */
		protected override function serialize(elementID:uint):Object {
			switch (elementID) {
			
			case STATE_HAND_UP:return int(state_handUp);
			
			}
			return null;
		}
		
		/**
		 * 
		 * @param	elementID
		 * @param	rawData
		 */
		protected override function deserializeAndStore(elementID:uint, rawData:Object):void {
			switch (elementID) {
			
			case STATE_HAND_UP:state_handUp=Boolean(rawData);break;
			
			}
		}
		//} =*^_^*= END OF working with data
		
		
	}
}

//{ =*^_^*= History
/* > (timestamp) [ ("+" (added) ) || ("-" (removed) ) || ("*" (modified) )] (text)
 * > 
 */
//} =*^_^*= END OF History

// template last modified:11.03.2011_[18#51#40]_[5]