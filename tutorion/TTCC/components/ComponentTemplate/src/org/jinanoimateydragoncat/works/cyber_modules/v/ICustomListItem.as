package org.jinanoimateydragoncat.works.cyber_modules.v {
	
	//{ =*^_^*= import
	import flash.display.DisplayObject;
	//} =*^_^*= END OF import
	
	
	/**
	 * 
	 * @author Jinanoimatey Dragoncat
	 * @version 0.0.0
	 * @created 04.02.2012 20:57
	 */
	public interface ICustomListItem {
		
	/**
	 * function (item:ICustomListItem):void;
	 * @param	target controlled DisplayObject
	 * @param	onActivate function (item:ICustomListItem):void;
	 * @return
	 */
	//function getInstance(target:DisplayObject, onActivate:Function):ICustomListItem;
	
	function set_data(data:Object):void;
	function get_data():Object;
	function set_visible(a:Boolean):void;
	
	}
}

//{ =*^_^*= History
/* > (timestamp) [ ("+" (added) ) || ("-" (removed) ) || ("*" (modified) )] (text)
 * > 
 */
//} =*^_^*= END OF History

// template last modified:11.03.2011_[18#51#40]_[5]