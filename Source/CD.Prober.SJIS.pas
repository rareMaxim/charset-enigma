unit CD.Prober.SJIS;

interface

uses
  CD.Analizer.Japanese.SJISContext,
  CD.Analizer.Japanese.SJISDistribution,
  CD.Core.CodingStateMachine,
  CD.Prober.Charset,
  CD.ProbingState,
  System.SysUtils;

type
  /// <summary>
  /// for S-JIS encoding, observe characteristic:
  /// 1, kana character (or hankaku?) often have hight frequency of appereance
  /// 2, kana character often exist in group
  /// 3, certain combination of kana is never used in japanese language
  /// </summary>
  TSJISProber = class(TCharsetProber)
  private
    FCodingSM: ICodingStateMachine;
    FContextAnalyser: TSJISContextAnalyser;
    FDistributionAnalyser: TSJISDistributionAnalyser;
    FLastChar: TArray<Byte>;
  public
    constructor Create; override;
    function GetCharsetName: string; override;
    function GetConfidence(status: TStringBuilder = nil): Single; override;
    function HandleData(ABuffer: TArray<Byte>; const AOffset, ALength: Integer): TProbingState; override;
    procedure Reset; override;
    destructor Destroy; override;
  end;

implementation

uses
  CD.Model.SM.SJIS,
  CD.Model.StateMachine,
  CD.Prober.MBCSGroup;

{ TSJISProber }

constructor TSJISProber.Create;
begin
  inherited;
  SetLength(FLastChar, 2);
  FCodingSM := TCodingStateMachine.Create(TSJISSMModel.Create());
  FDistributionAnalyser := TSJISDistributionAnalyser.Create();
  FContextAnalyser := TSJISContextAnalyser.Create();
  Reset();
end;

destructor TSJISProber.Destroy;
begin
  FreeAndNil(FDistributionAnalyser);
  FreeAndNil(FContextAnalyser);
  inherited;
end;

function TSJISProber.GetCharsetName: string;
begin
  Result := 'Shift-JIS';
end;

function TSJISProber.GetConfidence(status: TStringBuilder): Single;
var
  contxtCf: Single;
  distribCf: Single;
begin
  contxtCf := FContextAnalyser.GetConfidence();
  distribCf := FDistributionAnalyser.GetConfidence();
  if contxtCf > distribCf then
    Result := contxtCf
  else
    Result := distribCf;
end;

function TSJISProber.HandleData(ABuffer: TArray<Byte>; const AOffset, ALength: Integer): TProbingState;
var
  codingState: Integer;
  max: Integer;
  I: Integer;
  charLen: Integer;
begin
  max := AOffset + ALength;
  for I := AOffset to max - 1 do
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
        FContextAnalyser.HandleOneChar(FLastChar, 2 - charLen, charLen);
        FDistributionAnalyser.HandleOneChar(FLastChar, 0, charLen);
      end
      else
      begin
        FContextAnalyser.HandleOneChar(ABuffer, I + 1 - charLen, charLen);
        FDistributionAnalyser.HandleOneChar(ABuffer, I - 1, charLen);
      end;
    end;
  end;
  FLastChar[0] := ABuffer[max - 1];
  if (FState = TProbingState.Detecting) then
    if (FContextAnalyser.GotEnoughData()) and (GetConfidence() > SHORTCUT_THRESHOLD) then
      FState := TProbingState.FoundIt;
  Result := FState;
end;

procedure TSJISProber.Reset;
begin
  inherited;
  FCodingSM.Reset();
  FState := TProbingState.Detecting;
  FContextAnalyser.Reset();
  FDistributionAnalyser.Reset();
end;

initialization
  TMBCSGroupProber.RegisterProber(TSJISProber.Create);

end.

