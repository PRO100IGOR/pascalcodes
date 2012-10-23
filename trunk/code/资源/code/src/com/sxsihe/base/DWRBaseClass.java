package com.sxsihe.base;

import java.util.HashMap;
import java.util.Map;

import com.sxsihe.oxhide.service.BaseServiceIface;
import com.sxsihe.oxhide.spring.SpringContextUtil;

/**
 * <p>
 * </p>
 * <p>
 * Description:DWR类,用于后台处理数据
 * </p>
 * <p>
 * copyright:copyright (c) 2009
 * </p>
 * <p>
 * Company:ITE
 * </p>
 *
 * @version 1.0
 * @builder 2010-02-03
 */
public class DWRBaseClass {

	/**
	 * 根据主键检查对象是否存在
	 *
	 * @param type
	 *            对应Spring配置文件中service bean id，不含路径,第一个字母小写
	 * @param id
	 *            主键
	 * @return true表示存在
	 */
	public boolean checkObjcect(String type, String id) {
		BaseServiceIface typesServiceIface = (BaseServiceIface) SpringContextUtil.getBean(type);
		Object o = typesServiceIface.findObjectBykey(id);
		return o != null;
	}
}
