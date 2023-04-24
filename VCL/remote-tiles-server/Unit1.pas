unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, UECMapUtil, uecNativeMapControl,uECNativeTileServer,uecThreadGraphics,
  Vcl.StdCtrls,
  IdWebsocketServer, IdHTTPWebsocketClient, IdSocketIOHandling,superobject;


type
  TForm1 = class(TForm)
    btConnect: TButton;
    ckCache: TCheckBox;
    edCache: TEdit;
    Label2: TLabel;
    edPortServer: TEdit;

    procedure FormCreate(Sender: TObject);
    procedure doOnLoadTile(sender: TObject;  const x, y, z, t: integer);
    procedure btConnectClick(Sender: TObject);
  
    procedure ckCacheClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);

  private
    { Private declarations }

    server: TIdWebsocketServer;

    FMapServer : TNativeMapServer;

    procedure doMessage(const ASocket: ISocketIOContext; const aText:string; const aCallback: ISocketIOCallback) ;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;



implementation

{$R *.dfm}


procedure TForm1.FormCreate(Sender: TObject);
begin

 // create tile server  ( unit uECNativeTileServer )
  FMapServer              := TNativeMapServer.Create(nil,nil);
  FMapServer.OnLoadTile   := doOnLoadTile;
  FMapServer.TileServer   := tsOSM;

 // FMapServer.LocalCache :=

 // FMapServer.OnlyLocal := true;

  // create WebSocket server
  server := TIdWebsocketServer.Create(Self);
  server.SocketIO.OnSocketIOMsg  := doMessage;

end;


// request tile from client : ^Tile|x|y|z
procedure TForm1.doMessage(const ASocket: ISocketIOContext; const aText:string; const aCallback: ISocketIOCallback)  ;
 var Text:string;
 sxStream:TMemoryStream;
 ix,iy,iz,isz:integer;
begin



    Text := aText;

    if pos('^Tile',text)>0 then
    begin
      StrToken(text,'|');

      ix:=StrToIntDef(StrToken(text,'|'),0);
      iy:=StrToIntDef(StrToken(text,'|'),0);
      iz:=StrToIntDef(StrToken(text,'|'),0);
      sxStream:=TMemoryStream.Create;

      // request tile
      if FMapServer.GetStreamTile(sxStream,ix,iy,iz) then
      begin
        // if tile is ready  send to client
        ASocket.Send('^Tile|'+inttostr(ix)+'|'+inttostr(iy)+'|'+inttostr(iz)+'|'+EncodeStreamTo64(sxStream));
      end;


      sxStream.Free;
    end;


end;


// tile is ready now, send to clients
procedure TForm1.doOnLoadTile(sender: TObject;  const x, y, z, t: integer);
var TileStream: TMemoryStream;
begin



   TileStream := TMemoryStream.Create;
   try
       // request tile
    if FMapServer.GetStreamTile(TileStream,x,y,z) then
    // send response : ^Tile|x|y|z|Base64-Stream-Data-Tile
     server.SendMessageToAll('^Tile|'+inttostr(x)+'|'+inttostr(y)+'|'+inttostr(z)+'|'+EncodeStreamTo64(Tilestream));

   finally
    TileStream.Free;
   end;




end;


// connect / deconnect server
procedure TForm1.btConnectClick(Sender: TObject);
begin

  if not Server.Active then
    begin
      Server.DefaultPort:=StrtoIntDef(edPortServer.Text,8080);
    end;
  Server.Active:=not Server.Active;
  if Server.Active then btConnect.Caption:='Stop server' else btConnect.Caption:='Start server';

end;

// set cache
procedure TForm1.ckCacheClick(Sender: TObject);
begin
  if ckCache.Checked then
    begin
      FMapServer.LocalCache:=edCache.Text;
    end else
    begin
      FMapServer.LocalCache:='';
    end;
end;


procedure TForm1.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
 if CanClose then
 begin
  FMapServer.Free;
 end;
end;

end.
