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

unit CnWizHttpDownMgr;
{* |<PRE>
================================================================================
* ������ƣ����������ԡ�����༭����
* ��Ԫ���ƣ����߳�������
* ��Ԫ���ߣ��ܾ��� zjy@cnpack.org
* ��    ע��
* ����ƽ̨��Win7 + Delphi 7
* ���ݲ��ԣ�
* �� �� �����õ�Ԫ�ʹ����е��ַ����Ѿ����ػ�����ʽ
* ��Ԫ��ʶ��$Id: $
* �޸ļ�¼��
*           2011.07.06 V1.0
*               ������Ԫ
================================================================================
|</PRE>}

{$I CnWizards.inc}

interface

uses
  Windows, SysUtils, Classes, CnThreadTaskMgr, CnCommon, CnInetUtils;

const
  csRetryCount = 2; // �Զ����Դ���

type
  TCnDownTask = class(TCnTask)
  private
    FUrl: string;
    FFileName: string;
    FUserAgent: string;
    FReferer: string;
  public
    property Url: string read FUrl;
    property UserAgent: string read FUserAgent;
    property Referer: string read FReferer;
    property FileName: string read FFileName;
  end;

  TCnDownThread = class(TCnTaskThread)
  private
   FHttp: TCnHTTP;
  protected
    procedure DoExecute; override;
  public
    destructor Destroy; override;
  end;

  TCnDownMgr = class(TCnThreadTaskMgr)
  protected
    function GetThreadClass: TCnTaskThreadClass; override;
  public
    constructor Create;
    destructor Destroy; override;
    // ����һ������
    function NewDownload(AUrl, AFileName, AUserAgent, AReferer: string; Data: Pointer): TCnDownTask;
  end;
  
implementation

{ TCnDownMgr }

constructor TCnDownMgr.Create;
begin
  inherited Create;
end;

destructor TCnDownMgr.Destroy;
begin
  inherited;
end;

function TCnDownMgr.GetThreadClass: TCnTaskThreadClass;
begin
  Result := TCnDownThread;
end;

function TCnDownMgr.NewDownload(AUrl, AFileName, AUserAgent, AReferer: string;
  Data: Pointer): TCnDownTask;
begin
  if AUrl <> '' then
  begin
    Result := TCnDownTask.Create;
    Result.FUrl := AUrl;
    Result.FFileName := AFileName;
    Result.FUserAgent := AUserAgent;
    Result.FReferer := AReferer;
    Result.FData := Data;
    Result.TimeOut := 30 * 1000;
    AddTask(AUrl, Result);
  end
  else
    Result := nil;
end;

{ TCnDownThread }

destructor TCnDownThread.Destroy;
begin
  if FHttp <> nil then
    FHttp.Free;
  inherited;
end;

procedure TCnDownThread.DoExecute;
var
  i: Integer;
  ATask: TCnDownTask;
begin
  ATask := TCnDownTask(FTask);
  FHttp := TCnHTTP.Create;
  try
    for i := 0 to csRetryCount - 1 do
    begin
      if ATask.UserAgent <> '' then
        FHttp.UserAgent := ATask.UserAgent;
      if ATask.Referer <> '' then
        FHttp.HttpRequestHeaders.Add('Referer: ' + ATask.Referer);
      FHttp.GetFile(ATask.Url, ATask.FileName);
      if GetFileSize(ATask.FileName) > 0 then
      begin
        ATask.FStatus := tsFinished;
        Break;
      end;
    end;
  finally
    FreeAndNil(FHttp);
  end;
end;

end.

