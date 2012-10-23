unit main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TSearchForm = class(TForm)
    go: TButton;
    Memo1: TMemo;
    procedure goClick(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  SearchForm: TSearchForm;

implementation
uses msxml, superobject;

{$R *.dfm}

// http://code.google.com/intl/fr-FR/apis/ajaxsearch/documentation/reference.html#_class_GSearch



procedure TSearchForm.goClick(Sender: TObject);
var
  obj,oo: ISuperObject;
  I:Integer;
  fendList: TSuperArray;
begin
  obj := SO('{}');
  oo := SO('sss');
  obj['aa[]'] := oo;
    oo := SO('ss');
    obj['aa[]'] := oo;
    obj['bbbb'] := SO('ssszzxczxc');
               ShowMessage(obj.AsString);
end;

end.
