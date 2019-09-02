unit CD.Analizer.CharDistribution;

interface

type
  TCharDistributionAnalyser = class abstract
  protected
    const
      SURE_YES = 0.99;
      SURE_NO = 0.01;
      MINIMUM_DATA_THRESHOLD = 4;
      ENOUGH_DATA_THRESHOLD = 1024;
  protected
    // If this flag is set to true, detection is done and conclusion has been made
    FDone: Boolean;
    // The number of characters whose frequency order is less than 512
    FFreqChars: Integer;
    // Total character encounted.
    FTotalChars: Integer;
    // Mapping table to get frequency order from char order (get from GetOrder())
    FCharToFreqOrder: TArray<Integer>;
    // This constant value varies from language to language. It is used in calculating confidence.
    FTypicalDistributionRatio: Single;
  public
    constructor Create;
    /// <summary>
    /// Feed a block of data and do distribution analysis
    /// </summary>
    /// <remarks>
    /// we do not handle character base on its original encoding string, but
    /// convert this encoding string to a number, here called order.
    /// This allow multiple encoding of a language to share one frequency table
    /// </remarks>
    /// <param name="ABuffer">A <see cref="System.Byte"/></param>
    /// <param name="AOffset"></param>
    /// <returns></returns>
    function GetOrder(ABuffer: TArray<Byte>; const AOffset: Integer): Integer; virtual; abstract;
    /// <summary>
    /// Feed a character with known length
    /// </summary>
    /// <param name="ABuffer">A <see cref="System.Byte"/></param>
    /// <param name="AOffset">ABuffer AOffset</param>
    /// <param name="ACharLength">1 of 2 char length?</param>
    procedure HandleOneChar(ABuffer: TArray<Byte>; const AOffset: Integer; ACharLength: Integer);
    procedure Reset(); virtual;
    /// <summary>
    /// return confidence base on received data
    /// </summary>
    /// <returns></returns>
    function GetConfidence(): Single; virtual;
    // It is not necessary to receive all data to draw conclusion. For charset detection,
    // certain amount of data is enough
    function GotEnoughData(): Boolean;
  end;

implementation

{ TCharDistributionAnalyser }

constructor TCharDistributionAnalyser.Create;
begin
  Reset();
end;

function TCharDistributionAnalyser.GetConfidence: Single;
var
  r: Single;
begin
  // if we didn't receive any character in our consideration range, or the
  // number of frequent characters is below the minimum threshold, return
  // negative answer
  if (FTotalChars <= 0) or (FFreqChars <= MINIMUM_DATA_THRESHOLD) then
    Exit(SURE_NO);
  if (FTotalChars <> FFreqChars) then
  begin
    r := FFreqChars / ((FTotalChars - FFreqChars) * FTypicalDistributionRatio);
    if (r < SURE_YES) then
      Exit(r);
  end;
  // normalize confidence, (we don't want to be 100% sure)
  Exit(SURE_YES);
end;

function TCharDistributionAnalyser.GotEnoughData: Boolean;
begin
  Result := FTotalChars > ENOUGH_DATA_THRESHOLD;
end;

procedure TCharDistributionAnalyser.HandleOneChar(ABuffer: TArray<Byte>; const AOffset: Integer; ACharLength: Integer);
var
  order: Integer;
begin
  // we only care about 2-bytes character in our distribution analysis
  if ACharLength = 2 then
    order := GetOrder(ABuffer, AOffset)
  else
    order := -1;
  if (order >= 0) then
  begin
    Inc(FTotalChars);
    if (order < Length(FCharToFreqOrder)) then
    begin // order is valid
      if (512 > FCharToFreqOrder[order]) then
        Inc(FFreqChars);
    end;
  end;
end;

procedure TCharDistributionAnalyser.Reset;
begin
  FDone := False;
  FTotalChars := 0;
  FFreqChars := 0;
end;

end.

