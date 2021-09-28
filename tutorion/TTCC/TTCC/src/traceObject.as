package {
	
	//{ ^_^ import
	import org.jinanoimateydragoncat.utils.L;
	//} ^_^ END OF import
	
	public function traceObject(a:Object, callMethods:Boolean=false):String {
		var s:String=L.traceObject(a, callMethods);
		//if (!s) {return "traceObject ERROR, data:"+a+'\ntype:'+(typeof a);}
		return s.replace('}, {', '}\n,{');
	}
}

//{ =*^_^*= History
/* > (timestamp) [ ("+" (added) ) || ("-" (removed) ) || ("*" (modified) )] (text)
 * > 
 */
//} =*^_^*= END OF History

// template last modified:11.03.2011_[18#51#40]_[5]