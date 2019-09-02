unit CD.Prober.EUCJP;

interface

uses
  CD.Prober.Charset,
  CD.ProbingState,
  CD.Core.CodingStateMachine,
  CD.Analizer.Japanese.EUCJPContext,
  CD.Analizer.Japanese.EUCJPDistribution,
  System.SysUtils;

type
  TEUCJPProber = class(TCharsetProber)
  private
    FCodingSM: ICodingStateMachine;
    FContextAnalyser: TEUCJPContextAnalyser;
    FDistributionAnalyser: TEUCJPDistributionAnalyser;
    FLastChar: TArray<Byte>;
  public
    constructor Create; override;
    function GetCharsetName: string; override;
    function HandleData(ABuffer: TArray<Byte>; const AOffset, ALength: Integer): TProbingState; override;
    procedure Reset; override;
    function GetConfidence(status: TStringBuilder = nil): Single; override;
    destructor Destroy; override;
  end;

implementation

uses
  System.Math,
  CD.Model.StateMachine,
  CD.Model.SM.EUCJP,
  CD.Prober.MBCSGroup;

{ TEUCJPProber }

constructor TEUCJPProber.Create;
begin
  inherited;
  SetLength(FLastChar, 2);
  FCodingSM := TCodingStateMachine.Create(TEUCJPSMModel.Create());
  FDistributionAnalyser := TEUCJPDistributionAnalyser.Create();
  FContextAnalyser := TEUCJPContextAnalyser.Create();
  Reset();
end;

destructor TEUCJPProber.Destroy;
begin
  FreeAndNil(FDistributionAnalyser);
  FreeAndNil(FContextAnalyser);
  inherited;
end;

function TEUCJPProber.GetCharsetName: string;
begin
  Result := 'EUC-JP';
end;

function TEUCJPProber.GetConfidence(status: TStringBuilder): Single;
var
  contxtCf: Single;
  distribCf: Single;
begin
  contxtCf := FContextAnalyser.GetConfidence();
  { TODO -oOwner -cGeneral : Max function? }
  distribCf := FDistributionAnalyser.GetConfidence();
  Result := Max(contxtCf, distribCf)
//  if contxtCf > distribCf then
//    Result := contxtCf
//  else
//    Result := distribCf;
end;

function TEUCJPProber.HandleData(ABuffer: TArray<Byte>; const AOffset, ALength: Integer): TProbingState;
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
        FContextAnalyser.HandleOneChar(FLastChar, 0, charLen);
        FDistributionAnalyser.HandleOneChar(FLastChar, 0, charLen);
      end
      else
      begin
        FContextAnalyser.HandleOneChar(ABuffer, I - 1, charLen);
        FDistributionAnalyser.HandleOneChar(ABuffer, I - 1, charLen);
      end;
    end;
  end;
  FLastChar[0] := ABuffer[max - 1];
  if (FState = TProbingState.Detecting) then
    if FContextAnalyser.GotEnoughData() and (GetConfidence() > SHORTCUT_THRESHOLD) then
      FState := TProbingState.FoundIt;
  Result := FState;
end;

procedure TEUCJPProber.Reset;
begin
  inherited;
  FCodingSM.Reset();
  FState := TProbingState.Detecting;
  FContextAnalyser.Reset();
  FDistributionAnalyser.Reset();
end;

initialization
  TMBCSGroupProber.RegisterProber(TEUCJPProber.Create);

end.

