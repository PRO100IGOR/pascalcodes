package com.sxsihe.coall.runapps.dao.hibernateImpl;
import com.sxsihe.oxhide.persistence.BaseDAOImpl;
import com.sxsihe.coall.runapps.domain.Runapps;
import com.sxsihe.coall.runapps.dao.RunappsDAO;
/**
 * 
 * <p>Title:com.sxsihe.coall.runapps.dao.hibernateImpl.RunappsDAOImpl</p>
 * <p>Description:runapps���ݲ�ʵ��</p>
 * <p>Copyright: Copyright (c) 2012</p>
 * <p>Company: �ĺͿƼ�</p>
 * @author �ų���
 * @version 1.0
 * @date 2012-10-30
 * @modify
 * @date
 */
public class RunappsDAOImpl extends BaseDAOImpl implements RunappsDAO {
	/**
	 * ������룬ָ��dao��Ӧʵ����
	 */
	public Class getEntityClass() {
		return Runapps.class;
	}
}
	