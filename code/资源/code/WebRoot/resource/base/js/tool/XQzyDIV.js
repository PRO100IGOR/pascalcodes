
function M_XQzyDiv(id) {
	return document.getElementById(id);
}
function MC_XQzyDiv(t) {
	return document.createElement(t);
}
function isIE() {
	return (document.all && window.ActiveXObject && !window.opera) ? true : false;
} 
function getBodySize() {
	var bodySize = [];
	with (document.documentElement) {
		bodySize[0] = (scrollWidth > clientWidth) ? scrollWidth : clientWidth;
		bodySize[1] = (scrollHeight > clientHeight) ? scrollHeight : clientHeight;
	}
	return bodySize;
}
function popCoverDiv() {
	if (M_XQzyDiv("cover_div")) {
		M_XQzyDiv("cover_div").style.display = "block";
	} else {
		var coverDiv = MC_XQzyDiv("div");
		document.body.appendChild(coverDiv);
		coverDiv.id = "cover_div";
		with (coverDiv.style) {
			position = "absolute";
			background = "#CCCCCC";
			left = "0px";
			top = "0px";
			var bodySize = getBodySize();
			width = "100%";
			if (document.documentElement.scrollHeight > document.documentElement.clientHeight) {
				height = (bodySize[1] + document.body.scrollTop) + "px";
			} else {
				height = "100%";
			}
			zIndex = 0;
			if (isIE()) {
				filter = "Alpha(Opacity=0)";
			} else {
				opacity = 0;
			}
		}
	}
}



function showXQzyDIV() {
	var XQzyDIV = M_XQzyDiv("XQzyDIV");
	XQzyDIV.style.display = "block";
}

function change() {
	var XQzyDIV = M_XQzyDiv("XQzyDIV");
	XQzyDIV.style.position = "absolute";
	XQzyDIV.style.border = "1px solid #CCCCCC";
	XQzyDIV.style.background = "#f8f8f8";
	var i = 0;
	var bodySize = getBodySize();
	XQzyDIV.style.width = 220 + "px";
	XQzyDIV.style.height = 32 + "px";
	var sw = document.getElementsByTagName("select");
	for (i = 0; i < sw.length; i++) {
		sw[i].style.visibility = "hidden";
	}  
  	 // popChange(i);
}
function popChange(i) {
	var XQzyDIV = M_XQzyDiv("XQzyDIV");
	var bodySize = getBodySize();
	XQzyDIV.style.width = 220 + "px";
	XQzyDIV.style.height = 32 + "px";
	if (i <= 8) {
		i++;
		setTimeout("popChange(" + i + ")", 20);
	}
}
function XqTipOpen( message) {
	InitializationXQzyDIV( message);
	change();
	showXQzyDIV();
	popCoverDiv();
	document.body.scroll = "no";
	showBackground(M_XQzyDiv("cover_div"), 65);
	void (0);
}
function XqTipClose() {
	try {
		M_XQzyDiv("XQzyDIV").style.display = "none";
		M_XQzyDiv("cover_div").style.display = "none";
		var sw = document.getElementsByTagName("select");
		for (i = 0; i < sw.length; i++) {
			sw[i].style.visibility = "";
		}
		document.body.scroll = "auto";
		void (0);
	}
	catch (e) {
	}
}
function showBackground(obj, endInt) {
	if (isIE()) {
		obj.filters.Alpha.Opacity += 1;
		if (obj.filters.Alpha.Opacity < endInt) {
			setTimeout(function () {
				showBackground(obj, endInt);
			}, 50);
		}
	} else {
		var al = parseFloat(obj.style.opacity);
		al += 0.01;
		obj.style.opacity = al;
		if (al < (endInt / 100)) {
			setTimeout(function () {
				showBackground(obj, endInt);
			}, 50);
		}
	}
} 
function InitializationXQzyDIV(message) {
		var getBasePath= function() {
			var strFullPath = window.document.location.href;
			var strPath = window.document.location.pathname;
			var pos = strFullPath.indexOf(strPath);
			var prePath = strFullPath.substring(0, pos);
			var postPath = strPath.substring(0,
			strPath.substr(1).indexOf('/') + 1);
			return prePath + postPath;
		}
	
	
	if (document.getElementById("XQzyDIV") != null) {
		document.getElementById("XQzyDIV").parentNode.removeChild(document.getElementById("XQzyDIV"));
	}
	message = message || "\u9875\u9762\u52a0\u8f7d\u4e2d\uff0c\u8bf7\u7a0d\u540e..";
	var divff = document.createElement("div");
	divff.id = "XQzyDIV";
	
	divff.style.width = 300;
	divff.style.height = 70;
	divff.style.zIndex = 1000;
	divff.style.top = "50%";
	divff.style.position = "absolute";
	divff.style.left = (document.body.offsetWidth - 300)/2 + "px";
	if(!-[1,]){
		divff.style.marginTop = -35;
	}else{
		divff.style.marginTop = "auto";
	}
	divff.innerHTML = "<table  style=\"width:300px;border:1px black solid;font-size:13px;font-famliy:Î¢ÈíÑÅºÚ;vertical-align: middle;text-align:center;background-color: #F8F8F8\" cellspacing=\"0\" cellpadding=\"0\" height=\"70\"><tr> <td>"+ message + "</td></tr></table>";
	document.body.appendChild(divff);
}

