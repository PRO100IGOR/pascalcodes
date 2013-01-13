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

unit CnExploreFilter;
{ |<PRE>
================================================================================
* ������ƣ�CnPack IDE ר�Ұ�
* ��Ԫ���ƣ��ļ�������ר�ҵ�Ԫ
* ��Ԫ���ߣ�Hhha��Hhha�� Hhha@eyou.con
* ��    ע��
* ����ƽ̨��PWin2000Pro + Delphi 7
* ���ݲ��ԣ�δ����
* �� �� �����ô����е��ַ��������ϱ��ػ�����ʽ
* ��Ԫ��ʶ��$Id: CnExploreFilter.pas 763 2011-02-07 14:18:23Z liuxiao@cnpack.org $
* �޸ļ�¼��
================================================================================
|</PRE>}

interface

{$I CnWizards.inc}

{$IFDEF CNWIZARDS_CNEXPLORERWIZARD}

uses
  Windows, SysUtils, Classes, Forms, Controls, ImgList, ComCtrls, ToolWin,
  Grids, ExtCtrls, StdCtrls, CnWizConsts, CnCommon, CnWizMultiLang,
  CnWizShareImages;

type
  TCnExploreFilterForm = class(TCnTranslateForm)
    tlb: TToolBar;
    btnNew: TToolButton;
    btnDelete: TToolButton;
    btn4: TToolButton;
    btnClear: TToolButton;
    btn3: TToolButton;
    btnFilter: TToolButton;
    btnDefault: TToolButton;
    Panel1: TPanel;
    grp: TGroupBox;
    chkFolder: TCheckBox;
    chkFiles: TCheckBox;
    chkHider: TCheckBox;
    stat: TStatusBar;
    lvFilter: TListView;
    procedure btnFilterClick(Sender: TObject);
    procedure btnClearClick(Sender: TObject);
    procedure btnNewClick(Sender: TObject);
    procedure btnDefaultClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnDeleteClick(Sender: TObject);
    procedure ValueListEditor1DblClick(Sender: TObject);
    procedure lvFilterDblClick(Sender: TObject);
  private
    { Private declarations }
    function GetSelected: Integer;
    procedure SetSelected(const Row: Integer);
    procedure LoadFilterSetting(const FileName: String);
    procedure SaveFilterSetting(const FileName: String);
  public
    { Public declarations }
    function FindFilter(const FilterKey: String; var Row: Integer): Boolean;
    procedure GetFilter(const Row: Integer; var FilterKey, Value: String);
    property Selected: Integer read GetSelected write SetSelected;
  end;

var
  CnExploreFilterForm: TCnExploreFilterForm;

{$ENDIF CNWIZARDS_CNEXPLORERWIZARD}

implementation

{$IFDEF CNWIZARDS_CNEXPLORERWIZARD}

uses
  CnExploreFilterEditor, CnWizOptions, CnWizUtils;

{$R *.dfm}

// ����Ĭ�ϵ��ļ����͹�����
procedure CreateDefaultFilter(lv: TListView);

  procedure NewItem(lv: TListView; Key, Value: String);
  var
    Item: TListItem;
  begin
    Item := lv.Items.Add;
    Item.Caption := Key;
    Item.SubItems.Add(Value);
  end;
begin
  if not Assigned(lv) then Exit;
  lv.Items.Clear;

  NewItem(lv, SCnExploreFilterAllFile, '*.*');
  NewItem(lv, SCnExploreFilterDelphiFile, '*.pas;*.inc;*.bpg;*.dpr;*.dpk;*.dpkw');
  NewItem(lv, SCnExploreFilterBCBFile, '*.cpp;*.c;*.hpp;*.h;*.bpr;*.bpk;*.bpkw;*.cbproj');
  NewItem(lv, SCnExploreFilterDelphiProjectFile, '*.bpr;*.bpg;*.dpr;*.bdsproj;*.dproj');
  NewItem(lv, SCnExploreFilterDelphiPackageFile, '*.dpk;*.dpkw;*.bpk;*.bpkw;*.bdsproj;*.dproj');
  NewItem(lv, SCnExploreFilterDelphiUnitFile, '*.pas;*.inc');
  NewItem(lv, SCnExploreFilterDelphiFormFile, '*.xfm;*.dfm');
  NewItem(lv, SCnExploreFilterConfigFile, '*.ini;*.conf;*.cfg;*.dof;*.dat');
  NewItem(lv, SCnExploreFilterTextFile, '*.txt');
  NewItem(lv, SCnExploreFilterSqlFile, '*.sql');
  NewItem(lv, SCnExploreFilterHtmlFile, '*.html;*.htm');
  NewItem(lv, SCnExploreFilterWebFile, '*.xml;*.xsl;*.wsdl;*.xsd');
  NewItem(lv, SCnExploreFilterBatchFile, '*.bat');
  NewItem(lv, SCnExploreFilterTypeLibFile, '*.tbl;*.dll;*.ocx;*.olb');
