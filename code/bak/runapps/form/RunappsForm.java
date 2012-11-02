package com.sxsihe.coall.runapps.form;
import com.sxsihe.oxhide.struts.form.BaseForm;
/**
 * 
 * <p>Title:com.sxsihe.coall.runapps.form.RunappsForm</p>
 * <p>Description:runapps表单form</p>
 * <p>Copyright: Copyright (c) 2012</p>
 * <p>Company: 四和科技</p>
 * @author 张超超
 * @version 1.0
 * @date 2012-10-30
 * @modify
 * @date
 */
 public class RunappsForm extends BaseForm {
	private String runid;
	public void setRunid(String runid) {
		this.runid = runid;
	}
	public String getRunid() {
		return this.runid;
	}
	private String runname;
	public void setRunname(String runname) {
		this.runname = runname;
	}
	public String getRunname() {
		return this.runname;
	}
	private String runpath;
	public void setRunpath(String runpath) {
		this.runpath = runpath;
	}
	public String getRunpath() {
		return this.runpath;
	}
	private String needclose;
	public void setNeedclose(String needclose) {
		this.needclose = needclose;
	}
	public String getNeedclose() {
		return this.needclose;
	}
	private String enable;
	public void setEnable(String enable) {
		this.enable = enable;
	}
	public String getEnable() {
		return this.enable;
	}
	private String remark;
	public void setRemark(String remark) {
		this.remark = remark;
	}
	public String getRemark() {
		return this.remark;
	}
	}
	