package com.sxsihe.coall.runapps.action;
import java.util.List;
import java.util.Map;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.commons.beanutils.BeanUtils;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import java.io.Serializable;
import com.sxsihe.oxhide.persistence.ConditionBlock;
import com.sxsihe.oxhide.persistence.ConditionLeaf;
import org.apache.commons.beanutils.PropertyUtils;
import com.sxsihe.oxhide.exception.BaseException;
import com.sxsihe.oxhide.struts.action.BaseShowAction;
import com.sxsihe.utils.tld.table.PagerForm;
import com.sxsihe.coall.runapps.domain.Runapps;
import com.sxsihe.coall.runapps.form.RunappsForm;
import com.sxsihe.oxhide.struts.domain.DeskWork;
/**
 * 
 * <p>Title:com.sxsihe.coall.runapps.action.RunappsShowAction</p>
 * <p>Description:runapps��ʾaction</p>
 * <p>Copyright: Copyright (c) 2012</p>
 * <p>Company: �ĺͿƼ�</p>
 * @author �ų���
 * @version 1.0
 * @date 2012-10-30
 * @modify
 * @date
 */
 public class RunappsShowAction extends BaseShowAction {
	
/**
 * �Զ���actionʵ��
 * @param request
 */
//	public ActionForward showTest(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) throws BaseException {
//		return null;
//		return new ActionForward(""); 
//		return mapping.findForward("test");
//	}
	/**
	 * �������˱��˵���ʾ��ʽΪ����ʾ������ʱ�����õķ�����������ʾ������ļ�¼,pageNO�ǵڼ�ҳ��count����ʾ����
	 * @param request
	 * @param po
	 */
	protected List<DeskWork> showDesk(int pageNO, int count) throws BaseException {
		return null;
	}
	/**
	 * �������˱��˵���ʾ��ʽΪ����ʾ������ʱ�����õķ�����������ʾ�����������
	 * @param request
	 * @param po
	 */
	protected int showDeskCount(HttpServletRequest request) throws BaseException {
		return 0;
	}
	/**
	 * ��ʾ����ҳ�����,����ֵ��Ϊ�ս�������ת
	 * 
	 * @param mapping
	 * @param form
	 * @param request
	 * @param response
	 * @throws BaseException
	 */
	protected ActionForward nextShowAdd(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) throws BaseException {
		return null;
	}
	/**
	 * ��ʾ�޸�ҳ�����,����ֵ��Ϊ�ս�������ת
	 * 
	 * @param mapping
	 * @param form
	 * @param request
	 * @param response
	 * @throws BaseException
	 */
	protected ActionForward nextShowUpdate(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response, Serializable po) throws BaseException {
		return null;
	}
	/**
	 * ��ʾ�б�ҳ�����,����ֵ��Ϊ�ս�������ת
	 * 
	 * @param mapping
	 * @param form
	 * @param request
	 * @param response
	 * @throws BaseException
	 */
	protected ActionForward nextShowList(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) throws BaseException {
		return null;
	}
	/** 
	 * ת��ʵ����Ϊform����
	 * @param po	
	 * @param form
	 * @return
	 */
	protected ActionForm getForm(Serializable po, ActionForm form) {
		try {
			if (form instanceof RunappsForm) {
				Runapps pos = (Runapps) po;
				RunappsForm vForm = (RunappsForm) form;
				BeanUtils.setProperty(vForm, "runid", PropertyUtils.getProperty(pos, "runid"));
				BeanUtils.setProperty(vForm, "runname", PropertyUtils.getProperty(pos, "runname"));
				BeanUtils.setProperty(vForm, "runpath", PropertyUtils.getProperty(pos, "runpath"));
				BeanUtils.setProperty(vForm, "needclose", PropertyUtils.getProperty(pos, "needclose"));
				BeanUtils.setProperty(vForm, "enable", PropertyUtils.getProperty(pos, "enable"));
				BeanUtils.setProperty(vForm, "remark", PropertyUtils.getProperty(pos, "remark"));
				}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return form;
	}
	/**
	 * ��ʾ�鿴ҳ������,����ֵ��Ϊ�ս�������ת
	 * 
	 * @param mapping
	 * @param form
	 * @param request
	 * @param response
	 * @return
	 * @throws BaseException
	 */
	protected ActionForward nextShowView(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response, Serializable po) throws BaseException {
		return null;
	}
	/**
	 * �Զ����ѯ�����ӿڷ���
	 * 
	 * @param conditionForm
	 * @param limit
	 * @return
	 */
	protected int customSelectCount(ActionForm conditionForm, HttpServletRequest request, HttpServletResponse response, PagerForm pagerForm) {
		ConditionBlock block = new ConditionBlock();
		return getService().getTotalObjects(block);
	}
	/**
	 * �Զ����ѯ�б�ӿڷ���
	 * 
	 * @param conditionForm
	 * @param limit
	 * @return
	 */
	protected List customSelect(ActionForm conditionForm, PagerForm pagerForm, HttpServletRequest request, HttpServletResponse response, ActionMapping mapping) {
		ConditionBlock block = new ConditionBlock();
		Map sortMap = pagerForm.getSortMap();
		return getService().findObjectsByCondition(block, sortMap, (pagerForm.getPage() - 1) * pagerForm.getCurrentRowsDisplayed(), pagerForm.getCurrentRowsDisplayed());
		}
 }
	