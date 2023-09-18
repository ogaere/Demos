unit umain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,uecHttp, uecNativeMapControl,uecMapUtil,
  Vcl.ComCtrls, Vcl.ExtCtrls,shellapi;

type
  TFormGoogle = class(TForm)
    map: TECNativeMap;
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

    procedure FormCreate(Sender: TObject);
    procedure jsonChange(Sender: TObject);
    procedure maptypeChange(Sender: TObject);
    procedure langueChange(Sender: TObject);
    procedure trafficClick(Sender: TObject);
    procedure LinkStylesClick(Sender: TObject);
    procedure ClearStylesClick(Sender: TObject);
  private
    { Déclarations privées }

  public
    { Déclarations publiques }
  end;

var
  FormGoogle: TFormGoogle;

implementation

{$R *.dfm}


procedure TFormGoogle.FormCreate(Sender: TObject);
begin

 // see https://developers.google.com/maps/documentation/tile/cloud-setup?hl=en
 if map.Google.Key='' then
  map.Google.Key :=  InputBox('Google API key', 'Your Key', '');

  map.TileServer := tsGoogle;
  map.TileServerInfo.MapStyle := 'roadmap';
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
