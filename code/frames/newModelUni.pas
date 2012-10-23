unit newModelUni;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, bsSkinBoxCtrls, Mask, bsSkinShellCtrls, StdCtrls, bsSkinCtrls,ModelLib,
  bsSkinExCtrls, bsfilectrl, ComCtrls, bsSkinTabs,Common,OneUnit,TwoUnit,ThreeUnit,FourUnit;

type
  TNewModelForm = class(TFrame)
    bsSkinGroupBox1: TbsSkinGroupBox;
    modelbg: TbsSkinPanel;
    bsSkinPanel2: TbsSkinPanel;
    goBtn: TbsSkinButton;
    nextBtn: TbsSkinButton;
    preBtn: TbsSkinButton;
    procedure nextBtnClick(Sender: TObject);
    procedure preBtnClick(Sender: TObject);
    procedure goBtnClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    ModelCode:TModelCode;
    OneModel:TOneModel;
    TwoModel:TTwoModel;
    ThreeModel:TThreeModel;
    FourModel:TFourMoel;
    forms : array of TFrame;
    hasInit:array of Boolean;
    nowIndex:Integer;
    function check(var mess:string;index:Integer):Boolean;
    procedure init;
    procedure initModel(index:Integer);
    procedure hideAllFrame;
  end;

implementation

{$R *.dfm}
uses
  main,CodeMakerLib;


  
function TNewModelForm.check(var mess:string;index:Integer):Boolean;
begin
   case index of
      0:
      begin
          Result := (forms[index] as TOneModel).check(mess);
      end;
      1:
      begin
         Result := (forms[index] as TTwoModel).check(mess);
      end;
      2:
      begin
         Result := (forms[index] as TThreeModel).check(mess);
      end;
      3:
      begin
         Result := (forms[index] as TFourMoel).check(mess);
      end;
   end;
end;

procedure TNewModelForm.initModel(index:Integer);
begin
   case index of
      0:
      begin
          (forms[index] as TOneModel).init;
      end;
      1:
      begin
         (forms[index] as TTwoModel).init;
      end;
      2:
      begin
         (forms[index] as TThreeModel).init;
      end;
      3:
      begin
         (forms[index] as TFourMoel).init;
      end;
   end;
   hasInit[index] := True;
end;

procedure TNewModelForm.goBtnClick(Sender: TObject);
var
  I:Integer;
  mess:string;
begin
  for I := 0 to Length(forms) - 1 do
  begin
      nowIndex := I;
      hideAllFrame;
      forms[I].Visible := True;
      if not hasInit[I] then
        initModel(I);
      preBtn.Enabled := True;
      nextBtn.Enabled := True;
      if I = 3 then
      begin
        nextBtn.Enabled := False;
      end;
      if I = 0 then
      begin
        preBtn.Enabled := False;
      end;
      if not check(mess,I) then
      begin
        if mess <> '' then
        begin
          Application.MessageBox(PChar(mess), '提示', MB_OK +
            MB_ICONSTOP);
        end;
        Exit;
      end;
  end;
  if CodeMaker = nil then
     CodeMaker := TCodeMaker.Create(Application);
  CodeMaker.ShowModal;
end;

procedure TNewModelForm.hideAllFrame;
var
  I:Integer;
begin
  for I := 0 to Length(forms) - 1 do
  begin
      forms[I].Visible := False;
  end;
end;

procedure TNewModelForm.init;
begin
    if OneModel = nil then
    begin
       ModelCode := TModelCode.Create;
       OneModel := TOneModel.Create(Application);
       OneModel.Parent := modelbg;
       OneModel.Align := alClient;
       SetLength(forms,Length(forms)+1);
       forms[Length(forms)-1] := OneModel;
       OneModel.Init;
       SetLength(hasInit,Length(hasInit)+1);
       hasInit[Length(hasInit)-1] := True;


       TwoModel := TTwoModel.Create(Application);
       TwoModel.Parent := modelbg;
       TwoModel.Align := alClient;
       SetLength(forms,Length(forms)+1);
       forms[Length(forms)-1] := TwoModel;
       SetLength(hasInit,Length(hasInit)+1);
       hasInit[Length(hasInit)-1] := False;


       ThreeModel := TThreeModel.Create(Application);
       ThreeModel.Parent := modelbg;
       ThreeModel.Align := alClient;
       SetLength(forms,Length(forms)+1);
       forms[Length(forms)-1] := ThreeModel;
       SetLength(hasInit,Length(hasInit)+1);
       hasInit[Length(hasInit)-1] := False;


       FourModel := TFourMoel.Create(Application);
       FourModel.Parent := modelbg;
       FourModel.Align := alClient;
       SetLength(forms,Length(forms)+1);
       forms[Length(forms)-1] := FourModel;
       SetLength(hasInit,Length(hasInit)+1);
       hasInit[Length(hasInit)-1] := False;

    end;
    hideAllFrame;
    nowIndex := 0;
    OneModel.Visible := True;
end;

procedure TNewModelForm.nextBtnClick(Sender: TObject);
var
  mess:string;
begin
  if check(mess,nowIndex) then
  begin
    hideAllFrame;
    forms[nowIndex+1].Visible := True;
    Inc(nowIndex);
    if not hasInit[nowIndex] then
      initModel(nowIndex);
    if nowIndex = 3 then
    begin
      nextBtn.Enabled := False;
    end;
    preBtn.Enabled := True;
  end
  else if mess <> '' then
  begin
    Application.MessageBox(PChar(mess), '提示', MB_OK + MB_ICONSTOP);
  end;
end;

procedure TNewModelForm.preBtnClick(Sender: TObject);
begin
    hideAllFrame;
    forms[nowIndex-1].Visible := True;
    Inc(nowIndex,-1);
    if not hasInit[nowIndex] then
      initModel(nowIndex);
    if nowIndex = 0 then
    begin
       preBtn.Enabled := False;
    end;
    nextBtn.Enabled := True;
end;

end.
