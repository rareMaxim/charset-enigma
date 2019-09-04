unit CD.Analizer.Chinese.BIG5;

interface

uses
  CD.Analizer.CharDistribution;

type
  TBIG5DistributionAnalyser = class(TCharDistributionAnalyser)
  private
    const
      BIG5_TYPICAL_DISTRIBUTION_RATIO = 0.75;
    function BIG5_CHAR2FREQ_ORDER: TArray<Integer>;
  public
    constructor Create;
    /// <summary>
    /// first  byte range: 0xa4 -- 0xfe
    /// second byte range: 0x40 -- 0x7e , 0xa1 -- 0xfe
    /// no validation needed here. State machine has done that
    /// </summary>
    function GetOrder(ABuffer: TArray<Byte>; const AOffset: Integer): Integer; override;
  end;

implementation

{ TBIG5DistributionAnalyser }

function TBIG5DistributionAnalyser.BIG5_CHAR2FREQ_ORDER: TArray<Integer>;
begin
  Result := [{$I ..\Source\inc\BIG5DistributionAnalyser.inc}];
end;

constructor TBIG5DistributionAnalyser.Create;
begin
  FCharToFreqOrder := BIG5_CHAR2FREQ_ORDER;
  FTypicalDistributionRatio := BIG5_TYPICAL_DISTRIBUTION_RATIO;
end;

function TBIG5DistributionAnalyser.GetOrder(ABuffer: TArray<Byte>; const AOffset: Integer): Integer;
begin
  if (ABuffer[AOffset] >= $A4) then
  begin
    if (ABuffer[AOffset + 1] >= $A1) then
      Result := 157 * (ABuffer[AOffset] - $A4) + ABuffer[AOffset + 1] - $A1 + 63
    else
      Result := 157 * (ABuffer[AOffset] - $A4) + ABuffer[AOffset + 1] - $40
  end
  else
    Result := -1;
end;

end.

