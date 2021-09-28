package ttcc {
	
	//{ =*^_^*= import
	//} =*^_^*= END OF import
	
	/**
	 * @param	m msg
	 * @param	c channel id(see LOGGER)
		0-"R" realtime debugging
		1-"DT" data trace
		2-"DS" data storage
		3-"V" view
		4-"OP" operations
		5-"NET" network
		6-"AG" agent environment
		7-"AF" application flow
	 */
	public function ERR(m:String, c:uint=0):Object {
		LOG(c, "ERR!", 2);
		throw(new ArgumentError(m));
		return "ERR!" as Object;
	}
}

//{ =*^_^*= History
/* > (timestamp) [ ("+" (added) ) || ("-" (removed) ) || ("*" (modified) )] (text)
 * > 
 */
//} =*^_^*= END OF History

// template last modified:11.03.2011_[18#51#40]_[5]