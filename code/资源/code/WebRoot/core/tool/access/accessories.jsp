<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page language="java" contentType="text/html; charset=GBK" pageEncoding="GBK"%>
<%--
@version: 1.0
@author: �ų���
@time: 2011-04-21
--%>
<%
	request.setCharacterEncoding("GBK");
%>
<%@ taglib uri="/WEB-INF/tld/c.tld" prefix="c"%>
<%@ taglib prefix="fmt" uri="/WEB-INF/tld/fmt.tld"%>
<html>
	<c:set var="request" scope="page" value="${pageContext.request}" />
	<c:set var="base" scope="page" value="${request.scheme}://${request.serverName}:${request.serverPort}" />
	<c:set var="contextPath" scope="page" value="${request.contextPath}" />
	<c:set var="basePath" scope="page" value="${base}${contextPath}/" />
	<head>
		<title>����</title>
		<script type="text/javascript" src="${basePath}/resource/base/js/frame/jquery/jquery.js"></script>
		<script type="text/javascript" src="${basePath}/resource/base/js/layout/base.js?s=${faceStyle}"></script>
		<script type="text/javascript" src="${basePath}/resource/base/js/tool/codeutil.js"></script> 
		<script>
		(function(){
			function guid(){
				var c = new Date();
				return c.getSeconds()+c.getMinutes()+c.getMilliseconds()+(((1+Math.random())*0x10000)|0).toString(16).substring(1);
			}
			function parentInfo(message){
				if(window.parent.$.msgBar){
					window.parent.$.msgBar ({
						type: 'info',
						text: message,
						position: 'bottom-center',
						lifetime: 2000
					});
				}else{
				   parent.XqTipOpen( message);
				}
			}

			var basePath = "${basePath}/resource/base/theme/public/img/ui/access/";
			$.fn.upload = function(param){
				$.paramAccess = $.extend({
					max:0,
					min:0,
					extend:null
				},param);
				$.files = {};
				window.countAdd = 0;
				window.countInit = 0;
				this.append(
					$("<table/>").append(
						$("<tr/>").append(
							$("<td/>").append(
								$("<input/>",{
									type:"button",
									value:"ѡ���ļ�",
									id:"addFile"
								})
							)
						)
					).append(
						$("<tr/>").append(
							$("<td/>").attr(
								"id","fileScope"
							)
						)
					)
				);
				return this;
			};
			$.addFile = function(path,id,name){
			    for(var i in $.files){
					if($.files[i] == path){
					    parent.info({message:"�ļ��Ѿ����ڣ�"});
					    return;
					}
			    }
			    $.files[id] = path;
			    if(id.length < 30){
					$("#fileScope").append($("#"+id).css("position","static").hide());
					countAdd ++;
			    }
			    $.paramAccess.count ++;
			    
			    window.parent.addFile && window.parent.addFile(window.name,$.paramAccess.count);
				$("#fileScope").append(
					$("<div/>")
						.css({padding:"2px",float:"left"})
						.attr("id",id+"_div")
						.append(
								$("<img/>",{src:basePath+"global.gif"})
									.css({float:"left","margin-right":"2px","margin-top":"5px"})
						)
						.append(
								$("<span/>")
									.css({"float":"left",cursor:"pointer"})
									.html(name)
									.attr("title",path)
									.bind(
										"click",
										function(){
										    if(id.length > 30) $.paramAccess.onDown(path,name);
										}
									)
						).append(
							$("<img/>",{src:basePath+"uploadify-cancel.png",id:id+"_x",title:"ɾ��"})
								.css({
										float:"left","margin-left":"2px","margin-top":"5px",cursor:"pointer"
								})
								.bind("click",function(){
							 		window.paths = path,window.t = this.id.split("_")[0];
							 		parent.ask({
										message:"��ȷ��ɾ�����ļ���",
										fn:function(data){
											if(data=="yes"){
												if(id.length > 30){
													$.paramAccess.onDelete(t,paths)
												}
												$("#"+t).remove();
												$("#"+t+"_div").remove();
												$.paramAccess.count--;
												countAdd --;
												delete $.files[t];
												window.parent.delFile && window.parent.delFile(window.name,$.paramAccess.count);
												if( $.paramAccess.count < $.paramAccess.max){
												    $("#addFile").addFileCustom();
												}
											}
										}
									})
								})
						).append(
							$("<img/>",{
								src:basePath+"download.png",
								id:id+"_down",
								title:"����"
							}).css({
								float:"left","margin-left":"2px","margin-top":"5px",cursor:"pointer"
							}).bind("click",function(){
								if(id.length > 30){
									var t=$(this);
									$.paramAccess.onDown(path,name);
								}
							})
						).append(
							$("<img/>",{
								src:basePath+"look.png",
								id:id+"_look",
								title:"�鿴"
							}).css({
								float:"left","margin-left":"2px","margin-top":"5px",cursor:"pointer"
							}).bind("click",function(){
								if(id.length > 30)
									$.paramAccess.onLook(path,name);
							})
						).append("<span style='float:right;padding:0 3px'>;</span>")
				);
			};
			$.fn.addFileCustom = function(){
				var t = this,id = guid();
				t.after(
					$("<input/>",{
						type:"file",
						name:guid()
					}).css({
						"opacity":0,
						"width":150,
						"height":42,
						"left":-80,
						"top":-11,
						"z-index":"10",
						position: "absolute"
					}).attr("id",id).bind("change",function(){
						if(this.value){
							if(!$.paramAccess.onAdd || $.paramAccess.onAdd(this.value)){
							    var fileName = this.value.substring(this.value.lastIndexOf("\\") + 1, this.value.length).toLowerCase();
								$.addFile(this.value,this.id,fileName);
								if($.paramAccess.count < $.paramAccess.max)
									t.addFileCustom();
							}
						}
					})
				).attr("cc",id);
				return t;
			}
			$(window).load(function(){
				//��ʼ��
				window.parent.uploaders = window.parent.uploaders || [];
				window.parent.upload = function(){
					var framename = window.parent.uploaders[window.parent.uploaders.length - 1];
					window.parent.uploaders.length --;
					parent.frames[framename].upload();
				}; 
				if(!"${flagSubmit}"){
					var nee = true;
					for(var i = 0;i < window.parent.uploaders.length ;i++){
					    if(window.parent.uploaders[i] == window.name){
							nee = false;
							break;
					    }
					}
					if(nee){
						window.parent.uploaders.push(window.name);
					}
				}
			/**
			*�ϴ��ķ���
			**/
			window.upload = function(){
				if("${minCount}" != 0 && ($.paramAccess.count < "${minCount}")){
					window.parent.uploaders.push(window.name);
					parent.info({message:"����ѡ��${minCount}���ļ���"});
					return;
				}
				if(countAdd == 0){
					if(window.parent.uploaders.length == 0){
						window.parent.subform();
					}else{
						window.parent.upload();
					}					
				}else{
				    var ii = document.upd.elements;
				    for(var i = 0;i<ii.length;i++){
						if(ii[i].type == "file") {
						    if(!ii[i].value) $(ii[i]).remove();
						}
				    }
					parentInfo("�����ϴ��ļ�,���Ժ�");
					document.upd.submit();
				}
			}
				$("#main").upload({
					max : +("${maxCount}" || "0"),
					min : +("${minCount}" || "0"),
					extend : "${extend}".toLowerCase(),
					count : +("${count}" || "0"),
					onDelete:function(id,path){
						parentInfo("����ִ�в���,���Ժ�");
						document.play.id.value = id;
						document.play.filePath.value = path;
						document.play.action = "${basePath}/accessories.do?action=delete";
						document.play.submit();
					},
					onAdd:function(fileName){
						var fileType = (fileName.substring(fileName.lastIndexOf(".") + 1,fileName.length)).toLowerCase();
						if("${extend}".toLowerCase().indexOf(fileType)==-1){parent.info({message:"<br/>�ļ����ʹ�����ѡ���������͵��ļ���<br/>${extend}"});return;}
						return true;
					},
					onDown:function(path,name){
						parentInfo( "������������,���Ժ�");
						document.play.action = "${basePath}/accessories.do?action=download";
						document.play.filePath.value = path;
						document.play.fileName.value = name;
						document.play.submit();
						parent.XqTipClose();
					},
					onLook:function(path,name){
						var fileType = (name.substring(name.lastIndexOf(".") + 1, name.length)).toLowerCase();
						if("jpg,jpeg,png,bmp,gif".indexOf(fileType)!=-1){
							path = "${basePath}"+path;
						}else{
							path = "http://docs.google.com/viewer?url=" + encodeURIComponent("${basePath}"+path);
						}
						if("${USERSESSION}")
							window.open(path);
						else
							parent.location = path;
					}
				});
				<c:forEach items="${list}" var="item">
					$.addFile("${item.path}","${item.id}","${item.fileName}");
				</c:forEach>
				function initFile(){
					if(window.parent.document.readyState == "complete"){
						window.parent.initFile && window.parent.initFile(window.name,$.paramAccess.count);
					}else{
						if(![-1,]){
							setTimeout("initFile()",1000);
						}else{
							setTimeout(initFile, 1000);
						}
	
					}
				}
				initFile();
				function parentMessage(message,fn){
					if(window.parent.$.msgBar){
						window.parent.$.msgBar ({
							type: 'success',
							text: message,
							position: 'bottom-center',
							lifetime: 3000
						});
						if(fn)
							fn();
					}else if(window.parent.$.dialog){
					   window.parent.info({
					   		message:message,
					   		fn:fn
					   });
					}else{
						alert(message);
						if(fn)
							fn();
					}
				}
				(function(){
					try{
						parent.XqTipClose();
					}catch(e){}
					var msg = decode("${msg}");
					if("${flagSubmit}"=="true"){
						 if(msg){
						 	parentMessage(msg,function(){
								upload();
						 	});
						 }else{
						     	upload();
						 }
					}else if("${flagSubmit}"=="false"){
					    parent.ask({
					    	message:(msg || "�����ϴ�ʧ��")+" ȷ���ύ��",
					    	fn:function(data){
					    		if(data=='yes'){
									window.parent.upload();
					            }
					    	}
					    });
					}else{
						if(msg)
							parentMessage(msg);
					}
				})();
				if(!("${maxCount}" > 0 && $.paramAccess.count >= "${maxCount}")){
				   $("#addFile").addFileCustom();
				}
				$("#addFile").refresh().bind("click",function(){
						
				    	if("${maxCount}" > 0 && $.paramAccess.count >= "${maxCount}"){
							parent.info({message:"���ѡ��${maxCount}���ļ���"});
						}	
					
				})
			});
			
		})();
		</script>
	</head>
	<body>
