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

unit CnMsgXMLFiler;
{* |<PRE>
================================================================================
* ������ƣ�CnPack IDE ר�Ұ�
* ��Ԫ���ƣ���Ϣ�����ӿ� XML ʵ�ֵ�Ԫ
* ��Ԫ���ߣ�LiuXiao (liuxiao@cnpack.org)
* ��    ע��
* ����ƽ̨��PWin2000Pro + Delphi 5.01
* ���ݲ��ԣ�PWin9X/2000/XP + Delphi 5/6/7 + C++Builder 5/6
* �� �� �����ô����е��ַ��������ϱ��ػ�����ʽ
* ��Ԫ��ʶ��$Id: CnMsgXMLFiler.pas 763 2011-02-07 14:18:23Z liuxiao@cnpack.org $
* �޸ļ�¼��2005.01.19 V1.0
*               ������Ԫ��ʵ�ֹ���
================================================================================
|</PRE>}

interface

{$I CnPack.inc}

uses
  Classes, SysUtils, Controls, TypInfo,
{$IFDEF COMPILER6_UP}
  Variants,
{$ENDIF}
  CnMsgClasses,
  OmniXMLPersistent, OmniXML,
{$IFDEF USE_MSXML}
  OmniXML_MSXML,
{$ENDIF}
  OmniXMLUtils;

type
  TCnMsgXMLFiler = class(TInterfacedObject, ICnMsgFiler)
  private
    FXMLDoc: IXMLDocument;
    FRoot: IXMLElement;
    FPropsFormat: TPropsFormat;

    function FindElement(const Root: IXMLElement; const TagName: string): IXMLElement;
    procedure ReadProperties(Instance: TPersistent; Element: IXMLElement);
    procedure ReadProperty(Instance: TPersistent; PropInfo: Pointer; Element: IXMLElement);
    function InternalReadText(Root: IXMLElement; Name: string; var Value: WideString): Boolean;
    procedure Read(Instance: TPersistent; Root: IXMLElement);

    procedure WriteProperties(Instance: TPersistent; Element: IXMLElement);
    procedure WriteProperty(Instance: TPersistent; PropInfo: PPropInfo; Element: IXMLElement);
    procedure InternalWriteText(Root: IXMLElement; Name, Value: string);
    procedure Write(Instance: TPersistent; Root: IXMLElement);
  public
    constructor Create;
    destructor Destroy; override;

    procedure LoadFromFile(Instance: TPersistent; const FileName: string);
    procedure SaveToFile(Instance: TPersistent; const FileName: string);
  end;

implementation

const
  CNMSG_NODENAME = 'CnMsgs';
  CNTIME_NODENAME = 'CnTimes';
  PROP_FORMAT = 'PropFormat';

var
  PropFormatValues: array[TPropsFormat] of string = ('auto', 'attr', 'node');

procedure CreateDocument(var XMLDoc: IXMLDocument; var Root: IXMLElement; RootNodeName: string);
begin
  XMLDoc := CreateXMLDoc;
  Root := XMLDoc.CreateElement(RootNodeName);
  XMLDoc.DocumentElement := Root;
end;

procedure Load(var XMLDoc: IXMLDocument; var XMLRoot: IXMLElement; var PropsFormat: TPropsFormat);
var
  I: TPropsFormat;
  PropFormatValue: string;
begin
  // set root element
  XMLRoot := XMLDoc.documentElement;
  PropsFormat := pfNodes;

  if XMLRoot = nil then
    Exit;

  PropFormatValue := XMLRoot.GetAttribute(PROP_FORMAT);

  for I := Low(TPropsFormat) to High(TPropsFormat) do begin
    if SameText(PropFormatValue, PropFormatValues[I]) then begin
      PropsFormat := I;
      Break;
    end;
  end;
end;

