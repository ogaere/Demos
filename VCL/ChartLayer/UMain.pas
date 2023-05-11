unit UMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls,

  uecNativeMapControl, uecmaputil, uecNativeShape;

type
  TFormChartLayer = class(TForm)
    Panel1: TPanel;
    map: TECNativeMap;
    layers: TComboBox;
    addLayer: TButton;
    Delete: TButton;
    procedure addLayerClick(Sender: TObject);
    procedure layersChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure DeleteClick(Sender: TObject);
  private
    { Déclarations privées }
    /// trigger on layer change
    procedure doOnChangeLayers(Sender: TObject);
    /// trigger when clicking on a chart
    procedure doOnClick(Sender: TObject; const item: TECShape);
    /// trigger when right clicking on a chart
    procedure doOnRightClick(Sender: TObject; const item: TECShape);


  public
    { Déclarations publiques }
    TotalLayer : integer;
  end;

var
  FormChartLayer: TFormChartLayer;

implementation

{$R *.dfm}

const
  // from https://colorbrewer2.org
  palettes : array [0..2]of array [0..7] of string = (
    ('#7fc97f','#beaed4','#fdc086','#ffff99','#386cb0','#f0027f','#bf5b17','#666666'),
    ('#d53e4f','#f46d43','#fdae61','#fee08b','#e6f598','#abdda4','#66c2a5','#3288bd'),
    ('#66c2a5','#fc8d62','#8da0cb','#e78ac3','#a6d854','#ffd92f','#e5c494','#b3b3b3')

    );

// change default hint legend
procedure doOnValideHint(const Sender: TECChartItem; const index: integer;
  const percent, value: double; var hint: string);
begin

  // a positive index indicates a data line
  if index>-1 then

  hint := Sender.Layer.Fields[index].Legend + ' : ' + doubletostrdigit(percent,
    1) + ' % (' + doubletostr(value) + ')'

  else // -1 indicates that the legend is complete, you can enrich it

  Hint := '<h3><center>'+sender.Layer.Caption+'</center></h3>'+
           hint+
           '<h4><center>Chart n°'+inttostr(sender.Shape.IndexOf)+'</center></h4>';

end;

// create random layer
procedure TFormChartLayer.addLayerClick(Sender: TObject);
var
  Lat, Lng: double;
  x, y, i,id_pal, delta_lat, delta_lng: integer;

  s: string;

  FChartLayer: TECChartLayer;
  FChartType: TECChartType;
  chart: TECChartItem;

  begin

  Randomize;



  // cycle chart type
  case tag of
    0:
      begin
        FChartType := ctPie;
        s := 'Pie';
      end;
    1:
      begin
        FChartType := ctDonut;
        s := 'Donut';
      end;
    2:
      begin
        FChartType := ctFillDonut;
        s := 'FillDonut';
      end;
    3:
      begin
        FChartType := ctVerticalStackedBar;
        s := 'VerticalStackedBar';
      end;
    else
      begin
        FChartType := ctHorizontalStackedBar;
        s := 'HorizontalStackedBar';
      end;

  end;


  tag := tag + 1;
  if tag>4 then tag := 0;


  // create layer
  FChartLayer := map.ChartLayers.Add(s + ' ' + timeTosTr(time));

  inc(TotalLayer);
  FChartLayer.Caption := 'Title Chart Layer ' + inttostr(TotalLayer);


  // adapt the graph legend
  FChartLayer.OnValidHint := doOnValideHint;

  // create random datas

  // select palette
  id_pal := random(3);

  // between 4 and 8 lines of data
  for i := 0 to 3 + random(5) do
    FChartLayer.AddField('Data ' + chr(i + ord('A')), StrToColor(palettes[id_pal][i]));


  FChartLayer.ChartType := FChartType;

  // labels will be displayed for zoom 3 and more
  FChartLayer.Labels.MinZoom := 3;

  if FChartLayer.ChartType < ctVerticalStackedBar then
  begin
    // max radius 50
    FChartLayer.MaxChartSize := 50;
    FChartLayer.Labels.Align := laCenter;
  end
  else // stacked bar
  begin
    // max bar size 100
    FChartLayer.MaxChartSize := 100;
    FChartLayer.Labels.Align := laBottom;
  end;

  FChartLayer.MinChartSize := 16;

  // distribute 4 * 4 graphs on the visible surface of the map
  delta_lat := round(((map.NorthEastLatitude  - map.SouthWestLatitude)  * 1000));
  delta_lng := round(((map.NorthEastLongitude - map.SouthWestlongitude) * 1000));

  for y := 0 to 3 do
  begin

    for x := 0 to 3 do
    begin

      Lat := map.SouthWestLatitude  + (random(delta_lat) / 1000);
      Lng := map.SouthWestlongitude + (random(delta_lng) / 1000);

      // create chart
      chart := FChartLayer.Add(Lat, Lng);

      // add ramdom value
      // automatically sets the 'total' propertie
      for i := low(FChartLayer.Fields) to High(FChartLayer.Fields) do
        chart.data[i] := random(100) + random(99);

    end;
  end;

  // generate the elements on the map
  FChartLayer.Update;

  // zoom it
  FChartLayer.fitBounds;

  layers.ItemIndex := layers.Items.Count - 1;
  Delete.Enabled   := true;


end;

// click on chart
procedure TFormChartLayer.doOnClick(Sender: TObject; const item: TECShape);
begin
caption := 'Click Left - '+TECchartLayer(Sender).Name +
           ' : Chart n°'+inttostr(item.IndexOf)+' Total =' + item['total'] ;
// if needed you can access TECChartItem with TECChartItem(item.item)
end;

// right click on chart
procedure TFormChartLayer.doOnRightClick(Sender: TObject; const item: TECShape);
begin
   caption := 'Click Right - '+TECchartLayer(Sender).Name +
           ' : Chart n°'+inttostr(item.IndexOf)+' Total =' + item['total'] ;
end;


procedure TFormChartLayer.FormCreate(Sender: TObject);
begin

  map.ChartLayers.OnChange := doOnChangeLayers;
  map.ChartLayers.OnClick := doOnClick;
  map.ChartLayers.OnRightClick := doOnRightClick;

  // The size of the diagrams will also be adapted according to the zoom
  map.ScaleMarkerToZoom := true;

  tag        := 0;
  TotalLayer := 0;

end;

// event triggered after add or delete TECBubbleLayer
procedure TFormChartLayer.DeleteClick(Sender: TObject);
begin
  map.ChartLayers.Delete(layers.ItemIndex);
end;

procedure TFormChartLayer.doOnChangeLayers(Sender: TObject);
begin
  map.ChartLayers.getLayers(layers.Items);
  Delete.Enabled := layers.ItemIndex > -1;
end;

procedure TFormChartLayer.layersChange(Sender: TObject);
var
  FChartLayer: TECChartLayer;
begin
  FChartLayer := map.ChartLayers.List[layers.ItemIndex];
  if assigned(FChartLayer) then
  begin
    // zoom for show all charts
    FChartLayer.fitBounds;
  end;

  Delete.Enabled := layers.ItemIndex > -1;

end;


end.
