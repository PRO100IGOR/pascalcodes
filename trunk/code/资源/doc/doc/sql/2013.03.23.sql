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
  `ID` varchar(32) NOT NULL COMMENT '����',
  `ITEMID` varchar(32) default NULL COMMENT '��ID',
  `REMOTEIP` varchar(32) default NULL COMMENT '����IP',
  `EMPLOYEEID` varchar(32) default NULL COMMENT '�û�',
  `EMPLOYEENAME` varchar(32) default NULL COMMENT '�����û���',
  `DESCS` varchar(500) default NULL COMMENT '�û���������',
  `REMARK` text COMMENT '��ע',
  `UPDATE_DATE` varchar(32) default NULL COMMENT '�޸�ʱ��',
  PRIMARY KEY  (`ID`)
);