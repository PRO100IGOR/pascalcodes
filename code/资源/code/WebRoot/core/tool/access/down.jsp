<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="com.jspsmart.upload.SmartUpload"%>
<%
String filePath = request.getParameter("filePath");
SmartUpload smartUpload = new SmartUpload();
smartUpload.initialize(pageContext);
smartUpload.downloadFile(request.getSession().getServletContext().getRealPath("") + filePath);
out.clear();
out=pageContext.pushBody();
%>
