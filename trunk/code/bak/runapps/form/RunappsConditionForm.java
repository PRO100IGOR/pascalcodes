package com.sxsihe.coall.runapps.form;
import com.sxsihe.oxhide.struts.form.BaseForm;
/**
 * 
 * <p>Title:com.sxsihe.coall.runapps.form.RunappsConditionForm</p>
 * <p>Description:运行者查询条件form</p>
 * <p>Copyright: Copyright (c) 2012</p>
 * <p>Company: 四和科技</p>
 * @author 张超超
 * @version 1.0
 * @date 2012-10-30
 * @modify
 * @date
 */
 public class RunappsConditionForm extends BaseForm {
	private String crunname;
	public void setCrunname(String crunname) {
		this.crunname = crunname;
	}
	public String getCrunname() {
		return this.crunname;
	}
	private String crunpath;
	public void setCrunpath(String crunpath) {
		this.crunpath = crunpath;
	}
	public String getCrunpath() {
		return this.crunpath;
	}
	}
	