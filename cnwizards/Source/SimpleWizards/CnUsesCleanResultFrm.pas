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

unit CnUsesCleanResultFrm;
{ |<PRE>
================================================================================
* ������ƣ�CnPack IDE ר�Ұ�
* ��Ԫ���ƣ����õ�Ԫ����������
* ��Ԫ���ߣ��ܾ��� (zjy@cnpack.org)
* ��    ע��
* ����ƽ̨��PWinXP SP2 + Delphi 5.01
* ���ݲ��ԣ�PWin9X/2000/XP + Delphi 5/6/7 + C++Builder 5/6
* �� �� �����ô����е��ַ���֧�ֱ��ػ�����ʽ
* ��Ԫ��ʶ��$Id: CnUsesCleanResultFrm.pas 763 2011-02-07 14:18:23Z liuxiao@cnpack.org $
* �޸ļ�¼��2005.08.11 V1.0
*               ������Ԫ
================================================================================
|</PRE>}

interface

{$I CnWizards.inc}

{$IFDEF CNWIZARDS_CNUSESCLEANER}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, Contnrs, ToolsAPI, CnCheckTreeView, CnWizMultiLang,
  CnDCU32, CnWizShareImages, CnWizConsts, Menus, Clipbrd, CnPopupMenu;

type

  TCnProjectUsesInfo = class
  public
    Project: IOTAProject;
    Units: TObjectList;
    constructor Create;
    destructor Destroy; override;
  end;

  TCnUsesCleanResultForm = class(TCnTranslateForm)
    chktvResult: TCnCheckTreeView;
    lbl1: TLabel;
    btnClean: TButton;
    btnCancel: TButton;
    btnHelp: TButton;
    pmList: TPopupMenu;
    mniSelAll: TMenuItem;
    mniSelNone: TMenuItem;
    mniSelInvert: TMenuItem;
    N2: TMenuItem;
    mniCopyName: TMenuItem;
    mniDefault: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    mniSameSel: TMenuItem;
    mniSameNone: TMenuItem;
    procedure DoSetSameNode(Checked: Boolean);
    procedure btnCleanClick(Sender: TObject);
    procedure mniSelAllClick(Sender: TObject);
    procedure mniSelNoneClick(Sender: TObject);
    procedure mniSelInvertClick(Sender: TObject);
    procedure mniSameNoneClick(Sender: TObject);
    procedure mniCopyNameClick(Sender: TObject);
    procedure mniDefaultClick(Sender: TObject);
    procedure mniSameSelClick(Sender: TObject);
    procedure pmListPopup(Sender: TObject);
    procedure btnHelpClick(Sender: TObject);
  private
    { Private declarations }
    List: TObjectList;
    FSelection: TTreeNode;
  protected
    function GetHelpTopic: string; override;
  public
    { Public declarations }
    procedure InitList(AList: TObjectList);
  end;

function ShowUsesCleanResultForm(AList: TObjectList): Boolean;

{$ENDIF CNWIZARDS_CNUSESCLEANER}

implementation

{$IFDEF CNWIZARDS_CNUSESCLEANER}

{$R *.DFM}

const
  IdxProject = 76;
  IdxUnit = 78;
  IdxUses = 73;
  IdxIntf = 73;
  IdxImpl = 73;

  SCnIntfCaption = 'Interface Uses';
  SCnImplCaption = 'Implementation Uses';

  csUsesKinds: array[TCnUsesKind] of PString =
    (@SCnUsesCleanerHasInitSection, @SCnUsesCleanerHasRegProc,
     @SCnUsesCleanerInCleanList, @SCnUsesCleanerInIgnoreList,
     @SCnUsesCleanerNotSource, @SCnUsesCleanerCompRef);

function ShowUsesCleanResultForm(AList: TObjectList): Boolean;
begin
  with TCnUsesCleanResultForm.Create(nil) do
  try
    InitList(AList);
    Result := ShowModal = mrOk;
  finally
    Free;
  end;   
