unit SmsLib;

interface
uses
  Windows;
type
  //          TConnection�������������ڳ�ʼ���ն��봮�ڵ�����
  //          Com_Port�����ںţ�0Ϊ����ӿڣ�1,2,3,...Ϊ���ڣ�
  //          Com_BaudRate��������
  //          Mobile_Type�������ն��ͺ�
  //          Sms_Connection������ֵ(0�������ն�ʧ�ܣ�1�������ն˳ɹ�)
  TConnection    =    function(CopyRight:pchar;Com_Port,Com_BaudRate:Integer;var Mobile_Type,CopyRightToCOM:PChar):Integer;stdcall;


  //          TSend�������������Ͷ���
  //          Sms_TelNum�����͸����ն˺���
  //          Sms_Text�����͵Ķ�������
  //          Sms_Send������ֵ(0�����Ͷ���ʧ�ܣ�1�����Ͷ��ųɹ�)

  TSend          =    function(Sms_TelNum:string;Sms_Text:string):Integer;stdcall;


  //      TReceive��������������ָ�����͵Ķ���
  //      Sms_Type����������(0��δ�����ţ�1���Ѷ����ţ�2���������ţ�3���ѷ����ţ�4��ȫ������)
  //      Sms_Text������ָ�����͵Ķ��������ַ���(���������ַ���˵�������������֮ǰ��"|"������Ϊ�ָ���,ÿ�������м�ĸ��ֶ���"#"������Ϊ�ָ���)

  TReceive       =    function(Sms_Type:string;var Sms_Text:PChar):Integer;stdcall;


  //      TDelete����������ɾ��ָ���Ķ���
  //        Sms_Index�����ŵ�������
  TDelete        =    function(Sms_Index:string):Integer;stdcall;

  //       TAutoFlag����������������ӵ��ն��Ƿ�֧���Զ��շ����Ź���
  //       Sms_AutoFlag������ֵ(0����֧�֣�1��֧��)
  TAutoFlag      =    function :Integer;stdcall;

  //         TNewFlag������������ѯ�Ƿ��յ��µĶ���Ϣ
  //         Sms_AutoFlag������ֵ(0��δ�յ���1���յ�)
  TNewFlag       =    function :Integer;stdcall;

  //        TDisconnection��
  //         �����������Ͽ��ն��봮�ڵ�����
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
