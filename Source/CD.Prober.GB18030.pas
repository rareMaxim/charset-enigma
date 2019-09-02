unit CD.Prober.GB18030;

interface

uses
  CD.Prober.Charset,
  CD.Core.CodingStateMachine,
  CD.ProbingState,
  CD.Analizer.Chinese.GB18030,
  System.SysUtils;

type
  TGB18030Prober = class(TCharsetProber)
  private
    FCodingSM: ICodingStateMachine;
    FAnalyser: TGB18030DistributionAnalyser;
    FLastChar: TArray<Byte>;
  public
    constructor Create; override;
    function GetCharsetName: string; override;
    function HandleData(ABuffer: TArray<Byte>; const AOffset, ALength: Integer): TProbingState; override;
    function GetConfidence(status: TStringBuilder = nil): Single; override;
    procedure Reset; override;
    destructor Destroy; override;
  end;

implementation

uses
  CD.Model.StateMachine,
  CD.Model.SM.GB18030,
  CD.Prober.MBCSGroup;

{ TGB18030Prober }

constructor TGB18030Prober.Create;
begin
  inherited;
  SetLength(FLastChar, 2);
  FCodingSM := TCodingStateMachine.Create(TGB18030SMModel.Create());
  FAnalyser := TGB18030DistributionAnalyser.Create();
  Reset();
end;

destructor TGB18030Prober.Destroy;
begin
  FreeAndNil(FAnalyser);
  inherited;
end;

function TGB18030Prober.GetCharsetName: string;
begin
  Result := 'gb18030';
end;

function TGB18030Prober.GetConfidence(status: TStringBuilder): Single;
begin
  Result := FAnalyser.GetConfidence;
end;

function TGB18030Prober.HandleData(ABuffer: TArray<Byte>; const AOffset, ALength: Integer): TProbingState;
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
      charLen := FCodingSM.CurrentCharLen;
      if I = AOffset then
      begin
        FLastChar[1] := ABuffer[AOffset];
        FAnalyser.HandleOneChar(FLastChar, 0, charLen);
      end
      else
      begin
        FAnalyser.HandleOneChar(ABuffer, I - 1, charLen);
      end;
    end;
  end;
  FLastChar[0] := ABuffer[max - 1];
  if FState = TProbingState.Detecting then
  begin
    if FAnalyser.GotEnoughData and (GetConfidence > SHORTCUT_THRESHOLD) then
      FState := TProbingState.FoundIt;
  end;
  Result := FState;
end;

procedure TGB18030Prober.Reset;
begin
  inherited;
  FCodingSM.Reset();
  FState := TProbingState.Detecting;
  FAnalyser.Reset();
end;

initialization
  TMBCSGroupProber.RegisterProber(TGB18030Prober.Create);

end.

