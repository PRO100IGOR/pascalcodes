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

unit CnFilterFrm;
{ |<PRE>
================================================================================
* ������ƣ�CnDebugViewer
* ��Ԫ���ƣ��������õ�Ԫ
* ��Ԫ���ߣ���Х��LiuXiao�� liuxiao@cnpack.org
* ��    ע��
* ����ƽ̨��PWin2000Pro + Delphi 5.01
* ���ݲ��ԣ�PWin9X/2000/XP + Delphi 5/6/7 + C++Builder 5/6
* �� �� �����õ�Ԫ�е��ַ���֧�ֱ��ػ�����ʽ
* ��Ԫ��ʶ��$Id: CnFilterFrm.pas 763 2011-02-07 14:18:23Z liuxiao@cnpack.org $
* �޸ļ�¼��2005.01.01
*               ������Ԫ��ʵ�ֹ���
================================================================================
|</PRE>}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, CheckLst, CnLangMgr;

type
  TCnSenderFilterFrm = class(TForm)
    grpSender: TGroupBox;
    chkEnable: TCheckBox;
    lblLevel: TLabel;
    cbbLevel: TComboBox;
    lblTag: TLabel;
    edtTag: TEdit;
    lblTypes: TLabel;
    btnOK: TButton;
    btnCancel: TButton;
    lstMsgTypes: TCheckListBox;
    procedure chkEnableClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure lstMsgTypesKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  protected
    procedure DoCreate; override;
  public
    { Public declarations }
    procedure LoadFromOptions;
    procedure SaveToOptions;
  end;

implementation

uses CnViewCore, CnDebugIntf;

{$R *.DFM}

{ TCnSenderFilterFrm }

procedure TCnSenderFilterFrm.LoadFromOptions;
var
  AType: TCnMsgType;
begin
  chkEnable.Checked := CnViewerOptions.EnableFilter;
  cbbLevel.ItemIndex := CnViewerOptions.FilterLevel;
  edtTag.Text := CnViewerOptions.FilterTag;

  for AType := Low(TCnMsgType) to High(TCnMsgType) do
    lstMsgTypes.Checked[Ord(AType)] := AType in CnViewerOptions.FilterTypes;
  if Assigned(chkEnable.OnClick) then
    chkEnable.OnClick(chkEnable);
end;

procedure TCnSenderFilterFrm.SaveToOptions;
var
  I: Integer;
begin
  CnViewerOptions.EnableFilter := chkEnable.Checked;
  CnViewerOptions.FilterLevel := cbbLevel.ItemIndex;
  CnViewerOptions.FilterTag := edtTag.Text;
  CnViewerOptions.FilterTypes := [];
  for I := 0 to lstMsgTypes.Items.Count - 1 do
    if lstMsgTypes.Checked[I] then
      CnViewerOptions.FilterTypes := CnViewerOptions.FilterTypes + [TCnMsgType(I)];
end;

procedure TCnSenderFilterFrm.chkEnableClick(Sender: TObject);
begin
  lblLevel.Enabled := chkEnable.Checked;
  lblTag.Enabled := chkEnable.Checked;
  lblTypes.Enabled := chkEnable.Checked;
  cbbLevel.Enabled := chkEnable.Checked;
  edtTag.Enabled := chkEnable.Checked;
  lstMsgTypes.Enabled := chkEnable.Checked;
end;

procedure TCnSenderFilterFrm.FormCreate(Sender: TObject);
var
  I: Integer;
begin
  // ��ʼ�� CheckListBox
  lstMsgTypes.Clear;
  for I := Ord(Low(TCnMsgType)) to Ord(High(TCnMsgType)) do
    lstMsgTypes.Items.Add(SCnMsgTypeDescArray[TCnMsgType(I)]^);
end;

procedure TCnSenderFilterFrm.DoCreate;
begin
  inherited;
  CnLanguageManager.TranslateForm(Self);
end;

procedure TCnSenderFilterFrm.lstMsgTypesKeyPress(Sender: TObject;
  var Key: Char);
var
  I: Integer;
begin
  if Key = #1 then // Ctrl+A
  begin
    Key := #0;
    for I := 0 to lstMsgTypes.Items.Count - 1 do
      lstMsgTypes.Checked[I] := True;
  end
  else if Key = #4 then // Ctrl+D
  begin
    Key := #0;
    for I := 0 to lstMsgTypes.Items.Count - 1 do
      lstMsgTypes.Checked[I] := False;
  end
end;

end.
