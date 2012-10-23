unit BaseServerLib;

interface
uses
  Base, Dialogs, Common;
type

  TBaseObject = class(TBase)
    OnlyId: string;
    NeedAdd: Boolean;
    constructor Create(PNeedAdd: Boolean = false); overload;
  end;

  TBaseServer = class(TBase)
  public
    procedure ShowErrorMessage(Mess: string);
  end;
implementation

procedure TBaseServer.ShowErrorMessage(Mess: string);
begin
  MessageDlg(Mess, mtError, [mbOK], 0);
end;

constructor TBaseObject.Create(PNeedAdd: Boolean = false);
begin
  inherited Create;
  if PNeedAdd then
    OnlyId := Common.CreateOnlyId;
  NeedAdd := PNeedAdd;
end;

end.