end;  

{ TCnProjectUsesInfo }

constructor TCnProjectUsesInfo.Create;
begin
  inherited;
  Units := TObjectList.Create;
end;

destructor TCnProjectUsesInfo.Destroy;
begin
  Units.Free;
  inherited;
end;

{ TCnUsesCleanResultForm }

procedure TCnUsesCleanResultForm.InitList(AList: TObjectList);
var
  ProjectInfo: TCnProjectUsesInfo;
  ProjNode, UnitNode, IntfNode, ImplNode, ANode: TTreeNode;
  i, j, k: Integer;
  
  function GetUsesCaption(const ACaption: string; AKind: TCnUsesKinds): string;
  var
    s: string;
    Kind: TCnUsesKind;
  begin
    Result := ACaption;
    s := '';
    for Kind := Low(Kind) to High(Kind) do
      if Kind in AKind then
        if s = '' then
          s := csUsesKinds[Kind]^
        else
          s := s + ', ' + csUsesKinds[Kind]^;
    if s <> '' then
      Result := Result + ' [' + s + ']';
  end;
begin
  List := AList;
  chktvResult.BeginUpdate;
  try
    chktvResult.Items.Clear;
    for i := 0 to List.Count - 1 do
    begin
      ProjectInfo := TCnProjectUsesInfo(List[i]);
      ProjNode := chktvResult.Items.AddChildObject(nil,
        ExtractFileName(ProjectInfo.Project.FileName), ProjectInfo);
      ProjNode.ImageIndex := IdxProject;
      ProjNode.SelectedIndex := IdxProject;
      for j := 0 to ProjectInfo.Units.Count - 1 do
        with TCnEmptyUsesInfo(ProjectInfo.Units[j]) do
        begin
          UnitNode := chktvResult.Items.AddChildObject(ProjNode,
            ExtractFileName(Buffer.FileName), ProjectInfo.Units[j]);
          UnitNode.ImageIndex := IdxUnit;
          UnitNode.SelectedIndex := IdxUnit;

          if IntfCount > 0 then
          begin
            IntfNode := chktvResult.Items.AddChild(UnitNode, SCnIntfCaption);
            IntfNode.ImageIndex := IdxIntf;
            IntfNode.SelectedIndex := IdxIntf;
            for k := 0 to IntfCount - 1 do
            begin
              ANode := chktvResult.Items.AddChildObject(IntfNode,
                GetUsesCaption(IntfItems[k].Name, IntfItems[k].Kinds), IntfItems[k]);
              ANode.ImageIndex := IdxUses;
              ANode.SelectedIndex := IdxUses;
              chktvResult.Checked[ANode] := IntfItems[k].Checked;
            end;
          end;

          if ImplCount > 0 then
          begin
            ImplNode := chktvResult.Items.AddChild(UnitNode, SCnImplCaption);
            ImplNode.ImageIndex := IdxImpl;
            ImplNode.SelectedIndex := IdxImpl;
            for k := 0 to ImplCount - 1 do
            begin
              ANode := chktvResult.Items.AddChildObject(ImplNode,
                GetUsesCaption(ImplItems[k].Name, ImplItems[k].Kinds), ImplItems[k]);
              ANode.ImageIndex := IdxUses;
              ANode.SelectedIndex := IdxUses;
              chktvResult.Checked[ANode] := ImplItems[k].Checked;
            end;
          end;
        end;
    end;
    chktvResult.FullExpand;
    chktvResult.Selected := chktvResult.Items.GetFirstNode;
    chktvResult.TopItem := chktvResult.Items.GetFirstNode;
  finally
    chktvResult.EndUpdate;
  end;
end;

procedure TCnUsesCleanResultForm.btnCleanClick(Sender: TObject);
var
  Node: TTreeNode;
