unit Umain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  uecNativeMapControl,uecNativeShape,uecmaputil,
  Vcl.ExtCtrls, Vcl.ComCtrls;

type
  TFormWFS_WMS = class(TForm)
    Panel1: TPanel;
    map: TECNativeMap;
    PageControl1: TPageControl;
    WMS: TTabSheet;
    WFS: TTabSheet;
    Label1: TLabel;
    wfsEndPoint: TEdit;
    wfsGetCapabilities: TButton;
    ListFeature: TListBox;
    Label2: TLabel;
    wmfEndPoint: TEdit;
    wmsGetCapabilities: TButton;
    ListLayer: TListBox;
    procedure FormCreate(Sender: TObject);
    procedure wfsGetCapabilitiesClick(Sender: TObject);
    procedure ListFeatureClick(Sender: TObject);

    procedure wmsGetCapabilitiesClick(Sender: TObject);
    procedure ListLayerClick(Sender: TObject);
    procedure wmfEndPointChange(Sender: TObject);
    procedure wfsEndPointChange(Sender: TObject);
  private
    { Déclarations privées }

    WMS_Layer: TECNativeWMS;
    WFS_Layer: TECNativeWFS;

    procedure doOnCapabilities(Sender: TObject);
    procedure doBeginQuery(Sender: TObject);
    procedure doEndQuery(Sender: TObject);
    procedure doShapeClick(Sender: TObject; const item: TECShape);

  public
    { Déclarations publiques }
  end;

var
  FormWFS_WMS: TFormWFS_WMS;

implementation

{$R *.dfm}

// This demo shows how to manage layer and feature lists on WMS and WFS servers.


procedure TFormWFS_WMS.FormCreate(Sender: TObject);
begin

 // connect events
 map.WMSLayers.OnCapabilities := doOnCapabilities;

 map.WFSLayers.OnCapabilities := doOnCapabilities;
 map.WFSLayers.OnBeginQuery   := doBeginQuery;
 map.WFSLayers.OnEndQuery     := doEndQuery;

 // polygons style
 // weight  = contour thickness
 // color   = contour color
 // fcolor  = fill color
 // hbcolor = mouse-over contour color
 // hcolor  = mouse-over fill color
 map.Styles.addRule('.polygone {weight:1;color:#fdae6b;fcolor:#f03b20;hbcolor:#f03b20;hcolor:#fdae6b;');

 // markers style
 map.Styles.addRule('.marker {width:14;color:#f03b20;bcolor:#feb24c;hbcolor:#f03b20;hcolor:#feb24c;styleIcon:Flat}');

end;


// Request list of WMS server layers
procedure TFormWFS_WMS.wmsGetCapabilitiesClick(Sender: TObject);
begin
 wmsGetCapabilities.Enabled := false;
 ListLayer.Items.Text := 'waiting for data...';
 WMS_Layer.Free;

 // layer creation automatically calls getCapabilities
 // map.WMSLayers.OnCapabilities (doOnCapabilities) is triggered when data is ready
 WMS_Layer := map.WMSLayers.Add(wfsEndPoint.Text);

 WMS_Layer.opacity := 0.7;

 WMS_Layer.Visible := true;

end;

// Request list of WFS server features
procedure TFormWFS_WMS.wfsGetCapabilitiesClick(Sender: TObject);
begin
 wfsGetCapabilities.Enabled := false;
 ListFeature.Items.Text := 'waiting for data...';

 WFS_Layer.Free;

 // layer creation automatically calls getCapabilities
 // map.WFSLayers.OnCapabilities (doOnCapabilities) is triggered when data is ready
 // 'WFS' is the name of the group that will contain the elements.
 WFS_Layer := map.WFSLayers.Add(wfsEndPoint.Text,'','WFS');

 WFS_Layer.Shapes.Clusterable := true;

 // geographic features are loaded all at once,
 // so there are no queries when the visible map area is modified
 WFS_Layer.AutoRefresh := false;

 WFS_Layer.Visible := true;

 // respond to a click on a layer element
 WFS_Layer.OnShapeClick := doShapeClick;
end;




// call when WMS & WFS getcapabilities ready
procedure TFormWFS_WMS.doOnCapabilities(Sender: TObject);
var
  WFSLayer: TECNativeWFS;
  WMSLayer: TECNativeWMS;
  i:integer;
