/*json到str的转换、json到arr的转换、arr到json的转换*/
	function obj2Arr(o){
		var temp = [];
		for(var i in o){
			temp.push(o[i]);
		}
		return temp;
	}
	function arrtostr(arr){
		var temp = ["["];
		for(var i = 0;i<arr.length;i++){
			temp.push("'"+arr[i]+"'");
		}
		temp.push("]");
		return temp.join("");
	}
	function obj2str(o) {
		var r = [];
		if (typeof o == "string" || o == null) {
			return "\""+o+"\"";
		}
		if (typeof o == "object") {
			if (!o.sort) {
				r[0] = "{";
				var temp = false;
				for (var i in o) {
					r[r.length] = "\""+i+"\"";
					r[r.length] = ":";
					r[r.length] = obj2str(o[i]);
					r[r.length] = ",";
					temp = true;
				}
				r[temp ? r.length - 1 : r.length] = "}"
			} else {
				r[0] = "[";
				var temp = false;
				for (var i = 0; i < o.length; i++) {
					r[r.length] = obj2str(o[i]);
					r[r.length] = ",";
					temp = true;
				}
				r[temp ? r.length - 1 : r.length] = "]"
			}
			return r.join("");
		}
		return o.toString();
	}