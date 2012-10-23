unit CodeMakerLib;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, BusinessSkinForm, bsSkinCtrls, bsSkinBoxCtrls, StdCtrls,
  bsSkinExCtrls,Common,XMLIntf, XMLDoc,ErrorLogsUnit,Clipbrd, bsMessages,
  ExtCtrls;

type
  TCodeMaker = class(TForm)
    bsBusinessSkinForm: TbsBusinessSkinForm;
    bsSkinExPanel1: TbsSkinExPanel;
    fileList: TbsSkinCheckListBox;
    bsSkinExPanel2: TbsSkinExPanel;
    logMemo: TbsSkinMemo;
    bsSkinScrollBar18: TbsSkinScrollBar;
    bsSkinPanel1: TbsSkinPanel;
    goBtn: TbsSkinButton;
    bsSkinButton1: TbsSkinButton;
    bsSkinButton2: TbsSkinButton;
    TemBan: TRadioGroup;
    procedure FormShow(Sender: TObject);
    procedure goBtnClick(Sender: TObject);
    procedure bsSkinButton1Click(Sender: TObject);
    procedure bsSkinButton2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure createFile();
    procedure PresaveFile(fileName:string);
    procedure changeWebXml(modelName,fileName:String);//修改webxml
    procedure copyFileDo(old,new:string);
  end;

var
  CodeMaker: TCodeMaker;
  index:Integer;
  isFG:Boolean;
  paths:TStrings;
implementation
uses
   main,WebLib,WebService;
{$R *.dfm}

procedure TCodeMaker.PresaveFile(fileName:string);
var
  dir:string;
