unit umain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,uecHttp, uecNativeMapControl,uecMapUtil,
  Vcl.ComCtrls, Vcl.ExtCtrls,shellapi;

type
  TFormGoogle = class(TForm)
    Panel1: TPanel;
    Label1: TLabel;
    maptype: TComboBox;
    Label3: TLabel;
    langue: TComboBox;
    traffic: TCheckBox;
    GStyles: TGroupBox;
    json: TMemo;
    LinkStyles: TLabel;
    ClearStyles: TButton;
    map: TECNativeMap;

    procedure FormCreate(Sender: TObject);
    procedure jsonChange(Sender: TObject);
    procedure maptypeChange(Sender: TObject);
    procedure langueChange(Sender: TObject);
    procedure trafficClick(Sender: TObject);
    procedure LinkStylesClick(Sender: TObject);
    procedure ClearStylesClick(Sender: TObject);
    procedure mapMapClick(sender: TObject; const Lat, Lng: Double);
  private
    { Déclarations privées }
    FStreetViewWidth,FStreetViewHeight : integer;
  public
    { Déclarations publiques }
  end;

var
  FormGoogle: TFormGoogle;

implementation

{$R *.dfm}




procedure TFormGoogle.FormCreate(Sender: TObject);
begin

 if map.Google.ApiKey='' then
  map.Google.ApiKey :=  InputBox('Google API key', 'Your Key', '');

  map.TileServer := tsGoogle;
  map.TileServerInfo.MapStyle := 'roadmap';

  FStreetViewWidth := 320;
  FStreetViewHeight:= 200;

  map.InfowindowDescription.Width := FStreetViewWidth+10;
end;




// new styles
procedure TFormGoogle.jsonChange(Sender: TObject);
begin
  map.Google.Styles := json.Text;
end;

// default styles
procedure TFormGoogle.ClearStylesClick(Sender: TObject);
begin
 map.Google.Styles := '';
end;


procedure TFormGoogle.langueChange(Sender: TObject);
begin
 if langue.ItemIndex>-1 then
  map.Google.Lang := langue.Items[langue.ItemIndex];
end;

procedure TFormGoogle.LinkStylesClick(Sender: TObject);
begin
   ShellAPI.ShellExecute(0, 'Open', PChar(Linkstyles.caption),'', nil, SW_SHOWNORMAL);
end;

procedure TFormGoogle.mapMapClick(sender: TObject; const Lat, Lng: Double);
begin
  map.ShowInfoWindow(lat,lng,'<img src="'+map.Google.StreetView(lat,lng,FStreetViewWidth,FStreetViewHeight)+'" width='+inttostr(FStreetViewWidth)+' height='+inttostr(FStreetViewHeight)+'>');
end;

procedure TFormGoogle.maptypeChange(Sender: TObject);
begin
if mapType.ItemIndex>-1 then
  map.TileServerInfo.MapStyle := mapType.Items[mapType.ItemIndex];
end;

procedure TFormGoogle.trafficClick(Sender: TObject);
begin
 map.TrafficLayer := traffic.Checked;
end;

end.
