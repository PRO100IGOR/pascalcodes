unit ModelLib;

interface
uses
  Classes;
type
    TService = class(TObject)
        sercieName:string;
        key:string;
        value:string;
        treeKey:string;//����ID
    end;
    TServiceAdvance = class(TPersistent)
    private
      function GetItems(Key: string): TService;
      function GetCount: Integer;
    public
      Keys: TStrings;
      Values: array of TService;
      property Items[Key: string]: TService read GetItems; default;  //��ȡ�䵥һԪ��
      property Count: Integer read GetCount;  //��ȡ����
      function Add(Key: string; Value: TService): Integer;  //���Ԫ��
      procedure clear;
      function Remove(Key: string): Integer;  //�Ƴ�
      constructor Create; overload;
    end;
    TStringArr = class(TPersistent)
    private
      function GetItems(Key: string): string;
      function GetCount: Integer;
    public
      Keys: TStrings;
      Values: array of string;
      property Items[Key: string]: string read GetItems; default;  //��ȡ�䵥һԪ��
      property Count: Integer read GetCount;  //��ȡ����
      function Add(Key: string; Value: string): Integer;  //���Ԫ��
      procedure clear;
      function Remove(Key: string): Integer;  //�Ƴ�
      constructor Create; overload;
    end;
    TStringArrAdvance = class(TPersistent)
    private
      function GetItems(Key: string): TStringArr;
      function GetCount: Integer;
    public
      Keys: TStrings;
      Values: array of TStringArr;
      property Items[Key: string]: TStringArr read GetItems; default;  //��ȡ�䵥һԪ��
      property Count: Integer read GetCount;  //��ȡ����
      function Add(Key: string; Value: TStringArr): Integer;  //���Ԫ��
      procedure clear;
      function Remove(Key: string): Integer;  //�Ƴ�
      constructor Create; overload;
    end;
    TCheckRule = class(TObject)
      rules:TStringArr;
      needs:TStrings;
      events:TStrings;
      needCheck:Boolean;
      procedure clear;
      constructor Create; overload;
    end;
    //����
    TPrototype = class(TObject)
    public
       dataType:string;//�������� ������manytoone��onetomany����ͨ����
       dataData:string;//��������
       dataName:string; //�ֶ�����
       dataLength:Integer;//���ݳ���
       comment:string;//��������
       ClassName:string;//�����������ԣ���ô��Ӧ�ĸ�ʵ���ࣿ
       autoInsert:Boolean; //����ʱ���Ƿ��Զ����뻹���ֶ�����
       enable:Boolean; //�Ƿ����������
       constructor Create; overload;
    end;
    //���Լ���
    TPrototypes = class(TPersistent)
    private
      function GetItems(Key: string): TPrototype;
      function GetCount: Integer;
    public
      Keys: TStrings;
      Values: array of TPrototype;
      procedure clear;
      property Items[Key: string]: TPrototype read GetItems; default;  //��ȡ�䵥һԪ��
      property Count: Integer read GetCount;  //��ȡ����
      function Add(Key: string; Value: TPrototype): Integer;  //���Ԫ��
      function Remove(Key: string): Integer;  //�Ƴ�
      constructor Create; overload;
    end;
    TPrototypeUse = class(TObject)
    public
        dataName:string; //�ֶ�����
        comment:string;//��������
        Prototype:TPrototype; //��������
        StringArr:TStringArr; //��̬ȡ������
        service:TService;  //��̬ȡ������
        diccode:string;//�����ֵ�
        dataGetType:Integer;//ȡ������ 3=�ޣ�0=��̬ 1=��̬ 2=�����ֵ�;
        showType:string; //��ʾ��ʽ
        timerCoder:string;//ʱ��ؼ���ʾ��ʽ
        no:Integer;
        constructor Create; overload;
    end;

    //�б�
    TListType = class(TPrototypeUse)
    public
        order:Boolean;
        DataLength:Integer;
    end;
    //�б�s
    TListTypes = class(TPersistent)
    private
      function GetItems(Key: string): TListType;
      function GetCount: Integer;
    public
      Keys: TStrings;
      Values: array of TListType;
      procedure clear;
      property Items[Key: string]: TListType read GetItems; default;  //��ȡ�䵥һԪ��
      property Count: Integer read GetCount;  //��ȡ����
      function Add(Key: string; Value: TListType): Integer;  //���Ԫ��
      function Remove(Key: string): Integer;  //�Ƴ�
      constructor Create; overload;
    end;
    //��ѯ����
    TConditionType = class(TPrototypeUse)
    public
       datanameex:string;//����
       eqs:string;//�Աȹ�ϵ
