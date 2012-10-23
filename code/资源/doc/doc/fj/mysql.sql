drop table if exists T_ACCESSORIES;

/*==============================================================*/
/* Table: T_ACCESSORIES                                         */
/*==============================================================*/
create table T_ACCESSORIES
(
   ACCE_ID              varchar(60) not null comment '����ID',
   ITEM_ID              varchar(160) comment 'ҵ��ID',
   FILE_PATH            varchar(200) comment '�ļ�·��',
   FILE_NAME            varchar(200) comment '�ļ�����',
   FILE_SIZE            float(12) comment '�ļ���С',
   UPLOAD_DATE          varchar(20) comment '�ϴ�����',
   SHOW_AS_IMAGE        int default 0 comment '�Ƿ���ͼƬ��ʾ:0 ��1 ��',
   EMPLOYEENAME         varchar(32),
   EMPLOYEEID           varchar(32),
   FILETYPE             varchar(32),
   REALPATH             varchar(300),
   primary key (ACCE_ID)
);

alter table T_ACCESSORIES comment '�������ϱ�(�������)';