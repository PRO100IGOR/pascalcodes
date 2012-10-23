/*
	通用方法
	$.getAjax(url,params,fun); jquery异步获取数据
	$.encode(strIn); 汉字、特殊字符加码为unicode编码
	$.decode(strIn); 将unicode编码还原
	$.arr2Str(arr); 将数组arr转换为字符串
	$.obj2Str(obj); 将json对象obj转换为字符串
	$.saveCookie(name, value, time); 增加cookie
	$.getCookie(name); 获取cookie
	$.delCookie(name); 删除cookie
	$.imPortJs(src, charset); 导入js
	$.importCss(src); 导入css
	$.getLength(str); 获取字符串长度，根据全角、半角
	$.calcTime(date1c,date2c,mi); 返回date1、date2之间相隔时间差,data1/date2都是字符串
	$.getDate(da); 将字符串da转换为date对象
	$.formatDate(dateobj); 格式化时间字符串
	$.alert(msg,callbak); 根据访问环境不同弹出提示
	$.confirm(msg,function(ok){}); 询问，ok为true、false
	$.goto(url,needHistory); 根据不同 环境跳转页面
	$.msg(msg); tip提示
	$.changeTheme(theme); 改变样式
	$.getParam(paramname); 获取地址拦中的参数
	$.exit(); 退出app 
	$.http(url,data,callBack,error,async,timeout); //http请求
	$.urlAddParam(url,paramName,paramValue); //为url添加参数，自动添加?或者&
	$.noteMsg(msg,clear); //公告方式提示消息
*/
(function($) {

    String.prototype.replaceAll = function(s1, s2) {
        return this.replace(new RegExp(s1, "gm"), s2);
    };
    String.prototype.trim = function() {
        return this.replace(/(^\s*)|(\s*$)/g, "");
    };
    String.prototype.ltrim = function() {
        return this.replace(/(^\s*)/g, "");
    };
    String.prototype.rtrim = function() {
        return this.replace(/(\s*$)/g, "");
    };
    
    /*
		jquery异步获取数据，参数：
		url 地址
		params 传递参数，json封装
		fun 请求成功后调用方法
	*/
    $.getAjax = function(url, params, fun) {
        $.ajax({
            url: url,
            dataType: 'script',
            data: params,
            success: function() {
                fun(result);
            }
        });
    };

    /*
		汉字、特殊字符加码为unicode编码
	*/
    $.encode = function(strIn) {
        var intLen = strIn.length;
        var strOut = "";
        var strTemp;

        for (var i = 0; i < intLen; i++) {
            strTemp = strIn.charCodeAt(i);
            if (strTemp > 255) {
                tmp = strTemp.toString(16);
                for (var j = tmp.length; j < 4; j++) tmp = "0" + tmp;
                strOut = strOut + "^" + tmp;
            } else {
                if (strTemp < 48 || (strTemp > 57 && strTemp < 65) || (strTemp > 90 && strTemp < 97) || strTemp > 122) {
                    tmp = strTemp.toString(16);
                    for (var j = tmp.length; j < 2; j++) tmp = "0" + tmp;
                    strOut = strOut + "~" + tmp;
                } else {
                    strOut = strOut + strIn.charAt(i);
                }
            }
        }
        return (strOut);
    };

    /*
		将unicode编码还原
	*/
    $.decode = function(strIn) {
        var intLen = strIn.length;
        var strOut = "";
        var strTemp;

        for (var i = 0; i < intLen; i++) {
            strTemp = strIn.charAt(i);
            switch (strTemp) {
            case "~":
                {
                    strTemp = strIn.substring(i + 1, i + 3);
                    strTemp = parseInt(strTemp, 16);
                    strTemp = String.fromCharCode(strTemp);
                    strOut = strOut + strTemp;
                    i += 2;
                    break;
                }
            case "^":
                {
                    strTemp = strIn.substring(i + 1, i + 5);
                    strTemp = parseInt(strTemp, 16);
                    strTemp = String.fromCharCode(strTemp);
                    strOut = strOut + strTemp;
                    i += 4;
                    break;
                }
            default:
                {
                    strOut = strOut + strTemp;
                    break;
                }
            }
        }
        return (strOut);
    };

    /*
		数组转换为字符串
	*/
    $.arr2Str = function(arr) {
        var temp = ["["];
        for (var i = 0; i < arr.length; i++) {
            temp.push("'" + $.obj2Str(arr[i]) + "'");
        }
        temp.push("]");
        return temp.join("");
    };

    /*
		将json对象obj转换为字符串
	*/
    $.obj2Str = function(o) {
        var r = [];
        if (typeof o == "string" || o == null) {
            return "\"" + o + "\"";
        }
        if (typeof o == "object") {
            if (!o.sort) {
                r[0] = "{";
                var temp = false;
                for (var i in o) {
                    r[r.length] = "\"" + i + "\"";
                    r[r.length] = ":";
                    r[r.length] = $.obj2Str(o[i]);
                    r[r.length] = ",";
                    temp = true;
                }
                r[temp ? r.length - 1 : r.length] = "}"
            } else {
                r[0] = "[";
                var temp = false;
                for (var i = 0; i < o.length; i++) {
                    r[r.length] = $.obj2Str(o[i]);
                    r[r.length] = ",";
                    temp = true;
                }
                r[temp ? r.length - 1 : r.length] = "]"
            }
            return r.join("");
        }
        return o.toString();
    };

    /*
		增加cookie，time为0表示程序退出则消失
	*/
    $.saveCookie = function(name, value, time) {
        var str = name + "=" + value;
        if (time > 0) {
            var date = new Date();
            var ms = time * 3600 * 1000;
            date.setTime(date.getTime() + ms);
            str += "; expires=" + date.toGMTString();
        }
        document.cookie = str;
    };
    /*
		获取cookie
	*/
    $.getCookie = function(name) {
        var arrStr = document.cookie.split("; ");
        for (var i = 0; i < arrStr.length; i++) {
            var temp = arrStr[i].split("=");
            if (temp[0] == objName) return temp[1];
        }
    };

    /*
		删除cookie
	*/
    $.delCookie = function(name) {
        var date = new Date();
        date.setTime(date.getTime() - 10000);
        document.cookie = name + "=a; expires=" + date.toGMTString();
    };

    /**
	 * 导入js
	 */
    $.imPortJs = function(src, charset) {
        charset = charset || "UTF-8";
        document.write("<script src=\"" + src + "\" charset=\"" + charset + "\" ></script>");
    };
    /**
	 * 导入css
	 */
    $.importCss = function(src) {
        document.write("<link href=\"" + src + "\" rel=\"stylesheet\" type=\"text/css\">");
    };

    /**
	 * 获取字符串长度，根据全角、半角
	 */
    $.getLength = function(value) {
        var lengthSelf = 0;
        for (var i = 0; i < value.length; i++) {
            if (value.charCodeAt(i) < 27 || value.charCodeAt(i) > 126) lengthSelf += 2;
            else lengthSelf++;
        }
        return lengthSelf;
    };

    /*
		返回date1、date2之间相隔时间差
		date格式:2002-02-02 10:10或者2002-02-02 10:10:00
		mi表示返回的单位   毫秒:m 秒:s 分钟: M 小时: h 天: d
	*/
    $.calcTime = function(date1c, date2c, mi) {
        if (date1c.trim() == "" || date2c.trim() == "") return null;
        var date1 = $t.getDate(date1c);
        var date2 = $t.getDate(date2c);
        var maci;
        if (mi == "s") maci = 1000;
        if (mi == "M") maci = 1000 * 60;
        if (mi == "h") maci = 1000 * 60 * 60;
        if (mi == "d") maci = 1000 * 60 * 60 * 24;
        if (mi == "m") maci = 1;
        return Math.round(date1 / maci) - Math.round(date2 / maci);
    };
    /**
		返回date对象，指定日期date，
		格式为2002-02-02 10:10或者2002-02-02 10:10:00
	**/
    $.getDate = function(da) {
        var arr = da.split(" ");
        var arr1 = arr[0].split("-");
        var arr2 = arr[1].split(":");
        for (var i = 0; i < 3; i++) {
            if (!arr1[i]) arr1[i] = "00";
            if (!arr2[i]) arr2[i] = "00";
        }
        var date = new Date(arr1[0], arr1[1], arr1[2], arr2[0], arr2[1], arr2[2]);
        return date;
    };
    /**
			//参数
			{
				date:时间默认为当前时间,
				format:格式默认：yyyy-MM-dd
			}
			说明:  月(M)、日(d)、12小时(h)、24小时(H)、分(m)、秒(s)、周(E)、季度(q) 可以用 1-2 个占位符
			年(y)可以用 1-4 个占位符，
			毫秒(S)只能用 1 个占位符(是 1-3 位的数字)如：
			("yyyy-MM-dd hh:mm:ss.S") ==> 2006-07-02 08:09:04.423
			 ||("yyyy-MM-dd E HH:mm:ss") ==> 2009-03-10 二 20:09:04
			 ||("yyyy-MM-dd EE hh:mm:ss") ==> 2009-03-10 周二 08:09:04
			  ||("yyyy-MM-dd EEE hh:mm:ss") ==> 2009-03-10 星期二 08:09:04
			   ||("yyyy-M-d h:m:s.S") ==> 2006-7-2 8:9:4.18
			    ,date:默认当前时间,其他时间请传入字符，如 2002-02-02 10:10:00 之类
		*/
    $.formatDate = function(dateobj) {
        var date;
        var fmt;
        if (!dateobj) {
            date = new Date();
            fmt = "yyyy-MM-dd";
        } else {
            date = dateobj.date ? $t.getDate(dateobj.date) : new Date();
            fmt = dateobj.format || "yyyy-MM-dd hh:mm";
        }
        with(date) {
            var o = {

                "M+": getMonth() + 1,
                //月份
                "d+": getDate(),
                //日
                "h+": getHours() % 12 == 0 ? 12 : getHours() % 12,
                //小时
                "H+": getHours(),
                //小时
                "m+": getMinutes(),
                //分
                "s+": getSeconds(),
                //秒
                "q+": Math.floor((getMonth() + 3) / 3),
                //季度
                "S": getMilliseconds() //毫秒
            };
            var week = {
                "0": "\u65e5",
                "1": "\u4e00",
                "2": "\u4e8c",
                "3": "\u4e09",
                "4": "\u56db",
                "5": "\u4e94",
                "6": "\u516d"
            };
            if (/(y+)/.test(fmt)) fmt = fmt.replace(RegExp.$1, (getFullYear() + "").substr(4 - RegExp.$1.length));
            if (/(E+)/.test(fmt)) fmt = fmt.replace(RegExp.$1, ((RegExp.$1.length > 1) ? (RegExp.$1.length > 2 ? "\u661f\u671f": "\u5468") : "") + week[getDay() + ""]);
            for (var k in o) {
                if (new RegExp("(" + k + ")").test(fmt)) fmt = fmt.replace(RegExp.$1, (RegExp.$1.length == 1) ? (o[k]) : (("00" + o[k]).substr(("" + o[k]).length)));
            }
        }
        return fmt;
    };
	/*
		提示消息，
		msg 内容
		callbak 回调方法
	*/
	$.alert = function(msg,callbak){
		if(navigator.notification)
			navigator.notification.alert(msg,(callbak || function(){}),"提示","确认");
		else
			alert(msg);
	};
	/*
		询问消息，
		msg 内容,bak回调方法，参数是boolean
	*/
	$.confirm = function(msg,btns,bak){
		if(navigator.notification)
			navigator.notification.confirm(msg,function(d){
				bak(d==1);
			},"请问",btns);
		else
			bak(confirm(msg));
	};
	/*
	 * 退出方法
	 */
	$.exit = function(){
		if(navigator.notification)
			navigator.app.exitApp();
	};
	/*
		根据不同 环境跳转页面
		url 地址
		needHistyry : 是否保留历史记录，可选，默认true
	*/
	$.gotourl = function(url,needHistory){
//		var overs = ["slideup","slide","slidedown","fade","flip","turn","flow"];
//		var over = overs[parseInt(Math.random() * 6)];
	    	var over = "slide";
		(needHistory + "").length || (needHistory = true);
		if(needHistory){
			$.mobile.changePage(url,{transition:over});
		}else{
			$.mobile.changePage(url, {transition:over ,reverse: false,changeHash: false});	
		}
	};
	/*
		tip提示
		msg
		autoHide 是否自动隐藏，默认false
	*/
	$.msg = function(msg,autoHide){
		$.mobile.hidePageLoadingMsg();
		if(autoHide){
		$("<div class='ui-loader ui-overlay-shadow ui-body-e ui-corner-all'><h1>"+ msg +"</h1></div>" )
			.css({ "display": "block", "opacity": 0.96, "top":  $( window ).height() - 100 })
			.appendTo( $.mobile.pageContainer)
			.delay( 1000 )
			.fadeOut( 800, function() {
				$( this ).remove();
			});
		}else{
			$.mobile.loadingMessage = msg;
			$.mobile.showPageLoadingMsg(false);
		}
	};

	/*改变皮肤*/
	$.changeTheme = function(theme,titleTheme){
		$("div").attr("data-theme",theme).attr("data-dividertheme",titleTheme).attr("data-content-theme",titleTheme);
		$("ul").attr("data-theme",theme).attr("data-dividertheme",titleTheme);
		$("ol").attr("data-theme",theme).attr("data-dividertheme",titleTheme);
	};
	
	/*
		获取参数
	*/
	$.getParam = function(paramName){
		var sSource = String(window.document.location);
		
		var sName = paramName;
		var sReturn = "";
		var sQUS = "?";
		var sAMP = "&";
		var sEQ = "=";
		var iPos;
		iPos = sSource.indexOf(sQUS);
		if (iPos == -1) return;
		var strQuery = sSource.substr(iPos, sSource.length - iPos);
		var strLCQuery = strQuery.toLowerCase();
		var strLCName = sName.toLowerCase();
		iPos = strLCQuery.indexOf(sQUS + strLCName + sEQ);
		if (iPos == -1) {
			iPos = strLCQuery.indexOf(sAMP + strLCName + sEQ);
		}
		if (iPos != -1) {
			sReturn = strQuery.substr(iPos + sName.length + 2, strQuery.length - (iPos + sName.length + 2));
			var iPosAMP = sReturn.indexOf(sAMP);
			if (iPosAMP == -1) {
				return sReturn;
			} else {
				sReturn = sReturn.substr(0, iPosAMP);
			}
		}
		return sReturn;
	};


	/*
		http请求，使用jsonp方式，且服务器处理请求时回调方法必须是oxhide，例如：
		
		response.getWriter().write("oxhide("+result+ ")");
		
		url 地址
		data 发送的参数，json键值对,例如传递参数 {"username":"cc","password":"88888"},则在服务器中可以request.getParameter("username")获取参数
		callBack 回调函数，必有参数data，是从服务器返回的数据,
		error 发生错误时回调函数
		是否异步操作，默认true
		timeout 超时时间，默认5000
	*/
	$.http = function(url,data,callBack,error,async,timeout){
		(async+"").length || (async = true);
		url = url.indexOf("?") == -1 ? (url + "?callback=?&" + Math.random()) : (url + "&callback=?&" + Math.random());
		$.ajax({
			type: 'post',
			url:url,
			timeout:timeout || 5000,
			dataType: 'jsonp',
			data : data,
			success:function(data){
			    if(data && data.error) {$.msg(data.error,true);}
			    else callBack(data); 
			},
			error:function(jqXHR, textStatus, errorThrown){
				if($.debug){
					$.alert("common.js line 436 " +textStatus + "  url="+url);
				}
				
				if(error)error();
			},
			async:async
		});
	};
	/*
	 	 为url添加参数，自动添加?或者&
	 	如
	 	 url = 10.10.0.141:8083/oxhide/organLoadAction.do?action=showList
	 	 paramName = mobile
	 	 paramValue = 1
	 	 那么 添加完后为	10.10.0.141:8083/oxhide/organLoadAction.do?action=showList&mobile=1
	        如	
	    url = 10.10.0.141:8083/oxhide    
	 	paramName = mobile
	 	paramValue = 1
	 	那么 添加完后为	10.10.0.141:8083/oxhide?mobile=1
	 */
	$.urlAddParam = function(url,paramName,paramValue){
		return url.indexOf("?") > -1 ? (url + "&" + paramName + "=" + paramValue) : (url + "?" + paramName + "=" + paramValue);
	}
	
	/**
	 * 公告方式提示消息,
	 * msg:内容,clear 是否清空原有消息
	 */
	$.noteMsg = function(msg,clear){
              clear && window.msgBar.empty();
    	      var msgBox = $("#msgBox");
    	      msgBox.append($(
    		   [
    		    	"<li>",
    		    	msg,
    		    	"</li>"
    		   ].join("")
    	      ));
    	      window.msgBar.show();
	}
	
	
	$("div[data-role=page]").live("pagecreate",function(e){
		var theme = $.theme || $.sql.map("theme"),titleTheme = $.titleTheme || $.sql.map("titleTheme");
		$.changeTheme(theme,titleTheme); 
    		window.msgBar = $( "<div>" , {
    		    "class": "ui-footer ui-bar-e",
    		    style: "overflow: hide; padding:5px 10px;"
                    }).append(
                        $("<ol/>",{"id":"msgBox"})	
                    ).append(
                        $("<span/>",{
                    	"class":"ui-icon ui-icon-delete ui-icon-shadow",
                    	"style":"position: absolute;top: 5px;left: 5px;"
                        }).bind("click",function(){
                    	window.msgBar.hide();
                        })	
                    );
    		window.msgBar.appendTo($( e.target )).hide();
	});
	
})(jQuery);