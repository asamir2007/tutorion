package fms_so_test {
	
	//{ =*^_^*= import
	//} =*^_^*= END OF import
	
	/**
	 * @param	c channel id(see LOGGER)
		0-"R"
		1-"DT"
		2-"DS"
		3-"V"
		4-"OP"
		5-"NET"
		6-"AG"
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