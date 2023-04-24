unit UDialogMapOlt;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls,FMX.Platform;

type
  TFDialogMapOrOlt = class(TForm)
    Button2: TButton;
    tomap: TButton;
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  FDialogMapOrOlt: TFDialogMapOrOlt;

  function isLoadInMap(ParentForm:TForm=nil):boolean;

implementation

{$R *.fmx}

function isLoadInMap(ParentForm:TForm=nil):boolean;
begin
  FDialogMapOrOlt := TFDialogMapOrOlt.Create(ParentForm);
  try
  
    result := FDialogMapOrOlt.ShowModal=mrOK;

  finally
   FDialogMapOrOlt.Free;
  end;
end;

end.
