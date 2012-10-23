unit Common;

interface

uses
  SysUtils, ActiveX, Winsock, Classes,StdCtrls,IdHTTP,ModelLib,Windows,XMLIntf, XMLDoc,Variants,bsSkinBoxCtrls,ShellAPI;
const
  strEncryptCode : String = 'VZHLEPDQKYMGSOJX';
type
  StringArray = array of string;

function Split(const Source: string; ASplit: string): StringArray;

function SplitToStringList(const Source: string; ASplit: string): TStrings; overload;

function SplitToStringList(const Source: string; ASplit: string; Strings: TStrings): TStrings; overload;

function toArr(const Source: string): StringArray; //�ַ�����Ϊһ������

function toStringList(const Source: string): TStrings; //�ַ�����Ϊһ������

function StrToUniCode(text: string): string;

function UnicodeToStr(text: string): string;

procedure CompletStr(var text: string; Lengths: Integer); // ��0���textΪָ������

function CheckNum(const V: string): Boolean; //��֤�Ƿ�������

function CreateOnlyId: string; //����Ψһ���к�

function CompletWeight(text: string; LengthInt, LengthFloat: Integer): string; //��ʽ���������

function GetIPAddr: string; //��ȡip��ַ

function FormatDouble(Source: Double; Format: string): Double; //������������

function RandomStr(): string; //���ȡ��4λa��z֮���ַ���

function BooleanToStr(va: boolean): string;
function Encrypt(Source: string): string; //����
function Decrypt(Source: string): string;    //����

function checkPro(path:String;var mess:string):Boolean; //�����Ŀ�������Ƿ�Ϸ�
function checkMobilePro(path:String;var mess:string):Boolean; //����ƶ���Ŀ�������Ƿ�Ϸ�
function checkHasFire(dir:String;p:string):Boolean;    //�ļ������Ƿ����������ļ�
function getAllFilesFromDir(dir:string;p:string):TStrings; //��dir�л�ȡȫ��ָ�����͵��ļ���
procedure changeFileContext(filename,name1,name2:string);  //�滻ָ���ļ��е�����

function getClassNameFromPack(pack:string):string;//�Ӱ�����������

procedure readXml(xml,className:string;var ModelCode:TModelCode;classNameLarge :string = ''); //��xml�й��� ModelCode
function getIdFromXml(xml:string):string;//��ָ��xml�ж�ȡ����id
procedure getHistoryFromtxt(author: TbsSkinComboBox;fileName:string);overload; //��txt�ж�ȡ��ʷ���ݣ���Ĭ��ѡ��1
procedure getHistoryFromtxt(author: TbsSkinListBox;fileName:string);overload; //��txt�ж�ȡ��ʷ���ݣ���Ĭ��ѡ��1
function getValueFromServer(fileName,url:string):TStrings; //�ӷ������϶�ȡ�ļ�����
function getServiceFromSpring(basePath,className:string;springs:TStrings):string;//��xml�ж�ȡspring�����ļ��е�service
function getPacFromHbm(fileName:string):string;
procedure getProsFromHiberNate(var Model:TModel); //��hibernate�ж�ȡ����
function trimFileContext(filename:string):TStrings;  //����xml
function   CopyDirectory(const   Source,   Dest:   string):   boolean;
function encode(text:String):string;    //ת��unicode����
function decode(text:String):string;     //����unicode����
function enLargeCode(text:String;key:string):string;     //������
function deLargeCode(text:String;key:string):string;  //������
implementation


function encode(text:String):string;
var
  i, len: Integer;
  cur: Integer;
  t: string;
  ws: WideString;
begin
  Result := '';
  ws := text;
  len := Length(ws);
  i := 1;
  while i <= len do
  begin
    cur := Ord(ws[i]);
    if cur > 255 then
    begin
        FmtStr(t, '%4.4X', [cur]);
        Result := Result + '^' + LowerCase(t);
    end
    else
    begin
        if ((cur < 48) or ((cur > 57) and (cur < 65)) or ( (cur > 90) and (cur < 97)) or (cur > 122)) then
        begin
          FmtStr(t, '%2.2X', [cur]);
          Result := Result + '~' + LowerCase(t);
        end
        else
        begin
           Result := Result + ws[i];
        end;

    end;
    Inc(i);
  end;
end;

function decode(text:String):string;
var
  I, Len: Integer;
  temp:string;
