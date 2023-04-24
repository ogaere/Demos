unit UCVS;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, Dialogs, StdCtrls, uecNativeMapControl,uecnativeshape,uecMapUtil,
  ExtCtrls, Vcl.ComCtrls;

type
  TForm29 = class(TForm)
    Panel1: TPanel;
    Memo1: TMemo;
    map: TECNativeMap;
    Label1: TLabel;
    delimiter: TEdit;
    Label2: TLabel;
    latitude: TEdit;
    Label3: TLabel;
    longitude: TEdit;
    btOpenCSV: TButton;
    OpenDialog1: TOpenDialog;
    lbValidate: TLabel;
    Panel2: TPanel;
    Fields: TComboBox;
    DisplayLabel: TCheckBox;
    PageControl1: TPageControl;
    View: TTabSheet;
    TabSheet1: TTabSheet;
    csvdata: TMemo;
    wktFields: TComboBox;
    Label4: TLabel;
    procedure btOpenCSVClick(Sender: TObject);
    procedure delimiterKeyPress(Sender: TObject; var Key: Char);
    procedure latitudeKeyPress(Sender: TObject; var Key: Char);
    procedure longitudeKeyPress(Sender: TObject; var Key: Char);
    procedure FieldChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure LabelFieldKeyPress(Sender: TObject; var Key: Char);
    procedure FieldsSelect(Sender: TObject);
    procedure DisplayLabelClick(Sender: TObject);
    procedure wktFieldsChange(Sender: TObject);

  private
    { Déclarations privées }

    procedure ValidateEdit(const Edit:TEdit);
    procedure ModifiedEdit(const Edit:TEdit);

    procedure doOnCreateCSVPoint(const Group: TECShapes; var CSVPoint: TECShape; const Lat, Lng: double; const Data:TStringList)  ;
    procedure doOnCreateWKTObject(const Group: TECShapes; const WKTObject: TECShape; const Lat, Lng: double; const Data: TStringList);
    procedure doOnFilterCSV(const Data: TStringList;var validCSV:boolean);


    procedure doOnLoad(sender: TObject; const GroupName: string; const FinishLoading: Boolean);

    procedure doOnShapeClick(sender: TObject; const item: TECShape);
  public
    { Déclarations publiques }
    CSVGroup:TECShapes;
  end;

var
  Form29: TForm29;

implementation

{$R *.dfm}


procedure ConvertLatLng(var lat,lng:double);
begin
 Lat := Lat  / 1000000;
  Lng := Lng / 1000000;
end;


procedure TForm29.FormCreate(Sender: TObject);

begin

  // we will place our elements in the default group (map.shapes)
  // to use a particular group replace map.shapes by map['your_group_name']

  map.ScaleMarkerToZoom := true;

  CSVGroup := map.shapes;

  //csvgroup.CSV.OnConvertLatLng := ConvertLatLng;

  delimiter.Text := CSVGroup.csv.delimiter;
  latitude.text  := CSVGroup.csv.FieldNameLatitude;
  longitude.Text := CSVGroup.csv.FieldNameLongitude;

  // Any field of the CSV file can be displayed as a label
  CSVGroup.Markers.Labels.LabelType := ltProperty;
  CSVGroup.Markers.Labels.Align     := laBottom;
  CSVGroup.Markers.Labels.MinZoom   := 8;



  CSVGroup.polygones.Labels.LabelType := ltProperty;
  CSVGroup.polygones.Labels.Align     := laCenter;
  CSVGroup.polygones.Labels.MinZoom   := 8;

  CSVGroup.lines.Labels.LabelType := ltProperty;
  CSVGroup.lines.Labels.Align     := laCenter;
  CSVGroup.lines.Labels.MinZoom   := 8;



  // take over the creation of the points
  CSVGroup.CSV.OnCreateCSVPoint  := doOnCreateCSVPoint;

  // react after creation wkt object
  CSVGroup.CSV.OnCreateWKTObject := doOnCreateWKTObject;

  // filter csv data
   CSVGroup.CSV.OnFilterCSV := doOnFilterCSV;

  // connection to the end of the load
  map.OnLoad                       := doOnLoad;
  // react to the click on an item
  map.OnShapeClick                 := doOnShapeClick;

  ValidateEdit(delimiter);
  ValidateEdit(latitude);
  ValidateEdit(longitude);

end;



// Open CSV file
procedure TForm29.btOpenCSVClick(Sender: TObject);
begin
  if opendialog1.execute then
  begin
    map.Clear;
    caption := '';
    Memo1.Lines.Clear;
    Fields.Items.Clear;
    DisplayLabel.Checked := false;

    csvdata.Lines.LoadFromFile(opendialog1.filename) ;

    // load the CSV asynchronously
    CSVGroup.csv.ASyncLoadFromFile(opendialog1.filename);

  end;
end;



// Manual creation of each point
// Data contains the CSV values for the point
procedure TForm29.doOnCreateCSVPoint(const Group: TECShapes; var CSVPoint: TECShape; const Lat, Lng: double; const Data:TStringList)  ;
var  M:TECShapeMarker;
begin

 // create new marker
 M := Group.addMarker(lat,lng);;
 CSVPoint := M ;

 // marker design
 M.Width     := 12;
 M.StyleIcon := siFlat;

 // we calculate its color according to its index number
 M.Color     := GetHashColor(inttostr(M.IndexOf));

 caption := inttostr(M.Group.Count) + ' items';

end;


// valid csv data , default true
procedure TForm29.doOnFilterCSV(const Data: TStringList;var validCSV:boolean);
begin
  // if (data.Count>2) and (pos('POLYGON',data[7])<1) then
  // validCSV := (data[2]<>'relation');
end;