begin
  dir := Copy(fileName,1,LastDelimiter('\',fileName)-1);
  if not DirectoryExists(dir) then
  begin
      ForceDirectories(PChar(dir));
  end;
end;
procedure TCodeMaker.bsSkinButton2Click(Sender: TObject);
var
  I:Integer;
begin
  for I := 0 to fileList.Items.Count - 1 do
  begin
     fileList.Checked[I] := bsSkinButton2.Tag = 1;
  end;
  if bsSkinButton2.Tag = 1 then bsSkinButton2.Tag := 0
  else bsSkinButton2.Tag := 1;
  
end;

procedure TCodeMaker.changeWebXml(modelName,fileName:String);//修改webxml
var
  F: TextFile;
  Str: string;
  I: integer;
  TypeStrings,temp: TStrings;
  booleana,bb,cc:Boolean;
begin

  TypeStrings := TStringList.Create;
  if FileExists(FileName) then
  begin
    AssignFile(F, FileName);
    Reset(F);
    booleana := False;

    while not Eof(F) do
    begin
      Readln(F, Str);
      if Pos('/WEB-INF/struts-config.xml',Str) > 0 then
      begin
         booleana := True;
      end;

      if Pos('</param-value>',Str) > 0 then
      begin
         booleana := False;
      end;

      if booleana  then
      begin
          TypeStrings.Add(Trim(Str));
      end;

    end;
    Closefile(F);
  end;

   if TypeStrings.IndexOf(modelName) = -1 then
   begin
       TypeStrings[TypeStrings.Count -1] := TypeStrings[TypeStrings.Count -1]+',';  
       TypeStrings.Add(modelName);
   end;

  temp := TStringList.Create;
  if FileExists(FileName) then
  begin
    AssignFile(F, FileName);
    Reset(F);
    booleana := False;
    cc := True;
    while not Eof(F) do
    begin
      Readln(F, Str);

      if Pos('/WEB-INF/struts-config.xml',Str) > 0 then
      begin
         booleana := True;
      end;

      if Pos('</param-value>',Str) > 0 then
      begin
         booleana := False;
      end;

      if booleana  and cc then
      begin
          temp.AddStrings(TypeStrings);
          cc := False;
      end
      else if not booleana  then
      begin
         temp.Add(Str);
      end;
    end;
    Closefile(F);
    temp.SaveToFile(FileName);
  end;

end;

procedure TCodeMaker.createFile();
var
  temp:string;
  I,K,tempIndex:Integer;
  tempBoolean,tip,dateTime,dic,tempBoolean2,fck,lhg,warn:Boolean;
begin
    try
    case index of
        0:begin
            //deleteaction
            temp:='{';
            temp:=temp + '"pacname":"'+main.MainForm.NewModelForm.ModelCode.pacname+'",';
            temp:=temp + '"modelChname":"'+main.MainForm.NewModelForm.ModelCode.modelChname+'",';
            temp:=temp + '"modelName":"'+main.MainForm.NewModelForm.ModelCode.modelName+'",';
            temp:=temp + '"company":"'+main.MainForm.NewModelForm.ModelCode.company+'",';
            temp:=temp + '"author":"'+main.MainForm.NewModelForm.ModelCode.author+'",';

            temp:=temp + '"fjs":[';
            tempBoolean := False;
            for I := 0 to Length(main.MainForm.NewModelForm.ModelCode.Fjs) - 1 do
            begin
                  tempBoolean := True;
                  temp:=temp + '{';
                  temp:=temp + '"qz":"'+main.MainForm.NewModelForm.ModelCode.Fjs[I].qz+'",';
                  temp:=temp + '"hz":"'+main.MainForm.NewModelForm.ModelCode.Fjs[I].hz+'"';
                  temp:=temp + '},';
            end;
            if tempBoolean then
            begin
                temp:= Copy(temp,1,Length(temp)-1) + '],';
                temp:=temp + '"prototype":"'+main.MainForm.NewModelForm.ModelCode.Prototype.dataName+'",';
                temp:=temp + '"hasfj":true,';
            end
            else
            begin
                temp:=temp + '],';
            end;

            temp:=temp + '"date":"'+Formatdatetime('yyyy-MM-dd', Now)+'"';
            temp:=temp + '}';
        end;
        1:begin
            //saveaction
            tempBoolean := False;
            temp:='{';
            temp:=temp + '"pacname":"'+main.MainForm.NewModelForm.ModelCode.pacname+'",';
            temp:=temp + '"modelChname":"'+main.MainForm.NewModelForm.ModelCode.modelChname+'",';
            temp:=temp + '"modelName":"'+main.MainForm.NewModelForm.ModelCode.modelName+'",';
            temp:=temp + '"company":"'+main.MainForm.NewModelForm.ModelCode.company+'",';
            temp:=temp + '"author":"'+main.MainForm.NewModelForm.ModelCode.author+'",';
            temp:=temp + '"date":"'+Formatdatetime('yyyy-MM-dd', Now)+'",';
            temp:=temp + '"mobile":'+booleantostr(main.MainForm.NewModelForm.ModelCode.mobile)+',';
            temp:=temp + '"prototype":"'+main.MainForm.NewModelForm.ModelCode.Prototype.dataName+'",';
            temp:=temp + '"FormTypes":[';
            for I := 0 to main.MainForm.NewModelForm.ModelCode.FormTypes.Count - 1 do
            begin
                if main.MainForm.NewModelForm.ModelCode.FormTypes.Values[I].Prototype.enable then
                begin
                    tempBoolean := True;
                    temp:=temp + '{';
                    if main.MainForm.NewModelForm.ModelCode.FormTypes.Values[I].Prototype.dataData <> 'java.lang.String' then
                    begin
                       temp := temp + '"type":"new '+Copy(main.MainForm.NewModelForm.ModelCode.FormTypes.Values[I].Prototype.dataData,LastDelimiter('.',main.MainForm.NewModelForm.ModelCode.FormTypes.Values[I].Prototype.dataData)+1)+'",';
                    end
                    else
                    begin
                      temp := temp + '"nottype":true,';
                    end;
                    
                    temp:=temp + '"name":"'+main.MainForm.NewModelForm.ModelCode.FormTypes.Values[I].dataName+'"},';
                end;
            end;
            if tempBoolean then
            begin
               temp:=Copy(temp,1,Length(temp)-1) + '],';
            end
            else
            begin
               temp:=temp + '],';
            end;

            tempBoolean := False;
            temp:=temp + '"LinkTypes":[';
            for I := 0 to main.MainForm.NewModelForm.ModelCode.FormTypes.Count - 1 do
            begin
                if not main.MainForm.NewModelForm.ModelCode.FormTypes.Values[I].Prototype.enable then
                begin
                    tempBoolean := True;
                    temp := temp + '{';
                    temp := temp + '"className":"'+main.MainForm.NewModelForm.ModelCode.FormTypes.Values[I].Prototype.ClassName+'",';
                    temp := temp + '"pacName":"'+main.MainForm.NewModelForm.ModelCode.otherModels[main.MainForm.NewModelForm.ModelCode.FormTypes.Values[I].Prototype.ClassName].pacName+'",';
                    temp := temp + '"name":"'+ main.MainForm.NewModelForm.ModelCode.FormTypes.Values[I].dataName + '"},';
                end;
            end;
            if tempBoolean then
            begin
               temp:=Copy(temp,1,Length(temp)-1) + ']';
            end
            else
            begin
               temp:=temp + ']';
            end;
            temp:=temp + '}';
        end;
        2:begin
          //showaction
            tempBoolean := False;
            temp:='{';
            temp:=temp + '"pacname":"'+main.MainForm.NewModelForm.ModelCode.pacname+'",';
            temp:=temp + '"modelChname":"'+main.MainForm.NewModelForm.ModelCode.modelChname+'",';
            temp:=temp + '"modelName":"'+main.MainForm.NewModelForm.ModelCode.modelName+'",';
            temp:=temp + '"company":"'+main.MainForm.NewModelForm.ModelCode.company+'",';
            temp:=temp + '"author":"'+main.MainForm.NewModelForm.ModelCode.author+'",';
            temp:=temp + '"date":"'+Formatdatetime('yyyy-MM-dd', Now)+'",';
            temp:=temp + '"showAsTree":"'+common.BooleanToStr(main.MainForm.NewModelForm.ModelCode.showAsTree)+'",';
            temp:=temp + '"showList":"'+common.BooleanToStr(not main.MainForm.NewModelForm.ModelCode.showAsTree)+'",';
            temp:=temp + '"prototype":"'+main.MainForm.NewModelForm.ModelCode.Prototype.dataName+'",';
            temp:=temp + '"mobile":'+booleantostr(main.MainForm.NewModelForm.ModelCode.mobile)+',';
		        temp:=temp + '"mobileId":"'+main.MainForm.NewModelForm.ModelCode.Prototype.dataName+'",';
		        temp:=temp + '"mobileTitle":"'+main.MainForm.NewModelForm.ModelCode.mobileTitle+'",';
            temp:=temp + '"FormTypes":[';
            for I := 0 to main.MainForm.NewModelForm.ModelCode.FormTypes.Count - 1 do
            begin
                if main.MainForm.NewModelForm.ModelCode.FormTypes.Values[I].Prototype.enable then
                begin
                    tempBoolean := True;
                    temp:=temp + '{"name":"'+main.MainForm.NewModelForm.ModelCode.FormTypes.Values[I].dataName+'"},';
                end;
            end;
            if tempBoolean then
            begin
               temp:=Copy(temp,1,Length(temp)-1) + '],';
            end
            else
            begin
               temp:=temp + '],';
            end;

            tempBoolean := False;
            temp:=temp + '"LinkTypes":[';
            for I := 0 to main.MainForm.NewModelForm.ModelCode.FormTypes.Count - 1 do
            begin
                if not main.MainForm.NewModelForm.ModelCode.FormTypes.Values[I].Prototype.enable then
                begin
                    tempBoolean := True;
                    temp := temp + '{';
                    temp := temp + '"className":"'+main.MainForm.NewModelForm.ModelCode.FormTypes.Values[I].Prototype.ClassName+'",';
                    temp := temp + '"pacName":"'+main.MainForm.NewModelForm.ModelCode.otherModels[main.MainForm.NewModelForm.ModelCode.FormTypes.Values[I].Prototype.ClassName].pacName+'",';
                    temp := temp + '"name":"'+ main.MainForm.NewModelForm.ModelCode.FormTypes.Values[I].dataName + '"},';
                end;
            end;
            if tempBoolean then
            begin
               temp:=Copy(temp,1,Length(temp)-1) + '],';
            end
            else
            begin
               temp:=temp + '],';
            end;

            tempBoolean := False;
            temp:=temp + '"ConditionTypes":[';
            for I := 0 to main.MainForm.NewModelForm.ModelCode.tionTypes.Count - 1 do
            begin
                tempBoolean := True;
                temp := temp + '{';
                temp := temp + '"dataname":"'+main.MainForm.NewModelForm.ModelCode.tionTypes.Values[I].dataName+'",';
                temp := temp + '"eq":"'+main.MainForm.NewModelForm.ModelCode.tionTypes.Values[I].eqs+'",';
                temp := temp + '"name":"'+ main.MainForm.NewModelForm.ModelCode.tionTypes.Values[I].datanameex + '"},';
            end;
            if tempBoolean then
            begin
               temp:=Copy(temp,1,Length(temp)-1) + '],';
               temp:=temp + '"condition":true';
            end
            else
            begin
               temp:=temp + '],';
               temp:=temp + '"condition":false';
            end;
            temp:=temp + '}';
        end;
        3:begin
           //dao
           temp:='{';
           temp:=temp + '"pacname":"'+main.MainForm.NewModelForm.ModelCode.pacname+'",';
           temp:=temp + '"modelChname":"'+main.MainForm.NewModelForm.ModelCode.modelChname+'",';
           temp:=temp + '"modelName":"'+main.MainForm.NewModelForm.ModelCode.modelName+'",';
           temp:=temp + '"company":"'+main.MainForm.NewModelForm.ModelCode.company+'",';
           temp:=temp + '"author":"'+main.MainForm.NewModelForm.ModelCode.author+'",';
           temp:=temp + '"date":"'+Formatdatetime('yyyy-MM-dd', Now)+'"';
           temp:=temp + '}';
        end;
        4:begin
           //daoimpl
           temp:='{';
           temp:=temp + '"pacname":"'+main.MainForm.NewModelForm.ModelCode.pacname+'",';
           temp:=temp + '"modelChname":"'+main.MainForm.NewModelForm.ModelCode.modelChname+'",';
           temp:=temp + '"modelName":"'+main.MainForm.NewModelForm.ModelCode.modelName+'",';
           temp:=temp + '"company":"'+main.MainForm.NewModelForm.ModelCode.company+'",';
           temp:=temp + '"author":"'+main.MainForm.NewModelForm.ModelCode.author+'",';
           temp:=temp + '"date":"'+Formatdatetime('yyyy-MM-dd', Now)+'"';
           temp:=temp + '}';
        end;
        5:begin
           //service
           temp:='{';
           temp:=temp + '"pacname":"'+main.MainForm.NewModelForm.ModelCode.pacname+'",';
           temp:=temp + '"modelChname":"'+main.MainForm.NewModelForm.ModelCode.modelChname+'",';
           temp:=temp + '"modelName":"'+main.MainForm.NewModelForm.ModelCode.modelName+'",';
           temp:=temp + '"company":"'+main.MainForm.NewModelForm.ModelCode.company+'",';
           temp:=temp + '"author":"'+main.MainForm.NewModelForm.ModelCode.author+'",';
           temp:=temp + '"date":"'+Formatdatetime('yyyy-MM-dd', Now)+'"';
           temp:=temp + '}';
        end;
        6:begin
           //serviceimpl
           temp:='{';
           temp:=temp + '"pacname":"'+main.MainForm.NewModelForm.ModelCode.pacname+'",';
           temp:=temp + '"modelChname":"'+main.MainForm.NewModelForm.ModelCode.modelChname+'",';
           temp:=temp + '"modelName":"'+main.MainForm.NewModelForm.ModelCode.modelName+'",';
           temp:=temp + '"company":"'+main.MainForm.NewModelForm.ModelCode.company+'",';
           temp:=temp + '"author":"'+main.MainForm.NewModelForm.ModelCode.author+'",';
           temp:=temp + '"date":"'+Formatdatetime('yyyy-MM-dd', Now)+'"';
           temp:=temp + '}';
        end;
        7:begin
           //conditionform
           temp:='{';
           temp:=temp + '"pacname":"'+main.MainForm.NewModelForm.ModelCode.pacname+'",';
           temp:=temp + '"modelChname":"'+main.MainForm.NewModelForm.ModelCode.modelChname+'",';
           temp:=temp + '"modelName":"'+main.MainForm.NewModelForm.ModelCode.modelName+'",';
           temp:=temp + '"company":"'+main.MainForm.NewModelForm.ModelCode.company+'",';
           temp:=temp + '"author":"'+main.MainForm.NewModelForm.ModelCode.author+'",';
           temp:=temp + '"date":"'+Formatdatetime('yyyy-MM-dd', Now)+'",';

           tempBoolean := False;
           temp:=temp + '"ConditionTypes":[';
           for I := 0 to main.MainForm.NewModelForm.ModelCode.tionTypes.Count - 1 do
           begin
                tempBoolean := True;
                temp := temp + '{';
                temp := temp + '"name":"'+ main.MainForm.NewModelForm.ModelCode.tionTypes.Values[I].datanameex + '"},';
           end;
           if tempBoolean then
           begin
               temp:=Copy(temp,1,Length(temp)-1) + ']';
           end
           else
           begin
               temp:=temp + ']';
           end;

           temp:=temp + '}';
        end;
        8:begin
           //form
           temp:='{';
           temp:=temp + '"pacname":"'+main.MainForm.NewModelForm.ModelCode.pacname+'",';
           temp:=temp + '"modelChname":"'+main.MainForm.NewModelForm.ModelCode.modelChname+'",';
           temp:=temp + '"modelName":"'+main.MainForm.NewModelForm.ModelCode.modelName+'",';
           temp:=temp + '"company":"'+main.MainForm.NewModelForm.ModelCode.company+'",';
           temp:=temp + '"author":"'+main.MainForm.NewModelForm.ModelCode.author+'",';
           temp:=temp + '"date":"'+Formatdatetime('yyyy-MM-dd', Now)+'",';

           tempBoolean := False;
           temp:=temp + '"FormTypes":[';
           for I := 0 to main.MainForm.NewModelForm.ModelCode.FormTypes.Count - 1 do
           begin
                tempBoolean := True;
                temp:=temp + '{"name":"'+main.MainForm.NewModelForm.ModelCode.FormTypes.Values[I].dataName+'"},';
           end;
           if tempBoolean then
           begin
               temp:= Copy(temp,1,Length(temp)-1) + ']';
           end
           else
           begin
               temp:=temp + ']';
           end;

           temp:=temp + '}';
        end;
        9:begin
           //spring
           temp:='{';
           temp:=temp + '"pacname":"'+main.MainForm.NewModelForm.ModelCode.pacname+'",';
           temp:=temp + '"modelName":"'+main.MainForm.NewModelForm.ModelCode.modelName+'"';
           temp:=temp + '}';
        end;
        10:begin
        //struts
           temp:='{';
           temp:=temp + '"pacname":"'+main.MainForm.NewModelForm.ModelCode.pacname+'",';
           temp:=temp + '"modelName":"'+main.MainForm.NewModelForm.ModelCode.modelName+'",';
           temp:=temp + '"condition":' + BooleanToStr(main.MainForm.NewModelForm.ModelCode.tionTypes.Count > 0);
           temp:=temp + '}';
        end;
        11:begin
          //form
           tip := False;
           dateTime := False;
           dic := False;
           fck := False;
           lhg := False;
           warn := False;
           temp:='{';
           temp:=temp + '"modelChname":"'+main.MainForm.NewModelForm.ModelCode.modelChname+'",';
           temp:=temp + '"modelName":"'+main.MainForm.NewModelForm.ModelCode.modelName+'",';
           temp:=temp + '"company":"'+main.MainForm.NewModelForm.ModelCode.company+'",';
           temp:=temp + '"author":"'+main.MainForm.NewModelForm.ModelCode.author+'",';
           temp:=temp + '"date":"'+Formatdatetime('yyyy-MM-dd', Now)+'",';



           temp:=temp + '"formRules":[';

           for I := 0 to main.MainForm.NewModelForm.ModelCode.FormTypes.Count - 1 do
           begin
               tempBoolean := False;
               if main.MainForm.NewModelForm.ModelCode.FormTypes.Values[I].CheckRule.needCheck and (main.MainForm.NewModelForm.ModelCode.FormTypes.Values[I].CheckRule.needs.Count > 0) then
               begin
                   temp:=temp + '{';
                   temp:=temp + '"ruleName":"'+main.MainForm.NewModelForm.ModelCode.FormTypes.Keys[I]+'",';
                   temp:=temp + '"rules":[';
                   for K := 0 to main.MainForm.NewModelForm.ModelCode.FormTypes.Values[I].CheckRule.rules.Count - 1 do
                   begin
                       if Trim(main.MainForm.NewModelForm.ModelCode.FormTypes.Values[I].CheckRule.rules.Values[K]) <> '' then
                       begin
                         temp:= temp + '{';
                         temp:= temp + '"key":"'+main.MainForm.NewModelForm.ModelCode.FormTypes.Values[I].CheckRule.rules.Keys[K]+'",';
                         temp:=temp  + '"value":"'+main.MainForm.NewModelForm.ModelCode.FormTypes.Values[I].CheckRule.rules.Values[K]+'"';
                         if Pos('tip',main.MainForm.NewModelForm.ModelCode.FormTypes.Values[I].CheckRule.rules.Values[K]) > 0 then
                            tip:=True;
                         if Pos('lhgAlert',main.MainForm.NewModelForm.ModelCode.FormTypes.Values[I].CheckRule.rules.Values[K]) > 0 then
                            lhg:=True;
                         temp:=temp + '},';
                         tempBoolean := True;
                       end;
                   end;
                   if tempBoolean then
                   begin
                       temp:= Copy(temp,1,Length(temp)-1) + '],';
                   end
                   else
                   begin
                       temp:=temp + '],';
                   end;
                   tempBoolean := False;
                   if main.MainForm.NewModelForm.ModelCode.FormTypes.Values[I].CheckRule.events.Count > 0 then
                   begin
                        temp  :=  temp + '"hasEvent":true,';
                        temp:=temp + '"events":"';
                        for K := 0 to main.MainForm.NewModelForm.ModelCode.FormTypes.Values[I].CheckRule.events.Count - 1 do
                        begin
                             if K = main.MainForm.NewModelForm.ModelCode.FormTypes.Values[I].CheckRule.events.Count - 1 then
                             begin
                                  temp := temp + main.MainForm.NewModelForm.ModelCode.FormTypes.Values[I].CheckRule.events[K]+'",';
                             end
                             else
                             begin
                                 temp := temp + main.MainForm.NewModelForm.ModelCode.FormTypes.Values[I].CheckRule.events[K]+',';
                             end;
                        end;
                   end
                   else
                   begin
                     temp  :=  temp + '"hasEvent":false,';
                   end;


                   temp:=temp + '"needs":[';
                   for K := 0 to main.MainForm.NewModelForm.ModelCode.FormTypes.Values[I].CheckRule.needs.Count - 1 do
                   begin
                       temp:= temp + '{';
                       temp:= temp + '"need":"'+main.MainForm.NewModelForm.ModelCode.FormTypes.Values[I].CheckRule.needs[K]+'",';
                       if Pos('isWarn',main.MainForm.NewModelForm.ModelCode.FormTypes.Values[I].CheckRule.needs[K]) > 0 then
                       begin
                          warn := True;
                          if ((Pos('lhgAlert',main.MainForm.NewModelForm.ModelCode.CheckRule.rules.Items['onCheck']) = 0))
                          and ((Pos('alert',main.MainForm.NewModelForm.ModelCode.CheckRule.rules.Items['onCheck']) = 0))
                          and ((Pos('ymPrompt',main.MainForm.NewModelForm.ModelCode.CheckRule.rules.Items['onCheck']) = 0))
                          then
                          begin
                              main.MainForm.NewModelForm.ModelCode.CheckRule.rules.Add('onCheck',main.MainForm.NewModelForm.ModelCode.CheckRule.rules.Items['onCheck'] + ',lhgAlert');
                          end;

                       end;
                       
                       if K = main.MainForm.NewModelForm.ModelCode.FormTypes.Values[I].CheckRule.needs.Count - 1 then
                       begin
                           temp:=temp + '"adh":""';
                           temp:=temp + '}';
                       end
                       else
                       begin
                           temp:=temp + '"adh":","';
                           temp:=temp + '},';
                       end;
                   end;
                   temp:=temp + '],';

                   tempBoolean := False;
                   for K := I + 1 to main.MainForm.NewModelForm.ModelCode.FormTypes.Count - 1 do
                   begin
                        if main.MainForm.NewModelForm.ModelCode.FormTypes.Values[K].CheckRule.needCheck and (main.MainForm.NewModelForm.ModelCode.FormTypes.Values[K].CheckRule.needs.Count > 0) then
                           tempBoolean := True;
                   end;


                   if not tempBoolean then
                   begin
                        temp := temp + '"dh":""';
                        temp:=temp + '}';
                   end
                   else
                   begin
                        temp := temp + '"dh":","';
                        temp:=temp + '},';
                   end;
               end;

           end;

           temp:=temp + '],';

           temp:=temp + '"rules":[';
           for I := 0 to main.MainForm.NewModelForm.ModelCode.CheckRule.rules.Count - 1 do
           begin
                if Trim(main.MainForm.NewModelForm.ModelCode.CheckRule.rules.Values[I]) <> '' then
                begin
                    temp:=temp + '{';
                    temp:=temp + '"key":"'+main.MainForm.NewModelForm.ModelCode.CheckRule.rules.Keys[I]+'",';
                    temp:=temp + '"value":"'+main.MainForm.NewModelForm.ModelCode.CheckRule.rules.Values[I]+'"';
                    if Pos('tip',main.MainForm.NewModelForm.ModelCode.CheckRule.rules.Values[I]) > 0 then
                        tip:=True;
                    if Pos('lhgAlert',main.MainForm.NewModelForm.ModelCode.CheckRule.rules.Values[I]) > 0 then
                        lhg:=True;
                    if I = main.MainForm.NewModelForm.ModelCode.CheckRule.rules.Count - 1 then
                    begin
                       temp:=temp + '}';
                    end
                    else
                    begin
                       temp:=temp + '},';
                    end;
                end;
           end;

           temp:=temp + '],';

           if main.MainForm.NewModelForm.ModelCode.CheckRule.events.Count > 0 then
           begin
                temp  :=  temp + '"hasEvent":true,';
                temp  :=  temp + '"events":"';
                for K := 0 to main.MainForm.NewModelForm.ModelCode.CheckRule.events.Count - 1 do
                begin
                     if K = main.MainForm.NewModelForm.ModelCode.CheckRule.events.Count - 1 then
                     begin
                          temp := temp + main.MainForm.NewModelForm.ModelCode.CheckRule.events[K]+'",';
                     end
                     else
                     begin
                         temp := temp + main.MainForm.NewModelForm.ModelCode.CheckRule.events[K]+',';
                     end;
                end;
           end
           else
           begin
               temp  :=  temp + '"hasEvent":false,';
           end;
           


           temp:=temp + '"FormTypes":[';
           for I := 0 to  main.MainForm.NewModelForm.ModelCode.FormTypes.Count - 1 do
           begin
               temp:=temp+'{';
               temp:=temp+'"'+main.MainForm.NewModelForm.ModelCode.FormTypes.Values[I].showType+'":true,';

               if main.MainForm.NewModelForm.ModelCode.FormTypes.Values[I].showType = '时间控件文本框' then
               begin
                 dateTime := True;
               end
               else  if main.MainForm.NewModelForm.ModelCode.FormTypes.Values[I].showType = '富文本框' then
               begin
                 fck:=True;
               end;
               
               temp:=temp+'"comment":"'+main.MainForm.NewModelForm.ModelCode.FormTypes.Values[I].comment+'",';
               temp:=temp+'"dataName":"'+main.MainForm.NewModelForm.ModelCode.FormTypes.Values[I].dataName+'",';
               temp:=temp+'"timerCoder":"'+main.MainForm.NewModelForm.ModelCode.FormTypes.Values[I].timerCoder+'",';
               if main.MainForm.NewModelForm.ModelCode.FormTypes.Values[I].dataGetType = 2 then
               begin
                 temp:=temp+'"diccode":"'+main.MainForm.NewModelForm.ModelCode.FormTypes.Values[I].diccode+'",';
                 if main.MainForm.NewModelForm.ModelCode.FormTypes.Values[I].diccode <> '' then
                    dic := True;
               end
               else if main.MainForm.NewModelForm.ModelCode.FormTypes.Values[I].dataGetType = 0 then
               begin
                 temp:=temp+'"StringArr":[';
                 for K := 0 to main.MainForm.NewModelForm.ModelCode.FormTypes.Values[I].StringArr.Count - 1 do
                 begin
                     temp:= temp + '{';
                     temp:= temp + '"key":"'+main.MainForm.NewModelForm.ModelCode.FormTypes.Values[I].StringArr.Keys[K]+'",';
                     temp:=temp  + '"value":"'+main.MainForm.NewModelForm.ModelCode.FormTypes.Values[I].StringArr.Values[K]+'"';
                     if K = main.MainForm.NewModelForm.ModelCode.FormTypes.Values[I].StringArr.Count - 1 then
                     begin
                         temp:=temp + '}';
                     end
                     else
                     begin
                         temp:=temp + '},';
                     end;
                 end;
                 temp:=temp+'],';
               end;
               tempBoolean := False;
               for K := 0 to main.MainForm.NewModelForm.ModelCode.FormTypes.Values[I].CheckRule.needs.Count - 1 do
               begin
                  if Pos('must',main.MainForm.NewModelForm.ModelCode.FormTypes.Values[I].CheckRule.needs[K]) > 0 then
                  begin
                      temp:=temp + '"must":true';
                      tempBoolean := True;
                      Break;
                  end;
               end;
               if not tempBoolean then
                   temp:=temp + '"must":false';
               if I = main.MainForm.NewModelForm.ModelCode.FormTypes.Count - 1 then
               begin
                   temp:=temp + '}';
               end
               else
               begin
                   temp:=temp + '},';
               end;
           end;
           temp:=temp + '],';

           temp:=temp + '"fjs":[';
           tempBoolean := False;
           for I := 0 to Length(main.MainForm.NewModelForm.ModelCode.Fjs) - 1 do
           begin
                tempBoolean := True;
                temp:=temp + '{';
                temp:=temp + '"name":"accfrm'+inttostr(I)+'",';
                temp:=temp + '"type":"'+main.MainForm.NewModelForm.ModelCode.Fjs[I].fileType+'",';
                temp:=temp + '"qz":"'+main.MainForm.NewModelForm.ModelCode.Fjs[I].qz+'",';
                temp:=temp + '"hz":"'+main.MainForm.NewModelForm.ModelCode.Fjs[I].hz+'",';
                temp:=temp + '"maxCount":"'+inttostr(main.MainForm.NewModelForm.ModelCode.Fjs[I].maxcount)+'",';
                temp:=temp + '"showAsImg":"'+main.MainForm.NewModelForm.ModelCode.Fjs[I].showasimage+'",';
                temp:=temp + '"height":"'+inttostr(main.MainForm.NewModelForm.ModelCode.Fjs[I].maxcount * 20 + 80)+'",';
                if main.MainForm.NewModelForm.ModelCode.Fjs[I].path <> '' then
                  temp:=temp + '"path":"/'+main.MainForm.NewModelForm.ModelCode.Fjs[I].path+'",'
                else
                begin
                  temp:=temp + '"notpath":true,'
                end;
                temp:=temp + '"comment":"'+main.MainForm.NewModelForm.ModelCode.Fjs[I].comment+'"';
                temp:=temp + '},';
           end;

           if tempBoolean then
           begin
                temp:= Copy(temp,1,Length(temp)-1) + '],';
                temp:=temp + '"hasfj":true,';
                lhg := True;
                temp:=temp + '"prototype":"'+main.MainForm.NewModelForm.ModelCode.Prototype.dataName+'",';
           end
           else
           begin
                temp:=temp + '],';
                temp:=temp + '"nothasfj":true,';     //没有附件
           end;
           temp:=temp + '"tip":'+booleanTostr(tip)+',';
           temp:=temp + '"datepack":'+booleanTostr(dateTime)+',';
           temp:=temp + '"dic":'+booleanTostr(dic)+',';
           temp:=temp + '"lhg":'+booleanTostr(lhg)+',';
           temp:=temp + '"warn":'+booleanTostr(warn)+',';
           temp:=temp + '"fck":'+booleanTostr(fck);
           temp:=temp + '}';
        end;
        12:begin
          //list
           dateTime := False;
           dic := False;
           temp:='{';
           temp:=temp + '"modelChname":"'+main.MainForm.NewModelForm.ModelCode.modelChname+'",';
           temp:=temp + '"modelName":"'+main.MainForm.NewModelForm.ModelCode.modelName+'",';
           temp:=temp + '"company":"'+main.MainForm.NewModelForm.ModelCode.company+'",';
           temp:=temp + '"author":"'+main.MainForm.NewModelForm.ModelCode.author+'",';
           temp:=temp + '"date":"'+Formatdatetime('yyyy-MM-dd', Now)+'",';
           temp:=temp + '"prototype":"'+main.MainForm.NewModelForm.ModelCode.Prototype.dataName+'",';
           temp:=temp + '"showExport":'+ BooleanToStr(main.MainForm.NewModelForm.ModelCode.showExport)+',';
           temp:=temp + '"ConditionTypes":[';
           tempBoolean := False;
           for I := 0 to main.MainForm.NewModelForm.ModelCode.ConditionTypes.Count - 1 do
           begin
               tempBoolean := True;
               temp:=temp + '{';
               temp:=temp+'"'+main.MainForm.NewModelForm.ModelCode.ConditionTypes.Values[I].showType+'":true,';
               if main.MainForm.NewModelForm.ModelCode.ConditionTypes.Values[I].showType = '时间控件文本框' then
               begin
                 dateTime := True;
               end;
               temp:=temp+'"comment":"'+main.MainForm.NewModelForm.ModelCode.ConditionTypes.Values[I].comment+'",';
               temp:=temp+'"dataName":"'+main.MainForm.NewModelForm.ModelCode.ConditionTypes.Values[I].datanameex+'",';
               if main.MainForm.NewModelForm.ModelCode.ConditionTypes.Values[I].dataGetType = 2 then
               begin
                 temp:=temp+'"diccode":"'+main.MainForm.NewModelForm.ModelCode.ConditionTypes.Values[I].diccode+'",';
                 if main.MainForm.NewModelForm.ModelCode.ConditionTypes.Values[I].diccode <> '' then
                    dic := True;
               end
               else if main.MainForm.NewModelForm.ModelCode.ConditionTypes.Values[I].dataGetType = 0 then
               begin
                 temp:=temp+'"StringArr":[';
                 for K := 0 to main.MainForm.NewModelForm.ModelCode.ConditionTypes.Values[I].StringArr.Count - 1 do
                 begin
                     temp:= temp + '{';
                     temp:= temp + '"key":"'+main.MainForm.NewModelForm.ModelCode.ConditionTypes.Values[I].StringArr.Keys[K]+'",';
                     temp:=temp  + '"value":"'+main.MainForm.NewModelForm.ModelCode.ConditionTypes.Values[I].StringArr.Values[K]+'"';
                     if K = main.MainForm.NewModelForm.ModelCode.ConditionTypes.Values[I].StringArr.Count - 1 then
                     begin
                         temp:=temp + '}';
                     end
                     else
                     begin
                         temp:=temp + '},';
                     end;
                 end;
                 temp:=temp+'],';
               end;
               temp:=temp+'"timerCoder":"'+main.MainForm.NewModelForm.ModelCode.ConditionTypes.Values[I].timerCoder+'"';
               if I = main.MainForm.NewModelForm.ModelCode.ConditionTypes.Count - 1 then
               begin
                   temp:=temp + '}';
               end
               else
               begin
                   temp:=temp + '},';
               end;
           end;
           temp:=temp + '],';
           temp:=temp + '"ConditionTypesLength":' + BooleanToStr(tempBoolean) + ',';

//           temp:=temp + '"advanceTypes":[';
//           tempBoolean := False;
//           for I := 0 to main.MainForm.NewModelForm.ModelCode.advanceList.Count - 1 do
//           begin
//               tempBoolean := True;
//               temp:=temp + '{';
//               temp:=temp+'"'+main.MainForm.NewModelForm.ModelCode.advanceList.Values[I].showType+'":true,';
//               if main.MainForm.NewModelForm.ModelCode.advanceList.Values[I].showType = '时间控件文本框' then
//               begin
//                 dateTime := True;
//               end;
//               temp:=temp+'"comment":"'+main.MainForm.NewModelForm.ModelCode.advanceList.Values[I].comment+'",';
//               temp:=temp+'"dataName":"'+main.MainForm.NewModelForm.ModelCode.advanceList.Values[I].datanameex+'",';
//               if main.MainForm.NewModelForm.ModelCode.advanceList.Values[I].dataGetType = 2 then
//               begin
//                 temp:=temp+'"diccode":"'+main.MainForm.NewModelForm.ModelCode.advanceList.Values[I].diccode+'",';
//                 if main.MainForm.NewModelForm.ModelCode.advanceList.Values[I].diccode <> '' then
//                    dic := True;
//               end
//               else if main.MainForm.NewModelForm.ModelCode.advanceList.Values[I].dataGetType = 0 then
//               begin
//                 temp:=temp+'"StringArr":[';
//                 for K := 0 to main.MainForm.NewModelForm.ModelCode.advanceList.Values[I].StringArr.Count - 1 do
//                 begin
//                     temp:= temp + '{';
//                     temp:= temp + '"key":"'+main.MainForm.NewModelForm.ModelCode.advanceList.Values[I].StringArr.Keys[K]+'",';
//                     temp:=temp  + '"value":"'+main.MainForm.NewModelForm.ModelCode.advanceList.Values[I].StringArr.Values[K]+'"';
//                     if K = main.MainForm.NewModelForm.ModelCode.advanceList.Values[I].StringArr.Count - 1 then
//                     begin
//                         temp:=temp + '}';
//                     end
//                     else
//                     begin
//                         temp:=temp + '},';
//                     end;
//                 end;
//                 temp:=temp+'],';
//               end;
//               temp:=temp+'"timerCoder":"'+main.MainForm.NewModelForm.ModelCode.advanceList.Values[I].timerCoder + '"';
//               if I = main.MainForm.NewModelForm.ModelCode.advanceList.Count - 1 then
//               begin
//                   temp:=temp + '}';
//               end
//               else
//               begin
//                   temp:=temp + '},';
//               end;
//           end;
//           temp:=temp + '],';
//           temp:=temp + '"advance":' + BooleanToStr(tempBoolean) + ',';

           temp:=temp + '"showAsList":' + BooleanToStr( not main.MainForm.NewModelForm.ModelCode.showAsTree) + ',';
           temp:=temp + '"showAsTree":' + BooleanToStr(main.MainForm.NewModelForm.ModelCode.showAsTree) + ',';
           temp:=temp + '"id":"' + main.MainForm.NewModelForm.ModelCode.Prototype.dataName + '",';
           
           temp:=temp + '"treeNode":"' + main.MainForm.NewModelForm.ModelCode.treeNode + '",';
           temp:=temp + '"checkbox":' + BooleanToStr(main.MainForm.NewModelForm.ModelCode.showcheckbox) + ',';
           temp:=temp + '"num":' + BooleanToStr(main.MainForm.NewModelForm.ModelCode.showNum) + ',';
           temp:=temp + '"nonum":' + BooleanToStr(not main.MainForm.NewModelForm.ModelCode.showNum) + ',';
           temp:=temp + '"ListTypes":[';
           tempBoolean := False;
           for I := 0 to main.MainForm.NewModelForm.ModelCode.ListTypes.Count - 1 do
           begin
               temp:=temp + '{';
               temp:=temp + '"dataName":"'+main.MainForm.NewModelForm.ModelCode.ListTypes.Values[I].dataName+'",';
               temp:=temp + '"DataLength":"'+inttostr(main.MainForm.NewModelForm.ModelCode.ListTypes.Values[I].DataLength)+'%",';
               temp:=temp + '"comment":"'+main.MainForm.NewModelForm.ModelCode.ListTypes.Values[I].comment+'",';
               temp:=temp + '"order":"'+BooleanToStr(main.MainForm.NewModelForm.ModelCode.ListTypes.Values[I].order)+'",';
               temp:=temp + '"orderTrue":'+BooleanToStr(main.MainForm.NewModelForm.ModelCode.ListTypes.Values[I].order)+',';
               temp:=temp+'"getData":'+booleantostr(main.MainForm.NewModelForm.ModelCode.ListTypes.Values[I].dataGetType = 0)+',';
               temp:=temp+'"notgetData":'+booleantostr(main.MainForm.NewModelForm.ModelCode.ListTypes.Values[I].dataGetType <> 0)+',';
               if main.MainForm.NewModelForm.ModelCode.ListTypes.Values[I].dataGetType = 0 then
               begin
                  temp:=temp + '"data'+inttostr(main.MainForm.NewModelForm.ModelCode.ListTypes.Values[I].dataGetType)+'":true,';
                   temp:=temp+'"StringArr":[';
                   for K := 0 to main.MainForm.NewModelForm.ModelCode.ListTypes.Values[I].StringArr.Count - 1 do
                   begin
                       temp:= temp + '{';
                       temp:= temp + '"key":"'+main.MainForm.NewModelForm.ModelCode.ListTypes.Values[I].StringArr.Keys[K]+'",';
                       temp:=temp  + '"value":"'+main.MainForm.NewModelForm.ModelCode.ListTypes.Values[I].StringArr.Values[K]+'"';
                       if K = main.MainForm.NewModelForm.ModelCode.ListTypes.Values[I].StringArr.Count - 1 then
                       begin
                           temp:=temp + '}';
                       end
                       else
                       begin
                           temp:=temp + '},';
                       end;
                   end;
                   temp:=temp+'],';
               end;

               temp:=temp + '"nodetext":'+BooleanToStr(main.MainForm.NewModelForm.ModelCode.ListTypes.Values[I].dataName = main.MainForm.NewModelForm.ModelCode.treeText);

               if main.MainForm.NewModelForm.ModelCode.ListTypes.Values[I].order then
                  tempBoolean := True;
               if I = main.MainForm.NewModelForm.ModelCode.ListTypes.Count - 1 then
               begin
                   temp:=temp + '}';
               end
               else
               begin
                   temp:=temp + '},';
               end;
           end;
           temp:=temp + '],';
           temp:=temp + '"datepack":'+booleanTostr(dateTime)+',';
           temp:=temp + '"dic":'+booleanTostr(dic)+',';
           temp:=temp + '"width":600,';
           temp:=temp + '"formHeight":'+inttostr(main.MainForm.NewModelForm.ModelCode.FormTypes.Count * 40)+',';
           temp:=temp + '"viewHeight":'+inttostr(main.MainForm.NewModelForm.ModelCode.viewList.Count * 40)+',';
//           temp:=temp + '"advHeight":'+inttostr(main.MainForm.NewModelForm.ModelCode.advanceList.Count * 40)+',';
//           temp:=temp + '"advWidth":400,';
           temp:=temp + '"sort":' + BooleanToStr(tempBoolean);
           temp:=temp + '}';
        end;
        13:begin
           //view
           temp:='{';
           temp:=temp + '"modelChname":"'+main.MainForm.NewModelForm.ModelCode.modelChname+'",';
           temp:=temp + '"modelName":"'+main.MainForm.NewModelForm.ModelCode.modelName+'",';
           temp:=temp + '"company":"'+main.MainForm.NewModelForm.ModelCode.company+'",';
           temp:=temp + '"author":"'+main.MainForm.NewModelForm.ModelCode.author+'",';
           temp:=temp + '"date":"'+Formatdatetime('yyyy-MM-dd', Now)+'",';
           temp:=temp + '"fjs":[';
           tempBoolean := False;
           for I := 0 to Length(main.MainForm.NewModelForm.ModelCode.Fjs) - 1 do
           begin
                tempBoolean := True;
                temp:=temp + '{';
                temp:=temp + '"name":"accfrm'+inttostr(I)+'",';
                temp:=temp + '"type":"'+main.MainForm.NewModelForm.ModelCode.Fjs[I].fileType+'",';
                temp:=temp + '"qz":"'+main.MainForm.NewModelForm.ModelCode.Fjs[I].qz+'",';
                temp:=temp + '"hz":"'+main.MainForm.NewModelForm.ModelCode.Fjs[I].hz+'",';
                temp:=temp + '"maxCount":"'+inttostr(main.MainForm.NewModelForm.ModelCode.Fjs[I].maxcount)+'",';
                temp:=temp + '"showAsImg":"'+main.MainForm.NewModelForm.ModelCode.Fjs[I].showasimage+'",';
                temp:=temp + '"height":"'+inttostr(main.MainForm.NewModelForm.ModelCode.Fjs[I].maxcount * 20 + 80)+'",';
                if main.MainForm.NewModelForm.ModelCode.Fjs[I].path <> '' then
                  temp:=temp + '"path":"/'+main.MainForm.NewModelForm.ModelCode.Fjs[I].path+'",'
                else
                begin
                  temp:=temp + '"notpath":true,'
                end;
                temp:=temp + '"comment":"'+main.MainForm.NewModelForm.ModelCode.Fjs[I].comment+'"';
                temp:=temp + '},';
           end;

           if tempBoolean then
           begin
                temp:= Copy(temp,1,Length(temp)-1) + '],';
                temp:=temp + '"prototype":"'+main.MainForm.NewModelForm.ModelCode.Prototype.dataName+'",';
           end
           else
           begin
                temp:=temp + '],';
           end;
           temp:=temp + '"viewList":[';
           tempBoolean := False;
           for I := 0 to main.MainForm.NewModelForm.ModelCode.viewList.Count - 1 do
           begin
               temp:=temp + '{';
               temp:=temp + '"dataName":"'+main.MainForm.NewModelForm.ModelCode.viewList.Values[I].dataName+'",';
               temp:=temp + '"data'+inttostr(main.MainForm.NewModelForm.ModelCode.viewList.Values[I].dataGetType)+'":true,';
               if main.MainForm.NewModelForm.ModelCode.viewList.Values[I].dataGetType = 0 then
               begin
                   temp:=temp+'"StringArr":[';
                   for K := 0 to main.MainForm.NewModelForm.ModelCode.viewList.Values[I].StringArr.Count - 1 do
                   begin
                       temp:= temp + '{';
                       temp:= temp + '"key":"'+main.MainForm.NewModelForm.ModelCode.viewList.Values[I].StringArr.Keys[K]+'",';
                       temp:=temp  + '"value":"'+main.MainForm.NewModelForm.ModelCode.viewList.Values[I].StringArr.Values[K]+'"';
                       if K = main.MainForm.NewModelForm.ModelCode.viewList.Values[I].StringArr.Count - 1 then
                       begin
                           temp:=temp + '}';
                       end
                       else
                       begin
                           temp:=temp + '},';
                       end;
                   end;
                   temp:=temp+'],';
               end;
               temp:=temp + '"comment":"'+main.MainForm.NewModelForm.ModelCode.viewList.Values[I].comment+'"';
               if I = main.MainForm.NewModelForm.ModelCode.viewList.Count - 1 then
               begin
                   temp:=temp + '}';
               end
               else
               begin
                   temp:=temp + '},';
               end;
           end;
           temp:=temp + ']';
           temp:=temp + '}';
        end;
        14:begin
           temp:='{';
           temp:=temp + '"modelChname":"'+main.MainForm.NewModelForm.ModelCode.modelChname+'",';
           temp:=temp + '"modelName":"'+main.MainForm.NewModelForm.ModelCode.modelName+'",';
           temp:=temp + '"company":"'+main.MainForm.NewModelForm.ModelCode.company+'",';
           temp:=temp + '"author":"'+main.MainForm.NewModelForm.ModelCode.author+'",';
           temp:=temp + '"date":"'+Formatdatetime('yyyy-MM-dd', Now)+'",';
		       temp:=temp + '"mobileId":"'+main.MainForm.NewModelForm.ModelCode.Prototype.dataName+'",';
		       temp:=temp + '"mobileTitle":"'+main.MainForm.NewModelForm.ModelCode.mobileTitle+'",';
           temp:=temp + '"viewList":[';
           tempBoolean := False;
           for I := 0 to main.MainForm.NewModelForm.ModelCode.viewList.Count - 1 do
           begin
               temp:=temp + '{';
               temp:=temp + '"dataName":"'+main.MainForm.NewModelForm.ModelCode.viewList.Values[I].dataName+'",';
               temp:=temp + '"data'+inttostr(main.MainForm.NewModelForm.ModelCode.viewList.Values[I].dataGetType)+'":true,';
               if main.MainForm.NewModelForm.ModelCode.viewList.Values[I].dataGetType = 0 then
               begin
                   temp:=temp+'"StringArr":[';
                   for K := 0 to main.MainForm.NewModelForm.ModelCode.viewList.Values[I].StringArr.Count - 1 do
                   begin
                       temp:= temp + '{';
                       temp:= temp + '"key":"'+main.MainForm.NewModelForm.ModelCode.viewList.Values[I].StringArr.Keys[K]+'",';
                       temp:=temp  + '"value":"'+main.MainForm.NewModelForm.ModelCode.viewList.Values[I].StringArr.Values[K]+'"';
                       if K = main.MainForm.NewModelForm.ModelCode.viewList.Values[I].StringArr.Count - 1 then
                       begin
                           temp:=temp + '}';
                       end
                       else
                       begin
                           temp:=temp + '},';
                       end;
                   end;
                   temp:=temp+'],';
               end;
               temp:=temp + '"comment":"'+main.MainForm.NewModelForm.ModelCode.viewList.Values[I].comment+'"';
               if I = main.MainForm.NewModelForm.ModelCode.viewList.Count - 1 then
               begin
                   temp:=temp + '}';
               end
               else
               begin
                   temp:=temp + '},';
               end;
           end;
           temp:=temp + '],';
           temp:=temp + '"FormTypes":[';
           for I := 0 to  main.MainForm.NewModelForm.ModelCode.FormTypes.Count - 1 do
           begin
               temp:=temp+'{';
               temp:=temp+'"'+main.MainForm.NewModelForm.ModelCode.FormTypes.Values[I].showType+'":true,';

               if main.MainForm.NewModelForm.ModelCode.FormTypes.Values[I].showType = '时间控件文本框' then
               begin
                 dateTime := True;
               end
               else  if main.MainForm.NewModelForm.ModelCode.FormTypes.Values[I].showType = '富文本框' then
               begin
                 fck:=True;
               end;
               
               temp:=temp+'"comment":"'+main.MainForm.NewModelForm.ModelCode.FormTypes.Values[I].comment+'",';
               temp:=temp+'"dataName":"'+main.MainForm.NewModelForm.ModelCode.FormTypes.Values[I].dataName+'",';
               temp:=temp+'"timerCoder":"'+main.MainForm.NewModelForm.ModelCode.FormTypes.Values[I].timerCoder+'",';
               if main.MainForm.NewModelForm.ModelCode.FormTypes.Values[I].dataGetType = 2 then
               begin
                 temp:=temp+'"diccode":"'+main.MainForm.NewModelForm.ModelCode.FormTypes.Values[I].diccode+'",';
                 if main.MainForm.NewModelForm.ModelCode.FormTypes.Values[I].diccode <> '' then
                    dic := True;
               end
               else if main.MainForm.NewModelForm.ModelCode.FormTypes.Values[I].dataGetType = 0 then
               begin
                 temp:=temp+'"StringArr":[';
                 for K := 0 to main.MainForm.NewModelForm.ModelCode.FormTypes.Values[I].StringArr.Count - 1 do
                 begin
                     temp:= temp + '{';
                     temp:= temp + '"key":"'+main.MainForm.NewModelForm.ModelCode.FormTypes.Values[I].StringArr.Keys[K]+'",';
                     temp:=temp  + '"value":"'+main.MainForm.NewModelForm.ModelCode.FormTypes.Values[I].StringArr.Values[K]+'"';
                     if K = main.MainForm.NewModelForm.ModelCode.FormTypes.Values[I].StringArr.Count - 1 then
                     begin
                         temp:=temp + '}';
                     end
                     else
                     begin
                         temp:=temp + '},';
                     end;
                 end;
                 temp:=temp+'],';
               end;
               tempBoolean := False;
               for K := 0 to main.MainForm.NewModelForm.ModelCode.FormTypes.Values[I].CheckRule.needs.Count - 1 do
               begin
                  if Pos('must',main.MainForm.NewModelForm.ModelCode.FormTypes.Values[I].CheckRule.needs[K]) > 0 then
                  begin
                      temp:=temp + '"must":true';
                      tempBoolean := True;
                      Break;
                  end;
               end;
               if not tempBoolean then
                   temp:=temp + '"must":false';
               if I = main.MainForm.NewModelForm.ModelCode.FormTypes.Count - 1 then
               begin
                   temp:=temp + '}';
               end
               else
               begin
                   temp:=temp + '},';
               end;
           end;
           temp:=temp + ']';
           temp:=temp + '}';
        end;
        15:begin
           temp:='{';
           temp:=temp + '"modelChname":"'+main.MainForm.NewModelForm.ModelCode.modelChname+'",';
           temp:=temp + '"modelName":"'+main.MainForm.NewModelForm.ModelCode.modelName+'",';
           temp:=temp + '"company":"'+main.MainForm.NewModelForm.ModelCode.company+'",';
           temp:=temp + '"author":"'+main.MainForm.NewModelForm.ModelCode.author+'",';
           temp:=temp + '"date":"'+Formatdatetime('yyyy-MM-dd', Now)+'",';
		       temp:=temp + '"mobileId":"'+main.MainForm.NewModelForm.ModelCode.Prototype.dataName+'",';
		       temp:=temp + '"mobileTitle":"'+main.MainForm.NewModelForm.ModelCode.mobileTitle+'",';
           temp:=temp + '"formRules":[';
           for I := 0 to main.MainForm.NewModelForm.ModelCode.FormTypes.Count - 1 do
           begin
               tempBoolean := False;
               if main.MainForm.NewModelForm.ModelCode.FormTypes.Values[I].CheckRule.needCheck and (main.MainForm.NewModelForm.ModelCode.FormTypes.Values[I].CheckRule.needs.Count > 0) then
               begin
                   temp:=temp + '{';
                   temp:=temp + '"ruleName":"'+main.MainForm.NewModelForm.ModelCode.FormTypes.Keys[I]+'",';
                   tempBoolean := False;
                   temp:=temp + '"needs":[';
                   for K := 0 to main.MainForm.NewModelForm.ModelCode.FormTypes.Values[I].CheckRule.needs.Count - 1 do
                   begin
                       temp:= temp + '{';
                       temp:= temp + '"need":"'+main.MainForm.NewModelForm.ModelCode.FormTypes.Values[I].CheckRule.needs[K]+'",';
                       if Pos('isWarn',main.MainForm.NewModelForm.ModelCode.FormTypes.Values[I].CheckRule.needs[K]) > 0 then
                       begin
                          warn := True;
                          if ((Pos('lhgAlert',main.MainForm.NewModelForm.ModelCode.CheckRule.rules.Items['onCheck']) = 0))
                          and ((Pos('alert',main.MainForm.NewModelForm.ModelCode.CheckRule.rules.Items['onCheck']) = 0))
                          and ((Pos('ymPrompt',main.MainForm.NewModelForm.ModelCode.CheckRule.rules.Items['onCheck']) = 0))
                          then
                          begin
                              main.MainForm.NewModelForm.ModelCode.CheckRule.rules.Add('onCheck',main.MainForm.NewModelForm.ModelCode.CheckRule.rules.Items['onCheck'] + ',lhgAlert');
                          end;
                       end;
                       
                       if K = main.MainForm.NewModelForm.ModelCode.FormTypes.Values[I].CheckRule.needs.Count - 1 then
                       begin
                           temp:=temp + '"adh":""';
                           temp:=temp + '}';
                       end
                       else
                       begin
                           temp:=temp + '"adh":","';
                           temp:=temp + '},';
                       end;
                   end;
                   temp:=temp + '],';

                   tempBoolean := False;
                   for K := I + 1 to main.MainForm.NewModelForm.ModelCode.FormTypes.Count - 1 do
                   begin
                        if main.MainForm.NewModelForm.ModelCode.FormTypes.Values[K].CheckRule.needCheck and (main.MainForm.NewModelForm.ModelCode.FormTypes.Values[K].CheckRule.needs.Count > 0) then
                           tempBoolean := True;
                   end;


                   if not tempBoolean then
                   begin
                        temp := temp + '"dh":""';
                        temp:=temp + '}';
                   end
                   else
                   begin
                        temp := temp + '"dh":","';
                        temp:=temp + '},';
                   end;
               end;

           end;

           temp:=temp + ']';
           temp:=temp + '}';
        end;
    end;
    try
      WebForm.WebBrowser.OleObject.document.getElementByID('json').innerText := temp;
      WebForm.WebBrowser.OleObject.document.parentWindow.make();
      WebForm.result.Text := WebForm.WebBrowser.OleObject.document.getElementByID('html').innerText;
      PresaveFile(fileList.Items[index]);
      if index = 14 then
	      WebForm.result.Text :=  StringReplace(StringReplace(WebForm.result.Text,'<textsarea', '<textarea', [rfReplaceAll]),'</textsarea>', '</textarea>', [rfReplaceAll]);
      WebForm.result.Lines.SaveToFile(fileList.Items[index]);

      if isFG then
      begin
         logMemo.Lines.Add('覆盖生成'+fileList.Items[index]+'完毕..');
         ErrorLogsUnit.addErrors('覆盖生成'+fileList.Items[index]+'完毕..');
      end
      else
      begin
        logMemo.Lines.Add('生成'+fileList.Items[index]+'完毕..');
        ErrorLogsUnit.addErrors('生成'+fileList.Items[index]+'完毕..');
      end;
    except
      logMemo.Lines.Add('生成'+fileList.Items[index]+'失败..');
      ErrorLogsUnit.addErrors('生成'+fileList.Items[index]+'失败..');
    end;
    Inc(Index);
    bsSkinButton1Click(nil);
    except
        goBtn.Enabled := True;
        WebForm.Close;
    end;
end;

procedure TCodeMaker.copyFileDo(old,new:string);
var
  dir:string;
begin
  dir := Copy(new,1,LastDelimiter('\',new)-1);
  if not DirectoryExists(dir) then
  begin
    ForceDirectories(PChar(dir));
  end;
  logMemo.Lines.Add('备份'+old+'...');
  CopyFile(PChar(old), PChar(new), false);
end;

procedure TCodeMaker.bsSkinButton1Click(Sender: TObject);
var
  I:Integer;
  tem:string;
begin
  if fileList.Items.Count = 0 then
  begin
    Application.MessageBox('没有要生成的文件！' + #13#10 + 
      '请在文件列表中勾选要生成的文件！', '提示', MB_OK + MB_ICONINFORMATION);
    Exit;  
  end;
  
  if WebForm = nil then
     WebForm := TWebForm.Create(Application);
  WebForm.Show;
  bsSkinButton1.Enabled := False;
  goBtn.Enabled := False;
  for I := index to fileList.Items.Count - 1 do
  begin
      if fileList.Checked[I] then
      begin
          isFG := False;
          if FileExists(fileList.Items[I]) then
          begin
             if Application.MessageBox(PChar(fileList.Items[I]+'已经存在'#13#13'是否覆盖？？'), '提示', MB_OKCANCEL +
                  MB_ICONQUESTION) = 2 then
             begin
               logMemo.Lines.Add('跳过'+fileList.Items[index]);
               Continue;
             end;
             isFG := True;

             copyFileDo(fileList.Items[I],ExtractFilePath(ParamStr(0))+'\bak\'+main.MainForm.NewModelForm.ModelCode.modelName  + paths[I]);
          end;
          fileList.ItemIndex := I;
          index := I;
          if TemBan.ItemIndex = 0 then tem := '\template'
          else  tem := '\template09x';
          case index of
            0:begin
              WebForm.WebBrowser.Navigate(main.Path+tem+'\src\action\deleteAction.html');
            end;
            1:begin
              WebForm.WebBrowser.Navigate(main.Path+tem+'\src\action\saveAction.html');
            end;
            2:begin
              WebForm.WebBrowser.Navigate(main.Path+tem+'\src\action\showAction.html');
            end;
            3:begin
              WebForm.WebBrowser.Navigate(main.Path+tem+'\src\dao\dao.html');
            end;
            4:begin
              WebForm.WebBrowser.Navigate(main.Path+tem+'\src\dao\daoimpl.html');
            end;
            5:begin
              WebForm.WebBrowser.Navigate(main.Path+tem+'\src\service\service.html');
            end;
            6:begin
              WebForm.WebBrowser.Navigate(main.Path+tem+'\src\service\serviceimpl.html');
            end;
            7:begin
              if main.MainForm.NewModelForm.ModelCode.ConditionTypes.Count = 0 then
              begin
                DeleteFile(main.MainForm.NewModelForm.ModelCode.modelPath+'\form\'+main.MainForm.NewModelForm.ModelCode.modelLargeName+'ConditionForm.java');
                Continue;
              end;
              WebForm.WebBrowser.Navigate(main.Path+tem+'\src\form\conditionForm.html');
            end;
            8:begin
              WebForm.WebBrowser.Navigate(main.Path+tem+'\src\form\form.html');
            end;
            9:begin
              WebForm.WebBrowser.Navigate(main.Path+tem+'\springconfig\spring.html');
            end;
            10:begin
              WebForm.WebBrowser.Navigate(main.Path+tem+'\strutsconfig\struts.html');
            end;
            11:begin
              WebForm.WebBrowser.Navigate(main.Path+tem+'\pages\form.html');
            end;
            12:begin
              WebForm.WebBrowser.Navigate(main.Path+tem+'\pages\list.html');
            end;
            13:begin
              WebForm.WebBrowser.Navigate(main.Path+tem+'\pages\view.html');
            end;
            14:begin
              WebForm.WebBrowser.Navigate(main.Path+tem+'\mobile\o.html');
            end;
            15:begin
              WebForm.WebBrowser.Navigate(main.Path+tem+'\mobile\o.js.html');
            end;
          end;
          Exit;
      end;
  end;
  goBtn.Enabled := True;
  WebForm.Close;
  try
    changeWebXml('/WEB-INF/strutsconfig/struts-config-'+main.MainForm.NewModelForm.ModelCode.modelName+'.xml',main.MainForm.NewModelForm.ModelCode.propath+'\WebRoot\WEB-INF\web.xml');
  except
    Application.MessageBox('修改web.xml时发生错误' + #13#10 + 
      'web.xml是不是没有Struts Action 配置？', '提示', MB_OK + MB_ICONSTOP);
  end;


  Clipboard.AsText := '/'+main.MainForm.NewModelForm.ModelCode.modelName + 'LoadAction.do?action=showList';

  case 
    Application.MessageBox('生成完毕！菜单地址已经复制到了剪贴板#13是否调用webserveice将此地址配置到平台？',
    '提示', MB_OKCANCEL + MB_ICONINFORMATION) of
    IDOK:
      begin
      if  WebServiceForm = nil then
          WebServiceForm := TWebServiceForm.Create(Application);
      WebServiceForm.ShowModal;
      end;
  end;




end;

procedure TCodeMaker.FormShow(Sender: TObject);
var
  pathTemp:string;
  I:Integer;
begin
  index := 0;
  bsSkinButton1.Enabled := True;
  logMemo.Lines.Clear;
  pathTemp := main.MainForm.NewModelForm.ModelCode.propath;
  paths := TStringList.Create;
  fileList.Items.Clear;
  fileList.Items.Add(main.MainForm.NewModelForm.ModelCode.modelPath+'\action\'+main.MainForm.NewModelForm.ModelCode.modelLargeName+'DeleteAction.java');
  paths.Add('\action\'+main.MainForm.NewModelForm.ModelCode.modelLargeName+'DeleteAction.java');
  fileList.Items.Add(main.MainForm.NewModelForm.ModelCode.modelPath+'\action\'+main.MainForm.NewModelForm.ModelCode.modelLargeName+'SaveAction.java');
  paths.Add('\action\'+main.MainForm.NewModelForm.ModelCode.modelLargeName+'SaveAction.java');
  fileList.Items.Add(main.MainForm.NewModelForm.ModelCode.modelPath+'\action\'+main.MainForm.NewModelForm.ModelCode.modelLargeName+'ShowAction.java');
  paths.Add('\action\'+main.MainForm.NewModelForm.ModelCode.modelLargeName+'ShowAction.java');
  fileList.Items.Add(main.MainForm.NewModelForm.ModelCode.modelPath+'\dao\'+main.MainForm.NewModelForm.ModelCode.modelLargeName+'DAO.java');
  paths.Add('\dao\'+main.MainForm.NewModelForm.ModelCode.modelLargeName+'DAO.java');
  fileList.Items.Add(main.MainForm.NewModelForm.ModelCode.modelPath+'\dao\hibernateImpl\'+main.MainForm.NewModelForm.ModelCode.modelLargeName+'DAOImpl.java');
  paths.Add('\dao\hibernateImpl\'+main.MainForm.NewModelForm.ModelCode.modelLargeName+'DAOImpl.java');
  fileList.Items.Add(main.MainForm.NewModelForm.ModelCode.modelPath+'\service\'+main.MainForm.NewModelForm.ModelCode.modelLargeName+'Service.java');
  paths.Add('\service\'+main.MainForm.NewModelForm.ModelCode.modelLargeName+'Service.java');
  fileList.Items.Add(main.MainForm.NewModelForm.ModelCode.modelPath+'\service\'+main.MainForm.NewModelForm.ModelCode.modelLargeName+'ServiceImpl.java');
  paths.Add('\service\'+main.MainForm.NewModelForm.ModelCode.modelLargeName+'ServiceImpl.java');
  fileList.Items.Add(main.MainForm.NewModelForm.ModelCode.modelPath+'\form\'+main.MainForm.NewModelForm.ModelCode.modelLargeName+'ConditionForm.java');
  paths.Add('\form\'+main.MainForm.NewModelForm.ModelCode.modelLargeName+'ConditionForm.java');
  fileList.Items.Add(main.MainForm.NewModelForm.ModelCode.modelPath+'\form\'+main.MainForm.NewModelForm.ModelCode.modelLargeName+'Form.java');
  paths.Add('\form\'+main.MainForm.NewModelForm.ModelCode.modelLargeName+'Form.java');
  fileList.Items.Add(pathTemp+'\src\springconfig\applicationContext-'+main.MainForm.NewModelForm.ModelCode.modelName+'.xml');
  paths.Add('\springconfig\applicationContext-'+main.MainForm.NewModelForm.ModelCode.modelName+'.xml');
  fileList.Items.Add(pathTemp+'\WebRoot\WEB-INF\strutsconfig\struts-config-'+main.MainForm.NewModelForm.ModelCode.modelName+'.xml');
  paths.Add('\strutsconfig\struts-config-'+main.MainForm.NewModelForm.ModelCode.modelName+'.xml');
  fileList.Items.Add(pathTemp+'\WebRoot\pages\'+main.MainForm.NewModelForm.ModelCode.modelName+'\'+main.MainForm.NewModelForm.ModelCode.modelName+'form.jsp');
  paths.Add('\pages\'+main.MainForm.NewModelForm.ModelCode.modelName+'\'+main.MainForm.NewModelForm.ModelCode.modelName+'form.jsp');
  fileList.Items.Add(pathTemp+'\WebRoot\pages\'+main.MainForm.NewModelForm.ModelCode.modelName+'\'+main.MainForm.NewModelForm.ModelCode.modelName+'list.jsp');
  paths.Add('\pages\'+main.MainForm.NewModelForm.ModelCode.modelName+'\'+main.MainForm.NewModelForm.ModelCode.modelName+'list.jsp');
  fileList.Items.Add(pathTemp+'\WebRoot\pages\'+main.MainForm.NewModelForm.ModelCode.modelName+'\'+main.MainForm.NewModelForm.ModelCode.modelName+'view.jsp');
  paths.Add('\pages\'+main.MainForm.NewModelForm.ModelCode.modelName+'\'+main.MainForm.NewModelForm.ModelCode.modelName+'view.jsp');


  if MainForm.NewModelForm.ModelCode.mobile then
  begin
    pathTemp := main.MainForm.NewModelForm.ModelCode.mobilePath;
    fileList.Items.Add(pathTemp+'\assets\www\pages\'+main.MainForm.NewModelForm.ModelCode.modelName+'.html');
    paths.Add('\mobile\'+main.MainForm.NewModelForm.ModelCode.modelName+'.html');
    fileList.Items.Add(pathTemp+'\assets\www\resource\apps\'+main.MainForm.NewModelForm.ModelCode.modelName+'.js');
    paths.Add('\mobile\'+main.MainForm.NewModelForm.ModelCode.modelName+'.js');
  end;


  for I := 0 to fileList.Items.Count - 1 do
  begin
     fileList.Checked[I] := True;
  end;
end;

procedure TCodeMaker.goBtnClick(Sender: TObject);
begin
  Close;
end;

end.
