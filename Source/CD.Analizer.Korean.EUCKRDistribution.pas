unit CD.Analizer.Korean.EUCKRDistribution;

interface

uses
  CD.Analizer.CharDistribution;

type
  TEUCKRDistributionAnalyser = class(TCharDistributionAnalyser)
    // Sampling from about 20M text materials include literature and computer technology
    { *
      * 128  --> 0.79
      * 256  --> 0.92
      * 512  --> 0.986
      * 1024 --> 0.99944
      * 2048 --> 0.99999
      *
      * Idea Distribution Ratio = 0.98653 / (1-0.98653) = 73.24
      * Random Distribution Ration = 512 / (2350-512) = 0.279.
      * }
  public
    const
      EUCKR_TYPICAL_DISTRIBUTION_RATIO = 6.0;
    function EUCKR_CHAR2FREQ_ORDER: TArray<Integer>;
    constructor Create;
    /// <summary>
    /// first  byte range: 0xb0 -- 0xfe
    /// second byte range: 0xa1 -- 0xfe
    /// no validation needed here. State machine has done that
    /// </summary>
    function GetOrder(ABuffer: TArray<Byte>; const AOffset: Integer): Integer; override;
  end;

implementation

{ TEUCKRDistributionAnalyser }

constructor TEUCKRDistributionAnalyser.Create;
begin
  FCharToFreqOrder := EUCKR_CHAR2FREQ_ORDER;
  FTypicalDistributionRatio := EUCKR_TYPICAL_DISTRIBUTION_RATIO;
end;

function TEUCKRDistributionAnalyser.EUCKR_CHAR2FREQ_ORDER: TArray<Integer>;
begin
  Result := [{$I ..\Source\inc\EUCKRDistributionAnalyser.inc}];
end;

function TEUCKRDistributionAnalyser.GetOrder(ABuffer: TArray<Byte>; const AOffset: Integer): Integer;
begin
  if (ABuffer[AOffset] >= $B0) then
    Result := 94 * (ABuffer[AOffset] - $B0) + ABuffer[AOffset + 1] - $A1
  else
    Result := -1;
end;

end.

