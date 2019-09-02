unit CD.Analizer.Chinese.GB18030;

interface

uses
  CD.Analizer.CharDistribution;

type
  TGB18030DistributionAnalyser = class(TCharDistributionAnalyser)
    // GB2312 most frequently used character table
    // Char to FreqOrder table, from hz6763
    { ******************************************************************************
      * 512  --> 0.79  -- 0.79
      * 1024 --> 0.92  -- 0.13
      * 2048 --> 0.98  -- 0.06
      * 6768 --> 1.00  -- 0.02
      *
      * Idea Distribution Ratio = 0.79135/(1-0.79135) = 3.79
      * Random Distribution Ration = 512 / (3755 - 512) = 0.157
      *
      * Typical Distribution Ratio about 25% of Ideal one, still much higher that RDR
      ***************************************************************************** }
  private
    const
      GB2312_TYPICAL_DISTRIBUTION_RATIO = 0.9;
    function GB2312_CHAR2FREQ_ORDER: TArray<Integer>;
  public
    constructor Create;
    /// <summary>
    /// for GB2312 encoding, we are interested
    /// first  byte range: 0xb0 -- 0xfe
    /// second byte range: 0xa1 -- 0xfe
    /// no validation needed here. State machine has done that
    /// </summary>
    /// <returns></returns>
    function GetOrder(ABuffer: TArray<Byte>; const AOffset: Integer): Integer; override;
  end;

implementation

{ TGB18030DistributionAnalyser }

constructor TGB18030DistributionAnalyser.Create;
begin
  inherited;
  FCharToFreqOrder := GB2312_CHAR2FREQ_ORDER;
  FTypicalDistributionRatio := GB2312_TYPICAL_DISTRIBUTION_RATIO;
end;

function TGB18030DistributionAnalyser.GB2312_CHAR2FREQ_ORDER: TArray<Integer>;
begin
  Result := [{$I ..\Source\Inc\GB18030DistributionAnalyser.inc}];
end;

function TGB18030DistributionAnalyser.GetOrder(ABuffer: TArray<Byte>; const AOffset: Integer): Integer;
begin
  if (ABuffer[AOffset] >= $B0) and (ABuffer[AOffset + 1] >= $A1) then
    Result := 94 * (ABuffer[AOffset] - $B0) + ABuffer[AOffset + 1] - $A1
  else
    Result := -1;
end;

end.

