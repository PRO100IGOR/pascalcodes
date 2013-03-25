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
<%@ taglib uri="/WEB-INF/tld/c.tld" prefix="c"%>
<%@ taglib uri="/WEB-INF/tld/struts-html.tld" prefix="html"%>
<%@ taglib uri="/WEB-INF/tld/sihe.tld" prefix="sihe"%>
<%-- 
	���÷�ʽ ${basePath}/core/common/roleTree.jsp?checked=true|false&ids=*&type=p1_p2
	checked:�Ƿ��ø�ѡ��ģʽ
	ids:��ʹ�ø�ѡ��ģʽʱ,��Щ��ѡ��
	type:p1:��Դ��չ������:role ��ɫ
		 p2:form|list,��Դ����ʲô����ҳ����� �����form ������ر�,�������function nodeClickFun(obj);
	obj��������: roleid
			   rolename	 
			   
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
	<title>��Դ��</title>
	<base href="${basePath}/resource/" />
	<script type="text/javascript" src="${basePath}/resource/base/js/frame/jquery/jquery.js"></script>
	<script type="text/javascript" src="${basePath}/resource/base/js/layout/base.js?s=${faceStyle}"></script>
	<script type="text/javascript" src="${basePath}/resource/base/js/tool/XQzyDIV.js"></script>
	<script type="text/javascript" src="${basePath}/resource/base/js/tool/codeutil.js"></script>
	<script type="text/javascript" src="${basePath}/resource/base/js/tree/ztree/jquery.ztree.min.js"></script>
	<script type="text/javascript">
		function resultInfo(){
		    this.roleid = '';
		    this.rolename = '';
		}
function nodeClick(event, treeId, treeNode) {
	if ("${param.checked}" == "true") return;
    var types = "${param.type}".split("_");
    var infoM = new resultInfo();
    var type = treeNode.nodeType;
    if (type == "role") {
        infoM.rolename = treeNode.name;
        infoM.roleid = treeNode.id;
    }
    infoM.type = type;
	if (types[1] == "form") {
		if (type == types[0]) {
			father.nodeClick(infoM);
			dg.cancel();
		}
	} else {
		if (window.parent && window.parent.RightMain &&window.parent.RightMain.nodeClickFun) window.parent.RightMain.nodeClickFun(infoM);
	}
}

function selectNode(){
	var tree = trees[0]; //Ĭ�϶Ե�һ��������
	var list = tree.getCheckedNodes(true);
	var id=[];
	var name=[];
	for(var i=0;i<list.length;i++){
    		id.push(list[i].id);
    		name.push(list[i].name);
	}
	if("${param.submit}"=="true"){
		document.role.ids.value = id.join(",");
		XqTipOpen("���ڱ���,���Ժ�");
		document.role.submit();
	}else{
		father.nodeClick(id.join(","),name.join(","));
		dg.cancel(); 
	}

}
		</script>
	<c:if test="${param.checked==true}">
		<script type="text/javascript">
			(function(){
				var dg = frameElement.lhgDG;
				if(dg){
					dg.addBtn("ȷ��","ȷ��",selectNode,'left');
				}
			})();
	</script>
	</c:if>
</head>

<body>

	<form name="role" action="${basePath}/ssorolesSaveAction.do?action=saveuserroles" method="post">
		<input type="hidden" name="ids" value="${param.ids }" />
		<input type="hidden" name="id" value="${param.id }" />
	</form>



	<sihe:tree id="tree" type="${param.type}"  service="ssorolesTreeService" check="${param.checked }"  async="false"   methods="onClick:nodeClick" />
</body>
</html:html>
