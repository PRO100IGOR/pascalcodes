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

unit CnExploreDirectory;
{ |<PRE>
================================================================================
* ������ƣ�CnPack IDE ר�Ұ�
* ��Ԫ���ƣ��ļ�������ר�ҵ�Ԫ
* ��Ԫ���ߣ�Hhha��Hhha�� Hhha@eyou.con
* ��    ע��
* ����ƽ̨��PWin2000Pro + Delphi 7
* ���ݲ��ԣ�δ����
* �� �� �����ô����е��ַ��������ϱ��ػ�����ʽ
* ��Ԫ��ʶ��$Id: CnExploreDirectory.pas 763 2011-02-07 14:18:23Z liuxiao@cnpack.org $
* �޸ļ�¼��2004-01-18
*               ��ֲ������Ԫ���޸Ĳ������⡣
================================================================================
|</PRE>}

interface

{$I CnWizards.inc}

{$IFDEF CNWIZARDS_CNEXPLORERWIZARD}

uses
  Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls, Buttons,
  ExtCtrls, ComCtrls, ToolWin, CnWizConsts, CnWizMultiLang, CnWizShareImages;

type
  TCnExploreDirctoryForm = class(TCnTranslateForm)
    tlb: TToolBar;
    btnNew: TToolButton;
    btnDelete: TToolButton;
    btn4: TToolButton;
    btnClear: TToolButton;
    btn3: TToolButton;
    btnExit: TToolButton;
    lst: TListBox;
    stat: TStatusBar;
    procedure btnExitClick(Sender: TObject);
    procedure btnClearClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure btnNewClick(Sender: TObject);
    procedure lstDblClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  CnExploreDirctoryForm: TCnExploreDirctoryForm;

{$ENDIF CNWIZARDS_CNEXPLORERWIZARD}

implementation

{$IFDEF CNWIZARDS_CNEXPLORERWIZARD}

{$R *.dfm}

uses
  ShellAPI, ShlObj;

procedure TCnExploreDirctoryForm.btnExitClick(Sender: TObject);
begin
  Self.ModalResult := mrCancel;
end;

procedure TCnExploreDirctoryForm.btnClearClick(Sender: TObject);
begin
  Self.ModalResult := mrOK;
end;

procedure TCnExploreDirctoryForm.btnDeleteClick(Sender: TObject);
var
  i: Integer;
begin
  for i := lst.Items.Count - 1 downto 0 do
  begin
    if lst.Selected[i] then
      lst.Items.Delete(i);
  end;
end;

procedure TCnExploreDirctoryForm.btnNewClick(Sender: TObject);
var
  lpbi: TBrowseInfo;
  pidlResult: PItemIDList;
  sResult: string;
begin
  with lpbi do
  begin
    hwndOwner := Handle;
    GetMem(pszDisplayName, MAX_PATH);
    lpszTitle := PChar(SCnSelectDir);
    ulFlags := 1;
    SHGetSpecialFolderLocation(Handle, 17, pidlRoot);
    lpfn := nil;
  end;
  pidlResult := SHBrowseForFolder(lpbi);
  if SHGetPathFromIDList(pidlResult, lpbi.pszDisplayName) then
    sResult := StrPas(lpbi.pszDisplayName);
  FreeMem(lpbi.pszDisplayName);
  if (sResult <> '') and (lst.Items.IndexOf(sResult) < 0) then
    lst.Items.Add(sResult);
end;

procedure TCnExploreDirctoryForm.lstDblClick(Sender: TObject);
begin
  Self.ModalResult := mrOK;
end;

{$ENDIF CNWIZARDS_CNEXPLORERWIZARD}
end.

