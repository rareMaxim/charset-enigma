unit CD.Prober.UTF8;

interface

uses
  CD.Prober.Charset,
  CD.Core.CodingStateMachine,
  CD.ProbingState,
  System.SysUtils;

type
  TUTF8Prober = class(TCharsetProber)
  private
    const
      ONE_CHAR_PROB = 0.50;
  private
    FCodingSM: ICodingStateMachine;
    FNumOfMBChar: Integer;
  public
    constructor Create; override;
    function GetCharsetName: string; override;
    procedure Reset; override;
    function HandleData(ABuffer: TArray<Byte>; const AOffset, ALength: Integer): TProbingState; override;
    function GetConfidence(AStatus: TStringBuilder = nil): Single; override;
  end;

implementation

uses
  CD.Prober.MBCSGroup,
  CD.Model.StateMachine,
  CD.Model.SM.UTF8;

{ TUTF8Prober }

constructor TUTF8Prober.Create;
begin
  inherited;
  FNumOfMBChar := 0;
  FCodingSM := TCodingStateMachine.Create(TUTF8SMModel.Create());
  Reset();
end;

function TUTF8Prober.GetCharsetName: string;
begin
  Result := 'UTF-8';
end;

function TUTF8Prober.GetConfidence(AStatus: TStringBuilder = nil): Single;
var
  unlike: Single;
  confidence: Single;
  i: Integer;
begin
  unlike := 0.99;
  if FNumOfMBChar < 6 then
  begin
    for i := 0 to FNumOfMBChar - 1 do
      unlike := unlike * ONE_CHAR_PROB;
    confidence := 1.0 - unlike;
  end
  else
    confidence := 0.99;
  Result := confidence;
end;

function TUTF8Prober.HandleData(ABuffer: TArray<Byte>; const AOffset, ALength: Integer): TProbingState;
var
  codingState: Integer;
  max: Integer;
  i: Integer;
begin
  // codingState := TSMModel.START;
  max := AOffset + ALength;
  for i := AOffset to max - 1 do
  begin
    codingState := FCodingSM.NextState(ABuffer[i]);
    if codingState = TSMModel.ERROR then
    begin
      FState := TProbingState.NotMe;
      Break;
    end;
    if codingState = TSMModel.ITSME then
    begin
      FState := TProbingState.FoundIt;
      Break;
    end;
    if codingState = TSMModel.START then
    begin
      if FCodingSM.CurrentCharLen >= 2 then
        Inc(FNumOfMBChar);
    end;
  end;
  if FState = TProbingState.Detecting then
    if GetConfidence() > SHORTCUT_THRESHOLD then
      FState := TProbingState.FoundIt;
  Result := FState;
end;

procedure TUTF8Prober.Reset;
begin
  inherited;
  FCodingSM.Reset();
  FNumOfMBChar := 0;
  FState := TProbingState.Detecting;
end;

initialization
  TMBCSGroupProber.RegisterProber(TUTF8Prober.Create);

end.

