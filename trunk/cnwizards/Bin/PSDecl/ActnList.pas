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

unit ActnList;
{ |<PRE>
================================================================================
* ������ƣ�CnPack IDE ר�Ұ�
* ��Ԫ���ƣ��ڽű���ʹ�õ� ActnList ��Ԫ����
* ��Ԫ���ߣ��ܾ��� (zjy@cnpack.org)
* ��    ע����Ԫ�����������޸��� Borland Delphi Դ���룬��������������
*           ����Ԫ�����������ͺͺ��������� PasScript �ű���ʹ��
* ����ƽ̨��PWinXP SP2 + Delphi 5.01
* ���ݲ��ԣ�PWin9X/2000/XP + Delphi 5/6/7
* �� �� ����
* ��Ԫ��ʶ��$Id: ActnList.pas 763 2011-02-07 14:18:23Z liuxiao@cnpack.org $
* �޸ļ�¼��2006.12.29 V1.0
*               ������Ԫ
================================================================================
|</PRE>}

interface

uses Classes, Messages, ImgList;

type

{ TContainedAction }

  TCustomActionList = class;

  TContainedAction = class(TBasicAction)
  public
    destructor Destroy; override;
    function Execute: Boolean; override;
    function GetParentComponent: TComponent; override;
    function HasParent: Boolean; override;
    function Update: Boolean; override;
    property ActionList: TCustomActionList read FActionList write SetActionList;
    property Index: Integer read GetIndex write SetIndex stored False;
  published
    property Category: string read FCategory write SetCategory stored IsCategoryStored;
  end;

{ TCustomActionList }

  TActionEvent = procedure (Action: TBasicAction; var Handled: Boolean) of object;

  TCustomActionList = class(TComponent)
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function ExecuteAction(Action: TBasicAction): Boolean; override;
    function IsShortCut(var Message: TWMKey): Boolean;
    function UpdateAction(Action: TBasicAction): Boolean; override;
    property Actions[Index: Integer]: TContainedAction read GetAction write SetAction; default;
    property ActionCount: Integer read GetActionCount;
    property Images: TCustomImageList read FImages write SetImages;
  end;

{ TActionList }

  TActionList = class(TCustomActionList)
  published
    property Images;
    property OnChange;
    property OnExecute;
    property OnUpdate;
  end;

{ TControlAction }

  THintEvent = procedure (var HintStr: string; var CanShow: Boolean) of object;

  TCustomAction = class(TContainedAction)
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function DoHint(var HintStr: string): Boolean; dynamic;
    function Execute: Boolean; override;
    property Caption: string read FCaption write SetCaption;
    property Checked: Boolean read FChecked write SetChecked default False;
    property DisableIfNoHandler: Boolean read FDisableIfNoHandler write FDisableIfNoHandler default True;
    property Enabled: Boolean read FEnabled write SetEnabled default True;
    property HelpContext: THelpContext read FHelpContext write SetHelpContext default 0;
    property Hint: string read FHint write SetHint;
    property ImageIndex: TImageIndex read FImageIndex write SetImageIndex default -1;
    property ShortCut: TShortCut read FShortCut write SetShortCut default 0;
    property Visible: Boolean read FVisible write SetVisible default True;
    property OnHint: THintEvent read FOnHint write FOnHint;
  end;

  TAction = class(TCustomAction)
  published
    property Caption;
    property Checked;
    property Enabled;
    property HelpContext;
    property Hint;
    property ImageIndex;
    property ShortCut;
    property Visible;
    property OnExecute;
    property OnHint;
    property OnUpdate;
  end;

implementation

end.

