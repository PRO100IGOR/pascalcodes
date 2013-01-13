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

unit CnPngUtils;
{* |<PRE>
================================================================================
* ������ƣ�CnWizards ��������
* ��Ԫ���ƣ�Png ��ʽ֧�ֵ�Ԫ
* ��Ԫ���ߣ��ܾ��� zjy@cnpack.org
* ��    ע������ pngimage �Ѿ��� Embarcadero �չ����µ����Э���ƺ������������Ŀ
*           ��Դ��Ϊ�˱����Ȩ���⣬�˴��� D2010 ��ʹ�ùٷ��� pngimage ����һ��
*           DLL �����Ͱ汾�� IDE ������ʹ�á�
* ����ƽ̨��Win7 + Delphi 2010
* ���ݲ��ԣ�
* �� �� �����õ�Ԫ�ʹ����е��ַ����Ѿ����ػ�����ʽ
* ��Ԫ��ʶ��$Id: CnPngUtils.pas 763 2011-02-07 14:18:23Z liuxiao@cnpack.org $
* �޸ļ�¼��2011.07.05 V1.0
*               ������Ԫ
================================================================================
|</PRE>}

{//$I CnWizards.inc}

interface

uses
  Windows, SysUtils, Graphics, pngimage;

function CnConvertPngToBmp(PngFile, BmpFile: PAnsiChar): LongBool; stdcall;
function CnConvertBmpToPng(BmpFile, PngFile: PAnsiChar): LongBool; stdcall;

exports
  CnConvertPngToBmp,
  CnConvertBmpToPng;

implementation

function CnConvertPngToBmp(PngFile, BmpFile: PAnsiChar): LongBool;
var
  png: TPngImage;
  bmp: TBitmap;
begin
  Result := False;
  if not FileExists(string(PngFile)) then
    Exit;
  png := nil;
  bmp := nil;
  try
    png := TPngImage.Create;
    bmp := TBitmap.Create;
    png.LoadFromFile(string(PngFile));
    bmp.Assign(png);
    if not bmp.Empty then
    begin
      bmp.SaveToFile(string(BmpFile));
      Result := True;
    end;
  except
    png.Free;
    bmp.Free;
  end;
end;

function CnConvertBmpToPng(BmpFile, PngFile: PAnsiChar): LongBool;
var
  png: TPngImage;
  bmp: TBitmap;
  i, j: Integer;
  p, p1, p2: PByteArray;
begin
  Result := False;
  if not FileExists(string(BmpFile)) then
    Exit;
  png := nil;
  bmp := nil;
  try
    bmp := TBitmap.Create;
    bmp.LoadFromFile(string(BmpFile));
    if bmp.PixelFormat = pf32bit then
    begin
      png := TPngImage.CreateBlank(COLOR_RGBALPHA, 8, bmp.Width, bmp.Height);
      for i := 0 to bmp.Height - 1 do
      begin
        p := bmp.ScanLine[i];
        p1 := png.Scanline[i];
        p2 := png.AlphaScanline[i];
        for j := 0 to bmp.Width - 1 do
        begin
          p1[j * 3] := p[j * 4];
          p1[j * 3 + 1] := p[j * 4 + 1];
          p1[j * 3 + 2] := p[j * 4 + 2];
          p2[j] := p[j * 4 + 3];
        end;
      end;
    end
    else
    begin
      png := TPngImage.Create;
      png.Assign(bmp);
    end;
    if not png.Empty then
    begin
      png.SaveToFile(string(PngFile));
      Result := True;
    end;
  except
    png.Free;
    bmp.Free;
  end;
end;

end.