// fired after creation wkt object
procedure TForm29.doOnCreateWKTObject(const Group: TECShapes;
    const WKTObject: TECShape; const Lat, Lng: double; const Data: TStringList);

begin
 // we calculate its color according to its index number

 if WKTObject is TECShapePolygone then
   TECShapePolygone(WKTObject).FillColor := GetHashColor(inttostr(WKTObject.IndexOf))
 else
 begin
   WKTObject.Color     := GetHashColor(inttostr(WKTObject.IndexOf));
 end;

 caption := inttostr(WKTObject.Group.Count) + ' items';
end;


// triggered when loading of GroupName is complete
procedure TForm29.doOnLoad(sender: TObject; const GroupName: string;
  const FinishLoading: Boolean);
begin

 // display all elements of the group
 map[groupname].fitBounds;


 // CVSGroupe.csv.fields contains the list of field names
 fields.Items.Assign(CSVGroup.csv.Fields);

 WKTFields.Items.Assign(CSVGroup.csv.Fields);

 // if the file does not contain the names of the fields,
 // you will have to enter them manually, they will be of the style file_name+index
 if fields.Items.Count=0 then
  Fields.Style := csDropdown
  else
 Fields.Style := csDropdownList;


 caption := inttostr(map[groupname].Count)+' items - ' + extractfilename(opendialog1.filename);
end;


 // triggered by clicking on an element
procedure TForm29.doOnShapeClick(sender: TObject; const item: TECShape);
var key,value:string;
begin

 if assigned(map.ShapeBringToFront) then
  map.ShapeBringToFront.width  := map.ShapeBringToFront.width div 2;


  // bring to the forefront
  map.ShapeBringToFront := item;

  item.width     := item.width * 2;

  (*

    we save the state (here the width modication)
    otherwise when the mouse leaves the element width will be reset
    to the state it was when the mouse was positioned on the element.

    You have to do this when you change the appearance of an element
    when you click with the mouse

  *)

  Item.SaveState;


  
 memo1.Lines.Clear;

 memo1.Lines.BeginUpdate;

 // CSV data is stored in PropertyValue
 // Browse them all to view them
 if Item.PropertiesFindFirst(Key, Value) then
  begin
    repeat

      // by default the elements have a propertyValue ecshape which informs its type (marker, poi, line, polygon)
      //  we ignore it
      if Key = 'ecshape' then
        continue;

      memo1.Lines.Add(key+' = '+value);

    until Item.PropertiesFindNext(Key, Value);
  end;


  memo1.Lines.EndUpdate;

  // go to the beginning of the memo
  Memo1.SelStart := 0;
  SendMessage(Memo1.Handle, EM_SCROLLCARET, 0, 0);


end;




procedure TForm29.ValidateEdit(const Edit:TEdit);
begin
 Edit.Color      := clWindow;
 Edit.Font.Color := clwindowText;

 btOpenCsv.enabled := (delimiter.color = clwindow) and
                      (latitude.color = clwindow) and
                      (longitude.color = clwindow);

 lbvalidate.Visible := false;
end;

procedure TForm29.wktFieldsChange(Sender: TObject);
begin
 CSVGroup.csv.FieldNameWKT := wktFields.Text;
 ModifiedEdit(TEdit(sender));
end;

procedure TForm29.ModifiedEdit(const Edit:TEdit);
begin
 Edit.Color := clWindowtext;
 Edit.Font.Color := clwindow;
 btOpenCsv.enabled := false;

 lbvalidate.Top := Edit.Top+edit.Height;
 lbvalidate.Left:= Edit.Left;
 lbValidate.Visible := true;
end;


procedure TForm29.FieldChange(Sender: TObject);
begin
 ModifiedEdit(TEdit(sender));
end;




// fill in the field delimiter
procedure TForm29.delimiterKeyPress(Sender: TObject; var Key: Char);
begin
 if key=#13 then
 begin

  ValidateEdit(TEdit(sender));

  if delimiter.Text<>'' then
     CSVGroup.csv.delimiter := delimiter.Text[1];
 end;

end;

// show / hide labels
procedure TForm29.DisplayLabelClick(Sender: TObject);
begin
  CSVGroup.Markers.Labels.Visible     := DisplayLabel.Checked;
  CSVGroup.Polygones.Labels.Visible   := DisplayLabel.Checked;
  CSVGroup.lines.Labels.Visible   := DisplayLabel.Checked;
end;

// fill in the field that contains the latitude
procedure TForm29.latitudeKeyPress(Sender: TObject; var Key: Char);
begin
 if key=#13 then
 begin
   ValidateEdit(TEdit(sender));
   CSVGroup.csv.FieldNameLatitude := latitude.Text;
 end;
end;

// fill in the field that contains the longitude
procedure TForm29.longitudeKeyPress(Sender: TObject; var Key: Char);
begin
 if key=#13 then
 begin
  ValidateEdit(TEdit(sender));
  CSVGroup.csv.FieldNameLongitude := longitude.Text;
 end;
end;


// update labels with value contain in labelfield

procedure TForm29.LabelFieldKeyPress(Sender: TObject; var Key: Char);
begin
 if key=#13 then
 begin

  ValidateEdit(TEdit(sender));

  CSVGroup.markers.labels.LabelProperty :=  TEdit(sender).Text;
  CSVGroup.polygones.labels.LabelProperty :=  TEdit(sender).Text;
  CSVGroup.lines.labels.LabelProperty :=  TEdit(sender).Text;
 end;
end;


procedure TForm29.FieldsSelect(Sender: TObject);
begin
 CSVGroup.markers.labels.LabelProperty := Fields.Text;
 CSVGroup.polygones.labels.LabelProperty := Fields.Text;
 CSVGroup.lines.labels.LabelProperty := Fields.Text;
end;


end.
