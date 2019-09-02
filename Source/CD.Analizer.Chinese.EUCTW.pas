unit CD.Analizer.Chinese.EUCTW;

interface

uses
  CD.Analizer.CharDistribution;

type
  TEUCTWDistributionAnalyser = class(TCharDistributionAnalyser)
    // EUCTW frequency table
    // Converted from big5 work
    // by Taiwan's Mandarin Promotion Council
    // <http://www.edu.tw:81/mandr/>
    { ******************************************************************************
      * 128  --> 0.42261
      * 256  --> 0.57851
      * 512  --> 0.74851
      * 1024 --> 0.89384
      * 2048 --> 0.97583
      *
      * Idea Distribution Ratio = 0.74851/(1-0.74851) =2.98
      * Random Distribution Ration = 512/(5401-512)=0.105
      *
      * Typical Distribution Ratio about 25% of Ideal one, still much higher than RDR
      ***************************************************************************** }
  private
    const
      EUCTW_TYPICAL_DISTRIBUTION_RATIO = 0.75;
    function EUCTW_CHAR2FREQ_ORDER: TArray<Integer>;
  public
    constructor Create;
    function GetOrder(ABuffer: TArray<Byte>; const AOffset: Integer): Integer; override;
  end;

implementation

{ TEUCTWDistributionAnalyser }

constructor TEUCTWDistributionAnalyser.Create;
begin
  FCharToFreqOrder := EUCTW_CHAR2FREQ_ORDER;
  FTypicalDistributionRatio := EUCTW_TYPICAL_DISTRIBUTION_RATIO;
end;

function TEUCTWDistributionAnalyser.EUCTW_CHAR2FREQ_ORDER: TArray<Integer>;
begin
  Result := [{$I ..\Source\inc\EUCTWDistributionAnalyser.inc}];
end;

function TEUCTWDistributionAnalyser.GetOrder(ABuffer: TArray<Byte>; const AOffset: Integer): Integer;
begin
  if (ABuffer[AOffset] >= $C4) then
    Result := 94 * (ABuffer[AOffset] - $C4) + ABuffer[AOffset + 1] - $A1
  else
    Result := -1;
end;

end.

