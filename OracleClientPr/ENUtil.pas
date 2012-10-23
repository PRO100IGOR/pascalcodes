unit ENUtil;
{为enlib从xml中读取要显示的列}
interface
uses
  xmldom, XMLIntf, msxmldom, XMLDoc, ActiveX, SysUtils, Classes, Windows, Grids, DB, bsDBGrids;



procedure changeDB(FileName: string; DBGrid: TbsSkinDBGrid); overload; //有序号



procedure changeDB(FileName, SortColumn: string; DBGrid: TbsSkinDBGrid); overload; //有序号

implementation


procedure changeDB(FileName, SortColumn: string; DBGrid: TbsSkinDBGrid); overload; //有序号
var
  XMLDocument: IXMLDocument;
  Beans, Bean: IXMLNode;
  I, WidthAll: Integer;
begin
  WidthAll := 0;
  CoInitialize(nil);
  DBGrid.Columns.Clear;
  with DBGrid.Columns.Add do begin
    FieldName := SortColumn;
    Title.Caption := '序号';
    Title.Alignment := taCenter;
    ReadOnly := true;
    Width := 40;
    WidthAll := 40;
  end;
  XMLDocument := TXMLDocument.Create(nil);
  FileName := ExtractFileDir(PARAMSTR(0)) + '\' + FileName;
  if FileExists(FileName) then
  begin
    XMLDocument.LoadFromFile(FileName);
    Beans := XMLDocument.DocumentElement;
    for I := 0 to Beans.ChildNodes.Count - 1 do
    begin
      Bean := Beans.ChildNodes[I];
      with DBGrid.Columns.Add do
      begin
        FieldName := Trim(Bean.GetAttributeNS('name', ''));
        Visible := not ((Bean.HasAttribute('Visible')) and
          (Trim(Bean.GetAttributeNS('Visible', '')) = 'false'));
        if Visible then
        begin
          Title.Caption := Trim(Bean.GetAttributeNS('Caption', ''));
          Title.Alignment := taCenter;
          ReadOnly := true;
          Width := StrtoInt(Trim(Bean.GetAttributeNS('Width', '')));
          WidthAll := Width + WidthAll;
        end;
      end;
    end;
  end;
  XMLDocument := nil;
  CoUninitialize;
  DBGrid.VScrollBar.Left := DBGrid.Width + DBGrid.Left + 2;
  DBGrid.VScrollBar.Height := DBGrid.Height;
  DBGrid.VScrollBar.Top := DBGrid.Top;
end;

procedure changeDB(FileName: string; DBGrid: TbsSkinDBGrid); //没序号
var
  XMLDocument: IXMLDocument;
  Beans, Bean: IXMLNode;
  I, WidthAll: Integer;
begin
  WidthAll := 0;
  CoInitialize(nil);
  DBGrid.Columns.Clear;
  XMLDocument := TXMLDocument.Create(nil);
  FileName := ExtractFileDir(PARAMSTR(0)) + '\' + FileName;
  if FileExists(FileName) then
  begin
    XMLDocument.LoadFromFile(FileName);
    Beans := XMLDocument.DocumentElement;
    for I := 0 to Beans.ChildNodes.Count - 1 do
    begin
      Bean := Beans.ChildNodes[I];
      with DBGrid.Columns.Add do
      begin
        FieldName := Trim(Bean.GetAttributeNS('name', ''));

        Visible := not ((Bean.HasAttribute('Visible')) and
          (Trim(Bean.GetAttributeNS('Visible', '')) = 'false'));
        if Visible then
        begin
          Title.Caption := Trim(Bean.GetAttributeNS('Caption', ''));
          Title.Alignment := taCenter;
          ReadOnly := true;
          Width := StrtoInt(Trim(Bean.GetAttributeNS('Width', '')));
          WidthAll := Width + WidthAll;
        end;
      end;
    end;
  end;
  XMLDocument := nil;
  CoUninitialize;
  DBGrid.Width := WidthAll;
  DBGrid.Parent.Width := WidthAll + 47;
  DBGrid.VScrollBar.Left := WidthAll + DBGrid.Left + 2;
  DBGrid.VScrollBar.Height := DBGrid.Height;
  DBGrid.VScrollBar.Top := DBGrid.Top;
end;

end.

