<%@page import="com.sxsihe.utils.common.CharsetSwitch"%>
<%@page import="com.sxsihe.utils.properties.Reader"%>
<%@page import="com.sxsihe.utils.common.StringUtils"%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib uri="/WEB-INF/tld/struts-html.tld" prefix="html"%>
<%@ taglib uri="/WEB-INF/tld/c.tld" prefix="c"%>
<%@ taglib uri="/WEB-INF/tld/sihe.tld" prefix="sihe"%>
<html:html>
<c:set var="request" scope="page" value="${pageContext.request}" />
<c:set var="base" scope="page" value="${request.scheme}://${request.serverName}:${request.serverPort}" />
<c:set var="contextPath" scope="page" value="${request.contextPath}" />
<c:set var="basePath" scope="page" value="${base}${contextPath}/" />
<%
		String error = request.getParameter("error");
		Object needShowo =  request.getAttribute("needShow");
		Boolean needShow = needShowo == null ? false : (Boolean)needShowo;
		if(StringUtils.isEmpty(error)){
			String showMsg = (String) request.getAttribute("showMsg");
			if(showMsg == null)
				request.setAttribute("error", "您登录的时间太久了，请重新登录以保证您的帐号安全！");
			else if(needShow){
				request.setAttribute("error", showMsg);
				if(showMsg.indexOf("用户名或密码错误") > -1){
					request.setAttribute("loginPass", true);
				}
			}else{
				Reader reader = new Reader("config.properties");
				if("true".equals(reader.getProperty("debug", "false")))
					request.setAttribute("error", showMsg);
				else
					request.setAttribute("error", "对不起，您访问的功能发生错误了，我们已经收集了错误的详细信息，工程师将以最快的速度处理这个错误并第一时间通知您，对您的操作产生的影响我们致以诚挚的歉意，请您耐心等待！");
				
			}
		}else
			request.setAttribute("error", CharsetSwitch.decode(error));
%>
<head>
<script type="text/javascript" src="${basePath}/resource/base/js/frame/jquery/jquery.js"></script>
<script type="text/javascript" src="${basePath}/resource/base/js/layout/base.js?s=${faceStyle}"></script>
</head>
<body>
	<center>
		<div class="box1" whiteBg="true" panelWidth="450">
			<div class="msg_icon2"></div>
			<div class="padding_left50 padding_right15 padding_top20 minHeight_100 font_14 font_bold" style="font-family: 微软雅黑;">
				<p>${error }</p>
				<center><html:button value="好的" styleId="backBtn" onclick="goBack();"/></center>
			</div>
		</div>
	</center>
</body>

<script type="text/javascript">
	try{
		var DG = frameElement && frameElement.lhgDG;
		if(DG){
			for(var i = 0 ;i<DG.btns.length;i++){
				DG.removeBtn(DG.btns[i]);
			}
			document.getElementById("backBtn").style.display = "none";
		}else{
		    document.getElementById("backBtn").style.display = "block";
		}
	}catch(e){
	    	document.getElementById("backBtn").style.display = "none";
	}
	$(window).load(function(){
	    var t = $(".box1"),h1 = t.height(),h = $(window).height();
	    h ? t.css("padding-top",(h - h1)/2) : t.css("padding-top",30);
	});
	
	
	function goBack(){
	    if("${oldId}"){
			ask( {
				message : "您是否要注销并重新登录吗？",
				fn : function(data) {
					if (data == 'yes') {
	          		   $.ajax({
	                         url : "${basePath}/siheAction.do?action=tipUser&sid=${oldId}",
	                         success : function(data) {
	                         	   info({message:"操作成功！请重新登录！",fn:function(){
	                         	       window.location = "${basePath}";
	                         	   }});
	                         }
	          		   });
					}
				}
			});
	    }else if("${loginPass}"){
	    	 window.location = "${basePath}";
	    }else
	    	window.history.go(-1);
	}
	
	
</script>
</html:html>