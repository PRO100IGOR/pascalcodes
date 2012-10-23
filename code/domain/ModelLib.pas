unit ModelLib;

interface
uses
  Classes;
type
    TService = class(TObject)
        sercieName:string;
        key:string;
        value:string;
        treeKey:string;//父类ID
    end;
    TServiceAdvance = class(TPersistent)
    private
      function GetItems(Key: string): TService;
      function GetCount: Integer;
    public
      Keys: TStrings;
      Values: array of TService;
      property Items[Key: string]: TService read GetItems; default;  //获取其单一元素
      property Count: Integer read GetCount;  //获取个数
      function Add(Key: string; Value: TService): Integer;  //添加元素
      procedure clear;
      function Remove(Key: string): Integer;  //移除
      constructor Create; overload;
    end;
    TStringArr = class(TPersistent)
    private
      function GetItems(Key: string): string;
      function GetCount: Integer;
    public
      Keys: TStrings;
      Values: array of string;
      property Items[Key: string]: string read GetItems; default;  //获取其单一元素
      property Count: Integer read GetCount;  //获取个数
      function Add(Key: string; Value: string): Integer;  //添加元素
      procedure clear;
      function Remove(Key: string): Integer;  //移除
      constructor Create; overload;
    end;
    TStringArrAdvance = class(TPersistent)
    private
      function GetItems(Key: string): TStringArr;
      function GetCount: Integer;
    public
      Keys: TStrings;
      Values: array of TStringArr;
      property Items[Key: string]: TStringArr read GetItems; default;  //获取其单一元素
      property Count: Integer read GetCount;  //获取个数
      function Add(Key: string; Value: TStringArr): Integer;  //添加元素
      procedure clear;
      function Remove(Key: string): Integer;  //移除
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
    //属性
    TPrototype = class(TObject)
    public
       dataType:string;//数据类型 主键、manytoone、onetomany、普通属性
       dataData:string;//数据类型
       dataName:string; //字段名称
       dataLength:Integer;//数据长度
       comment:string;//中文描述
       ClassName:string;//如果是外键属性，那么对应哪个实体类？
       autoInsert:Boolean; //主键时，是否自动插入还是手动生成
       enable:Boolean; //是否不是外键属性
       constructor Create; overload;
    end;
    //属性集合
    TPrototypes = class(TPersistent)
    private
      function GetItems(Key: string): TPrototype;
      function GetCount: Integer;
    public
      Keys: TStrings;
      Values: array of TPrototype;
      procedure clear;
      property Items[Key: string]: TPrototype read GetItems; default;  //获取其单一元素
      property Count: Integer read GetCount;  //获取个数
      function Add(Key: string; Value: TPrototype): Integer;  //添加元素
      function Remove(Key: string): Integer;  //移除
      constructor Create; overload;
    end;
    TPrototypeUse = class(TObject)
    public
        dataName:string; //字段名称
        comment:string;//中文描述
        Prototype:TPrototype; //基本类型
        StringArr:TStringArr; //静态取数集合
        service:TService;  //动态取数对象
        diccode:string;//数据字典
        dataGetType:Integer;//取数类型 3=无，0=静态 1=动态 2=数据字典;
        showType:string; //显示方式
        timerCoder:string;//时间控件显示方式
        no:Integer;
        constructor Create; overload;
    end;

    //列表
    TListType = class(TPrototypeUse)
    public
        order:Boolean;
        DataLength:Integer;
    end;
    //列表s
    TListTypes = class(TPersistent)
    private
      function GetItems(Key: string): TListType;
      function GetCount: Integer;
    public
      Keys: TStrings;
      Values: array of TListType;
      procedure clear;
      property Items[Key: string]: TListType read GetItems; default;  //获取其单一元素
      property Count: Integer read GetCount;  //获取个数
      function Add(Key: string; Value: TListType): Integer;  //添加元素
      function Remove(Key: string): Integer;  //移除
      constructor Create; overload;
    end;
    //查询条件
    TConditionType = class(TPrototypeUse)
    public
       datanameex:string;//别名
       eqs:string;//对比关系
