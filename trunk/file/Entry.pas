unit Entry;

interface
uses
  SysUtils,Classes,Common;
function entryCode(source:string ):string;

implementation

function entryCode(source:String):string;
var
  I,tempIndex:Integer;
  outString:string;
  bigArr,smallArr,sources,numArr:TStrings;
begin
  bigArr := Common.toStringList('ABCDEFGHIJKLMNOPQRSTUVWXYZ');
  smallArr := Common.toStringList('abcdefghijklmnopqrstuvwxyz');
  numArr := Common.toStringList('1234567890');
  sources := Common.toStringList(source);
  for I := 0 to sources.Count - 1 do
  begin
      if numArr.IndexOf(sources[I]) > -1 then
      begin
          outString := outString + bigArr[Strtoint(sources[I])];
      end
      else if smallArr.IndexOf(sources[I]) > -1 then
      begin
         outString := outString + IntToStr(smallArr.IndexOf(sources[I]));
      end
      else if bigArr.IndexOf(sources[I]) > -1 then
      begin
         outString := outString + smallArr[bigArr.IndexOf(sources[I])];
      end
      else
      begin
        outString := outString + sources[I];
      end;
  end;
  Result := outString;
end;


end.
