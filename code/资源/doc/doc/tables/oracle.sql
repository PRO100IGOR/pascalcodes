
/*==============================================================*/
/* Table: COLUMNS                                               */
/*==============================================================*/
create table COLUMNS  (
   CID                  VARCHAR2(32)                    not null,
   TID                  VARCHAR2(32),
   CNAME                VARCHAR2(32),
   RULE                 VARCHAR2(4000),
   LTYPE                VARCHAR2(1),
   SHOWTYPE             VARCHAR2(1),
   ORDERNO              VARCHAR2(1),
   ISSHOW               VARCHAR2(1),
   WIDTH                VARCHAR2(32),
   CCODE                VARCHAR2(32),
   TIMER                VARCHAR2(32),
   DATA                 VARCHAR2(4000),
   GETDATA              VARCHAR2(1),
   ISMUST               VARCHAR2(1),
   ISMAIN               VARCHAR2(1),
   constraint PK_COLUMNS primary key (CID)
);

comment on column COLUMNS.CNAME is
'列名';

comment on column COLUMNS.RULE is
'规则';

comment on column COLUMNS.LTYPE is
'列类型 1主键 2主属性 3普通属性';

comment on column COLUMNS.SHOWTYPE is
'显示类型';

comment on column COLUMNS.ORDERNO is
'排序号';

comment on column COLUMNS.ISSHOW is
'显示到列表';

comment on column COLUMNS.WIDTH is
'列表宽度';

comment on column COLUMNS.CCODE is
'列编码';

comment on column COLUMNS.TIMER is
'时间控件';

comment on column COLUMNS.DATA is
'取数值';

comment on column COLUMNS.GETDATA is
'取数类型 1=不取，2=数据字典，3=静态';

comment on column COLUMNS.ISMUST is
'1=是 0=否';

comment on column COLUMNS.ISMAIN is
'1=是 0=否';

/*==============================================================*/
/* Table: DATAID                                                */
/*==============================================================*/
create table DATAID  (
   DTID                 VARCHAR2(32)                    not null,
   TID                  VARCHAR2(32),
   PDTID                VARCHAR2(32),
   constraint PK_DATAID primary key (DTID)
);

comment on column DATAID.PDTID is
'引用属性';

/*==============================================================*/
/* Table: DATAS                                                 */
/*==============================================================*/
create table DATAS  (
   DID                  VARCHAR2(32)                    not null,
   CID                  VARCHAR2(32),
   DTID                 VARCHAR2(32),
   DVALUE               VARCHAR2(4000),
   constraint PK_DATAS primary key (DID)
);

comment on column DATAS.CID is
'列ID';

comment on column DATAS.DTID is
'记录数';

comment on column DATAS.DVALUE is
'值';

/*==============================================================*/
/* Table: SELS                                                  */
/*==============================================================*/
create table SELS  (
   SID                  VARCHAR2(32)                    not null,
   CID                  VARCHAR2(32),
   TID                  VARCHAR2(32),
   SNAME                VARCHAR2(32),
   SWITH                INTEGER,
   ORDERNO              VARCHAR2(1),
   SHOWTYPE             VARCHAR2(200),
   CNAME                VARCHAR2(32),
   TIMER                VARCHAR2(32),
   GETDATA              VARCHAR2(1),
   DATA                 VARCHAR2(4000),
   constraint PK_SELS primary key (SID)
);

comment on column SELS.SNAME is
'名称';

comment on column SELS.SWITH is
'关系';

comment on column SELS.ORDERNO is
'排序号';

comment on column SELS.SHOWTYPE is
'显示类型';

comment on column SELS.CNAME is
'别名';

comment on column SELS.TIMER is
'时间控件';

comment on column SELS.GETDATA is
'取数类型 1=不取，2=数据字典，3=静态';

comment on column SELS.DATA is
'取数值';

/*==============================================================*/
/* Table: TABLES                                                */
/*==============================================================*/
create table TABLES  (
   TID                  VARCHAR2(32)                    not null,
   PTID                 VARCHAR2(32),
   TCODE                VARCHAR2(32),
   TNAME                VARCHAR2(32),
   REMARK               VARCHAR2(200),
   MAINCOL              VARCHAR2(32),
   MENUID               VARCHAR2(32),
   constraint PK_TABLES primary key (TID)
);

comment on column TABLES.PTID is
'父表';

comment on column TABLES.TCODE is
'表名';

comment on column TABLES.TNAME is
'中文名';

comment on column TABLES.REMARK is
'备注';

comment on column TABLES.MAINCOL is
'主要属性';

comment on column TABLES.MENUID is
'菜单ID';

alter table COLUMNS
   add constraint FK_COLUMNS_REFERENCE_TABLES foreign key (TID)
      references TABLES (TID);

alter table DATAID
   add constraint FK_DATAID_REFERENCE_DATAID foreign key (PDTID)
      references DATAID (DTID);

alter table DATAID
   add constraint FK_DATAID_REFERENCE_TABLES foreign key (TID)
      references TABLES (TID);

alter table DATAS
   add constraint FK_DATAS_REFERENCE_COLUMNS foreign key (CID)
      references COLUMNS (CID);

alter table DATAS
   add constraint FK_DATAS_REFERENCE_DATAID foreign key (DTID)
      references DATAID (DTID);

alter table SELS
   add constraint FK_SELS_REFERENCE_COLUMNS foreign key (CID)
      references COLUMNS (CID);

alter table SELS
   add constraint FK_SELS_REFERENCE_TABLES foreign key (TID)
      references TABLES (TID);

alter table TABLES
   add constraint FK_TABLES_REFERENCE_TABLES foreign key (PTID)
      references TABLES (TID);