begin

  if Sender is TECNativeWFS then
  begin

    WFSLayer := Sender as TECNativeWFS;
    if assigned(WFSLayer) then
    begin

     ListFeature.Items.BeginUpdate;
     ListFeature.Items.Text := '';

     for i := low(WFSLayer.FeatureTypeList) to High(WFSLayer.FeatureTypeList) do
      ListFeature.items.add(WFSLayer.FeatureTypeList[i].Title);

     ListFeature.Items.EndUpdate;


    end;
  end
  else
  if Sender is TECNativeWMS then
  begin

    WMSLayer := Sender as TECNativeWMS;
    if assigned(WMSLayer) then
    begin

     ListLayer.Items.BeginUpdate;
     ListLayer.Items.Text := '';

     for i := low(WMSLayer.LayersList) to High(WMSLayer.LayersList) do
      ListLayer.items.add(WMSLayer.LayersList[i].Title);

     ListLayer.Items.EndUpdate;


    end;
  end

end;


// Selecting a WFS feature
procedure TFormWFS_WMS.ListFeatureClick(Sender: TObject);
begin
 if assigned(WFS_Layer) and (ListFeature.ItemIndex>-1) and
 (ListFeature.ItemIndex<=High(WFS_Layer.FeatureTypeList)) then
 begin

  WFS_Layer.Shapes.ClusterManager.Hint := WFS_Layer.FeatureTypeList[ListFeature.ItemIndex].Title;

  // request feature
  // map.WFSLayers.OnBeginQuery (doBeginQuery) is called just before the query
  // map.WFSLayers.OnEndQuery (doEndQuery) is called when the requested data is available

  WFS_Layer.Typenames := WFS_Layer.FeatureTypeList[ListFeature.ItemIndex].Name;

  // The elements will be contained in the group defined at creation, here map['WFS'].
 //  The map will be automatically centered to display all elements

 end;

end;


// respond to a click on a feature element
// show properties in a infoWindow
procedure TFormWFS_WMS.doShapeClick(Sender: TObject; const item: TECShape);
var
  Key, Value, content: string;
  win: TECShapeInfoWindow;
begin

  if not assigned(item) then
    exit;

  content := '';
  // extract all properties and their values,
  // enriching them for a more readable display
  if item.PropertiesFindFirst(Key, Value) then
  begin
    repeat
      // if necessary line break
      if content <> '' then
        content := content + '<br>';
      // align the values to 100 pixels
      Key := Key + '<tab=100>';
      // Bold the keys
      content := content + '<b>' + Key + '</b>: ' + Value;
      // continue as long as there are properties
    until item.PropertiesFindNext(Key, Value);
  end;

  if content = '' then
    exit;

  // retrieve the WFSLayer stored in the Data property of the clicked element's group
  if item.Group.Data is TECNativeWFS then
  begin
    // we use its infoWindow, but we could use any infoWindow,
    // in which case we'd have to ensure that its group ZIndex is greater than that of the WFSLayer
    win := TECNativeWFS(item.Group.Data).InfoWindow;
    win.content := content;
    win.SetPosition(map.MouseLatLng.Lat, map.MouseLatLng.lng);
    win.Visible := true;
  end;

end;

// fired before request feature
procedure TFormWFS_WMS.doBeginQuery(Sender: TObject);
begin
  ListFeature.enabled := false;
end;

// fired when feature are ready
procedure TFormWFS_WMS.doEndQuery(Sender: TObject);
begin
 ListFeature.enabled := true;
end;

// Selecting a WMS layer
procedure TFormWFS_WMS.ListLayerClick(Sender: TObject);
var rLayer : TECRecordLayer;
begin
if assigned(WMS_Layer) and (ListLayer.ItemIndex>-1) and
 (ListLayer.ItemIndex<=High(WMS_Layer.LayersList)) then
 begin

  rLayer :=  WMS_Layer.LayersList[ListLayer.ItemIndex];

  WMS_Layer.Shapes.ClusterManager.Hint := rLayer.Title;
  WMS_Layer.layers := rLayer.Name;

  // Center the map on the area managed by the layer
  map.Bounds(rLayer);
 end;

end;




procedure TFormWFS_WMS.wfsEndPointChange(Sender: TObject);
begin
    wfsGetCapabilities.Enabled := pos('http',trim(wfsEndPoint.text))>0;;
end;

procedure TFormWFS_WMS.wmfEndPointChange(Sender: TObject);
begin
   wmsGetCapabilities.Enabled := pos('http',trim(wmfEndPoint.text))>0;
end;









end.
