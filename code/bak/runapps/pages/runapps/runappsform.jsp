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
	<title>runapps表单页面</title>
	<script type="text/javascript" src="${basePath}/resource/base/js/frame/jquery/jquery.js"></script>
	<script type="text/javascript" src="${basePath}/resource/base/js/layout/base.js?s=${faceStyle}"></script>
	<script type="text/javascript" src="${basePath}/resource/base/js/tool/XQzyDIV.js"></script>
	<script type="text/javascript" src="${basePath}/resource/base/js/validate/Magican.js"></script>
	<script type="text/javascript" src="${basePath}/resource/base/js/msg/msgBar/js/msgBar.js"></script>
	<script type="text/javascript" src="${basePath}/dwr/engine.js"></script>
	<script type="text/javascript" src="${basePath}/dwr/interface/DWRBaseClass.js"></script>
	<script type="text/javascript" src="${basePath}/resource/base/js/dialog/lhgdialog.js?t=self&s=${faceStyle}"></script>
	<script>
	var runappsForm = new $Form("runappsForm");
	runappsForm.onCheck = "checkOne>appendAfter";
	runappsForm.rules = {
		};
	function save(){
		if(runappsForm.check()){
			upload();
			}
	}
function subform(){
		$.msgBar ({
			type: 'info', 
			text: "正在保存数据",
			position: 'bottom-center', 
			lifetime: 3000
		});
		XqTipOpen("正在保存数据,请稍后");
		document.runappsForm.submit();
	}
</script>
</head>
<body>
	<html:form action="/runappsSaveAction.do?action=${param.action}" styleId="runappsForm">
		<input type="hidden" name="isSaveAndAdd" id="isSaveAndAdd" value="${isSaveAndAdd }" />
		<table class="tableStyle" formMode="true" footer="normal">
			<html:hidden property="runid" />
			<tr>
				<td width="30%">
					启动项名称：
				</td>
				<td>
					<html:text property="runname" size="32" maxlength="32" styleId="runname" />
				</td>
			</tr>
			<tr>
				<td width="30%">
					启动项命令：
				</td>
				<td>
					<html:text property="runpath" size="32" maxlength="32" styleId="runpath" />
				</td>
			</tr>
			<tr>
				<td width="30%">
					是否需要关闭：
				</td>
				<td>
					<html:text property="needclose" size="32" maxlength="32" styleId="needclose" />
				</td>
			</tr>
			<tr>
				<td width="30%">
					是否有效：
				</td>
				<td>
					<html:text property="enable" size="32" maxlength="32" styleId="enable" />
				</td>
			</tr>
			<tr>
				<td width="30%">
					备注：
				</td>
				<td>
					<html:text property="remark" size="32" maxlength="32" styleId="remark" />
				</td>
			</tr>
			<tr>
					<td >
						附件:
					</td>
					<td>
						<iframe name="accfrm0" width="100%" height="100" scrolling="auto" frameborder="0"
							src="${basePath}/accessories.do?action=show&type=image&isManager=true&itemId=${ runappsForm.runid }&appName=${contextPath }&maxCount=1&showAsImg=1">
						</iframe>
						</td>
				</tr>
			</table>
	</html:form>
</body>
</html:html>
	