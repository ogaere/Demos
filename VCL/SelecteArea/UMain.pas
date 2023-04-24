unit UMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uecNativeMapControl, uecMapUtil, Vcl.StdCtrls,
  Vcl.ExtCtrls;

type
  TFSelectArea = class(TForm)
    toolbar: TLabel;
    info: TLabel;
    map: TECNativeMap;
    CircleSelection: TCheckBox;
    panel1: TPanel;
    ChangeColor: TButton;
    showmetric: TCheckBox;
    CenterOnArea: TButton;
    procedure FormCreate(Sender: TObject);
    procedure mapMapClick(sender: TObject; const Lat, Lng: Double);
    procedure CircleSelectionClick(Sender: TObject);
    procedure ChangeColorClick(Sender: TObject);
    procedure showmetricClick(Sender: TObject);
    procedure CenterOnAreaClick(Sender: TObject);
  private
    { Déclarations privées }
    procedure doOnChange(sender : TObject);
    procedure doOnClick(sender : TObject);
    procedure doOnDblClick(sender : TObject);
    procedure doOnRightClick(sender : TObject);
    procedure doOnLongPress(sender : TObject);
  public
    { Déclarations publiques }
  end;

var
  FSelectArea: TFSelectArea;

implementation

{$R *.dfm}

procedure TFSelectArea.CenterOnAreaClick(Sender: TObject);
begin
 map.SelectArea.fitBounds;
end;

procedure TFSelectArea.ChangeColorClick(Sender: TObject);
begin
   map.SelectArea.Color := GetRandomColor;
end;

procedure TFSelectArea.CircleSelectionClick(Sender: TObject);
begin

 if CircleSelection.Checked then
     map.SelectArea.AreaType := atCircle
 else
    map.SelectArea.AreaType := atRectangle;

end;

procedure TFSelectArea.doOnClick(sender : TObject);
begin
 info.Caption := 'Click';
end;

procedure TFSelectArea.doOnDblClick(sender : TObject);
begin
 info.Caption := 'Double Click';
end;

procedure TFSelectArea.doOnRightClick(sender : TObject);
begin
 info.Caption := 'Right Click';
end;

procedure TFSelectArea.doOnLongPress(sender : TObject);
begin
 info.Caption := 'Long Press';
end;

procedure TFSelectArea.doOnChange(sender : TObject);
begin
 case map.SelectArea.AreaType of
   atRectangle: begin

      info.Caption := 'NorthEst : '+ doubletostrdigit(map.SelectArea.NELat,3)+','+
                    doubletostrdigit(map.SelectArea.NELng,3)+' SouthWest : '+
                    doubletostrdigit(map.SelectArea.SWLat,3)+','+
                    doubletostrdigit(map.SelectArea.SWLng,3)+
                    ' W : '+doubletostrdigit(map.SelectArea.Width,2)+' Km '+
                    'H : '+doubletostrdigit(map.SelectArea.Height,2)+' Km '+
                    'Area : '+doubletostrdigit(map.SelectArea.Area,3)+' Km²';

   end;
   atCircle: begin

      info.Caption := 'Lat : '+ doubletostrdigit(map.SelectArea.Center.lat,3)+','+
                    doubletostrdigit(map.SelectArea.Center.lng,3)+' Radius : '+
                    doubletostrdigit(map.SelectArea.Width / 2,2)+' Km Area : '+doubletostrdigit(map.SelectArea.Area,3)+' Km²';

   end;
 end;
end;

procedure TFSelectArea.FormCreate(Sender: TObject);
begin
 map.SelectArea.OnChange      := doOnChange;
 map.SelectArea.OnClick       := doOnClick;
 map.SelectArea.OnRightClick  := doOnRightClick;
 map.SelectArea.OnLongPress   := doOnLongPress;
 map.SelectArea.OnDblClick    := doOnDblClick;

 map.SelectArea.Visible  := true;
end;

procedure TFSelectArea.mapMapClick(sender: TObject; const Lat, Lng: Double);
begin
  map.SelectArea.setPosition(lat,lng)  ;
  // you can also use
  // map.SelectArea.Boundary(NELat,NELng,SWLat,SWLng)
end;

procedure TFSelectArea.showmetricClick(Sender: TObject);
begin
 map.SelectArea.ShowMetrics := ShowMetric.Checked;
end;

end.
