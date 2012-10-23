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
'附件资料表(公共组件)';

comment on column T_ACCESSORIES.ACCE_ID is
'附件ID';

comment on column T_ACCESSORIES.ITEM_ID is
'业务ID';

comment on column T_ACCESSORIES.FILE_PATH is
'文件路径';

comment on column T_ACCESSORIES.FILE_NAME is
'文件名称';

comment on column T_ACCESSORIES.FILE_SIZE is
'文件大小';

comment on column T_ACCESSORIES.UPLOAD_DATE is
'上传日期';

comment on column T_ACCESSORIES.SHOW_AS_IMAGE is
'是否以图片显示:0 是1 否';
