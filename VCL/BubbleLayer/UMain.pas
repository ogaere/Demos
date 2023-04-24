unit UMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  uecNativeMapControl, uecNativeShape, uecMapUtil,
  Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.Mask, Vcl.Samples.Gauges, Vcl.ComCtrls;

type
  TForm10 = class(TForm)
    Panel1: TPanel;
    map: TECNativeMap;
    addLayer: TButton;
    layers: TComboBox;
    Delete: TButton;
    ckColorPalette: TCheckBox;
    ColorListBox: TColorListBox;
    MinItemSize: TLabeledEdit;
    MaxItemSize: TLabeledEdit;
    trOpacity: TTrackBar;
    Label1: TLabel;
    UpdateOptions: TButton;
    procedure FormCreate(Sender: TObject);
    procedure addLayerClick(Sender: TObject);
    procedure layersChange(Sender: TObject);
    procedure DeleteClick(Sender: TObject);
    procedure UpdateOptionsClick(Sender: TObject);

  private
    { Déclarations privées }

    procedure doOnEditBubble(const BubbleShape: TECShapePoi);
    procedure doOnClick(Sender: TObject; const item: TECShape);
    procedure doOnRightClick(Sender: TObject; const item: TECShape);

    procedure doOnChangeLayers(Sender: TObject);

    procedure Add_5_Most_Populated_FR_cities;

    procedure setLayerOptions(FBubbleLayer: TECBubbleLayer);
    procedure getLayerOptions(FBubbleLayer: TECBubbleLayer);

    procedure setEnabledButton(const value: boolean);

  public
    { Déclarations publiques }
  end;

var
  Form10: TForm10;

implementation

{$R *.dfm}

procedure TForm10.FormCreate(Sender: TObject);
begin

  map.MinZoom := 3;

  map.BubbleLayers.Color := clGreen;
  map.BubbleLayers.OnEditBubble := doOnEditBubble;
  map.BubbleLayers.OnClick := doOnClick;
  map.BubbleLayers.OnRightClick := doOnRightClick;
  map.BubbleLayers.OnChange := doOnChangeLayers;

  MaxItemSize.Text := IntToStr(map.BubbleLayers.MaxItemSize);
  MinItemSize.Text := IntToStr(map.BubbleLayers.MinItemSize);

  trOpacity.Position := map.BubbleLayers.Opacity;

  Add_5_Most_Populated_FR_cities;

end;

// Attention each request of localization makes an Internet request,
// in the cumulated it takes time
// the best is to use directly the GPS coordinates
// here it is used for documentation purposes
procedure TForm10.Add_5_Most_Populated_FR_cities;
var
  FBubbleLayer: TECBubbleLayer;
begin

  FBubbleLayer := map.BubbleLayers.Add('5 Most Populated FR cities');
  // Global Hint where the properties of each element will be injected
  FBubbleLayer.Hint := '[size] inhabitants in [location] in 2020';
  // the color will be determined according to the size using the layer's color palette
  FBubbleLayer.UseColorPalette := true;
  // the size of the elements will be scaled between 60 and 100 pixels depending on size
  FBubbleLayer.MinItemSize := 60;
  FBubbleLayer.MaxItemSize := 100;
  // labels will be displayed for zoom 5 and more
  FBubbleLayer.Labels.MinZoom := 5;
  // the label will be composed of the properties 'location' and 'size'
  FBubbleLayer.Labels.LabelMask := '[location]' + #13#10 + '[size]';
  FBubbleLayer.Labels.LabelType := ltMask;

  // the position of the bubbles is determined by their location
  // its size by the number of inhabitants
  FBubbleLayer.Add('Paris,FR', 2145906);
  FBubbleLayer.Add('Marseille,FR', 870321);
  FBubbleLayer.Add('Lyon,FR', 522228);
  FBubbleLayer.Add('Toulouse,FR', 498003);
  FBubbleLayer.Add('Nice,FR', 343477);

  // Add('location',size) automatically sets the 'location' and 'size' properties
  // you can add properties with these two syntaxes
  // var bubble:TECBubbleItem;
  // bubble :=  FBubbleLayer.Add('Paris,FR',2145906,'prop1=data1,prop2=data2');
  // bubble['propx'] := 'datax';

  // update of the layer display
  FBubbleLayer.Update;
  // zoom in to show all elements
  FBubbleLayer.fitBounds;

end;

procedure TForm10.addLayerClick(Sender: TObject);
var
  Lat, Lng, size: double;
  x, y: integer;

  dx, dy: double;

  FBubbleLayer: TECBubbleLayer;
  bubble: TECBubbleItem;
