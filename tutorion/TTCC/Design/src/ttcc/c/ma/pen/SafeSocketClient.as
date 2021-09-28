package ttcc.c.ma.pen
{
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
import flash.utils.*;

import ttcc.LOG;


/**
 * SafeSocketClient -- work-around for flash sockets! 
 * 		Flash sockets can drop data!
 * 		SafeSocketClient is for safe send/recieve data without drops.
 **/
public class SafeSocketClient
	{
	static public const TIMER_INTERVAL:int=50;
	static public const RESEND_INTERVAL:int=100;
	static public const MAX_RESEND_ATTEMPTS:int=10;
	static public const PACKET_START_BYTE:int=0xab;					// SafeSocket packet signature
	static public const PACKET_HEAD_LENGTH:int=6;					// offset to data in packet
	static public const PACKET_INDEX_MASK:int=0xffff;				// mask to trim packets indices
	static public const PACKET_TYPE_DATA:int=0x1;					// data packet
	static public const PACKET_TYPE_CONFIRM:int=0x2;				// confirm-packet
	static public const PACKET_TYPE_DUP:int=0x4;					// copy of last packet
	static public const PACKET_DATA_STR:int=0x10;					// string data in packet
	
	static public const ST_CONNECTING:int=0x1;		
	static public const ST_CONNECTED:int=0x2;
	static public const ST_DISCONNECTED:int=0x4;
	static public const ST_NO_SERVER:int=0x8;
	static public const ST_ERR:int=0x80;
	static public const ST_SENDING:int=0x100;						// packet sent but not confirmed		
	static public const ST_SENT:int=0x200;							// packet sent and confirmed
	static public const ST_RECEIVED:int=0x400;						// at least 1 packet is recieved
	static public const ST_SEND_BIN:int=0x4000;						// packet sent is a binary data
	static public const ST_RCV_BIN:int=0x8000;						// packet recieved is a binary data
	
	public var ed:EventDispatcher=new EventDispatcher();
	public var st:int=0;										// socket state
	public var name:String;										// socket name (optional)
	
	private var s:Socket;
	private var tm:Timer=new Timer(TIMER_INTERVAL,0);
	private var lastSent:ByteArray;								// last sent packet
	private var lastRcv:ByteArray;								// last received packet
	private var lastSentIndex:int=0;
	private var lastSendTm:int=0;								// time of last data sending attempt
	private var resendAttempts:int=0;							// number of resend attempts of last data
	private var lastRcvIndex:int=0;
	private var opCount:int=0;									// total number of send/receive operations
	
////////////////////////////////////////////////////////////////////////////////
/////////////////////  public methods:  ////////////////////////////////////////
	
	/**
	 * 	constructor
	 **/
	public function SafeSocketClient(str:String="ss00")
		{
		name=str;
		LOG(5,"SafeSocketClient::constructor("+name+")");
		}
	
	/**
	 * 	connect(addr, port) -- connect to socket
	 **/
	public function connect(addr:String, port:int):void
		{
		LOG(5,"SafeSocket("+name+")::connect() addr:"+addr+" port:"+port);
		if(st&&!(st&ST_DISCONNECTED))err("Already in use!");
		st=ST_CONNECTING;
		lastSentIndex=lastRcvIndex=0;
		s=new Socket();
		s.endian=Endian.LITTLE_ENDIAN;
        s.addEventListener(Event.CLOSE, s_closeHandler);
        s.addEventListener(Event.CONNECT, s_connectHandler);
        s.addEventListener(IOErrorEvent.IO_ERROR, s_ioErrorHandler);
        s.addEventListener(SecurityErrorEvent.SECURITY_ERROR, s_securityErrorHandler);
        s.addEventListener(ProgressEvent.SOCKET_DATA, s_socketDataHandler);
		s.connect(addr,port);
		tm.addEventListener(TimerEvent.TIMER,tmProc);
		tm.start();
		}
	
	/**
	 * 	disconnect() -- close connection
	 **/
	public function disconnect(dispatch:Boolean=true):void
		{
		LOG(5,"SafeSocket("+name+")::disconnect()");
		tm.stop();
		tm.removeEventListener(TimerEvent.TIMER,tmProc);
		if(s){
			if(s.connected)s.close();
	        s.removeEventListener(Event.CLOSE, s_closeHandler);
	        s.removeEventListener(Event.CONNECT, s_connectHandler);
	        s.removeEventListener(IOErrorEvent.IO_ERROR, s_ioErrorHandler);
	        s.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, s_securityErrorHandler);
	        s.removeEventListener(ProgressEvent.SOCKET_DATA, s_socketDataHandler);
			if(dispatch)
				ed.dispatchEvent(new SafeSocketEvent(SafeSocketEvent.DISCONNECT));
			s=null;
			}
		st=ST_DISCONNECTED;
		}

	/**
	 * 	rcvPacket(d) -- get last received data
	 **/
	public function rcvPacket(b:ByteArray):void
		{
		try
			{
			if(!(st&ST_CONNECTED))throw("Not connected!");		// paranoid
			if(!(st&ST_RECEIVED))throw("Nothing is received");	// paranoid
			lastRcv.position=0;//PACKET_HEAD_LENGTH;		// skip packet header
			lastRcv.readBytes(b);
			}
		catch(s:String)
			{
			err("rcvPacket():"+s);
			}
		}
	
	/**
	 * 	sendPacket(d) -- send data-packet.
	 * 		Use sendLowLevelPacket() for confirm-packets and dup-packets.
	 **/
	public function sendPacket(d:ByteArray, flags:int=0):void
		{
		try
			{
			LOG(5,"SafeSocket("+name+")::sendPacket()",0);
			if(!(st&ST_CONNECTED))throw("Not connected!");
			if(st&ST_SENDING)throw("Is already sending: ("+lastSentIndex+")");
			st&=~ST_SENT;			// party has not confirmed receiving
			st|=ST_SENDING;	
			var packet:ByteArray=new ByteArray();
			packet.endian=Endian.LITTLE_ENDIAN;
			packet.writeByte(PACKET_START_BYTE);		// packet signature
			packet.writeByte(flags|PACKET_TYPE_DATA);	// packet flags (packet type, data type, etc.)
			packet.writeShort(++lastSentIndex);			// packet index
			packet.writeShort(d.length);				// data length
			packet.writeBytes(d);						// data
			lastSent=packet;
			s.writeBytes(packet);
			if((opCount++)%13)							// (!!!) sometimes packets are lost...
				s.flush();
			resendAttempts=0;
			lastSendTm=getTimer();
			}
		catch(s:String)
			{
			setErr("sendPacket():"+s);
			}
		}

	
////////////////////////////////////////////////////////////////////////////////
/////////////////////  private methods:  ///////////////////////////////////////

	/**
	 * 	setErr(s) -- error processing. 
	 * 		Disconnect, total deinit, dispatch event, throw debug exception.
	 **/
	private function setErr(s:String):void
		{
		disconnect(false);			// dont dispatch DISC after ERR
		ed.dispatchEvent(new SafeSocketEvent(SafeSocketEvent.ERROR));
		st|=ST_ERR;
		err("setErr(): "+s);
		}

	/** sendLowLevelPacket(fl,n,d) -- send confirm-packet or dup-packet (data from d) **/
    private function sendLowLevelPacket(fl:int,n:int,d:ByteArray=null):void 
		{
		var packet:ByteArray=new ByteArray();
		packet.endian=Endian.LITTLE_ENDIAN;
		packet.writeByte(PACKET_START_BYTE);		// packet signature
		packet.writeByte(fl);						// packet flags (packet type, data type, etc.)
		packet.writeShort(n);						// packet index
		if(d)
			{
			packet.writeShort(d.length);			// data length
			packet.writeBytes(d);					// data
			}
		else
			packet.writeShort(0);					// data length
		s.writeBytes(packet);
		if((opCount++)%17)							// (!!!) sometimes packets are lost...
			s.flush();			
		}	
	
	/** readIncoming() -- processing of incoming socket data **/
    private function readIncoming():void 
		{
		var b:ByteArray=new ByteArray();			// header
		var bb:ByteArray=new ByteArray();			// data
		b.endian=Endian.LITTLE_ENDIAN;
		bb.endian=Endian.LITTLE_ENDIAN;
		var n:int;
		try
			{
			opCount++;
			s.readBytes(b,0,PACKET_HEAD_LENGTH);	// read packet header:
			var b1:int=b.readUnsignedByte();		// 		packet signature
			var fl:int=b.readUnsignedByte();		// 		packet flags (packet type, data type, etc.)
			var pi:int=b.readUnsignedShort();		// 		packet index
			var l:int=b.readUnsignedShort();		// 		data length
			if(b1!=PACKET_START_BYTE)
				setErr("wrong signature byte received!");
			LOG(5,"SafeSocket("+name+")::readIncoming(): "+
				b1.toString(16)+fl.toString(16)+" "+
				pi.toString(16)+" "+l.toString(16),2);
			if(fl&PACKET_TYPE_DATA)					// data packet?
				{
				s.readBytes(bb,0,l);				// read packet data
				sendLowLevelPacket(PACKET_TYPE_CONFIRM,pi);	// confirm receiving
				n=(lastRcvIndex+1)&PACKET_INDEX_MASK;		// expected packet index
				if(fl&PACKET_TYPE_DUP)				// duplicate packet?
					{
					LOG(5,"SafeSocket("+name+"): copy-packet detected: "+pi,2);
					if(pi!=n)return;				// accept only lastRcvIndex+1, ignore others
					}
				if(pi!=n)throw("Unexpected packet index:"+pi+"(not "+n+")");
				lastRcvIndex=pi;
				lastRcv=bb;
				st|=ST_RECEIVED;
				ed.dispatchEvent(new SafeSocketEvent(SafeSocketEvent.DATA_RCV,
					(fl&PACKET_DATA_STR)?SafeSocketEvent.CODE_STR_DATA:0,
					bb));							// dispatch DATA_RCV event with data
				return;
				}
			if(fl&PACKET_TYPE_CONFIRM)			// confirm-packet?
				{
				n=lastSentIndex;					// expected packet index
				if(!(st&ST_SENDING)||pi!=n)				// confirm-packet is not expected?
					{
					LOG(5,"SafeSocket("+name+"): Unexpected confirm-packet: pi="+pi+"("+n+") sending:"+
						((st&ST_SENDING)?"y":"n"),2);
					return;							// ignore
					}
				st&=~ST_SENDING;
				st|=ST_SENT;						// change state
				ed.dispatchEvent(new SafeSocketEvent(SafeSocketEvent.DATA_SENT));// dispatch DATA_SENT
				return;				
				}
			}
		catch(e:EOFError)
			{
			throw("readIncoming():EOF:Cannot read packet.");
			}
		}	
	
///////////////////////////////////////////////////////////////////////////////////
///////////////////   events    ///////////////////////////////////////////////////
	
	/** tmProc() -- try resend last packet if not confirmed **/
    private function tmProc(e:TimerEvent):void 
		{
		if(!(st&ST_SENDING))return;
		var t:int=getTimer();
		if(t-lastSendTm<RESEND_INTERVAL)return;
		if(++resendAttempts>MAX_RESEND_ATTEMPTS)
			{setErr("MAX_RESEND_ATTEMPTS");return;}
		LOG(5,"SafeSocket("+name+")::resend attempt!",1);
		var d:ByteArray=new ByteArray();
		lastSent.position=PACKET_HEAD_LENGTH;
		lastSent.readBytes(d);
		sendLowLevelPacket(lastSent[1]|PACKET_TYPE_DUP/* flags */,lastSentIndex,d);
		lastSendTm=t;
		}	
	
	/** s_socketDataHandler() **/
    private function s_socketDataHandler(e:ProgressEvent):void 
		{
        LOG(5,"SafeSocket("+name+")::socketDataHandler: " + e,0);
		try
			{
			while(s.bytesAvailable>=PACKET_HEAD_LENGTH)
				readIncoming();
			}
		catch(s:String)
			{
			setErr(s);
			}
   		}	
	
	/** s_ioErrorHandler(e) -- closed socket??? **/
    private function s_ioErrorHandler(e:IOErrorEvent):void 
		{
		LOG(5,"SafeSocket("+name+")::ioErrorHandler: " + e,0);
		//setErr("ioErrorHandler: " + e);
		disconnect(false);
		st|=ST_NO_SERVER;
		ed.dispatchEvent(new SafeSocketEvent(SafeSocketEvent.NO_SERVER));
		}
	
	/** s_securityErrorHandler(e) -- no socket server??? **/	
    private function s_securityErrorHandler(e:SecurityErrorEvent):void 
		{
        LOG(5,"SafeSocket("+name+")::s_securityErrorHandler: " + e,0);
		disconnect(false);
		st|=ST_NO_SERVER;
		ed.dispatchEvent(new SafeSocketEvent(SafeSocketEvent.NO_SERVER));
		}
	
	/** s_closeHandler(e) **/	
    private function s_closeHandler(e:Event):void 
		{
        LOG(5,"SafeSocket("+name+")::closeHandler: " + e,0);
		disconnect();
		}

	/** s_connectHandler(e) **/		
    private function s_connectHandler(e:Event):void 
		{
        LOG(5,"SafeSocket("+name+")::connectHandler: " + e,0);
		st&=~ST_CONNECTING;
		st|=ST_CONNECTED;
		ed.dispatchEvent(new SafeSocketEvent(SafeSocketEvent.CONNECT));
		}
	
	private function err(s:String):void
		{
		LOG(5,"SafeSocket("+name+") error: "+s,2);
		throw(new ArgumentError("SafeSocket("+name+") error: "+s));
		}
	
	}
}
