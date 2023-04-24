unit UMapArchiveCreator;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  System.IOUtils,
  FMX.uecMaputil, FMX.uecMapZip,
{$IFDEF MSWINDOWS}
  Winapi.Windows, Winapi.ShellAPI,
{$ENDIF}
{$IFDEF POSIX}
  Posix.Stdlib,
{$ENDIF POSIX}
  FMX.uecNativeMapControl, FMX.Controls.Presentation, FMX.StdCtrls, FMX.Edit,
  FMX.ComboEdit, FMX.ListBox, FMX.EditBox, FMX.SpinBox;

type
  TForm10 = class(TForm)
    map_panel : TPanel;
    map : TECNativeMap;
    Zip : TButton;
    Archive : TComboEdit;
    GroupBox6 : TGroupBox;
    ProgressBar : TProgressBar;
    StartStop : TButton;
    LabelDownLoad : TLabel;
    Directory : TButton;
    edAdress : TEdit;
    servers : TComboBox;
    Rectangle1 : TRectangle;
    Label1 : TLabel;
    Label2 : TLabel;
    Label3 : TLabel;
    GroupBox1 : TGroupBox;
    Label4 : TLabel;
    Label5 : TLabel;
    RouteStart : TEdit;
    RouteEnd : TEdit;
    AddRoute : TButton;
    InfoRoute : TLabel;
    LEngine : TLabel;
    engine : TComboBox;
    ClearDirectory : TButton;
    Files : TGroupBox;
    Label6 : TLabel;
    FileType : TComboBox;
    SelectFile : TButton;
    OD : TOpenDialog;
    maxzoom: TSpinBox;
    procedure FormCreate(Sender : TObject);
    procedure ArchiveChange(Sender : TObject);
    procedure ArchiveKeyUp(Sender : TObject; var Key : Word; var KeyChar : Char;
      Shift : TShiftState);
    procedure StartStopClick(Sender : TObject);
    procedure FormDestroy(Sender : TObject);
    procedure FormCloseQuery(Sender : TObject; var CanClose : Boolean);
    procedure ZipClick(Sender : TObject);
    procedure DirectoryClick(Sender : TObject);
    procedure edAdressKeyUp(Sender : TObject; var Key : Word; var KeyChar : Char;
      Shift : TShiftState);
    procedure serversChange(Sender : TObject);
    procedure AddRouteClick(Sender : TObject);
    procedure ClearDirectoryClick(Sender : TObject);
    procedure SelectFileClick(Sender : TObject);
  private
    { Déclarations privées }
    FCopyright,
      FMACPath : string;

    // download area of tiles
    FECDownLoadTiles : TECDownLoadTiles;

    function GetDirectoryArchive(const ArchiveName : string) : string;
    procedure OpenDirectory(const DirectoryName : string);

    procedure doDownLoadTiles(Sender : TObject);
    procedure doEndDownLoadtiles(Sender : TObject);
  public
    { Déclarations publiques }
  end;

var
  Form10 : TForm10;

implementation

{$R *.fmx}


procedure TForm10.FormCloseQuery(Sender : TObject; var CanClose : Boolean);
begin
  FECDownLoadTiles.OnEndDownLoad := nil;
  FECDownLoadTiles.cancel;
end;

procedure TForm10.FormCreate(Sender : TObject);
var
  l : TStringList;
  i, j : integer;
begin

  FMACPath := TPath.GetDocumentsPath + PathDelim + 'MapArchiveCreator';
  FCopyright := 'MapArchiveCreator - © ' + inttostr(CurrentYear) +
    ' E. Christophe';

  Caption := FCopyright;

  l := TStringList.Create;
  try

    DirectoryGetDirectorie(FMACPath, l);

    j := length(FMACPath);

    Archive.Items.BeginUpdate;

    for i := 0 to l.Count - 1 do
    begin

      Archive.Items.Add(copy(l[i], j + 2, length(l[i])));

    end;

    Archive.Items.EndUpdate;

  finally
    l.Free;
  end;

  // for download area of tiles
  FECDownLoadTiles := TECDownLoadTiles.Create;

  FECDownLoadTiles.OnDownLoad := doDownLoadTiles;
  FECDownLoadTiles.OnEndDownLoad := doEndDownLoadtiles;

  // ! USE YOUR KEY !
  map.MapBoxToken :=  '';

  // ! USE YOUR KEY !
  map.MapQuestKey := '';

  maxzoom.Max  := map.MaxZoom;
  maxzoom.Value:= map.MaxZoom;

end;

procedure TForm10.FormDestroy(Sender : TObject);
begin
  FECDownLoadTiles.Free;
end;

function TForm10.GetDirectoryArchive(const ArchiveName : string) : string;
begin
  result := TPath.Combine(FMACPath, ArchiveName);
end;

procedure TForm10.StartStopClick(Sender : TObject);
begin
  case StartStop.tag of

  0 :
    begin
      // start downloading visible area

      StartStop.Text := 'Stop';
      StartStop.tag := 1;

      // tiles are saved in DirectoryTiles
      FECDownLoadTiles.DirectoryTiles := map.LocalCache;
      FECDownLoadTiles.TileServer := map.TileServer;
      FECDownLoadTiles.TileSize := map.TileSize;

      // download visible area from zoom+1 to MaxZoom

      FECDownLoadTiles.DownLoadTiles(map.Zoom, round(MaxZoom.value),
        map.NorthEastLatitude, map.NorthEastLongitude, map.SouthWestLatitude,
        map.SouthWestLongitude);

    end;

  1 :
    begin
      // stop downloading

      FECDownLoadTiles.cancel;

      LabelDownLoad.Text := '';

      ProgressBar.Value := 0;

      StartStop.Text := 'Start';
      StartStop.tag := 0;

    end;

  end;
