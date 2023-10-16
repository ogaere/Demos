unit UMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uecNativeMapControl, Vcl.StdCtrls, Vcl.ExtCtrls,
  uecNativeShape,uecmaputil;

type
  TFormWMS_WFS = class(TForm)
    Panel1: TPanel;
    pn_events: TPanel;
    events: TMemo;
    map: TECNativeMap;
    gbTiles: TGroupBox;
    rbOSM: TRadioButton;
    rbTopoWMS: TRadioButton;
    ckOverlayWMS: TCheckBox;
    gbWMSLayers: TGroupBox;
    pnLegend: TPanel;
    ckLegend: TCheckBox;
    cbLegendPosition: TComboBox;
    ckRadar: TCheckBox;
    ckCadastre: TCheckBox;
    btClearWMSLayers: TButton;
    GroupBox1: TGroupBox;
    ckOilGas: TCheckBox;
    procedure rbOSMClick(Sender: TObject);
    procedure rbTopoWMSClick(Sender: TObject);
    procedure ckOverlayWMSClick(Sender: TObject);

    procedure ckLegendClick(Sender: TObject);
    procedure cbLegendPositionChange(Sender: TObject);


    procedure ckRadarClick(Sender: TObject);
    procedure ckCadastreClick(Sender: TObject);
    procedure btClearWMSLayersClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ckOilGasClick(Sender: TObject);
  private
    { Déclarations privées }
    FOverlayWMS : TECOverlayTileLayer;
    WMS_Layer_Radar,
    WMS_Layer_Cadastre : TECNativeWMS ;

    WFS_Layer_OilGas : TECNativeWFS;

    procedure doShapeClick(sender: TObject; const item: TECShape);

    procedure doBeginQuery(sender : TObject);
    procedure doEndQuery(sender : TObject);
    procedure doGraphicLegend(sender : TObject);
  public
    { Déclarations publiques }
  end;

var
  FormWMS_WFS: TFormWMS_WFS;

implementation

{$R *.dfm}



procedure TFormWMS_WFS.FormCreate(Sender: TObject);
begin
 // connect WMS events
 map.WMSLayers.OnBeginQuery    := doBeginQuery;
 map.WMSLayers.OnEndQuery      := doEndQuery;
 map.WMSLayers.OnGraphicLegend := doGraphicLegend;
 // connect WFS events
 map.WFSLayers.OnBeginQuery    := doBeginQuery;
 map.WFSLayers.OnEndQuery      := doEndQuery;
end;



//  ---------- WMS Tiles server

procedure TFormWMS_WFS.rbOSMClick(Sender: TObject);
begin
 // classic OSM tiles no WMS
 map.TileServer := tsOSM; // use uecMapUtil
end;


procedure TFormWMS_WFS.rbTopoWMSClick(Sender: TObject);
begin
 //  url to the WMS service
 //  you can stack several layers, separating them with a comma : 'TOPO-WMS,OSM-Overlay-WMS'
 map.TileServerWMS('https://ows.mundialis.de/services/service','TOPO-WMS');

 map.CopyrightTile := 'Topographic WMS - by terrestris';
 map.Zoom := 7;
end;





procedure TFormWMS_WFS.ckOverlayWMSClick(Sender: TObject);
begin
 if ckOverlayWMS.Checked then
 //  url to the WMS service
 //  you can stack several layers, separating them with a comma : 'SRTM30-Contour,,OSM-Overlay-WMS'
   FOverlayWMS := map.AddOverlayTileServerWMS('https://ows.mundialis.de/services/service','OSM-Overlay-WMS')
 else
  map.RemoveOverlayTiles(FOverlayWMS);
end;

// =====


// ----------- WMS Layer ---------------------------------------------------------------------------

procedure TFormWMS_WFS.ckRadarClick(Sender: TObject);
begin

 if ckRadar.Checked then
 begin
  map.address := 'deutschland';
  map.Zoom    := 6;

  if not assigned(WMS_Layer_Radar) then
    WMS_Layer_Radar := map.WMSLayers.Add('https://maps.dwd.de/geoserver/ows',  // url service
                                         'dwd:Niederschlagsradar', // layer
                                         'RADAR' // TECNativeMap group name
                                         );

  WMS_Layer_Radar.Version := '1.1.1';
  WMS_Layer_Radar.ZIndex := 20;

  ckLegendClick(ckLegend);

 end ;

 WMS_Layer_Radar.Visible := ckRadar.Checked;
 pnLegend.Enabled        := WMS_Layer_Radar.Visible;


end;




// hide / show WMS legend
procedure TFormWMS_WFS.ckLegendClick(Sender: TObject);
begin

  WMS_layer_Radar.Legend := ckLegend.Checked;
  // opacity 0..100
  WMS_layer_Radar.LegendOpacity  := 75;

  cbLegendPositionChange(cbLegendPosition);

end;

// change the position of the legend

