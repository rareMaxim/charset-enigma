unit CharsetEnigma.Lite;

interface

uses
  CharsetEnigma.Core;

type
  IDetectionResult = CharsetEnigma.Core.IDetectionResult;

  IDetectionDetail = CharsetEnigma.Core.IDetectionDetail;

  TCharsetEnigma = class(CharsetEnigma.Core.TCharsetEnigma)
  public
    class function IsProVersion: Boolean; virtual;
  end;

implementation

uses
  CD.Prober.Register.Lite;

{ TCharsetEnigma }

class function TCharsetEnigma.IsProVersion: Boolean;
begin
  result := False;
end;

end.

