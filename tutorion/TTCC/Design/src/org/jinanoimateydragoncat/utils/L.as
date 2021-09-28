package org.jinanoimateydragoncat.utils {
	
	//{ =^_^= import
	//} =^_^= END OF import
	
	
	/**
	 * 
	 * @author Jinanoimatey Dragoncat
	 * @version 0.1.0
	 * @created 04.11.2010 19:02
	 */
	public class L {
		
		//{ =^_^= CONSTRUCTOR
		
		public function L () {throw new ArgumentError("static");}
		//} =^_^= END OF CONSTRUCTOR
		
		
		/**
		 * "sync with me" <strong>ATTENTION!! NOT TESTED WELL SINCE LAST MODIFICATION!!</strong>
		 * @param target target Object <em>if (target == null) returns Object</em>
		 * @param src source Object
		 * @param map <code>{srcVariableNameToCopyTo:targetVariableNameToCopyFrom} | ['srcVariableName', ...])</code>
		 */
		public static function swm (target:*, src:*, map:Object = null):Object {
			var i:*;
			if (map != null) {
				var _5D7C54CA139:Boolean = false;
				if (target == null) {target = {};_5D7C54CA139 = true};
				if (src != undefined) {
					if (map is Array) {
						for (i in map) {if (src[map[i]] != undefined) {target[map[i]] = src[map[i]];}}
					} else {
						for (i in map) {if (src[map[i]] != undefined) {target[i] = src[map[i]];}}
					}
				}
				if (_5D7C54CA139) {return target;}
			} else if (typeof src == 'object') {
				for (i in src) {
					try {target[i] = src[i];} catch (e:Error) {}
				}
			}
			
			return null;
		}
		
		public static function traceObject(o:Object, callMethods:Boolean=false):String {
			var r:String='';
			if (o is Array) {
				r = '[';
				for (var ii:Object in o) {
					// if ((typeof o[ii]) == 'object') {
						r += traceObject(o[ii])+', ';
					/*} else {
						r+=o[ii]+', ';
					}*/
				}
				if (r.length>1&&r.lastIndexOf(', ')==r.length-2) {
					return r.substr(0, r.length-2)+']';
				} else {
					return r+']';
				}
			} else if (typeof o == 'object') {
				r = '{';
				for (var i:String in o) {
					if ((typeof o[i]) == 'object') {
						r += i+':'+traceObject(o[i])+', ';
					} else {
						r+=(i+':'+o[i])+', ';
					}
				}
				if (r.length>1&&r.lastIndexOf(', ')==r.length-2) {
					return r.substr(0, r.length-2)+'}';
				} else {
					return r+'}';
				}
			} else if (o.hasOwnProperty('toXMLstring')){
				return o.toXMLstring();
			} else if (callMethods&&(typeof o == 'function')&&o.length==0) {
				return 'function('+o()+');';
			} else {
				return String(o);
			}
		}
		
		/**
		 * text sync
		 * @param a target reference
		 * @param b <code>["variableOrFunctionName0", value0, ...]
		 * ["parent.parent.removeChild(","//this.parent//"]
		 * ["parent.visible", false, "parent.mouseEnabled", false]</code>
		 * @return array of inaccessible properties or null
		 * tested
		 */
		public static function ts (a:*, b:Array):Array {
			if (b.length < 1) {return null;}
			var r:*=null, rr:String=null, n:Array=[], v:Array=[], t:Array, LB25I9T5PD:Boolean=false, res:Array=[];
			for (var i:uint=0;i<b.length; i++) {
				if (i%2 == 0) {n.push(b[i]);
				} else {if(b[i]===TS_THIS){v.push(a);}else{v.push(b[i]);}}
			}
			for (i = 0;i < n.length; i++ ) {if (n[i].length < 1) {continue;}
				r = a;t = n[i].split(".");rr = t[t.length-1];t.splice(t.length-1, 1);
				LB25I9T5PD = rr.substr(-1, 1) == "(";
				if (LB25I9T5PD) {rr = rr.substr(0, rr.length-1);}
				
				for each(var ii:String in t) {if (ii in r) {r = r[ii];}else{res.push(n[i]);continue;}}
				if (!(rr in r)) {res.push(n[i]);continue;}
				if (LB25I9T5PD) {r[rr].apply(r, (v[i] is Array)?v[i]:[v[i]]);} else {r[rr] = v[i];}
			}
			return (res.length)?res:null;
		}
		
		
		/**
		 * absolete(?)
		 * @param	a target | [target0,...]
		 * @param	b propertyORfunction | [propertyORfunction0,...]
		 * @param	c value | argumentsArray
		 * @param	d functionMode
		 */
		public static function s (a:*, b:*, c:*, d:Boolean = false):void {
			if (!(a is Array)) {a = [a];}
			if (!(b is Array)) {b = [b];}
			for each(var i:* in a) {
				for each(var ii:* in b) {
					if (d) {i[ii].apply(i,(c is Array)?c:[c]);}else{i[ii] = c;}
				}
			}
		}
		
		/**
		 * L.match <strong>ATTENTION!! NOT TESTED WELL SINCE LAST MODIFICATION!!</strong>
		 * @param	a target
		 * @param	criteria [{name:value, name0:null}, ...]// null means any with property "name0" 
		 * @param	type 'AND' mode
		 * @return result
		 */
		public static function match (a:Object, criteria:*, type:Boolean = false):Boolean {
			if (!(criteria is Array)) {criteria = [criteria];}
			for each(var i:Object in criteria) {
				match$0 = false;
				for (var ii:String in i) {
					if (!(ii in a) || (i[ii] != null && a[ii] != i[ii])) {
						match$0 = true;
						if (!type) {break;}
					}
				}
				if (match$0) {if (type || criteria.length == 1) {return false;}}
				else if (!type || criteria.length == 1) {return true;}
			}
			return type;
		}
		
		/**
		 * construct object from string
		 * @param	b string representation of object
		 * @return Object instance
		 */
		public static function strtoobj (b:String):Array {
			if (b.indexOf('<data>') == -1) {return null;}
			var a:String = b.substr(b.indexOf('<data>')+'<data>'.length);
			a = a.substring(0, a.indexOf('</data>'));
			var tmp0:Array = a.split('/o'), tmp1:Array = [];
			if (tmp0.length < 1) {return [];}
			for (var i:String in tmp0) {
				var t:Array = tmp0[int(i)].split('/n');
				if (t.length < 1) {tmp0[int(i)] = ''; continue;}
				tmp0[int(i)] = {};
				for (var ii:String in t) {
					t[ii] = t[ii].split('=');
					if ((t[ii].length < 1) || (t[ii].length == 1 && t[ii][0].length<1)) {tmp0[int(i)] = '';break;}// invalid property
					if (t[ii].length == 2){tmp0[int(i)][t[ii][0]] = t[ii][1];} else if (t[ii].length == 1) {tmp0[i][t[ii][0]] = null;}
				}
			}
			for (var i0:* in tmp0) { if (typeof (tmp0[i0]) == 'object') {tmp1.push(tmp0[i0]);}}
			return tmp1;
		}
		
		/**
		 * returns string representation of object <strong>ATTENTION!! NOT TESTED WELL SINCE LAST MODIFICATION!!</strong>
		 * @param	a target object
		 * @param map filters data using L.swm with <code>map</code>
		 * @return string representation of object
		 */
		public static function objtostr (a:Object, map:Array=null):String {
			if (!(a is Array)) {a = [a];}
			var tmp0:Object;
			var tmp1:String = '<data>';
			for (var i:String in a) {
				if (a[i] != null) {
					tmp0 = swm(null, a[i], map);
					for (var ii:String in tmp0) {tmp1 += ii+'='+tmp0[ii]+'/n';}// to do : don't add empty objects
					tmp1 = tmp1.substring(0,tmp1.length-'/n'.length);
					tmp1 += ((int(i) < a.length - 1)?'/o':'');
				}
			}
			return tmp1+'</data>';
		}
		
		/**
		 * 
		 * @param	targetString
		 * @param	replaceBy [item:String, ...]
		 * @param	argumentPrefix
		 * @return
		 */
		public static function replaceArgumentsInString (targetString:String, replaceBy:Array, argumentPrefix:String = "%"):String {
			var l:uint = replaceBy.length
			for (var i:uint = 0;i < l;i++ ) {
				if (targetString.indexOf(argumentPrefix+ i)) {
					targetString = targetString.replace(argumentPrefix+i, replaceBy[i]);
				}
			}
			return targetString;
		}
		
		/**
		 * deletes item from array
		 * @param	targetArray
		 * @param	item
		 * @return true if item was found in array
		 */
		public static function deleteItemFromArray(targetArray:Array, item:*):Boolean 
		{
			var l:uint = targetArray.length;
			for (var dd:uint = 0;dd < l;dd++ ) {
				if (targetArray[dd] == item) {
					targetArray.splice(dd, 1);
					return true;
				}
			}
			return false;
		}
		
		
		public static var TS_THIS:String = "//this//";
		
		private static var match$0:Boolean;
		
		
	}
}

//{ =^_^= History
/* > (timestamp) [ ("+" (added) ) || ("-" (removed) ) || ("*" (modified) )] (text)
 * > + traceObject
 * > * traceObject, tested
 * > 30.01.2012_21#47#32 * traceObject removed redundant and wrong code
 * > 27.02.2012_17#25#09 + callMethods
 */
//} =^_^= END OF History

// template last modified:03.05.2010_[22#42#27]_[1]