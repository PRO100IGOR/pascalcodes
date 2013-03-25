unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type


        //记录类型
        TAT_INFO=       record
        JobTime:        DWord;
        DaysOfMonth:    DWord;
        DaysOfWeek:     UCHAR;
        Flags:          UCHAR;
        Command:        PWideChar;
        end;

        PAT_INFO=       ^TAT_INFO;
        NET_API_STATUS= Longint;


        TForm1 = class(TForm)
        Button1: TButton;
    procedure Button1Click(Sender: TObject);
        private
        { Private declarations }
        public
        { Public declarations }
end;
Function  NetScheduleJobAdd(ServerName:   PWideChar;   Buffer:   PAT_INFO;   var   JobID:   PDWord):NET_API_STATUS;stdcall;

var
  Form1: TForm1;

implementation

{$R *.DFM}
function   NetScheduleJobAdd; external 'netapi32.dll' name 'NetScheduleJobAdd';


procedure TForm1.Button1Click(Sender: TObject);
var

  ATInfo:PAT_Info;

  jobid:PDword;
  const JOB_RUN_PERIODICALLY : BYTE=$01;
  CONST NERR_Success:integer=0;
begin
        getmem(atinfo,sizeof(TAt_info));

        getmem(jobid,sizeof(dword));

        atinfo^.jobtime:=13*60*60*1000+45*60*1000;//miliseconds   from   midnight   to   3:15

        atinfo^.DaysOfMonth:=0;

        atinfo^.DaysOfWeek:=0;

        atinfo^.command:='"'+'E:\delphi\AccessSrv\安装服务.bat'+'"';

        atinfo^.flags:=1;

        if   NetScheduleJobAdd(nil,atinfo,jobid)=NERR_Success  then
                showmessage('ok');
        //freemem(jobid);
        freemem(atinfo);


end;

end.
