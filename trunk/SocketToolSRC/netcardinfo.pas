unit netcardinfo;

interface

uses  Windows, SysUtils,Dialogs;
Const
  MAX_ADAPTER_NAME_LENGTH        = 256;
  MAX_ADAPTER_DESCRIPTION_LENGTH = 128;
  MAX_ADAPTER_ADDRESS_LENGTH     = 8;

  Type
  TIPAddressString = Array[0..4*4-1] of Char;

  PIPAddrString = ^TIPAddrString;
  
  TIPAddrString = Record
    Next      : PIPAddrString;
    IPAddress : TIPAddressString;
    IPMask    : TIPAddressString;
    Context   : Integer;
  End;


  PIPAdapterInfo = ^TIPAdapterInfo;
  TIPAdapterInfo = Record { IP_ADAPTER_INFO }
    Next                : PIPAdapterInfo;
    ComboIndex          : Integer;
    AdapterName         : Array[0..MAX_ADAPTER_NAME_LENGTH+3] of Char;
    Description         : Array[0..MAX_ADAPTER_DESCRIPTION_LENGTH+3] of Char;
    AddressLength       : Integer;
    Address             : Array[1..MAX_ADAPTER_ADDRESS_LENGTH] of Byte;
    Index               : Integer;
    _Type               : Integer;
    DHCPEnabled         : Integer;
    CurrentIPAddress    : PIPAddrString;
    IPAddressList       : TIPAddrString;
    GatewayList         : TIPAddrString;
  End;

function getnetcardinfo:string;
function getudpbroadaddr:string;
function getlocalip:string; 
implementation

Function GetAdaptersInfo(AI : PIPAdapterInfo; Var BufLen : Integer) : Integer;
         StdCall; External 'iphlpapi.dll' Name 'GetAdaptersInfo';

Function MACToStr(ByteArr : PByte; Len : Integer) : String;
  Begin
    Result := '';
    While (Len > 0) do Begin
      Result := Result+IntToHex(ByteArr^,2)+'-';
      ByteArr := Pointer(Integer(ByteArr)+SizeOf(Byte));
      Dec(Len);
    End;
    SetLength(Result,Length(Result)-1); { remove last dash }
End;

Function GetAddrString(Addr : PIPAddrString) : String;
  Begin
    Result := '';
    While (Addr <> nil) do Begin
      Result := Result+'A: '+Addr^.IPAddress+' M: '+Addr^.IPMask+#13;
      Addr := Addr^.Next;
    End;
  End;


function getnetcardinfo:string;
var
  AI,Work : PIPAdapterInfo;
  Size    : Integer;
  Res     : Integer;
  s:string;
begin
  Size := 5120;
  GetMem(AI,Size);
  work:=ai;

  Res := GetAdaptersInfo(AI,Size);
  If (Res <> ERROR_SUCCESS) Then
  Begin
    //SetLastError(Res);
    //RaiseLastWin32Error;
    result:=''; exit;
  End;

  s:='';
  {
  s:=s+'Adapter address: '+MACToStr(@Work^.Address,Work^.AddressLength);
  repeat
    s:=s+'  IP addresses: '+GetAddrString(@Work^.IPAddressList);
    work:=work^.Next ;
  until (work=nil);
  }
  s:=GetAddrString(@Work^.IPAddressList);
  result:=s;
end;

{
procedure TForm1.Button1Click(Sender: TObject);
var
  AI,Work : PIPAdapterInfo;
  Size    : Integer;
  Res     : Integer;
begin
  Size := 5120;
  GetMem(AI,Size);
  work:=ai;
  Res := GetAdaptersInfo(AI,Size);
  If (Res <> ERROR_SUCCESS) Then Begin
    SetLastError(Res);
    RaiseLastWin32Error;
  End;
  memo1.Lines.Add ('Adapter address: '+MACToStr(@Work^.Address,Work^.AddressLength));
  repeat
    memo1.Lines.add('  IP addresses: '+GetAddrString(@Work^.IPAddressList));
    work:=work^.Next ;
  until (work=nil);
end;
}


