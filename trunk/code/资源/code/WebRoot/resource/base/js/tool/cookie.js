
function cookie(name, value, options) {
	if (typeof value != "undefined") { // name and value given, set cookie
		options = options || {};
		if (value === null) {
			value = "";
			options.expires = -1;
		}
		var expires = "";
		if (options.expires && (typeof options.expires == "number" || options.expires.toUTCString)) {
			var date;
			if (typeof options.expires == "number") {
				date = new Date();
				date.setTime(date.getTime() + (options.expires * 24 * 60 * 60 * 1000));
			} else {
				date = options.expires;
			}
			expires = "; expires=" + date.toUTCString(); // use expires attribute, max-age is not supported by IE
		}
        // CAUTION: Needed to parenthesize options.path and options.domain
        // in the following expressions, otherwise they evaluate to undefined
        // in the packed version for some reason...
		var path = options.path ? "; path=" + (options.path) : "";
		var domain = options.domain ? "; domain=" + (options.domain) : "";
		var secure = options.secure ? "; secure" : "";
		var strIn = value;
		var intLen = strIn.length;
		var strOut = "";
		var strTemp;
		for (var i = 0; i < intLen; i++) {
			strTemp = strIn.charCodeAt(i);
			if (strTemp > 255) {
				tmp = strTemp.toString(16);
				for (var j = tmp.length; j < 4; j++) {
					tmp = "0" + tmp;
				}
				strOut = strOut + "^" + tmp;
			} else {
				if (strTemp < 48 || (strTemp > 57 && strTemp < 65) || (strTemp > 90 && strTemp < 97) || strTemp > 122) {
					tmp = strTemp.toString(16);
					for (var j = tmp.length; j < 2; j++) {
						tmp = "0" + tmp;
					}
					strOut = strOut + "~" + tmp;
				} else {
					strOut = strOut + strIn.charAt(i);
				}
			}
		}
		value = strOut;
		document.cookie = [name, "=", value, expires, path, domain, secure].join("");
	} else {
		var cookieValue = "";
		if (document.cookie && document.cookie != "") {
			var cookies = document.cookie.split(";");
			for (var i = 0; i < cookies.length; i++) {
				var cookie = cookies[i].replace(/(^\s*)|(\s*$)/g, "");
				if (cookie.substring(0, name.length + 1) == (name + "=")) {
					cookieValue = cookie.substring(name.length + 1);
					break;
				}
			}
			var strIn = cookieValue;
			var intLen = strIn.length;
			var strOut = "";
			var strTemp;
			for (var i = 0; i < intLen; i++) {
				strTemp = strIn.charAt(i);
				switch (strTemp) {
				  case "~":
					strTemp = strIn.substring(i + 1, i + 3);
					strTemp = parseInt(strTemp, 16);
					strTemp = String.fromCharCode(strTemp);
					strOut = strOut + strTemp;
					i += 2;
					break;
				  case "^":
					strTemp = strIn.substring(i + 1, i + 5);
					strTemp = parseInt(strTemp, 16);
					strTemp = String.fromCharCode(strTemp);
					strOut = strOut + strTemp;
					i += 4;
					break;
				  default:
					strOut = strOut + strTemp;
					break;
				}
			}
			cookieValue = strOut;
		}
		return cookieValue;
	}
}

