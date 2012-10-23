
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
'����';

comment on column COLUMNS.RULE is
'����';

comment on column COLUMNS.LTYPE is
'������ 1���� 2������ 3��ͨ����';

comment on column COLUMNS.SHOWTYPE is
'��ʾ����';

comment on column COLUMNS.ORDERNO is
'�����';

comment on column COLUMNS.ISSHOW is
'��ʾ���б�';

comment on column COLUMNS.WIDTH is
'�б���';

comment on column COLUMNS.CCODE is
'�б���';

comment on column COLUMNS.TIMER is
'ʱ��ؼ�';

comment on column COLUMNS.DATA is
'ȡ��ֵ';

comment on column COLUMNS.GETDATA is
'ȡ������ 1=��ȡ��2=�����ֵ䣬3=��̬';

comment on column COLUMNS.ISMUST is
'1=�� 0=��';

comment on column COLUMNS.ISMAIN is
'1=�� 0=��';

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
'��������';

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
'��ID';

comment on column DATAS.DTID is
'��¼��';

comment on column DATAS.DVALUE is
'ֵ';

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
'����';

comment on column SELS.SWITH is
'��ϵ';

comment on column SELS.ORDERNO is
'�����';

comment on column SELS.SHOWTYPE is
'��ʾ����';

comment on column SELS.CNAME is
'����';

comment on column SELS.TIMER is
'ʱ��ؼ�';

comment on column SELS.GETDATA is
'ȡ������ 1=��ȡ��2=�����ֵ䣬3=��̬';

comment on column SELS.DATA is
'ȡ��ֵ';

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
'����';

comment on column TABLES.TCODE is
'����';

comment on column TABLES.TNAME is
'������';

comment on column TABLES.REMARK is
'��ע';

comment on column TABLES.MAINCOL is
'��Ҫ����';

comment on column TABLES.MENUID is
'�˵�ID';

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

