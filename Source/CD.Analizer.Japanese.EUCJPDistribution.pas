unit CD.Analizer.Japanese.EUCJPDistribution;

interface

uses
  CD.Analizer.Japanese.SJISDistribution;

type
  TEUCJPDistributionAnalyser = class(TSJISDistributionAnalyser)
  public
    constructor Create;
    /// <summary>
    /// first  byte range: 0xa0 -- 0xfe
    /// second byte range: 0xa1 -- 0xfe
    /// no validation needed here. State machine has done that
    /// </summary>
    function GetOrder(ABuffer: TArray<Byte>; const AOffset: Integer): Integer; override;
  end;

implementation

{ TEUCJPDistributionAnalyser }

constructor TEUCJPDistributionAnalyser.Create;
begin
  inherited Create;
end;

function TEUCJPDistributionAnalyser.GetOrder(ABuffer: TArray<Byte>; const AOffset: Integer): Integer;
begin
  if (ABuffer[AOffset] >= $A0) then
    Result := 94 * (ABuffer[AOffset] - $A1) + ABuffer[AOffset + 1] - $A1
  else
    Result := -1;
end;

end.

