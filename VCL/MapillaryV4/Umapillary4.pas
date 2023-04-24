unit Umapillary4;

interface

uses
  Windows, Messages, SysUtils, Variants,
  Classes, Graphics,
  Controls, Forms, Dialogs, uecNativeMapControl, uecNativeShape,
  StdCtrls,


  vector_tile, uecHttp, uecMapUtil, math, uecMapillary,


  ExtCtrls, Spin;

type
  TForm30 = class(TForm)
    Panel1: TPanel;
    map: TECNativeMap;
    LoadVisibleArea: TButton;
    Image: TImage;
    ckLayer: TCheckBox;
    Label1: TLabel;
    MapillaryRequest: TLabel;
    pnImage: TPanel;
    NextImage: TButton;
    PrevImage: TButton;
    LastImage: TButton;
    FirstImage: TButton;
    lbImage: TLabel;
    Sequences: TComboBox;
    Label2: TLabel;
    Label3: TLabel;
    distance: TSpinEdit;
    Panel2: TPanel;
    Label4: TLabel;
    detections: TMemo;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure mapChangeMapZoom(Sender: TObject);
    procedure LoadVisibleAreaClick(Sender: TObject);
    procedure ckLayerClick(Sender: TObject);
    procedure FirstImageClick(Sender: TObject);
    procedure PrevImageClick(Sender: TObject);
    procedure NextImageClick(Sender: TObject);
    procedure LastImageClick(Sender: TObject);
    procedure SequencesChange(Sender: TObject);
    procedure mapMapDblClick(sender: TObject; const Lat, Lng: Double);

  private
    { Déclarations privées }

    var BeginRequestCount,EndRequestCount:integer;

        SelectedSequence   : TMapillarySequence;
        SelectedImageIndex : integer;

    PositionView : TECShapeMarker;

    // click on image
    procedure doOnMapillaryLayerClick(Layer : TECMapillaryLayer; item : TECShape;
    MapillarySequence : TMapillarySequence; ImageIndex : integer);

    // click on traffic sign
    procedure doOnMapillaryLayerTrafficSignClick(layer: TECMapillaryLayer; item: TECShape;
    ListTrafficSign: TListTrafficSign; TrafficSignIndex: integer) ;

    procedure doBeginRequest(sender: TObject);
    procedure doEndRequest(sender: TObject);

    procedure SetSequenceImage(const Sequence : TMapillarySequence; const ImageIndex : integer;const moveMap:boolean=true);


  public
    { Déclarations publiques }


    FMapillaryLayer : TECMapillaryLayer;



  end;

var
  Form30: TForm30;

implementation

{$R *.dfm}




procedure TForm30.LoadVisibleAreaClick(Sender: TObject);
begin
 FMapillaryLayer.SearchBounds(map.NorthEastLatitude,map.NorthEastLongitude,map.SouthWestLatitude,map.SouthWestLongitude)
end;

procedure TForm30.ckLayerClick(Sender: TObject);
begin
 FMapillaryLayer.Visible := ckLayer.Checked;
end;


// click on line or marker mapillary image
procedure TForm30.doOnMapillaryLayerClick(Layer : TECMapillaryLayer; item : TECShape;
    MapillarySequence : TMapillarySequence; ImageIndex : integer);
begin

  SetSequenceImage(MapillarySequence,ImageIndex);

end;


// click on marker mapillary traffic sign
procedure TForm30.doOnMapillaryLayerTrafficSignClick(layer: TECMapillaryLayer; item: TECShape;
    ListTrafficSign: TListTrafficSign; TrafficSignIndex: integer) ;