procedure LoadDocument(const FileName: string; var XMLDoc: IXMLDocument; var XMLRoot: IXMLElement; var PropsFormat: TPropsFormat);
begin
  XMLDoc := CreateXMLDoc;

  XMLDoc.preserveWhiteSpace := True;
  XMLDoc.Load(FileName);

  Load(XMLDoc, XMLRoot, PropsFormat);
end;

{ TCnTreeXMLFiler }

constructor TCnMsgXMLFiler.Create;
begin

end;

destructor TCnMsgXMLFiler.Destroy;
begin
  FXMLDoc := nil;
  FRoot := nil;
end;

function TCnMsgXMLFiler.FindElement(const Root: IXMLElement;
  const TagName: string): IXMLElement;
var
  I: Integer;
begin
  Result := nil;
  if Root = nil then
    Exit;
  I := 0;
  while (Result = nil) and (I < Root.ChildNodes.Length) do
  begin
    if (Root.ChildNodes.Item[I].NodeType = ELEMENT_NODE)
      and (CompareText(Root.ChildNodes.Item[I].NodeName, TagName) = 0) then
      Result := Root.ChildNodes.Item[I] as IXMLElement
    else
      Inc(I);
  end;
end;

function TCnMsgXMLFiler.InternalReadText(Root: IXMLElement; Name: string;
  var Value: WideString): Boolean;
var
  PropNode: IXMLElement;
  AttrNode: IXMLNode;
