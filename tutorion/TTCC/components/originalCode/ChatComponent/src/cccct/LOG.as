package cccct {
	
	//{ =*^_^*= import
	//} =*^_^*= END OF import
	
	/**
	 * @param	c channel id(see LOGGER)
		0-"R-Realtime"
		1-"DT-Data trace"
		2-"DS-Data storage"
		3-"V-View"
		4-"OP-Operations"
		5-"NET-Network"
		6-"AG-Agents"
	 * @param	m msg
	 * @param	l level
		0-INFO
		1-WARNING
		2-ERROR
	 */
	public function LOG(c:uint, m:String, l:uint=0):void {
		LOGGER0.log(c, m, l);
	}
}

//{ =*^_^*= History
/* > (timestamp) [ ("+" (added) ) || ("-" (removed) ) || ("*" (modified) )] (text)
 * > 
 */
//} =*^_^*= END OF History

// template last modified:11.03.2011_[18#51#40]_[5]