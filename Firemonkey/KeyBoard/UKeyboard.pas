unit UKeyboard;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Memo.Types,
  FMX.Objects,

 {$IFDEF MSWINDOWS}
   Winapi.Windows, // for VK_XXX
{$ENDIF}
  FMX.uecNativeMapControl,
  FMX.uecMapUtil, // for KeyIsDown
  FMX.ScrollBox, FMX.Memo,
  FMX.Controls.Presentation, FMX.StdCtrls;

type
  TForm13 = class(TForm)
    Panel1: TPanel;
    Memo1: TMemo;
    map: TECNativeMap;
    procedure mapKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  Form13: TForm13;

implementation

{$R *.fmx}

procedure TForm13.FormCreate(Sender: TObject);
begin
 // To activate rotation you must place the map in a container (TPanel here)
 // and switch OverSizeForRotation to true
 map.OverSizeForRotation := true;
 // Give the focus directly to the map, otherwise you will have to click on it to get it
 map.CanFocus := true;
 map.SetFocus;
end;

procedure TForm13.mapKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char;
  Shift: TShiftState);
 var kUp,kDown,kLeft,kRight,kCtrl : boolean;
begin

   // KeyIsDown is in unit uecMapUtil
   kDown  := KeyIsDown(VK_DOWN);
   kLeft  := KeyIsDown(VK_LEFT);
   kUp    := KeyIsDown(VK_UP);
   kRight := KeyIsDown(VK_RIGHT);
   kCtrl  := KeyIsDown(VK_LCONTROL) or KeyIsDown(VK_RCONTROL);


   if KeyIsDown(VK_PRIOR) then
   begin
    map.RotationAngle := map.RotationAngle-10;
   end
   else
   if KeyIsDown(VK_NEXT) then
   begin
    map.RotationAngle := map.RotationAngle+10;
   end;


  // scroll by 40 pixels
   if kDown then
   begin
     if kLeft then
      map.ScrollXY(40,-40)
     else
     if kRight then
      map.ScrollXY(-40,-40)
     else
     map.ScrollXY(0,-40)
   end
   else
   if kUp then
   begin
    if kLeft then
      map.ScrollXY(40,40)
    else
    if kRight then
    map.ScrollXY(-40,40)
    else
    map.ScrollXY(0,40)
   end
   else
   if kRight then
    map.ScrollXY(-40,0)
   else
   if kLeft then
   map.ScrollXY(40,0);


    if KeyIsDown(VK_ADD) then
    begin
     if kCtrl then
       map.ZoomScaleFactor := map.ZoomScaleFactor + 10
     else
       map.Zoom := map.Zoom + 1;
    end
   else
   if KeyIsDown(VK_SUBTRACT) then
   begin
     if kCtrl then
       map.ZoomScaleFactor := map.ZoomScaleFactor - 10
     else
       map.Zoom := map.Zoom - 1;
   end;

end;

end.
