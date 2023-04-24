unit UMappilary;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, Generics.Collections,
  FMX.uecNativeShape, FMX.StdCtrls, FMX.uecMapUtil, FMX.Objects, System.IOUtils,
  FMX.uecNativeMapControl, FMX.Controls.Presentation, FMX.ListBox, FMX.Edit,
  FMX.uecMapillary,
  System.UIConsts,
  FMX.EditBox, FMX.SpinBox, FMX.ScrollBox, FMX.Memo, FMX.Layouts;

type



  TForm2 = class(TForm)
    Panel1: TPanel;
    Image: TImage;
    StyleBook1: TStyleBook;
    Rectangle2: TRectangle;
    map: TECNativeMap;
    Label1: TLabel;
    address: TEdit;
    totalSequences: TLabel;
    location: TLabel;
    date: TLabel;
    NextImage: TButton;
    PrevImage: TButton;
    SelectedPhoto: TLabel;
    Rectangle1: TRectangle;
    Label2: TLabel;
    distance: TSpinBox;
    startImage: TButton;
    LastImage: TButton;
    SeqAniIndicator: TAniIndicator;
    findImage: TLabel;
    Sequences: TComboBox;
    Label3: TLabel;

    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure addressKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);


    procedure mapMapDblClick(sender: TObject; const Lat, Lng: Double);
    procedure FirstImageClick(Sender: TObject);
    procedure PrevImageClick(Sender: TObject);
    procedure NextImageClick(Sender: TObject);
    procedure LastImageClick(Sender: TObject);
    procedure SequencesChange(Sender: TObject);
    procedure mapChangeMapZoom(Sender: TObject);
  private
    { Déclarations privées }
   SelectedSequence   : TMapillarySequence;
   SelectedImageIndex : integer;


   FECMapillaryLayer : TECMapillaryLayer;

   PositionView     : TECShapeMarker;


  procedure SetSequenceImage(const Sequence : TMapillarySequence; const ImageIndex : integer;const moveMap:boolean=true);


   procedure doMapillaryClick(Layer: TECMapillaryLayer;
    Item : TECShape;
    MapillarySequence: TMapillarySequence; PhotoIndex: integer);





    procedure doEndRequest(sender:TObject);
    procedure doBeginRequest(sender : TObject);

    procedure doColor(Layer : TECMapillaryLayer;
                                       MappilarySequence: TMapillarySequence;
                                       var SequenceColor:TColor) ;
  public
    { Déclarations publiques }
  end;

var
  Form2: TForm2;

implementation

{$R *.fmx}




procedure TForm2.FormCreate(Sender: TObject);
begin

 caption := 'Mapillary Layer for TECNativeMap - © '+inttostr(CurrentYear)+' E. Christophe'  ;

 SeqAniIndicator.Visible := false;
 SeqAniIndicator.Enabled := false;

 map.ScaleMarkerToZoom := true;

 map.Reticle      := true;
 map.ReticleColor :=  claWhite;

 map.LocalCache := ExtractfilePath(ParamStr(0))+'cache';



 FECMapillaryLayer := TECMapillaryLayer.Create(map);
  // here you mappilary accesstoken https://www.mapillary.com/signup
  // FECMapillaryLayer.AccessToken := ''


 FECMapillaryLayer.OnClick     := doMapillaryClick;

 FECMapillaryLayer.OnEndRequest := doEndRequest;
 FECMapillaryLayer.OnBeginRequest := doBeginRequest;

 // for select colors for sequences
 //FECMappilaryLayer.OnSequenceColor := doColor;

 FECMapillaryLayer.Visible := true;

 PositionView           := map.AddMarker(map.Latitude,map.Longitude);
 PositionView.Visible   := false;
 { load new icon }
 PositionView.filename := GOOGLE_RED_DOT_ICON;
 PositionView.YAnchor := 32;
 // on top of all over items, even if zindex <
 PositionView.setFocus;

 mapChangeMapZoom(map);


end;

procedure TForm2.doColor(Layer : TECMapillaryLayer;
                                       MappilarySequence: TMapillarySequence;
                                       var SequenceColor:TColor) ;
begin
  // here adapt the color
  // SequenceColor := $ffeeffee;
end;

procedure TForm2.FormDestroy(Sender: TObject);
begin
 FECMapillaryLayer.Free;
end;


procedure TForm2.addressKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char;
  Shift: TShiftState);
begin

 if (Key = 13) then
   Map.Address := Address.Text;

end;


// click on mappilary items
procedure TForm2.doMapillaryClick(Layer: TECMapillaryLayer;
    Item : TECShape; // ( TECShapeLine, TECShapePoi or TECShapeMarker function on zoom level )
    MapillarySequence: TMapillarySequence;
    PhotoIndex: integer // returns the nearest photo of the clicked point
    );
begin
  SetSequenceImage(MapillarySequence,PhotoIndex);
end;









// find the nearest photo among those in the area