//       isAdv:Boolean; //�Ƿ��Ǹ߼���ѯ
    end;
    //��ѯ��������
    TConditionTypes = class(TPersistent)
    private
      function GetItems(Key: string): TConditionType;
      function GetCount: Integer;
    public
      Keys: TStrings;
      Values: array of TConditionType;
      procedure clear;
      property Items[Key: string]: TConditionType read GetItems; default;  //��ȡ�䵥һԪ��
      property Count: Integer read GetCount;  //��ȡ����
      function Add(Key: string; Value: TConditionType): Integer;  //���Ԫ��
      function Remove(Key: string): Integer;  //�Ƴ�
      constructor Create; overload;
    end;
    //��
    TFormType = class(TPrototypeUse)
    public
      CheckRule:TCheckRule;
      constructor Create; overload;
    end;
    //������
    TFormTypes = class(TPersistent)
    private
      function GetItems(Key: string): TFormType;
      function GetCount: Integer;
    public
      Keys: TStrings;
      Values: array of TFormType;
      procedure clear;
      property Items[Key: string]: TFormType read GetItems; default;  //��ȡ�䵥һԪ��
      property Count: Integer read GetCount;  //��ȡ����
      function Add(Key: string; Value: TFormType): Integer;  //���Ԫ��
      function Remove(Key: string): Integer;  //�Ƴ�
      constructor Create; overload;
    end;
    //�鿴
    TViewType = class(TPrototypeUse)

    end;
    TViewTypes = class(TPersistent)
    private
      function GetItems(Key: string): TViewType;
      function GetCount: Integer;
    public
      Keys: TStrings;
      Values: array of TViewType;
      procedure clear;
      property Items[Key: string]: TViewType read GetItems; default;  //��ȡ�䵥һԪ��
      property Count: Integer read GetCount;  //��ȡ����
      function Add(Key: string; Value: TViewType): Integer;  //���Ԫ��
      function Remove(Key: string): Integer;  //�Ƴ�
      constructor Create; overload;
    end;
    //����
    TFj = class(TObject)
       itemid:string;
       fileType:string;
       qz,hz:string; //ǰ׺����׺
       showasimage:string;
       maxcount :Integer;
       path:string;
       comment:string;
    end;
    TFJS = array of TFj;
    //ģ��s
    TModel = class(TObject)
      className:string;
      serviceName:string;
      modelName:string;
      hibernatePath:string;
      springPath:string;
      pacName:string;//����
      prototypes:TPrototypes;//���Լ���
      constructor Create; overload;
    end;
    TModels = class(TPersistent)
    private
      function GetItems(Key: string): TModel;
      function GetCount: Integer;
    public
      Keys: TStrings;
      Values: array of TModel;
      procedure clear;
      property Items[Key: string]: TModel read GetItems; default;  //��ȡ�䵥һԪ��
      property Count: Integer read GetCount;  //��ȡ����
      function Add(Key: string; Value: TModel): Integer;  //���Ԫ��
      function Remove(Key: string): Integer;  //�Ƴ�
      constructor Create; overload;
    end;
    //����ģ��
    TModelCode = class(TComponent)
    public
        mobile:Boolean; //�����ƶ�ģ��
        mobilePath:string; //�ƶ�Ŀ¼·��
        mobileTitle:string; //�ƶ���Ŀ��Ŀ
        propath:string; //��ĿĿ¼
        modelPath:string; //ģ��Ŀ¼
        pacname:string; //����
        modelLargeName:string;//��д��ģ��
        className:string; //����
        modelName:string; //��Ŀ����
        hibernatePath:string; //hibernateĿ¼
        modelChname:string;//ģ��������
        hibernate:string; //hibernate��Ŀ¼
        author:string;
        company:string;
        changeHibernate:Boolean;
        dynamicUpdate:Boolean; //���ܲ���
        OneToMany:string;
        ManyToOne:string;
        prototypes:TPrototypes;//���Լ���
        ConditionTypes:TConditionTypes;//��ѯ��������
        ListTypes:TListTypes;  //�б�
