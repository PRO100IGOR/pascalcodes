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
 * <p>Description:runapps保存action</p>
 * <p>Copyright: Copyright (c) 2012</p>
 * <p>Company: 四和科技</p>
 * @author 张超超
 * @version 1.0
 * @date 2012-10-30
 * @modify
 * @date
 */
 public class RunappsSaveAction extends BaseSaveAction {
	/**
	 * 从FORM得到持久化PO,如果转换复杂，请子类重写
	 * 
	 * @param form
	 * @param type 添加还是修改
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
	 * 增加前调用的方法返回值不为空将引发跳转
	 * 
	 * @param mainPo
	 * @param request
	 * @param type
	 */
	public ActionForward preAdd(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) throws BaseException{
		return null;
	}
	/**
	 * 修改前调用的方法返回值不为空将引发跳转
	 * 
	 * @param mainPo
	 * @param request
	 * @param type
	 */
	public ActionForward preUpdate(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) throws BaseException{
		return null;
	}
	/**
	 * 增加后调用的方法,返回null表示增加完成后跳到增加成功页面，否则跳到自定义地址
	 * 
	 * @param mainPo
	 * @param request
	 * @param type
	 */
	public ActionForward nextAdd(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response, Serializable po) {
		return null;
	}
	/**
	 * 修改后调用的方法,返回null表示修改完成后跳到修改成功页面，否则跳到自定义地址
	 * 
	 * @param mainPo
	 * @param request
	 * @param type
	 */
	public ActionForward nextUpdate(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response, Serializable po) {
		return null;
	}
	/**
	 * 设置主实体的关联实体
	 * 
	 * @param mainPo
	 * @param request
	 * @param type
	 */
	protected void setPersistAssociatePo(Serializable mainPo, ActionForm form, HttpServletRequest request, String type) {
	}
	/**
	 * 验证po完整性
	 * 返回非空字符串将导致add、update时抛出异常
	 * @param po
	 */
	protected String checkSave(Serializable po) {
		return null;
	}
 }
	