unit LogUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TLogForm = class(TForm)
    LogMemo: TMemo;
  private
    { Private declarations }
  public
    { Public declarations }
    procedure AddLog(log:string);
  end;

var
  LogForm: TLogForm;

implementation

{$R *.dfm}

procedure TLogForm.AddLog(log:string);
begin
    LogMemo.Lines.Add(log);
end;


end.
