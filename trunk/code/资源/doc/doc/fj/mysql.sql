drop table if exists T_ACCESSORIES;

/*==============================================================*/
/* Table: T_ACCESSORIES                                         */
/*==============================================================*/
create table T_ACCESSORIES
(
   ACCE_ID              varchar(60) not null comment '附件ID',
   ITEM_ID              varchar(160) comment '业务ID',
   FILE_PATH            varchar(200) comment '文件路径',
   FILE_NAME            varchar(200) comment '文件名称',
   FILE_SIZE            float(12) comment '文件大小',
   UPLOAD_DATE          varchar(20) comment '上传日期',
   SHOW_AS_IMAGE        int default 0 comment '是否以图片显示:0 是1 否',
   EMPLOYEENAME         varchar(32),
   EMPLOYEEID           varchar(32),
   FILETYPE             varchar(32),
   REALPATH             varchar(300),
   primary key (ACCE_ID)
);

alter table T_ACCESSORIES comment '附件资料表(公共组件)';