end;

procedure TCnExploreFilterForm.btnFilterClick(Sender: TObject);
begin
  CnExploreFilterForm.ModalResult := mrCancel;
end;

procedure TCnExploreFilterForm.btnClearClick(Sender: TObject);
begin
  CnExploreFilterForm.ModalResult := mrOK;
end;

procedure TCnExploreFilterForm.btnNewClick(Sender: TObject);
var
  Result: Integer;
  Item: TListItem;
begin
  CnExploreFilterEditorForm := TCnExploreFilterEditorForm.Create(nil);
  with CnExploreFilterEditorForm do
  try
    Result := ShowModal;
    if Result = mrOK then
    begin
      Item := lvFilter.Items.Add;
      Item.Caption := edtType.Text;
      Item.SubItems.Add(edtExtName.Text);
    end;
  finally
    Free;
    CnExploreFilterEditorForm := nil;
  end;
end;

procedure TCnExploreFilterForm.btnDeleteClick(Sender: TObject);
var
  Item: TListItem;
begin
  Item := lvFilter.Selected;
  if not Assigned(Item) then Exit;

  if QueryDlg(Format(SCnExploreFilterDeleteFmt, [Item.Caption,
    Item.SubItems.Strings[0]])) then
    Item.Delete;
end;

procedure TCnExploreFilterForm.btnDefaultClick(Sender: TObject);
begin
  if QueryDlg(SCnExploreFilterDefault) then
    CreateDefaultFilter(lvFilter);
end;

procedure TCnExploreFilterForm.FormCreate(Sender: TObject);
begin
  if FileExists(WizOptions.DataPath + SCnExploreFilterDataName) then
    LoadFilterSetting(WizOptions.DataPath + SCnExploreFilterDataName)
  else
    CreateDefaultFilter(lvFilter);
end;

procedure TCnExploreFilterForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  SaveFilterSetting(WizOptions.DataPath + SCnExploreFilterDataName);
end;

procedure TCnExploreFilterForm.ValueListEditor1DblClick(Sender: TObject);
begin
  CnExploreFilterForm.ModalResult := mrOK;
end;

procedure TCnExploreFilterForm.lvFilterDblClick(Sender: TObject);
begin
  CnExploreFilterForm.ModalResult := mrOK;
end;

procedure TCnExploreFilterForm.LoadFilterSetting(const FileName: String);
begin
end;

procedure TCnExploreFilterForm.SaveFilterSetting(const FileName: String);
begin
end;

function TCnExploreFilterForm.FindFilter(const FilterKey: String;
  var Row: Integer): Boolean;
var
  Item: TListItem;
begin
  Item := lvFilter.FindCaption(0, FilterKey, False, True, False);
  if Assigned(Item) then
    Row := lvFilter.Items.IndexOf(Item)
  else
    Row := -1;

  Result := (Row <> -1);
end;

procedure TCnExploreFilterForm.GetFilter(const Row: Integer;
  var FilterKey, Value: String);
var
  Item: TListItem;
begin
  Item := lvFilter.Items[Row];
  FilterKey := '';
  Value := '';
  if not Assigned(Item) then Exit;
  FilterKey := Item.Caption;
  Value := Item.SubItems.Strings[0];
end;

function TCnExploreFilterForm.GetSelected: Integer;
var
  Item: TListItem;
begin
  Item := lvFilter.Selected;
  Result := -1;
  if not Assigned(Item) then Exit;
  Result := lvFilter.Items.IndexOf(Item);
end;

procedure TCnExploreFilterForm.SetSelected(const Row: Integer);
begin
  lvFilter.Selected := lvFilter.Items[Row];
end;

{$ENDIF CNWIZARDS_CNEXPLORERWIZARD}
end.

