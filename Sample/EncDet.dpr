program EncDet;

uses
  System.StartUpCopy,
  FMX.Forms,
  EncodingDetecor.UI in 'EncodingDetecor.UI.pas' {Form4};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm4, Form4);
  Application.Run;
end.

