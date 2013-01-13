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

unit CnOTACreators;
{ |<PRE>
================================================================================
* ������ƣ�CnPack IDE ר�Ұ�
* ��Ԫ���ƣ�Creators ��Ԫ���
* ��Ԫ���ߣ�LiuXiao ��liuxiao@cnpack.org��
* ��    ע������ TCnTemplateParser ���ɴ����ʵ���� Creators �Ŀ�ܵ�Ԫ
* ����ƽ̨��Windows 2000 + Delphi 5
* ���ݲ��ԣ�PWin9X/2000/XP + Delphi 5/6/7 + C++Builder 5/6
* �� �� �����ô����е��ַ��������ϱ��ػ�����ʽ
* ��Ԫ��ʶ��$Id: CnOTACreators.pas 767 2011-03-05 03:37:17Z liuxiao@cnpack.org $
* �޸ļ�¼��2003.12.1 V1.0
*               ������Ԫ��ʵ�ֹ���
================================================================================
|</PRE>}

interface

{$I CnWizards.inc}

uses
  Classes, Windows, SysUtils, ToolsAPI, CnCommon, CnWizUtils;

type
  TCnCreatorType = (ctProject, ctPascalUnit, ctCppUnit, ctHppUnit, ctForm, ctDataModule);
  TCnSourceType = (stImplSource, stIntfSource, stFormFile, stProjectSource,
    stOptionSource);

