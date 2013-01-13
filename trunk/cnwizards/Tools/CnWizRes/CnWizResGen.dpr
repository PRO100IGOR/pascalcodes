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

program CnWizResGen;
{ |<PRE>
================================================================================
* ������ƣ�CnWizards IDE ר�ҹ��߰�
* ��Ԫ���ƣ�CnWizards ��Դ DLL RC �ļ����ɹ���
* ��Ԫ���ߣ��ܾ��� (zjy@cnpack.org)
* ��    ע���ù�������ɨ�� Icons Ŀ¼�µ�ͼ���λͼ������ RC �ļ�
* ����ƽ̨��PWinXP Pro + Delphi 5.01
* ���ݲ��ԣ�
* �� �� �����õ�Ԫ�е��ַ���֧�ֱ��ػ�����ʽ
* ��Ԫ��ʶ��$Id: CnWizResGen.dpr,v 1.6 2009/01/02 08:36:30 liuxiao Exp $
* �޸ļ�¼��2005.10.20
*               ������Ԫ��ʵ�ֹ���
================================================================================
|</PRE>}

{$APPTYPE CONSOLE}

uses
  Windows,
  Classes,
  SysUtils;

var
  IconPath: string;
  RcFile: string;
  Info: TSearchRec;
  Succ: Integer;
  Lines: TStringList;

begin
  if ParamCount <> 2 then
  begin
    Writeln('Usage: ' + ExtractFileName(ParamStr(0)) + ' IconPath RcFile');
    Exit;
  end;

  IconPath := IncludeTrailingBackslash(ParamStr(1));
  RcFile := ParamStr(2);
  Lines := TStringList.Create;
  try
    Succ := FindFirst(IconPath + '*.*', faAnyFile - faDirectory - faVolumeID, Info);
    try
      while Succ = 0 do
      begin
        if SameText(ExtractFileExt(Info.Name), '.ico') then
        begin
          Lines.Add(Format('%s ICON "%s"', [UpperCase(ChangeFileExt(
            ExtractFileName(Info.Name), '')), IconPath + Info.Name]));
        end
        else if SameText(ExtractFileExt(Info.Name), '.bmp') then
        begin
          Lines.Add(Format('%s BITMAP "%s"', [UpperCase(ChangeFileExt(
            ExtractFileName(Info.Name), '')), IconPath + Info.Name]));
        end;
        Succ := FindNext(Info);
      end;
    finally
      FindClose(Info);
    end;
    Lines.SaveToFile(RcFile);
  finally
    Lines.Free;
  end;          
end.
