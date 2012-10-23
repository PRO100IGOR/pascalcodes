/**
	登录相关js >> data.js,common.js
	Id为username/password/menuContainer 的控件必须存在
	登录需要配置参数:
	$.loginUrl = "http://10.10.0.141:8083/oxhide/loginAction.do?action=login";
	$.appcode = "MKZHYDXXPT"; //要登录的系统编码。必填
	$.modelcode 要登录的模块编码，选填
*/
(function($) {
	
	$.initLogin = function(){
		/*登录事件*/
		$("#loginBtn").bind("click", $.login);

        	$("#autoLogin").bind("click",
        		function(){this.checked && $("#remLogin").attr("checked", true).checkboxradio("refresh");}
		);

        	$("#remLogin").bind("click",
        		function() {!this.checked && $("#autoLogin").attr("checked", false).checkboxradio("refresh");}
		);
		
		if(device.platform == "Android") {
                	$("#exitAll").bind("click",function(){
        			$.confirm("确定注销吗?\n\r注销将清除您保存的账户、密码","确定,取消",function(d){
        				if(d){
        					$.sql.removeMap("menus");
        					$.sql.removeMap("remLogin")
        					$.sql.removeMap("userinfo");
        					$.sql.removeMap("autoLogin");
        					$.sql.removeMap("username");
        					$.sql.removeMap("password");
        					$.sql.removeMap("prompt");
        				}
        				d && $.exit();
        			});
                	});
                	$("#exit").bind("click",function(){
        			$.confirm("确定退出吗?","确定,取消",function(d){
        				if(d){
        					$.sql.removeMap("menus");
        					$.sql.removeMap("userinfo");
        				}
        				d && $.exit();
        			});
                	});
		}else {
		    $("#exitAll").html("清空").bind("click",function(){
        			$.confirm("确定清空数据吗?\n\r将清除您保存的账户、密码，下次登录需要重新输入账户密码","确定,取消",function(d){
        				if(d){
        					$.sql.removeMap("menus");
        					$.sql.removeMap("remLogin")
        					$.sql.removeMap("userinfo");
        					$.sql.removeMap("autoLogin");
        					$.sql.removeMap("username");
        					$.sql.removeMap("password");
        					$.sql.removeMap("prompt");
        				}
        				d && $.exit();
        			});
                	});
		    $("#exit").hide();
		}
        	

        	
        	
        	$("#index").live("pageshow",function(){
        	    if($.sql.map("prompt")) {
        		window.msgBar.children("#msgBox").html($.sql.map("prompt"));
        		//window.msgBar.show();
        		$.sql.removeMap("prompt");
        	    }
        	});
        	
		/*环境检查*/
		if(navigator.network){
			var networkState = navigator.network.connection.type;
			var states = {};
			states[Connection.UNKNOWN]  = '未知网络';
			states[Connection.ETHERNET] = '以太网';
			states[Connection.WIFI]     = 'WiFi';
			states[Connection.CELL_2G]  = '2G网络';
			states[Connection.CELL_3G]  = '3G网络';
			states[Connection.CELL_4G]  = '4G网络';
			states[Connection.NONE]     = '没有网络连接';
			
			if(networkState == Connection.UNKNOWN || networkState == Connection.NONE ){
				$.alert("您没有连接到任何网络!",function(){$.exit();});
			}
			/*回退处理事件*/
			document.addEventListener("backbutton", function(){
				$.confirm("确定退出吗?","确定,取消",function(d){
					if(d){
						$.sql.removeMap("menus");
						$.sql.removeMap("userinfo");
					}
					d && $.exit();
				});
				return false;
			}, false);
			/*处理菜单事件*/
			document.addEventListener("menubutton", function(){
				
			}, false);
			/*处理搜索按钮事件*/
			document.addEventListener("searchbutton", function(){
				
			}, false);
		}
		$.urlN = $.loginUrlN ;
		$.urlW = $.loginUrlW ;
		$.loginUrlN = "http://" + $.loginUrlN + "/oxhide/loginAction.do?action=login&mobile=1";
		$.loginUrlW && ($.loginUrlW = "http://" + $.loginUrlW + "/oxhide/loginAction.do?action=login&mobile=1");
		var rem = $.sql.map("remLogin");
		$("#remLogin").attr("checked", rem).checkboxradio("refresh");
		if (rem == "true") {
			$("#username").val($.sql.map("username"));
			$("#password").val($.sql.map("password"));
		}
		var auto = $.sql.map("autoLogin");
		$("#autoLogin").attr("checked", auto).checkboxradio("refresh");
		if (auto == "true") {
			$.login();
		}
		
		$.sql.map("theme",$.theme);
		$.sql.map("titleTheme",$.titleTheme);
		$.sql.map("errormessage","加载错误!");
		$.mobile.pageLoadErrorMessage = "加载错误!";
	};

	
	/*
		登录方法
	*/
    $.login =  function() {
    	if($.islogin)return;
        var username = $("#username"),
        password = $("#password");
        if (!username.val() || !password.val()) {
            $.msg("帐号或者密码没有输入!",true);
            return;
        }
        $.islogin = false;
        $.sql.map("autoLogin", $("#autoLogin")[0].checked);
        var rem = $("#remLogin")[0].checked;
        $.sql.map("remLogin", rem);
        if (rem) {
            $.sql.map("username", username.val());
            $.sql.map("password", password.val());
        } else {
            $.sql.removeMap("username");
            $.sql.removeMap("password");
        }
		$.msg("正在登陆,请稍后...");
		var data = {
			username: username.val(),
			password: password.val(),
			appcode: $.appcode,
			modelcode: $.modelcode || "",
			type:"tree"
		};
		if(device.platform == "Android") {
		    data.android = device.uuid;
		}else {
		    data.apple = device.uuid;
		}
		$.http(
			$.loginUrlW,
			{
				data:$.obj2Str(data)
			},
			function(data) {
			    	$.sql.map("urls",$.urlN);
				$.islogin = false;
				if(data.message){
					$.msg(data.message,true);
				}else{
					$.explanMenu(data);
					$.gotourl("#index",false);
				}
			},
			function(){
			    	$.msg("登录失败,更换登录服务器..",true);
			    	$.msg("正在登陆,请稍后...");
                        	$.http(
                        	     $.loginUrlN,
                        	     {
                        		data:
                        			$.obj2Str({
                        				username: username.val(),
                        				password: password.val(),
                        				appcode: $.appcode,
                        				modelcode: $.modelcode || "",
                        				type:"tree"
                        			})
                        		},
                        		function(data) {
                        		    	$.sql.map("urls",$.urlW);
                        			$.islogin = false;
                        			if(data.message){
                        				$.msg(data.message,true);
                        			}else{
                        				$.explanMenu(data);
                        				$.gotourl("#index",false);
                        			}
                        		},
                        		function(){
                        			$.islogin = false;
                        			$.msg("登陆失败,请检查网络连接!",true);
                        		},
                        		true
                        	);
			},
			true
		);

	}
		
		
		/*
			解析菜单
		*/
		$.explanMenu = function(data){
			var temp = [];
			for(var i =0;i < data.resource.length;i++){
			    temp = obj2Menu(data.resource[i],temp,data.id,data.resource.length > 1);
			}
			var menus = temp.join("");
			delete data.resource;
			$.sql.map("menus",menus);
			$.sql.map("userinfo",$.obj2Str(data));
			$("#menuContainer").attr("has","yes").html(menus);
		};
		

		
		
		/*
			对象转换为菜单的方法
		*/
		function obj2Menu(obj,menuStr,id,needShow){
		    	/*消息提醒*/
		    	if (obj.prompt) {
            		    $.http(
            			$.urlAddParam($.urlAddParam(obj.prompt,"SESSIONID",id),"mobile","1"),
            			{},
            			function(data){
            			    if (data) {
            				$.noteMsg($.decode(data));
            				$.sql.map("prompt",$("#msgBox").html());
            			    }
            			},
            			function(){},
            			false
            		    ); 
		    	}
		    
			if(!obj.resource.length){
			    	if(!obj.mobileurl) return menuStr;
				obj.mobileurl =  $.urlAddParam(obj.mobileurl,"url",encodeURIComponent($.urlAddParam($.urlAddParam(obj.resourceurl,"SESSIONID",id),"mobile","1"))) ;
				
				return menuStr.concat([
					"<li id='",
					obj.resourceid,
					"_li'> <a class='menus' id='a_",
					obj.resourceid,
					"_a' data-ajax='false' href='",
					obj.mobileurl,
					"'><img src='",
					obj.mobileico,
					"'/>",
					"<h3>",
					obj.resourcename,
					"</h3>",
					"<p>",
					obj.remark,
					"</p>",
					"</a>",
					"</li>"
				]);
			}else{
			    	
				var temp = needShow ? [
					"<li id='",
					obj.resourceid,
					"_li'> <img src='",
					obj.mobileico,
					"'/>",
					"<h3>",
					obj.resourcename,
					"</h3>",
					"<span class='ui-li-count'>",
					obj.resource.length,
					"</span>",
					"<p>",
					obj.remark,
					"</p>",
					"<ul data-role='listview' data-inset='true' data-dividertheme='",
					$.titleTheme,
					"' data-theme='",
					$.theme,
					"'>",
					"<li>",
					"<a class='menus' href='#index'><img src='",
					obj.mobileico,
					"'/>",
					"<h3>返回到",
					obj.resourcename,
					"</h3>",
					"<p>",
					obj.remark,
					"</p>",
					"</a>",
					"</li>"
				] : [
				];
				for(var i = 0;i<obj.resource.length;i++){
					temp = obj2Menu(obj.resource[i],temp,id,obj.resource.length > 1 );
				}
				if(needShow)
				   temp.push("</ul></li>");
				return menuStr.concat(temp);
			}
		}
		
		document.addEventListener("deviceready", function(){
			$.initLogin();
		}, false);
				/*加载菜单事件*/
		if($.sql.map("menus")){
			$("#menuContainer").html($.sql.map("menus"));	
			
		}
})(jQuery);