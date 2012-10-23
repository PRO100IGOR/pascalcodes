create table T_ACCESSORIES  (
   ACCE_ID              VARCHAR2(60)                    not null,
   ITEM_ID              VARCHAR2(160),
   FILE_PATH            VARCHAR2(200),
   FILE_NAME            VARCHAR2(200),
   FILE_SIZE            FLOAT(12),
   UPLOAD_DATE          VARCHAR2(20),
   SHOW_AS_IMAGE        INTEGER                        default 0,
   EMPLOYEENAME         VARCHAR2(32),
   EMPLOYEEID           VARCHAR2(32),
   FILETYPE             VARCHAR2(32),
   REALPATH             VARCHAR2(300),
   constraint PK_T_ACCESSORIES primary key (ACCE_ID)
);

comment on table T_ACCESSORIES is
'�������ϱ�(�������)';

comment on column T_ACCESSORIES.ACCE_ID is
'����ID';

comment on column T_ACCESSORIES.ITEM_ID is
'ҵ��ID';

comment on column T_ACCESSORIES.FILE_PATH is
'�ļ�·��';

comment on column T_ACCESSORIES.FILE_NAME is
'�ļ�����';

comment on column T_ACCESSORIES.FILE_SIZE is
'�ļ���С';

comment on column T_ACCESSORIES.UPLOAD_DATE is
'�ϴ�����';

comment on column T_ACCESSORIES.SHOW_AS_IMAGE is
'�Ƿ���ͼƬ��ʾ:0 ��1 ��';
