
/*==============================================================*/
create table COLUMNS
(
   CID                  varchar(32) not null,
   TID                  varchar(32),
   CNAME                varchar(32) comment '列名',
   RULE                 varchar(4000) comment '规则',
   LTYPE                varchar(1) comment '列类型 1主键 2主属性 3普通属性',
   SHOWTYPE             varchar(1) comment '显示类型',
   ORDERNO              varchar(1) comment '排序号',
   ISSHOW               varchar(1) comment '显示到列表',
   WIDTH                varchar(32) comment '列表宽度',
   CCODE                varchar(32) comment '列编码',
   TIMER                varchar(32) comment '时间控件',
   DATA                 varchar(4000) comment '取数值',
   GETDATA              varchar(1) comment '取数类型 1=不取，2=数据字典，3=静态',
   ISMUST               varchar(1) comment '1=是 0=否',
   ISMAIN               varchar(1) comment '1=是 0=否',
   primary key (CID)
);

/*==============================================================*/
/* Table: DATAID                                                */
/*==============================================================*/
create table DATAID
(
   DTID                 varchar(32) not null,
   TID                  varchar(32),
   PDTID                varchar(32) comment '引用属性',
   primary key (DTID)
);

/*==============================================================*/
/* Table: DATAS                                                 */
/*==============================================================*/
create table DATAS
(
   DID                  varchar(32) not null,
   CID                  varchar(32) comment '列ID',
   DTID                 varchar(32) comment '记录数',
   DVALUE               varchar(4000) comment '值',
   primary key (DID)
);

/*==============================================================*/
/* Table: SELS                                                  */
/*==============================================================*/
create table SELS
(
   SID                  varchar(32) not null,
   CID                  varchar(32),
   TID                  varchar(32),
   SNAME                varchar(32) comment '名称',
   SWITH                int(3) comment '关系',
   ORDERNO              varchar(1) comment '排序号',
   SHOWTYPE             varchar(200) comment '显示类型',
   CNAME                varchar(32) comment '别名',
   TIMER                varchar(32) comment '时间控件',
   GETDATA              varchar(1) comment '取数类型 1=不取，2=数据字典，3=静态',
   DATA                 varchar(4000) comment '取数值',
   primary key (SID)
);

/*==============================================================*/
/* Table: TABLES                                                */
/*==============================================================*/
create table TABLES
(
   TID                  varchar(32) not null,
   PTID                 varchar(32) comment '父表',
   TCODE                varchar(32) comment '表名',
   TNAME                varchar(32) comment '中文名',
   REMARK               varchar(200) comment '备注',
   MAINCOL              varchar(32) comment '主要属性',
   MENUID               varchar(32) comment '菜单ID',
   primary key (TID)
);

alter table COLUMNS add constraint FK_Reference_9 foreign key (TID)
      references TABLES (TID) on delete restrict on update restrict;

alter table DATAID add constraint FK_Reference_10 foreign key (PDTID)
      references DATAID (DTID) on delete restrict on update restrict;

alter table DATAID add constraint FK_Reference_4 foreign key (TID)
      references TABLES (TID) on delete restrict on update restrict;

alter table DATAS add constraint FK_Reference_2 foreign key (CID)
      references COLUMNS (CID) on delete restrict on update restrict;

alter table DATAS add constraint FK_Reference_3 foreign key (DTID)
      references DATAID (DTID) on delete restrict on update restrict;

alter table SELS add constraint FK_Reference_6 foreign key (CID)
      references COLUMNS (CID) on delete restrict on update restrict;

alter table SELS add constraint FK_Reference_7 foreign key (TID)
      references TABLES (TID) on delete restrict on update restrict;

alter table TABLES add constraint FK_Reference_8 foreign key (PTID)
      references TABLES (TID) on delete restrict on update restrict;

