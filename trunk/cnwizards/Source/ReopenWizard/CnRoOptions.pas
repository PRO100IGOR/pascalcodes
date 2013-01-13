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

unit CnRoOptions;
{ |<PRE>
================================================================================
* ������ƣ�CnPack IDE ר�Ұ�
* ��Ԫ���ƣ����ļ�ѡ�����õ�Ԫ
* ��Ԫ���ߣ�Leeon (real-like@163.com);
* ��    ע��
* ����ƽ̨��PWin2000Pro + Delphi 5.02
* ���ݲ��ԣ�PWin2000 + Delphi 5/6/7
* �� �� �����ô����е��ַ���֧�ֱ��ػ�����ʽ
* ��Ԫ��ʶ��$Id: CnRoOptions.pas 763 2011-02-07 14:18:23Z liuxiao@cnpack.org $
* �޸ļ�¼��2004-12-12 V1.1
*               �޸�ΪIRoOptions����
*           2004-03-02 V1.0
*               ��������ֲ��Ԫ
================================================================================
|</PRE>}

interface

{$I CnWizards.inc}

{$IFDEF CNWIZARDS_CNFILESSNAPSHOTWIZARD}

uses
  Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls, ComCtrls,
  ExtCtrls, Buttons, Inifiles, CnWizMultiLang, CnRoInterfaces, CnSpin;

type
  TCnRoOptionsDlg = class(TCnTranslateForm)
    cbDefaultPage: TComboBox;
    chkIgnoreDefault: TCheckBox;
    chkLocalDate: TCheckBox;
    chkSortPersistance: TCheckBox;
    Label6: TLabel;
    lblFav: TLabel;
    lblOth: TLabel;
    lblPj: TLabel;
    lblPjg: TLabel;
    lblPkg: TLabel;
    lblUnt: TLabel;
    pcOption: TPageControl;
    SpinEditBPG: TCnSpinEdit;
    SpinEditDPK: TCnSpinEdit;
    SpinEditDPR: TCnSpinEdit;
    SpinEditFAV: TCnSpinEdit;
    SpinEditOther: TCnSpinEdit;
    SpinEditPAS: TCnSpinEdit;
    tsCapacity: TTabSheet;
    tsSample: TTabSheet;
    btnOK: TButton;
    btnCancel: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure SpinLimited(Sender: TObject);
  public
    procedure GetMemento;
    procedure SetMemento;
  end;
  
var
  CnRoOptionsDlg: TCnRoOptionsDlg;

{$ENDIF CNWIZARDS_CNFILESSNAPSHOTWIZARD}

implementation

{$IFDEF CNWIZARDS_CNFILESSNAPSHOTWIZARD}

{$R *.DFM}

uses
  CnRoWizard, CnRoConst, CnRoFilesList;

{******************************* TCnRoOptionsDlg ******************************}

procedure TCnRoOptionsDlg.FormCreate(Sender: TObject);
begin
  pcOption.ActivePageIndex := 0;
end;

procedure TCnRoOptionsDlg.FormShow(Sender: TObject);
begin
  lblPjg.Caption := Format(lblPjg.Caption, [SProjectGroup]);
  lblPj.Caption := Format(lblPj.Caption, [SProject]);
  lblUnt.Caption := Format(lblUnt.Caption, [SUnt]);
  lblpkg.Caption := Format(lblpkg.Caption, [SPackge]);
end;

procedure TCnRoOptionsDlg.GetMemento;
begin
  with TCnFilesListForm(Owner) do
  begin
    with Options do
    begin
      Files[SProjectGroup].Capacity := SpinEditBPG.Value;
      Files[SPackge].Capacity := SpinEditDPK.Value;
      Files[SProject].Capacity := SpinEditDPR.Value;
      Files[SFavorite].Capacity := SpinEditFAV.Value;
      Files[SOther].Capacity := SpinEditOther.Value;
      Files[SUnt].Capacity := SpinEditPAS.Value;
  //      ColumnPersistance := chkColumnPersistance.Checked;
      DefaultPage := cbDefaultPage.ItemIndex;
      IgnoreDefaultUnits := chkIgnoreDefault.Checked;
      LocalDate := chkLocalDate.Checked;
      SortPersistance := chkSortPersistance.Checked;
      SaveSetting;
    end; //end with
  end;
end;

procedure TCnRoOptionsDlg.SetMemento;
begin
  with TCnFilesListForm(Owner) do
  begin
    with Options do
    begin
      cbDefaultPage.ItemIndex      := DefaultPage;
  //      chkColumnPersistance.Checked := ColumnPersistance;
      chkIgnoreDefault.Checked     := IgnoreDefaultUnits;
      chkLocalDate.Checked         := LocalDate;
      chkSortPersistance.Checked   := SortPersistance;
      SpinEditBPG.Value := Files[SProjectGroup].Capacity;
      SpinEditDPK.Value := Files[SPackge].Capacity;
      SpinEditDPR.Value := Files[SProject].Capacity;
      SpinEditFAV.Value := Files[SFavorite].Capacity;
      SpinEditOther.Value := Files[SOther].Capacity;
      SpinEditPAS.Value := Files[SUnt].Capacity;
    end; //end with
  end;
end;

procedure TCnRoOptionsDlg.SpinLimited(Sender: TObject);
begin
  if TCnSpinEdit(Sender).Value < 1 then TCnSpinEdit(Sender).Value := 1;
end;

{$ENDIF CNWIZARDS_CNFILESSNAPSHOTWIZARD}
end.

