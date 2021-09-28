package org.jinanoimateydragoncat.works.cyber_modules.d {
	
	//{ =*^_^*= import
	//} =*^_^*= END OF import
	
	
	/**
	 * SerializableStateTransientModel
	 * @author Jinanoimatey Dragoncat
	 * @version 0.0.0
	 * @created 03.08.2012 17:11
	 */
	public class SSTM {
		
		//{ =*^_^*= CONSTRUCTOR
		function SSTM () {
		}
		public function construct(id:String):void {
			this.id=id;
		}
		public function destruct():void {
			// override and place your code here
			//super.destruct();
		}
		//} =*^_^*= END OF CONSTRUCTOR
		
		
		//{ =*^_^*= data port
		public function setUpdateReflexBlock(block:Boolean):void {locked=block;}
		
		public function receiveUpdate(elementID:uint, rawData:Object):void {
			deserializeAndStore(elementID, rawData);
			reflect(elementID, true);
		}
		/**
		 * @param	dataReceiver function(modelID:String, elementID:uint, rawData:Object):void {
		 */
		public final function set_rawDataReceiver(dataReceiver:Function):void {
			this.dataReceiver=dataReceiver;
		}
		private function transferUpdates(elementID:uint, rawData:Object):void {
			if (dataReceiver==null) {return;}
			dataReceiver(id, elementID, rawData);
		}
		private var dataReceiver:Function;
		//} =*^_^*= END OF data port
		
		//{ =*^_^*= reflection
		public function reflectAll():void {
			if (locked) {return;}
			for (var i:Object in pIsChangedReflect) {
				reflectUpdates(pIsChangedReflect[i], pIsChangedReflectDP[i]);
			}
			pIsChangedReflect=[];
			pIsChangedReflectDP=[];
		}
		/**
		 * includes markForReflect()
		 */
		protected final function reflect(elementID:uint, updateFromDataport:Boolean=false):void {
			markForReflect(elementID, updateFromDataport);
			if (locked) {return;}
			reflectUpdates(elementID, updateFromDataport);
		}
		/**
		 * @param	listener function (targetModel:SSTM, elementID:uint, updateFromDataport:Boolean=false):void;
		 */
		public final function setViewUpdatesListener(listener:Function):void {
			el_view=listener;
		}
		private var el_view:Function;
		//} =*^_^*= END OF reflection
		
		//{ =*^_^*= transfer
		protected final function transfer(elementID:uint):void {
			transferUpdates(elementID, serialize(elementID));
		}
		//} =*^_^*= END OF transfer
		
		
		//{ =*^_^*= control
		private function reflectUpdates(elementID:uint, updateFromDataport:Boolean=false):void {
			el_view(this, elementID, updateFromDataport);
		}
		public final function reset(updateFromDataport:Boolean=false):void {
			pIsChangedReflect=[];
			pIsChangedReflectDP=[];
			//pIsChangedTransfer=[];
			resetModel();
			el_view(this, ID_P_A_RESET_MODEL, updateFromDataport);
		}
		protected function resetModel(updateFromDataport:Boolean=false):void {
			// override and place your code here
		}
		//} =*^_^*= END OF control
		
		//{ =*^_^*= working with data
		/**
		 * override and place your code here
		 * @param	elementID
		 * @return rawData
		 */
		protected function serialize(elementID:uint):Object {
			// override and place your code here
			return null;
		}
		/**
		 * 
		 * @param	elementID
		 * @param	rawData
		 */
		protected function deserializeAndStore(elementID:uint, rawData:Object):void {
			// override and place your code here
		}
		//} =*^_^*= END OF working with data
		
		
		//{ =*^_^*= for internal usage
		/*protected final function markForTransfer(propertyID:uint):void {
			if (pIsChangedTransfer.indexOf(propertyID)!=-1) {return;}
			pIsChangedTransfer.push(propertyID);
		}
		private var pIsChangedTransfer:Array=[];
		*/
		protected final function markForReflect(propertyID:uint, updateFromDataport:Boolean=false):void {
			if (pIsChangedReflect.indexOf(propertyID)!=-1) {return;}
			pIsChangedReflect.push(propertyID);
			pIsChangedReflectDP[pIsChangedReflect.indexOf(propertyID)]=updateFromDataport;
		}
		private var pIsChangedReflect:Array=[];
		private var pIsChangedReflectDP:Array=[];
		
		protected final function isLocked():Boolean {return locked;}
		//} =*^_^*= END OF for internal usage
		
		private var locked:Boolean=false;
		public function get_id():String {return id;}
		private var id:String;
		
		public static const ID_P_A_RESET_MODEL:uint=999999999;
	}
}

//{ =*^_^*= History
/* > (timestamp) [ ("+" (added) ) || ("-" (removed) ) || ("*" (modified) )] (text)
 * > 
 */
//} =*^_^*= END OF History

// template last modified:11.03.2011_[18#51#40]_[5]