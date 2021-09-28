package ru.inspirit.net.events
{
import flash.events.Event;
        public class MP_LdrEvt extends Event
        {
                public static const DATA_PREPARE_PROGRESS:String = 'dataPrepareProgress';
                public static const DATA_PREPARE_COMPLETE:String = 'dataPrepareComplete';
               
                public var bytesWritten:uint = 0;
                public var bytesTotal:uint = 0;
               
                public function MP_LdrEvt(type:String, w:uint = 0, t:uint = 0)
                {
                        super(type);
                       
                        bytesTotal = t;
                        bytesWritten = w;
                }
               
        }
       
}

