unit Tip;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, RzPanel,ShellApi;

type
  TTipForm = class(TForm)
    header: TRzPanel;
    lblcontent: TLabel;
    procedure FormClick(Sender: TObject);
  private
    { Private declarations }

  public
    { Public declarations }
  end;

var
  TipForm: TTipForm;

implementation
uses
    MainForm,login;
{$R *.dfm}
procedure TTipForm.FormClick(Sender: TObject);
begin
Main.CoolTrayIcon.Hint := '来文提醒系统';
ShellExecute(handle, 'open', 'explorer.exe', pChar('http://'+login.ip+':'+login.port+'/oxhide/'), nil, SW_SHOWNORMAL);
Self.Close;
end;

end.
