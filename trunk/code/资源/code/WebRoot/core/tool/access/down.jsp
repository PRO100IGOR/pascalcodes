<%@ page language="java" contentType="text/html; charset=GBK" pageEncoding="GBK"%>
<%@ page import="com.jspsmart.upload.SmartUpload"%>
<%
String filePath = request.getParameter("filePath");
SmartUpload smartUpload = new SmartUpload();
smartUpload.initialize(pageContext);
smartUpload.downloadFile(request.getSession().getServletContext().getRealPath("") + filePath);
out.clear();
out=pageContext.pushBody();
%>