//       isAdv:Boolean; //是否是高级查询
    end;
    //查询条件集合
    TConditionTypes = class(TPersistent)
    private
      function GetItems(Key: string): TConditionType;
      function GetCount: Integer;
    public
      Keys: TStrings;
      Values: array of TConditionType;
      procedure clear;
      property Items[Key: string]: TConditionType read GetItems; default;  //获取其单一元素
      property Count: Integer read GetCount;  //获取个数
      function Add(Key: string; Value: TConditionType): Integer;  //添加元素
      function Remove(Key: string): Integer;  //移除
      constructor Create; overload;
    end;
    //表单
    TFormType = class(TPrototypeUse)
    public
      CheckRule:TCheckRule;
      constructor Create; overload;
    end;
    //表单集合
    TFormTypes = class(TPersistent)
    private
      function GetItems(Key: string): TFormType;
      function GetCount: Integer;
    public
      Keys: TStrings;
      Values: array of TFormType;
      procedure clear;
      property Items[Key: string]: TFormType read GetItems; default;  //获取其单一元素
      property Count: Integer read GetCount;  //获取个数
      function Add(Key: string; Value: TFormType): Integer;  //添加元素
      function Remove(Key: string): Integer;  //移除
      constructor Create; overload;
    end;
    //查看
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
      property Items[Key: string]: TViewType read GetItems; default;  //获取其单一元素
      property Count: Integer read GetCount;  //获取个数
      function Add(Key: string; Value: TViewType): Integer;  //添加元素
      function Remove(Key: string): Integer;  //移除
      constructor Create; overload;
    end;
    //附件
    TFj = class(TObject)
       itemid:string;
       fileType:string;
       qz,hz:string; //前缀、后缀
       showasimage:string;
       maxcount :Integer;
       path:string;
       comment:string;
    end;
    TFJS = array of TFj;
    //模块s
    TModel = class(TObject)
      className:string;
      serviceName:string;
      modelName:string;
      hibernatePath:string;
      springPath:string;
      pacName:string;//包名
      prototypes:TPrototypes;//属性集合
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
      property Items[Key: string]: TModel read GetItems; default;  //获取其单一元素
      property Count: Integer read GetCount;  //获取个数
      function Add(Key: string; Value: TModel): Integer;  //添加元素
      function Remove(Key: string): Integer;  //移除
      constructor Create; overload;
    end;
    //代码模块
    TModelCode = class(TComponent)
    public
        mobile:Boolean; //生成移动模块
        mobilePath:string; //移动目录路径
        mobileTitle:string; //移动项目题目
        propath:string; //项目目录
        modelPath:string; //模块目录
        pacname:string; //包名
        modelLargeName:string;//大写名模块
        className:string; //类名
        modelName:string; //项目名称
        hibernatePath:string; //hibernate目录
        modelChname:string;//模块中文名
        hibernate:string; //hibernate根目录
        author:string;
        company:string;
        changeHibernate:Boolean;
        dynamicUpdate:Boolean; //智能插入
        OneToMany:string;
        ManyToOne:string;
        prototypes:TPrototypes;//属性集合
        ConditionTypes:TConditionTypes;//查询条件集合
        ListTypes:TListTypes;  //列表
//        advanceList:TConditionTypes;//高级查询列表
        tionTypes: TConditionTypes;//所有查询列表
        FormTypes:TFormTypes;  //表单
        parentIds:TStrings; //many-to-one id集合
        proList:TStrings; //字段名称集合
        xmlList:TStrings;  //已经级联读取的hibernatexml文件
        otherModels:TModels; //其他模块集合
        springList:TStrings; //spring文件合集
        springPath:string;
        CheckRule:TCheckRule; //表单验证
        viewList:TViewTypes;   //查看页面
        Prototype:TPrototype;//主键
        showAsTree:Boolean;//是否显示为树
        showExport:Boolean;// 是否导出
        treeNode:string;//树节点id
        treeText:string;//树节点
        services:TServiceAdvance; // 动态取数集合
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
function TPrototypes.Remove(Key: string): Integer; //移除
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