<form name="play" method="post" action="#">
<input type="hidden" name="forward" value="${forward }"/>
<input type="hidden" name="minCount" value="${minCount }"/>
<input type="hidden" name="id" />
<input type="hidden" name="filePath" value="${filePath }"/>
<input type="hidden" name="itemId" value="${itemId }"/>
<input type="hidden" name="isManager" value="${isManager }"/>
<input type="hidden" name="appName" value="${appName }"/>
<input type="hidden" name="type" value="${type }"/>
<input type="hidden" name="maxCount" value="${maxCount }"/>
<input type="hidden" name="path" value="${path }"/>
<input type="hidden" name="fileName" />
</form>
<form name="upd" method="post" enctype="multipart/form-data" action="${basePath}/accessories.do?action=upload">
<input type="hidden" name="forward" value="${forward }"/>
<input type="hidden" name="minCount" value="${minCount }"/>
<input type="hidden" name="id" value="${id }"/>
<input type="hidden" name="filePath" value="${filePath }"/>
<input type="hidden" name="itemId" value="${itemId }"/>
<input type="hidden" name="isManager" value="${isManager }"/>
<input type="hidden" name="appName" value="${appName }"/>
<input type="hidden" name="type" value="${type }"/>
<input type="hidden" name="maxCount" value="${maxCount }"/>
<input type="hidden" name="path" value="${path }"/>
<div id="main"></div>
</form>
���ļ����
<c:choose>
	<c:when test="${fsize > 1024}">
		<fmt:formatNumber value="${fsize/(1024)}" pattern="#.##" />MB
	</c:when>
	<c:otherwise>
		<fmt:formatNumber value="${fsize/1024}" pattern="#.##" />KB
	</c:otherwise>
</c:choose>
,����${extend }
	</body>
	
</html>
