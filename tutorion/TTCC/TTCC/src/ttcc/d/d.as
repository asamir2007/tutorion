package ttcc.d {
	/*
	 * Data
	 * 
	 * du - DataUnit - data storage and no helpers(only getters and setters). Typically small, contains both non-persistent(temp) and persistent data
	 * ds - DataStoreroom - data storage and optionally: builtin helpers, eventDispatching. Typically large, contains DataUnits 
	 * dua - DataUnitAccessor - provides access controll, that can vary at runtime, while accessing data units
	 * duai - DataUnitAccessInformation - provides permissions list for the dua
	 * s - server related
	 * v - view related
	 * a - application related
	 * dsp disposable/temp data
	 * dp data processors
	 */
}

//{ =^_^= History
/* > (timestamp) [ ("+" (added) ) || ("-" (removed) ) || ("*" (modified) )] (text)
 * > 
 */
//} =^_^= END OF History

// template last modified:03.05.2010_[22#42#27]_[1]