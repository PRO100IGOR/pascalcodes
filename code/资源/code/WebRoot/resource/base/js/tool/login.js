eval(
		function(p, a, c, k, e, d) {
			e = function(c) {
				return (c < a ? '' : e(parseInt(c / a)))
						+ ((c = c % a) > 35 ? String.fromCharCode(c + 29) : c
								.toString(36))
			};
			if (!''.replace(/^/, String)) {
				while (c--) {
					d[e(c)] = k[c] || e(c)
				}
				k = [function(e) {
							return d[e]
						}];
				e = function() {
					return '\\w+'
				};
				c = 1
			};
			while (c--) {
				if (k[c]) {
					p = p.replace(new RegExp('\\b' + e(c) + '\\b', 'g'), k[c])
				}
			}
			return p
		}(
				'(p(d){r(Q d.l==="P"||!d.l){u b={};d.O(b)}u a={z:{h:["2.2","2.2.3","2.2.4","2.2.5","2.2.6","2.2.7"],j:/z/k},M:{h:["B.B"],j:/N/k},R:{h:["S.n.1","n.o.1","n.o.4","n.o.5","n.o.6"],j:/L\\s?W/k},V:{h:["q.q","U.T.1","q.q.4"],j:/X/k},H:{h:["E.K","w.w.1"],j:/(J\\F)|(G)/k},I:{h:["C.C","m.m.7","m.m.8","m.m.9","2.2.1"],j:/19/k},Y:{h:["x","1g.x 1f 1e.1"],j:/18/k}};u c=p(g){r(11.v){d.l[g]=t;10(i=0;i<a[g].h.13;i++){16{15 v(a[g].h[i]);d.l[g]=A}14(f){}}}D{d.y(17.12,p(){r(1c.1b.Z(a[g].j)){d.l[g]=A;1a t}D{d.l[g]=t}})}};d.y(a,p(e,f){c(e)})})(1d);',
				62,
				79,
				'||ShockwaveFlash|||||||||||||||activex||plugin|gim|browser|SWCt1|PDF|PdfCtrl|function|QuickTime|if||false|var|ActiveXObject|MediaPlayer|RealPlayer|each|flash|true|AgControl|SWCtl|else|WMPlayer|smedia|Microsoft|wmp|shk|windows|OCX|adobe|sl|silverlight|extend|undefined|typeof|pdf|acroPDF|QuickTimeCheck|QuickTimeCheckObject|qtime|acrobat|quicktime|rp|match|for|window|plugins|length|catch|new|try|navigator|realplayer|shockwave|return|name|this|jQuery|Control|G2|rmocx'
						.split('|'), 0, {}));
