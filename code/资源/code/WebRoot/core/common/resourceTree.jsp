<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%--   
 @<p> title: 资源树</p>
 @<p> description JSP</p>
 @<p>copyright: copyright (c) 2009 </p>
 @version: 1.0           
 @time: 2010-03-01
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib uri="/WEB-INF/tld/struts-html.tld" prefix="html"%>
<%@ taglib uri="/WEB-INF/tld/c.tld" prefix="c"%>
<%@ taglib uri="/WEB-INF/tld/sihe.tld" prefix="sihe"%>
<%-- 
	调用方式 ${basePath}/core/common/resourceTree.jsp?checked=true|false&ids=*&type=p1_p2
	checked:是否用复选框模式
	ids:当使用复选框模式时,哪些被选中
	type:p1:资源树展开级别:-1不限 0 应用系统 1 资源
		 p2:form|list,资源树被什么类型页面调用 如果是form 则点击后关闭,否则调用function nodeClickFun(obj);
	obj的属性有: appname
			     appid
			     menuid
			     menuname
--%>
<%
	request.setCharacterEncoding("utf-8");
%>

<html:html>
<c:set var="request" scope="page" value="${pageContext.request}" />
<c:set var="base" scope="page" value="${request.scheme}://${request.serverName}:${request.serverPort}" />
<c:set var="contextPath" scope="page" value="${request.contextPath}" />
<c:set var="basePath" scope="page" value="${base}${contextPath}/" />
<c:set var="faceStyle" value="${sessionScope.faceStyle}" />
<head>
	<title>资源树</title>
	<base href="${basePath}/resource/" />
	<script type="text/javascript" src="${basePath}/resource/base/js/frame/jquery/jquery.js"></script>
	<script type="text/javascript" src="${basePath}/resource/base/js/layout/base.js?s=${faceStyle}"></script>
	<script type="text/javascript" src="${basePath}/resource/base/js/tool/XQzyDIV.js"></script>
	<script type="text/javascript" src="${basePath}/resource/base/js/tool/codeutil.js"></script>
	<script type="text/javascript" src="${basePath}/resource/base/js/tree/ztree/jquery.ztree.min.js"></script>
	<script type="text/javascript">
	window.types = "${param.type}".split("_");	
	function resultInfo(){
		    this.appname = '';
		    this.appid = '';
		    this.parentmenuid = ''
		    this.parentmenuname = ''
		    this.menuid='';
		    this.menuname = '';
		}
		function nodeClick(event, treeId, treeNode) {
			if("${param.checked}"=="true")return;
			var id = treeNode.id.split("_")[1];		//节点id
			var infoM = new resultInfo();
			var type = treeNode.nodeType;
			if (type == "0") {
			    infoM.appname = treeNode.name; 
			    infoM.appid = id;
			}else if (type == "1"){
			    infoM.menuname = treeNode.name; 
			    infoM.menuid = id;
			    var parentNode = treeNode.getParentNode(); 
			    if(parentNode.nodeType == "1"){
				    infoM.parentmenuname = parentNode.name; 
				    infoM.parentmenuid = parentNode.id.split("_")[1];;
			    }
				while (parentNode.nodeType == "1") {
					parentNode = parentNode.getParentNode();
				}
			    infoM.appname = parentNode.name; 
			    infoM.appid =  parentNode.id.split("_")[1];;
			}
		    if (types[1] == "form" ) {
		        if (type == types[0] || types[0] == -1) {
					father.nodeClick(infoM);
		            dg.cancel(); 
		        }
		    } else {
		        if (window.parent.RightMain.nodeClickFun) window.parent.RightMain.nodeClickFun(infoM);
		    }
		}
<c:if test="${param.oxhide==1}">
function selectNode(){
	var types = "${param.type}".split("_");
	var tree = trees[0]; //默认对第一个树操作
	var list = tree.getCheckedNodes(true);
	var ida= [];
	var idr= [];
	for(var i=0;i<list.length;i++){
		if(list[i].nodeType == 0){
			ida.push(list[i].id.split("_")[1]); 
		}else if(list[i].nodeType == 1){
			idr.push(list[i].id.split("_")[1]); 
		}
	}
	document.roleresource.appids.value = ida.join(",");
	document.roleresource.resids.value = idr.join(",");
	XqTipOpen( "正在保存,请稍后");
	document.roleresource.submit();
}
</c:if>
<c:if test="${param.oxhide!=1}">
function selectNode(){
	var types = "${param.type}".split("_");
	var tree = trees[0]; //默认对第一个树操作
	var list = tree.getCheckedNodes(true);
	var ida= [];
	var idr= [];
	var titlea = [];
	var titler = [];
	for(var i=0;i<list.length;i++){
		if(list[i].nodeType == 0){
			ida.push(list[i].id.split("_")[1]); 
			titlea.push(list[i].name);
		}else if(list[i].nodeType == 1){
			idr.push(list[i].id.split("_")[1]);
			titler.push(list[i].name);
		}
	}
	var t = +"${param.type}".split("_")[0];
	if(t == -1){
	    father.nodeClick(ida, idr,titlea,titler);
	}else if(t == 0){
	    father.nodeClick(ida, titlea);
	}else{
	    father.nodeClick(idr, titler);
	}
	
	dg.cancel();
}
</c:if>
		</script>
		
<c:if test="${param.checked==true}">
	<script type="text/javascript">
			(function(){
				var dg = frameElement.lhgDG;
				if(dg){
					dg.addBtn("确定","确定",selectNode,'left');
				}
			})();
	</script>
</c:if>
</head>

<body>

	<form name="roleresource" action="${basePath}/ssorolesSaveAction.do?action=saveroleresource" method="post">
		<input  type="hidden" name="resids" value="${param.idr }"/>
		<input type="hidden" name="appids" value="${param.ida }"/>
		<input type="hidden" name="id" value="${param.id }"/>
	</form>

	<sihe:tree id="tree" type="${param.type}" showIconDes="true"  service="resourceTreeService" check="${param.checked }"    methods="onClick:nodeClick" />
</body>
</html:html>
