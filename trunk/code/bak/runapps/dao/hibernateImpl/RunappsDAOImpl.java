package com.sxsihe.coall.runapps.dao.hibernateImpl;
import com.sxsihe.oxhide.persistence.BaseDAOImpl;
import com.sxsihe.coall.runapps.domain.Runapps;
import com.sxsihe.coall.runapps.dao.RunappsDAO;
/**
 * 
 * <p>Title:com.sxsihe.coall.runapps.dao.hibernateImpl.RunappsDAOImpl</p>
 * <p>Description:runapps数据层实现</p>
 * <p>Copyright: Copyright (c) 2012</p>
 * <p>Company: 四和科技</p>
 * @author 张超超
 * @version 1.0
 * @date 2012-10-30
 * @modify
 * @date
 */
public class RunappsDAOImpl extends BaseDAOImpl implements RunappsDAO {
	/**
	 * 反射必须，指定dao对应实体类
	 */
	public Class getEntityClass() {
		return Runapps.class;
	}
}
	