//        advanceList:TConditionTypes;//�߼���ѯ�б�
        tionTypes: TConditionTypes;//���в�ѯ�б�
        FormTypes:TFormTypes;  //��
        parentIds:TStrings; //many-to-one id����
        proList:TStrings; //�ֶ����Ƽ���
        xmlList:TStrings;  //�Ѿ�������ȡ��hibernatexml�ļ�
        otherModels:TModels; //����ģ�鼯��
        springList:TStrings; //spring�ļ��ϼ�
        springPath:string;
        CheckRule:TCheckRule; //����֤
        viewList:TViewTypes;   //�鿴ҳ��
        Prototype:TPrototype;//����
        showAsTree:Boolean;//�Ƿ���ʾΪ��
        showExport:Boolean;// �Ƿ񵼳�
        treeNode:string;//���ڵ�id
        treeText:string;//���ڵ�
        services:TServiceAdvance; // ��̬ȡ������
        showcheckbox:Boolean;
        showNum:Boolean;
        Fjs:TFJS;
        constructor Create; overload;


        procedure clear;
    end;


implementation

constructor TCheckRule.Create;
begin
 rules:=TStringArr.Create;
 needs:=TStringList.Create;
 events:=TStringList.Create;
 needCheck := True;
end;
procedure TCheckRule.clear;
begin
   rules.clear;
   needs.clear;
   events.clear;
end;

constructor TFormType.Create;
begin
    CheckRule := TCheckRule.Create;
    inherited Create();
end;

constructor TModel.Create;
begin
    prototypes := TPrototypes.Create;
end;


procedure TModelCode.clear;
begin
  prototypes.clear;
  ConditionTypes.clear;
  ListTypes.clear;
  FormTypes.clear;
  parentIds.Clear;
  proList.Clear;
  xmlList.Clear;
  otherModels.Clear;
  springList.Clear;
  CheckRule.clear;
  viewList.clear;
  services.clear;
//  advanceList.clear;
  tionTypes.clear;
end;



constructor TPrototype.Create;
begin
   autoInsert := False;
   enable:=True;
end;
constructor TPrototypeUse.Create;
begin
   StringArr:=TStringArr.Create;
   service := Tservice.Create;
   dataGetType := 3;
end;
constructor TModelCode.Create;
begin
   prototypes:=Tprototypes.Create;
   ConditionTypes := TConditionTypes.Create;
   ListTypes:=TListTypes.Create;
   FormTypes:=TFormTypes.Create;
   proList := TStringList.Create;
   parentIds := TStringList.Create;
   xmlList :=TStringList.Create;
   otherModels:= TModels.Create;
   springList := TStringList.Create;
   CheckRule := TCheckRule.Create;
   viewList := TViewTypes.Create;
   services := TServiceAdvance.Create;
//   advanceList :=TConditionTypes.Create;
   tionTypes := TConditionTypes.Create;
end;
constructor TStringArr.Create;
begin
  Keys := TStringList.Create;
  SetLength(Values, 0);
end;
procedure TStringArr.clear;
begin
  SetLength(Values, 0);
  Keys.Clear;
end;
function TStringArr.GetItems(Key: string): string;
var
  KeyIndex: Integer;
begin
  KeyIndex := Keys.IndexOf(Key);
  if KeyIndex <> -1 then
    Result := Values[KeyIndex]
  else
    Result := '';
end;
function TStringArr.Add(Key: string; Value: string): Integer;
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
function TStringArr.GetCount: Integer;
begin
  Result := Keys.Count;
end;
function TStringArr.Remove(Key: string): Integer;
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

constructor TPrototypes.Create;
begin
  Keys := TStringList.Create;
  SetLength(Values, 0);
end;
procedure TPrototypes.clear;
begin
  SetLength(Values, 0);
  Keys.Clear;
end;
function TPrototypes.GetItems(Key: string): TPrototype;
var
  KeyIndex: Integer;
begin
  KeyIndex := Keys.IndexOf(Key);
  if KeyIndex <> -1 then
    Result := Values[KeyIndex]
  else
    Result := nil;
end;
function TPrototypes.Add(Key: string; Value: TPrototype): Integer;
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
function TPrototypes.GetCount: Integer;
begin
  Result := Keys.Count;
end;
function TPrototypes.Remove(Key: string): Integer; //�Ƴ�
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

constructor TListTypes.Create;
begin
  Keys := TStringList.Create;
  SetLength(Values, 0);
end;
procedure TListTypes.clear;
begin
  SetLength(Values, 0);
  Keys.Clear;
end;
function TListTypes.GetItems(Key: string): TListType;
var
  KeyIndex: Integer;
begin
  KeyIndex := Keys.IndexOf(Key);
  if KeyIndex <> -1 then
    Result := Values[KeyIndex]
  else
    Result := nil;
end;
function TListTypes.Add(Key: string; Value: TListType): Integer;
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
function TListTypes.GetCount: Integer;
begin
  Result := Keys.Count;
