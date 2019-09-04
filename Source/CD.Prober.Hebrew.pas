unit CD.Prober.Hebrew;

interface

uses
  CD.Prober.Charset,
  CD.ProbingState,
  System.SysUtils;

type
  THebrewProber = class(TCharsetProber)
    // windows-1255 / ISO-8859-8 code points of interest
  private
    const
      FINAL_KAF = $EA;
      NORMAL_KAF = $EB;
      FINAL_MEM = $ED;
      NORMAL_MEM = $EE;
      FINAL_NUN = $EF;
      NORMAL_NUN = $F0;
      FINAL_PE = $F3;
      NORMAL_PE = $F4;
      FINAL_TSADI = $F5;
      NORMAL_TSADI = $F6;
    // Minimum Visual vs Logical final letter score difference.
    // If the difference is below this, don't rely solely on the final letter score distance.
      MIN_FINAL_CHAR_DISTANCE = 5;
    // Minimum Visual vs Logical model score difference.
    // If the difference is below this, don't rely at all on the model score distance.
      MIN_MODEL_DISTANCE = 0.01;
      VISUAL_HEBREW_NAME = 'ISO-8859-8';
      LOGICAL_HEBREW_NAME = 'windows-1255';
  protected
    // owned by the group prober.
    FLogicalProber, FVisualProber: ICharsetProber;
    FFinalCharLogicalScore, FFinalCharVisualScore: Integer;
    // The two last bytes seen in the previous buffer.
    FPrev, FBeforePrev: Byte;
  public
    constructor Create; override;
    procedure SetModelProbers(logical, visual: ICharsetProber);
    function HandleData(ABuffer: TArray<Byte>; const AOffset, ALength: Integer): TProbingState; override;
    function GetCharsetName: string; override;
    procedure Reset; override;
    function GetState: TProbingState; override;
    function DumpStatus: string; override;
    function GetConfidence(status: TStringBuilder = nil): Single; override;
    function IsFinal(b: Byte): Boolean;
    function IsNonFinal(b: Byte): Boolean;
  end;

implementation

{ THebrewProber }

constructor THebrewProber.Create;
begin
  inherited;
  Reset;
end;

function THebrewProber.DumpStatus: string;
var
  status: TStringBuilder;
begin
  status := TStringBuilder.Create;
  try
    status.AppendFormat('  HEB: %d - %d [Logical-Visual score]', [FFinalCharLogicalScore,
      FFinalCharVisualScore]).AppendLine;
    Result := status.ToString;
  finally
    status.Free;
  end;
end;

function THebrewProber.GetCharsetName: string;
var
  finalsub: Integer;
  modelsub: Single;
begin
  // If the final letter score distance is dominant enough, rely on it.
  finalsub := FFinalCharLogicalScore - FFinalCharVisualScore;
  if (finalsub >= MIN_FINAL_CHAR_DISTANCE) then
    Exit(LOGICAL_HEBREW_NAME);
  if (finalsub <= -(MIN_FINAL_CHAR_DISTANCE)) then
    Exit(VISUAL_HEBREW_NAME);
  // It's not dominant enough, try to rely on the model scores instead.
  modelsub := FLogicalProber.GetConfidence() - FVisualProber.GetConfidence();
  if (modelsub > MIN_MODEL_DISTANCE) then
    Exit(LOGICAL_HEBREW_NAME);
  if (modelsub < -(MIN_MODEL_DISTANCE)) then
    Exit(VISUAL_HEBREW_NAME);
  // Still no good, back to final letter distance, maybe it'll save the day.
  if (finalsub < 0) then
    Exit(VISUAL_HEBREW_NAME);
  // (finalsub > 0 - Logical) or (don't know what to do) default to Logical.
  Exit(LOGICAL_HEBREW_NAME);
end;

function THebrewProber.GetConfidence(status: TStringBuilder): Single;
begin
  Result := 0.0;
end;

function THebrewProber.GetState: TProbingState;
begin
  // Remain active as long as any of the model probers are active.
  if (FLogicalProber.GetState() = TProbingState.NotMe) and (FVisualProber.GetState() = TProbingState.NotMe) then
    Result := TProbingState.NotMe
  else
    Result := TProbingState.Detecting;
end;

function THebrewProber.HandleData(ABuffer: TArray<Byte>; const AOffset, ALength: Integer): TProbingState;
var
  max: Integer;
  I: Integer;
  b: Byte;
begin
  // Both model probers say it's not them. No reason to continue.
  if (GetState() = TProbingState.NotMe) then
    Exit(TProbingState.NotMe);
  max := AOffset + ALength;
  for I := AOffset to max - 1 do
  begin
    b := ABuffer[I];
    // a word just ended
    if (b = $20) then
    begin
      // *(curPtr-2) was not a space so prev is not a 1 letter word
      if (FBeforePrev <> $20) then
      begin
        // case (1) [-2:not space][-1:final letter][cur:space]
        if (IsFinal(FPrev)) then
          Inc(FFinalCharLogicalScore)
          // case (2) [-2:not space][-1:Non-Final letter][cur:space]
        else if (IsNonFinal(FPrev)) then
          Inc(FFinalCharVisualScore);
      end;
    end
    else
    begin
      // case (3) [-2:space][-1:final letter][cur:not space]
      if (FBeforePrev = $20) and IsFinal(FPrev) and (b <> Ord(' ')) then
        Inc(FFinalCharVisualScore);
    end;
    FBeforePrev := FPrev;
    FPrev := b;
  end;
  // Forever detecting, till the end or until both model probers
  // return NotMe (handled above).
  Result := TProbingState.Detecting;
end;

function THebrewProber.IsFinal(b: Byte): Boolean;
begin
  Result := (b = FINAL_KAF) or (b = FINAL_MEM) or (b = FINAL_NUN) or (b = FINAL_PE) or (b = FINAL_TSADI);
end;

function THebrewProber.IsNonFinal(b: Byte): Boolean;
begin
  // The normal Tsadi is not a good Non-Final letter due to words like
  // 'lechotet' (to chat) containing an apostrophe after the tsadi. This
  // apostrophe is converted to a space in FilterWithoutEnglishLetters causing
  // the Non-Final tsadi to appear at an end of a word even though this is not
  // the case in the original text.
  // The letters Pe and Kaf rarely display a related behavior of not being a
  // good Non-Final letter. Words like 'Pop', 'Winamp' and 'Mubarak' for
  // example legally end with a Non-Final Pe or Kaf. However, the benefit of
  // these letters as Non-Final letters outweighs the damage since these words
  // are quite rare.
  Result := (b = NORMAL_KAF) or (b = NORMAL_MEM) or (b = NORMAL_NUN) or (b = NORMAL_PE);
end;

procedure THebrewProber.Reset;
begin
  inherited;
  FFinalCharLogicalScore := 0;
  FFinalCharVisualScore := 0;
  FPrev := $20;
  FBeforePrev := $20;
end;

procedure THebrewProber.SetModelProbers(logical, visual: ICharsetProber);
begin
  FLogicalProber := logical;
  FVisualProber := visual;
end;

end.

