<%@ page language="java" contentType="text/html; charset=gbk" pageEncoding="gbk"%>
<%@ taglib uri="/WEB-INF/tld/struts-html.tld" prefix="html"%>
<%@ taglib uri="/WEB-INF/tld/struts-bean.tld" prefix="bean"%>
<%@ taglib uri="/WEB-INF/tld/c.tld" prefix="c"%>
<c:set var="request" scope="page" value="${pageContext.request}" />
<c:set var="base" scope="page" value="${request.scheme}://${request.serverName}:${request.serverPort}" />
<c:set var="contextPath" scope="page" value="${request.contextPath}" />
<c:set var="basePath" scope="page" value="${base}${contextPath}/" />
<html>
	<c:set var="contextPath" scope="page" value="${request.contextPath}" />
	<HEAD>
		<TITLE>操作成功</TITLE>
	</HEAD>
	<body>
		<c:choose>
			<c:when test="${param.action=='add'}">
				<input type="hidden" class="buttoncss"  name="isSaveAndAdd" id="isSaveAndAdd" value="${isSaveAndAdd }" />
				<div style="position:absolute;width:250px;height:70px;top:50%;left:50%;margin-left:-125px;margin-top:-35px;z-index:10; visibility:visible;" >
					<table WIDTH="100%" BORDER="0" CELLSPACING="0" CELLPADDING="0">
						<tr>
							<td valign="middle" >
								<img src='${ basePath}/resource/base/js/dialog/skins/ico/right.gif'  />
							</td>
							<td valign="middle" >
								添加成功！
							</td>
						</tr>
					</table>
				</div>
				<script type="text/javascript">
					var DG = frameElement.lhgDG;
					DG.reDialogSize(360,200);
					DG.SetTitle("提示");
					for(var i = 0 ;i<DG.btns.length;i++){
						DG.removeBtn(DG.btns[i]);
					}
					DG.SetCancelBtn("确定");
				</script>

			</c:when>
			<c:when test="${param.action=='update'}">
				<input type="hidden" class="buttoncss"  name="isSaveAndAdd" id="isSaveAndAdd" value="${isSaveAndAdd }" />
				<div style="position:absolute;width:250px;height:70px;top:50%;left:50%;margin-left:-125px;margin-top:-35px;z-index:10; visibility:visible;" >
					<table WIDTH="100%" BORDER="0" CELLSPACING="0" CELLPADDING="0">
						<tr>
							<td valign="middle" >
								<img src='${ basePath}/resource/base/js/dialog/skins/ico/right.gif'  />
							</td>
							<td valign="middle" >
								修改成功！
							</td>
						</tr>
					</table>
				</div>
				<script type="text/javascript">
					var DG = frameElement.lhgDG;
					DG.reDialogSize(360,200);
					DG.SetTitle("提示");
					for(var i = 0 ;i<DG.btns.length;i++){
						DG.removeBtn(DG.btns[i]);
					}
					DG.SetCancelBtn("确定");
				</script>
			</c:when>
			<c:otherwise>
				<div style="position:absolute;width:250px;height:70px;top:50%;left:50%;margin-left:-125px;margin-top:-35px;z-index:10; visibility:visible;" >
					<input type="hidden" class="buttoncss"  name="isSaveAndAdd" id="isSaveAndAdd" value="${isSaveAndAdd }" />
					<table WIDTH="100%" BORDER="0" CELLSPACING="0" CELLPADDING="0">
						<tr>
							<td valign="middle" >
								<img src='${ basePath}/resource/base/js/dialog/skins/ico/right.gif'  />
							</td>
							<td valign="middle" >
								操作成功！
							</td>
						</tr>
					</table>
				</div>
				<script type="text/javascript">
					var DG = frameElement.lhgDG;
					DG.reDialogSize(360,200);
					DG.SetTitle("提示");
					for(var i = 0 ;i<DG.btns.length;i++){
						DG.removeBtn(DG.btns[i]);
					}
					DG.SetCancelBtn("确定");
				</script>
			</c:otherwise>
		</c:choose>
	</body>
</html>
