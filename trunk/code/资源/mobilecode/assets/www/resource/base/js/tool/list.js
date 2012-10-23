/*
	相关js >> common.js
	列表页面
	listcontain(列表容器)/next20(查看下20条) id控件必须存在
	jquery插件方法：
	$.showList(async,condition); //列表
	$.showUpdate(id); //显示修改
	$.showView(id); //显示查看
	$.add();增加方法
	$.update();修改方法
*/
(function($){

	$.initList = function(){

		
		$("#listcontain").empty();
		/*回退处理事件*/
		document.addEventListener("backbutton", function(){
			window.location = "../index.html#index";
			return false;
		}, false);
		/*处理菜单事件*/
		document.addEventListener("menubutton", function(){
			
		}, false);
		/*处理搜索按钮事件*/
		document.addEventListener("searchbutton", function(){
			
		}, false);
		/*保存按钮事件绑定*/
		$("#saveBtn").click(function(){
			var action = $(this).attr("action");
			action && $[action] && $[action]();
		});
		/* 显示增加按钮绑定 */
		$("#showAddBtn").click(function(){
			$.showAdd();
		});
		/* 显示修改按钮绑定 */
		$("#showUpdateBtn").click(function(){
			var actionid = $(this).attr("actionid");
			actionid && $.showUpdate(actionid);
		});
		$.mobile.pageLoadErrorMessage = $.sql.map("errormessage");
		$.list = {};
		$.begin = 0;
		$.showList(true);
		$("#next20").bind("click",function(){
			$.showList(false);
		});
	};
	/**
	 * 显示修改页面
	 */
	$.showUpdate = function(id){
		if(id){
			$.msg("正在加载...");
			var data = {
				id:id
			};
			var temp = beforeShowUpdate(id);
			temp && $.extend(data,temp,true);
			$.http(
				$.urlAddParam($.showUpdateUrl,"id",id),
				{
					data : $.obj2Str(data)
				},
				function(data){
					data && $.gotourl("#form");
					window["onShowUpdate"] && onShowUpdate(data);
					$.mobile.hidePageLoadingMsg();
					if(!data)return;
					$("#saveBtn").attr("action","update");
				},
				function(){
					$.msg("获取数据发生错误!",true);
				},
				true
			);
		}
	}
	/*
		查看单条记录
		ahref:
	*/
	$.showView = function(id){
		if(id){
			$.msg("正在加载...");
			var data = {
				id:id
			},temp;
			window["beforeShowView"] && (temp = beforeShowView(id)) && $.extend(data,temp,true);
			$.http(
				$.urlAddParam($.showViewUrl,"id",id),
				{
					data : $.obj2Str(data)
				},
				function(data){
					data && $.gotourl("#view");
					window["onShowView"] && onShowView(data);
					$.mobile.hidePageLoadingMsg();
					if(!data)return;
					$("#showUpdateBtn").attr("actionid",id);
				},
				function(){
					$.msg("获取数据发生错误!",true);
				},
				true,
				10000
			);
		}
	};
	$.listClear = function(){
		$.begin = 0 ;
		$("#listcontain").empty();
	}
	/*
		加载列表数据
		url:请求地址
		data:请求参数
		title:列表显示标题
		id:主键
		async:是否同步
	*/
	$.showList = function(async,condition){
		var data = {
			begin:$.begin,
			count:20
		},temp;
		window["beforeShowList"] && (temp = beforeShowList()) && $.extend(data,temp,true);
		if(condition){
			data.condition = condition;
		}
		if(async){
			$.msg("正在加载...");
		}else{
			$("#next20").html("正在加载,请稍后...");	
		}
		$.http(
			$.url,
			{
				data : $.obj2Str(data)
			},
			function(data){
				if(async){
					$.mobile.hidePageLoadingMsg();
				}else{
					$("#next20").html("查看下20条");
				}
			    	if(!data || !data.push ||!data.length) {
			    	    $.msg("没有查询到数据!",true);
			    	    return;
			    	}
			    	$.begin += data.length;
			    	if( !(window["onShowList"] && onShowList(data)) ) {
			    	    var str = [];
			    	    for(var i = 0;i< data.length;i++){
					str.push("<li><a href='javascript:;' src='");
					str.push(data[i][$.id]);
					str.push("' class='listid"+$.begin+"'>");
					str.push(data[i][$.title]);
					str.push("</a></li>");
					$.list[data[i][$.id]] = data[i];
			    	    }
			    	    $("#listcontain").append($(str.join(""))).listview('refresh');
			    	}
				
				$(".listid").bind("click",function(){
					$.showView($(this).attr("src"));
				});

			},
			function(){
				$.msg("获取数据发生错误!",true);
				$("#next20").html("查看下20条");
			},
			async,
			10000
		);
	};
	$.showAdd = function(){
		$.msg("正在加载...");
		var data = {},temp;
		window["beforeShowAdd"] && (temp = beforeShowAdd()) && $.extend(data,temp,true);
		$.http(
			$.showAddUrl,
			{
				data : $.obj2Str(data)
			},
			function(data){
				$("*[c=form]").val("");
				data && $.gotourl("#form");
				$.mobile.hidePageLoadingMsg();
				window["onShowAdd"] && onShowAdd(data);
				$("#saveBtn").attr("action","add");
				if(!data)return;
				window["onShowView"] && onShowView(data);
				$("#updateBtn").click(function(){
					showUpdate(id);
				});
			},
			function(){
				$.msg("获取数据发生错误!",true);
			},
			true,
			10000
		);
	}
	$.update = function(){
		if(!check()) return;
		var forms = $("*[c=form]"),data = {},temp;
		for(var i =0;i < forms.length;i++){
			data[forms[i].id] = forms[i].value;
		}
		window["beforeAdd"] && (temp = beforeAdd()) && $.extend(data,temp,true);
		$.msg("正在保存...");
		$.http(
			$.urlAddParam($.updateUrl,"id",$("#showUpdateBtn").attr("actionid")),
			{
				data : $.encode($.obj2Str(data))
			},
			function(data){
				if(data.error){
					$.alert(data.error);
				}else{
					$.msg(data.message,true);
					window["onUpdate"] && onUpdate(data);
					$.gotourl("#list");
					$.listClear();
					$.showList(true);
				}
			},
			function(){
				$.msg("发生错误!",true);
			},
			true,
			10000
		);
	}
	$.add = function(){
		if(!check()) return;
		var forms = $("*[c=form]"),data = {},temp;
		for(var i =0;i < forms.length;i++){
			data[forms[i].id] = forms[i].value;
		}
		window["beforeAdd"] && (temp = beforeAdd()) && $.extend(data,temp,true);
		$.msg("正在保存...");
		$.http(
			$.addUrl,
			{
				data : $.encode($.obj2Str(data))
			},
			function(data){
				if(data.error){
					$.alert(data.error);
				}else{
					$.msg(data.message,true);
					window["onAdd"] && onAdd(data);
					$.gotourl("#list");
					$.listClear();
					$.showList(true);
				}
			},
			function(){
				$.msg("发生错误!",true);
			},
			true,
			10000
		);
	}

	$.url = decodeURIComponent($.getParam("url"));
	$.showUpdateUrl = $.showUpdateUrl || $.url.replaceAll("LoadAction.do\\?action=showList","ShowAction.do?action=showUpdate");
	$.showAddUrl = $.showAddUrl  || $.url.replaceAll("LoadAction.do\\?action=showList","ShowAction.do?action=showAdd");
	$.showViewUrl = $.showViewUrl || $.url.replaceAll("LoadAction.do\\?action=showList","ShowAction.do?action=showView");
	$.addUrl = $.addUrl || $.url.replaceAll("LoadAction.do\\?action=showList","SaveAction.do?action=add");
	$.updateUrl = $.updateUrl || $.url.replaceAll("LoadAction.do\\?action=showList","SaveAction.do?action=update");
	document.addEventListener("deviceready", function(){
		$.initList();
	}, false);
	
})(jQuery);