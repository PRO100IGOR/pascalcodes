package com.sxsihe.coall.runapps.action;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.Serializable;
import org.apache.struts.action.ActionForm;
import com.sxsihe.oxhide.struts.action.BaseSaveAction;
import com.sxsihe.oxhide.exception.BaseException;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import com.sxsihe.coall.runapps.domain.Runapps;
import com.sxsihe.coall.runapps.form.RunappsForm;
/**
 * 
 * <p>Title:com.sxsihe.coall.runapps.action.RunappsSaveAction</p>
 * <p>Description:runapps����action</p>
 * <p>Copyright: Copyright (c) 2012</p>
 * <p>Company: �ĺͿƼ�</p>
 * @author �ų���
 * @version 1.0
 * @date 2012-10-30
 * @modify
 * @date
 */
 public class RunappsSaveAction extends BaseSaveAction {
	/**
	 * ��FORM�õ��־û�PO,���ת�����ӣ���������д
	 * 
	 * @param form
	 * @param type ��ӻ����޸�
	 * @return
	 */
	protected Serializable getPersisPo(ActionForm form, String type) {
		RunappsForm vForm = (RunappsForm) form;
		Runapps po;
		if (type.equals("add"))
			po = new Runapps();
		else {
			po = (Runapps) service.findObjectBykey(vForm.getRunid());
		}
		po.setRunid(vForm.getRunid());
		po.setRunname(vForm.getRunname());
		po.setRunpath(vForm.getRunpath());
		po.setNeedclose(vForm.getNeedclose());
		po.setEnable(vForm.getEnable());
		po.setRemark(vForm.getRemark());
		return po;
	}
	/**
	 * ����ǰ���õķ�������ֵ��Ϊ�ս�������ת
	 * 
	 * @param mainPo
	 * @param request
	 * @param type
	 */
	public ActionForward preAdd(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) throws BaseException{
		return null;
	}
	/**
	 * �޸�ǰ���õķ�������ֵ��Ϊ�ս�������ת
	 * 
	 * @param mainPo
	 * @param request
	 * @param type
	 */
	public ActionForward preUpdate(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) throws BaseException{
		return null;
	}
	/**
	 * ���Ӻ���õķ���,����null��ʾ������ɺ��������ӳɹ�ҳ�棬���������Զ����ַ
	 * 
	 * @param mainPo
	 * @param request
	 * @param type
	 */
	public ActionForward nextAdd(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response, Serializable po) {
		return null;
	}
	/**
	 * �޸ĺ���õķ���,����null��ʾ�޸���ɺ������޸ĳɹ�ҳ�棬���������Զ����ַ
	 * 
	 * @param mainPo
	 * @param request
	 * @param type
	 */
	public ActionForward nextUpdate(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response, Serializable po) {
		return null;
	}
	/**
	 * ������ʵ��Ĺ���ʵ��
	 * 
	 * @param mainPo
	 * @param request
	 * @param type
	 */
	protected void setPersistAssociatePo(Serializable mainPo, ActionForm form, HttpServletRequest request, String type) {
	}
	/**
	 * ��֤po������
	 * ���طǿ��ַ���������add��updateʱ�׳��쳣
	 * @param po
	 */
	protected String checkSave(Serializable po) {
		return null;
	}
 }
	