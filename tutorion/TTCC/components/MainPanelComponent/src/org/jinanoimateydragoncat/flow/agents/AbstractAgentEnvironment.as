package org.jinanoimateydragoncat.utils.flow.agents {
	
	//{ =*^_^*= import
	import flash.utils.Dictionary;
	import org.jinanoimateydragoncat.utils.flow.agents.AbstractAgent;
	//} =*^_^*= END OF import
	
	
	/**
	 * all agents receiving service event ID_E_ENV_PLACED
	 * all alive agents receiving service event ID_E_ENV_CND_CHANGE
	 * all alive agents receiving non-service(user) events after <i>set_notifyAll(true);</i>
	 * @author Jinanoimatey Dragoncat
	 * @version 1.0.0
	 * @created 09.06.2011 1:43
	 */
	public class AbstractAgentEnvironment extends AbstractAgent {
		
		//{ =*^_^*= CONSTRUCTOR
		
		function AbstractAgentEnvironment (name:String) {
			super(NAME);
			em = [];
		}
		public static const NAME:String = 'AbstractAgentEnvironment';
		//} =*^_^*= END OF CONSTRUCTOR
		
		
		//{ =*^_^*= public
		
		/**
		 * @param	eventType see list below
		 * @param	detais
		 */
		public override function listen(eventType:String, details:Object):void {
			if (notifyAll) {
				en_notifyAliveAgents(eventType, details);
			} else {
				en_notifyAliveInterestedOnlyAgents(eventType, details);
			}
		}
		
		public function placeAgent(a:AbstractAgent):void {
			if (agents.indexOf(a)>-1) {return;}
			agents.push(a);
			// inform agent about placement
			a.placed(this);
			//
			b = a.autoSubscribeEvents();
			for each(var i:String in b) {subscribe(a, i);}
		}
		
		/**
		 * set alive to false, rmeove from list, remove subscription to autoSubscribeEvents list
		 * @param	a
		 */
		public function removeAgent(a:AbstractAgent):void {
			a.setAlive(false);
			if (agents.indexOf(a)==-1) {return;}
			agents.splice(agents.indexOf(a), 1);
			//
			b = a.autoSubscribeEvents();
			for each(var i:String in b) {unsubscribe(a, i);}
		}
		
		/**
		 * force dispatch event to all agents istead of interested(condition change event will remain unaffected)
		 */
		public function get_notifyAll():Boolean {return notifyAll;}
		public function set_notifyAll(a:Boolean):void {notifyAll = a;}
		
		
		/**
		 * env:AbstractAgent
		 */
		public static const ID_E_ENV_PLACED:String=NAME+'>ID_E_ENV_PLACED';
		
		/**
		 * обновлен параметр среды
		 * i:uint//id, v:Object//value
		 */
		public static const ID_E_ENV_CND_CHANGE:String=NAME+'>ID_E_ENV_CND_CHANGE';
		
		/**
		 * to event
		 * @return true-added; false-already subscribed to event
		 */
		public function subscribe(target:AbstractAgent, eventType:String):Boolean {
			a = em[eventType];
			if (a==null) {
				a = [];
				em[eventType] = a;
			}
			
			for each(var i:AbstractAgent in a) {
				if (i==target) {
					return false;
				}
			}
			
			a.push(target);
			
			return true;
		}
		
		/**
		 * to event
		 * @return true-removed; false-was not subscribed to event
		 */
		public function unsubscribe(target:AbstractAgent, eventType:String):Boolean {
			a = em[eventType];
			if (a==null) {
				return false;
			}
			
			for each(var i:AbstractAgent in a) {
				if (i==target) {
					a.splice(a.indexOf(target), 1);
					if (a.length==0) {//no subscribers left
						delete em[eventType];
					}
					return true;
				}
			}
			
			return false;
		}
		
		/**
		 * from all events
		 */
		// NOTE: not tested!
		public function unsubscribeALL(target:AbstractAgent):void {
			for each(var i:String in em) {//eventType
				a = em[i];//agents list for eventType
				if (!a) {continue;}//list is invalid or not exist
				for each(var ia:AbstractAgent in a) {
					if (ia==target) {
						a.splice(a.indexOf(target), 1);
						if (a.length==0) {//no subscribers left
							delete em[i];
							break;//list deleted. goto next
						}
					}
				}
			}
		}
		
		
		//} =*^_^*= END OF public
		
		
		private var agents:Array = [];
		private var notifyAll:Boolean;
		
		
		//{ =*^_^*= condition
		/**
		 * @param	id ид параметра(must be unique) - константа конкретного класса среды
		 * @return значение параметра среды
		 */
		public final function getConditionValue(id:uint):Object {
			return conditionList[id];
		}
		
		/**
		 * 
		 * @param	id ид параметра(must be unique) - константа конкретного класса среды
		 * @param	value значение параметра среды
		 * @return updated/not changed
		 */
		public final function setConditionValue(id:uint, value:Object):Boolean {
			if (conditionList[id]==value) {return false;}
			conditionList[id]=value;
			// notify agents
			en_notifyAliveAgents(ID_E_ENV_CND_CHANGE, {i:id, v:value});
			return true;
		}
		
		private var conditionList:Array=[];
		//} =*^_^*= END OF condition
		
		
		//{ =*^_^*= engineering events
		private function en_notifyAliveAgents(eventType:String, details:Object):void {
			for each(var i:AbstractAgent in agents) {
				if (i.isAlive()) {
					i.listen(eventType, details);
				}
			}
		}
		
		private function en_notifyAliveInterestedOnlyAgents(eventType:String, details:Object):void {
			a = em[eventType];
			if (a==null) {return;}//no subscribers
			
			for each(var i:AbstractAgent in a) {
				i.listen(eventType, details);
			}
			
		}
		
		
		/**
		 * events map
		 */
		private var em:Array;
		private var a:Array;
		private var b:Array;
		
		//} =*^_^*= END OF engineering events
		
		
	}
}

//{ =*^_^*= History
/* > (timestamp) [ ("+" (added) ) || ("-" (removed) ) || ("*" (modified) )] (text)
 * > 17.07.2011_06#50#35 +removeAgent
 * > 02.02.2012_10#16#02 + unsubscribeALL
 * > 
 */
//} =*^_^*= END OF History

// template last modified:11.03.2011_[18#51#40]_[5]