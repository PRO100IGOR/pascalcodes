
/*==============================================================*/
create table COLUMNS
(
   CID                  varchar(32) not null,
   TID                  varchar(32),
   CNAME                varchar(32) comment '����',
   RULE                 varchar(4000) comment '����',
   LTYPE                varchar(1) comment '������ 1���� 2������ 3��ͨ����',
   SHOWTYPE             varchar(1) comment '��ʾ����',
   ORDERNO              varchar(1) comment '�����',
   ISSHOW               varchar(1) comment '��ʾ���б�',
   WIDTH                varchar(32) comment '�б���',
   CCODE                varchar(32) comment '�б���',
   TIMER                varchar(32) comment 'ʱ��ؼ�',
   DATA                 varchar(4000) comment 'ȡ��ֵ',
   GETDATA              varchar(1) comment 'ȡ������ 1=��ȡ��2=�����ֵ䣬3=��̬',
   ISMUST               varchar(1) comment '1=�� 0=��',
   ISMAIN               varchar(1) comment '1=�� 0=��',
   primary key (CID)
);

/*==============================================================*/
/* Table: DATAID                                                */
/*==============================================================*/
create table DATAID
(
   DTID                 varchar(32) not null,
   TID                  varchar(32),
   PDTID                varchar(32) comment '��������',
   primary key (DTID)
);

/*==============================================================*/
/* Table: DATAS                                                 */
/*==============================================================*/
create table DATAS
(
   DID                  varchar(32) not null,
   CID                  varchar(32) comment '��ID',
   DTID                 varchar(32) comment '��¼��',
   DVALUE               varchar(4000) comment 'ֵ',
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
   SNAME                varchar(32) comment '����',
   SWITH                int(3) comment '��ϵ',
   ORDERNO              varchar(1) comment '�����',
   SHOWTYPE             varchar(200) comment '��ʾ����',
   CNAME                varchar(32) comment '����',
   TIMER                varchar(32) comment 'ʱ��ؼ�',
   GETDATA              varchar(1) comment 'ȡ������ 1=��ȡ��2=�����ֵ䣬3=��̬',
   DATA                 varchar(4000) comment 'ȡ��ֵ',
   primary key (SID)
);

/*==============================================================*/
/* Table: TABLES                                                */
/*==============================================================*/
create table TABLES
(
   TID                  varchar(32) not null,
   PTID                 varchar(32) comment '����',
   TCODE                varchar(32) comment '����',
   TNAME                varchar(32) comment '������',
   REMARK               varchar(200) comment '��ע',
   MAINCOL              varchar(32) comment '��Ҫ����',
   MENUID               varchar(32) comment '�˵�ID',
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

