unit CD.Prober.EUCTW;

interface

uses
  CD.Prober.Charset,
  CD.Core.CodingStateMachine,
  CD.ProbingState,
  CD.Analizer.Chinese.EUCTW,
  System.SysUtils;

type
  TEUCTWProber = class(TCharsetProber)
    FCodingSM: ICodingStateMachine;
    FDistributionAnalyser: TEUCTWDistributionAnalyser;
    FLastChar: TArray<Byte>;
  public
    constructor Create; override;
    function HandleData(ABuffer: TArray<Byte>; const AOffset, ALength: Integer): TProbingState; override;
    function GetCharsetName: string; override;
    procedure Reset; override;
    function GetConfidence(status: TStringBuilder = nil): Single; override;
    destructor Destroy; override;
  end;

implementation

uses
  CD.Model.StateMachine,
  CD.Model.SM.EUCTW,
  CD.Prober.MBCSGroup;

{ TEUCTWProber }

constructor TEUCTWProber.Create;
begin
  inherited;
  SetLength(FLastChar, 2);
  FCodingSM := TCodingStateMachine.Create(TEUCTWSMModel.Create());
  FDistributionAnalyser := TEUCTWDistributionAnalyser.Create();
  Reset();
end;

destructor TEUCTWProber.Destroy;
begin
  FreeAndNil(FDistributionAnalyser);
  inherited;
end;

function TEUCTWProber.GetCharsetName: string;
begin
  Result := 'EUC-TW';
end;

function TEUCTWProber.GetConfidence(status: TStringBuilder): Single;
begin
  Result := FDistributionAnalyser.GetConfidence();
end;

function TEUCTWProber.HandleData(ABuffer: TArray<Byte>; const AOffset, ALength: Integer): TProbingState;
var
  codingState: Integer;
  max: Integer;
  I: Integer;
  charLen: Integer;
begin
  max := AOffset + ALength;
  for I := 0 to max - 1 do
  begin
    codingState := FCodingSM.NextState(ABuffer[I]);
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
      if (I = AOffset) then
      begin
        FLastChar[1] := ABuffer[AOffset];
        FDistributionAnalyser.HandleOneChar(FLastChar, 0, charLen);
      end
      else
      begin
        FDistributionAnalyser.HandleOneChar(ABuffer, I - 1, charLen);
      end;
    end;
  end;
  FLastChar[0] := ABuffer[max - 1];
  if (FState = TProbingState.Detecting) then
    if (FDistributionAnalyser.GotEnoughData()) and (GetConfidence() > SHORTCUT_THRESHOLD) then
      FState := TProbingState.FoundIt;
  Result := FState;
end;

procedure TEUCTWProber.Reset;
begin
  inherited;
  FCodingSM.Reset();
  FState := TProbingState.Detecting;
  FDistributionAnalyser.Reset();
end;

initialization
  TMBCSGroupProber.RegisterProber(TEUCTWProber.Create);

end.

