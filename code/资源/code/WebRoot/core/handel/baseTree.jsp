<%@ page contentType="text/html; charset=gbk"  
import="net.sf.json.JSONArray,
java.util.List,
com.sxsihe.oxhide.spring.SpringContextUtil,
com.sxsihe.utils.tld.tree.TreeService,
com.sxsihe.utils.tld.tree.TreeNode,
net.sf.json.JSONObject,
java.util.HashMap,
java.util.Map,
com.sxsihe.utils.common.StringUtils,
com.sxsihe.utils.common.CharsetSwitch" 
language="java" errorPage="" %>
<%
	TreeService treeService = (TreeService) SpringContextUtil.getBean(request.getParameter("service"));
    JSONObject param = JSONObject.fromObject(CharsetSwitch.decode(request.getParameter("param")));
    Map outParam = new HashMap();
    List<TreeNode> map = treeService.treeAsync(request.getParameter("nodeType"), request.getParameter("id"), request.getParameter("type"),param,outParam);
	if(!outParam.isEmpty()){
		for(Object key : outParam.keySet()){
			request.setAttribute(key+"", outParam.get(key));
		}
	}
	JSONArray array = JSONArray.fromObject(map);
	out.println(array);
%>