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

unit CnRoWizard;
{ |<PRE>
================================================================================
* ������ƣ�CnPack IDE ר�Ұ�
* ��Ԫ���ƣ�����ʷ�ļ�������Ԫ
* ��Ԫ���ߣ�Leeon (real-like@163.com);
* ��    ע��
* ����ƽ̨��PWin2000Pro + Delphi 5.02
* ���ݲ��ԣ�PWin2000 + Delphi 5/6/7
* �� �� �����ô����е��ַ���֧�ֱ��ػ�����ʽ
* ��Ԫ��ʶ��$Id: CnRoWizard.pas 763 2011-02-07 14:18:23Z liuxiao@cnpack.org $
* �޸ļ�¼��2004-12-12 V1.2
*               �޸�ΪIReopener����
*           2004.07.22 V1.1
*               ��ֲ���ļ�����ר�ң��޸�Ĭ�Ͽ�ݼ�
*           2004.03.02 V1.0
*               ��������ֲ��Ԫ
================================================================================
|</PRE>}

interface

{$I CnWizards.inc}

{$IFDEF CNWIZARDS_CNFILESSNAPSHOTWIZARD}

uses
  SysUtils, Classes, ToolsAPI, Menus, ExtCtrls,
  CnWizNotifier, CnWizUtils, CnRoFilesList, CnRoInterfaces, CnRoClasses;

type
  TCnFileReopener = class(TObject)
  private
    FFilesListForm: TCnFilesListForm;
    FReopener: ICnReopener;
    FChanged: Boolean;
    FTimer: TTimer;
  protected
    function GetReopen: ICnReopener;
    function GetRoOptions: ICnRoOptions;
    procedure Notify(NotifyCode: TOTAFileNotification; const FileName: string);
    procedure TimerOnTimer(Sender: TObject);
  public
    constructor Create;
    destructor Destroy; override;
    procedure Execute;
    function GetDefShortCut: TShortCut;

    property FilesListForm: TCnFilesListForm read FFilesListForm write FFilesListForm;
  end;
  
var
  FormOpened: Boolean = False;

{$ENDIF CNWIZARDS_CNFILESSNAPSHOTWIZARD}

implementation

{$IFDEF CNWIZARDS_CNFILESSNAPSHOTWIZARD}

{****************************** TCnFileReopener *******************************}

constructor TCnFileReopener.Create;
begin
  inherited Create;
  CnWizNotifierServices.AddFileNotifier(Notify);
  FTimer := TTimer.Create(nil);
  FTimer.Interval := 1000 * 5;
  FTimer.Enabled := False;
  FTimer.OnTimer := TimerOnTimer;
end;

destructor TCnFileReopener.Destroy;
begin
  FReopener := nil;
  FTimer.Free;
  CnWizNotifierServices.RemoveFileNotifier(Notify);
  inherited Destroy;
end;

procedure TCnFileReopener.Execute;
begin
  if not FormOpened then
  begin
    try
      FFilesListForm := TCnFilesListForm.Create(GetRoOptions);
      FormOpened := True;
    except
      FormOpened := False;
    end;
  end;
  FFilesListForm.Show;
end;

function TCnFileReopener.GetDefShortCut: TShortCut;
begin
  Result := ShortCut(Word('O'), [ssShift, ssCtrl]);
end;

function TCnFileReopener.GetReopen: ICnReopener;
var
  Ini: ICnRoOptions;
begin
  if not Assigned(FReopener) then
  begin
    FReopener := GetReopener();
    if Supports(FReopener, ICnRoOptions, Ini) then
    begin
      if Ini.AutoSaveInterval > 0 then
      begin
        FTimer.Interval := Ini.AutoSaveInterval * 1000;
        FTimer.Enabled := True;
      end
      else
        FTimer.Enabled := False;
    end;
  end;
  Result := FReopener;
end;

function TCnFileReopener.GetRoOptions: ICnRoOptions;
begin
  Supports(GetReopen, ICnRoOptions, Result);
end;

procedure TCnFileReopener.Notify(NotifyCode: TOTAFileNotification; const FileName: string);
begin
  case NotifyCode of
    ofnFileOpened: GetReopen.LogOpenedFile(FileName);
    ofnFileClosing: GetReopen.LogClosingFile(FileName);
    ofnProjectDesktopSave:
      begin
        GetReopen.LogClosingFile(CnOtaGetCurrentProject.FileName);
        GetReopen.LogClosingFile(CnOtaGetProjectGroup.FileName);
        GetRoOptions.SaveFiles;
      end;
  end;
  FChanged := True;
end;

procedure TCnFileReopener.TimerOnTimer(Sender: TObject);
var
  Ini:  ICnRoOptions;
begin
  if FChanged and (FReopener <> nil) then
  begin
    if Supports(FReopener, ICnRoOptions, Ini) then
    begin
      try
        Ini.SaveFiles;
      except
        ; // ��һ�������Ҳ���ε���
      end;
      FChanged := False;
    end;
  end;
end;

{$ENDIF CNWIZARDS_CNFILESSNAPSHOTWIZARD}
end.

