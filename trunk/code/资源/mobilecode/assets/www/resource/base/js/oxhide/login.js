/**
	��¼���js >> data.js,common.js
	IdΪusername/password/menuContainer �Ŀؼ��������
	��¼��Ҫ���ò���:
	$.loginUrl = "http://10.10.0.141:8083/oxhide/loginAction.do?action=login";
	$.appcode = "MKZHYDXXPT"; //Ҫ��¼��ϵͳ���롣����
	$.modelcode Ҫ��¼��ģ����룬ѡ��
*/
(function($) {
	
	$.initLogin = function(){
		/*��¼�¼�*/
		$("#loginBtn").bind("click", $.login);

        	$("#autoLogin").bind("click",
        		function(){this.checked && $("#remLogin").attr("checked", true).checkboxradio("refresh");}
		);

        	$("#remLogin").bind("click",
        		function() {!this.checked && $("#autoLogin").attr("checked", false).checkboxradio("refresh");}
		);
		
		if(device.platform == "Android") {
                	$("#exitAll").bind("click",function(){
        			$.confirm("ȷ��ע����?\n\rע���������������˻�������","ȷ��,ȡ��",function(d){
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
        			$.confirm("ȷ���˳���?","ȷ��,ȡ��",function(d){
        				if(d){
        					$.sql.removeMap("menus");
        					$.sql.removeMap("userinfo");
        				}
        				d && $.exit();
        			});
                	});
		}else {
		    $("#exitAll").html("���").bind("click",function(){
        			$.confirm("ȷ�����������?\n\r�������������˻������룬�´ε�¼��Ҫ���������˻�����","ȷ��,ȡ��",function(d){
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
        	
		/*�������*/
		if(navigator.network){
			var networkState = navigator.network.connection.type;
			var states = {};
			states[Connection.UNKNOWN]  = 'δ֪����';
			states[Connection.ETHERNET] = '��̫��';
			states[Connection.WIFI]     = 'WiFi';
			states[Connection.CELL_2G]  = '2G����';
			states[Connection.CELL_3G]  = '3G����';
			states[Connection.CELL_4G]  = '4G����';
			states[Connection.NONE]     = 'û����������';
			
			if(networkState == Connection.UNKNOWN || networkState == Connection.NONE ){
				$.alert("��û�����ӵ��κ�����!",function(){$.exit();});
			}
			/*���˴����¼�*/
			document.addEventListener("backbutton", function(){
				$.confirm("ȷ���˳���?","ȷ��,ȡ��",function(d){
					if(d){
						$.sql.removeMap("menus");
						$.sql.removeMap("userinfo");
					}
					d && $.exit();
				});
				return false;
			}, false);
			/*����˵��¼�*/
			document.addEventListener("menubutton", function(){
				
			}, false);
			/*����������ť�¼�*/
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
		$.sql.map("errormessage","���ش���!");
		$.mobile.pageLoadErrorMessage = "���ش���!";
	};

	
	/*
		��¼����
	*/
    $.login =  function() {
    	if($.islogin)return;
        var username = $("#username"),
        password = $("#password");
        if (!username.val() || !password.val()) {
            $.msg("�ʺŻ�������û������!",true);
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
		$.msg("���ڵ�½,���Ժ�...");
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
			    	$.msg("��¼ʧ��,������¼������..",true);
			    	$.msg("���ڵ�½,���Ժ�...");
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
                        			$.msg("��½ʧ��,������������!",true);
                        		},
                        		true
                        	);
			},
			true
		);

	}
		
		
		/*
			�����˵�
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
			����ת��Ϊ�˵��ķ���
		*/
		function obj2Menu(obj,menuStr,id,needShow){
		    	/*��Ϣ����*/
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
					"<h3>���ص�",
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
				/*���ز˵��¼�*/
		if($.sql.map("menus")){
			$("#menuContainer").html($.sql.map("menus"));	
			
		}
})(jQuery);