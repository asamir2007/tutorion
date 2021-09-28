package org.jinanoimateydragoncat.data{
	
	//{ =*^_^*= import
	//} =*^_^*= END OF import
	
	
	/**
	 * 
	 * @author Jinanoimatey Dragoncat
	 * @version 0.0.0
	 * @created 17.11.2009 21:35
	 */
	public interface IJDSerializable {
		
		function fromObject(a:Object):Object {}
		function toObject(a:Object=null):Object {}
		
	}
}