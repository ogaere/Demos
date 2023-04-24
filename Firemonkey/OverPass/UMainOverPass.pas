unit UMainOverPass;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.ScrollBox, FMX.Memo, FMX.Objects,
  FMX.uecNativeMapControl, FMX.uecnativeShape, FMX.uecMapUtil,
  FMX.TabControl, FMX.Memo.Types, FMX.Edit;

type
  TFormOverPass = class(TForm)
    pLeft: TPanel;
    spl1: TSplitter;
    pright: TPanel;
    lbl1: TLabel;
    query: TMemo;
    tabmapdata: TTabControl;
    tmap: TTabItem;
    tdata: TTabItem;
    map: TECNativeMap;
    mmomdata: TMemo;
    btnExecQuery: TButton;
    lbl2: TLabel;
    lbl_count_query: TLabel;
    LayerAniIndicator: TAniIndicator;
    Panel1: TPanel;
    btRestaurants: TButton;
    btStreets: TButton;
    Panel2: TPanel;
    Rectangle1: TRectangle;
    edKey: TEdit;
    btTAg: TButton;
    Label1: TLabel;
    Label2: TLabel;
    edValue: TEdit;
    ckIsoChrone: TCheckBox;
    ClearMap: TButton;
    procedure FormCreate(Sender: TObject);
    procedure btnExecQueryClick(Sender: TObject);
    procedure mapMapSelectRect(sender: TObject; const SWLat, SWLng, NELat,
      NELng: Double);
    procedure mapShapeClick(sender: TObject; const item: TECShape);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure btRestaurantsClick(Sender: TObject);
    procedure btStreetsClick(Sender: TObject);
    procedure btTAgClick(Sender: TObject);
    procedure ClearMapClick(Sender: TObject);


  private
    { Déclarations privées }

   _NELat, _NELng, _SWLat, _SWLng: double ;

   FLast_Data : string;
   FTotal_Query : Integer;

   procedure InfoAddQuery;
   procedure doOverPass(const value:TECOverPassData);

  public
    { Déclarations publiques }
  end;

var
  FormOverPass: TFormOverPass;

implementation

{$R *.fmx}

// script query
procedure TFormOverPass.btnExecQueryClick(Sender: TObject);
var q:string;
begin

  InfoAddQuery;

 // output only in osm xml, no json
 q := StringReplace(query.Text, '[out:json]','', [rfReplaceAll, rfIgnoreCase]) ;
 // excute query in thread, doOverPass fired when data ready
 map.OverPassApi.Query(q);
end;



procedure TFormOverPass.mapMapSelectRect(sender: TObject; const SWLat, SWLng,
  NELat, NELng: Double);
begin

 InfoAddQuery;
 // no polygone filter
  map.OverPassApi.FilterPolygone := nil;
 // excute query in thread, doOverPass fired when data ready
 map.OverPassApi.Data(SWLat, SWLng, NELat, NELng);
end;


// a query is ready
procedure TFormOverPass.btRestaurantsClick(Sender: TObject);
begin
 InfoAddQuery;
 // all screen no polygone filter
 map.OverPassApi.FilterPolygone := nil;
 map.OverPassApi.Amenity('restaurant');
end;

procedure TFormOverPass.btStreetsClick(Sender: TObject);
begin
 InfoAddQuery;
 // all screen no polygone filter
 map.OverPassApi.FilterPolygone := nil;
 map.OverPassApi.Streets;
end;

procedure TFormOverPass.btTAgClick(Sender: TObject);
begin
  InfoAddQuery;

  if ckIsoChrone.IsChecked then
  begin
    map['isochrone'].polygones.Clear;
    // within 10 minutes walking distance (see https://www.helpandweb.com/ecmap/en/roads.htm#ISOCHRONE)
    map.routing.IsoChrone.Time(map.latitude,map.longitude,map['isochrone'].polygones,[10])  ;

    if map['isochrone'].polygones.Count>0 then
     map.OverPassApi.FilterPolygone := map['isochrone'].polygones[0];

  end
  else
  map.OverPassApi.FilterPolygone := nil;


  map.OverPassApi.tag(edKey.text,edValue.text);
end;

procedure TFormOverPass.ClearMapClick(Sender: TObject);
begin
 map.Clear;
end;

