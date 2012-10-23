unit Base;

interface
uses
  Common,Classes;
type
  TBase = class (TObject)
    Version: string;
    Author: string;
    NewTime: string;
    OnlyId :String;
    NeedAdd :Boolean;
    constructor Create(PNeedAdd:Boolean = false);overload;
  end;

  TItemsArr = array of TStrings;



implementation

constructor TBase.Create(PNeedAdd:Boolean = false);
begin
   inherited Create;
   Version := '1.0.0.1';
   Author := 'Magican';
   NewTime := '2010-11-05';
   if PNeedAdd then
      OnlyId := Common.CreateOnlyId;
   NeedAdd := PNeedAdd;
end;






end.