begin
  I := 1;
  Len := Length(text);
  text := StringReplace(text, #13, '', [rfReplaceAll]);
  text := StringReplace(text, #10, '', [rfReplaceAll]);
  while I <= Len do
  begin
    temp := text[I];
    if temp = '~' then
    begin
        Result := Result + Widechar(StrToInt('$' + copy(text, I+1, 2)));
        I := I + 3;
    end
    else if temp = '^' then
    begin
       Result := Result + Widechar(StrToInt('$' + copy(text, I+1, 4)));
       I := I + 5;
    end
    else
    begin
       Result := Result + temp;
       Inc(I);
    end;
  end;
end;

function trimFileContext(filename:string):TStrings;  //����xml
var
  F: TextFile;
  Str: string;
  I: integer;
  TypeStrings: TStrings;
  booleana,bb:Boolean;
begin
  
end;

function getValueFromServer(fileName,url:string):TStrings; //�ӷ������϶�ȡ�ļ�����
var
  idhtpLog: TIdHTTP;
  Stream: TMemoryStream;
begin
    idhtpLog := TIdHTTP.Create(nil);
    Stream := TMemoryStream.Create;
  try
    idhtpLog.Get(url + '/res/'+fileName, Stream);
    Result := TStringList.Create;
    Stream.SaveToFile(ExtractFileDir(PARAMSTR(0))+'/~temp.bmp');
    Result.LoadFromFile(ExtractFileDir(PARAMSTR(0))+'/~temp.bmp');
    DeleteFile(PChar(ExtractFileDir(PARAMSTR(0))+'/~temp.bmp'));
  finally
    Stream.Free;
    idhtpLog.Free;
  end;
end;

procedure getHistoryFromtxt(author: TbsSkinComboBox;fileName:string); //��txt�ж�ȡ��ʷ���ݣ���Ĭ��ѡ��1
var
  I:Integer;
  A:array of Integer;
begin
  if FileExists(fileName) then
  begin
    author.Items.LoadFromFile(fileName);
    for I := 0 to author.Items.Count - 1 do begin
        if author.Items[I] = '' then
        begin
             SetLength(A,Length(A) + 1);
             A[Length(A) - 1] := I;
        end;
    end;
    for I := 0 to Length(A) - 1 do
        author.Items.Delete(A[I]);
    if author.Items.Count > 0 then
      author.ItemIndex := 0;
  end;
end;

procedure getHistoryFromtxt(author: TbsSkinListBox;fileName:string); //��txt�ж�ȡ��ʷ���ݣ���Ĭ��ѡ��1
var
  I:Integer;
  A:array of Integer;
begin
  if FileExists(fileName) then
  begin
    author.Items.LoadFromFile(fileName);

    for I := 0 to author.Items.Count - 1 do begin
        if author.Items[I] = '' then
        begin
             SetLength(A,Length(A) + 1);
             A[Length(A) - 1] := I;
        end;
    end;
    for I := 0 to Length(A) - 1 do
        author.Items.Delete(A[I]);

    if author.Items.Count > 0 then
      author.ItemIndex := 0;
  end;
end;

function getIdFromXml(xml:string):string;//��ָ��xml�ж�ȡ����id
var
  XMLDocument: IXMLDocument;
  rootnode, classNode: IXMLNode;
begin
  if FileExists(xml) then
  begin
      XMLDocument := TXMLDocument.Create(nil);
      XMLDocument.LoadFromFile(xml);
      rootnode := XMLDocument.DocumentElement;
      classNode := rootnode.ChildNodes[0];
      Result := classNode.ChildNodes['id'].Attributes['name'];
      XMLDocument := nil;
  end
  else
  begin
     Result := '';
  end;
end;


procedure readXml(xml,className:string;var ModelCode:TModelCode;classNameLarge :string = ''); //��xml�й��� ModelCode
var
  XMLDocument: IXMLDocument;
  rootnode, classNode,propertys: IXMLNode;
  I:Integer;
  Prototype:TPrototype;
  temp,temp2:string;
  AStringArray:StringArray;
begin
  XMLDocument := TXMLDocument.Create(nil);
  if xml = '' then
     xml := ModelCode.hibernatePath;
  XMLDocument.LoadFromFile(xml);
  rootnode := XMLDocument.DocumentElement;
  classNode := rootnode.ChildNodes[0];
  if className = '' then
  begin
    if ModelCode.changeHibernate then
    begin
      classNode.AttributeNodes.Delete('catalog');
      classNode.AttributeNodes.Delete('schema');
    end;

    if ModelCode.dynamicUpdate  then
    begin
        classNode.Attributes['dynamic-insert'] := 'true';
        classNode.Attributes['dynamic-update'] := 'true';
    end;

    
  end;


  for I := 0 to classNode.ChildNodes.Count - 1 do
  begin
    propertys := classNode.ChildNodes[I];

    if propertys.NodeName = 'id' then
    begin
        Prototype := TPrototype.Create;
        Prototype.dataType := 'id';
        Prototype.ClassName := classNameLarge;
        Prototype.dataType := propertys.NodeName;
        Prototype.autoInsert := propertys.ChildNodes['generator'].Attributes['class'] <> 'assigned';
        Prototype.dataData := propertys.Attributes['type'];
        Prototype.dataName := className+propertys.Attributes['name'];
        if propertys.ChildNodes['column'].Attributes['length'] = null then
            Prototype.dataLength := 16
        else
            Prototype.dataLength := StrtoInt(propertys.ChildNodes['column'].Attributes['length']);
        ModelCode.prototypes.Add(Prototype.dataName,Prototype);
        ModelCode.proList.Add(Prototype.dataName);
        if className <> '' then
        begin
          ModelCode.parentIds.Add(Prototype.dataName);
          Prototype.enable := False;
        end
        else
        begin
          ModelCode.prototype := Prototype;
        end;
    end
    else if propertys.NodeName = 'property' then
    begin
      Prototype := TPrototype.Create;
      if propertys.ChildNodes[0].ChildNodes.Count > 0 then
        Prototype.comment := propertys.ChildNodes[0].ChildNodes[0].Text
      else
        Prototype.comment :=  propertys.Attributes['name'];
      Prototype.dataType := propertys.NodeName;
      Prototype.ClassName := classNameLarge;
      Prototype.dataData := propertys.Attributes['type'];
      Prototype.dataName := className+propertys.Attributes['name'];
      Prototype.dataType := 'property';
      if propertys.ChildNodes[0].Attributes['length'] = null then
          Prototype.dataLength := 16
      else
          Prototype.dataLength := propertys.ChildNodes[0].Attributes['length'];
      ModelCode.prototypes.Add(Prototype.dataName,Prototype);
      ModelCode.proList.Add(Prototype.dataName);
      if className <> '' then
      begin
          Prototype.enable := False;
      end;
    end
    else if propertys.NodeName = 'many-to-one' then
    begin
        temp2 := Common.getClassNameFromPack(propertys.Attributes['class']);
        temp := ModelCode.hibernate + temp2+'.hbm.xml';
        if ModelCode.xmlList.IndexOf(temp2) = -1 then
        begin
            ModelCode.xmlList.Add(temp2);
            readXml(temp,className+propertys.Attributes['name']+'.',ModelCode,propertys.Attributes['name']);
        end;
        if className = '' then
        begin
          if ModelCode.ManyToOne <> '' then
          begin
             AStringArray := Split(ModelCode.ManyToOne,'=');
             if Length(AStringArray) = 2  then
             begin
                propertys.Attributes[AStringArray[0]] := AStringArray[1];
             end;
          end;
        end;
    end
    else if propertys.NodeName = 'set' then
    begin
        if className = '' then
        begin
          if ModelCode.OneToMany <> '' then
          begin
             AStringArray := Split(ModelCode.OneToMany,'=');
             if Length(AStringArray) = 2  then
             begin
                propertys.Attributes[AStringArray[0]] := AStringArray[1];
             end;
          end;
        end;
    end;
    XMLDocument.SaveToFile(xml);
  end;
  XMLDocument := nil;
end;

procedure getProsFromHiberNate(var Model:TModel); //��hibernate�ж�ȡ����
var
  XMLDocument: IXMLDocument;
  rootnode, classNode,propertys: IXMLNode;
  I:Integer;
  Prototype:TPrototype;
begin
  XMLDocument := TXMLDocument.Create(nil);

  XMLDocument.LoadFromFile(Model.hibernatePath);
  rootnode := XMLDocument.DocumentElement;
  classNode := rootnode.ChildNodes[0];
  

  for I := 0 to classNode.ChildNodes.Count - 1 do
  begin
    propertys := classNode.ChildNodes[I];
    if propertys.NodeName = 'id' then
    begin
        Prototype := TPrototype.Create;
        Prototype.dataType := 'id';
        Prototype.dataType := propertys.NodeName;
        Prototype.autoInsert := propertys.ChildNodes['generator'].Attributes['class'] <> 'assigned';
        Prototype.dataData := propertys.Attributes['type'];
        Prototype.dataName := propertys.Attributes['name'];
        if propertys.ChildNodes['column'].Attributes['length'] = null then
              Prototype.dataLength := 16
        else
              Prototype.dataLength := StrtoInt(propertys.ChildNodes['column'].Attributes['length']);
        Model.prototypes.Add(Prototype.dataName,Prototype);
    end
    else if propertys.NodeName = 'property' then
    begin
      Prototype := TPrototype.Create;
      if propertys.ChildNodes[0].ChildNodes.Count > 0 then
        Prototype.comment := propertys.ChildNodes[0].ChildNodes[0].Text
      else
        Prototype.comment :=  propertys.Attributes['name'];
      Prototype.dataType := propertys.NodeName;
      Prototype.dataData := propertys.Attributes['type'];
      Prototype.dataName := propertys.Attributes['name'];
      Prototype.dataType := 'property';
      if propertys.ChildNodes[0].Attributes['length'] = null then
          Prototype.dataLength := 16
      else
          Prototype.dataLength := propertys.ChildNodes[0].Attributes['length'];
      Model.prototypes.Add(Prototype.dataName,Prototype);
    end;
  end;
  XMLDocument := nil;
end;

function getClassNameFromPack(pack:string):string;//�Ӱ�����������
begin
  Result := Copy(pack,LastDelimiter('.',pack)+1,999);
end;

function checkHasFire(dir:String;p:string):Boolean;    //�ļ������Ƿ����������ļ�
var
  sr:TSearchRec;
begin
    if SysUtils.FindFirst(dir + '\'+p, faAnyFile, sr) = 0 then
    begin
      repeat
        if (sr.Name<>'.') and (sr.Name<>'..') then
        begin
          Result := True;
          Break;
        end;
      until SysUtils.FindNext(sr) <> 0;
      SysUtils.FindClose(sr);
    end;
    Result := False;
end;
function getAllFilesFromDir(dir:string;p:string):TStrings; //��dir�л�ȡȫ��ָ�����͵��ļ���
var
  sr:TSearchRec;
  temp:TStrings;
begin
    temp := TStringList.Create;
    if SysUtils.FindFirst(dir + '\'+p, faAnyFile, sr) = 0 then
    begin
      repeat
        if (sr.Name<>'.') and (sr.Name<>'..') then
        begin
          temp.Add(sr.Name);
        end;
      until SysUtils.FindNext(sr) <> 0;
      SysUtils.FindClose(sr);
    end;
    Result := temp;
end;
procedure changeFileContext(filename,name1,name2:string);  //�滻ָ���ļ��е�����
var
  F: TextFile;
  Str: string;
  TypeStrings: TStrings;
begin
  TypeStrings := TStringList.Create;
  if FileExists(FileName) then
  begin
    AssignFile(F, FileName);
    Reset(F);
    while not Eof(F) do
    begin
      Readln(F, Str);
      if  Pos(name1,Str) > 0 then
      begin
          TypeStrings.add(StringReplace(Str,name1,name2,[rfReplaceAll,rfIgnoreCase]));
      end
      else
      begin
         TypeStrings.Add(Str);
      end;
    end;
    Closefile(F);
    TypeStrings.SaveToFile(FileName);
  end;


end;




///����Source����Ŀ¼��DESTĿ¼�����Dest�����ڣ��Զ����������DEST���ڣ���ôSource����ΪDest����Ŀ¼��
//�������Ҫ����E:\Temp����Ŀ¼��E:\��ô����Ϊ��   copydirectory( 'e:\temp ', 'e:\ '); 
///���Ҫ����E:\Temp��E:\TestĿ¼���棬��ô����Ϊ��CopyDirecotry( 'E:\Temp ', 'E:\TEST ');
function   CopyDirectory(const   Source,   Dest:   string):   boolean;
var 
    fo:   TSHFILEOPSTRUCT; 
begin 
    FillChar(fo,   SizeOf(fo),   0); 
    with   fo   do 
    begin 
        Wnd   :=   0; 
        wFunc   :=   FO_COPY; 
        pFrom   :=   PChar(source+#0); 
        pTo   :=   PChar(Dest+#0); 
        fFlags   :=   FOF_NOCONFIRMATION+FOF_NOCONFIRMMKDIR         ; 
    end; 
    Result   :=   (SHFileOperation(fo)   =   0); 
end;
function checkPro(path:String;var mess:string):Boolean; //�����Ŀ�������Ƿ�Ϸ�
begin
    Result:=True;
    if not DirectoryExists(path + '\WebRoot') then
    begin
      mess := '�Ҳ���WebRoot��';
      Result:=False;
      Exit;
    end;
    if not DirectoryExists(path + '\src') then
    begin
      mess := '�Ҳ���src��';
      Result:=False;
      Exit;
    end;
    if not DirectoryExists(path + '\src\hibernatemap') then
    begin
      CreateDirectory(PChar(path + '\src\hibernatemap'), nil);
      Exit;
    end;
    if not DirectoryExists(path + '\src\springconfig') then
    begin
      CreateDirectory(PChar(path + '\src\springconfig'), nil);
      Exit;
    end;
end;
function checkMobilePro(path:String;var mess:string):Boolean; //����ƶ���Ŀ�������Ƿ�Ϸ�
begin
    Result:=True;
    if not DirectoryExists(path + '\assets') then
    begin
      mess := '�Ҳ���assets��';
      Result:=False;
      Exit;
    end;
    if not DirectoryExists(path + '\src') then
    begin
      mess := '�Ҳ���src��';
      Result:=False;
      Exit;
    end;
    if not DirectoryExists(path + '\gen') then
    begin
      mess := '�Ҳ���gen��';
      Result:=False;
      Exit;
    end;
end;
function Encrypt(Source: string): string;
var
  i, n, j: Integer;
  strTmp: string;
  chrTmp: Char;
begin
//    strEncryptCode := 'VZHLEPDQKYMGSOJX';

  Result := '';
  n := Length(Source);
  if (n <= 0) or (n >= 100) then Exit; // ����

    // ����2λ����
  if n < 10 then Result := '0' + IntToStr(n) // ����
  else Result := IntToStr(n);

    // ���� 00+AABBCCDD....
  for i := 1 to n do
  begin
    chrTmp := Source[i];
    strTmp := IntToHex(Ord(ChrTmp), 2);
    Result := Result + strTmp;
  end;
  n := Length(Result);
  strTmp := Copy(Result, n, 1);
  Delete(Result, n, 1);
  Result := strTmp + Result; // ���һ���ַ��ŵ���һ���ַ�
  strTmp := '';
    //
  for i := 1 to n do // �滻
  begin
    case Result[i] of
      '0'..'9':
        strTmp := strTmp + strEncryptCode[StrToInt(Result[i]) + 1];
      'A'..'F', 'a'..'f':
        begin
          j := Ord(UpperCase(Result[i])[1]) - 54; //(-55+1)//91;
          strTmp := strTmp + strEncryptCode[j];
        end;
    end;
  end;
  Result := strTmp;
end;

function Decrypt(Source: string): string;
var
  i, n, j, k: Integer;
  strTmp, strTmp1: string;
    //chrTmp: Char;
begin
  Result := '';
  n := Length(Source);
  if n <= 4 then Exit;

  j := -1;
  strTmp := '';
  for i := 1 to n do
  begin
    StrTmp := Source[i];
    j := Pos(strTmp, strEncryptCode) - 1;
    if j < 0 then break;
        //if j>9 then j := j + 54;

    Result := Result + IntToHex(j, 1);
  end;
  if j < 0 then // ����
  begin
    Result := '';
    Exit;
  end;

  strTmp := Copy(Result, 1, 1);
  Delete(Result, 1, 1);
  Result := Result + strTmp;
  strTmp := Copy(Result, 1, 2);
  try
    k := StrToInt(strTmp);
  except
    Result := '';
    Exit;
  end;

  if k > ((n - 2) div 2) then // ���鳤��
  begin
    Result := '';
    Exit;
  end;
  n := k;
  strTmp := '';
  for i := 1 to n do
  begin
    strTmp1 := Copy(Result, i * 2 + 1, 2);
    j := 0;
    for k := 1 to 2 do
    begin
      case strTmp1[k] of
        '0'..'9':
          j := j * 16 + StrToInt(strTmp1[k]);
        'A'..'F', 'a'..'f':
          begin
            j := j * 16 + Ord(UpperCase(strTmp1[k])[1]) - 55; //91
          end;
      end;
    end;
    strTmp := strTmp + Chr(j);
  end;
  Result := strTmp;
end;

function FormatDouble(Source: Double; Format: string): Double;
var
  Temp: string;
begin
  Temp := FormatFloat(Format, Source);
  Result := StrtoFloat(Temp);
end;

function Split(const Source: string; ASplit: string): StringArray;
var
  AStr: string;
  rArray: StringArray;
  I: Integer;
begin
  if Source = '' then
    Exit;
  AStr := Source;
  I := pos(ASplit, Source);
  Setlength(rArray, 0);
  while I <> 0 do
  begin
    Setlength(rArray, Length(rArray) + 1);
    rArray[Length(rArray) - 1] := copy(AStr, 0, I - 1);
    Delete(AStr, 1, I + Length(ASplit) - 1);
    I := pos(ASplit, AStr);
  end;
  Setlength(rArray, Length(rArray) + 1);
  rArray[Length(rArray) - 1] := AStr;
  Result := rArray;
end;

function SplitToStringList(const Source: string; ASplit: string): TStrings;
var
  rArray: StringArray;
  Roles: TStrings;
  I: Integer;
begin
  rArray := Split(Source, ASplit);
  Roles := TStringList.Create;
  for I := 0 to Length(rArray) - 1 do
  begin
    if rArray[I] = '' then Continue;
    if Roles.IndexOf(rArray[I]) = -1 then
      Roles.Add(rArray[I]);
  end;
  Result := Roles;
end;

function SplitToStringList(const Source: string; ASplit: string; Strings: TStrings): TStrings;
var
  rArray: StringArray;
  I: Integer;
begin
  rArray := Split(Source, ASplit);
  for I := 0 to Length(rArray) - 1 do
  begin
    Strings.Add(rArray[I]);
  end;
  Result := Strings;
end;

function StrToUniCode(text: string): string;
var
  I, len: Integer;
  cur: Integer;
  t: string;
  ws: WideString;
begin
  Result := '';
  ws := text;
  len := Length(ws);
  I := 1;
  Result := '\u';
  while I <= len do
  begin
    cur := Ord(ws[I]);
    FmtStr(t, '%4.4X', [cur]);
    Result := Result + t;
    if I <> len then
      Result := Result + '\u';
    Inc(I);
  end;
end;

// �ָ�

function UnicodeToStr(text: string): string;
var
  I, len: Integer;
  ws: WideString;
begin
  ws := '';
  I := 1;
  len := Length(text);
  while I < len do
  begin
    ws := ws + Widechar(StrToInt('$' + copy(text, I, 4)));
    I := I + 4;
  end;
  Result := ws;
end;

procedure CompletStr(var text: string; Lengths: Integer); // ��0���textΪָ������
var
  L, I: Integer;
begin
  L := Lengths - Length(text);
  for I := 0 to L - 1 do
  begin
    text := '0' + text;
  end;

end;

function CreateOnlyId: string; //����Ψһ���к�
var
  AGuid: TGuid;
begin
  if CoCreateGuid(AGuid) = s_OK then begin
    Result := Split(Split(GUIDToString(AGuid), '{')[1], '}')[0];
  end;
end;

function CheckNum(const V: string): Boolean;
var
  Temp: Double;
begin
  Result := false;
  try
    Temp := StrtoFloat(V);
    Result := true;
  except

  end;

end;

function CompletWeight(text: string; LengthInt, LengthFloat: Integer): string; //��ʽ���������
var
  SA: StringArray;
  L, I: Integer;
begin
  SA := Split(text, '.');
  L := LengthInt - Length(SA[0]);

  text := SA[0];
  for I := 0 to L - 1 do
  begin
    text := '0' + text;
  end;

  text := text + '.';
  if Length(SA) = 2 then
  begin
    L := LengthFloat - Length(SA[1]);
    text := text + SA[1];
  end
  else
  begin
    L := LengthFloat;
  end;

  for I := 0 to L - 1 do
  begin
    text := text + '0';
  end;
  Result := text;
end;

function toArr(const Source: string): StringArray; //�ַ�����Ϊһ������
var
  rArray: StringArray;
  I: Integer;
begin
  for I := 1 to Length(Source) do
  begin
    SetLength(rArray, Length(rArray) + 1);
    rArray[Length(rArray) - 1] := Copy(Source, I, 1);
  end;
  Result := rArray;
end;
function toStringList(const Source: string): TStrings; //�ַ�����Ϊһ������
var
  a:TStrings;
  I:Integer;
begin
  a:=TStringList.Create;
  for I := 1 to Length(Source) do
  begin
     a.Add(Copy(Source, I, 1))
  end;
  Result := a;
end;
function GetIPAddr: string; //��ȡip��ַ
type
  TaPInAddr = array[0..10] of PInAddr;
  PaPInAddr = ^TaPInAddr;
var
  phe: PHostEnt;
  pptr: PaPInAddr;
  Buffer: array[0..63] of char;
  I: Integer;
  GInitData: TWSADATA;
begin
  WSAStartup($101, GInitData);
  Result := '';
  GetHostName(Buffer, SizeOf(Buffer));
  phe := GetHostByName(buffer);
  if phe = nil then Exit;
  pptr := PaPInAddr(Phe^.h_addr_list);
  I := 0;
  while pptr^[I] <> nil do begin
    result := StrPas(inet_ntoa(pptr^[I]^));
    Inc(I);
  end;
  WSACleanup;
end;

function RandomStr(): string;
var
  PicName: string;
  I: Integer;
begin
  Randomize;
  for I := 1 to 4 do
    PicName := PicName + chr(97 + random(26));
  RandomStr := PicName;
end;

function BooleanToStr(va: boolean): string;
begin
  if va then Result := 'true'
  else Result := 'false';
end;

function getServiceFromSpring(basePath,className:string;springs:TStrings):string;//��xml�ж�ȡspring�����ļ��е�service
var
  temp:string;
  I,K:Integer;
  XMLDocument: IXMLDocument;
  rootnode, bean: IXMLNode;
begin
  temp := 'applicationcontext-'+ LowerCase(className)+'.xml';
  for I := 0 to springs.Count - 1 do
  begin
    if LowerCase(springs[I]) = temp  then
    begin
        XMLDocument := TXMLDocument.Create(nil);
        XMLDocument.LoadFromFile(basePath+springs[I]);
        rootnode := XMLDocument.DocumentElement;
        for K := 0 to rootnode.ChildNodes.Count - 1 do
        begin
            bean := rootnode.ChildNodes[K];
            if bean.Attributes['parent'] = 'baseTxService' then
            begin
                Result := bean.Attributes['id'];
                XMLDocument := nil;
                Exit;
            end;
        end;
    end;
  end;
end;
function getPacFromHbm(fileName:string):string;
var
  temp:string;
  I,K:Integer;
  XMLDocument: IXMLDocument;
  rootnode, bean: IXMLNode;
begin
  XMLDocument := TXMLDocument.Create(nil);
  XMLDocument.LoadFromFile(fileName);
  rootnode := XMLDocument.DocumentElement;
  Result :=rootnode.ChildNodes[0].Attributes['name'];
  XMLDocument := nil;
end;

function enLargeCode(text:String;key:string):string;
var
  keys : array of byte;
  i,j,k:integer;
begin
  for i := 1 to Length(key) do
  begin
      SetLength(keys,i);
      keys[i-1] := byte(key[i]);
  end;
  Result := '';
  j := 0;
  k := Length(keys);
  for i := 1 to Length(text) do
  begin
    Result := Result + IntToHex(Byte(text[i]) xor keys[j], 2);
    j := (j + 1) mod k;
  end;
end;
function deLargeCode(text:String;key:string):string;
var
  keys : array of byte;
  i,j,k:integer;
begin
  for i := 1 to Length(key) do
  begin
      SetLength(keys,i);
      keys[i-1] := byte(key[i]);
  end;
  Result := '';
  j := 0;
  k := Length(keys);
  for i := 1 to Length(text) div 2 do
  begin
    Result := Result + Char(StrToInt('$' + Copy(text, i * 2 - 1, 2)) xor keys[j]);
    j := (j + 1) mod k;
  end;
end;


end.

