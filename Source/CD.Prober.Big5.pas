unit CD.Prober.Big5;

interface

uses
  CD.Prober.Charset,
  CD.Core.CodingStateMachine,
  CD.ProbingState,
  CD.Analizer.Chinese.BIG5,
  System.SysUtils;

type
  TBig5Prober = class(TCharsetProber)
  private
    FCodingSM: ICodingStateMachine;
    FDistributionAnalyser: TBIG5DistributionAnalyser;
    FLastChar: TArray<Byte>;
  public
    constructor Create; override;
    function HandleData(ABuffer: TArray<Byte>; const AOffset, ALength: Integer): TProbingState; override;
    procedure Reset; override;
    function GetCharsetName: string; override;
    function GetConfidence(status: TStringBuilder = nil): Single; override;
    destructor Destroy; override;
  end;

implementation

uses
  CD.Model.StateMachine,
  CD.Model.SM.BIG5,
  CD.Prober.MBCSGroup;

{ TBig5Prober }

constructor TBig5Prober.Create;
begin
  inherited Create;
  SetLength(FLastChar, 2);
  FCodingSM := TCodingStateMachine.Create(TBIG5SMModel.Create());
  FDistributionAnalyser := TBIG5DistributionAnalyser.Create();
  Reset();
end;

destructor TBig5Prober.Destroy;
begin
  FreeAndNil(FDistributionAnalyser);
  inherited;
end;

function TBig5Prober.GetCharsetName: string;
begin
  Result := 'Big5';
end;

function TBig5Prober.GetConfidence(status: TStringBuilder): Single;
begin
  Result := FDistributionAnalyser.GetConfidence;
end;

function TBig5Prober.HandleData(ABuffer: TArray<Byte>; const AOffset, ALength: Integer): TProbingState;
var
  codingState: Integer;
  max: Integer;
  i: Integer;
  charLen: Integer;
begin
  max := AOffset + ALength;
  for i := AOffset to max - 1 do
  begin
    codingState := FCodingSM.NextState(ABuffer[i]);
    if (codingState = TSMModel.ERROR) then
    begin
      FState := TProbingState.NotMe;
      Break;
    end;
    if (codingState = TSMModel.ITSME) then
    begin
      FState := TProbingState.FoundIt;
      Break;
    end;
    if (codingState = TSMModel.START) then
    begin
      charLen := FCodingSM.CurrentCharLen;
      if (i = AOffset) then
      begin
        FLastChar[1] := ABuffer[AOffset];
        FDistributionAnalyser.HandleOneChar(FLastChar, 0, charLen);
      end
      else
      begin
        FDistributionAnalyser.HandleOneChar(ABuffer, i - 1, charLen);
      end;
    end;
  end;
  FLastChar[0] := ABuffer[max - 1];
  if (FState = TProbingState.Detecting) then
    if FDistributionAnalyser.GotEnoughData() and (GetConfidence() > SHORTCUT_THRESHOLD) then
      FState := TProbingState.FoundIt;
  Result := FState;
end;

procedure TBig5Prober.Reset;
begin
  inherited;
  FCodingSM.Reset();
  FState := TProbingState.Detecting;
  FDistributionAnalyser.Reset();
end;

initialization
  TMBCSGroupProber.RegisterProber(TBig5Prober.Create);

end.