begin
  case FPropsFormat of
    pfAttributes:
      begin
        AttrNode := Root.Attributes.GetNamedItem(Name);
        Result := AttrNode <> nil;
        if Result then
          Value := AttrNode.NodeValue;
      end;
    pfNodes:
      begin
        PropNode := FindElement(Root, Name);
        Result := PropNode <> nil;
        if Result then
        begin
          Value := PropNode.Text;
          // �� OmniXML ����� #10 ����ת���� #13#10 ����������󲻻��е�����
          Value := StringReplace(Value, #10, #13#10, [rfReplaceAll]);
        end;
      end;
    else
      Result := False;
  end;
end;

procedure TCnMsgXMLFiler.InternalWriteText(Root: IXMLElement; Name,
  Value: string);
var
  PropNode: IXMLElement;
begin
  PropNode := FXMLDoc.CreateElement(Name);
  PropNode.Text := Value;
  Root.appendChild(PropNode);
end;

procedure TCnMsgXMLFiler.LoadFromFile(Instance: TPersistent;
  const FileName: string);
begin
  FXMLDoc := nil;
  FRoot := nil;

  if Instance is TCnMsgStore then
  begin
    LoadDocument(FileName, FXMLDoc, FRoot, FPropsFormat);
    Read(Instance, FRoot);

    FXMLDoc := nil;
    FRoot := nil;
  end;
end;

procedure TCnMsgXMLFiler.Read(Instance: TPersistent; Root: IXMLElement);
var
  I: Integer;
  AStore: TCnMsgStore;
  AMsgItem: TCnMsgItem;
  ATimeItem: TCnTimeItem;
begin
  if Instance is TCnMsgStore then
  begin
    Root := FindElement(Root, Instance.ClassName);
    if Root = nil then
      Exit;

    AStore := Instance as TCnMsgStore;
    AStore.ClearMsgs;
    AStore.ClearTimes;

    ReadProperties(Instance, Root);
    for I := 0 to Root.ChildNodes.Length - 1 do
    begin
      if Root.ChildNodes.Item[I].NodeType = ELEMENT_NODE then
      begin
        if (Root.ChildNodes.Item[I].NodeName = CNMSG_NODENAME) then
        begin
          AMsgItem := TCnMsgItem.Create;
          ReadProperties(AMsgItem, Root.ChildNodes.Item[I] as IXMLElement);
          AStore.AddAMsgItem(AMsgItem);
        end
        else if Root.ChildNodes.Item[I].NodeName = CNTIME_NODENAME then
        begin
          ATimeItem := TCnTimeItem.Create;
          ReadProperties(ATimeItem, Root.ChildNodes.Item[I] as IXMLElement);
          AStore.AddATimeItem(ATimeItem);
        end;
      end;
    end;
  end;
end;

procedure TCnMsgXMLFiler.ReadProperties(Instance: TPersistent;
  Element: IXMLElement);
var
  I: Integer;
  PropCount: Integer;
  PropList: PPropList;
  PropInfo: PPropInfo;
begin
  PropCount := GetTypeData(Instance.ClassInfo)^.PropCount;
  if PropCount > 0 then begin
    GetMem(PropList, PropCount * SizeOf(Pointer));
    try
      GetPropInfos(Instance.ClassInfo, PropList);
      for I := 0 to PropCount - 1 do begin
        PropInfo := PropList^[I];
        if PropInfo = nil then
          Break;
        ReadProperty(Instance, PropInfo, Element);
      end;
    finally
      FreeMem(PropList, PropCount * SizeOf(Pointer));
    end;
  end;
end;

procedure TCnMsgXMLFiler.ReadProperty(Instance: TPersistent;
  PropInfo: Pointer; Element: IXMLElement);
var
  PropType: PTypeInfo;

  procedure ReadFloatProp;
  var
    Value: Extended;
    Text: WideString;
  begin
    if InternalReadText(Element, PPropInfo(PropInfo)^.Name, Text) then
      Value := XMLStrToRealDef(Text, 0)
    else
      Value := 0;
    SetFloatProp(Instance, PropInfo, Value)
  end;

  procedure ReadDateTimeProp;
  var
    Value: TDateTime;
    Text: WideString;
  begin
    if InternalReadText(Element, PPropInfo(PropInfo)^.Name, Text) then begin
      if XMLStrToDateTime(Text, Value) then
        SetFloatProp(Instance, PropInfo, Value)
      else
        raise EOmniXMLPersistent.CreateFmt('Error in datetime property %s', [PPropInfo(PropInfo)^.Name]);
    end
    else
      SetFloatProp(Instance, PropInfo, 0);
      // raise EOmniXMLPersistent.CreateFmt('Missing datetime property %s', [PPropInfo(PropInfo)^.Name]);
  end;

  procedure ReadStrProp;
  var
    Value: WideString;
  begin
    if InternalReadText(Element, PPropInfo(PropInfo)^.Name, Value) then
      SetStrProp(Instance, PropInfo, Value)
    else
      SetStrProp(Instance, PropInfo, '');
  end;

  procedure ReadOrdProp;
  var
    Value: WideString;
    IntValue: Integer;
    BoolValue: Boolean;
  begin
    if InternalReadText(Element, PPropInfo(PropInfo)^.Name, Value) then begin
      case PropType^.Kind of
        tkInteger:
          if XMLStrToInt(Value, IntValue) then
            SetOrdProp(Instance, PropInfo, XMLStrToIntDef(Value, 0))
          else
            raise EOmniXMLPersistent.CreateFmt('Invalid integer value (%s).', [Value]);
        tkChar: SetOrdProp(Instance, PropInfo, Ord(Value[1]));
        tkSet: SetSetProp(Instance, PropInfo, Value);
        tkEnumeration:
          begin
            if PropType = System.TypeInfo(Boolean) then begin
              if XMLStrToBool(Value, BoolValue) then
                SetOrdProp(Instance, PropInfo, Ord(BoolValue))
              else
                raise EOmniXMLPersistent.CreateFmt('Invalid boolean value (%s).', [Value]);
            end
            else if PropType^.Kind = tkInteger then begin
              if XMLStrToInt(Value, IntValue) then
                SetOrdProp(Instance, PropInfo, IntValue)
              else
                raise EOmniXMLPersistent.CreateFmt('Invalid enum value (%s).', [Value]);
            end
            // 2003-05-27 (mr): added tkEnumeration processing
            else if PropType^.Kind = tkEnumeration then
              if XMLStrToInt(Value, IntValue) then
                SetOrdProp(Instance, PropInfo, IntValue)
              else
                SetEnumProp(Instance, PropInfo, Value);
          end;
      end;
    end
    else
      SetOrdProp(Instance, PropInfo, PPropInfo(PropInfo)^.Default)
  end;

  procedure ReadInt64Prop;
  var
    Value: WideString;
    IntValue: Int64;
  begin
    if InternalReadText(Element, PPropInfo(PropInfo)^.Name, Value) then begin
      if XMLStrToInt64(Value, IntValue) then
        SetInt64Prop(Instance, PropInfo, IntValue)
      else
        raise EOmniXMLPersistent.CreateFmt('Invalid int64 value (%s).', [Value]);
    end
    else
      SetFloatProp(Instance, PropInfo, 0)
  end;

begin
  if (PPropInfo(PropInfo)^.SetProc <> nil)
    and (PPropInfo(PropInfo)^.GetProc <> nil) then
  begin
    PropType := PPropInfo(PropInfo)^.PropType^;
    case PropType^.Kind of
      tkInteger, tkChar, tkEnumeration, tkSet: ReadOrdProp;
      tkString, tkLString, tkWString{$IFDEF DELPHI2009_UP}, tkUString{$ENDIF}: ReadStrProp;
      tkFloat:
        if (PropType = System.TypeInfo(TDateTime)) or (PropType = System.TypeInfo(TTime)) or (PropType = System.TypeInfo(TDate)) then
          ReadDateTimeProp
        else
          ReadFloatProp;
      tkInt64: ReadInt64Prop;
    end;
  end;
end;

procedure TCnMsgXMLFiler.SaveToFile(Instance: TPersistent;
  const FileName: string);
begin
  FXMLDoc := nil;
  FRoot := nil;

  if Instance is TCnMsgStore then
  begin
    CreateDocument(FXMLDoc, FRoot, 'data');
    FXMLDoc.DocumentElement.SetAttribute(PROP_FORMAT, PropFormatValues[pfNodes]);

    Write(Instance, FRoot);
    FXMLDoc.Save(FileName, ofIndent);

    FXMLDoc := nil;
    FRoot := nil;
  end;
end;

procedure TCnMsgXMLFiler.Write(Instance: TPersistent; Root: IXMLElement);
var
  I: Integer;
  AStore: TCnMsgStore;
  Element, ChildElement: IXMLElement;
begin
  if Instance is TCnMsgStore then
  begin
    // д Store ����
    Element := FXMLDoc.CreateElement(Instance.ClassName);
    WriteProperties(Instance, Element);
    // д��������
    AStore := Instance as TCnMsgStore;
    for I := 0 to AStore.MsgCount - 1 do
    begin
      ChildElement := FXMLDoc.CreateElement(CNMSG_NODENAME);
      WriteProperties(AStore.Msgs[I], ChildElement);
      Element.AppendChild(ChildElement);
    end;
    for I := 0 to AStore.TimeCount - 1 do
    begin
      ChildElement := FXMLDoc.CreateElement(CNTIME_NODENAME);
      WriteProperties(AStore.Times[I], ChildElement);
      Element.AppendChild(ChildElement);
    end;
    Root.AppendChild(Element);
  end;
end;

procedure TCnMsgXMLFiler.WriteProperties(Instance: TPersistent;
  Element: IXMLElement);
var
  I: Integer;
  PropCount: Integer;
  PropList: PPropList;
  PropInfo: PPropInfo;
begin
  if (Instance <> nil) and (Element <> nil) then
  begin
    PropCount := GetTypeData(Instance.ClassInfo)^.PropCount;
    if PropCount > 0 then
    begin
      GetMem(PropList, PropCount * SizeOf(Pointer));
      try
        GetPropInfos(Instance.ClassInfo, PropList);
        for I := 0 to PropCount - 1 do
        begin
          PropInfo := PropList^[I];
          if PropInfo = nil then
            Break;
          if IsStoredProp(Instance, PropInfo) then
            WriteProperty(Instance, PropInfo, Element)
        end;
      finally
        FreeMem(PropList, PropCount * SizeOf(Pointer));
      end;
    end;
  end;
end;

procedure TCnMsgXMLFiler.WriteProperty(Instance: TPersistent;
  PropInfo: PPropInfo; Element: IXMLElement);
var
  PropType: PTypeInfo;

  procedure WriteStrProp;
  var
    Value: string;
  begin
    Value := GetStrProp(Instance, PropInfo);
    if Value <> '' then
      InternalWriteText(Element, PPropInfo(PropInfo)^.Name, Value);
  end;

  procedure WriteOrdProp;
  var
    Value: Longint;
  begin
    Value := GetOrdProp(Instance, PropInfo);
    if Value <> PPropInfo(PropInfo)^.Default then begin
      case PropType^.Kind of
        tkInteger: InternalWriteText(Element, PPropInfo(PropInfo)^.Name, XMLIntToStr(Value));
        tkChar: InternalWriteText(Element, PPropInfo(PropInfo)^.Name, Chr(Value));
        tkSet: InternalWriteText(Element, PPropInfo(PropInfo)^.Name, GetSetProp(Instance, PPropInfo(PropInfo), True));
        tkEnumeration:
          begin
            if PropType = System.TypeInfo(Boolean) then
              InternalWriteText(Element, PPropInfo(PropInfo)^.Name, XMLBoolToStr(Boolean(Value)))
            else if PropType^.Kind = tkInteger then
              InternalWriteText(Element, PPropInfo(PropInfo)^.Name, XMLIntToStr(Value))
            // 2003-05-27 (mr): added tkEnumeration processing
            else if PropType^.Kind = tkEnumeration then
              InternalWriteText(Element, PPropInfo(PropInfo)^.Name, GetEnumName(PropType, Value));
          end;
      end;
    end;
  end;

  procedure WriteFloatProp;
  var
    Value: Real;
  begin
    Value := GetFloatProp(Instance, PropInfo);
    if Value <> 0 then
      InternalWriteText(Element, PPropInfo(PropInfo)^.Name, XMLRealToStr(Value));
  end;

  procedure WriteDateTimeProp;
  var
    Value: TDateTime;
  begin
    Value := VarAsType(GetFloatProp(Instance, PropInfo), varDate);
    if Value <> 0 then
      InternalWriteText(Element, PPropInfo(PropInfo)^.Name, XMLDateTimeToStrEx(Value));
  end;

  procedure WriteInt64Prop;
  var
    Value: Int64;
  begin
    Value := GetInt64Prop(Instance, PropInfo);
    if Value <> 0 then
      InternalWriteText(Element, PPropInfo(PropInfo)^.Name, XMLInt64ToStr(Value));
  end;

begin
  if (PPropInfo(PropInfo)^.SetProc <> nil) and
    (PPropInfo(PropInfo)^.GetProc <> nil) then
  begin
    PropType := PPropInfo(PropInfo)^.PropType^;
    case PropType^.Kind of
      tkInteger, tkChar, tkEnumeration, tkSet: WriteOrdProp;
      tkString, tkLString, tkWString{$IFDEF DELPHI2009_UP}, tkUString{$ENDIF}: WriteStrProp;
      tkFloat:
        if (PropType = System.TypeInfo(TDateTime)) or
         (PropType = System.TypeInfo(TTime)) or (PropType = System.TypeInfo(TDate)) then
          WriteDateTimeProp
        else
          WriteFloatProp;
      tkInt64: WriteInt64Prop;
      // ʡ�£������� Class ���͵���
    end;
  end;
end;

end.
