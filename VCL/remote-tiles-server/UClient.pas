unit UClient;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, IdComponent, UECMapUtil,
  uecNativeMapControl,
  IdWebsocketServer, IdHTTPWebsocketClient, IdSocketIOHandling, superobject,
  Vcl.StdCtrls, Vcl.ExtCtrls;

type

  TForm2 = class(TForm)
    Panel1: TPanel;
    Label1: TLabel;
    edIPServer: TEdit;
    Label2: TLabel;
    edPortServer: TEdit;
    map: TECNativeMap;
    btConnect: TButton;
    CheckBox1: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure btConnectClick(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);

  private
    { Déclarations privées }

    client: TidHTTPWebSocketClient;

    procedure getTileStream(const ThreadIndex:integer;var TileStream: TMemoryStream;
      const x, y, z: integer);

    procedure doMessage(const ASocket: ISocketIOContext; const aText: string;
      const aCallback: ISocketIOCallback);

  public
    { Déclarations publiques }
  end;

var
  Form2: TForm2;

implementation

{$R *.dfm}

procedure TForm2.FormCreate(Sender: TObject);
begin

  // manual management tiles as stream
  map.TileServerInfo.getTileStream := getTileStream;
  // the name will be uses as subdirectory in cache
  map.TileServerInfo.Name := 'MyMAP';
  // important to specify a manual management tiles
  map.TileServer := tsOwnerDraw;

  // create WebSocket clients for communication with server
  client := TidHTTPWebSocketClient.Create(self);
  client.SocketIOCompatible := true;
  client.SocketIO.OnSocketIOMsg := doMessage;

end;

// asks for a tile
procedure TForm2.getTileStream(const ThreadIndex:integer;var TileStream: TMemoryStream;
  const x, y, z: integer);
begin

  // send request to the server  : ^Tile|x|y|z
  client.SocketIO.Send('^Tile|' + inttostr(x) + '|' + inttostr(y) + '|' +
    inttostr(z));

end;

// response from server, get tile : ^Tile|x|y|z|Base64-Stream-Data-Tile
procedure TForm2.CheckBox1Click(Sender: TObject);
begin
  map.onlylocal := CheckBox1.Checked;
end;

procedure TForm2.doMessage(const ASocket: ISocketIOContext; const aText: string;
  const aCallback: ISocketIOCallback);
var
  Text: string;
  sxStream: TMemoryStream;
  ix, iy, iz: integer;
begin

  TThread.synchronize(nil,
   procedure
    begin

      Text := aText;

      if pos('^Tile', Text) > 0 then
      begin
        StrToken(Text, '|');
        ix := StrToIntDef(StrToken(Text, '|'), 0);
        iy := StrToIntDef(StrToken(Text, '|'), 0);
        iz := StrToIntDef(StrToken(Text, '|'), 0);
        sxStream := TMemoryStream.Create;
        if Decode64ToStream(Text, sxStream) then
        begin
          map.AddStreamTile(sxStream, ix, iy, iz);
        end;
        sxStream.Free;
      end;
     end);

end;

// connect / deconnect from server
procedure TForm2.btConnectClick(Sender: TObject);
begin

  if not client.Connected then
  begin
    client.Host := edIPServer.Text;
    client.Port := StrToIntDef(edPortServer.Text, 8080);
    client.Connect;
    map.Invalidate;

  end
  else
  begin
    client.Disconnect(false);

  end;

  if client.Connected then
    btConnect.Caption := 'Stop client'
  else
    btConnect.Caption := 'Start client';

end;

// set cache
end.
