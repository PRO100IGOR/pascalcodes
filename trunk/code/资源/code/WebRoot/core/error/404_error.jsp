<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%
	request.setCharacterEncoding("utf-8");
	response.setStatus(HttpServletResponse.SC_OK);
	request.setAttribute("pathself", request.getAttribute("javax.servlet.forward.request_uri").toString().toLowerCase());
%>
<%@ taglib uri="/WEB-INF/tld/c.tld" prefix="c"%>
<%@ taglib uri="/WEB-INF/tld/fn.tld" prefix="fn"%>
<c:if test="${!fn:endsWith(pathself, '.js')}">
	<html>
		<c:set var="request" scope="page" value="${pageContext.request}" />
		<c:set var="base" scope="page" value="${request.scheme}://${request.serverName}:${request.serverPort}" />
		<c:set var="contextPath" scope="page" value="${request.contextPath}" />
		<c:set var="basePath" scope="page" value="${base}${contextPath}/" />
		<head>
			<title>ณ๖ดํมห${pathself}</title>
		</head>
		<body bgColor="#D9D9D9">
			<center>
				<IMG src="${basePath }/resource/base/theme/public/img/ui/jsz.png">
			</center>
		</body>
	</html>
</c:if>