begin
 FMapillaryLayer.OpenWindow(item.Latitude,item.Longitude,
                           '<h4>'+ListTrafficSign[TrafficSignIndex].value+'</h4><br>'+
                           '<tab="10"><b>Id</b><tab="40"> : '+IntToStr(ListTrafficSign[TrafficSignIndex].id)+'<br>'+
                           '<tab="10"><b>Lat</b><tab="40"> : '+DoubleToStrDigit(ListTrafficSign[TrafficSignIndex].lat,5)+'<br>'+
                           '<tab="10"><b>Lng</b><tab="40"> : '+DoubleToStrDigit(ListTrafficSign[TrafficSignIndex].lng,5),
                           250 // width=250
                           );
end;

procedure TForm30.SequencesChange(Sender: TObject);
begin
 if assigned(Sender) then
   SetSequenceImage(TMapillarySequence(sequences.Items.Objects[sequences.ItemIndex]),0);

 map.SetFocus;
end;



// selected a image in a sequence and show it
procedure TForm30.SetSequenceImage(const Sequence : TMapillarySequence; const ImageIndex : integer;const moveMap:boolean=true);
var bmp:TBitmap;
    L:TListDataDetections;
    i,n:integer;
begin
   SelectedSequence   := Sequence;
   SelectedImageIndex := ImageIndex;

   if assigned(SelectedSequence)and((SelectedImageIndex>-1) and( SelectedImageIndex<SelectedSequence.Count)) then
   begin

     Detections.Lines.Clear;


     sequences.OnChange  := nil;
     sequences.ItemIndex := sequences.Items.IndexOf(SelectedSequence.Sequence_id);
     sequences.OnChange  := SequencesChange;

     if moveMap then
       map.setCenter(SelectedSequence[SelectedImageIndex].Lat,SelectedSequence[SelectedImageIndex].Lng);


       PositionView.SetPosition(SelectedSequence[SelectedImageIndex].Lat,SelectedSequence[SelectedImageIndex].Lng) ;
       PositionView.Visible := true;

     pnImage.Enabled := true;

     bmp := TBitmap.Create;
     try

     // load image 256*256
     // also url1024 and url2048
     if FMapillaryLayer.LoadMapillaryBitmap(SelectedSequence[SelectedImageIndex].Url256,bmp) then
        Image.Picture.Assign(bmp);

     lbImage.Caption := inttostr(SelectedImageIndex+1)+'/'+inttostr(SelectedSequence.Count);

    finally
      bmp.Free;
    end;


    // search for elements contained in the image

    L := TListDataDetections.Create;
    try
     n := FMapillaryLayer.DetectionsImage(SelectedSequence[SelectedImageIndex].Id,L);

     Detections.Lines.BeginUpdate;

     for i := 0 to n-1 do
     begin
       Detections.Lines.Add(L[i].value);
     end;

     Detections.Lines.EndUpdate;



    finally
     L.Free;
    end;



   end
   else
   begin

     Image.Picture.Assign(nil);
     lbImage.Caption    := '';
     SelectedSequence   := nil;
     SelectedImageIndex := -1;
     pnImage.Enabled    := false;
     PositionView.Visible := false;



   end;

end;


// show first image of selected sequence
procedure TForm30.FirstImageClick(Sender: TObject);
begin
  SetSequenceImage(SelectedSequence,0);
end;

// show last image of selected sequence
procedure TForm30.LastImageClick(Sender: TObject);
begin
  SetSequenceImage(SelectedSequence,SelectedSequence.Count-1);
end;

// show next image of selected sequence
procedure TForm30.NextImageClick(Sender: TObject);
begin
 if SelectedImageIndex<SelectedSequence.Count-1 then
  inc(SelectedImageIndex);

 SetSequenceImage(SelectedSequence,SelectedImageIndex);
end;

// show prev image of selected sequence
procedure TForm30.PrevImageClick(Sender: TObject);
begin

 if SelectedImageIndex>0 then
  dec(SelectedImageIndex);

 SetSequenceImage(SelectedSequence,SelectedImageIndex);

end;


