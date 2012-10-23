<!-- 文件上传工具页 -->
<%@page import="com.sxsihe.utils.common.StringUtils"%>
<%@page import="com.sxsihe.utils.common.CharsetSwitch"%>
<%@ page language="java" contentType="text/html; charset=GBK" pageEncoding="GBK"  
		import="com.sxsihe.utils.file.FileUtils,
				com.oreilly.servlet.MultipartRequest,
				java.io.File,
				com.sxsihe.oxhide.spring.SpringContextUtil,
				com.sxsihe.utils.file.FileUploader"%>
<%
	
	String path = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort()+ request.getContextPath() ;
	String tempPath = this.getServletContext().getRealPath("/") + "/temp/";
	File fileTempPath = new File(tempPath);
	if (!fileTempPath.isDirectory()) fileTempPath.mkdirs();
	MultipartRequest multipartRequest = null;
	try{
		multipartRequest = new MultipartRequest(request, tempPath, Integer.MAX_VALUE, "GBK");
	}catch(Exception e){
		e.printStackTrace();
		response.sendRedirect(path + "/core/exception/baseException.jsp?error="+CharsetSwitch.encode("文件流获取错误！"));
	}
	
	Object o = SpringContextUtil.getBean(multipartRequest.getParameter("uploader"));
	if(o == null){
		response.sendRedirect(path + "/core/exception/baseException.jsp?error="+CharsetSwitch.encode("uploader("+request.getParameter("uploader")+")类型指定错误！"));
	}
	FileUploader uploader =  null;
	try{
		uploader = (FileUploader)o;
	}catch(Exception e){
		e.printStackTrace();
		response.sendRedirect(path + "/core/exception/baseException.jsp?error="+CharsetSwitch.encode("uploader("+request.getParameter("uploader")+")类型指定错误！"));
	}
	try{
		String url = uploader.excuteFile(multipartRequest);
		FileUtils.delte(fileTempPath);
		if(StringUtils.isEmpty(url)) url ="/core/success/opSuccess.jsp";
		response.sendRedirect( path + url);
	}catch(Exception e){
		e.printStackTrace();
		response.sendRedirect(path + "/core/exception/baseException.jsp?error="+CharsetSwitch.encode(e.getMessage()));
	}
%>
