unit MutiScreensApi;

interface
uses
  Forms,  SysUtils,Dialogs;


procedure changeScreen(form: TForm; SceenIndex: Integer; PScreen: TScreen); //�ı���ʾ��


implementation




procedure changeScreen(form: TForm; SceenIndex: Integer; PScreen: TScreen); //�ı���ʾ��
begin
  form.Left := PScreen.Monitors[SceenIndex].Left + (PScreen.Monitors[SceenIndex].Width - form.Width) div 2;
  form.Top := PScreen.Monitors[SceenIndex].Top + (PScreen.Monitors[SceenIndex].Height - form.Height) div 2;
end;



end.

