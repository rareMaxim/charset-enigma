unit CD.Prober.MBCSGroup;

interface

uses
  CharsetEnigma.Lite,
  CD.Prober.Charset,
  CD.ProbingState,
  System.SysUtils;

type
  TMBCSGroupProber = class(TCharsetProber)
  private
    FProbers: TArray<ICharsetProber>;
    FIsActive: TArray<Boolean>;
    FBestGuess: Integer;
    FActiveNum: Integer;
  protected
  public
    constructor Create; override;
    function GetCharsetName: string; override;
    procedure Reset; override;
    function HandleData(ABuffer: TArray<Byte>; const AOffset, ALength: Integer): TProbingState; override;
    function GetConfidence(AStatus: TStringBuilder = nil): Single; override;
    function DumpStatus: string; override;
    class procedure RegisterProber(AProber: ICharsetProber);
  end;

implementation

uses
  CD.Prober.Store;

{ TMBCSGroupProber }

constructor TMBCSGroupProber.Create;
begin
  inherited;
  FProbers := TProberService.Current.Filtered('MBCS.');
  SetLength(FIsActive, Length(FProbers));
  Reset();
end;

function TMBCSGroupProber.DumpStatus: string;
var
  status: TStringBuilder;
  cf, cfp: Single;
  i: Integer;
begin
  status := TStringBuilder.Create;
  try
    cf := GetConfidence(status);
    status.AppendLine(' MBCS Group Prober --------begin status');
    for i := 0 to Length(FProbers) - 1 do
    begin
      if Assigned(FProbers[i]) then
      begin
        if (not FIsActive[i]) then
        begin
          status.AppendFormat(' MBCS inactive: %s (i.e. confidence is too low).',
            [FProbers[i].GetCharsetName()]).AppendLine;
        end
        else
        begin
          cfp := FProbers[i].GetConfidence();
          status.AppendFormat(' MBCS %f: [%s]', [cfp, FProbers[i].GetCharsetName()]).AppendLine;
          status.AppendLine(FProbers[i].DumpStatus());
        end;
      end;
    end;
    if FBestGuess = -1 then
      FBestGuess := 0;
    status.AppendFormat(' MBCS Group found best match [%s] confidence %f.', [FProbers
      [FBestGuess].GetCharsetName(), cf]).AppendLine;
    Result := status.ToString;
  finally
    status.Free;
  end;
end;

function TMBCSGroupProber.GetCharsetName: string;
begin
  if (FBestGuess = -1) then
  begin
    GetConfidence();
    if (FBestGuess = -1) then
      FBestGuess := 0;
  end;
  Result := FProbers[FBestGuess].GetCharsetName();
end;

function TMBCSGroupProber.GetConfidence(AStatus: TStringBuilder = nil): Single;
var
  bestConf: Single;
  cf: Single;
  i: Integer;
begin
  bestConf := 0.0;
  // cf := 0.0;
  if (FState = TProbingState.FoundIt) then
  begin
    Exit(0.99);
  end
  else if (FState = TProbingState.NotMe) then
  begin
    Exit(0.01);
  end
  else
  begin
    if Assigned(AStatus) then
      AStatus.AppendLine('Get confidence:');
    for i := 0 to Length(FProbers) - 1 do
    begin
      if FIsActive[i] then
      begin
        cf := FProbers[i].GetConfidence();
        if (bestConf < cf) then
        begin
          bestConf := cf;
          FBestGuess := i;
          if Assigned(AStatus) then
            AStatus.AppendFormat('-- new match found: confidence %f, index %d, charset %s.',
              [bestConf, FBestGuess, FProbers[i].GetCharsetName()]).AppendLine;
        end;
      end;
    end;
    if Assigned(AStatus) then
      AStatus.AppendLine('Get confidence done.');
  end;
  Result := bestConf;
end;

function TMBCSGroupProber.HandleData(ABuffer: TArray<Byte>; const AOffset, ALength: Integer): TProbingState;
var
  highbyteBuf: TArray<Byte>;
  hptr: Integer;
  keepNext: Boolean;
  max: Integer;
  i: Integer;
  st: TProbingState;
begin
  // do filtering to reduce load to probers
  SetLength(highbyteBuf, ALength);
  hptr := 0;
  // assume previous is not ascii, it will do no harm except add some noise
  keepNext := True;
  max := AOffset + ALength;

  for i := AOffset to max - 1 do
  begin
    if (ABuffer[i] and $80) <> 0 then
    begin
      highbyteBuf[hptr] := ABuffer[i];
      Inc(hptr);
      keepNext := True;
    end
    else
    begin
      // if previous is highbyte, keep this even it is a ASCII
      if keepNext then
      begin
        highbyteBuf[hptr] := ABuffer[i];
        Inc(hptr);
        keepNext := False;
      end
    end
  end;
  // st := TProbingState.NotMe;
  for i := 0 to Length(FProbers) - 1 do
  begin
    if FIsActive[i] then
    begin
      st := FProbers[i].HandleData(highbyteBuf, 0, hptr);
      if st = TProbingState.FoundIt then
      begin
        FBestGuess := i;
        FState := TProbingState.FoundIt;
        Break;
      end
      else if st = TProbingState.NotMe then
      begin
        FIsActive[i] := False;
        Dec(FActiveNum);
        if FActiveNum <= 0 then
        begin
          FState := TProbingState.NotMe;
          Break;
        end;
      end;
    end;
  end;
  Result := FState;
end;

class procedure TMBCSGroupProber.RegisterProber(AProber: ICharsetProber);
begin
  TProberService.Current.RegisterProber(AProber, 'MBCS');
end;

procedure TMBCSGroupProber.Reset;
var
  i: Integer;
begin
  FActiveNum := 0;
  for i := 0 to Length(FProbers) - 1 do
  begin
    if FProbers[i] <> nil then
    begin
      FProbers[i].Reset();
      FIsActive[i] := True;
      Inc(FActiveNum);
    end
    else
    begin
      FIsActive[i] := False;
    end;
  end;
  FBestGuess := -1;
  FState := TProbingState.Detecting;
end;

initialization
  TCharsetEnigma.RegisterProber(TMBCSGroupProber.Create(), 'General');

end.

