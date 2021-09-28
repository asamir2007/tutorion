// Project TTCC
package ttcc.d.s {
	import ttcc.d.i.ISerializable;
	
	//{ =*^_^*= import
	//} =*^_^*= END OF import
	
	
	/**
	 * 
	 * @author Jinanoimatey Dragoncat
	 * @version 0.0.0
	 * @created 08.08.2012 12:41
	 */
	public class UpdateDataEvent implements ISerializable {
		
		//{ =*^_^*= CONSTRUCTOR
		public function construct(rawData:Object, sn:Number, timeStamp:Number, ownerID:String, propertyID:uint):void {
			this.rawData = rawData;
			this.sn = sn;
			this.timeStamp = timeStamp;
			this.ownerID = ownerID;
			this.propertyID = propertyID;
		}
		public function destruct():void {
		}
		//} =*^_^*= END OF CONSTRUCTOR
		
		public function get_rawData():Object {return rawData;}
		public function set_rawData(a:Object):void {rawData = a;}
		public function get_sn():Number {return sn;}
		public function set_sn(a:Number):void {sn = a;}
		public function get_timestamp():Number {return timeStamp;}
		public function set_timeStamp(a:Number):void {timeStamp = a;}
		public function get_ownerID():String {return ownerID;}
		public function set_ownerID(a:String):void {ownerID = a;}
		public function get_propertyID():uint {return propertyID;}
		public function set_propertyID(a:uint):void {propertyID = a;}
		//public function get_markerType():uint {return markerType;}
		//public function set_markerType(a:uint):void {markerType = a;}
		
		private var rawData:Object;
		private var sn:Number;
		private var timeStamp:Number;
		private var ownerID:String;
		private var propertyID:uint;
		//private var markerType:uint=0;
		
		//public static const ID_TYPE_MARKER_NONE:uint=0;
		//public static const ID_TYPE_MARKER_START:uint=1;
		//public static const ID_TYPE_MARKER_END:uint=2;
		
		public function toObject():Object {
			return {r:rawData, sn:sn, ts:timeStamp, oi:ownerID, pi:propertyID};
		}
		public static function fromObject (o:Object):UpdateDataEvent {
			var a:UpdateDataEvent=new UpdateDataEvent;
			a.construct(o.r, o.sn, o.ts, o.oi, o.pi);
			return a;
		}

	}
}

//{ =*^_^*= History
/* > (timestamp) [ ("+" (added) ) || ("-" (removed) ) || ("*" (modified) )] (text)
 * > 
 */
//} =*^_^*= END OF History

// template last modified:11.03.2011_[18#51#40]_[5]