end;
function TListTypes.Remove(Key: string): Integer;
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


constructor TConditionTypes.Create;
begin
  Keys := TStringList.Create;
  SetLength(Values, 0);
end;
procedure TConditionTypes.clear;
begin
  SetLength(Values, 0);
  Keys.Clear;
end;
function TConditionTypes.GetItems(Key: string): TConditionType;
var
  KeyIndex: Integer;
begin
  KeyIndex := Keys.IndexOf(Key);
  if KeyIndex <> -1 then
    Result := Values[KeyIndex]
  else
    Result := nil;
end;
function TConditionTypes.Add(Key: string; Value: TConditionType): Integer;
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
function TConditionTypes.GetCount: Integer;
begin
  Result := Keys.Count;
end;
function TConditionTypes.Remove(Key: string): Integer;
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


constructor TFormTypes.Create;
begin
  Keys := TStringList.Create;
  SetLength(Values, 0);
end;
procedure TFormTypes.clear;
begin
  SetLength(Values, 0);
  Keys.Clear;
end;
function TFormTypes.GetItems(Key: string): TFormType;
var
  KeyIndex: Integer;
begin
  KeyIndex := Keys.IndexOf(Key);
  if KeyIndex <> -1 then
    Result := Values[KeyIndex]
  else
    Result := nil;
end;
function TFormTypes.Add(Key: string; Value: TFormType): Integer;
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
function TFormTypes.GetCount: Integer;
begin
  Result := Keys.Count;
end;
function TFormTypes.Remove(Key: string): Integer;
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


constructor TModels.Create;
begin
  Keys := TStringList.Create;
  SetLength(Values, 0);
end;
procedure TModels.clear;
begin
  SetLength(Values, 0);
  Keys.Clear;
end;
function TModels.GetItems(Key: string): TModel;
var
  KeyIndex: Integer;
begin
  KeyIndex := Keys.IndexOf(Key);
  if KeyIndex <> -1 then
    Result := Values[KeyIndex]
  else
    Result := nil;
end;
function TModels.Add(Key: string; Value: TModel): Integer;
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
function TModels.GetCount: Integer;
begin
  Result := Keys.Count;
end;
function TModels.Remove(Key: string): Integer;
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


constructor TStringArrAdvance.Create;
begin
  Keys := TStringList.Create;
  SetLength(Values, 0);
end;
procedure TStringArrAdvance.clear;
begin
  SetLength(Values, 0);
  Keys.Clear;
end;
function TStringArrAdvance.GetItems(Key: string): TStringArr;
var
  KeyIndex: Integer;
begin
  KeyIndex := Keys.IndexOf(Key);
  if KeyIndex <> -1 then
    Result := Values[KeyIndex]
  else
    Result := nil;
end;
function TStringArrAdvance.Add(Key: string; Value: TStringArr): Integer;
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
function TStringArrAdvance.GetCount: Integer;
begin
  Result := Keys.Count;
end;
function TStringArrAdvance.Remove(Key: string): Integer;
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



constructor TViewTypes.Create;
begin
  Keys := TStringList.Create;
  SetLength(Values, 0);
end;
procedure TViewTypes.clear;
begin
  SetLength(Values, 0);
  Keys.Clear;
end;
function TViewTypes.GetItems(Key: string): TViewType;
var
  KeyIndex: Integer;
begin
  KeyIndex := Keys.IndexOf(Key);
  if KeyIndex <> -1 then
    Result := Values[KeyIndex]
  else
    Result := nil;
end;
function TViewTypes.Add(Key: string; Value: TViewType): Integer;
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
function TViewTypes.GetCount: Integer;
begin
  Result := Keys.Count;
end;
function TViewTypes.Remove(Key: string): Integer;
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


constructor TServiceAdvance.Create;
begin
  Keys := TStringList.Create;
  SetLength(Values, 0);
end;
procedure TServiceAdvance.clear;
begin
  SetLength(Values, 0);
  Keys.Clear;
end;
function TServiceAdvance.GetItems(Key: string): TService;
var
  KeyIndex: Integer;
begin
  KeyIndex := Keys.IndexOf(Key);
  if KeyIndex <> -1 then
    Result := Values[KeyIndex]
  else
    Result := nil;
end;
function TServiceAdvance.Add(Key: string; Value: TService): Integer;
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
function TServiceAdvance.GetCount: Integer;
begin
  Result := Keys.Count;
end;
function TServiceAdvance.Remove(Key: string): Integer;
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


end.
