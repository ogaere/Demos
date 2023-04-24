unit umaintrack;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.uecNativeMapControl,System.IOUtils, System.Sensors,
  System.UIConsts,
  System.Sensors.Components,
  FMX.uecNativeShape,FMX.uecMapUtil, FMX.Controls.Presentation, FMX.StdCtrls;

type
  TFormTrack = class(TForm)
    map: TECNativeMap;
    LocationSensor: TLocationSensor;
    Label1: TLabel;
    Circle1: TCircle;
    speed: TLabel;
    TimerSpeed: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure LocationSensorLocationChanged(Sender: TObject; const OldLocation,
      NewLocation: TLocationCoord2D);
    procedure TimerSpeedTimer(Sender: TObject);
  private
    { Déclarations privées }

   FTracker       : TECShapeMarker;



  public
    { Déclarations publiques }
  end;

var
  FormTrack: TFormTrack;

implementation

{$R *.fmx}

procedure TFormTrack.FormCreate(Sender: TObject);
begin

 map.localCache        := TPath.Combine(TPath.GetSharedDocumentsPath, 'cache');

 map.ScaleMarkerToZoom := true;

 map.Zoom              := 18;

 LocationSensor.Active := true;

end;


procedure TFormTrack.LocationSensorLocationChanged(Sender: TObject;
  const OldLocation, NewLocation: TLocationCoord2D);
begin

 map.BeginUpdate;

 if not assigned(FTracker) then
 begin

   FTracker           := map.AddMarker(NewLocation.Latitude, NewLocation.Longitude) ;

   FTracker.StyleIcon := siDirection;

   // To activate the trace just access TrackLine
   // line is created in the same group as FTracker
   FTracker.TrackLine.visible := true;

   // You can also pass a line
   // FTracker.TrackLine := your_line;

   // for stop tracking set to nil  , the line is free
   // FTracker.TrackLine := nil

   TimerSpeed.Enabled := true;

 end
 else
 begin

   FTracker.SetDirection(NewLocation.Latitude, NewLocation.Longitude);

 end;

 map.setCenter(NewLocation.Latitude, NewLocation.Longitude);

 map.EndUpdate;

 // crash if set text here (thread ?)
 // use timer for show speed
 //Speed.Text := inttostr(FTracker.SpeedKmH);
end;

procedure TFormTrack.TimerSpeedTimer(Sender: TObject);
begin
 Speed.Text := inttostr(FTracker.SpeedKmH);
end;

end.
