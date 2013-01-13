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

unit CnEditorOpenFile;
{* |<PRE>
================================================================================
* ������ƣ�CnPack IDE ר�Ұ�
* ��Ԫ���ƣ����ļ����ߵ�Ԫ
* ��Ԫ���ߣ��ܾ��� (zjy@cnpack.org)
* ��    ע��
* ����ƽ̨��PWin2000Pro + Delphi 5.01
* ���ݲ��ԣ�PWin9X/2000/XP + Delphi 5/6/7 + C++Builder 5/6
* �� �� �����ô����е��ַ��������ϱ��ػ�����ʽ
* ��Ԫ��ʶ��$Id: CnEditorOpenFile.pas 920 2011-07-13 01:14:36Z liuxiao@cnpack.org $
* �޸ļ�¼��2003.03.06 V1.1
*               ��չ��·��������Χ��֧�ֹ�������·��
*           2002.12.06 V1.0
*               ������Ԫ��ʵ�ֹ���
================================================================================
|</PRE>}

interface

{$I CnWizards.inc}

{$IFDEF CNWIZARDS_CNEDITORWIZARD}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, Menus,
  StdCtrls, IniFiles, ToolsAPI, CnConsts, CnWizUtils, CnEditorWizard, CnWizConsts,
  CnCommon;

type

//==============================================================================
// ���ļ�������
//==============================================================================

{ TCnEditorOpenFile }

  TCnEditorOpenFile = class(TCnBaseEditorTool)
  private
    class procedure DoFindFile(const FileName: string; const Info: TSearchRec;
      var Abort: Boolean);
  protected

  public
    function GetCaption: string; override;
    function GetHint: string; override;
    function GetDefShortCut: TShortCut; override;
    procedure Execute; override;
    procedure GetEditorInfo(var Name, Author, Email: string); override;

    class function SearchAndOpenFile(FileName: string): Boolean;
  end;

{$ENDIF CNWIZARDS_CNEDITORWIZARD}

implementation

{$IFDEF CNWIZARDS_CNEDITORWIZARD}

uses
  CnWizIdeUtils;

var
  SrcFile: string;
  DstFile: string;
  Found: Boolean = False;

// ��ָ�����ļ�
function DoOpenFile(const FileName: string): Boolean;
var
  F: TSearchRec;
  AName: string;
begin
  if FindFirst(FileName, faAnyFile, F) = 0 then
  begin
    AName := ExtractFilePath(FileName) + (F.Name); // ȡ����ʵ���ļ���
    FindClose(F);                                  // ��Ϊ�û�����Ŀ�����ȫСд
    CnOtaOpenFile(AName);
    Result := True;
  end
  else
    Result := False;
end;

//==============================================================================
// ���ļ�������
//==============================================================================

{ TCnEditorOpenFile }

class procedure TCnEditorOpenFile.DoFindFile(const FileName: string;
  const Info: TSearchRec; var Abort: Boolean);
begin
  if SameFileName(ExtractFileName(FileName), SrcFile) then
  begin
    DstFile := FileName;
    Found := True;
    Abort := True;
  end;
end;

procedure TCnEditorOpenFile.Execute;
var
  FileName: string;
  Ini: TCustomIniFile;
begin
  Ini := CreateIniFile;
  try
    FileName := CnInputBox(SCnEditorOpenFileDlgCaption,
      SCnEditorOpenFileDlgHint, '', Ini);
  finally
    Ini.Free;
  end;
  
  if FileName <> '' then
    if not SearchAndOpenFile(FileName) then
    begin
      // For Vcl.Forms like
      if IsDelphiRuntime then
        FileName := FileName + '.pas'
      else
        FileName := FileName + '.cpp';

      if not SearchAndOpenFile(FileName) then
        ErrorDlg(SCnEditorOpenFileNotFind);
    end;
end;

function TCnEditorOpenFile.GetCaption: string;
begin
  Result := SCnEditorOpenFileMenuCaption;
end;

function TCnEditorOpenFile.GetDefShortCut: TShortCut;
begin
{$IFDEF DELPHI}
  Result := ShortCut(Word('O'), [ssCtrl, ssAlt]);
{$ELSE}
  Result := 0;
{$ENDIF}
end;

function TCnEditorOpenFile.GetHint: string;
begin
  Result := SCnEditorOpenFileMenuHint;
end;

procedure TCnEditorOpenFile.GetEditorInfo(var Name, Author, Email: string);
begin
  Name := SCnEditorOpenFileName;
  Author := SCnPack_Zjy;
  Email := SCnPack_ZjyEmail;
end;

class function TCnEditorOpenFile.SearchAndOpenFile(
  FileName: string): Boolean;
var
  PathName: string;
  Paths: TStrings;
  i: Integer;
begin
  Result := True;
  if ExtractFileExt(FileName) = '' then
  begin
    if IsDelphiRuntime then
      FileName := FileName + '.pas'
    else
      FileName := FileName + '.cpp';
  end;

  Paths := TStringList.Create;
  try
    GetLibraryPath(Paths);
    for i := 0 to Paths.Count - 1 do
    begin
      PathName := MakePath(Paths[i]) + FileName;
      if DoOpenFile(PathName) then
        Exit;
    end;

    SrcFile := FileName;
    DstFile := '';
    Found := False;
    FindFile(MakePath(GetInstallDir) + 'Source\', '*.*', DoFindFile, nil, True, True);
    if Found and DoOpenFile(DstFile) then
      Exit
    else
      Result := False;

  finally
    Paths.Free;
  end;
end;

initialization
  RegisterCnEditor(TCnEditorOpenFile); // ע��ר��

{$ENDIF CNWIZARDS_CNEDITORWIZARD}
end.
