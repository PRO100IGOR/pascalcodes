package com.sxsihe.base;

import java.util.HashMap;
import java.util.Map;

import com.sxsihe.oxhide.service.BaseServiceIface;
import com.sxsihe.oxhide.spring.SpringContextUtil;

/**
 * <p>
 * </p>
 * <p>
 * Description:DWR��,���ں�̨��������
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
	 * ���������������Ƿ����
	 *
	 * @param type
	 *            ��ӦSpring�����ļ���service bean id������·��,��һ����ĸСд
	 * @param id
	 *            ����
	 * @return true��ʾ����
	 */
	public boolean checkObjcect(String type, String id) {
		BaseServiceIface typesServiceIface = (BaseServiceIface) SpringContextUtil.getBean(type);
		Object o = typesServiceIface.findObjectBykey(id);
		return o != null;
	}
}
