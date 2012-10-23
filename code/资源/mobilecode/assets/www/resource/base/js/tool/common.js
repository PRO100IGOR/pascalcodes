/*
	ͨ�÷���
	$.getAjax(url,params,fun); jquery�첽��ȡ����
	$.encode(strIn); ���֡������ַ�����Ϊunicode����
	$.decode(strIn); ��unicode���뻹ԭ
	$.arr2Str(arr); ������arrת��Ϊ�ַ���
	$.obj2Str(obj); ��json����objת��Ϊ�ַ���
	$.saveCookie(name, value, time); ����cookie
	$.getCookie(name); ��ȡcookie
	$.delCookie(name); ɾ��cookie
	$.imPortJs(src, charset); ����js
	$.importCss(src); ����css
	$.getLength(str); ��ȡ�ַ������ȣ�����ȫ�ǡ����
	$.calcTime(date1c,date2c,mi); ����date1��date2֮�����ʱ���,data1/date2�����ַ���
	$.getDate(da); ���ַ���daת��Ϊdate����
	$.formatDate(dateobj); ��ʽ��ʱ���ַ���
	$.alert(msg,callbak); ���ݷ��ʻ�����ͬ������ʾ
	$.confirm(msg,function(ok){}); ѯ�ʣ�okΪtrue��false
	$.goto(url,needHistory); ���ݲ�ͬ ������תҳ��
	$.msg(msg); tip��ʾ
	$.changeTheme(theme); �ı���ʽ
	$.getParam(paramname); ��ȡ��ַ���еĲ���
	$.exit(); �˳�app 
	$.http(url,data,callBack,error,async,timeout); //http����
	$.urlAddParam(url,paramName,paramValue); //Ϊurl��Ӳ������Զ����?����&
	$.noteMsg(msg,clear); //���淽ʽ��ʾ��Ϣ
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
		jquery�첽��ȡ���ݣ�������
		url ��ַ
		params ���ݲ�����json��װ
		fun ����ɹ�����÷���
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
		���֡������ַ�����Ϊunicode����
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
		��unicode���뻹ԭ
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
		����ת��Ϊ�ַ���
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
		��json����objת��Ϊ�ַ���
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
		����cookie��timeΪ0��ʾ�����˳�����ʧ
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
		��ȡcookie
	*/
    $.getCookie = function(name) {
        var arrStr = document.cookie.split("; ");
        for (var i = 0; i < arrStr.length; i++) {
            var temp = arrStr[i].split("=");
            if (temp[0] == objName) return temp[1];
        }
    };

    /*
		ɾ��cookie
	*/
    $.delCookie = function(name) {
        var date = new Date();
        date.setTime(date.getTime() - 10000);
        document.cookie = name + "=a; expires=" + date.toGMTString();
    };

    /**
	 * ����js
	 */
    $.imPortJs = function(src, charset) {
        charset = charset || "UTF-8";
        document.write("<script src=\"" + src + "\" charset=\"" + charset + "\" ></script>");
    };
    /**
	 * ����css
	 */
    $.importCss = function(src) {
        document.write("<link href=\"" + src + "\" rel=\"stylesheet\" type=\"text/css\">");
    };

    /**
	 * ��ȡ�ַ������ȣ�����ȫ�ǡ����
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
		����date1��date2֮�����ʱ���
		date��ʽ:2002-02-02 10:10����2002-02-02 10:10:00
		mi��ʾ���صĵ�λ   ����:m ��:s ����: M Сʱ: h ��: d
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
		����date����ָ������date��
		��ʽΪ2002-02-02 10:10����2002-02-02 10:10:00
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
			//����
			{
				date:ʱ��Ĭ��Ϊ��ǰʱ��,
				format:��ʽĬ�ϣ�yyyy-MM-dd
			}
			˵��:  ��(M)����(d)��12Сʱ(h)��24Сʱ(H)����(m)����(s)����(E)������(q) ������ 1-2 ��ռλ��
			��(y)������ 1-4 ��ռλ����
			����(S)ֻ���� 1 ��ռλ��(�� 1-3 λ������)�磺
			("yyyy-MM-dd hh:mm:ss.S") ==> 2006-07-02 08:09:04.423
			 ||("yyyy-MM-dd E HH:mm:ss") ==> 2009-03-10 �� 20:09:04
			 ||("yyyy-MM-dd EE hh:mm:ss") ==> 2009-03-10 �ܶ� 08:09:04
			  ||("yyyy-MM-dd EEE hh:mm:ss") ==> 2009-03-10 ���ڶ� 08:09:04
			   ||("yyyy-M-d h:m:s.S") ==> 2006-7-2 8:9:4.18
			    ,date:Ĭ�ϵ�ǰʱ��,����ʱ���봫���ַ����� 2002-02-02 10:10:00 ֮��
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
                //�·�
                "d+": getDate(),
                //��
                "h+": getHours() % 12 == 0 ? 12 : getHours() % 12,
                //Сʱ
                "H+": getHours(),
                //Сʱ
                "m+": getMinutes(),
                //��
                "s+": getSeconds(),
                //��
                "q+": Math.floor((getMonth() + 3) / 3),
                //����
                "S": getMilliseconds() //����
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
		��ʾ��Ϣ��
		msg ����
		callbak �ص�����
	*/
	$.alert = function(msg,callbak){
		if(navigator.notification)
			navigator.notification.alert(msg,(callbak || function(){}),"��ʾ","ȷ��");
		else
			alert(msg);
	};
	/*
		ѯ����Ϣ��
		msg ����,bak�ص�������������boolean
	*/
	$.confirm = function(msg,btns,bak){
		if(navigator.notification)
			navigator.notification.confirm(msg,function(d){
				bak(d==1);
			},"����",btns);
		else
			bak(confirm(msg));
	};
	/*
	 * �˳�����
	 */
	$.exit = function(){
		if(navigator.notification)
			navigator.app.exitApp();
	};
	/*
		���ݲ�ͬ ������תҳ��
		url ��ַ
		needHistyry : �Ƿ�����ʷ��¼����ѡ��Ĭ��true
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
		tip��ʾ
		msg
		autoHide �Ƿ��Զ����أ�Ĭ��false
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

	/*�ı�Ƥ��*/
	$.changeTheme = function(theme,titleTheme){
		$("div").attr("data-theme",theme).attr("data-dividertheme",titleTheme).attr("data-content-theme",titleTheme);
		$("ul").attr("data-theme",theme).attr("data-dividertheme",titleTheme);
		$("ol").attr("data-theme",theme).attr("data-dividertheme",titleTheme);
	};
	
	/*
		��ȡ����
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
		http����ʹ��jsonp��ʽ���ҷ�������������ʱ�ص�����������oxhide�����磺
		
		response.getWriter().write("oxhide("+result+ ")");
		
		url ��ַ
		data ���͵Ĳ�����json��ֵ��,���紫�ݲ��� {"username":"cc","password":"88888"},���ڷ������п���request.getParameter("username")��ȡ����
		callBack �ص����������в���data���Ǵӷ��������ص�����,
		error ��������ʱ�ص�����
		�Ƿ��첽������Ĭ��true
		timeout ��ʱʱ�䣬Ĭ��5000
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
	 	 Ϊurl��Ӳ������Զ����?����&
	 	��
	 	 url = 10.10.0.141:8083/oxhide/organLoadAction.do?action=showList
	 	 paramName = mobile
	 	 paramValue = 1
	 	 ��ô ������Ϊ	10.10.0.141:8083/oxhide/organLoadAction.do?action=showList&mobile=1
	        ��	
	    url = 10.10.0.141:8083/oxhide    
	 	paramName = mobile
	 	paramValue = 1
	 	��ô ������Ϊ	10.10.0.141:8083/oxhide?mobile=1
	 */
	$.urlAddParam = function(url,paramName,paramValue){
		return url.indexOf("?") > -1 ? (url + "&" + paramName + "=" + paramValue) : (url + "?" + paramName + "=" + paramValue);
	}
	
	/**
	 * ���淽ʽ��ʾ��Ϣ,
	 * msg:����,clear �Ƿ����ԭ����Ϣ
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