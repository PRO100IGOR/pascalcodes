{******************************************************************************}
{                       CnPack For Delphi/C++Builder                           }
{                     �й����Լ��Ŀ���Դ�������������                         }
{                   (C)Copyright 2001-2011 CnPack ������                       }
{                   ------------------------------------                       }
{                                                                              }
{            ���������ǿ�Դ��������������������� CnPack �ķ���Э������        }
{        �ĺ����·�����һ����                                                }
{                                                                              }
{            ������һ��������Ŀ����ϣ�������ã���û���κε���������û��        }
{        �ʺ��ض�Ŀ�Ķ������ĵ���������ϸ���������� CnPack ����Э�顣        }
{                                                                              }
{            ��Ӧ���Ѿ��Ϳ�����һ���յ�һ�� CnPack ����Э��ĸ��������        }
{        ��û�У��ɷ������ǵ���վ��                                            }
{                                                                              }
{            ��վ��ַ��http://www.cnpack.org                                   }
{            �����ʼ���master@cnpack.org                                       }
{                                                                              }
{******************************************************************************}

unit CnRoConst;
{ |<PRE>
================================================================================
* ������ƣ�CnPack IDE ר�Ұ�
* ��Ԫ���ƣ�����ʷ�ļ�������Ԫ
* ��Ԫ���ߣ�Leeon (real-like@163.com)
* ��    ע��
* ����ƽ̨��PWin2000Pro + Delphi 6.10
* ���ݲ��ԣ�PWin2000 + Delphi 5/6/7
* �� �� �����ô����е��ַ���֧�ֱ��ػ�����ʽ
* ��Ԫ��ʶ��$Id: CnRoConst.pas 763 2011-02-07 14:18:23Z liuxiao@cnpack.org $
* �޸ļ�¼��2004-12-11 V1.0
*               ������Ԫ
================================================================================
|</PRE>}

interface

{$I CnWizards.inc}

{$IFDEF CNWIZARDS_CNFILESSNAPSHOTWIZARD}

const
  SSeparator = '|';
  SFilePrefix = 'No';
  SSection = '[%s]';
  SCapacity = 'Capacity';
  SDefaults = 'Defaults';
  SPersistance = 'Persistance';
  SProjectGroup = 'bpg';
  SFavorite = 'fav';
  SOther = 'oth';
{$IFDEF DELPHI}
  SCnRecentFile = 'RecentFiles.ini';
  SProject = 'dpr';
  SPackge = 'dpk';
  SUnt = 'pas';
{$ELSE}
  SCnRecentFile = 'RecentFiles_BCB.ini';
  SProject = 'bpr';
  SPackge = 'bpk';
  SUnt = 'cpp';
{$ENDIF}
  SIgnoreDefaultUnits = 'IgnoreDefaultUnits';
  SDefaultPage = 'DefaultPage';
  SFormPersistance = 'FormPersistance';
  SSortPersistance = 'SortPersistance';
  SColumnPersistance = 'ColumnPersistance';
  SLocalDate = 'LocalDate';
  SAutoSaveInterval = 'AutoSaveInterval';

  SColumnSorting = 'ColumnSorting';
  SDataFormat = 'yyyy-mm-dd hh:nn:ss';

  PageSize = 1024;
  iDefaultFileQty = 20;
  LowFileType = 0;
  HighFileType = 5;
  FileType: array[LowFileType..HighFileType] of string =
    (SProjectGroup, SProject, SPackge, SUnt, SFavorite, SOther);

{$ENDIF CNWIZARDS_CNFILESSNAPSHOTWIZARD}

implementation

end.


