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

unit CnViewSMRUnit;
{ |<PRE>
================================================================================
* ������ƣ�CnPack ��ִ���ļ���ϵ��������
* ��Ԫ���ƣ�SMR �鿴��Ԫ
* ��Ԫ���ߣ�Chinbo��Shenloqi��
* ��    ע��
* ����ƽ̨��PWin2000Pro + Delphi 5.01
* ���ݲ��ԣ�PWin9X/2000/XP + Delphi 5/6/7 + C++Builder 5/6
* �� �� �����õ�Ԫ�е��ַ���֧�ֱ��ػ�����ʽ
* ��Ԫ��ʶ��$Id: CnViewSMRUnit.pas 763 2011-02-07 14:18:23Z liuxiao@cnpack.org $
* �޸ļ�¼��2007.08.29 V1.0
*               ������Ԫ
================================================================================
|</PRE>}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, CnMainUnit, StdCtrls, Buttons, ExtCtrls, CnSMRUtils, Menus;

type
  TCnViewSMRForm = class(TForm, IUIInitializable)
    gpAnalyse: TPanel;
    pnlImpAffectModules: TPanel;
    Label1: TLabel;
    mmoAffects: TMemo;
    pnlSourceFiles: TPanel;
    Label3: TLabel;
    lsbFiles: TListBox;
    sbButtons: TScrollBox;
    odOpenFiles: TOpenDialog;
    sdAnalyseResults: TSaveDialog;
    Panel3: TPanel;
    Label2: TLabel;
    mmoAllAffects: TMemo;
    Label9: TLabel;
    edtSearchFile: TEdit;
    lblOpenedFile: TLabel;
    pmOpenFiles: TPopupMenu;
    miOpenFileManually: TMenuItem;
    N1: TMenuItem;
    odOpenSavedResults: TOpenDialog;
    gpAnalyseBtns: TPanel;
    btnOpenFiles: TBitBtn;
    btnClear: TBitBtn;
    btnPrevView: TBitBtn;
    btnNextView: TBitBtn;
    pnlAffectModules: TPanel;
    procedure pmOpenFilesPopup(Sender: TObject);
    procedure DoUpdateViews(Sender: TObject);
    procedure DoProcessKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure DoSearchByMask(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnNextViewClick(Sender: TObject);
    procedure btnPrevViewClick(Sender: TObject);
    procedure btnClearClick(Sender: TObject);
    procedure miOpenFileManuallyClick(Sender: TObject);
    procedure btnOpenFilesClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    FOpenedFiles: TStringList;
    FOpenedFileName: string;
    FAnalyseResults: TSMRList;
    FPrevList, FNextList: TStringList;
    FPreving, FNexting: Boolean;
    FUIUpdating: Boolean;
    FPopupMenuItemCount: Integer;

    procedure SetOpenedFileName(const Value: string);

    function CanViewNext: Boolean;
    function CanViewPrev: Boolean;
    function PrevNexting: Boolean;
    function GetMask: string;
    function GetSelectedFile: string;
    function IndexOfAnalyseResult(const s: string): Integer;
    function LastViewIs(const s: string): Boolean;
    function PrevNextProc: TPrevNextProc;

    procedure UpdateControlsState;
    procedure UpdateFileView; overload;
    procedure UpdateFileView(P: PSMR); overload;
    procedure UpdateFileView(ssAffectModules, ssAllAffectModules: TStrings); overload;
    procedure GetOpenedFiles(Files: TStrings; AllFiles: Boolean);
    procedure CMGetOpenedFiles(var Message: TMessage); message CM_GETOPENEDFILES;
    procedure CMGetFormIndex(var Message: TMessage); message CM_GETFORMINDEX;
    procedure OpenFileManually;
    procedure PrevBuildMenu(pm: TPopupMenu);
    procedure miOpenSpecifiedFileClick(Sender: TObject);
    procedure ClearPrev;
    procedure ClearNext;
    procedure ViewPrev;
    procedure ViewNext;
    procedure ViewAnalyseResults;
    procedure ViewByFile(const s: string);
    procedure LoadFromFile(const s: string);
  public
    { Public declarations }
    procedure UIInitialize;
    property OpenedFileName: string read FOpenedFileName write SetOpenedFileName;
  end;

implementation

uses
  CnBaseUtils;

{$R *.dfm}

procedure TCnViewSMRForm.btnClearClick(Sender: TObject);
begin
  FAnalyseResults.Clear;
  OpenedFileName := '';
  ViewAnalyseResults;
  UpdateControlsState;
end;

procedure TCnViewSMRForm.btnNextViewClick(Sender: TObject);
begin
  ViewNext;
end;

procedure TCnViewSMRForm.btnOpenFilesClick(Sender: TObject);
var
  Pos: TPoint;
begin
  if FOpenedFiles.Count = 0 then
  begin
    OpenFileManually;
  end
  else
  begin
    pmOpenFiles.PopupComponent := btnOpenFiles;
    Pos := btnOpenFiles.ClientToScreen(GetRectCenter(btnOpenFiles.ClientRect));// gpAnalyseBtns.ClientToScreen(GetRectCenter(GetControlRectInGridPanel(btnOpenFiles, gpAnalyseBtns)));
    pmOpenFiles.Popup(Pos.X, Pos.Y);
  end;
end;

procedure TCnViewSMRForm.btnPrevViewClick(Sender: TObject);
begin
  ViewPrev;
end;

function TCnViewSMRForm.CanViewNext: Boolean;
begin
  Result := FNextList.Count > 0;
end;

function TCnViewSMRForm.CanViewPrev: Boolean;
begin
  Result := FPrevList.Count > 1;
end;

procedure TCnViewSMRForm.ClearNext;
begin
  FNextList.Clear;
end;

procedure TCnViewSMRForm.ClearPrev;
begin
  FPrevList.Clear;
  FPrevList.Add('');
end;

procedure TCnViewSMRForm.CMGetFormIndex(var Message: TMessage);
begin
  Message.Result := 5;
end;

procedure TCnViewSMRForm.CMGetOpenedFiles(var Message: TMessage);
var
  Proc: TGetOpenedFilesProcObject;
begin
  if Message.WParam = Ord(aftSMR) then
  begin
    Proc := GetOpenedFiles;
    Message.Result := 1;
    Message.WParam := Integer(Pointer(@Proc));
    Message.LParam := Integer(Pointer(Self));
  end;
end;

procedure TCnViewSMRForm.DoSearchByMask(Sender: TObject);
var
  OldItemIndex: Integer;
  lsb: TListBox;
  msk: string;
begin
  lsb := lsbFiles;
  msk := GetMask;

  OldItemIndex := lsb.ItemIndex;
  lsb.Items.BeginUpdate;
  try
    lsb.ItemIndex := -1;
    lsbFindKey(lsb, msk, True, False, DefaultMatchProc);
  finally
    lsb.Items.EndUpdate;
  end;
  if (lsb.ItemIndex <> OldItemIndex) and Assigned(lsb.OnClick) then
  begin
    lsb.OnClick(lsb);
  end;
end;

procedure TCnViewSMRForm.DoProcessKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  lsb: TListBox;
begin
  lsb := lsbFiles;
  lsbProcessSearchKeyDown(lsb, GetMask, Key, Shift);
end;

procedure TCnViewSMRForm.FormCreate(Sender: TObject);
begin
  FOpenedFiles := TStringList.Create;
  FOpenedFiles.Sorted := True;
  FAnalyseResults := TSMRList.Create;
  FAnalyseResults.Sorted := True;
  FPrevList := TStringList.Create;
  FNextList := TStringList.Create;
  SetDlgInitialDir(Self);
  FPopupMenuItemCount := pmOpenFiles.Items.Count;
end;

procedure TCnViewSMRForm.FormDestroy(Sender: TObject);
begin
  FNextList.Clear;
  FPrevList.Clear;
  FNextList.Free;
  FPrevList.Free;
  FAnalyseResults.Free;
  FOpenedFiles.Free;
end;

function TCnViewSMRForm.GetMask: string;
begin
  Result := GetSearchMask(edtSearchFile.Text);
end;

procedure TCnViewSMRForm.GetOpenedFiles(Files: TStrings; AllFiles: Boolean);
begin
  if not Assigned(Files) then
  begin
    Exit;
  end;

  if AllFiles then
  begin
    Files.AddStrings(FOpenedFiles);
  end
  else
  begin
    Files.Add(OpenedFileName);
  end;
end;

function TCnViewSMRForm.GetSelectedFile: string;
begin
  Result := '';
  if lsbFiles.ItemIndex >= 0 then
  begin
    Result := lsbFiles.Items[lsbFiles.ItemIndex];
  end;
end;

function TCnViewSMRForm.IndexOfAnalyseResult(const s: string): Integer;
begin
  Result := -1;
  if s = '' then
  begin
    Exit;
  end;

  Result := FAnalyseResults.IndexOf(s);
end;

function TCnViewSMRForm.LastViewIs(const s: string): Boolean;
var
  idx: Integer;
begin
  idx := FPrevList.Count - 1;
  Result := (idx >= 0) and (FPrevList[idx] = s);
end;

procedure TCnViewSMRForm.LoadFromFile(const s: string);
begin
//  btnClear.Click;
  FAnalyseResults.LoadFromFile(s);
  OpenedFileName := s;
  ViewAnalyseResults;
  UpdateControlsState;
end;

procedure TCnViewSMRForm.DoUpdateViews(Sender: TObject);
var
  Proc: TPrevNextProc;
begin
  Proc := PrevNextProc();
  if Assigned(Proc) then
  begin
    Proc(GetSelectedFile);
  end;
end;

procedure TCnViewSMRForm.miOpenFileManuallyClick(Sender: TObject);
begin
  OpenFileManually;
end;

procedure TCnViewSMRForm.miOpenSpecifiedFileClick(Sender: TObject);
begin
  if Sender is TMenuItem then
  begin
    LoadFromFile(TMenuItem(Sender).Caption);
  end;
end;

procedure TCnViewSMRForm.OpenFileManually;
begin
  if odOpenSavedResults.Execute then
  begin
    LoadFromFile(odOpenSavedResults.FileName);
  end;
end;

procedure TCnViewSMRForm.pmOpenFilesPopup(Sender: TObject);
begin
  PrevBuildMenu(pmOpenFiles);
  BuildPopupMenu(pmOpenFiles, FOpenedFiles, miOpenSpecifiedFileClick);
end;

procedure TCnViewSMRForm.PrevBuildMenu(pm: TPopupMenu);
var
  i: Integer;
begin
  for i := pm.Items.Count - 1 downto FPopupMenuItemCount do
  begin
    pm.Items.Delete(i);
  end;
end;

function TCnViewSMRForm.PrevNexting: Boolean;
begin
  Result := FPreving or FNexting;
end;

function TCnViewSMRForm.PrevNextProc: TPrevNextProc;
begin
  Result := ViewByFile;
end;

procedure TCnViewSMRForm.SetOpenedFileName(const Value: string);
begin
  if Value <> '' then
  begin
    FOpenedFiles.Add(Value);
    if FOpenedFiles.Count > ciMaxFileList then
    begin
      FOpenedFiles.Delete(0);
    end;
  end;
  FOpenedFileName := Value;
  ClearPrev;
  ClearNext;
end;

procedure TCnViewSMRForm.UpdateControlsState;

  procedure EnableEdit(edt: TEdit; bEnabled: Boolean);
  begin
    if Assigned(edt) then
    begin
      edt.Enabled := bEnabled;
      if not bEnabled then
      begin
        edt.Clear;
      end;
    end;
  end;

var
  bEnabled: Boolean;
begin
  if FUIUpdating then
  begin
    Exit;
  end;

  FUIUpdating := True;
  try
    bEnabled := OpenedFileName <> '';

    if not bEnabled then
    begin
      lblOpenedFile.Caption := Format(SCnClickHintSMRFmt, [GetButtonCaption(btnOpenFiles)]);
//      lblOpenedFile.EllipsisPosition := epEndEllipsis;
    end
    else
    begin
      lblOpenedFile.Caption := Format(SCnBrowseHintSMRFmt, [OpenedFileName]);
//      lblOpenedFile.EllipsisPosition := epPathEllipsis;
    end;
    btnClear.Enabled := bEnabled;
    mmoAffects.Enabled := bEnabled;
    mmoAllAffects.Enabled := bEnabled;
    EnableEdit(edtSearchFile, bEnabled);
    btnPrevView.Enabled := bEnabled and CanViewPrev;
    btnNextView.Enabled := bEnabled and CanViewNext;

    if FPrevList.Count > ciMaxPrevNext then
    begin
      FPrevList.Delete(0);
    end;
  finally
    UpdateFileView;
    FUIUpdating := False;
  end;
end;

procedure TCnViewSMRForm.UpdateFileView;
var
  idx: Integer;
  s: string;
begin
  s := GetSelectedFile;
  idx := IndexOfAnalyseResult(s);
  UpdateFileView(FAnalyseResults.SMR[idx]);
end;

procedure TCnViewSMRForm.UpdateFileView(P: PSMR);
begin
  if not Assigned(P) then
  begin
    UpdateFileView(nil, nil);
  end
  else
  begin
    UpdateFileView(P.AffectModules, P.AllAffectModules);
  end;
end;

procedure TCnViewSMRForm.UpdateFileView(ssAffectModules,
  ssAllAffectModules: TStrings);
begin
  SyncMemoWithStrings(ssAffectModules, mmoAffects);
  SyncMemoWithStrings(ssAllAffectModules, mmoAllAffects);
end;

procedure TCnViewSMRForm.ViewAnalyseResults;
var
  i: Integer;
begin
  lsbFiles.Clear;
  if FAnalyseResults.Count > 0 then
  begin
    lsbFiles.Items.BeginUpdate;
    try
      for i := 0 to FAnalyseResults.Count - 1 do
      begin
        lsbFiles.Items.AddObject(FAnalyseResults.Strings[i], FAnalyseResults.Objects[i]);
      end;
    finally
      lsbAddHorizontalScrollBar(lsbFiles);
      lsbFiles.Items.EndUpdate;
    end;
  end;  
end;

procedure TCnViewSMRForm.ViewByFile(const s: string);
var
  idx: Integer;
begin
  idx := lsbFiles.Items.IndexOf(s);
  if PrevNexting or (idx >= 0) then
  begin
    lsbFiles.ItemIndex := idx;

    if not (PrevNexting or LastViewIs(s)) then
    begin
      FPrevList.Add(s);
      FNextList.Clear;
    end;

    if not PrevNexting then
    begin
      UpdateControlsState;
    end;
  end;
end;

procedure TCnViewSMRForm.ViewNext;
var
  idx: Integer;
  s: string;
  Proc: TPrevNextProc;
begin
  if not CanViewNext then
  begin
    Exit;
  end;
  FNexting := True;
  try
    idx := FNextList.Count - 1;
    s := FNextList[idx];
    Proc := PrevNextProc();
    if Assigned(Proc) then
    begin
      Proc(s);
    end;
    FPrevList.AddObject(s, FNextList.Objects[idx]);
    FNextList.Delete(idx);
  finally
    UpdateControlsState;
    FNexting := False;
  end;
end;

procedure TCnViewSMRForm.ViewPrev;
var
  idx: Integer;
  s: string;
  Proc: TPrevNextProc;
begin
  if not CanViewPrev then
  begin
    Exit;
  end;
  FPreving := True;
  try
    idx := FPrevList.Count - 2;
    s := FPrevList[idx];
    Proc := PrevNextProc();
    if Assigned(Proc) then
    begin
      Proc(s);
    end;
    FNextList.AddObject(FPrevList[idx + 1], FPrevList.Objects[idx + 1]);
    FPrevList.Delete(idx + 1);
  finally
    UpdateControlsState;
    FPreving := False;
  end;
end;

procedure TCnViewSMRForm.FormResize(Sender: TObject);
begin
  // realign controls
  pnlSourceFiles.Width := (gpAnalyse.ClientWidth - sbButtons.Width) div 2;
  pnlImpAffectModules.Height := pnlAffectModules.ClientHeight div 2;
end;

procedure TCnViewSMRForm.FormShow(Sender: TObject);
begin
  UpdateControlsState;
end;

procedure TCnViewSMRForm.UIInitialize;
begin
  WrapButtonsCaption(gpAnalyseBtns);
end;

initialization
  RegisterFormClass(TCnViewSMRForm);

end.
