package ttcc.c.ma.graph
{
import com.dynamicflash.util.Base64;

import flash.display.*;
import flash.events.Event;
import flash.utils.*;

import mx.core.Application;

import ttcc.*;
import ttcc.cfg.SP;
import ttcc.n.a.HTTPXMLServerAdaptor;

public class StatDataProcessing
	{
	//static public var vlist:VList;
				
	static public const MAX_CHUNK:int=10;		// max number of chunks
	static public const TO_LOG_LEN:int=5;		// number of pts in chunk
//	static public const BUFF_LEN:int=MAX_CHUNK*TO_LOG_LEN;
//	static public const DATA_INTERVAL:int=1000;	// interval (ms) between pts
//	static public const LOG_INTERVAL:int=TO_LOG_LEN*DATA_INTERVAL;

	static private var ready:Boolean=false;		// init() called?
	static private var sprite:Sprite;			// for ENTER_FRAME listener
	static private var rq:HTTPXMLServerAdaptor;
	
	static private var framesCount:int=0;		// frames after last data
	static private var lastFPS:int;				// last fps
	static private var lastDataTm:int=0;		// timestamp of last data
	
//	static private var data:Array=new Array(BUFF_LEN);
	static private var dataIndex:int=0;
	static private var chunkIndex:int=0;
	
	//static private var timer:Timer;				
	
	static private var dataObj:Object=			// last data object for dp
		{
		/** fields from getStats() **/
		bytes_in :0,    // Общее число полученных данных в байтах.
		bytes_out :0,    // Общее число отправленных данных в байтах.
		msg_in :0,    // Общее число полученных RTMP обращений.
		msg_out :0,    // Общее число отправленных RTMP обращений.
		msg_dropped :0,    // Общее число потерянных RTMP обращений.
		ping_rtt :0,    // Промежуток времени, требуемый клиенту для ответа на ping обращение.
		audio_queue_msgs :0,    // Текущее количество аудио пакетов стоящих в очереди на доставку к клиенту.
		video_queue_msgs :0,    // Текущее количество видео пакетов стоящих в очереди на доставку к клиенту.
		so_queue_msgs :0,    // Текущее количество пакетов общих объектов стоящих в очереди на доставку к клиенту.
		data_queue_msgs :0,    // Текущее количество пакетов данных стоящих в очереди на доставку к клиенту.
		dropped_audio_msgs :0,    // Число потерянных аудио пакетов.
		dropped_video_msgs :0,    // Число потерянных видео пакетов.
		audio_queue_bytes :0,    // Общий размер аудио пакетов в байтах стоящих в очереди на доставку к клиенту.
		video_queue_bytes :0,    // Общий размер видео пакетов в байтах стоящих в очереди на доставку к клиенту.
		so_queue_bytes :0,    // Общий размер пакетов общих объектов в байтах стоящих в очереди на доставку к клиенту.
		data_queue_bytes :0,    // Общий размер пакетов данных в байтах стоящих в очереди на доставку к клиенту.
		dropped_audio_bytes :0,    // Общий размер потерянных аудио пакетов в байтах.
		dropped_video_bytes :0,    // Общий размер потерянных видео пакетов в байтах.
		bw_out :0,    // Текущая пропускная способность исходящего потока (от клиента к серверу) для данного клиента.
		bw_in :0,    // Текущая пропускная способность входящего потока (от сервера к клиенту) для данного клиента.
		client_id :0,    // Уникальный идентификатор ID назначенный сервером данному клиенту.
		/** custom fields **/
		ping :0,			// custom ping. Based on nc.call(); 
		lag :0,				// client buffer length
		fps :0,				// application frame rate
		aRecv:0, vRecv:0,	// traffic received by client (audio/video)
		aSent:0, vSent:0	// traffic sent by client (audio/video)
		};
	static private var logTemplate:Array=	// data fields to collect
		[
		/** fields from fms **/
		"bytes_in","bytes_out",				// Общее число данных в байтах.
		"msg_in","msg_out","msg_dropped",  	// Общее число RTMP обращений.
		"ping_rtt",							// Промежуток времени, требуемый клиенту для ответа на ping обращение.
		// Server queue
		"audio_queue_msgs","video_queue_msgs","so_queue_msgs","data_queue_msgs",    
		"audio_queue_bytes","video_queue_bytes","so_queue_bytes","data_queue_bytes",
		// Server dropped
		"dropped_audio_msgs","dropped_video_msgs","dropped_audio_bytes","dropped_video_bytes",
		/** custom fields **/
		"ping","lag","fps",
		"aRecv", "vRecv",	// traffic sent by client (audio/video)
		"aSent", "vSent"	// traffic received by client (audio/video)
		];
	
	/** output format (Example) **/ 
	static private var outputObject:Object=
		{									
		pnum:TO_LOG_LEN, chunk:0, 			// number of pts, chunkIndex
		t:getTimer(),						// sending time
		x:[5,6,7],							// x-data for all graphs
		graphs:								// hash-map containing graphs
			{
	      	ping:							// object with data for one graph
				{
				y:[0,1,2]					// data
				},
			lag:							// object with data for one graph
				{
				y:[0,1,2]					// data
				}
			}
		};

	
	/////////////////////////////////////////////
	static public function init(_sprite:Sprite, _rq:HTTPXMLServerAdaptor):Object
		{
		if(ready)return;
		if(!_sprite)return ERR("null sprite");
		sprite=_sprite;
		rq=_rq;
		dataIndex=0;
		chunkIndex=0;
		outputObject.graphs={};
		var g:Object=outputObject.graphs;
		var s:String;
		for(var j:int=0; j<logTemplate.length; j++)
			{
			s=logTemplate[j];
			if(!s)continue;
			g[s]={y:new Array(TO_LOG_LEN)};
//			for(var i:int=BUFF_LEN-TO_LOG_LEN; i<BUFF_LEN; i++)
//				if(data[i]) dst[s]+=","+int(data[i][s]);
//			dsts+=dst[s]+"\n";
			}
		outputObject.x=new Array(TO_LOG_LEN);
		sprite.addEventListener(Event.ENTER_FRAME, frameHandler);
		ready=true;
		}	
	
	static public function push(o:Object, o2:Object):Object
		{
		if(!o)return;		// packet-lost
		if(!ready)return ERR("Call StatDataProcessing.init() first!");
		var oo:Object=convertToDataObj(o,o2);
		var g:Object=outputObject.graphs;
		var s:String;
		var y:Array;
		for(var j:int=0; j<logTemplate.length; j++)
			{
			s=logTemplate[j];
			if(!s)continue;
			//LOG(1,"("+s+")",1);
			y=g[s].y;
			y[dataIndex]=oo[s];
			}
		outputObject.x[dataIndex++]=o.tsend;
		if(dataIndex==TO_LOG_LEN)
			{
			sendDataChunk();
			dataIndex=0;
			}
		}
	
	/** Generate and fill in missing fields **/
	static private function convertToDataObj(o:Object, o2:Object):Object
		{
		var dt:int=getTimer()-lastDataTm;
		if(dt>900)
			{
			lastFPS=framesCount*1000/dt; 
			lastDataTm=getTimer();
			framesCount=0;
			}
		var s:String;
		var oo:Object={};					// new dataObj
		for (s in o2)if(s)o[s]=o2[s];		// copy all from src		
		for (s in o)if(s)oo[s]=o[s];		// copy all from src		
//		oo.ping=0;
		oo.fps=lastFPS;
		// outgoing stream
//		if(vlist.v_in && vlist.v_in.isConnected && vlist.v_in.ns)
//			{
//			o.aSent=int(vlist.v_in.ns2.info.audioBytesPerSecond);
//			o.vSent=int(vlist.v_in.ns.info.videoBytesPerSecond);
//			}
//		else
//			{
//			o.aSent=0;
//			o.vSent=0;	
//			}
			
		// incoming streams	
//		var aa:Array=vlist.v;
//		o.aRecv=o.vRecv=0;
//		var lag:int=0;
//		var lag0:int=0;
//		for(var i:int=0;i<aa.length;i++)
//			{			
//			var v:VBase=aa[i] as VBase;
//			if(v==vlist.v_in)continue;
//			o.aRecv+=(v.isConnected)?int(v.ns2.info.audioBytesPerSecond):0;
//			o.vRecv+=(v.isConnected)?int(v.ns.info.videoBytesPerSecond):0;
//			lag0=(v.isConnected)?int(v.ns.bufferLength*1000):0;// .liveDelay;		
//			if(lag<lag0)lag=lag0;
//			lag0=(v.isConnected)?int(v.ns2.bufferLength*1000):0;// .liveDelay;		
//			if(lag<lag0)lag=lag0;
//			}
//		
//		o.lag=lag;
		oo.dropped_audio_bytes-=dataObj.dropped_audio_bytes;
		oo.dropped_video_bytes-=dataObj.dropped_video_bytes;
		oo.dropped_audio_msgs-=dataObj.dropped_audio_msgs;
		oo.dropped_video_msgs-=dataObj.dropped_video_msgs;
		//status("tmProc o.bytes_out, dataObj.bytes_out:  "+o.bytes_out+", "+dataObj.bytes_out);
		oo.bytes_in-=dataObj.bytes_in;
		oo.bytes_out-=dataObj.bytes_out;
		dataObj=o;
		return oo;		
		}	
	
	/** send to rq **/
	static private function sendDataChunk():void
		{
		outputObject.chunk=chunkIndex;
		outputObject.t=getTimer();
		var s:String=JSON.stringify(outputObject);
		//LOG(1,"sendDataChunk():\n"+s,1);
		rq.reqXML(SP.getApiUrl(), SP.ID_METHOD_HTTP_SEND_STATS, 
			{userdata:Base64.encode(s), item_id:chunkIndex}, elRqAnswer);
		dataIndex=0;
		chunkIndex++;
		}
	
	/////////////////////////////////////////////
	static private function frameHandler(e:Event):void
		{
		framesCount++;
		}
	
	static private function elRqAnswer(d:Object,e:Boolean):void
		{
		if(e)LOG(1,"d="+(d?d.toString():"null")+" e="+e,2);
		}

	}
}