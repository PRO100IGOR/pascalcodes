alter table EMPLOYEE add column EMPTYPE varchar(32);
alter table EMPLOYEE add column DEPTID varchar(32);
alter table EMPLOYEE add column ORGANID varchar(32);
alter table EMPLOYEE
   add constraint FK_EMPLOYEE_REFERENCE_DEPTMENT foreign key (DEPTID)
      references DEPTMENT (DEPTID);

alter table EMPLOYEE
   add constraint FK_EMPLOYEE_REFERENCE_ORGAN foreign key (ORGANID)
      references ORGAN (ORGANID);


alter table POSTS add column ORGANID varchar(32);

alter table POSTS
   add constraint FK_POSTS_REFERENCE_ORGAN foreign key (ORGANID)
      references ORGAN (ORGANID);


update EMPLOYEE  e set DEPTID = (select DEPTID from posts p where p.POSTID = e.POSTID);
update EMPLOYEE  e set ORGANID = (select ORGANID from deptment p where p.DEPTID = e.DEPTID);
update POSTS  e set ORGANID = (select ORGANID from deptment p where p.DEPTID = e.DEPTID);


CREATE TABLE `formrecord` (
  `ID` varchar(32) NOT NULL COMMENT '主键',
  `ITEMID` varchar(32) default NULL COMMENT '项ID',
  `REMOTEIP` varchar(32) default NULL COMMENT '访问IP',
  `EMPLOYEEID` varchar(32) default NULL COMMENT '用户',
  `EMPLOYEENAME` varchar(32) default NULL COMMENT '操作用户名',
  `DESCS` varchar(500) default NULL COMMENT '用户操作描述',
  `REMARK` text COMMENT '备注',
  `UPDATE_DATE` varchar(32) default NULL COMMENT '修改时间',
  PRIMARY KEY  (`ID`)
);