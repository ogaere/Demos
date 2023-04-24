unit URouteWeather;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uecNativeMapControl, Vcl.StdCtrls,
  Vcl.ExtCtrls,
  uecnativeshape, uecopenweather, uecmaputil, uecgeolocalise;

type
  TForm6 = class(TForm)
    Panel1: TPanel;
    start: TEdit;
    rend: TEdit;
    route: TButton;
    Panel2: TPanel;
    map: TECNativeMap;
    WeatherMemo: TMemo;
    Label1: TLabel;
    Panel3: TPanel;
    procedure FormCreate(Sender: TObject);
    procedure routeClick(Sender: TObject);
    procedure mapMapDblClick(sender: TObject; const Lat, Lng: Double);
    procedure Panel3Resize(Sender: TObject);
    procedure mapMapSelectRect(sender: TObject; const SWLat, SWLng, NELat,
      NELng: Double);
  private
    { Déclarations privées }

    procedure doOnAddRoute(Sender: TECShapeLine; const params: string);

    procedure doWeatherId(WeatherId: integer; var FilenameIcon: string;
      var Color: TColor);
    procedure doWeatherClick(Sender: TObject;
      const WeatherData: TOpenWeatherData);
    procedure doOnWeatherComplete(Sender: TObject);

  public
    { Déclarations publiques }

    FInfoWindow: TECShapeInfoWindow;

  end;

var
  Form6: TForm6;

implementation

{$R *.dfm}

procedure TForm6.FormCreate(Sender: TObject);
begin

  // Important, set a cache directory to limit calls to the api weather
  map.localcache := ExtractfilePath(ParamStr(0)) + 'cache';

  FInfoWindow := map.AddInfoWindow(0, 0);
  FInfoWindow.Visible := false;


  map.Routing.EditOnClick := false;

  // get your key from http://openweathermap.org/appid
  map.OpenWeather.Key := 'your key here';

  // if localcache by default the data is kept cached for 60 minutes
  map.OpenWeather.MaxMinutesInCache := 60;

  map.OpenWeather.Lang := 'en';


  // clic to meteo station icon
  map.OpenWeather.OnWeatherClick     := doWeatherClick;

  // if you want change default colors and icons
  map.OpenWeather.OnAdaptToWeatherId := doWeatherId;



  map.Routing.OnAddRoute := doOnAddRoute;

end;


procedure TForm6.Panel3Resize(Sender: TObject);
begin
 start.Width := (panel3.Width div 2)-5;
 rend.Width  := start.Width;
end;



// Show the weather of the clicked point
procedure TForm6.mapMapDblClick(sender: TObject; const Lat, Lng: Double);
var m       : TECShapeMarker;
    station : TOpenWeatherData;
begin

 // get the meteo of now

 station := map.OpenWeather.Now.Weather(lat,lng);

 if station.name<>'' then
 begin

  m          := map.AddMarker(lat,lng);

   m.Hint := '<h2>' +
             station.name +   // name of station
             '</h2>' +
             station.weather.description +
             '<br>T : ' +
             doubletostr(station.temp) + '°';

  m.filename := station.weather.filenameicon;
 

 end;
end;


// show the weather for the selected area
procedure TForm6.mapMapSelectRect(sender: TObject; const SWLat, SWLng, NELat,
  NELng: Double);
  var i,n   : integer;
      m     : TECShapeMarker;
    station : TOpenWeatherData;
begin
  // get then meteo of now for this area , return number stations
  n := map.OpenWeather.Now.ByBox(NELat,NELng,SWLat,SWLng);

  if n=0 then exit;


  map.BeginUpdate;

  for i:=0 to n-1 do
  begin

    // data is an array of TOpenWeatherData
    station := map.OpenWeather.Now.Data[i];

    m          := map.AddMarker(station.coord.lat,station.coord.lng);

    m.Hint := '<h2>' +
             station.name +   // name of station
             '</h2>' +
             station.weather.description +
             '<br>T : ' +
             doubletostr(station.temp) + '°';

    if station.weather.filenameicon<>'' then
	begin
      m.filename := station.weather.filenameicon;
	end   
    else
      m.Remove;



  end;

  map.EndUpdate;

end;

// calculate the route
procedure TForm6.routeClick(Sender: TObject);
begin
  map.Routing.Request(start.Text, rend.Text);
end;


// triggered when route is ok
procedure TForm6.doOnAddRoute(Sender: TECShapeLine; const params: string);
begin

  // To react when the weather will be calculated for the entire route
  Sender.OnWeatherComplete := doOnWeatherComplete;

  // By default the weather points are spaced 25km apart
  // change to 20km
  sender.KmDistanceBetweenWeatherStations := 20;

   // Get the weather along the road
  Sender.ShowWeather := true;

  // show all route
  Sender.fitBounds;

end;



// triggered when meteo complete
// sender is the line
procedure TForm6.doOnWeatherComplete(Sender: TObject);
var
  line: TECShapeLine;
  i   : integer;
  s   : string;
begin

  line := TECShapeLine(Sender);

  s := '';

  // get all meteo stations names

  for i := 0 to line.WeatherStationCount - 1 do
    s := s + line.WeatherData[i].name + ',';

  s := copy(s, 1, length(s) - 1);

  WeatherMemo.Lines.Add(s);

end;


// trigged when clic on meteo station icon
procedure TForm6.doWeatherClick(Sender: TObject;
  const WeatherData: TOpenWeatherData);
begin

  FInfoWindow.SetPosition(WeatherData.coord.Lat, WeatherData.coord.Lng);

  FInfoWindow.content := '<h2><img src="' + WeatherData.weather.FilenameIcon +
    '"/>' + WeatherData.name + '</h2>' + WeatherData.weather.description +
    '<br>T : ' + doubletostr(WeatherData.temp) + '°';

  FInfoWindow.Visible := true;

  // move the map to see the entire infowindow
  FInfoWindow.ShowAll;

  with WeatherMemo.Lines do
  begin
    Add(WeatherData.name + ' : ' + WeatherData.weather.description + ' T:' +
      doubletostr(WeatherData.temp) + '°');
  end;

end;

// change défault color and icon according to WeatherID
procedure TForm6.doWeatherId(WeatherId: integer; var FilenameIcon: string;
  var Color: TColor);
begin
  (*

   case WeatherId of
       xxx : begin
               FilenameIcon := 'xxx';
               Color        := ccc;
             end;
   end;

  *)
end;





end.
