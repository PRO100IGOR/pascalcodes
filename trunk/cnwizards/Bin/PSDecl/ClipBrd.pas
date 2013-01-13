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

unit Clipbrd;
{ |<PRE>
================================================================================
* ������ƣ�CnPack IDE ר�Ұ�
* ��Ԫ���ƣ��ڽű���ʹ�õ� Clipbrd ��Ԫ����
* ��Ԫ���ߣ��ܾ��� (zjy@cnpack.org)
* ��    ע����Ԫ�����������޸��� Borland Delphi Դ���룬��������������
*           ����Ԫ�����������ͺͺ��������� PasScript �ű���ʹ��
* ����ƽ̨��PWinXP SP2 + Delphi 5.01
* ���ݲ��ԣ�PWin9X/2000/XP + Delphi 5/6/7
* �� �� ����
* ��Ԫ��ʶ��$Id: ClipBrd.pas 763 2011-02-07 14:18:23Z liuxiao@cnpack.org $
* �޸ļ�¼��2006.12.30 V1.0
*               ������Ԫ
================================================================================
|</PRE>}

{$R-,T-,H+,X+}

interface

uses Windows, Messages, Classes, Graphics;

{ TClipboard }

{ The clipboard object encapsulates the Windows clipboard.

  Assign - Assigns the given object to the clipboard.  If the object is
    a TPicture or TGraphic desendent it will be placed on the clipboard
    in the corresponding format (e.g. TBitmap will be placed on the
    clipboard as a CF_BITMAP). Picture.Assign(Clipboard) and
    Bitmap.Assign(Clipboard) are also supported to retrieve the contents
    of the clipboard.
  Clear - Clears the contents of the clipboard.  This is done automatically
    when the clipboard object adds data to the clipboard.
  Close - Closes the clipboard if it is open.  Open and close maintain a
    count of the number of times the clipboard has been opened.  It will
    not actually close the clipboard until it has been closed the same
    number of times it has been opened.
  Open - Open the clipboard and prevents all other applications from changeing
    the clipboard.  This is call is not necessary if you are adding just one
    item to the clipboard.  If you need to add more than one format to
    the clipboard, call Open.  After all the formats have been added. Call
    close.
  HasFormat - Returns true if the given format is available on the clipboard.
  GetAsHandle - Returns the data from the clipboard in a raw Windows handled
    for the specified format.  The handle is not owned by the application and
    the data should be copied.
  SetAsHandle - Places the handle on the clipboard in the given format.  Once
    a handle has been given to the clipboard it should *not* be deleted.  It
    will be deleted by the clipboard.
  GetTextBuf - Retrieves
  AsText - Allows placing and retrieving text from the clipboard.  This property
    is valid to retrieve if the CF_TEXT format is available.
  FormatCount - The number of formats in the Formats array.
  Formats - A list of all the formats available on the clipboard. }

type
  TClipboard = class(TPersistent)
  public
    procedure Assign(Source: TPersistent); override;
    procedure Clear;
    procedure Close;
    function GetComponent(Owner, Parent: TComponent): TComponent;
    function GetAsHandle(Format: Word): THandle;
    function GetTextBuf(Buffer: PChar; BufSize: Integer): Integer;
    function HasFormat(Format: Word): Boolean;
    procedure Open;
    procedure SetComponent(Component: TComponent);
    procedure SetAsHandle(Format: Word; Value: THandle);
    procedure SetTextBuf(Buffer: PChar);
    property AsText: string read GetAsText write SetAsText;
    property FormatCount: Integer read GetFormatCount;
    property Formats[Index: Integer]: Word read GetFormats;
  end;

function Clipboard: TClipboard;

implementation

end.