begin

  FBubbleLayer := map.BubbleLayers.Add('Layer ' + timeTosTr(time));

  // another way to display the hint, here the title property of the element will be used
  FBubbleLayer.HintProperty := 'title';

  FBubbleLayer.Labels.MinZoom := 5;

  // default
  FBubbleLayer.Shape := poiEllipse;

  setLayerOptions(FBubbleLayer);

  dy := (map.NorthEastLatitude - map.SouthWestLatitude) / 2;
  dx := (map.NorthEastLongitude - map.SouthWestlongitude) / 2;

  size := 10;

  for y := 0 to 4 do
  begin

    for x := 0 to 4 do
    begin

      Lat := map.latitude - dy + (random(round(dy * 1000)) / 1000);
      Lng := map.longitude - dx + (random(round(dx * 1000)) / 1000);

      // Add(lat,lng,size) automatically sets the 'size' propertie
      bubble := FBubbleLayer.Add(Lat, Lng, size);
      // title will serve as a tooltip
      bubble['title'] := 'Bubble ' + IntToStr(FBubbleLayer.Count + 1) + #13#10 +
        'size [size]';

      size := size + 10;

    end;
  end;

  FBubbleLayer.Update;
  FBubbleLayer.fitBounds;

  layers.ItemIndex := layers.Items.Count - 1;
  setEnabled(true);

end;

procedure TForm10.DeleteClick(Sender: TObject);
begin
  map.BubbleLayers.Delete(layers.ItemIndex);
end;

procedure TForm10.UpdateOptionsClick(Sender: TObject);
var
  FBubbleLayer: TECBubbleLayer;
begin
  FBubbleLayer := map.BubbleLayers.List[layers.ItemIndex];
  if assigned(FBubbleLayer) then
  begin
    setLayerOptions(FBubbleLayer);
    // redraw layer with new options
    FBubbleLayer.Update;
  end;

end;

procedure TForm10.setLayerOptions(FBubbleLayer: TECBubbleLayer);
begin

  if not assigned(FBubbleLayer) then
    exit;

  FBubbleLayer.Color := ColorListBox.Selected;
  FBubbleLayer.UseColorPalette := ckColorPalette.Checked;

  FBubbleLayer.MaxItemSize := StrToInt(MaxItemSize.Text);
  FBubbleLayer.MinItemSize := StrToInt(MinItemSize.Text);

  FBubbleLayer.Opacity := trOpacity.Position;

end;

procedure TForm10.getLayerOptions(FBubbleLayer: TECBubbleLayer);
begin

  if not assigned(FBubbleLayer) then
    exit;

  ColorListBox.Selected := FBubbleLayer.Color;
  ckColorPalette.Checked := FBubbleLayer.UseColorPalette;

  MaxItemSize.Text := IntToStr(FBubbleLayer.MaxItemSize);
  MinItemSize.Text := IntToStr(FBubbleLayer.MinItemSize);

  trOpacity.Position := FBubbleLayer.Opacity;

end;

// click on bubble
procedure TForm10.doOnClick(Sender: TObject; const item: TECShape);
var Hint:string;
begin
 Hint := Item.Hint;
 if Hint='' then
   Hint := TECBubbleLayer(Sender).Hint;

 caption := TECBubbleLayer(Sender).Name + ' : ' + item.PropertyFormat(Hint);
end;

// right click on bubble
procedure TForm10.doOnRightClick(Sender: TObject; const item: TECShape);
var Hint:string;
begin
 Hint := Item.Hint;
 if Hint='' then
   Hint := TECBubbleLayer(Sender).Hint;

  caption := TECBubbleLayer(Sender).Name + ' : ' + item.PropertyFormat(Hint) + ' (Right)';
end;

// event triggered after the automatic creation
// you can modify your element as you wish, to change its shape and color for example
procedure TForm10.doOnEditBubble(const BubbleShape: TECShapePoi);
begin
  // you can use a property for test
  if BubbleShape['diamond'] = '1' then
  begin
    BubbleShape.POIShape := poiDiamond;
    BubbleShape.Color := getInvertColor(BubbleShape.Color);
  end;

end;

// event triggered after add or delete TECBubbleLayer
procedure TForm10.doOnChangeLayers(Sender: TObject);
begin
  map.BubbleLayers.getLayers(layers.Items);
  setEnabledButton(layers.ItemIndex > -1);
end;

procedure TForm10.layersChange(Sender: TObject);
var
  FBubbleLayer: TECBubbleLayer;
begin
  FBubbleLayer := map.BubbleLayers.List[layers.ItemIndex];
  if assigned(FBubbleLayer) then
  begin
    FBubbleLayer.fitBounds;
    getLayerOptions(FBubbleLayer);
  end;

  setEnabledButton(layers.ItemIndex > -1);

end;

procedure TForm10.setEnabledButton(const value: boolean);
begin
  Delete.Enabled := value;
  UpdateOptions.Enabled := value;
end;

end.
