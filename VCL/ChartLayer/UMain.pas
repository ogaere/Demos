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
  end;

var
  FormChartLayer: TFormChartLayer;

implementation

{$R *.dfm}

const
  // from https://colorbrewer2.org
  palette : array[0..7] of string = ('#7fc97f','#beaed4','#fdc086','#ffff99','#386cb0','#f0027f','#bf5b17','#666666');

// change default hint legend
procedure doOnValideHint(const Sender: TECChartItem; const index: integer;
  const percent, value: double; var hint: string);
begin
  hint := Sender.Layer.Fields[index].Legend + ' : ' + doubletostrdigit(percent,
    1) + ' % (' + doubletostr(value) + ')';
end;

// create random layer
procedure TFormChartLayer.addLayerClick(Sender: TObject);
var
  Lat, Lng: double;
  x, y, i, delta_lat, delta_lng: integer;

  s: string;

  FChartLayer: TECChartLayer;
  FChartType: TECChartType;
  chart: TECChartItem;

  begin

    Randomize;

   // random chart type
  case random(5) of
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

  FChartLayer := map.ChartLayers.Add(s + ' ' + timeTosTr(time));

  // adapt the graph legend
  FChartLayer.OnValidHint := doOnValideHint;

  // create random datas

  for i := 0 to 3 + random(5) do
    FChartLayer.AddField('Data ' + chr(i + ord('A')), StrToColor(palette[i]));


  FChartLayer.ChartType := FChartType;


  if FChartLayer.ChartType < ctVerticalStackedBar then
  begin
    // max radius 50
    FChartLayer.MaxChartSize := 50;
    FChartLayer.Labels.Align := laCenter;
  end
  else
  begin
    // max bar size 100
    FChartLayer.MaxChartSize := 100;
    FChartLayer.Labels.Align := laBottom;
  end;

  FChartLayer.MinChartSize := 16;

  // distribute 4 * 4 graphs on the visible surface of the map
  delta_lat := round(((map.NorthEastLatitude - map.SouthWestLatitude) * 1000));
  delta_lng := round(((map.NorthEastLongitude - map.SouthWestlongitude)
    * 1000));

  for y := 0 to 3 do
  begin

    for x := 0 to 3 do
    begin

      Lat := map.SouthWestLatitude + (random(delta_lat) / 1000);
      Lng := map.SouthWestlongitude + (random(delta_lng) / 1000);

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


end;

// click on chart
procedure TFormChartLayer.doOnClick(Sender: TObject; const item: TECShape);
begin
caption := TECchartLayer(Sender).Name + ' : ' + item['total'] ;
// if needed you can access TECChartItem with TECChartItem(item.item)
end;

// right click on chart
procedure TFormChartLayer.doOnRightClick(Sender: TObject; const item: TECShape);
begin
   caption := TECchartLayer(Sender).Name + ' : ' + item['total'] + ' (Right)';
end;


procedure TFormChartLayer.FormCreate(Sender: TObject);
begin
  map.ChartLayers.OnChange := doOnChangeLayers;
  map.ChartLayers.OnClick := doOnClick;
  map.ChartLayers.OnRightClick := doOnRightClick;
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