procedure TForm2.mapChangeMapZoom(Sender: TObject);
begin
if map.Zoom<FECMapillaryLayer.MinZoom then
  begin
   Label3.text := 'Zoom low - Mapillary Layer inactive';
   //LoadVisibleArea.enabled := true;
  end
  else
  begin
   Label3.text := 'Mapillary Layer activated';
   //LoadVisibleArea.enabled := false;
  end;
end;

procedure TForm2.mapMapDblClick(sender: TObject; const Lat, Lng: Double);
var seq        : TMapillarySequence;
    PhotoIndex,
    FindDistance : integer;
    Group        : TECShapes;
begin

  // "closest" is the group used for draw the click point and line up to the photo
  Group := map.Group['closest'];


  Group.Clear;

  FindImage.Text := '';

  FindDistance := FECMapillaryLayer.FindImageClose(lat,lng,round(Distance.Value),seq,PhotoIndex);

  if FindDistance>0 then
  begin
    Group.AddPoint(lat,lng,seq.Color);


    Group.Lines.Add([lat,lng,seq.images[PhotoIndex].lat,seq.images[PhotoIndex].lng]);
    Group.Lines[0].Color := seq.Color;
    Group.Lines[0].PenStyle := psDot;




   FindImage.Text := inttostr(FindDistance)+' m';

   FindImage.TextSettings.FontColor := seq.Color;

   Group.Pois[0].Hint  := inttostr(FindDistance)+' meters';


   Group.Lines[0].Hint := Group.Pois[0].Hint;


  end;


end;



procedure TForm2.SequencesChange(Sender: TObject);
begin
if assigned(Sender)and(sequences.ItemIndex>-1) then
   SetSequenceImage(TMapillarySequence(sequences.Items.Objects[sequences.ItemIndex]),0);

 map.SetFocus;
end;

procedure TForm2.SetSequenceImage(const Sequence : TMapillarySequence; const ImageIndex : integer;const moveMap:boolean=true);
var bmp:TBitmap;
begin
   SelectedSequence   := Sequence;
   SelectedImageIndex := ImageIndex;

   if assigned(SelectedSequence)and((SelectedImageIndex>-1) and( SelectedImageIndex<SelectedSequence.Count)) then
   begin

     sequences.OnChange  := nil;
     sequences.ItemIndex := sequences.Items.IndexOf(SelectedSequence.Sequence_id);
     sequences.OnChange  := SequencesChange;

     if moveMap then
       map.setCenter(SelectedSequence[SelectedImageIndex].Lat,SelectedSequence[SelectedImageIndex].Lng);


       PositionView.SetPosition(SelectedSequence[SelectedImageIndex].Lat,SelectedSequence[SelectedImageIndex].Lng) ;
       PositionView.Visible := true;



     bmp := TBitmap.Create;
     try

     if FECMapillaryLayer.LoadMapillaryBitmap(SelectedSequence[SelectedImageIndex].Url256,bmp) then
        Image.bitmap.Assign(bmp);

      SelectedPhoto.text := inttostr(SelectedImageIndex+1)+'/'+inttostr(SelectedSequence.Count);

    finally
      bmp.Free;
    end;
   end
   else
   begin

     Image.bitmap.Assign(nil);
     SelectedPhoto.text    := '';
     SelectedSequence   := nil;
     SelectedImageIndex := -1;

     PositionView.Visible := false;


   end;

end;



// navigate in sequence image by image

procedure TForm2.FirstImageClick(Sender: TObject);
begin
  SetSequenceImage(SelectedSequence,0);
end;

procedure TForm2.LastImageClick(Sender: TObject);
begin
  SetSequenceImage(SelectedSequence,SelectedSequence.Count-1);
end;

procedure TForm2.NextImageClick(Sender: TObject);
begin
 if SelectedImageIndex<SelectedSequence.Count-1 then
  inc(SelectedImageIndex);

 SetSequenceImage(SelectedSequence,SelectedImageIndex);
end;

procedure TForm2.PrevImageClick(Sender: TObject);
begin

 if SelectedImageIndex>0 then
  dec(SelectedImageIndex);

 SetSequenceImage(SelectedSequence,SelectedImageIndex);

end;






procedure TForm2.doBeginRequest(Sender: TObject);
begin
 SeqAniIndicator.Visible := true;
 SeqAniIndicator.Enabled := true;
end;


procedure TForm2.doEndRequest(sender:TObject);
var i,j,n:integer;
begin

 SeqAniIndicator.Visible := false;
 SeqAniIndicator.Enabled := false;

 sequences.Items.BeginUpdate;

  sequences.items.clear;

 for i := 0 to FECMapillaryLayer.Tiles.Count-1  do
  for j :=0  to FECMapillaryLayer.Tiles[i].Sequences.Count-1 do
   sequences.items.addObject(FECMapillaryLayer.Tiles[i].Sequences[j].Sequence_id,FECMapillaryLayer.Tiles[i].Sequences[j]);



 sequences.Items.EndUpdate;

 SetSequenceImage(SelectedSequence,SelectedImageIndex,false);

 end;








end.
