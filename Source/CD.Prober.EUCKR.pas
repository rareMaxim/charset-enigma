unit CD.Prober.EUCKR;

interface

uses
  CD.Prober.Charset,
  CD.Core.CodingStateMachine,
  CD.ProbingState,
  CD.Analizer.Korean.EUCKRDistribution,
  System.SysUtils,
  CD.Model.StateMachine;

type
  TEUCKRProber = class(TCharsetProber)
  private
    FCodingSM: ICodingStateMachine;
    FDistributionAnalyser: TEUCKRDistributionAnalyser;
    FLastChar: TArray<Byte>;
  protected
    function GetModel: ISMModel; virtual;
  public
    constructor Create; override;
    function GetCharsetName: string; override;
    function HandleData(ABuffer: TArray<Byte>; const AOffset, ALength: Integer): TProbingState; override;
    function GetConfidence(AStatus: TStringBuilder = nil): Single; override;
    procedure Reset; override;
    destructor Destroy; override;
  end;

implementation

uses
  CD.Model.SM.EUCKR,
  CD.Prober.MBCSGroup;

{ TEUCKRProber }

constructor TEUCKRProber.Create;
begin
  inherited;
  SetLength(FLastChar, 2);
  FCodingSM := TCodingStateMachine.Create(GetModel);
  FDistributionAnalyser := TEUCKRDistributionAnalyser.Create();
  Reset();
end;

destructor TEUCKRProber.Destroy;
begin
  FreeAndNil(FDistributionAnalyser);
  inherited;
end;

function TEUCKRProber.GetCharsetName: string;
begin
  Result := 'EUC-KR';
end;

function TEUCKRProber.GetConfidence(AStatus: TStringBuilder = nil): Single;
begin
  Result := FDistributionAnalyser.GetConfidence();
end;

function TEUCKRProber.GetModel: ISMModel;
begin
  Result := TEUCKRSMModel.Create();
end;

function TEUCKRProber.HandleData(ABuffer: TArray<Byte>; const AOffset, ALength: Integer): TProbingState;
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

procedure TEUCKRProber.Reset;
begin
  inherited;
  FCodingSM.Reset();
  FState := TProbingState.Detecting;
  FDistributionAnalyser.Reset();
  // mContextAnalyser.Reset();
end;

initialization
  TMBCSGroupProber.RegisterProber(TEUCKRProber.Create);

end.