procedure TFormWMS_WFS.cbLegendPositionChange(Sender: TObject);
begin
  case cbLegendPosition.ItemIndex of
   0: WMS_layer_Radar.LegendPosition := lpTopLeft;
   1: WMS_layer_Radar.LegendPosition := lpTopRight;
   2: WMS_layer_Radar.LegendPosition := lpBottomLeft;
   3: WMS_layer_Radar.LegendPosition := lpBottomRight;
   4: WMS_layer_Radar.LegendPosition := lpTopCenter;
   5: WMS_layer_Radar.LegendPosition := lpBottomCenter;
   6: WMS_layer_Radar.LegendPosition := lpLeftCenter;
   7: WMS_layer_Radar.LegendPosition := lpRightCenter;
  end;
end;


procedure TFormWMS_WFS.ckCadastreClick(Sender: TObject);
begin

 if ckCadastre.Checked then
 begin
  map.address := 'Rennes, France';
  map.Zoom    := 18;

  if not assigned(WMS_Layer_Cadastre) then
    WMS_Layer_Cadastre := map.WMSLayers.Add('https://geobretagne.fr/geoserver/cadastre/wms', // url service
                                             'CP.CadastralParcel', // layer
                                             'CADASTRE' // TECNativeMap group name
                                             );

  WMS_Layer_Cadastre.ZIndex := 10;


 end ;

 WMS_Layer_Cadastre.Visible := ckCadastre.Checked;
end;


// delete all WMS layers
procedure TFormWMS_WFS.btClearWMSLayersClick(Sender: TObject);
begin

  ckCadastre.Checked := false;
  ckRadar.Checked    := false;

  // delete layers
  map.WMSLayers.Clear;

  WMS_Layer_Cadastre := nil;
  WMS_layer_Radar    := nil;
  pnLegend.Enabled   := false;
end;


// =====


// ----------- WFS Layers

procedure TFormWMS_WFS.ckOilGasClick(Sender: TObject);
begin

 if ckOilGas.Checked then
 begin

   if not assigned(WFS_Layer_OilGas) then
   begin
    WFS_Layer_OilGas := map.WFSLayers.Add(
                       'https://geoserver.geoplatform.gov/geoserver/ngda/ows',  // url service
                       'ngda:4c013425_24dd_4d6d_926e_1283a4a65894' // layer
                       ,'Oil&GAS' // TECNativeMap group name
                       );
    // respond to a click on a layer element
    WFS_Layer_OilGas.OnShapeClick  := doShapeClick;

    // By default, all wells will be red, except for abandoned wells, which will be black.
    map.Styles.addRule('#Oil&GAS.marker {color:light(red,96);hcolor:red}');
    // for discontinued products,
    // we set a smaller zindex so that they are displayed under active products
    map.Styles.addRule('#Oil&GAS.marker.status_description:Permanently Abandoned {color:gray;hcolor:black;zindex:-1;}');
   end;

   WFS_Layer_OilGas.MaxFeature := 1000;


   map.Zoom := 6;
   map.address := 'Gulf of mexico';

  end;

  WFS_Layer_OilGas.Visible := ckOilGas.Checked;
end;


// respond to a click on a layer element
procedure TFormWMS_WFS.doShapeClick(sender: TObject; const item: TECShape);
var Key, Value, content: string;
    win: TECShapeInfoWindow;
begin


  if not assigned(item) then exit;

   content := '';
  // extract all properties and their values,
  // enriching them for a more readable display
  if item.PropertiesFindFirst(Key, Value) then
  begin
    repeat
      // if necessary line break
      if content<>'' then content := content+'<br>';
      // align the values to 100 pixels
      Key := Key + '<tab=100>';
      // Bold the keys
      content := content + '<b>' + Key + '</b>: ' + Value ;
    // continue as long as there are properties
    until item.PropertiesFindNext(Key, Value);
  end;

  if content='' then exit;

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




// --------------   Events   WMS & WFS Layers
procedure TFormWMS_WFS.doBeginQuery(sender : TObject);
var WMSLayer : TECNativeWMS;
    WFSLayer : TECNativeWFS;
begin

 if events.lines.count>50 then
  events.lines.clear;

 if sender is TECNativeWMS then
 begin

   WMSLayer := sender as TECNativeWMS;
  if assigned(WMSLayer) then
   events.lines.Add('BEGIN QUERY : '+WMSLayer.Name) ;
 end
 else
 if sender is TECNativeWFS then
 begin

   WFSLayer := sender as TECNativeWFS;
  if assigned(WFSLayer) then
   events.lines.Add('BEGIN QUERY : '+WFSLayer.Name) ;
 end

end;

procedure TFormWMS_WFS.doEndQuery(sender : TObject);
var WMSLayer : TECNativeWMS;
    WFSLayer : TECNativeWFS;
begin

 if sender is TECNativeWMS then
 begin
   WMSLayer := sender as TECNativeWMS;

   if assigned(WMSLayer) then
     events.lines.Add('END QUERY : '+WMSLayer.Name);
 end
 else
 if sender is TECNativeWFS then
 begin

   WFSLayer := sender as TECNativeWFS;
  if assigned(WFSLayer) then
  begin
    events.lines.Add('END QUERY : '+WFSLayer.Name) ;
  end;
 end

end;

procedure TFormWMS_WFS.doGraphicLegend(sender : TObject);
var WMSLayer : TECNativeWMS;
begin

 WMSLayer := sender as TECNativeWMS;

 if assigned(WMSLayer) then
  events.lines.Add('GRAPHIC LEGEND OK : '+WMSLayer.Name);

end;






end.
