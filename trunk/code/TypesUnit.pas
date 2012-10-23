unit TypesUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls,XMLIntf, msxmldom, XMLDoc, bsSkinBoxCtrls, bsSkinCtrls,
  BusinessSkinForm,IdHTTP;

type
  TTypesForm = class(TForm)
    bsBusinessSkinForm: TbsBusinessSkinForm;
    bsSkinGroupBox1: TbsSkinGroupBox;
    bsSkinButton1: TbsSkinButton;
    bsSkinButton3: TbsSkinButton;
    types: TbsSkinComboBox;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  TypesForm: TTypesForm;
  messages:tstrings;
  names:tstrings;

implementation
uses
  main;
{$R *.dfm}

procedure TTypesForm.FormCreate(Sender: TObject);
var
    XMLDocument : IXMLDocument;
    rootNode,beanNode :IXMLNode;
    index : Integer;
    idhtpLog: TIdHTTP;
    Stream: TMemoryStream;
begin
    XMLDocument :=  TXMLDocument.Create(Application); 
    idhtpLog := TIdHTTP.Create(Application);
    Stream := TMemoryStream.Create;
    try
      idhtpLog.Get(main.Path + '/res/types.xml', Stream);
      XMLDocument.LoadFromStream(Stream);
      rootNode := XMLDocument.DocumentElement;
      messages := tstringlist.Create;
      names := tstringlist.Create;
      for index := 0 to rootNode.ChildNodes.Count - 1 do
      begin
          beanNode:= rootNode.ChildNodes[index];
          names.Add(Trim(beanNode.GetAttributeNS('name','')));
          messages.Add(Trim(beanNode.ChildNodes.First.Text));
          types.Items.Add(Trim(beanNode.GetAttributeNS('value','')));
      end;
    finally
      XMLDocument := nil;
      idhtpLog.Free;
      Stream.Free;
    end;
end;

procedure TTypesForm.FormShow(Sender: TObject);
begin
  types.ItemIndex := -1;
end;

end.
