<!-- frame中间的切换显示页面 -->
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
		<script type="text/javascript" src="${basePath}/resource/base/js/frame/jquery/jquery.js"></script>
		<script type="text/javascript" src="${basePath}/resource/base/js/layout/base.js?s=${faceStyle}"></script>
		<style>
			<c:if test="${param.dir=='cols'}">
				.gn-fg{background:url(${ basePath}/resource/base/theme/${faceStyle }/base/img/fg.gif) repeat; width:7px;height:100%;cursor: pointer;}	
			</c:if>
			<c:if test="${param.dir=='rows'}">
				.gn-fg{background:url(${ basePath}/resource/base/theme/${faceStyle }/base/img/fg1.gif) repeat; width:100%;height:7px;cursor: pointer;}	
			</c:if>
		</style>
	</head>
	<body>
	<c:if test="${param.dir=='cols'}">
		<table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%">
			<tr>
				<td height="100%" width="7" class="gn-fg" onclick="display()">
						<table width="7" height="100%" border="0" cellspacing="0" cellpadding="0">
							<tr>
								<td align="left" >
									<img src="${ basePath}/resource/base/theme/${faceStyle }/base/img/fg_jt.gif" title="关闭/打开左栏" id="jt" />
								</td>
							</tr>
						</table>
				</td>
			</tr>
		</table>
	</c:if>
	<c:if test="${param.dir=='rows'}">
		<table width="100%" border="0" cellspacing="0" cellpadding="0" style="height:7px">
			<tr>
				<td  style="height:7px" class="gn-fg" onclick="display()">
				</td>
			</tr>
		</table>
	</c:if>
	<script type="text/javascript">
		var frameParent = window.parent.document.getElementById("${param.id}"),
			frameLeft = "${param.left}",
			frameRight = "${param.right}",
			dir = "${param.dir}",
			old = frameParent[dir],
			jt = document.getElementById("jt") || {};
			jt.action = "hidden";
		function display(){
			if(jt.action == "show"){
				jt.src= (dir == "cols" ? "${ basePath}/resource/base/theme/${faceStyle }/base/img/fg_jt.gif" : "${ basePath}/resource/base/theme/${faceStyle }/base/img/fg_ujt.gif")
				frameParent[dir] = old;
				jt.action = "hidden";
			}else{
				jt.src=(dir == "cols" ? "${ basePath}/resource/base/theme/${faceStyle }/base/img/fg_rjt.gif" : "${ basePath}/resource/base/theme/${faceStyle }/base/img/fg_djt.gif");
				frameParent[dir] = "0,10,*";
				jt.action = "show";
			}
		}
		if(dir == "cols")
			$(".gn-fg").css("height",$(window).height() - 5);
		else
		    $(".gn-fg").css("width",$(window).width());
 	 </script>
	</body>
</html>
