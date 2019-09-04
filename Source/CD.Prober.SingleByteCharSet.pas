unit CD.Prober.SingleByteCharSet;

interface

uses
  CD.Prober.Charset,
  CD.Model.Sequence,
  CD.ProbingState,
  System.SysUtils;

type
  TSingleByteCharSetProber = class(TCharsetProber)
  private
    const
      SB_ENOUGH_REL_THRESHOLD = 1024;
      POSITIVE_SHORTCUT_THRESHOLD = 0.95;
      NEGATIVE_SHORTCUT_THRESHOLD = 0.05;
      SYMBOL_CAT_ORDER = 250;
      NUMBER_OF_SEQ_CAT = 4;
      POSITIVE_CAT = NUMBER_OF_SEQ_CAT - 1;
      PROBABLE_CAT = NUMBER_OF_SEQ_CAT - 2;
      NEUTRAL_CAT = NUMBER_OF_SEQ_CAT - 3;
      NEGATIVE_CAT = 0;
  protected
    FModel: ISequenceModel;
    // true if we need to reverse every pair in the FMmodel lookup
    FReversed: Boolean;
    // char order of last character
    FLastOrder: Byte;
    FTotalSeqs: Integer;
    FSeqCounters: TArray<Integer>;
    FTotalChar: Integer;
    FctrlChar: Integer;
    // characters that fall in our sampling range
    FFreqChar: Integer;
    // Optional auxiliary prober for name decision. created and destroyed by the GroupProber
    FNameProber: TCharsetProber;
  public
    constructor Create(AModel: ISequenceModel); reintroduce; overload;
    constructor Create(AModel: ISequenceModel; reversed: Boolean; nameProber: TCharsetProber); reintroduce; overload;
    function HandleData(ABuffer: TArray<Byte>; const AOffset, ALength: Integer): TProbingState; override;
    function DumpStatus: string; override;
    function GetConfidence(status: TStringBuilder = nil): Single; override;
    procedure Reset; override;
    function GetCharsetName: string; override;
  end;

implementation

{ TSingleByteCharSetProber }

constructor TSingleByteCharSetProber.Create(AModel: ISequenceModel);
begin
  inherited Create();
  Self.Create(AModel, False, nil);
end;

constructor TSingleByteCharSetProber.Create(AModel: ISequenceModel; reversed: Boolean; nameProber: TCharsetProber);
begin
  inherited Create();
  SetLength(FSeqCounters, NUMBER_OF_SEQ_CAT);
  Self.FModel := AModel;
  Self.FReversed := reversed;
  Self.FNameProber := nameProber;
  Reset();
end;

function TSingleByteCharSetProber.DumpStatus: string;
begin
  Result := Format('  SBCS: %f [%s]', [GetConfidence(), GetCharsetName()]);
end;

function TSingleByteCharSetProber.GetCharsetName: string;
begin
  if Assigned(FNameProber) then
    Result := FNameProber.GetCharsetName
  else
    Result := FModel.charsetName;
end;

function TSingleByteCharSetProber.GetConfidence(status: TStringBuilder): Single;
begin
  if FTotalSeqs > 0 then
  begin
    Result := 1.0 * FSeqCounters[POSITIVE_CAT] / FTotalSeqs / FModel.TypicalPositiveRatio;
    Result := Result * (FSeqCounters[POSITIVE_CAT] + FSeqCounters[PROBABLE_CAT] / 4.0) / FTotalChar;
    Result := Result * (FTotalChar - FctrlChar) / FTotalChar;
    Result := Result * FFreqChar / FTotalChar;
    if Result >= 1.0 then
      Result := 0.99;
  end
  else
    Result := 0.01;
end;

function TSingleByteCharSetProber.HandleData(ABuffer: TArray<Byte>; const AOffset, ALength: Integer): TProbingState;
var
  max: Integer;
  i: Integer;
  order: Byte;
  cf: Single;
begin
  max := AOffset + ALength;
  for i := AOffset to max - 1 do
  begin
    order := FModel.GetOrder(ABuffer[i]);
    if order < SYMBOL_CAT_ORDER then
      Inc(FTotalChar)
    else if order = TSequenceModel.ILL then
    begin
      // When encountering an illegal codepoint,
      // no need to continue analyzing data
      FState := TProbingState.NotMe;
      Break;
    end
    else if order = TSequenceModel.CTR then
    begin
      Inc(FctrlChar);
    end;
    if order < FModel.FreqCharCount then
    begin
      Inc(FFreqChar);
      if FLastOrder < FModel.FreqCharCount then
      begin
        Inc(FTotalSeqs);
        if (not FReversed) then
          Inc(FSeqCounters[FModel.GetPrecedence(FLastOrder * FModel.FreqCharCount + order)])
        else // reverse the order of the letters in the lookup
          Inc(FSeqCounters[FModel.GetPrecedence(order * FModel.FreqCharCount + FLastOrder)]);
      end;
    end;
    FLastOrder := order;
  end;
  if FState = TProbingState.Detecting then
  begin
    if FTotalSeqs > SB_ENOUGH_REL_THRESHOLD then
    begin
      cf := GetConfidence();
      if cf > POSITIVE_SHORTCUT_THRESHOLD then
        FState := TProbingState.FoundIt
      else if cf < NEGATIVE_SHORTCUT_THRESHOLD then
        FState := TProbingState.NotMe;
    end;
  end;
  Result := FState;
end;

procedure TSingleByteCharSetProber.Reset;
var
  i: Integer;
begin
  inherited;
  FState := TProbingState.Detecting;
  FLastOrder := 255;
  for i := 0 to NUMBER_OF_SEQ_CAT - 1 do
    FSeqCounters[i] := 0;
  FTotalSeqs := 0;
  FTotalChar := 0;
  FFreqChar := 0;
end;

end.

