<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%--   
 @<p> title: ��Ա��</p>
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
	���÷�ʽ ${basePath}/core/common/userTree.jsp?checked=true|false&type=p1_p2&organid=organid
	dom:dom true|false �Ƿ������Զ��尴ťģʽ(ֻ��������ͼ��ڵ���Ч)
	checked:�Ƿ��ø�ѡ��ģʽ ���Ϊtrue ��ּ�����Ϊfalse
	filter : �Ƿ����ù���ģʽ��������Ϊ�Ƿּ����أ���ֻ������������ͼ�����
	organid:Ҫ��ѯ�ĸ�����
	deptid:Ҫ��ѯ�Ǹ�����
	postid:Ҫ��ѯ�ĸ���λ
	dir: up|down ���ϵݹ�����µݹ� Ĭ��down
	ids:�Ѿ�ѡ�����Ŀid
	isgrade:�Ƿ�ּ�����
	p1:organ/dept/post/employee  ��չ��������/����/��λ/Ա��
	p2:form/list/frame                 p2=formʱ,������󷵻�һ������obj;p2=listʱ,����������listҳ���function nodeClickFun(obj);,p2=frameʱ�����ø�ҳ��ķ���
	obj��������:organName
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
<title>��Ա��</title>
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
		var id = treeNode.id.split("_")[1];		//�ڵ�id
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
		/*����Ƕ�ѡģʽ,�򲻴���ڵ㵥���¼�*/
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
		var tree = trees[0]; //Ĭ�϶Ե�һ��������
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
		dg.addBtn("ȷ��", "ȷ��", selectNode, 'left');
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
			<img src="${basePath}/resource/base/js/tree/ztree/zTreeStyle/img/diy/7.png" alt="�ʼ�" id="email" />
			<img src="${basePath}/resource/base/js/tree/ztree/zTreeStyle/img/diy/bubble.gif" alt="΢��" id="msg"  />
			<img src="${basePath}/resource/base/js/tree/ztree/zTreeStyle/img/diy/find.gif" alt="�鿴��ϸ" id="view"  />
		</span>
	</div>
	<sihe:tree id="tree" type="${param.type}" addHoverDom="${addHoverDom }" removeHoverDom="${removeHoverDom }" filter="${filter }"  service="organTreeService" check="${param.checked }"  async="${isgrade }"   showIconDes="true" methods="onClick:nodeClick" />
	
		<c:if test="${openIds != null}">
			<script>
		    var openIds = ${openIds},tree = trees[0]; //Ĭ�϶Ե�һ��������
		    for(var i = openIds.length - 1;i>-1;i--){
				openNodeAndParent("tree",openIds[i]);
		    }
		    </script>
		</c:if>
	
</body>
</html:html>
