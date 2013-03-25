<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%--   
 @<p> title: 人员树</p>
 @<p> description JSP</p>
 @<p>copyright: copyright (c) 2009 </p>
 @<p>Company: ITE co., Ltd</p>
 @version: 1.0           
 @time: 2010-03-01
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib uri="/WEB-INF/tld/struts-html.tld" prefix="html"%>
<%@ taglib uri="/WEB-INF/tld/c.tld" prefix="c"%>
<%@ taglib uri="/WEB-INF/tld/sihe.tld" prefix="sihe"%>
<%-- 
	调用方式 ${basePath}/core/common/userTree.jsp?checked=true|false&type=p1_p2&organid=organid
	dom:dom true|false 是否启用自定义按钮模式(只对树的最低级节点有效)
	checked:是否用复选框模式 如果为true 则分级下载为false
	filter : 是否启用过滤模式，启动后为非分级下载，并只能搜索树的最低级对象
	organid:要查询哪个机构
	deptid:要查询那个部门
	postid:要查询哪个岗位
	dir: up|down 向上递归或向下递归 默认down
	ids:已经选择的项目id
	isgrade:是否分级下载
	p1:organ/dept/post/employee  树展开到机构/部门/岗位/员工
	p2:form/list/frame                 p2=form时,结点点击后返回一个对象obj;p2=list时,结点点击后调用list页面的function nodeClickFun(obj);,p2=frame时，调用父页面的方法
	obj的属性有:organName
			   organId
			   deptName
			   deptId
			   employeeName
			   employeeId
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
<title>人员树</title>
<base href="${basePath}/resource/" />
	<script type="text/javascript" src="${basePath}/resource/base/js/frame/jquery/jquery.js"></script>
	<script type="text/javascript" src="${basePath}/resource/base/js/layout/base.js?s=${faceStyle}"></script>
	<script type="text/javascript" src="${basePath}/resource/base/js/tool/XQzyDIV.js"></script>
	<script type="text/javascript" src="${basePath}/resource/base/js/tool/codeutil.js"></script>
	<script type="text/javascript" src="${basePath}/resource/base/js/tree/ztree/jquery.ztree.min.js"></script>
<script type="text/javascript">
    function resultInfo() {
		this.organName = '';
		this.organId = '';
		this.deptName = '';
		this.deptId = '';
		this.postId = '';
		this.postName = '';
		this.employeeName = '';
		this.employeeId = '';
    }
    function addHoverDom(treeId,treeNode){
		if(treeNode.nodeType != types[0]) return;
		if($("#div_"+treeNode.id).length) return;
		var treeObj = $("#" + treeNode.tId + "_a");
		if ($("#cbtn_"+treeNode.id).length > 0) return;
		var temp = window.flam.clone(true);
		temp.attr("nid",treeNode.tId);
		temp.attr("id","div_"+treeNode.id);
		temp.addClass("exp_btn");
		treeObj.append(temp);
    }
    function removeHoverDom(treeId,treeNode){
		$("#div_"+treeNode.id).unbind().remove();
    }
    function getNodeInfo(nodeId, treeNode){
		if ( nodeId)treeNode = trees[0].getNodeByTId(nodeId);
		if ( !treeNode)return;
		var id = treeNode.id.split("_")[1];		//节点id
		var infoM = new resultInfo();
		var type = treeNode.nodeType;
		if (type == "organ") {
			infoM.organName = treeNode.name; 
			infoM.organId = id;
		} else if (type == "dept") {
			infoM.deptName = treeNode.name;
			infoM.deptId = id;
			var parentNode = treeNode.getParentNode(); 
			while (parentNode.nodeType == "dept") {
				parentNode = parentNode.getParentNode();
			}
			infoM.organId = parentNode.id.split("_")[1];
			infoM.organName = parentNode.name;
		} else if (type == "post") {
			infoM.postName = treeNode.name;
			infoM.postId = id;
			var parentNode = treeNode.getParentNode(); 
			while (parentNode.nodeType == "post") {
				parentNode = parentNode.getParentNode();
			}
			infoM.deptName = parentNode.name;
			infoM.deptId = parentNode.id.split("_")[1];
			parentNode = parentNode.getParentNode(); 
			while (parentNode.nodeType == "dept") {
				parentNode = parentNode.getParentNode();
			}
			infoM.organId = parentNode.id.split("_")[1];
			infoM.organName = parentNode.name;
		} else if (type == "employee") {
			infoM.employeeName = treeNode.name;
			infoM.employeeId = id;
			var parentNode = treeNode.getParentNode(); 
			infoM.postName = parentNode.name;
			infoM.postId = parentNode.id.split("_")[1];
			parentNode = parentNode.getParentNode(); 
			while (parentNode.nodeType == "post") {
				parentNode = parentNode.getParentNode();
			}
			infoM.deptName = parentNode.name;
			infoM.deptId = parentNode.id.split("_")[1];
			parentNode = parentNode.getParentNode(); 
			while (parentNode.nodeType == "dept") {
				parentNode = parentNode.getParentNode();
			}
			infoM.organId = parentNode.id.split("_")[1];
			
			infoM.organName = parentNode.name;
		}
		return infoM;
    }
     function nodeClick(event, treeId, treeNode){
		/*如果是多选模式,则不处理节点单击事件*/
		if ("${param.checked}" == "true") return;
		var infoM = getNodeInfo(0, treeNode);
		if (types[1] == "form") {
			if (treeNode.nodeType == types[0]) {
				father.nodeClick(infoM);
				dg.cancel();
			}
		} else if(types[1] == "list"){
			if (window.parent && window.parent.RightMain &&window.parent.RightMain.nodeClickFun) window.parent.RightMain.nodeClickFun(infoM);
		}else if(types[1] == "frame"){
			if (window.parent  &&window.parent.nodeClickFun) window.parent.nodeClickFun(infoM);
		}
    }


    function selectNode() {
		var types = "${param.type}".split("_");
		var tree = trees[0]; //默认对第一个树操作
		var list = tree.getCheckedNodes(true);
		var ids = [];
		var titles = [];
		for ( var i = 0; i < list.length; i++) {
			if (list[i].nodeType == types[0]) {
				ids.push(list[i].id.split("_")[1]);
				titles.push(list[i].name);
			}
		}
		father.nodeClick(ids, titles);
		dg.cancel();
    }
    
    
    $(window).load(function(){
		window.flam =  $("#btnFlag");
		window.types = "${param.type}".split("_");
		if (types[1] == "form") {
			window.father && (openers = window.father ); 
		} else if(types[1] == "list"){
			openers =  parent.RightMain;
		}else if(types[1] == "frame"){
			openers =  parent;
		}
		$("#email").click(function(){
		    openers && openers.email && openers.email(getNodeInfo($(this).parent().attr("nid")));
		});
		$("#msg").click(function(){
		    openers && openers.msg && openers.msg(getNodeInfo($(this).parent().attr("nid")));
		});
		$("#view").click(function(){
		    openers && openers.view && openers.viewEmp(getNodeInfo($(this).parent().attr("nid")));
		});
    });
