program CEDemo;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  CharsetEnigma.Lite,
  System.IOUtils,
  System.SysUtils;

type
  TApplication = class
    class procedure Main;
  end;

class procedure TApplication.Main;
var
  LFileName: string;
  LResult: IDetectionResult;
  I: Integer;
begin
  if ParamCount = 0 then
  begin
    WriteLn('Usage: CEDemo <filename>');
    Exit;
  end;
  for I := 1 to ParamCount do
  begin
    LFileName := ParamStr(I);
    LResult := TCharsetEnigma.DetectFromFile(LFileName);
    if LResult.Detected = nil then
      Exit;
    if ParamCount = 1 then
      Writeln('Charset: ', LResult.Detected.EncodingName, ' confidence: ', LResult.Detected.Confidence.ToString)
    else if ParamCount > 1 then
      Writeln('Filename: ', ExtractFileName(LFileName), ' Charset: ', LResult.Detected.EncodingName,
        ' confidence: ', LResult.Detected.Confidence.ToString);

  end;
end;

begin
  try
    { TODO -oUser -cConsole Main : Insert code here }
    ReportMemoryLeaksOnShutdown := True;
    TApplication.Main;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
  Readln;
end.