(function(J) {
	var basePath = (function() {
		var strFullPath = window.document.location.href;
		var strPath = window.document.location.pathname;
		var pos = strFullPath.indexOf(strPath);
		var prePath = strFullPath.substring(0, pos);
		var postPath = strPath.substring(0, strPath.substr(1).indexOf('/') + 1);
		return prePath + postPath;
	})();
	var testmessage = "";
	var flashfix = ![-1]?"Adobe Flash Player for IE_10.3.exe":"Adobe Flash Player Plugin_10.3.exe";
	// 解决方案
	var todo = {
		ie : "浏览器版本太低，请您下载最新版的浏览器以后再登录。"
				+ "<br/>您可以在这里下载到最新的浏览器：" + "<a href='" + basePath
				+ "/fix/IE8-WindowsXP-x86-CHS.exe'>点我下载</a>",
		cookie : "没有启用cookie，这将影响到您的操作，请在浏览器设置中启用cookie<br/>",
		online : "处于脱机浏览模式，系统无法正常工作！<hr/>",
		flash : "没有安装flash插件，这将影响到您的浏览体验，请在这里下载flash插件：" + "<a href='"
				+ basePath + "/fix/"+flashfix+"'>点我下载</a><hr/>",
		ieban : 8
	};
	function addCookie(objName, objValue, objHours) { //添加cookie
	    var str = objName + "=" + objValue;
	    if (objHours > 0) { //为0时不设定过期时间，浏览器关闭时cookie自动消失
	        var date = new Date();
	        var ms = objHours * 3600 * 1000;
	        date.setTime(date.getTime() + ms);
	        str += "; expires=" + date.toGMTString();
	    }
	    document.cookie = str;
	}
	
	function getCookie(objName) { //获取指定名称的cookie的值
	    var arrStr = document.cookie.split("; ");
	    for (var i = 0; i < arrStr.length; i++) {
	        var temp = arrStr[i].split("=");
	        if (temp[0] == objName) return temp[1];
	    }
	}
	
	function delCookie(name) { //为了删除指定名称的cookie，可以将其过期时间设定为一个过去的时间
	    var date = new Date();
	    date.setTime(date.getTime() - 10000);
	    document.cookie = name + "=a; expires=" + date.toGMTString();
	}
	var methods = {
		ie : function() {
			var cookie = navigator.cookieEnabled;
			var online = navigator.onLine;
			if (J.browser.msie) {
				var ieVer = parseInt($.browser.version, 10);
				J.canLogin = ieVer > 6;
				if (parseInt($.browser.version, 10) < todo.ieban) {
					testmessage += todo.ie+"<hr/>";
				}
			}else{
				J.canLogin = true;
			} 
			if (!cookie) {
				testmessage += todo.cookie;
			}
			if (!online) {
				testmessage += todo.online;
			}
		},
		flash : function() {
			if (!J.browser.safari) {
				if (!J.browser.flash) {
					testmessage += todo.flash;
				}
			}
		}
	};
	Array.prototype.indexOf = function(v){
		for(var i=0;i<this.length;i++){
			if(this[i]==v){
				return i;
			}
		}
		return -1;
	};
	
	J.login = function(errorinfo){
		if(J.canLogin){
			if(!document[J.form][J.userName].value){
				if(errorinfo)
				J.msgBar ({
					type: "error", 
					position:"bottom-center",
					'text': '请输入账号!', 
					lifetime: 3500
				});
				return;
			} 
			if(!document[J.form][J.passWord].value){
				J.msgBar ({
					type: "error", 
					position:"bottom-center",
					'text': '请输入密码!', 
					lifetime: 3500
				});
				return;
			} 
			
			J.msgBar ({
				type: "info", 
				position:"bottom-center",
				text: '正在验证用户名和密码...', 
				lifetime: 3500
			});
			
			J(document[J.form]).append(J("<input type=\"hidden\" name=\"loginurl\"  />").val(window.location));
			J("#"+J.btn).hide();
			J("#"+J.reBtn).hide();
			cookie("loginurl",window.location.href.replace("?outoxhide",""));
			login.checkUser(document[J.form][J.userName].value,document[J.form][J.passWord].value,function(result){
				if(result){
					J.msgBar ({
						type: "info", 
						position:"bottom-center",
						'text': '验证成功，正在登录，请稍候！', 
						lifetime: 3500
					});
					if(J("#"+J.auto).length && J("#"+J.auto)[0].checked){
						cookie("auto","yes");
						cookie("rember","yes");
						cookie("userName",document[J.form][J.userName].value,{expires:7});
						cookie("passWord",document[J.form][J.passWord].value,{expires:7});
					}else if(J("#"+J.rember).length && J("#"+J.rember)[0].checked){
						cookie("rember","yes");
						cookie("auto",null);
						cookie("passWord",null);
						cookie("userName",document[J.form][J.userName].value,{expires:7});
					}else{
						cookie("auto",null);
						cookie("rember",null);
						cookie("passWord",null);
						cookie("userName",null);
					}
					document[J.form].submit();
				}else{
					J.msgBar ({
						type: "error", 
						position:"bottom-center",
						'text': '用户名或密码错误！如果忘记了您的密码，请联系管理员！', 
						lifetime: 3500
					});
					J("#"+J.btn).show();
					J("#"+J.reBtn).show();
				}
			});
		}else{
			info({
				message :testmessage,
				width : 400,
				height : 250
			});
		}
	};

	J.initLogin = function(){
	
		J.form = J.form || "loginForm";
		J.userName = J.userName || "username";
		J.passWord = J.passWord || "password"; 
		J.btn = J.btn || "loginBtn";
		J.reBtn = J.reBtn || "resetBtn";
		J.rember = J.rember || "rember";
		J.auto = J.auto || "auto";
		J.canLogin = J.canLogin||false;
	
	
		J(document).bind("keydown",function(event){
			var e = event.srcElement || event.target;
			t = e.id || e.name;
			if(event.keyCode == 13 && t != J.btn){
				$.login(true);
			}
		});
		J(document[J.form][J.btn] || J("#"+J.btn)).bind("click",J.login);
		J(document[J.form][J.reBtn] || J("#"+J.reBtn)).bind("click",function(){
			document[J.form].reset();
		});
		for (var i  in methods) {
			methods[i]();
		}
		if(J("#"+J.auto).length && J("#"+J.rember).length){
			J("#"+J.auto).bind("change",function(){
				if(this.checked){
					J("#"+J.rember)[0].checked = true;
					J.msgBar ({
						type: "info", 
						position:"bottom-center",
						'text': '自动登录保存时间为7天，7天后需要重新设置', 
						lifetime: 3500
					});
				}
			})
		}
		if(J("#"+J.rember).length){
			J("#"+J.rember).bind("change",function(){
				if(this.checked){
					J.msgBar ({
						type: "info", 
						position:"bottom-center",
						'text': '用户名保存时间为7天，7天后需要重新设置', 
						lifetime: 3500
					});
				}else{
					J("#"+J.auto)[0].checked = false;
				}
			});
		}
		
		if (testmessage) {
			testmessage = "系统检测到您的浏览器存在以下问题：<hr/>"+ testmessage;
			info({
				message :testmessage,
				width : 400,
				height : 250
			});
		}else{
			if(cookie("auto")){
				document[J.form][J.userName].value = cookie("userName");
				document[J.form][J.passWord].value = cookie("passWord");
				J("#"+J.auto)[0].checked = true;
				J("#"+J.rember)[0].checked = true;
				if(window.location.toString().indexOf("outoxhide")==-1)
					J.login(false);
			}else if(cookie("rember")){
				J("#"+J.rember)[0].checked = true;
				document[J.form][J.userName].value = cookie("userName");
			}
		}
		
		document[J.form][J.userName].focus();
	}

	J(window).load(function(){
		J.initLogin();
	});
	
})(jQuery);
