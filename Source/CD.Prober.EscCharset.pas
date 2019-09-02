unit CD.Prober.EscCharset;

interface

uses
  CD.Core.CodingStateMachine,
  CD.Prober.Charset,
  CD.ProbingState,
  System.SysUtils,
  System.Generics.Collections;

type
  TEscCharsetProber = class(TCharsetProber)
  private
    FDetectedCharset: string;
    FCodingSM: TList<ICodingStateMachine>;
    FActiveSM: Integer;
  public
    constructor Create; override;
    procedure Reset; override;
    function HandleData(ABuffer: TArray<Byte>; const offset, len: Integer): TProbingState; override;
    function GetCharsetName: string; override;
    function GetConfidence(AStatus: TStringBuilder = nil): Single; override;
    destructor Destroy; override;
    class procedure RegisterProber(AProber: ICharsetProber);

  end;

implementation

uses
  CD.Model.StateMachine,
  CD.Model.SM.HZ_GB_2312,
  CD.Model.SM.ISO2022CN,
  CD.Model.SM.ISO2022JP,
  CD.Model.SM.ISO2022KR;

{ TEscCharsetProber }

constructor TEscCharsetProber.Create;
begin
  inherited;
  FCodingSM := TList<ICodingStateMachine>.Create;
  FCodingSM.Add(TCodingStateMachine.Create(THZ_GB_2312_SMModel.Create()));
  FCodingSM.Add(TCodingStateMachine.Create(TISO2022CNSMModel.Create()));
  FCodingSM.Add(TCodingStateMachine.Create(TISO2022JPSMModel.Create()));
  FCodingSM.Add(TCodingStateMachine.Create(TISO2022KRSMModel.Create()));
  Reset();
end;

destructor TEscCharsetProber.Destroy;
begin
  FCodingSM.Free;
  inherited;
end;

function TEscCharsetProber.GetCharsetName: string;
begin
  Result := FDetectedCharset;
end;

function TEscCharsetProber.GetConfidence(AStatus: TStringBuilder = nil): Single;
begin
  Result := 0.99;
end;

function TEscCharsetProber.HandleData(ABuffer: TArray<Byte>; const offset, len: Integer): TProbingState;
var
  max: Integer;
  i, j: Integer;
  codingState: Integer;
  t: ICodingStateMachine;
begin
  max := offset + len;
  i := offset;
  while True do
  begin
    if not ((i < max) and (FState = TProbingState.Detecting)) then
      Break;
    for j := FActiveSM - 1 downto 0 do
    begin
      // byte is feed to all active state machine
      codingState := FCodingSM[j].NextState(ABuffer[i]);
      if codingState = TSMModel.ERROR then
      begin
        // got negative answer for this state machine, make it inactive
        Dec(FActiveSM);
        if FActiveSM = 0 then
        begin
          FState := TProbingState.NotMe;
          Exit(FState);
        end
        else if j <> FActiveSM then
        begin
          t := FCodingSM[FActiveSM];
          FCodingSM[FActiveSM] := FCodingSM[j];
          FCodingSM[j] := t;
        end
      end
      else if codingState = TSMModel.ITSME then
      begin
        FState := TProbingState.FoundIt;
        FDetectedCharset := FCodingSM[j].ModelName;
        Exit(FState);
      end
    end;
    Inc(i);
  end;
  Exit(FState);
end;

class procedure TEscCharsetProber.RegisterProber(AProber: ICharsetProber);
begin
  inherited;

end;

procedure TEscCharsetProber.Reset;
var
  i: Integer;
begin
  inherited;
  FState := TProbingState.Detecting;
  for i := 0 to FCodingSM.Count - 1 do
    FCodingSM[i].Reset();
  FActiveSM := FCodingSM.Count;
  FDetectedCharset := '';
end;

end.