begin
  Node := chktvResult.Items.GetFirstNode;
  while Node <> nil do
  begin
    if (Node.Data <> nil) and (TObject(Node.Data) is TCnUsesItem) then
      TCnUsesItem(Node.Data).Checked := chktvResult.Checked[Node];
    Node := Node.GetNext;
  end;
  ModalResult := mrOk;
end;

procedure TCnUsesCleanResultForm.pmListPopup(Sender: TObject);
var
  Bl: Boolean;
begin
  FSelection := chktvResult.Selected;
  Bl := FSelection <> nil;
  mniCopyName.Enabled := Bl;
  Bl := Bl and (FSelection.Data <> nil) and (TObject(FSelection.Data) is TCnUsesItem);
  mniSameSel.Enabled := Bl;
  mniSameNone.Enabled := Bl;
end;

procedure TCnUsesCleanResultForm.mniSelAllClick(Sender: TObject);
begin
  chktvResult.SelectAll;
end;

procedure TCnUsesCleanResultForm.mniSelNoneClick(Sender: TObject);
begin
  chktvResult.SelectNone;
end;

procedure TCnUsesCleanResultForm.mniSelInvertClick(Sender: TObject);
begin
  chktvResult.SelectInvert;
end;

procedure TCnUsesCleanResultForm.DoSetSameNode(Checked: Boolean);
var
  Node: TTreeNode;
  Obj: TObject;
  UName: string;
begin
  if FSelection <> nil then
  begin
    Obj := TObject(FSelection.Data);
    if (Obj <> nil) and (Obj is TCnUsesItem) then
    begin
      chktvResult.BeginUpdate;
      try
        UName := TCnUsesItem(Obj).Name;
        Node := chktvResult.Items.GetFirstNode;
        while Node <> nil do
        begin
          if (Node.Data <> nil) and (TObject(Node.Data) is TCnUsesItem) and
            SameText(TCnUsesItem(Node.Data).Name, UName) then
            chktvResult.Checked[Node] := Checked;
          Node := Node.GetNext;
        end;
      finally
        chktvResult.EndUpdate;
      end;                      
    end;
  end;
end;

procedure TCnUsesCleanResultForm.mniSameSelClick(Sender: TObject);
begin
  DoSetSameNode(True);
end;

procedure TCnUsesCleanResultForm.mniSameNoneClick(Sender: TObject);
begin
  DoSetSameNode(False);
end;

procedure TCnUsesCleanResultForm.mniCopyNameClick(Sender: TObject);
var
  Obj: TObject;
begin
  if FSelection <> nil then
  begin
    Obj := TObject(FSelection.Data);
    if Obj = nil then
      Clipboard.AsText := FSelection.Text
    else if Obj is TCnUsesItem then
      Clipboard.AsText := TCnUsesItem(Obj).Name
    else if Obj is TCnEmptyUsesInfo then
      Clipboard.AsText := ExtractFileName(TCnEmptyUsesInfo(Obj).Buffer.FileName)
    else
      Clipboard.AsText := FSelection.Text;
  end;
end;

procedure TCnUsesCleanResultForm.mniDefaultClick(Sender: TObject);
var
  Node: TTreeNode;
begin
  chktvResult.BeginUpdate;
  try
    Node := chktvResult.Items.GetFirstNode;
    while Node <> nil do
    begin
      if (Node.Data <> nil) and (TObject(Node.Data) is TCnUsesItem) then
        chktvResult.Checked[Node] := TCnUsesItem(Node.Data).Checked;
      Node := Node.GetNext;
    end;
  finally
    chktvResult.EndUpdate;
  end;
end;

function TCnUsesCleanResultForm.GetHelpTopic: string;
begin
  Result := 'CnUsesCleaner';
end;

procedure TCnUsesCleanResultForm.btnHelpClick(Sender: TObject);
begin
  ShowFormHelp;
end;

{$ENDIF CNWIZARDS_CNUSESCLEANER}
end.

