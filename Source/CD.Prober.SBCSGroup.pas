unit CD.Prober.SBCSGroup;

interface

uses
  CD.Prober.Charset,
  CD.ProbingState,
  System.SysUtils,
  CD.Model.Sequence,
  System.Generics.Collections;

type
  ISequenceModel = CD.Model.Sequence.ISequenceModel;

  TSBCSGroupProber = class(TCharsetProber)
  private
    FIsActive: TArray<Boolean>;
    FBestGuess: Integer;
    FActiveNum: Integer;
    FProbers: TList<ICharsetProber>;
    procedure LoadAllModelsFromModelRegistrator;
    class var
      FModelGenerator: TList<TFunc<ISequenceModel>>;
  public
    class constructor Create;
    class destructor Destroy;
    constructor Create; override;
    function HandleData(ABuffer: TArray<Byte>; const AOffset, ALength: Integer): TProbingState; override;
    function GetConfidence(status: TStringBuilder = nil): Single; override;
    function DumpStatus: string; override;
    procedure Reset; override;
    function GetCharsetName: string; override;
    function AddModel(AModel: ISequenceModel): ICharsetProber; overload;
    function AddModel(AModel: ISequenceModel; reversed: Boolean; nameProber: TCharsetProber): ICharsetProber; overload;
    destructor Destroy; override;
    class procedure RegisterModel(AFunction: TFunc<ISequenceModel>);
  end;

implementation

uses
  CD.Prober.Hebrew,
  CD.Model.Win1255.Hebrew,
  //

  CD.Prober.SingleByteCharSet;

{ TSBCSGroupProber }

constructor TSBCSGroupProber.Create;
var
  hebprober: THebrewProber;
  hebproberLog, hebproberVis: ICharsetProber;
begin
  inherited;
 // SetLength(FProbers, PROBERS_NUM);
  FProbers := TList<ICharsetProber>.Create;
  // Hebrew
  hebprober := THebrewProber.Create();
  FProbers.Add(hebprober);
  // Logical
  hebproberLog := AddModel(TWindows_1255_HebrewModel.Create(), False, hebprober);
  FProbers.Add(hebproberLog);
  // Visual
  hebproberVis := AddModel(TWindows_1255_HebrewModel.Create(), True, hebprober);
  FProbers.Add(hebproberVis);
  hebprober.SetModelProbers(hebproberLog, hebproberVis);
  LoadAllModelsFromModelRegistrator;
  //----------------------------------------------------------------------------
  SetLength(FIsActive, FProbers.Count);
  Reset();
end;

class constructor TSBCSGroupProber.Create;
begin
  FModelGenerator := TList<TFunc<ISequenceModel>>.Create;
end;

destructor TSBCSGroupProber.Destroy;
begin
  FProbers.Free;
  inherited;
end;

class destructor TSBCSGroupProber.Destroy;
begin
  FreeAndNil(FModelGenerator);
end;

function TSBCSGroupProber.DumpStatus: string;
var
  status: TStringBuilder;
  cf: Single;
  cfp: Single;
  i: Integer;
begin
  status := TStringBuilder.Create;
  try
    cf := GetConfidence(status);
    status.AppendLine(' SBCS Group Prober --------begin status');
    for i := 0 to FProbers.Count - 1 do
    begin
      if Assigned(FProbers[i]) then
      begin
        if not FIsActive[i] then
        begin
          status.AppendFormat(' SBCS inactive: [%s] (i.e. confidence is too low).',
            [FProbers[i].GetCharsetName()]).AppendLine;
        end
        else
        begin
          cfp := FProbers[i].GetConfidence();
          status.AppendFormat(' SBCS %f: [%s]', [cfp, FProbers[i].GetCharsetName()]).AppendLine;
          status.AppendLine(FProbers[i].DumpStatus());
        end;
      end;
    end;
    if FBestGuess < 0 then
      FBestGuess := 0;
    status.AppendFormat(' SBCS Group found best match [%s] confidence %f.', [FProbers
      [FBestGuess].GetCharsetName(), cf]).AppendLine;
    Result := status.ToString;
  finally
    status.Free;
  end;
end;

function TSBCSGroupProber.GetCharsetName: string;
begin
  // if we have no answer yet
  if (FBestGuess = -1) then
  begin
    GetConfidence();
    // no charset seems positive
    if (FBestGuess = -1) then
      FBestGuess := 0;
  end;
  Result := FProbers[FBestGuess].GetCharsetName();
end;

function TSBCSGroupProber.GetConfidence(status: TStringBuilder): Single;
var
  bestConf, cf: Single;
  i: Integer;
begin
  bestConf := 0.0;
  case FState of
    FoundIt:
      Exit(0.99);
    NotMe:
      Exit(0.01);
  else
    begin
      if Assigned(status) then
      begin
        status.AppendLine('Get confidence:');
      end;
      for i := 0 to FProbers.Count - 1 do
      begin
        if not FIsActive[i] then
          Continue;
        cf := FProbers[i].GetConfidence();
        if bestConf < cf then
        begin
          bestConf := cf;
          FBestGuess := i;
          if Assigned(status) then
          begin
            status.AppendLine('Get confidence:');
            status.AppendFormat('-- new match found: confidence %f, index %d, charset %s.',
              [bestConf, FBestGuess, FProbers[i].GetCharsetName()]);
          end;
        end;
      end;
      if Assigned(status) then
      begin
        status.AppendLine('Get confidence done.');
      end;
    end;
  end;
  Result := bestConf;
end;

function TSBCSGroupProber.HandleData(ABuffer: TArray<Byte>; const AOffset, ALength: Integer): TProbingState;
var
  st: TProbingState;
  newBuf: TArray<Byte>;
  i: Integer;
begin
  // st := TProbingState.NotMe;
  // apply filter to original buffer, and we got new buffer back
  // depend on what script it is, we will feed them the new buffer
  // we got after applying proper filter
  // this is done without any consideration to KeepEnglishLetters
  // of each prober since as of now, there are no probers here which
  // recognize languages with English characters.
  newBuf := FilterWithoutEnglishLetters(ABuffer, AOffset, ALength);
  if Length(newBuf) = 0 then
    Exit(FState); // Nothing to see here, move on.
  for i := 0 to FProbers.Count - 1 do
  begin
    if FIsActive[i] then
    begin
      st := FProbers[i].HandleData(newBuf, 0, Length(newBuf));
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
  Exit(FState);
end;

procedure TSBCSGroupProber.LoadAllModelsFromModelRegistrator;
var
  I: Integer;
begin
  for I := 0 to FModelGenerator.Count - 1 do
    AddModel(FModelGenerator[I]());
end;

function TSBCSGroupProber.AddModel(AModel: ISequenceModel; reversed: Boolean;
  nameProber: TCharsetProber): ICharsetProber;
begin
  Result := TSingleByteCharSetProber.Create(AModel, reversed, nameProber);
  FProbers.add(Result);
end;

function TSBCSGroupProber.AddModel(AModel: ISequenceModel): ICharsetProber;
begin
  Result := AddModel(AModel, False, nil);
end;

class procedure TSBCSGroupProber.RegisterModel(AFunction: TFunc<ISequenceModel>);
begin
  FModelGenerator.Add(AFunction);
end;

procedure TSBCSGroupProber.Reset;
var
  i: Integer;
begin
  inherited;
  FActiveNum := 0;
  for i := 0 to FProbers.Count - 1 do
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

end.