// fired before call mapillary
procedure TForm30.doBeginRequest(sender: TObject);
begin
 inc(BeginRequestCount);
 MapillaryRequest.Caption := inttostr(BeginRequestCount)+' Requests - '+inttostr(EndRequestCount)+' Responses';
end;



// fired when mapillary request is done
procedure TForm30.doEndRequest(sender: TObject);
var i,j:integer;

begin
 inc(EndRequestCount);
 MapillaryRequest.Caption := inttostr(BeginRequestCount)+' Requests - '+inttostr(EndRequestCount)+' Responses';

 sequences.Items.BeginUpdate;

  sequences.items.clear;

 for i := 0 to FMapillaryLayer.Tiles.Count-1  do
  for j :=0  to FMapillaryLayer.Tiles[i].Sequences.Count-1 do
   sequences.items.addObject(FMapillaryLayer.Tiles[i].Sequences[j].Sequence_id,FMapillaryLayer.Tiles[i].Sequences[j]);



 sequences.Items.EndUpdate;

 SetSequenceImage(SelectedSequence,SelectedImageIndex,false);

end;

procedure TForm30.FormCreate(Sender: TObject);
begin


  FMapillaryLayer := TECMapillaryLayer.Create(map);


  FMapillaryLayer.OnClick := doOnMapillaryLayerClick;
  FMapillaryLayer.OnTrafficSignClick := doOnMapillaryLayerTrafficSignClick;

  FMapillaryLayer.OnBeginRequest := doBeginRequest;
  FMapillaryLayer.OnendRequest   := doEndRequest;


  FMapillaryLayer.LocalCache := ExtractfilePath(ParamStr(0)) + 'cache';

  FMapillaryLayer.Visible := true;


  // use your access token see www.mapillary.com
  // FMapillaryLayer.AccessToken := 'your_token';

  SelectedSequence   := nil;
  SelectedImageIndex := -1;


  { Position marker }

   PositionView := map.AddMarker(map.Latitude, map.Longitude);
   PositionView.Visible := false;

  { load new icon }


  PositionView.filename := GOOGLE_RED_DOT_ICON; // unit uecMapUtil also BLUE,YELLOW and GREEN

  PositionView.YAnchor := 32;

  // on top of all over items, even if zindex <
  PositionView.setFocus;



  mapChangeMapZoom(map);




end;

procedure TForm30.FormDestroy(Sender: TObject);
begin

  FMapillaryLayer.Free;

end;

procedure TForm30.mapChangeMapZoom(Sender: TObject);
begin
  if map.Zoom<FMapillaryLayer.MinZoom then
  begin
   Label1.caption := 'Zoom low - Mapillary Layer inactive';
   LoadVisibleArea.enabled := true;
  end
  else
  begin
   Label1.caption := 'Mapillary Layer activated';
   LoadVisibleArea.enabled := false;
  end;
end;


// select photo nearest this point
procedure TForm30.mapMapDblClick(sender: TObject; const Lat, Lng: Double);
var seq        : TMapillarySequence;
    img        : TMapillaryImage;
    PhotoIndex,
    FindDistance : integer;
    Group        : TECShapes;
    Line         : TECShapeLine;
    Poi          : TECShapePOI;
begin


  FindDistance := FMapillaryLayer.FindImageClose(lat,lng,distance.Value,seq,PhotoIndex);

  if FindDistance>0 then
  begin


     // "closest" is the group used for draw the click point and line up to the photo
     Group := map['closest'];
     Group.Clear;

     Poi      := Group.AddPoint(lat,lng,seq.Color);
     Poi.Hint := inttostr(FindDistance)+' meters';

     img := seq.images[PhotoIndex];

     Line           := Group.AddLine([lat,lng,img.lat,img.lng]);
     Line.Color     := seq.Color;
     Line.PenStyle  := psDot;
     Line.Hint      := Poi.Hint;

    SetSequenceImage(seq,PhotoIndex,false);

  end;


end;



end.
