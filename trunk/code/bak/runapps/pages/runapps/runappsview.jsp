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
<%@ taglib uri="/WEB-INF/tld/struts-html.tld" prefix="html"%>
<%@ taglib uri="/WEB-INF/tld/c.tld" prefix="c"%>
<%@ taglib uri="/WEB-INF/tld/sihe.tld" prefix="sihe"%>
<html:html>
<c:set var="request" scope="page" value="${pageContext.request}" />
<c:set var="base" scope="page" value="${request.scheme}://${request.serverName}:${request.serverPort}" />
<c:set var="contextPath" scope="page" value="${request.contextPath}" />
<c:set var="basePath" scope="page" value="${base}${contextPath}/" />
<head>
	<title>runapps�鿴ҳ��</title>
	<script type="text/javascript" src="${basePath}/resource/base/js/frame/jquery/jquery.js"></script>
	<script type="text/javascript" src="${basePath}/resource/base/js/layout/base.js?s=${faceStyle}"></script>
</head>
<body>
	<table class="tableStyle" formMode="true" footer="normal">
		<tr>
			<td width="30%" >
				���������ƣ�
			</td>
			<td>
				${view.runname }
				</td>
		</tr>
		<tr>
			<td width="30%" >
				���������
			</td>
			<td>
				${view.runpath }
				</td>
		</tr>
		<tr>
			<td width="30%" >
				�Ƿ���Ҫ�رգ�
			</td>
			<td>
				${view.needclose }
				</td>
		</tr>
		<tr>
			<td width="30%" >
				�Ƿ���Ч��
			</td>
			<td>
				${view.enable }
				</td>
		</tr>
		<tr>
			<td width="30%" >
				��ע��
			</td>
			<td>
				${view.remark }
				</td>
		</tr>
		<tr>
					<td >
						����:
					</td>
					<td>
						<sihe:access itemId=${ view.runid }/>
					</td>
				</tr>
			</table>
</body>
</html:html>