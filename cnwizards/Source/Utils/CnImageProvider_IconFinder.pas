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

unit CnImageProvider_IconFinder;
{* |<PRE>
================================================================================
* ������ƣ����������ԡ�����༭����
* ��Ԫ���ƣ�www.IconFinder.com ����֧�ֵ�Ԫ
* ��Ԫ���ߣ��ܾ��� zjy@cnpack.org
* ��    ע��
* ����ƽ̨��Win7 + Delphi 7
* ���ݲ��ԣ�
* �� �� �����õ�Ԫ�ʹ����е��ַ����Ѿ����ػ�����ʽ
* ��Ԫ��ʶ��$Id: $
* �޸ļ�¼��
*           2011.07.04 V1.0
*               ������Ԫ
================================================================================
|</PRE>}

{$I CnWizards.inc}

interface

uses
  Windows, SysUtils, Classes, Graphics, CnImageProviderMgr, CnInetUtils,
  OmniXML, OmniXMLUtils, CnCommon;

type
  TCnImageProvider_IconFinder = class(TCnBaseImageProvider)
  protected
    function DoSearchImage(Req: TCnImageReqInfo): Boolean; override;
  public
    constructor Create; override;
    destructor Destroy; override;
    class procedure GetProviderInfo(var DispName, HomeUrl: string); override;
    procedure OpenInBrowser(Item: TCnImageRespItem); override;
    function SearchIconset(Item: TCnImageRespItem; var Req: TCnImageReqInfo): Boolean; override;
  end;
  
implementation

{ TCnImageProvider_IconFinder }

constructor TCnImageProvider_IconFinder.Create;
begin
  inherited;
  FItemsPerPage := 20;
  FFeatures := [pfOpenInBrowser, pfSearchIconset];
end;

destructor TCnImageProvider_IconFinder.Destroy;
begin

  inherited;
end;

class procedure TCnImageProvider_IconFinder.GetProviderInfo(var DispName,
  HomeUrl: string);
begin
  DispName := 'IconFinder.com';
  HomeUrl := 'http://www.iconfinder.com';
end;

function TCnImageProvider_IconFinder.DoSearchImage(Req: TCnImageReqInfo): Boolean;
var
  Url, Text: string;
  Lic: Integer;
  xml: IXMLDocument;
  root, node, icon: IXMLNode;
  i, j, size: Integer;
  Item: TCnImageRespItem;
begin
  Result := False;
  if Req.CommercialLicenses then
    Lic := 1
  else
    Lic := 0;
  Url := Format('http://www.iconfinder.com/xml/search/?q=%s&c=%d&p=%d&l=%d&min=%d&max=%d&api_key=7cb3bc9947285bc4b3a2f2d8bd20a3dd',
    [Req.Keyword, FItemsPerPage, Req.Page, Lic, Req.MinSize, Req.MaxSize]);
  Text := string(CnInet_GetString(Url));
  xml := CreateXMLDoc;
  if xml.LoadXML(Text) then
  begin
    root := FindNode(xml, 'results');
    if root <> nil then
    begin
      for i := 0 to root.ChildNodes.Length - 1 do
      begin
        node := root.ChildNodes.Item[i];
        if SameText(node.NodeName, 'opensearch:totalResults') then
        begin
          FTotalCount := XMLStrToIntDef(node.Text, 0);
          FPageCount := (FTotalCount + FItemsPerPage - 1) div FItemsPerPage;
        end
        else if SameText(node.NodeName, 'iconmatches') then
        begin
          Result := True;
          for j := 0 to node.ChildNodes.Length - 1 do
          begin
            icon := node.ChildNodes.Item[j];
            if SameText(icon.NodeName, 'icon') then
            begin
              size := GetNodeTextInt(icon, 'size', 0);
              if (size >= Req.MinSize) and (size <= Req.MaxSize) then
              begin
                Item := Items.Add;
                Item.Size := size;
                Item.Id := GetNodeTextStr(icon, 'id', '');
                Item.Url := GetNodeTextStr(icon, 'image', '');
                Item.Ext := ExtractFileExt(Item.Url);
              end;
            end;
          end;
        end;
      end;
    end;
  end;
end;

procedure TCnImageProvider_IconFinder.OpenInBrowser(Item: TCnImageRespItem);
begin
  OpenUrl(Format('http://www.iconfinder.com/icondetails/%s/%d/', [Item.Id, Item.Size]));
end;

function TCnImageProvider_IconFinder.SearchIconset(Item: TCnImageRespItem;
  var Req: TCnImageReqInfo): Boolean;
var
  Url, Text: string;
  xml: IXMLDocument;
  root, node: IXMLNode;
begin
  Result := False;
  Url := Format('http://www.iconfinder.com/xml/icondetails/?id=%s&size=%d&api_key=7cb3bc9947285bc4b3a2f2d8bd20a3dd',
    [Item.Id, Item.Size]);
  Text := string(CnInet_GetString(Url));
  xml := CreateXMLDoc;
  if xml.LoadXML(Text) then
  begin
    root := FindNode(xml, 'icon');
    if root <> nil then
    begin
      node := FindNode(root, 'iconsetid');
      if node <> nil then
      begin
        Req.Keyword := 'iconset:' + node.Text;
        Req.Page := 0;
        Result := True;
      end;
    end;
  end;
end;

initialization
  ImageProviderMgr.RegisterProvider(TCnImageProvider_IconFinder);

end.