</script>
<c:if test="${param.checked==true}">
	<script type="text/javascript">
	(function() {
	    var dg = frameElement.lhgDG;
	    if (dg) {
		dg.addBtn("确定", "确定", selectNode, 'left');
	    }
	})();
    </script>
</c:if>
</head>

<body>
	
	
	<c:if test="${param.dom }">
		<c:set value="addHoverDom" var="addHoverDom"  />
		<c:set value="removeHoverDom" var="removeHoverDom"  />
	</c:if>
	<c:set value="${param.filter ?  true : false}" var="filter"></c:set>
	<c:set value="${param.isgrade}" var="isgrade"></c:set>
	<c:if test="${isgrade }">
		<c:if test="${param.organid!=null && param.organid != ''}">
			<c:set value="false" var="isgrade"></c:set>
		</c:if>
		<c:if test="${param.deptid != null && param.deptid != ''}">
			<c:set value="false" var="isgrade"></c:set>
		</c:if>
		<c:if test="${param.postid != null && param.postid != ''}">
			<c:set value="false" var="isgrade"></c:set>
		</c:if>
	</c:if>
	<div  style="display:none;">
		<span id="btnFlag">
			<img src="${basePath}/resource/base/js/tree/ztree/zTreeStyle/img/diy/7.png" alt="邮件" id="email" />
			<img src="${basePath}/resource/base/js/tree/ztree/zTreeStyle/img/diy/bubble.gif" alt="微信" id="msg"  />
			<img src="${basePath}/resource/base/js/tree/ztree/zTreeStyle/img/diy/find.gif" alt="查看详细" id="view"  />
		</span>
	</div>
	<sihe:tree id="tree" type="${param.type}" addHoverDom="${addHoverDom }" removeHoverDom="${removeHoverDom }" filter="${filter }"  service="organTreeService" check="${param.checked }"  async="${isgrade }"   showIconDes="true" methods="onClick:nodeClick" />
	
		<c:if test="${openIds != null}">
			<script>
		    var openIds = ${openIds},tree = trees[0]; //默认对第一个树操作
		    for(var i = openIds.length - 1;i>-1;i--){
				openNodeAndParent("tree",openIds[i]);
		    }
		    </script>
		</c:if>
	
</body>
</html:html>
