<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page language="java" contentType="text/html; charset=GBK" pageEncoding="GBK"%>
<%--
@version: 1.0
@author: �ų���
@company: �ĺͿƼ�
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
	<title>runapps�б�ҳ��</title>
	<script type="text/javascript" src="${basePath}/resource/base/js/frame/jquery/jquery.js"></script>
	<script type="text/javascript" src="${basePath}/resource/base/js/layout/base.js?s=${faceStyle}"></script>
	<script type="text/javascript" src="${basePath}/resource/base/js/tool/XQzyDIV.js"></script>
	<script type="text/javascript" src="${basePath}/resource/base/js/validate/Magican.js"></script>
	<script type="text/javascript" src="${basePath}/resource/base/js/msg/msgBar/js/msgBar.js"></script>
	<script type="text/javascript" src="${basePath}/dwr/engine.js"></script>
	<script type="text/javascript" src="${basePath}/dwr/interface/DWRBaseClass.js"></script>
	<script type="text/javascript" src="${basePath}/resource/base/js/dialog/lhgdialog.js?t=${dialog }&s=${faceStyle}"></script>
	<script>
	var showAdd = "${basePath}/runappsShowAction.do?action=showAdd",					//����ҳ��
	    showUpdate = "${basePath}/runappsShowAction.do?action=showUpdate",			//�޸�ҳ��
		showView = "${basePath}/runappsShowAction.do?action=showView",				//�鿴ҳ��
		showDelete = "${basePath}/runappsDeleteAction.do?action=delete",				//ɾ��ҳ��
		showBatchDelete = "${basePath}/runappsDeleteAction.do?action=batchDelete",	//����ɾ��ҳ��
		service = "runappsService",													//����ӿ�
		formName = "runappsConditionForm",											//������
		formWidth = 600,																//�����
		formHeight = 240,														//���߶�
		viewHeight = 240,														//�鿴�߶�
		viewWidth = 600,																//�鿴���
		listOpen = true,																	//�Ƿ����list.js�еķ���
		pageTitle = "runapps",														//ҳ��ģ������
		tableId = "siheTable";																//Ĭ�ϵı��id
	</script>
</head>
<body>
	
	<!-- ��ѯ��������ʼ���������Ű� -->
	<div class="box2" panelWidth="99%"  panelTitle="����">
			<table class="tableStyle" formMode="true" footer="left">
			<tr>
				<td colspan="2">
					<html:button buttonType="view" value="�鿴" />
					<html:button buttonType="add" value="����" />
					<html:button buttonType="edit" value="�޸�" />
					<html:button buttonType="delete" value="ɾ��" />
				</td>
			</tr>
			</table>
	</div>
	<!-- ��ѯ���������� -->
	
	<!-- ��������ʼ -->
	<sihe:table items="list" var="item" action="${basePath}/runappsLoadAction.do?action=showList"   checkId="runid">
	<sihe:row id="${item.runid }">
		<sihe:column property="runname" width="10%" title="����������" /><sihe:column property="runpath" width="10%" title="����������" /><sihe:column property="needclose" width="10%" title="�Ƿ���Ҫ�ر�" /><sihe:column property="enable" width="10%" title="�Ƿ���Ч" /><sihe:column property="remark" width="10%" title="��ע" /></sihe:row>
	</sihe:table>
	<!-- ����������-->
</body>
</html:html>
	