end;

procedure TForm10.ZipClick(Sender : TObject);
begin
  CreateMapZipFromDirectory(FMACPath + PathDelim + Archive.Text + '.zip',
    GetDirectoryArchive(Archive.Text));
end;

// event fired after a tile is downloading
procedure TForm10.doDownLoadTiles(Sender : TObject);
begin

  ProgressBar.Max := FECDownLoadTiles.CountTotalTiles;
  ProgressBar.Value := FECDownLoadTiles.CountDownLoadTiles;

  LabelDownLoad.Text :=
    inttostr(round((FECDownLoadTiles.CountDownLoadTiles /
    FECDownLoadTiles.CountTotalTiles) * 100)) + '%   ' +
    inttostr(FECDownLoadTiles.CountDownLoadTiles) + ' / ' +
    inttostr(FECDownLoadTiles.CountTotalTiles);

end;

// fired when cancel or when all tiles are downloading
procedure TForm10.doEndDownLoadtiles(Sender : TObject);
begin
  doDownLoadTiles(nil);

  StartStop.Text := 'Start';
  StartStop.tag := 0;
end;

procedure TForm10.edAdressKeyUp(Sender : TObject; var Key : Word;
  var KeyChar : Char; Shift : TShiftState);
var
  Lat, Lng, lat2, lng2 : Double;
begin

  if Key = 13 then
  begin
    // Map.Address := edAdress.Text;
    if map.GetLatLngFromAddress(edAdress.Text, Lat, Lng) then
    begin

      // 200 meter around you
      map.fitBoundsRadius(Lat, Lng, 0.2);

    end;
  end;

end;

procedure TForm10.ArchiveKeyUp(Sender : TObject; var Key : Word;
  var KeyChar : Char; Shift : TShiftState);
begin
  if KeyChar = #13 then
    ArchiveChange(Sender);
end;

procedure TForm10.ClearDirectoryClick(Sender : TObject);
begin

  if (MessageDlg('Delete the directory ' + Archive.Text + ' ?',
    TMsgDlgType.mtConfirmation,
    [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo], 0) = mrYes) then
  begin
    System.IOUtils.TDirectory.Delete(map.LocalCache, true);
    Forcedirectories(map.LocalCache);
  end;

end;

procedure TForm10.DirectoryClick(Sender : TObject);
begin
  OpenDirectory(FMACPath);
end;

procedure TForm10.OpenDirectory(const DirectoryName : string);
begin
{$IFDEF MSWINDOWS}
  ShellExecute(0, 'OPEN', PChar(DirectoryName), '', '', SW_SHOWNORMAL);
{$ENDIF MSWINDOWS}
{$IFDEF POSIX}
  _system(PAnsiChar('open ' + AnsiString(DirectoryName)));
{$ENDIF POSIX}
end;

procedure TForm10.SelectFileClick(Sender : TObject);
var
  path : string;
  i : integer;
begin

  path := map.LocalCache + PathDelim + FileType.Items[FileType.ItemIndex] +
    PathDelim;

  if OD.Execute then
  begin

    Forcedirectories(path);

    for i := 0 to OD.Files.Count - 1 do
      System.IOUtils.TFile.copy(OD.Files[i],
        path + Extractfilename(OD.Files[i]));

  end;

end;

procedure TForm10.serversChange(Sender : TObject);
begin
  case servers.ItemIndex of

  0 : map.TileServer := tsOSM;
  1 : map.TileServer := tsOpenCycleMap;
  2 : map.TileServer := tsOPNV;
  3 : map.TileServer := tsArcGisWorldTopoMap;
  4 : map.TileServer := tsArcGisWorldStreetMap;
  5 : map.TileServer := tsArcGisWorldImagery;
  6 : map.TileServer := tsBingRoad;
  7 : map.TileServer := tsBingAerial;
  8 : map.TileServer := tsBingAerialLabels;
  9 : map.TileServer := tsHereNormal;
  10 : map.TileServer := tsHereTerrain;
  11 : map.TileServer := tsHereMobile;
  12 : map.TileServer := tsHereSatellite;
  13 : map.TileServer := tsHereHybrid;
  14 : map.TileServer := tsOsmFr;

  end;


  maxzoom.Max  := map.MaxZoom;
  maxzoom.Value:= map.MaxZoom;
end;

procedure TForm10.AddRouteClick(Sender : TObject);
begin
  case engine.ItemIndex of
  0 :
      map.Routing.engine(reMapBox);
  1 :
      map.Routing.engine(reMapQuest);
  // ! USE YOUR KEY !
  2 :
      map.Routing.engine(reMapZen, '');
  3 :
      map.Routing.engine(reOSRM);
  end;

  map.Routing.Color := GetHashColor(RouteStart.Text + '-' + RouteEnd.Text);
  map.Routing.Request(RouteStart.Text, RouteEnd.Text);
end;

procedure TForm10.ArchiveChange(Sender : TObject);
begin
  Caption := FCopyright + ' - Archive : ' + Archive.Text;

  StartStop.Enabled := true;
  Zip.Enabled := true;
  AddRoute.Enabled := true;
  ClearDirectory.Enabled := true;
  SelectFile.Enabled := true;

  if (Archive.Text <> '') and (Archive.Items.IndexOf(Archive.Text) = -1) then
  begin
    Forcedirectories(GetDirectoryArchive(Archive.Text));
    Archive.Items.Add(Archive.Text);
  end;

  map.Clear;
  map.LocalCache := GetDirectoryArchive(Archive.Text);
end;

end.
