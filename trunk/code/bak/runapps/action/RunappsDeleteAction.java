package com.sxsihe.coall.runapps.action;
import java.io.Serializable;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import java.util.List;
import com.sxsihe.oxhide.exception.BaseException;
import com.sxsihe.oxhide.struts.action.BaseDeleteAction;
import com.sxsihe.coall.runapps.domain.Runapps;
import com.sxsihe.accessories.AccessoriesService;
import com.sxsihe.oxhide.spring.SpringContextUtil;
/**
 * 
 * <p>Title:com.sxsihe.coall.runapps.action.RunappsDeleteAction</p>
 * <p>Description:runappsɾ��action</p>
 * <p>Copyright: Copyright (c) 2012</p>
 * <p>Company: �ĺͿƼ�</p>
 * @author �ų���
 * @version 1.0
 * @date 2012-10-30
 * @modify
 * @date
 */
 public class RunappsDeleteAction extends BaseDeleteAction {
	/**
	 * ɾ��֮ǰ����,����ֵ����null�Ļ�������ת
	 * @param mapping
	 * @param form
	 * @param request
	 * @param response
	 * @param ob ��Ҫɾ���Ķ���
	 * @throws BaseException
	 */
	public ActionForward preDelete(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response, Serializable ob) throws BaseException {
		if (ob != null) {
			Runapps runapps = (Runapps) ob;
			AccessoriesService accessService = (AccessoriesService) SpringContextUtil.getBean("accessService");
			accessService.deleteAccessory(""+runapps.getRunid()+"");
			}
		return null;
	}
	/**
	 * ɾ��֮�����,����ֵ����null�Ļ�������ת������ֵ
	 * @param mapping
	 * @param form
	 * @param request
	 * @param response
	 * @param ob ����ɾ��ʱ�Ķ���
	 * @param obs ���ɾ��ʱ�Ķ���
	 * @throws BaseException
	 */
	protected ActionForward afterDelete(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response, Serializable ob, List obs) throws BaseException {
		return null;
	}
 }
	