procedure TFormOverPass.doOverPass(const value:TECOverPassData);
begin

  lbl_count_query.Text := 'Pending query : '+inttostr(map.OverPassApi.PendingQuery)+' / '+inttostr(FTotal_Query);


  // import osm xml in default group
  map.Shapes.LoadFromOSMString(value.Data);

 if map.OverPassApi.PendingQuery=0 then
 begin
  LayerAniIndicator.Visible := false;
  LayerAniIndicator.Enabled := false;
 end;

  mmomdata.Lines.BeginUpdate;
  mmomdata.Lines.Text := value.Data;
  mmomdata.Lines.EndUpdate;

 
end;


procedure TFormOverPass.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
 canClose := map.OverPassApi.PendingQuery = 0;

 if not canClose then
  showmessage('Wait for current requests before leaving');
end;

procedure TFormOverPass.FormCreate(Sender: TObject);
begin

 // grey scale use uecMapUtil
 map.ColorFilter.filter := fcGrey;

 caption := 'Test OverPass API - © ' + inttostr(CurrentYear) + ' E. Christophe';


{$IFDEF MSWINDOWS}
 map.LocalCache := ExtractfilePath(ParamStr(0)) + 'cache';
{$ELSE}
 map.LocalCache := TPath.Combine(TPath.GetSharedDocumentsPath, 'cache');
{$ENDIF}

 // fired when OSM data is ready
 map.OverPassApi.OnData := doOverPass;

  map['isochrone'].ZIndex := -10;

// map.OverPassApi.Url := 'https://overpass.kumi.systems/api/interpreter';

 // redefine the style of points of interest to make them more visible
 map.styles.addRule('.marker {scale:0-10=0.7,11-15=0.8,16-17=0.95,18-20=1;width:16;height:16;visible:true;styleicon:Flat;color:@orange}');


  // style restaurant
  map.styles.addRule('.marker.amenity:restaurant ' +
    '{scale:1;graphic:base64,iVBORw0KGgoAAAANSUhEUgAAABIAAAAaBAMAAABI' +
    'sxEJAAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAABJQTFRFAAAA////AAAAAAA'
    + 'AAAAAAAAA/h6U3wAAAAV0Uk5TAAAQgL++EJOXAAAAOElEQVQY02MIFQ0MFWRUCXVigLBcQ0OgrNDQUH'
    + 'JYQIDOMg0NDYawBIFC2FgCSCxBerFMg0Es02AAP34wMx8/aIAAAAAASUVORK5CYII=;visible:true;}');


  map.Styles.addRule('#isochrone.polygone {penStyle:dash;fopacity:10}');


 LayerAniIndicator.Visible := false;
 LayerAniIndicator.Enabled := false;

 FTotal_Query := 0;


end;



// click on shape, show osm property
procedure TFormOverPass.mapShapeClick(sender: TObject; const item: TECShape);
var

  Key, Value, content: string;

  win: TECShapeInfoWindow;
begin

  content := '<h3>OpenStreetMap Data</h3><br>';

  if item.PropertiesFindFirst(Key, Value) then
  begin
    repeat

      Key := Key + '<tab="110">';

      content := content + '<b>' + Key + '</b>: ' + Value + '<br>';

    until item.PropertiesFindNext(Key, Value);
  end;

  // create window if not exists
  if map.group['info'].InfoWindows.count = 0 then
  begin
    map.group['info'].InfoWindows.add(0, 0, '');

    win := map.group['info'].InfoWindows[0];
    win.Zindex := 100;
    win.Width := 320;
    map.group['info'].Zindex := map.shapes.Zindex + 1;

  end
  else
    win := map.group['info'].InfoWindows[0];

  win.content := content;
  win.SetPosition(map.MouseLatLng.Lat, map.MouseLatLng.lng);
  win.Visible := true;

  // automatically close the window after 15 seconds
  win.Animation := TECAnimationAutoHide.Create;
  TECAnimationAutoHide(win.Animation).MaxTiming := 1000 * 15;
end;



// update label with query count
procedure TFormOverPass.InfoAddQuery;
begin


 LayerAniIndicator.Visible := true;
 LayerAniIndicator.Enabled := true;

 Inc(FTotal_Query);

 lbl_count_query.Text := 'Pending query : '+inttostr(map.OverPassApi.PendingQuery)+' / '+inttostr(FTotal_Query);

end;


end.
