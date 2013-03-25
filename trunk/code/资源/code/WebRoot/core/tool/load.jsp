<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib uri="/WEB-INF/tld/c.tld" prefix="c"%>
<html>
	<head>
		<c:set var="request" scope="page" value="${pageContext.request}" />
		<c:set var="base" scope="page"value="${request.scheme}://${request.serverName}:${request.serverPort}" />
		<c:set var="contextPath" scope="page" value="${request.contextPath}" />
		<c:set var="basePath" scope="page" value="${base}${contextPath}/" />
		<title>页面加载中</title>
		<script type="text/javascript" src="${basePath}resource/base/js/tool/XQzyDIV.js"></script>
		<style type="text/css">
		body{
			font-Size:12px;
		}
		</style>
	</head>
	<body>
	<form action="#" name="loadForm" method="post"  >

	</form>
	<script type="text/javascript">
	 XqTipOpen("页面加载中,请稍后");
	 var url = decodeURIComponent("${param.url}");
	 document.loadForm.action = url;
	 document.loadForm.submit();
 	 </script>
	</body>
</html>