//------------
function getip(valuestr:string):string;
var i:integer;
    s,a,b,c,d:string;
    rets:string;
begin
   rets:='0000';

   s:=valuestr;

   i:=pos('.',s);
   if i=0 then
   begin
     result:='';
     exit;
   end;
   a:=copy(s,1,i-1);
   s:=copy(s,i+1,length(s));

   i:=pos('.',s);
   if i=0 then
   begin
     result:='';
     exit;
   end;
   b:=copy(s,1,i-1);
   s:=copy(s,i+1,length(s));

   i:=pos('.',s);
   if i=0 then
   begin
     result:='';
     exit;
   end;
   c:=copy(s,1,i-1);
   s:=copy(s,i+1,length(s));

   d:=s;

   try
    if ((strtoint(a)>255) or (strtoint(a)<0)) then
    begin
     result:=''; exit;
    end;
    if ((strtoint(b)>255)  or (strtoint(b)<0)) then
    begin
     result:=''; exit;
    end;
    if ((strtoint(c)>255)   or (strtoint(c)<0)) then
    begin
     result:=''; exit;
    end;
    if ((strtoint(d)>255)  or (strtoint(d)<0)) then
    begin
     result:=''; exit;
    end;


     rets[1]:=chr(strtoint(a));
     rets[2]:=chr(strtoint(b));
     rets[3]:=chr(strtoint(c));
     rets[4]:=chr(strtoint(d));
   except
     result:='';
     exit;
   end;
   result:=rets;
end;


function getlocalip:string;
var s,s2:string;
    maskbytes:string;
    ipaddrbytes:string;
    pos1,pos2,pos3:integer;
    tmps1,tmps2:string;
begin
 s:=getnetcardinfo;
 if s='' then
 begin
  result:='127.0.0.1';
  exit;
 end;
 pos1:=pos('A:',s);  pos2:=pos('M:',s);  pos3:=pos(chr($D),s);
 //ip addr
 result:=trim(copy(s,pos1+2,pos2-pos1-2));
end;

function getudpbroadaddr:string;
var s,s2:string;
    maskbytes:string;
    ipaddrbytes:string;
    pos1,pos2,pos3:integer;
    tmps1,tmps2:string;
begin
 s:=getnetcardinfo;
 if s='' then
 begin
  showmessage('请检查本机网络连接是否正常');
 end;
 pos1:=pos('A:',s);  pos2:=pos('M:',s);  pos3:=pos(chr($D),s);
 //ip addr
 s2:=trim(copy(s,pos1+2,pos2-pos1-2));
 if s2='0.0.0.0' then showmessage('请检查本机网络连接是否正常');
 ipaddrbytes:=getip(s2);

 //subnet
 s2:=trim(copy(s,pos2+2,pos3-pos2-2));
 maskbytes:=getip(s2);
 tmps1:=chr(ord(ipaddrbytes[1]) and ord(maskbytes[1]))+
        chr(ord(ipaddrbytes[2]) and ord(maskbytes[2]))+
        chr(ord(ipaddrbytes[3]) and ord(maskbytes[3]))+
        chr(ord(ipaddrbytes[4]) and ord(maskbytes[4]));
 tmps2:=chr(ord(maskbytes[1]) xor $FF)+chr(ord(maskbytes[2]) xor $FF)+
        chr(ord(maskbytes[3]) xor $FF)+chr(ord(maskbytes[4]) xor $FF);

 //udp broadcast add
 result:= inttostr( ord(tmps1[1])+  ord(tmps2[1]) ) +'.'+
                   inttostr( ord(tmps1[2])+  ord(tmps2[2]) ) +'.'+
                   inttostr( ord(tmps1[3])+  ord(tmps2[3]) ) +'.'+
                   inttostr( ord(tmps1[4])+  ord(tmps2[4]) ) ;
end;

//-----------
end.

