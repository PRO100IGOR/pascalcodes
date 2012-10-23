/*
	���js >> common.js
	�б�ҳ��
	listcontain(�б�����)/next20(�鿴��20��) id�ؼ��������
	jquery���������
	$.showList(async,condition); //�б�
	$.showUpdate(id); //��ʾ�޸�
	$.showView(id); //��ʾ�鿴
	$.add();���ӷ���
	$.update();�޸ķ���
*/
(function($){

	$.initList = function(){

		
		$("#listcontain").empty();
		/*���˴����¼�*/
		document.addEventListener("backbutton", function(){
			window.location = "../index.html#index";
			return false;
		}, false);
		/*����˵��¼�*/
		document.addEventListener("menubutton", function(){
			
		}, false);
		/*����������ť�¼�*/
		document.addEventListener("searchbutton", function(){
			
		}, false);
		/*���水ť�¼���*/
		$("#saveBtn").click(function(){
			var action = $(this).attr("action");
			action && $[action] && $[action]();
		});
		/* ��ʾ���Ӱ�ť�� */
		$("#showAddBtn").click(function(){
			$.showAdd();
		});
		/* ��ʾ�޸İ�ť�� */
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
	 * ��ʾ�޸�ҳ��
	 */
	$.showUpdate = function(id){
		if(id){
			$.msg("���ڼ���...");
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
					$.msg("��ȡ���ݷ�������!",true);
				},
				true
			);
		}
	}
	/*
		�鿴������¼
		ahref:
	*/
	$.showView = function(id){
		if(id){
			$.msg("���ڼ���...");
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
					$.msg("��ȡ���ݷ�������!",true);
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
		�����б�����
		url:�����ַ
		data:�������
		title:�б���ʾ����
		id:����
		async:�Ƿ�ͬ��
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
			$.msg("���ڼ���...");
		}else{
			$("#next20").html("���ڼ���,���Ժ�...");	
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
					$("#next20").html("�鿴��20��");
				}
			    	if(!data || !data.push ||!data.length) {
			    	    $.msg("û�в�ѯ������!",true);
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
				$.msg("��ȡ���ݷ�������!",true);
				$("#next20").html("�鿴��20��");
			},
			async,
			10000
		);
	};
	$.showAdd = function(){
		$.msg("���ڼ���...");
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
				$.msg("��ȡ���ݷ�������!",true);
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
		$.msg("���ڱ���...");
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
				$.msg("��������!",true);
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
		$.msg("���ڱ���...");
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
				$.msg("��������!",true);
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