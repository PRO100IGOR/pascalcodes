<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page language="java" contentType="text/html; charset=GBK" pageEncoding="GBK"%>
<%--
@version: 1.0
@author: 张超超
@company: 四和科技
@time: 2012-10-30
--%>
<%
	request.setCharacterEncoding("GBK");
%>
<%@ taglib uri="/WEB-INF/tld/c.tld" prefix="c"%>
<%@ taglib uri="/WEB-INF/tld/struts-html.tld" prefix="html"%>
<%@ taglib uri="/WEB-INF/tld/sihe.tld" prefix="sihe"%>
<html:html>
<c:set var="request" scope="page" value="${pageContext.request}" />
<c:set var="base" scope="page" value="${request.scheme}://${request.serverName}:${request.serverPort}" />
<c:set var="contextPath" scope="page" value="${request.contextPath}" />
<c:set var="basePath" scope="page" value="${base}${contextPath}/" />
<head>
	<title>runapps列表页面</title>
	<script type="text/javascript" src="${basePath}/resource/base/js/frame/jquery/jquery.js"></script>
	<script type="text/javascript" src="${basePath}/resource/base/js/layout/base.js?s=${faceStyle}"></script>
	<script type="text/javascript" src="${basePath}/resource/base/js/tool/XQzyDIV.js"></script>
	<script type="text/javascript" src="${basePath}/resource/base/js/validate/Magican.js"></script>
	<script type="text/javascript" src="${basePath}/resource/base/js/msg/msgBar/js/msgBar.js"></script>
	<script type="text/javascript" src="${basePath}/dwr/engine.js"></script>
	<script type="text/javascript" src="${basePath}/dwr/interface/DWRBaseClass.js"></script>
	<script type="text/javascript" src="${basePath}/resource/base/js/dialog/lhgdialog.js?t=${dialog }&s=${faceStyle}"></script>
	<script>
	var showAdd = "${basePath}/runappsShowAction.do?action=showAdd",					//增加页面
	    showUpdate = "${basePath}/runappsShowAction.do?action=showUpdate",			//修改页面
		showView = "${basePath}/runappsShowAction.do?action=showView",				//查看页面
		showDelete = "${basePath}/runappsDeleteAction.do?action=delete",				//删除页面
		showBatchDelete = "${basePath}/runappsDeleteAction.do?action=batchDelete",	//批量删除页面
		service = "runappsService",													//服务接口
		formName = "runappsConditionForm",											//表单名称
		formWidth = 600,																//表单宽度
		formHeight = 240,														//表单高度
		viewHeight = 240,														//查看高度
		viewWidth = 600,																//查看宽度
		listOpen = true,																	//是否调用list.js中的方法
		pageTitle = "runapps",														//页面模块名称
		tableId = "siheTable";																//默认的表格id
	</script>
</head>
<body>
	
	<!-- 查询操作区开始，请自行排版 -->
	<div class="box2" panelWidth="99%"  panelTitle="功能">
			<table class="tableStyle" formMode="true" footer="left">
			<tr>
				<td colspan="2">
					<html:button buttonType="view" value="查看" />
					<html:button buttonType="add" value="增加" />
					<html:button buttonType="edit" value="修改" />
					<html:button buttonType="delete" value="删除" />
				</td>
			</tr>
			</table>
	</div>
	<!-- 查询操作区结束 -->
	
	<!-- 数据区开始 -->
	<sihe:table items="list" var="item" action="${basePath}/runappsLoadAction.do?action=showList"   checkId="runid">
	<sihe:row id="${item.runid }">
		<sihe:column property="runname" width="10%" title="启动项名称" /><sihe:column property="runpath" width="10%" title="启动项命令" /><sihe:column property="needclose" width="10%" title="是否需要关闭" /><sihe:column property="enable" width="10%" title="是否有效" /><sihe:column property="remark" width="10%" title="备注" /></sihe:row>
	</sihe:table>
	<!-- 数据区结束-->
</body>
</html:html>
	