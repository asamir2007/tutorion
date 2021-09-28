package ttcc.c.ma.pen
{
import flash.events.Event;
import flash.utils.ByteArray;

/* Event type, dispatched by PenSocketHandler */
public class SafeSocketEvent extends Event		
	{
	/** events: **/
	public static const CONNECT:String = "connect";					// socket connected
	public static const DISCONNECT:String = "disconnect";			// socket disconnected
	public static const ERROR:String = "proto_error";				// protocol error detected
	public static const NO_SERVER:String = "no_server";				// socket server not found
	public static const DATA_RCV:String = "data_rcv";				// data packet is successfully received
	public static const DATA_SENT:String = "data_sent";				// data packet is successfully sent
	
	public static const CODE_BIN_DATA:int=0x10;						// have binary data
	public static const CODE_STR_DATA:int=0x20;						// have string data
	
	public var data:ByteArray=null;									// binary data
	public var str:String=null;										// string data
	public var code:int=0;
	
	public function SafeSocketEvent(type:String, code:int=0, data:*=null)
		{
		super(type);
		this.code=code;
		if(!data)return;
		if(code&CODE_STR_DATA)
			this.data=data as ByteArray;
		else if(code&CODE_BIN_DATA)
			this.str=data as String;
		}
	
	override public function clone():Event
		{
		var e:SafeSocketEvent=new SafeSocketEvent(type,code);
		e.data=data;
		e.str=str;
		return e;
		}

	}
}