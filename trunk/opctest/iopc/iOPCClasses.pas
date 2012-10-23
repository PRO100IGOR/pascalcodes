{*******************************************************}
{                                                       }
{       Iocomp OPC Classes                              }
{                                                       }
{       Copyright (c) 1997,2002 Iocomp Software         }
{                                                       }
{*******************************************************}
{$I iInclude.inc}

{$ifdef iVCL}unit  iOPCClasses;{$endif}
{$ifdef iCLX}unit QiOPCClasses;{$endif}

interface

uses
  Windows, Forms, Classes, ComObj, ActiveX, SysUtils, iOPCTypes, iOPCFunctions{$IFDEF COMPILER_6_UP},Variants{$ENDIF};
type
  TiOPCShutdownCallback = class(TInterfacedObject, IOPCShutdown)
  private
    FOnChange : TNotifyEvent;
  public
    function ShutdownRequest(szReason: POleStr): HResult; stdcall;

    property OnChange : TNotifyEvent read FOnChange write FOnChange;
  end;

  TiOPCAdviseSink = class(TInterfacedObject, IAdviseSink)
  private
    FData         : OleVariant;
    FQuality      : Word;
    FTimeStamp    : TDateTime;
    FClientHandle : OPCHANDLE;
    FOnChange     : TNotifyEvent;
  public
    procedure OnDataChange(const formatetc: TFormatEtc; const stgmed: TStgMedium); stdcall;
    procedure OnViewChange(dwAspect: Longint; lindex: Longint); stdcall;
    procedure OnRename(const mk: IMoniker); stdcall;
    procedure OnSave; stdcall;
    procedure OnClose; stdcall;

    property Data      : OleVariant read FData;
    property TimeStamp : TDateTime  read FTimeStamp;
    property Quality   : Word       read FQuality;

    property OnChange  : TNotifyEvent read FOnChange write FOnChange;
  end;

  TiOPCDataCallback = class(TInterfacedObject, IOPCDataCallback)
  private
    FOnWriteComplete2 : TNotifyEvent;
    FOnDataChange2    : TNotifyEvent;
    FOnReadComplete2  : TNotifyEvent;

    FData             : OleVariant;
    FQuality          : Word;
    FTimeStamp        : TDateTime;
  public
    function OnDataChange    (dwTransid       : DWORD;
                              hGroup          : OPCHANDLE;
                              hrMasterquality : HResult;
                              hrMastererror   : HResult;
                              dwCount         : DWORD;
                              phClientItems   : POPCHANDLEARRAY;
                              pvValues        : POleVariantArray;
                              pwQualities     : PWordArray;
                              pftTimeStamps   : PFileTimeArray;
                              pErrors         : PResultList      ): HResult; stdcall;

    function OnReadComplete  (dwTransid       : DWORD;
                              hGroup          : OPCHANDLE;
                              hrMasterquality : HResult;
                              hrMastererror   : HResult;
                              dwCount         : DWORD;
                              phClientItems   : POPCHANDLEARRAY;
                              pvValues        : POleVariantArray;
                              pwQualities     : PWordArray;
                              pftTimeStamps   : PFileTimeArray;
                              pErrors         : PResultList      ): HResult; stdcall;

    function OnWriteComplete (dwTransid       : DWORD;
                              hGroup          : OPCHANDLE;
                              hrMastererr     : HResult;
                              dwCount         : DWORD;
                              pClienthandles  : POPCHANDLEARRAY;
                              pErrors         : PResultList      ): HResult; stdcall;

    function OnCancelComplete(dwTransid       : DWORD;
                              hGroup          : OPCHANDLE        ): HResult; stdcall;

    property Data             : OleVariant   read FData;
    property TimeStamp        : TDateTime    read FTimeStamp;
    property Quality          : Word         read FQuality;

    property OnDataChange2    : TNotifyEvent read FOnDataChange2    write FOnDataChange2;
    property OnReadComplete2  : TNotifyEvent read FOnReadComplete2  write FOnReadComplete2;
    property OnWriteComplete2 : TNotifyEvent read FOnWriteComplete2 write FOnWriteComplete2;
  end;

implementation
//***********************************************************************************************************************************
{ TiOPCShutdownCallback }
//***********************************************************************************************************************************
function TiOPCShutdownCallback.ShutdownRequest(szReason: POleStr): HResult;
begin
  Result := S_OK;
  if Assigned(FOnChange) then FOnChange(Self);
end;
//***********************************************************************************************************************************
procedure TiOPCAdviseSink.OnDataChange(const formatetc: TFormatEtc; const stgmed: TStgMedium);
var
  PGH         : POPCGROUPHEADER;
  PIHA1       : POPCITEMHEADER1ARRAY;
  PIHA2       : POPCITEMHEADER2ARRAY;
  PV          : POleVariant;
  I           : Integer;
  WithTime    : Boolean;
  FileTime    : TFileTime;
  SystemTime  : TSystemTime;
  ALength     : Integer;
  AWideString : WideString;
  APointer    : Pointer;
