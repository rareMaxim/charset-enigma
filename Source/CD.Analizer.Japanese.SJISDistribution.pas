unit CD.Analizer.Japanese.SJISDistribution;

interface

uses
  CD.Analizer.CharDistribution;

type
  // Sampling from about 20M text materials include literature and computer technology
  // Japanese frequency table, applied to both S-JIS and EUC-JP
  // They are sorted in order.

  { ******************************************************************************
    * 128  --> 0.77094
    * 256  --> 0.85710
    * 512  --> 0.92635
    * 1024 --> 0.97130
    * 2048 --> 0.99431
    *
    * Idea Distribution Ratio = 0.92635 / (1-0.92635) = 12.58
    * Random Distribution Ration = 512 / (2965+62+83+86-512) = 0.191
    *
    * Typical Distribution Ratio, 25% of IDR
    ***************************************************************************** }

  TSJISDistributionAnalyser = class(TCharDistributionAnalyser)
    const
      SJIS_TYPICAL_DISTRIBUTION_RATIO = 3.0;
  protected
    function SJIS_CHAR2FREQ_ORDER: TArray<Integer>;
  public
    constructor Create;
    /// <summary>
    /// first  byte range: 0x81 -- 0x9f , 0xe0 -- 0xfe
    /// second byte range: 0x40 -- 0x7e,  0x81 -- oxfe
    /// no validation needed here. State machine has done that
    /// </summary>
    function GetOrder(ABuffer: TArray<Byte>; const offset: Integer): Integer; override;
  end;

implementation

{ TSJISDistributionAnalyser }

constructor TSJISDistributionAnalyser.Create;
begin
  FCharToFreqOrder := SJIS_CHAR2FREQ_ORDER;
  FTypicalDistributionRatio := SJIS_TYPICAL_DISTRIBUTION_RATIO;
end;

function TSJISDistributionAnalyser.GetOrder(ABuffer: TArray<Byte>; const offset: Integer): Integer;
var
  order: Integer;
begin
  // order := 0;
  if (ABuffer[offset] >= $81) and (ABuffer[offset] <= $9F) then
    order := 188 * (ABuffer[offset] - $81)
  else if (ABuffer[offset] >= $E0) and (ABuffer[offset] <= $EF) then
    order := 188 * (ABuffer[offset] - $E0 + 31)
  else
    Exit(-1);
  Inc(order, ABuffer[offset + 1] - $40);
  if (ABuffer[offset + 1] > $7F) then
    Dec(order);
  Exit(order);
end;

function TSJISDistributionAnalyser.SJIS_CHAR2FREQ_ORDER: TArray<Integer>;
begin
  Result := [{$I ..\Source\Inc\SJISDistributionAnalyser.inc}];
end;

end.

