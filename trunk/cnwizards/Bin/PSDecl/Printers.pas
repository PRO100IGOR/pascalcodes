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

unit Printers;
{ |<PRE>
================================================================================
* ������ƣ�CnPack IDE ר�Ұ�
* ��Ԫ���ƣ��ڽű���ʹ�õ� Printers ��Ԫ����
* ��Ԫ���ߣ��ܾ��� (zjy@cnpack.org)
* ��    ע����Ԫ�����������޸��� Borland Delphi Դ���룬��������������
*           ����Ԫ�����������ͺͺ��������� PasScript �ű���ʹ��
* ����ƽ̨��PWinXP SP2 + Delphi 5.01
* ���ݲ��ԣ�PWin9X/2000/XP + Delphi 5/6/7
* �� �� ����
* ��Ԫ��ʶ��$Id: Printers.pas 763 2011-02-07 14:18:23Z liuxiao@cnpack.org $
* �޸ļ�¼��2006.12.30 V1.0
*               ������Ԫ
================================================================================
|</PRE>}

{$R-,T-,X+,H+}

interface

uses Windows, WinSpool, SysUtils, Classes, Graphics, Forms;

type
  { TPrinter }

  { The printer object encapsulates the printer interface of Windows.  A print
    job is started whenever any redering is done either through a Text variable
    or the printers canvas.  This job will stay open until EndDoc is called or
    the Text variable is closed.  The title displayed in the Print Manager (and
    on network header pages) is determined by the Title property.

    EndDoc - Terminates the print job (and closes the currently open Text).
      The print job will being printing on the printer after a call to EndDoc.
    NewPage - Starts a new page and increments the PageNumber property.  The
      pen position of the Canvas is put back at (0, 0).
    Canvas - Represents the surface of the currently printing page.  Note that
      some printer do not support drawing pictures and the Draw, StretchDraw,
      and CopyRect methods might fail.
    Fonts - The list of fonts supported by the printer.  Note that TrueType
      fonts appear in this list even if the font is not supported natively on
      the printer since GDI can render them accurately for the printer.
    PageHeight - The height, in pixels, of the page.
    PageWidth - The width, in pixels, of the page.
    PageNumber - The current page number being printed.  This is incremented
      when ever the NewPage method is called.  (Note: This property can also be
      incremented when a Text variable is written, a CR is encounted on the
      last line of the page).
    PrinterIndex - Specifies which printer in the TPrinters list that is
      currently selected for printing.  Setting this property to -1 will cause
      the default printer to be selected.  If this value is changed EndDoc is
      called automatically.
    Printers - A list of the printers installed in Windows.
    Title - The title used by Windows in the Print Manager and for network
      title pages. }

  TPrinterState = (psNoHandle, psHandleIC, psHandleDC);
  TPrinterOrientation = (poPortrait, poLandscape);
  TPrinterCapability = (pcCopies, pcOrientation, pcCollation);
  TPrinterCapabilities = set of TPrinterCapability;

  TPrinter = class(TObject)
  public
    constructor Create;
    destructor Destroy; override;
    procedure Abort;
    procedure BeginDoc;
    procedure EndDoc;
    procedure NewPage;
    procedure GetPrinter(ADevice, ADriver, APort: PChar; var ADeviceMode: THandle);
    procedure SetPrinter(ADevice, ADriver, APort: PChar; ADeviceMode: THandle);
    procedure Refresh;
    property Aborted: Boolean read FAborted;
    property Canvas: TCanvas read GetCanvas;
    property Capabilities: TPrinterCapabilities read FCapabilities;
    property Copies: Integer read GetNumCopies write SetNumCopies;
    property Fonts: TStrings read GetFonts;
    property Handle: HDC read GetHandle;
    property Orientation: TPrinterOrientation read GetOrientation write SetOrientation;
    property PageHeight: Integer read GetPageHeight;
    property PageWidth: Integer read GetPageWidth;
    property PageNumber: Integer read FPageNumber;
    property PrinterIndex: Integer read GetPrinterIndex write SetPrinterIndex;
    property Printing: Boolean read FPrinting;
    property Printers: TStrings read GetPrinters;
    property Title: string read FTitle write FTitle;
  end;

{ Printer function - Replaces the Printer global variable of previous versions,
  to improve smart linking (reduce exe size by 2.5k in projects that don't use
  the printer).  Code which assigned to the Printer global variable
  must call SetPrinter instead.  SetPrinter returns current printer object
  and makes the new printer object the current printer.  It is the caller's
  responsibility to free the old printer, if appropriate.  (This allows
  toggling between different printer objects without destroying configuration
  settings.) }

function Printer: TPrinter;

implementation

end.