begin
  if (formatetc.cfFormat <> OPCSTMFORMATDATA) and (formatetc.cfFormat <> OPCSTMFORMATDATATIME) then Exit;
  WithTime := formatetc.cfFormat = OPCSTMFORMATDATATIME;

  PGH := GlobalLock(stgmed.hGlobal);
  try
    if PGH <> nil then
      begin
        PIHA1 := Pointer(PChar(PGH) + SizeOf(OPCGROUPHEADER));
        PIHA2 := Pointer(PIHA1);
        if Succeeded(PGH.hrStatus) then
          begin
            for I := 0 to PGH.dwItemCount - 1 do
            begin
              if WithTime then
                begin
                  PV            := POleVariant(PChar(PGH) + PIHA1[I].dwValueOffset);
                  FileTime      := PIHA1[I].ftTimeStampItem;
                  if (FileTime.dwLowDateTime <> 0) or (FileTime.dwHighDateTime <> 0) then
                    begin
                      FileTimeToLocalFileTime(FileTime, FileTime);
                      FileTimeToSystemTime(FileTime, SystemTime);
                      try
                        FTimeStamp := SystemTimeToDateTime(SystemTime);
                      except
                        FTimeStamp := Now;
                      end;
                    end
                  else FTimeStamp := 0;
                end
              else
                begin
                  PV            := POleVariant(PChar(PGH) + PIHA2[I].dwValueOffset);
                  FTimeStamp    := 0;
                end;

              FClientHandle := PIHA1[I].hClient;
              FQuality      := (PIHA1[I].wQuality and OPC_QUALITY_MASK);

              if VarType(PV^) = varOleStr then
                begin
                  APointer := Pointer(PChar(PV) + SizeOf(OleVariant));
                  ALength  := Integer(APointer^);
                  APointer := Pointer(PChar(APointer) + SizeOf(ALength));

                  SetString(AWideString, PChar(WideCharToString(APointer)), ALength div 2);

                  FData := AWideString;
                end
              else FData := PV^;


              if Assigned(FOnChange) then FOnChange(Self);
            end;
          end;
        end;
    finally
      GlobalUnlock(stgmed.hGlobal);
    end;
end;
//***********************************************************************************************************************************
procedure TiOPCAdviseSink.OnViewChange(dwAspect: Longint; lindex: Longint);begin end;
procedure TiOPCAdviseSink.OnRename    (const mk: IMoniker);                begin end;
procedure TiOPCAdviseSink.OnSave;                                          begin end;
procedure TiOPCAdviseSink.OnClose;                                         begin end;
//***********************************************************************************************************************************
function TiOPCDataCallback.OnDataChange(dwTransid       : DWORD;
                                        hGroup          : OPCHANDLE;
                                        hrMasterquality : HResult;
                                        hrMastererror   : HResult;
                                        dwCount         : DWORD;
                                        phClientItems   : POPCHANDLEARRAY;
                                        pvValues        : POleVariantArray;
                                        pwQualities     : PWordArray;
                                        pftTimeStamps   : PFileTimeArray;
                                        pErrors         : PResultList): HResult;
var
//  ClientItems : POPCHANDLEARRAY;
  Values      : POleVariantArray;
  Qualities   : PWORDARRAY;
  Times       : PFileTimeArray;
  FileTime    : TFileTime;
  SystemTime  : TSystemTime;
begin
  Result := S_OK;
  if dwCount <= 0 then Exit;

//  ClientItems := POPCHANDLEARRAY(phClientItems);
  Values      := POleVariantArray(pvValues);
  Qualities   := PWORDARRAY(pwQualities);
  Times       := PFileTimeArray(pftTimeStamps);

  FData    := Values[0];
  FQuality := Qualities[0];

  if (FileTime.dwLowDateTime <> 0) or (FileTime.dwHighDateTime <> 0) then
    begin
      FileTime := Times[0];
      FileTimeToLocalFileTime(FileTime, FileTime);
      FileTimeToSystemTime(FileTime, SystemTime);
      FTimeStamp := SystemTimeToDateTime(SystemTime);
    end
  else FTimeStamp := 0;

  if Assigned(FOnDataChange2) then FOnDataChange2(Self);
end;
//***********************************************************************************************************************************
function TiOPCDataCallback.OnReadComplete(dwTransid       : DWORD;
                                          hGroup          : OPCHANDLE;
                                          hrMasterquality : HResult;
                                          hrMastererror   : HResult;
                                          dwCount         : DWORD;
                                          phClientItems   : POPCHANDLEARRAY;
                                          pvValues        : POleVariantArray;
                                          pwQualities     : PWordArray;
                                          pftTimeStamps   : PFileTimeArray;
                                          pErrors         : PResultList): HResult;
begin
  Result := OnDataChange(dwTransid, hGroup, hrMasterquality, hrMastererror,  dwCount, phClientItems, pvValues, pwQualities, pftTimeStamps, pErrors);
end;
//***********************************************************************************************************************************
function TiOPCDataCallback.OnWriteComplete(dwTransid: DWORD; hGroup: OPCHANDLE; hrMastererr: HResult; dwCount: DWORD; pClienthandles: POPCHANDLEARRAY; pErrors: PResultList): HResult;
begin
  Result := S_OK;
end;
//***********************************************************************************************************************************
function TiOPCDataCallback.OnCancelComplete(dwTransid: DWORD; hGroup: OPCHANDLE): HResult;
begin
  Result := S_OK;
end;
//***********************************************************************************************************************************
end.

