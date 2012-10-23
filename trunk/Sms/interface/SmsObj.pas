unit SmsObj;

interface
uses
    Classes,Common;
type
    TSms = class(TObject)
    public
        Index  : string;
        Tel    : string;
        Text   : string;
        SmsType: string;
    end;
    TSmsList = class(TPersistent)
    private
      function GetItems(Key: string): TSms;
      function GetCount: Integer;
    public
      Keys: TStrings;
      Values: array of TSms;
      property Items[Key: string]: TSms read GetItems; default;  //获取其单一元素
      property Count: Integer read GetCount;  //获取个数
      function Add(Key: string; Value: TSms): Integer;  //添加元素
      procedure clear;
      function Remove(Key: string): Integer;  //移除
      constructor Create; overload;
    end;
    procedure getSmsListFromString(source:String;var SmsList :TSmsList);
implementation



    constructor TSmsList.Create;
    begin
      Keys := TStringList.Create;
      SetLength(Values, 0);
    end;
    procedure TSmsList.clear;
    begin
      SetLength(Values, 0);
      Keys.Clear;
    end;
    function TSmsList.GetItems(Key: string): TSms;
    var
      KeyIndex: Integer;
    begin
      KeyIndex := Keys.IndexOf(Key);
      if KeyIndex <> -1 then
        Result := Values[KeyIndex]
      else
        Result := nil;
    end;
    function TSmsList.Add(Key: string; Value: TSms): Integer;
    begin
      if Keys.IndexOf(Key) = -1 then
      begin
        Keys.Add(Key);
        SetLength(Values, Length(Values) + 1);
        Values[Length(Values) - 1] := Value;
      end
      else
        Values[Keys.IndexOf(Key)] := Value;
      Result := Length(Values) - 1;
    end;
    function TSmsList.GetCount: Integer;
    begin
      Result := Keys.Count;
    end;
    function TSmsList.Remove(Key: string): Integer;
    var
      Index, Count: Integer;
    begin
      Index := Keys.IndexOf(Key);
      Count := Length(Values);
      if Index <> -1 then
      begin
        Keys.Delete(Index);
        Move(Values[Index + 1], Values[Index], (Count - Index) * SizeOf(Values[0]));
        SetLength(Values, Count - 1);
      end;
      Result := Count - 1;
    end;



    procedure getSmsListFromString(source:String;var SmsList :TSmsList);
    var
       SmsStrings   :TStrings;
       SmsPrototypes:TStrings;
       Sms          :TSms;
       I            :Integer;
    begin
       SmsStrings := Common.SplitToStrings(source,'|');
       if not Assigned(SmsList) then
          SmsList := TSmsList.Create;
       for I := 0 to SmsStrings.Count - 1 do
       begin
           SmsPrototypes := Common.SplitToStrings(SmsStrings[I],'#');
           Sms           := TSms.Create;
           Sms.Index     := SmsPrototypes[0];
           Sms.SmsType   := SmsPrototypes[1];
           Sms.Tel       := SmsPrototypes[2];
           Sms.Text      := SmsPrototypes[3];
           SmsList.Add(Sms.Index,Sms);
       end;
    end;
end.
