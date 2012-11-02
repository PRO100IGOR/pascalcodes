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
 * <p>Description:runapps显示action</p>
 * <p>Copyright: Copyright (c) 2012</p>
 * <p>Company: 四和科技</p>
 * @author 张超超
 * @version 1.0
 * @date 2012-10-30
 * @modify
 * @date
 */
 public class RunappsShowAction extends BaseShowAction {
	
/**
 * 自定义action实例
 * @param request
 */
//	public ActionForward showTest(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) throws BaseException {
//		return null;
//		return new ActionForward(""); 
//		return mapping.findForward("test");
//	}
	/**
	 * 当设置了本菜单显示方式为：显示到桌面时，调用的方法，返回显示在桌面的记录,pageNO是第几页，count是显示几条
	 * @param request
	 * @param po
	 */
	protected List<DeskWork> showDesk(int pageNO, int count) throws BaseException {
		return null;
	}
	/**
	 * 当设置了本菜单显示方式为：显示到桌面时，调用的方法，返回显示在桌面的条数
	 * @param request
	 * @param po
	 */
	protected int showDeskCount(HttpServletRequest request) throws BaseException {
		return 0;
	}
	/**
	 * 显示增加页面后处理,返回值不为空将引发跳转
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
	 * 显示修改页面后处理,返回值不为空将引发跳转
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
	 * 显示列表页面后处理,返回值不为空将引发跳转
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
	 * 转换实体类为form对象
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
	 * 显示查看页面后调用,返回值不为空将引发跳转
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
	 * 自定义查询个数接口方法
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
	 * 自定义查询列表接口方法
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
	