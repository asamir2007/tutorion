package ttcc {
	
	//{ =*^_^*= import
	//} =*^_^*= END OF import
	
	/**
	 * @param	c channel id(see LOGGER)
		0-"R" realtime debugging
		1-"DT" data trace
		2-"DS" data storage
		3-"V" view
		4-"OP" operations
		5-"NET" network
		6-"AG" agent environment
		7-"AF" application flow
	 * @param	m msg
	 * @param	l level
		0-INFO
		1-WARNING
		2-ERROR
	 */
	public function LOG(c:uint, m:String, l:uint=0):void {
		LOGGER.log(c, m, l);
	}
}

//{ =*^_^*= History
/* > (timestamp) [ ("+" (added) ) || ("-" (removed) ) || ("*" (modified) )] (text)
 * > 
 */
//} =*^_^*= END OF History

// template last modified:11.03.2011_[18#51#40]_[5]