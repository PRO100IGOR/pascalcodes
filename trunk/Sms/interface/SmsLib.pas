unit SmsLib;

interface
uses
  Windows;
type
  //          TConnection功能描述：用于初始化终端与串口的连接
  //          Com_Port：串口号（0为红外接口，1,2,3,...为串口）
  //          Com_BaudRate：波特率
  //          Mobile_Type：返回终端型号
  //          Sms_Connection：返回值(0：连接终端失败；1：连接终端成功)
  TConnection    =    function(CopyRight:pchar;Com_Port,Com_BaudRate:Integer;var Mobile_Type,CopyRightToCOM:PChar):Integer;stdcall;


  //          TSend功能描述：发送短信
  //          Sms_TelNum：发送给的终端号码
  //          Sms_Text：发送的短信内容
  //          Sms_Send：返回值(0：发送短信失败；1：发送短信成功)

  TSend          =    function(Sms_TelNum:string;Sms_Text:string):Integer;stdcall;


  //      TReceive功能描述：接收指定类型的短信
  //      Sms_Type：短信类型(0：未读短信；1：已读短信；2：待发短信；3：已发短信；4：全部短信)
  //      Sms_Text：返回指定类型的短信内容字符串(短信内容字符串说明：短信与短信之前用"|"符号作为分隔符,每条短信中间的各字段用"#"符号作为分隔符)

  TReceive       =    function(Sms_Type:string;var Sms_Text:PChar):Integer;stdcall;


  //      TDelete功能描述：删除指定的短信
  //        Sms_Index：短信的索引号
  TDelete        =    function(Sms_Index:string):Integer;stdcall;

  //       TAutoFlag功能描述：检测连接的终端是否支持自动收发短信功能
  //       Sms_AutoFlag：返回值(0：不支持；1：支持)
  TAutoFlag      =    function :Integer;stdcall;

  //         TNewFlag功能描述：查询是否收到新的短信息
  //         Sms_AutoFlag：返回值(0：未收到；1：收到)
  TNewFlag       =    function :Integer;stdcall;

  //        TDisconnection：
  //         功能描述：断开终端与串口的连接
  TDisconnection =    function :Integer;stdcall;
  TSmsLoad       =    class(TObject)
  private
      FillName:string;
      PDllName: HMODULE;
      FConnection   : Pointer;
      FSend         : Pointer;
      FReceive      : Pointer;
      FDelete       : Pointer;
      FAutoFlag     : Pointer;
      FNewFlag      : Pointer;
      FDisconnection: Pointer;
  public
      constructor Create(var IsSuccess:Integer;PFileName:string = 'sms.dll'); overload;
      destructor  Destroy; override;
      function    Connection(CopyRight:pchar;Com_Port,Com_BaudRate:integer;var Mobile_Type,CopyRightToCOM:PChar):Integer;
      function    Send(Sms_TelNum:string;Sms_Text:string):Integer;
      function    Receive(Sms_Type:string;var Sms_Text:PChar):Integer;
      function    Delete(Sms_Index:string):Integer;
      function    AutoFlag:Integer;
      function    NewFlag :Integer;
      function    Disconnection:Integer; 
  end;
implementation

constructor TSmsLoad.Create(var IsSuccess:Integer;PFileName:string = 'sms.dll');
begin
    PDllName := LoadLibrary(PChar(PFileName));
    FillName := PFileName;
    IsSuccess := 0;
    if PDllName > 32 then
    begin
        FConnection    := GetProcAddress(PDllName,PChar('Sms_Connection'));
        FSend          := GetProcAddress(PDllName,PChar('Sms_Send'));
        FReceive       := GetProcAddress(PDllName,PChar('Sms_Receive'));
        FDelete        := GetProcAddress(PDllName,PChar('Sms_Delete'));
        FAutoFlag      := GetProcAddress(PDllName,PChar('Sms_AutoFlag'));
        FNewFlag       := GetProcAddress(PDllName,PChar('Sms_NewFlag'));
        FDisconnection := GetProcAddress(PDllName,PChar('Sms_Disconnection'));
        IsSuccess      := 1;
    end;
end;
destructor  TSmsLoad.Destroy;
begin
    if PDllName > 32 then
    begin
       Disconnection;
       FreeLibrary(PDllName);
       PDllName := 0;
    end;
end;
function    TSmsLoad.Connection(CopyRight:pchar;Com_Port,Com_BaudRate:integer;var Mobile_Type,CopyRightToCOM:PChar):Integer;
begin
    Result := 0;
    if (PDllName > 32) and (Integer(FConnection) > 0) then
       Result := TConnection(FConnection)(CopyRight,Com_Port,Com_BaudRate,Mobile_Type,CopyRightToCOM);
end;
function    TSmsLoad.Send(Sms_TelNum:string;Sms_Text:string):Integer;
begin
    Result := 0;
    if (PDllName > 32) and (Integer(FSend) > 0) then
       Result := TSend(FSend)(Sms_TelNum,Sms_Text);
end;
function    TSmsLoad.Receive(Sms_Type:string;var Sms_Text:PChar):Integer;
begin
    Result := 0;
    if (PDllName > 32) and (Integer(FReceive) > 0) then
       Result :=  TReceive(FReceive)(Sms_Type,Sms_Text);
end;
function    TSmsLoad.Delete(Sms_Index:string):Integer;
begin
    Result := 0;
    if (PDllName > 32) and (Integer(FDelete) > 0) then
       Result :=  TDelete(FDelete)(Sms_Index);
end;
function    TSmsLoad.AutoFlag:Integer;
begin
    Result := 0;
    if (PDllName > 32) and (Integer(FAutoFlag) > 0) then
       Result :=  TAutoFlag(FAutoFlag) ;
end;
function    TSmsLoad.NewFlag :Integer;
begin
    Result := 0;
   if (PDllName > 32) and (Integer(FNewFlag) > 0) then
       Result :=  TNewFlag(FNewFlag);
end;
function    TSmsLoad.Disconnection:Integer;
begin
    Result := 0;
    if (PDllName > 32) and (Integer(FDisconnection) > 0) then
       Result :=  TDisconnection(FDisconnection);
end;

end.
