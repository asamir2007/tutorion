package ttcc.c.ma.pen
{
//import MyClasses.SafeSocketClient;
//import MyEvents.PenEvent;
//import MyEvents.SafeSocketEvent;

import flash.errors.EOFError;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.IOErrorEvent;
import flash.events.ProgressEvent;
import flash.events.SecurityErrorEvent;
import flash.events.SyncEvent;
import flash.events.TimerEvent;
import flash.net.Socket;
import flash.system.Security;
import flash.utils.ByteArray;
import flash.utils.Endian;
import flash.utils.Timer;

import mx.core.ByteArrayAsset;

import ttcc.LOG;
import ttcc.v.wb.v.DrawingObjectRealPen;

//import pf_mod.Whiteboard;
//import pf_mod.wb_components.items.MyWB_Line;

/**
 * PenSocketHelper -- methods, events for communicate with pen
 **/

public class PenSocketHelper
	{
	static public var SOCKET_ADDR:String="localhost";//"lh_win";
	static public var SOCKET_PORT:int=1843;//843;
	static public var POLICY_RQ_ADDR:String="xmlsocket://localhost:1843";//"xmlsocket://lh_win:843";
	static public const SRV_ANSW_OK:String="OK";		
	static public const AUTH_STR:String="PenClient1.0";		// auth request
	static public const CMD_RESET:String="RESET_RQ";		// reset pen data
	static public const CMD_DATA_RQ:String="DATA_RQ";		// get pen data
	
	static public const PEN_UP:int=3;
	static public const PEN_DOWN:int=1;
	static public const PEN_MOVE:int=2;
	static public const PEN_CONNECTED:int=0x12;
	static public const PEN_DISCONNECTED:int=0x13;
	
	static public const ST_CONNECTING:int=0x1;		
	static public const ST_CONNECTED:int=0x2;
	static public const ST_AUTH_CHECKING:int=0x4;		// auth info is sent. waiting for answer 
	static public const ST_AUTH_CHECKED:int=0x8;		// auth procedure success
	static public const ST_CMD_EXECUTING:int=0x10;		// we are waiting for answer now
	static public const ST_ANSWER_READY:int=0x20;		// have just got answer
	static public const ST_NO_SERVER:int=0x100;				// socket not responded
	static public const ST_SERVER_DISCONNECTED:int=0x200;	// socket disconnected
	static public const ST_PEN_DISCONNECTED:int=0x400;		// pen disconnected
	static public const ST_PEN_ERR:int=0x800;				// error in communication
	
	static public var ed:EventDispatcher=new EventDispatcher();
	static public var st:int=0;
	static public var ready:Boolean=false;				// is data ready?
	static private var s:SafeSocketClient;
	static private var lastCommand:String="";
	static private var lastAnswer:String="";
	
	static public var WB_xres:int=1024;
	static public var WB_yres:int=768;
	static public var calibrW:int=15000;		// A4 width in pen units
	static public var calibrH:int=11000;		// A4 height in pen units
//	static private var data:ByteArray=new ByteArray();
//	static private var ln:MyWB_Line=new MyWB_Line();
//	static private var ln:PenLine=new PenLine();
	static private var ln:DrawingObjectRealPen=new DrawingObjectRealPen(null);
	static private var lnUp:Boolean=true;

	public function PenSocketHelper(){}
	
	/**
	 * 	connect() -- init, connect to socket and start work
	 **/
	static public function connect():void
		{
		LOG(5,"PenSocketHelper::connect()");
		st=ST_CONNECTING;
		Security.loadPolicyFile(POLICY_RQ_ADDR);
		s=new SafeSocketClient("pen");
		s.ed.addEventListener(SafeSocketEvent.CONNECT,socketEventsHandler);
		s.ed.addEventListener(SafeSocketEvent.DISCONNECT,socketEventsHandler);
		s.ed.addEventListener(SafeSocketEvent.NO_SERVER,socketEventsHandler);
		s.ed.addEventListener(SafeSocketEvent.ERROR,socketEventsHandler);
		s.ed.addEventListener(SafeSocketEvent.DATA_RCV,socketEventsHandler);
		s.ed.addEventListener(SafeSocketEvent.DATA_SENT,socketEventsHandler);
		s.connect(SOCKET_ADDR,SOCKET_PORT);
		}
	
	/**
	 * 	disconnect() -- stop work, close connection, and deinit all 
	 **/
	static public function disconnect(dispatch:Boolean=true):void
		{
		LOG(5,"PenSocketHelper::disconnect()");
		if(s){
			s.ed.removeEventListener(SafeSocketEvent.CONNECT,socketEventsHandler);
			s.ed.removeEventListener(SafeSocketEvent.DISCONNECT,socketEventsHandler);
			s.ed.removeEventListener(SafeSocketEvent.NO_SERVER,socketEventsHandler);
			s.ed.removeEventListener(SafeSocketEvent.ERROR,socketEventsHandler);
			s.ed.removeEventListener(SafeSocketEvent.DATA_RCV,socketEventsHandler);
			s.ed.removeEventListener(SafeSocketEvent.DATA_SENT,socketEventsHandler);
			if(dispatch)
				ed.dispatchEvent(new PenEvent(PenEvent.PEN_SERVER_DISCONNECT));
			s.disconnect();
			s=null;
			}
		st=ST_SERVER_DISCONNECTED;
		}

	/**
	 * 	penErr(s) -- pen error processing -- total deinit and dispatch event
	 **/
	static public function penErr(s:String):void
		{
		disconnect(false);			// dont dispatch DISC after ERR
		ed.dispatchEvent(new PenEvent(PenEvent.PEN_ERROR));
		st|=ST_PEN_ERR;
		err("penErr(): "+s);
		}
	
	/**
	 * 	sendCommand(s) -- send null-terminated string to socket
	 **/
	static private function sendCommand(str:String):void
		{
		try
			{
			LOG(5,"PenSocketHelper::sendCommand(): "+str,0);
			if(!(st&ST_CONNECTED))throw("Not connected!");
			if(st&ST_CMD_EXECUTING)throw("Command ("+lastCommand+") is in progress !!!");
			lastCommand=str;
			st|=ST_CMD_EXECUTING;
			var b:ByteArray=new ByteArray();
			b.endian=Endian.LITTLE_ENDIAN;
			b.writeUTF(str);
			s.sendPacket(b, SafeSocketClient.PACKET_DATA_STR);
			}
		catch(s:String)
			{
			penErr(s);
			}
		}

	/**
	 * 	readAnswerStr() -- read answer string from socket
	 **/
	static private function readAnswerStr():void
		{
		LOG(5,"PenSocketHelper::readAnswerStr(): ",0);
		if(!(st&ST_CONNECTED))throw("Not connected!");
		if(!(st&ST_CMD_EXECUTING))throw("No command in progress !!!");
		var str:String;
		var b:ByteArray=new ByteArray();
		b.endian=Endian.LITTLE_ENDIAN;
		try
			{
			s.rcvPacket(b);
			str=b.readUTF();
			lastAnswer=str;
			LOG(5,"    answ="+str,0);
			st&=~ST_CMD_EXECUTING;
			st|=ST_ANSWER_READY;
			}
//		ed.dispatchEvent(new PenEvent(PenEvent.PEN_SERVER_ANSWER));
		catch(e:EOFError)			// wrong msg format is detected!
			{
			throw("readAnswerStr(): EOF error in readUTF()");
			}
		}
	
	/**
	 * 	readData() -- read answer string from socket
	 **/
	static private function readData():void
		{
		try
			{
			var s:ByteArray=new ByteArray();
			s.endian=Endian.LITTLE_ENDIAN;
			PenSocketHelper.s.rcvPacket(s);
			s.readUTF();					// OK
			var n:int=s.readShort();		// number of data items
			var nn:int=s.readShort();		// head (prt to data in server buffer)
			LOG(5,"PenSocketHelper::readData(): n="+n+" head="+nn);
			//var b:ByteArray=new ByteArray();
			//b.length=n*6;
			//s.readBytes(b,0,n*6);
			for(var i:int=0;i<n;i++)	// convert all data to 
				{
				var x0:int=x;
				var y0:int=y;
				var e:int=s.readShort();
				var x:int=s.readShort(); 
				var y:int=s.readShort(); 
//				continue;
				LOG(5,"    x="+x.toString(16)+" y="+y.toString(16)+" e="+e.toString(16), 0);
				x=x*WB_xres/calibrW+WB_xres/2;
				y=y*WB_yres/calibrH;
				switch(e)
					{
					case PEN_DOWN:	// pen down
						LOG(5,"    PEN_DOWN");
						lnUp=false;
						if(!ln.npoints)				// empty line?
							ln.start(x,y);		// init
						else 
							ln.addGap(x,y);			// add gap
						break;
					case PEN_UP:	// pen up
						LOG(5,"    PEN_UP");
//						if(ln.npoints)				// empty line?
//							ln.add(x,y);			// add gap
						lnUp=true;
						break;
					case PEN_MOVE:	// pen down and move
						lnUp=false;
						if(!ln.npoints)				// empty line?
							ln.start(x,y);		// init
						else 
							if(x!=x0||y!=y0)ln.add(x,y);			// add
						break;
					case PEN_CONNECTED:
						st&=~ST_PEN_DISCONNECTED;						
						ed.dispatchEvent(new PenEvent(PenEvent.PEN_CONNECT));
						return;
					case PEN_DISCONNECTED:
						st|=ST_PEN_DISCONNECTED;
						ed.dispatchEvent(new PenEvent(PenEvent.PEN_DISCONNECT));
						return;
					default:
						throw("readData(): unknown data type:"+e);
						//log.status("readData(): unknown data type:0x"+e.toString(16),2);
					}
				}
			ed.dispatchEvent(new PenEvent(PenEvent.PEN_DATA));
			}
		catch(e:EOFError)			// wrong msg format is detected!
			{
			throw("readData(): EOF error");
			}	
		}
	
	/**
	 * 	getLineObj() -- return MyWB_Line.toObj() or null (if not pen_up)
	 **/
	static public function getLineObj(w:int=-1, c:int=-1):Object
		{
		if(!(
				(lnUp&&ln.npoints>2)||					// 1. pen is up and line is not empty
				(ln.lastGap>2)||						// 2. line break detected
				(ln.npoints>100)						// 3. line is long enough
		))return null;									// if not -- continue with data collection...
		ln.setThicknessColor(w,c);
		var o:Object=ln.serialize();					// if true -- returns lineObj
		ln.trim(0);										// 		and clean line
		ln=new DrawingObjectRealPen(null);
//		o.c=Whiteboard.wb.colPick.selectedColor;
//		o.w=int(Whiteboard.wb.width_ctrl.value);
		return o;
		}
	
	/**
	 * 	processAnswer() -- answer processing. Common logic of client here.
	 **/
	static private function processAnswer():void
		{
		LOG(5,"processAnswer(): cmd="+lastCommand+" answ="+lastAnswer.slice(0,20), 0);
		if(!lastCommand)throw("Empty lastCommand!");							// paranid
		if(!(st&ST_ANSWER_READY)||!lastAnswer)throw("Empty lastAnswer!");		// paranoid
		st&=~ST_ANSWER_READY;								// mark command as processed
		switch(lastCommand)
			{
			case AUTH_STR:		// auth request
				st&=~ST_AUTH_CHECKING;
				if(lastAnswer!=SRV_ANSW_OK)					// rejected by server
					throw("Auth reject:"+lastAnswer);
				LOG(5,"PenSocketServer connected!");
				st|=ST_AUTH_CHECKED;						// auth-check completed
				ed.dispatchEvent(new PenEvent(PenEvent.PEN_SERVER_CONNECT));
				sendCommand(CMD_RESET);					
				break;
			case CMD_RESET:		// clear pen data
				if(lastAnswer!=SRV_ANSW_OK)					// rejected by server
					throw("Not OK in answer:"+lastAnswer);
				sendCommand(CMD_DATA_RQ);
				break;
			case CMD_DATA_RQ:	// pen data
				if(lastAnswer!=SRV_ANSW_OK)					// rejected by server
					throw("Not OK in answer:"+lastAnswer);
				readData();
//				st|=ST_TIMER_ARMED; 
				sendCommand(CMD_DATA_RQ);
				break;
			default:
				throw("Unknown command??:"+lastCommand);
			}
		}
	
	/////////////////////////////////////////////////////////////////////
	///////////////////   events    /////////////////////////////////////
	/** socketEventsHandler() -- safe socket event listener **/
    static private function socketEventsHandler(e:SafeSocketEvent):void 
		{
		LOG(5,"socketEventsHandler e.type="+e.type,0);
		switch(e.type)
			{
			case SafeSocketEvent.CONNECT:
				st&=~ST_CONNECTING;
				st|=ST_CONNECTED|ST_AUTH_CHECKING;              // start auth-check phase
				sendCommand(AUTH_STR);
				break;
			case SafeSocketEvent.DISCONNECT:
				disconnect();
				break;
			case SafeSocketEvent.ERROR:
				penErr("SafeSocketEvent.ERROR");
				break;
			case SafeSocketEvent.NO_SERVER:
				disconnect(false);
				st|=ST_NO_SERVER;
				ed.dispatchEvent(new PenEvent(PenEvent.PEN_NO_SERVER));
				break;
			case SafeSocketEvent.DATA_RCV:
				try{
					readAnswerStr();
					processAnswer();
					}
				catch(s:String)
					{penErr(s);}
				break;
			case SafeSocketEvent.DATA_SENT:
				break;
			default:
				penErr("paranoid");
			}
		
   		}	
	
	/////////////////////////////////////////////////////////////////////
	
	/**
	*   addBunchListeners() -- add EL's to all events from array
	**/
	static public function addBunchListeners(eventArray:Array, f:Function):void
		{
		for(var i:int=0;i<eventArray.length;i++)
			ed.addEventListener(eventArray[i], f);
		}
	
	/**
	*   removeBunchListeners() -- remove EL's to all events from array
	**/
	static public function removeBunchListeners(eventArray:Array, f:Function):void
		{
		for(var i:int=0;i<eventArray.length;i++)
			ed.removeEventListener(eventArray[i], f);
		}

	private function err(s:String):void
		{
		LOG(5,"ERROR in PenSocketHelper: "+s,2);
		throw(new ArgumentError("ERROR in PenSocketHelper: "+s));
		}

	}



}
//class PenData
//	{
//	public var ev:uint;
//	public var x:int;
//	public var y:int;
//	}
