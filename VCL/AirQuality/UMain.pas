unit UMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uecNativeMapControl,Vcl.ExtCtrls, Vcl.StdCtrls,uecmaputil;

type
  TFormAirQuality = class(TForm)
    MJson: TMemo;
    Panel1: TPanel;
    map: TECNativeMap;
    getallstations: TButton;
    GetStation: TButton;
    procedure FormCreate(Sender: TObject);
    procedure GetStationClick(Sender: TObject);
    procedure getallstationsClick(Sender: TObject);
  private
    { Déclarations privées }
    procedure doOnJson(sender: TObject; const Query, JSon: string) ;
    procedure doOnclick(const sender : TAirQualityCity);
    procedure doOnRequest(sender : TObject);
  public
    { Déclarations publiques }
  end;

var
  FormAirQuality: TFormAirQuality;

implementation

{$R *.dfm}


/// Request the list of stations located in the visible area of the map.
/// The list is returned in json format, the OnJson event is triggered as soon as it is available
procedure TFormAirQuality.getallstationsClick(Sender: TObject);
begin
 map.AirQuality.getJSON(map.SouthWestLatitude,map.SouthWestLongitude,map.NorthEastLatitude,map.NorthEastLongitude);
end;

/// Request data from the station closest to the center of the map
/// Data is returned in json format, the OnJson event is triggered as soon as it is available
procedure TFormAirQuality.GetStationClick(Sender: TObject);
begin
  map.AirQuality.getJSON(map.Center.Lat,map.Center.Lng);
end;


/// Triggered just before call getJSON or click on Station
procedure TFormAirQuality.doOnRequest(sender : TObject);
begin
  MJson.Lines.Text := 'result pending...';
  MJSon.Color      := clwhite;
  MJSon.Font.Color := clBlack;
end;


/// Triggered when the response of a call to getJSON is available
/// The response is contained in Json, Query contains the parameters of the request
procedure TFormAirQuality.doOnJson(sender: TObject; const Query, JSon: string) ;
begin
  MJson.Lines.Text := Json;
  MJSon.Color      := clwhite;
  MJSon.Font.Color := clBlack;
end;

// Triggered after a click on a station when data is available
procedure TFormAirQuality.doOnclick(const sender : TAirQualityCity);
 var i:integer;
     level:string;
begin
  // all data in json format are available in sender.Json

  case sender.level of
    aqlGood: level := 'Good';
    aqlModerate: level := 'Moderate';
    aqlUnhealthySensitive: level := 'Unhealthy for Sensitive Groups';
    aqlUnhealthy: level := 'Unhealthy';
    aqlVeryUnhealthy: level := 'Very unhealthy';
    aqlHazardous: level := 'Hazardous';
  end;

  MJSon.text := #13#10+Level+#13#10#13#10;

  MJSon.Lines.Add(Sender.Name);

  MJson.Lines.Add('IQ '+DoubleToStr(Sender.DominantPollutant.Value));

  for i := 0 to High(sender.Pollutants) do
   MJson.Lines.Add(Sender.Pollutants[i].Name+' = '+DoubleToStr(sender.Pollutants[i].value));

  for i := 0 to High(sender.weather) do
   MJson.Lines.Add(sender.weather[i].Name+' = '+DoubleToStr(sender.weather[i].value));

   MJSon.Lines.Add('');
   MJSon.Lines.Add(sender.IsoTime);
   MJSon.Lines.Add(DateTimeToStr(sender.Time));

   MJSon.Color := sender.LevelColor;
   MJSon.Font.Color :=  GetContrastingColor(sender.LevelColor);
end;

procedure TFormAirQuality.FormCreate(Sender: TObject);
begin
 // get your free key from https://aqicn.org/data-platform/token/
 map.AirQuality.key := '';
 map.AirQuality.OnJson := doOnJson;
 map.AirQuality.OnClick := doOnclick;
 map.AirQuality.OnRequest := doOnRequest;
 map.AirQuality.visible := true;
end;



end.