type
  TCnReplaceTagEvent = procedure (Sender: TObject; const TagString: string;
    TagParams: TStrings; var ReplaceText: string) of object;
    
  TCnTemplateParser = class
  {* �������ģ�� }
  private
    FOnTag: TCnReplaceTagEvent;
    FTemplateText: string;
    function FindNextTag(var P: PChar; OutStream: TMemoryStream; var ATag: string): 
      Boolean;
    function GetContent: string;
  public
    procedure LoadTemplateFile(const FileName: string);
    property Content: string read GetContent;
    property TemplateText: string read FTemplateText write FTemplateText;
    property OnTag: TCnReplaceTagEvent read FOnTag write FOnTag;
  end;

  TCnOTAFile = class(TInterfacedObject, IOTAFile)
  {* ʵ�� IOTAFile�ӿڵļ��ļ��� }
  private
    FSource: string;
    FAge: TDateTime;
  public
    constructor Create(const Source: string; AAge: TDateTime = -1);
    function GetSource: string;
    function GetAge: TDateTime; virtual;
  end;

  TCnBaseCreator = class(TInterfacedObject, IOTACreator)
  {* ʵ�� IOTACreator �ӿں� TCnTemplateParser ���ɴ���Ļ����� }
  private
    FTemplateFile: string;
    FSourceType: TCnSourceType;
    function GetIOTAFileByTemplate(ASourceType: TCnSourceType): IOTAFile;
    {* �����ļ����͵��� TCnTemplateParser ���� IOTAFile }

    procedure InternalReplaceTagSource(const TagString: string; TagParams: TStrings;
      var ReplaceText: string);
    {* �ڲ����������滻���� }
  protected
    function GetTemplateFile(FileType: TCnSourceType): string; virtual; abstract;
    {* ��������������ṩ��ͬ�����ļ��ľ���ģ���ļ��� }
    procedure OnReplaceTagsSource(Sender: TObject; const TagString: string;
      TagParams: TStrings; var ReplaceText: string); virtual;
    {* TCnTemplateParser �� Tag �����¼��������¼������������Խ��к��ʵĴ��� }

    function GetNeedBaseProcess: Boolean;
    {* ��������أ������Ƿ��û�����л����ı�ǩ�滻 }
  public
    constructor Create; virtual;

    // IOTACreator �ӿ�ʵ��
    function GetCreatorType: string; virtual;
    {* Ĭ�Ϸ��ؿմ�����ʾ�������ṩ��Ϣ }
    function GetExisting: Boolean; virtual;
    {* Ĭ�Ϸ��� False����ʾ�½��ļ� }
    function GetFileSystem: string; virtual;
    {* Ĭ�Ϸ��ؿմ�����ʾĬ�� }
    function GetOwner: IOTAModule; virtual;
    {* Ĭ�Ϸ��ص�ǰ��Ŀ����ʾ�½��� }
    function GetUnnamed: Boolean; virtual;
    {* Ĭ�Ϸ��� True����ʾδ������ }

    property TemplateFile: string read FTemplateFile write FTemplateFile;
    {* ��ǰģ���ļ��� }
    property SourceType: TCnSourceType read FSourceType write FSourceType;
    {* ��ǰ�����ɵĴ������� }
  end;

  TCnTemplateModuleCreator = class(TCnBaseCreator, IOTAModuleCreator)
  {* ʵ�� IOTAModuleCreator �Ա㴴��������Ԫ���� }
  private
    FModuleIdent: string;
    FFormIdent: string;
    FAncestorIdent: string;
  protected
    procedure OnReplaceTagsSource(Sender: TObject; const TagString: string;
      TagParams: TStrings; var ReplaceText: string); override;

    procedure DoReplaceTagsSource(const TagString: string; TagParams: TStrings; var 
      ReplaceText: string; ASourceType: TCnSourceType; ModuleIdent, FormIdent, 
      AncestorIdent: string); virtual;
    {* �������ش˺���ʵ�� ModuleCreator ��ģ�� Tag �滻 }
  public
    // IOTACreator �ӿ�ʵ��
    function GetCreatorType: string; override;
    {* �����Է��� sUnit����ʾ�����޴���� Unit������ɰ���Ҫ���ط��� sForm �� }

    // IOTAModuleCreator �ӿ�ʵ��
    function GetAncestorName: string; virtual;
    {* ���ؿմ�����ʾ����̳���Ĭ�ϵ� TForm }
    function GetImplFileName: string; virtual;
    {* ���ؿմ�����ʾԴ��ʵ��ʹ��Ĭ������ }
    function GetIntfFileName: string; virtual;
    {* ���ؿմ�����ʾͷ�ļ�ʹ��Ĭ������ }
    function GetFormName: string; virtual;
    {* ���ؿմ�����ʾ����ʹ��Ĭ������ }
    function GetMainForm: Boolean; virtual;
    {* �Ƿ��ǹ��̵� MainForm��Ĭ�Ϸ��� False }
    function GetShowForm: Boolean; virtual;
    {* �Ƿ���ʾ�����������Ĭ�Ϸ��� True }
    function GetShowSource: Boolean; virtual;
    {* �Ƿ���ʾԴ�ļ���Ĭ�Ϸ��� False }
    function NewFormFile(const FormIdent, AncestorIdent: string): IOTAFile;
      virtual;
    {* ���ش��� dfm �ļ��� IOTAFile �ӿ�ʵ�� }
    function NewImplSource(const ModuleIdent, FormIdent, AncestorIdent: string):
      IOTAFile; virtual;
    {* ����Դ��ʵ�ֲ��֣�Pascal Ϊ pas �ļ���C++ Ϊ .cpp �ļ����� IOTAFile �ӿ�ʵ�� }
    function NewIntfSource(const ModuleIdent, FormIdent, AncestorIdent: string):
      IOTAFile; virtual;
    {* ����Դ��ͷ�ļ���Pascal Ϊ nil��C++ Ϊ .h �ļ����� IOTAFile �ӿ�ʵ�� }
    procedure FormCreated(const FormEditor: IOTAFormEditor); virtual;
    {* ���崴���󱻵��ã�Ĭ��ʲôҲ���� }
  end;

  TCnTemplateDataModuleCreator = class(TCnTemplateModuleCreator)
  {* ʵ�ִ���  DataModule }
  public
    function GetAncestorName: string; override;
    {* �����ش˺������� 'DataModule' �Ա�Ǵ��� DataModule }
  end;

  TCnTemplateProjectCreator = class(TCnBaseCreator, IOTAProjectCreator{$IFDEF BDS}, IOTAProjectCreator80{$ENDIF})
  {* ʵ�� IOTAProjectCreator �Ա㴴�����̣�BDS2006 �±���ʵ�� 80 }
  private
    FProjectName: string;
  protected
    procedure OnReplaceTagsSource(Sender: TObject; const TagString: string;
      TagParams: TStrings; var ReplaceText: string); override;

    procedure DoReplaceTagsSource(const TagString: string; TagParams: 
      TStrings; var ReplaceText: string; ASourceType: TCnSourceType; ProjectName: 
      string); virtual;
    {* �������ش˺���ʵ�� ProjectCreator ��ģ�� Tag �滻 }
  public
    function GetOwner: IOTAModule; override;
    {* �����ش˺������ص�ǰ ProjectGroup }

    // IOTAProjectCreator �ӿ�ʵ��
    function GetFileName: string; virtual;
    {* Ĭ�Ϸ��ؿմ�����ʾ��Ŀ�ļ����Զ����� }
    function GetOptionFileName: string; virtual;
    {* Ĭ�Ϸ��ؿմ�����ʾѡ���ļ����Զ����� }
    function GetShowSource: Boolean; virtual;
    {* Ĭ�Ϸ��� False����ʾ����ʾ Project Source }
    procedure NewDefaultModule; virtual;
    {* �½���Ŀʱ��Ҫ����Ĭ��ģ���ʱ����� }
    function NewOptionSource(const ProjectName: string): IOTAFile; virtual;
    {* ���� OptionSource�������� C++ }
    procedure NewProjectResource(const Project: IOTAProject); virtual;
    {* ���޸���Ŀѡ���ã�������������޸���Ŀѡ�� }
    function NewProjectSource(const ProjectName: string): IOTAFile; virtual;
    {* ������ĿԴ�ļ��� IOTAFile �ӿ� }

