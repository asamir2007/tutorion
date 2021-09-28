// Project TTCC
package ttcc.c.ma {
	
	//{ =*^_^*= import
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.net.Responder;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	
	import ttcc.APP;
	import ttcc.Application;
	import ttcc.LOG;
	import ttcc.c.ae.AEApp;
	import ttcc.c.ma.ac.MACMP;
	import ttcc.c.ma.ac.MAPPComponents;
	import ttcc.c.ma.graph.StatDataProcessing;
	import ttcc.c.vcm.d.DUMPButton;
	import ttcc.cfg.SP;
	import ttcc.d.a.ARO;
	import ttcc.media.Text;
	import ttcc.n.a.FMSServerAdaptor;
	//} =*^_^*= END OF import
	
	
	/**
	 * ping
	 * resume/cut media streams (message)
	 * block/unblock screen with disconnected message (message)
	 * @author Jinanoimatey Dragoncat
	 * @version 0.0.0
	 * @created 12.10.2012 14:11
	 */
	public class MServerMonitor extends AM {
		
		//{ =*^_^*= CONSTRUCTOR
		
		function MServerMonitor (app:Application) {
			super(NAME);
			a=app;
		}
		//} =*^_^*= END OF CONSTRUCTOR
		
		
		public override function listen(eventType:String, details:Object):void {
			var r:ARO;
			switch (eventType) {
			
			case ID_A_CONNECT:
				a.get_aer().subscribe(this, ID_E_STREAM_INFO);
				
				freezeTimeout=a.get_ds().get_duAppComponentsCfg().get_freeze_timeout();
				disconnectTimeout=a.get_ds().get_duAppComponentsCfg().get_disconnect_timeout();
				log(5,NAME+'>config: freezeTimeout='+freezeTimeout+'disconnectTimeout='+disconnectTimeout, 0);
				nca=new FMSServerAdaptor();
				nca.construct(el_nca, a.get_fmsNetConnectorRef());				
				StatDataProcessing.init(a.get_mainScreen().get_displayObject(), a.get_httpXMLAdaptor());
				prepareAndRunTimer();
				break;
				
			case MAPPComponents.ID_E_COMPONENTS_ARE_READY:
				break;//remove test buttons
				 //add test buttons:
				e.listen(MACMP.ID_A_ADD_BUTTON, new DUMPButton(
					ID_A_DEUBUG_FREEZE
					,100001
					,"board_h"
					,"board_w"
					,"board_b"
					,'freeze client'
				));
				break;
			
			case ID_A_DEUBUG_FREEZE:
				var t:int=getTimer();
				log(5,'freezing....')
				for (var i:int = 0; i < 119111000;i++) {
					if (i%2==0) {}
				}
				log(5,'unfreezing, seconds:'+(getTimer()-t)/1000)
				break;
				
			case ID_E_STREAM_INFO:
				lastStreamInfo=details;
				break;
			}
		}
		
		private function sendPingMessage():void {
			//lastPacketIndex+=1;
			//lastReceivedPacketTime=getTimer();
			//log(5,'sendPingMessage>lastPacketIndex='+lastPacketIndex+' lastReceivedPacketTime'+lastReceivedPacketTime);
			//mesageQueue+=1;
			nca.call(SP.METHOD_RTMP_PING, [++lastPacketIndex, getTimer()], resp);
		}
		
		private function prepareAndRunTimer():void {
			timer=new Timer(pingInterval);
			timer.addEventListener(TimerEvent.TIMER, el_timer);
			timer.start();
		}
		private function stopTimer():void {
			timer.removeEventListener(TimerEvent.TIMER, el_timer);
			timer.stop();
		}
		
		private function el_timer(e:Event):void {
			var dt:int=getTimer()-lastSuccessPingTime;
			//log(5,'ping:'+ping);
			if (dt>disconnectTimeout) {
			//} else if (lastPacketIndex==9) {//test
				stopTimer();
				// disconnect, stop timer
				get_envRef().listen(ID_E_CONNECTION_LOST, null);
			} else if (dt>freezeTimeout) {
				if (!clientPaused) {
					clientPaused=true;
					// freeze
					get_envRef().listen(ID_E_SUSPEND_APPLICATION, null);
				}
			} else if (dt<freezeTimeout) {
				if (clientPaused) {
					clientPaused=false;
					// unfreeze
					get_envRef().listen(ID_E_RESUME_APPLICATION, null);
				}
			}
			StatDataProcessing.push(lastStatObj,lastStreamInfo);
			sendPingMessage();
		}
		
		private static const PING_INTERVAL:int = 1000;				
		
		private var clientPaused:Boolean;
		private var resp:Responder=new Responder(onResult,onStatus);
		private var lastStatObj:Object=null;						// obj with fms stats from last ping-responce 
		private var lastStreamInfo:Object=null;						// obj with NetStream stats from last ID_A_GET_STREAM_INFO
		private var lastSuccessPingTime:int=0;						// time of last success ping-responce (ping<freezeTimeout)
		private var lastPacketIndex:int=0;							// index of last sent packet 
		private var lastPing:int=0;									// value of last ping: [0..pingInterval] OR pingTOValue
		private var pingInterval:int=PING_INTERVAL;					// how often to ping
		private var pingTOValue:int=PING_INTERVAL;					// time to wait ping-answer packet (pingTOValue <= pingInterval)
		private var freezeTimeout:int=3000;
		private var disconnectTimeout:int=5000;
		private var timer:Timer;
		
		/**
		* 	onResult(o) -- callback on pingAndStats(pi,tm)
		* 		o:{pi,tm,info} -- value returned from pingAndStats(pi,tm)
		**/
		private function onResult(o:Object=null):void{
			if(o.pi!=lastPacketIndex)
				{
				lastPing=pingTOValue;		// packet-lost detected!
				lastStatObj=null;
				LOG(5,"too late for ping-packet "+o.pi+", waiting for "+lastPacketIndex, 1);
				return;						// ignore packet 
				}
			lastPing=getTimer()-o.tm;
			if(lastPing>pingTOValue)
				LOG(5,"ping timeout: "+o.tm+" > "+pingTOValue, 1);
			else
				lastSuccessPingTime=o.tm;
			lastStatObj=o.info;
			lastStatObj.tsend=o.tm;
			lastStatObj.ping=lastPing;
			a.get_aer().listen(MAV.ID_A_GET_STREAM_INFO, null);
			//LOG(5,NAME+">onResult(): pi="+o.pi+" tm="+o.tm+" dt="+(lastReceivedPacketTime-o.tm), 0);
		}
		
		private function onStatus(o:Object=null):void {
			LOG(5,NAME+">onStatus():"+traceObject(o), 0);
		}
		
		
		private function el_nca(target:FMSServerAdaptor, eventType:String, eventData:Object):void {
			log(5, NAME+'>el_nca: eventType='+eventType+' data'+traceObject(eventData), 2);
			if (eventType==FMSServerAdaptor.ID_E_ERR_NC_NOT_CONNECTED) {return;}
			throw new Error('[N] '+NAME+'>el_nca: eventType='+eventType+' data'+traceObject(eventData));
		}
		
		
		//{ =*^_^*= private 
		private var nca:FMSServerAdaptor;
		//} =*^_^*= END OF private
		
		private function get e():AEApp {return get_envRef();}
		private var a:Application;		
		
		//{ =*^_^*= id
		public static const ID_A_CONNECT:String=NAME+'>ID_A_CONNECT';
		public static const ID_A_DEUBUG_FREEZE:String=NAME+'>ID_A_DEUBUG_FREEZE';
		//} =*^_^*= END OF id
		
		//{ =*^_^*= events
		public static const ID_E_CONNECTED:String=NAME+'>ID_E_CONNECTED';
		public static const ID_E_SUSPEND_APPLICATION:String=NAME+'>ID_E_SUSPEND_APPLICATION';
		public static const ID_E_RESUME_APPLICATION:String=NAME+'>ID_E_RESUME_APPLICATION';
		public static const ID_E_CONNECTION_LOST:String=NAME+'>ID_E_CONNECTION_LOST';
		/**
		 * data:{aSent:0, vSent:0,aRecv:0, vRecv:0,lag:0}
		 */
		public static const ID_E_STREAM_INFO:String=NAME+'>ID_E_STREAM_INFO';
		//} =*^_^*= END OF events
		
		public static const NAME:String = 'MServerMonitor';
		
		public override function autoSubscribeEvents():Array {
			return [
				ID_A_CONNECT
				,ID_A_DEUBUG_FREEZE
				,MAPPComponents.ID_E_COMPONENTS_ARE_READY
			];
		}
		
	}
}

//{ =*^_^*= History
/* > (timestamp) [ ("+" (added) ) || ("-" (removed) ) || ("*" (modified) )] (text)
 * > 
 */
//} =*^_^*= END OF History

// template last modified:11.03.2011_[18#51#40]_[5]