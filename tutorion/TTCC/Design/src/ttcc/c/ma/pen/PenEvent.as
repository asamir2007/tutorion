package ttcc.c.ma.pen
{
import flash.events.Event;

/* Event type, dispatched by PenSocketHandler */
public class PenEvent extends Event		
	{
	/** events: **/
	public static const PEN_CONNECT:String = "pen_connect";					// pen device connected
	public static const PEN_DISCONNECT:String = "pen_disconnect";			// pen device disconnected
	public static const PEN_ERROR:String = "pen_error";						// client-server protocol error detected
	public static const PEN_NO_SERVER:String = "pen_no_server";				// socket server not found
	public static const PEN_SERVER_CONNECT:String = "pen_server_connect";		// socket server connected
	public static const PEN_SERVER_DISCONNECT:String = "pen_server_disconnect";		// socket server disconnected
	public static const PEN_DATA:String = "pen_data";						// data from pen is ready
//	public static const PEN_SERVER_ANSWER:String = "pen_server_answer";		// low level: answer from server
	
	public function PenEvent(type:String)
		{
		super(type);
		}

	}
}