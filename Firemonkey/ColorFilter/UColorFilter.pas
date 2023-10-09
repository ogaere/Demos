unit UColorFilter;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.uecNativeMapControl, FMX.Controls.Presentation, FMX.StdCtrls,
  Generics.Collections, Generics.Defaults, FMX.Colors,FMX.uecmaputil, FMX.ListBox, FMX.Edit,
  FMX.EditBox, FMX.SpinBox;

type
  TForm18 = class(TForm)
    map: TECNativeMap;
    Panel2: TPanel;
    NewColor: TColorComboBox;
    SelectColor: TRectangle;
    label1: TLabel;
    Label2: TLabel;
    GroupBox1: TGroupBox;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    RadioButton3: TRadioButton;
    RadioButton4: TRadioButton;
    RadioButton5: TRadioButton;
    RadioButton6: TRadioButton;
    light: TSpinBox;
    Dark: TSpinBox;
    procedure FormCreate(Sender: TObject);
    procedure mapMapClick(sender: TObject; const Lat, Lng: Double);
    procedure NewColorChange(Sender: TObject);
    procedure RadioButton3Click(Sender: TObject);
    procedure lightChange(Sender: TObject);
    procedure DarkChange(Sender: TObject);

  private
    { Déclarations privées }

  public
    { Déclarations publiques }
  end;

var
  Form18: TForm18;

implementation

{$R *.fmx}


procedure TForm18.FormCreate(Sender: TObject);
begin
  Dark.Value  := map.ColorFilter.DarkValue;
  Light.Value := map.ColorFilter.LightValue;
end;

procedure TForm18.lightChange(Sender: TObject);
begin
  map.ColorFilter.LightValue := round(Light.Value);
end;

procedure TForm18.DarkChange(Sender: TObject);
begin
  map.ColorFilter.DarkValue := round(Dark.Value);
end;

// find color at point click
procedure TForm18.mapMapClick(sender: TObject; const Lat, Lng: Double);
var x,y:integer;
   Data: TBitmapData;
   ScreenShot : TBitmap;
begin
  x := map.MouseX;
  y := map.MouseY;

 ScreenShot := map.ScreenShot;

 if ScreenShot.Map(TMapAccess.ReadWrite, Data) then
 begin

   SelectColor.Fill.Color := Data.getPixel(x,y);

     ScreenShot.Unmap(Data);
 end;
end;


// replace SelectColor.Fill.Color by NewColor.Color
procedure TForm18.NewColorChange(Sender: TObject);
begin
  map.ColorFilter.Colors.Add(SelectColor.Fill.Color);
  map.ColorFilter.Colors.Add(NewColor.Color);

  map.ColorFilter.ActionColor := acReplace;

  // tolerance 5%
  map.ColorFilter.Tolerance := 0.05;

  // apply change
  map.ColorFilter.Filter :=  fcCustom;
end;


// select color filter
procedure TForm18.RadioButton3Click(Sender: TObject);
begin
 case TRadioButton(sender).tag of
  0 : map.ColorFilter.Filter := fcGrey;
  1 : map.ColorFilter.Filter := fcSepia;
  2 : map.ColorFilter.Filter := fcInvert;
  3 : map.Light := true;
  4 : map.Dark  := true;
  5 : begin
       map.ColorFilter.Filter := fcNone;
       map.ColorFilter.Colors.Clear;
      end;

 end;
end;

end.