{$IFDEF BDS}
    // IOTAProjectCreator80 �ӿ�ʵ��
    procedure NewDefaultProjectModule(const Project: IOTAProject);
    {* �½�ȱʡģ�� }
    function GetProjectPersonality: string;
    {* ���� Personality �ַ��� }
{$ENDIF}
  end;

implementation

{$IFDEF DEBUG}
uses
  CnDebug;
{$ENDIF}

const
  csProjectName = 'ProjectName';
  csUnitName = 'UnitName';
  csFormName = 'FormName';

{ TCnTemplateParser }

function TCnTemplateParser.FindNextTag(var P: PChar; OutStream: TMemoryStream;
  var ATag: string): Boolean;
var
  PStart: PChar;
  Len: Integer;
begin
  Result := False;
  while P^ <> #0 do
  begin
    if (P^ = '<') and (P[1] = '#') then
    begin
      PStart := P;
      Inc(P);
      Inc(P);
      Len := 0;
      while not CharInSet(P^, ['>', #0]) do
      begin
        Inc(P);
        Inc(Len);
      end;
      if P^ = #0 then                   // �ѽ���
      begin
        OutStream.Write(PStart^, Len + 2);
      end
      else if Len = 0 then              // �ձ�ǩ
      begin
        OutStream.Write(PStart^, 3);
        Inc(P);
      end
      else
      begin                             // �ҵ�һ����
        SetLength(ATag, Len);
        CopyMemory(Pointer(ATag), @PStart[2], Len * SizeOf(Char));
        Inc(P);
        Result := True;
        Exit;
      end;
      Continue;
    end;
    
    OutStream.Write(P^, SizeOf(Char));
    Inc(P);
  end;
end;

function TCnTemplateParser.GetContent: string;
var
  P: PChar;
  Idx: Integer;
  Stream: TMemoryStream;
  TagString, ReplaceText: string;
  TagParams: TStringList;
begin
  P := PChar(FTemplateText);
  Stream := nil;
  TagParams := nil;
  try
    Stream := TMemoryStream.Create;
    TagParams := TStringList.Create;
    while FindNextTag(P, Stream, TagString) do
    begin
      TagString := Trim(TagString);
      TagParams.Clear;

      Idx := AnsiPos(' ', TagString);
      if Idx > 0 then
      begin
        TagParams.CommaText := Copy(TagString, Idx + 1, MaxInt);
        Delete(TagString, Idx, MaxInt);
      end;
      
      ReplaceText := '';
      if Assigned(FOnTag) then
        FOnTag(Self, TagString, TagParams, ReplaceText);
      if ReplaceText <> '' then
        Stream.Write(PChar(ReplaceText)^, Length(ReplaceText) * SizeOf(Char));
    end;
    Stream.Write(P^, SizeOf(Char));
    Result := PChar(Stream.Memory);
  finally
    Stream.Free;
    TagParams.Free;
  end;
end;

procedure TCnTemplateParser.LoadTemplateFile(const FileName: string);
begin
  TemplateText := '';
  if FileExists(FileName) then
    with TStringList.Create do
    try
      LoadFromFile(FileName);
      TemplateText := Text;
    finally
      Free;
    end;
end;

{ TCnOTAFile }

constructor TCnOTAFile.Create(const Source: string; AAge: TDateTime = -1);
begin
  FSource := Source;
  FAge := AAge;
end;

function TCnOTAFile.GetAge: TDateTime;
begin
  Result := FAge;
end;

function TCnOTAFile.GetSource: string;
begin
  Result := FSource;
end;

{ TCnBaseCreator }

constructor TCnBaseCreator.Create;
begin

end;

function TCnBaseCreator.GetCreatorType: string;
begin
  Result := '';
end;

function TCnBaseCreator.GetExisting: Boolean;
begin
  Result := False;
end;

function TCnBaseCreator.GetFileSystem: string;
begin
  Result := '';
end;

function TCnBaseCreator.GetOwner: IOTAModule;
begin
  Result := CnOtaGetCurrentProject;
end;

function TCnBaseCreator.GetUnnamed: Boolean;
begin
{$IFDEF DEBUG}
  CnDebugger.LogMsg('Unnamed true.');
{$ENDIF}
  Result := False;
end;

procedure TCnBaseCreator.OnReplaceTagsSource(Sender: TObject; const TagString: 
  string; TagParams: TStrings; var ReplaceText: string);
begin
  // ���಻�� Tag ������
end;

function TCnBaseCreator.GetIOTAFileByTemplate(ASourceType:
  TCnSourceType): IOTAFile;
var
  Producer: TCnTemplateParser;
begin
  TemplateFile := GetTemplateFile(ASourceType);
  SourceType := ASourceType;
  if (TemplateFile = '') or not FileExists(TemplateFile) then
  begin
    Result := nil;
    Exit;
  end;

  Producer := TCnTemplateParser.Create;
  try
    Producer.LoadTemplateFile(TemplateFile);
    Producer.OnTag := OnReplaceTagsSource;
    Result := TCnOTAFile.Create(Producer.Content);
  finally
    Producer.Free;
  end;
end;

function TCnBaseCreator.GetNeedBaseProcess: Boolean;
begin
  Result := True;
end;

procedure TCnBaseCreator.InternalReplaceTagSource(const TagString: string; 
  TagParams: TStrings; var ReplaceText: string);
begin
  // ���������ı�׼���滻
end;

{ TCnTemplateModuleCreator }

function TCnTemplateModuleCreator.GetAncestorName: string;
begin
  Result := '';
end;

function TCnTemplateModuleCreator.GetImplFileName: string;
begin
  Result := '';
end;

function TCnTemplateModuleCreator.GetIntfFileName: string;
begin
  Result := '';
end;

function TCnTemplateModuleCreator.GetFormName: string;
begin
  Result := '';
end;

function TCnTemplateModuleCreator.GetMainForm: Boolean;
begin
  Result := False;
end;

function TCnTemplateModuleCreator.GetShowForm: Boolean;
begin
  Result := True;
end;

function TCnTemplateModuleCreator.GetShowSource: Boolean;
begin
  Result := True;
end;

function TCnTemplateModuleCreator.NewFormFile(const FormIdent, AncestorIdent:
  string): IOTAFile;
begin
  {$IFDEF DEBUG}
  CnDebugger.LogFmt('New Form File. %s, %s', [FormIdent, AncestorIdent]);
  {$ENDIF}
  FModuleIdent := '';
  FFormIdent := FormIdent;
  FAncestorIdent := AncestorIdent;
  Result := Self.GetIOTAFileByTemplate(stFormFile);
end;

function TCnTemplateModuleCreator.NewImplSource(const ModuleIdent, FormIdent,
  AncestorIdent: string): IOTAFile;
begin
  {$IFDEF DEBUG}
  CnDebugger.LogFmt('New Impl Source.%s, %s, %s', [ModuleIdent, FormIdent, AncestorIdent]);
  {$ENDIF}
  FModuleIdent := ModuleIdent;
  FFormIdent := FormIdent;
  FAncestorIdent := AncestorIdent;
  Result := GetIOTAFileByTemplate(stImplSource);
end;

function TCnTemplateModuleCreator.NewIntfSource(const ModuleIdent, FormIdent,
  AncestorIdent: string): IOTAFile;
begin
  {$IFDEF DEBUG}
  CnDebugger.LogFmt('New Intf Source. %s, %s, %s', [ModuleIdent, FormIdent, AncestorIdent]);
  {$ENDIF}
  FModuleIdent := ModuleIdent;
  FFormIdent := FormIdent;
  FAncestorIdent := AncestorIdent;
  Result := GetIOTAFileByTemplate(stIntfSource);
end;

procedure TCnTemplateModuleCreator.OnReplaceTagsSource(Sender: TObject; const 
  TagString: string; TagParams: TStrings; var ReplaceText: string);
begin
  if GetNeedBaseProcess then // ��Ҫ���л������滻������£��滻��Ԫ���������ƺ�����
  begin
    if TagString = csUnitName then
      ReplaceText := FModuleIdent
    else if TagString = csFormName then
      ReplaceText := FFormIdent;

    InternalReplaceTagSource(TagString, TagParams, ReplaceText);
  end;

  DoReplaceTagsSource(TagString, TagParams, ReplaceText, SourceType, FModuleIdent,
    FFormIdent, FAncestorIdent);
end;

procedure TCnTemplateModuleCreator.FormCreated(const FormEditor: IOTAFormEditor);
begin

end;

function TCnTemplateModuleCreator.GetCreatorType: string;
begin
  Result := sUnit;
end;

procedure TCnTemplateModuleCreator.DoReplaceTagsSource(const TagString: string;
  TagParams: TStrings; var ReplaceText: string; ASourceType: TCnSourceType; 
  ModuleIdent, FormIdent, AncestorIdent: string);
begin
  // ���಻��������ɫ���滻
end;

{ TCnTemplateDataModuleCreator }

function TCnTemplateDataModuleCreator.GetAncestorName: string;
begin
  Result := 'DataModule';
end;

{ TCnTemplateProjectCreator }

function TCnTemplateProjectCreator.GetOwner: IOTAModule;
begin
  Result := CnOtaGetProjectGroup;
end;

function TCnTemplateProjectCreator.GetFileName: string;
begin
  Result := '';
end;

function TCnTemplateProjectCreator.GetOptionFileName: string;
begin
  Result := '';
end;

function TCnTemplateProjectCreator.GetShowSource: Boolean;
begin
  Result := False;
end;

procedure TCnTemplateProjectCreator.NewDefaultModule;
begin

end;

function TCnTemplateProjectCreator.NewOptionSource(const ProjectName: string):
  IOTAFile;
begin
  Self.FProjectName := ProjectName;
  Result := Self.GetIOTAFileByTemplate(stOptionSource);
end;

procedure TCnTemplateProjectCreator.NewProjectResource(const Project: IOTAProject);
begin

end;

function TCnTemplateProjectCreator.NewProjectSource(const ProjectName: string):
  IOTAFile;
begin
  Self.FProjectName := ProjectName;
  Result := Self.GetIOTAFileByTemplate(stProjectSource);
end;

{$IFDEF BDS}
procedure TCnTemplateProjectCreator.NewDefaultProjectModule(const Project: IOTAProject);
begin

end;

function TCnTemplateProjectCreator.GetProjectPersonality: string;
begin
  Result := sDelphiPersonality;
end;
{$ENDIF}

procedure TCnTemplateProjectCreator.OnReplaceTagsSource(Sender: TObject; const
  TagString: string; TagParams: TStrings; var ReplaceText: string);
begin
  if GetNeedBaseProcess then // ��Ҫ���л������滻������£��滻��Ŀ���ƺ�����
  begin
    if TagString = csProjectName then
      ReplaceText := FProjectName;
    InternalReplaceTagSource(TagString, TagParams, ReplaceText);
  end;

  DoReplaceTagsSource(TagString, TagParams, ReplaceText, SourceType, FProjectName);
end;

procedure TCnTemplateProjectCreator.DoReplaceTagsSource(const
    TagString: string; TagParams: TStrings; var ReplaceText: string;
    ASourceType: TCnSourceType; ProjectName: string);
begin
  // ����Ҳ����������ɫ���滻
end;

end.
