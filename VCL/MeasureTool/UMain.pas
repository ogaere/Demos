unit UMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uecNativeMapControl,uecMapUtil,
  Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TFormMeasureTool = class(TForm)
    map: TECNativeMap;
    Panel1: TPanel;
    GroupBox1: TGroupBox;
    rbHide: TRadioButton;
    rbDistance: TRadioButton;
    rbArea: TRadioButton;
    lbArea: TLabel;
    lbDistance: TLabel;
    GroupBox2: TGroupBox;
    rbMetric: TRadioButton;
    rbImperial: TRadioButton;
    GroupBox3: TGroupBox;
    rbBlackWhite: TRadioButton;
    rbOrange: TRadioButton;
    GroupBox4: TGroupBox;
    rbClassic: TRadioButton;
    rbSolid: TRadioButton;
    ckLabel: TCheckBox;
    procedure doShowMeasureTool(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure doUnit(Sender: TObject);
    procedure doColors(Sender: TObject);
    procedure doStyle(Sender: TObject);
    procedure doLabel(Sender: TObject);
  private
    { Déclarations privées }

    procedure doChange(Sender : TObject);

  public
    { Déclarations publiques }
  end;

var
  FormMeasureTool: TFormMeasureTool;

implementation

{$R *.dfm}

// This demo shows you how to manage the measurement tool


procedure TFormMeasureTool.FormCreate(Sender: TObject);
begin
 // react to changes in distance or area
 map.MeasureTool.OnChange := doChange;
end;

// fired when distance or area change
procedure TFormMeasureTool.doChange(Sender : TObject);
begin
 // you can also access the values
 // map.MeasureTool.Distance
 // map.MeasureTool.Area
 if map.MeasureTool.MeasureArea then
 begin
   lbDistance.Caption := 'Perimeter : '+map.MeasureTool.DistanceText;
   lbArea.Caption     := 'Area : '+map.MeasureTool.AreaText;
 end
 else
 begin
  lbDistance.Caption := 'Distance : '+map.MeasureTool.DistanceText;
  lbArea.Caption     := '';
 end;

end;

// show / hide Measure and select distance or area
procedure TFormMeasureTool.doShowMeasureTool(Sender: TObject);
begin
 if Sender is TRadioButton then
 begin
  map.MeasureTool.Visible     := TRadioButton(Sender).tag>0;
  map.MeasureTool.MeasureArea := TRadioButton(Sender).tag=2;
 end;
end;

// change unit
procedure TFormMeasureTool.doUnit(Sender: TObject);
begin
 if Sender is TradioButton then
 begin
  if TRadioButton(Sender).tag=0 then
   map.MeasureTool.UnitMeasure := msMetric
  else
   map.MeasureTool.UnitMeasure := msImperial;
 end;
end;

// change colors
procedure TFormMeasureTool.doColors(Sender: TObject);
begin
 if Sender is TradioButton then
 begin
  if TRadioButton(Sender).tag=0 then
  begin
   map.MeasureTool.Color      := clBlack;
   map.MeasureTool.FillColor  := clBlack;
   map.MeasureTool.PointColor := clWhite;

  end
  else
  begin
   map.MeasureTool.Color      := StrToColor('#e34a33');
   map.MeasureTool.PointColor := StrToColor('#fee8c8');
   map.MeasureTool.FillColor  := StrToColor('#e34a33');
  end;
 end;
end;

// change style
// with styles you can change everything, even colors,
// but in this demo the colors are managed separately for documentation purposes.
procedure TFormMeasureTool.doStyle(Sender: TObject);
begin
  if Sender is TradioButton then
 begin
  if TRadioButton(Sender).tag=0 then
  begin
    map.MeasureTool.resetStyle;
  end
  else
  begin
    map.Styles.ClearAddRule('#MeasureTool.line {weight:2;bsize:2;penStyle:Solid}');
   map.Styles.ClearAddRule('#MeasureTool.polygone {weight:2;bsize:2;penStyle:Solid}');
   map.Styles.ClearAddRule('.poi.parent:MeasureTool {height:10;width:10}');
  end;
 end;
end;

// show / hide label
procedure TFormMeasureTool.doLabel(Sender: TObject);
begin
 map.MeasureTool.ShowLabel := ckLabel.Checked;
end;






end.
