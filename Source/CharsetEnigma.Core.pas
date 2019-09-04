unit CharsetEnigma.Core;

interface

uses
  CD.Prober.Store,
  CD.DetectionResult,
  CD.DetectionDetail,
  CD.Prober.Charset,
  CD.Core.InputState,
  System.Classes,
  System.Generics.Collections;

type
  IDetectionResult = CD.DetectionResult.IDetectionResult;

  IDetectionDetail = CD.DetectionDetail.IDetectionDetail;

  TCharsetEnigma = class(TInterfacedObject)
  private
    const
      MINIMUM_THRESHOLD = 0.20;
  private
    FInputState: TInputState;
    /// <summary>
    /// Start of the file
    /// </summary>
    FStart: Boolean;
    /// <summary>
    /// De byte array has data?
    /// </summary>
    FGotData: Boolean;
    /// <summary>
    /// Most of the time true of <see cref="_detectionDetail"/> is set. TODO not always
    /// </summary>
    FDone: Boolean;
    /// <summary>
    /// Lastchar, but not always filled. TODO remove?
    /// </summary>
    FLastChar: Byte;
    /// <summary>
    /// Detected charset. Most of the time <see cref="FDone"/> is true
    /// </summary>
    FDetectionDetail: IDetectionDetail;
  private
    function RunProber(ABuffer: TArray<Byte>; const AOffset, ALength: Integer; ACharsetProber: ICharsetProber): Boolean;
    procedure FindInputState(ABuffer: TArray<Byte>; const ALength: Integer);
    /// <summary>
    /// Notify detector that no further data is available.
    /// </summary>
    function DataEnd(): IDetectionResult;
    class function CalcToRead(const AMaxBytes, AReadTotal, ABufferSize: Int64): Int64;
  protected
    procedure Feed(ABuffer: TArray<Byte>; const AOffset, ALength: Integer); virtual;
  public
    /// <summary>
    /// Detect the character encoding form this byte array.
    /// </summary>
    /// <param name="bytes"></param>
    /// <returns></returns>
    class function DetectFromBytes(bytes: TArray<Byte>): IDetectionResult;
    /// <summary>
    /// Detect the character encoding by reading the AStream.
    ///
    /// Note: AStream position is not reset before and after.
    /// </summary>
    /// <param name="AStream">The steam. </param>
    class function DetectFromStream(AStream: TStream): IDetectionResult; overload;
    /// <summary>
    /// Detect the character encoding by reading the AStream.
    /// Note: AStream position is not reset before and after.
    /// </summary>
    /// <param name="AStream">The steam. </param>
    /// <param name="AMaxBytesToRead">max bytes to read from <paramref name="AStream"/>. If <c>null</c>, then no max</param>
    /// <exception cref="ArgumentOutOfRangeException"><paramref name="AMaxBytesToRead"/> 0 or lower.</exception>
    class function DetectFromStream(AStream: TStream; const AMaxBytesToRead: Int64): IDetectionResult; overload;
    class procedure ReadStream(AStream: TStream; const AMaxBytes: Int64; ADetector: TCharsetEnigma);

    /// <summary>
    /// Detect the character encoding of this file.
    /// </summary>
    /// <param name="AFileName">Path to file</param>
    /// <returns></returns>
    class function DetectFromFile(const AFileName: string): IDetectionResult;
    constructor Create;
    destructor Destroy; override;
    class procedure RegisterProber(AProber: ICharsetProber; const AGroupName: string = '');
  end;

implementation

uses
  CD.Core.BOMTools,
  CD.ProbingState,
  //
  CD.Prober.EscCharset,
  CD.Prober.MBCSGroup,
  CD.Prober.SBCSGroup,
  CD.Prober.Latin1,
  //
  System.SysUtils,
  System.IOUtils,
  System.Generics.Defaults;
{ TCharsetEnigma }

class function TCharsetEnigma.CalcToRead(const AMaxBytes, AReadTotal, ABufferSize: Int64): Int64;
begin
  if AMaxBytes = -1 then
    Exit(ABufferSize);
  if AReadTotal + ABufferSize > AMaxBytes then
    Result := AMaxBytes - AReadTotal
  else
    Result := ABufferSize;
end;

constructor TCharsetEnigma.Create;
begin
  FStart := True;
  FInputState := TInputState.PureASCII;
  FLastChar := $00;
  // register
  TProberService.Current.RegisterProber(TMBCSGroupProber.Create(), 'General');
  TProberService.Current.RegisterProber(TSBCSGroupProber.Create(), 'General');
  TProberService.Current.RegisterProber(TLatin1Prober.Create(), 'General');
  TProberService.Current.RegisterProber(TEscCharsetProber.Create(), 'Esc');
end;

function TCharsetEnigma.DataEnd: IDetectionResult;
var
  list: TList<IDetectionDetail>;
  listArray: TArray<IDetectionDetail>;
  i: Integer;
  LCharsetProber: ICharsetProber;
begin
  if not FGotData then
  begin
    // we haven't got any data yet, return immediately
    // caller program sometimes call DataEnd before anything has
    // been sent to detector
    Result := TDetectionResult.Create();
    Exit();
  end;
  if FDetectionDetail <> nil then
  begin
    FDone := True;
    // conf 1.0 is from v1.0 (todo wrong?)
    FDetectionDetail.Confidence := 1.0;
    Exit(TDetectionResult.Create(TDetectionDetail(FDetectionDetail)));
  end;
  if FInputState = TInputState.Highbyte then
  begin
    list := TList<IDetectionDetail>.Create();
    try
      for LCharsetProber in TProberService.Current.Filtered('General') do
      begin
        list.Add(TDetectionDetail.Create(TCharsetProber(LCharsetProber)));
      end;
      for i := list.Count - 1 downto 0 do
      begin
        if list[i].Confidence < MINIMUM_THRESHOLD then
          list.Delete(i);
      end;
      list.Sort(TComparer<IDetectionDetail>.Construct(
        function(const Left, Right: IDetectionDetail): Integer
        var
          LConfLeft, LConfRight: Integer;
        begin
          LConfLeft := Trunc(Left.Confidence * 10000);
          LConfRight := Trunc(Right.Confidence * 10000);
          Result := LConfRight - LConfLeft;
        end));
      listArray := list.ToArray;
      Result := TDetectionResult.Create(listArray);
      Exit();
      // TODO why done isn't true?
    finally
      list.Free;
    end;
  end
  else if (FInputState = TInputState.PureASCII) then
  begin
    // TODO why done isn't true?
    Exit(TDetectionResult.Create(TDetectionDetail.Create('ASCII', 1.0, nil)));
  end;
  Exit(TDetectionResult.Create());
end;

destructor TCharsetEnigma.Destroy;
begin
  inherited;
end;

class function TCharsetEnigma.DetectFromBytes(bytes: TArray<Byte>): IDetectionResult;
var
  detector: TCharsetEnigma;
begin
  if bytes = nil then
    raise EArgumentNilException.Create('bytes = nil');
  detector := TCharsetEnigma.Create();
  try
    detector.Feed(bytes, 0, Length(bytes));
    Result := detector.DataEnd();
  finally
    detector.Free;
  end;
end;

class function TCharsetEnigma.DetectFromFile(const AFileName: string): IDetectionResult;
var
  fs: TFileStream;
begin
  if not FileExists(AFileName) then
    raise EArgumentException.CreateFmt('File not found: %s', [AFileName]);
  fs := TFile.OpenRead(AFileName);
  try
    fs.Position := 0;
    Result := DetectFromStream(fs);
  finally
    fs.Free;
  end;
end;

class function TCharsetEnigma.DetectFromStream(AStream: TStream; const AMaxBytesToRead: Int64): IDetectionResult;
var
  detector: TCharsetEnigma;
begin
  if AStream = nil then
  begin
    raise EArgumentNilException.Create('AStream = nil');
  end;
  if AMaxBytesToRead = 0 then
  begin
    raise EArgumentOutOfRangeException.Create('AMaxBytesToRead');
  end;

  detector := TCharsetEnigma.Create;
  try
    ReadStream(AStream, AMaxBytesToRead, TCharsetEnigma(detector));
    Result := detector.DataEnd();
  finally
    FreeAndNil(detector);
  end;
end;

class function TCharsetEnigma.DetectFromStream(AStream: TStream): IDetectionResult;
begin
  Assert(Assigned(AStream), 'AStream = nil');
  Result := DetectFromStream(AStream, -1);
end;

procedure TCharsetEnigma.Feed(ABuffer: TArray<Byte>; const AOffset, ALength: Integer);
var
  LBomSet: string;
  LCharsetProber: ICharsetProber;
begin
  if FDone then
    Exit;
  if ALength > 0 then
    FGotData := True;
  // If the data starts with BOM, we know it is UTF
  if FStart then
  begin
    LBomSet := TBomTools.FindCharset(ABuffer, ALength);
    FStart := False;
    if not LBomSet.IsEmpty then
    begin
      FDetectionDetail := TDetectionDetail.Create(LBomSet, 1.0);
      FDone := True;
      Exit;
    end;
  end;
  FindInputState(ABuffer, ALength);
  case FInputState of
    TInputState.EscASCII:
      begin
        LCharsetProber := TProberService.Current['Esc.TEscCharsetProber'];
        RunProber(ABuffer, AOffset, ALength, LCharsetProber);
      end;
    TInputState.Highbyte:
      begin
        for LCharsetProber in TProberService.Current.Filtered('General') do
        begin
          if RunProber(ABuffer, AOffset, ALength, LCharsetProber) then
            Exit;
        end;
      end;
  end;
end;

procedure TCharsetEnigma.FindInputState(ABuffer: TArray<Byte>; const ALength: Integer);
var
  i: Integer;
begin
  for i := 0 to ALength - 1 do
  begin
    // other than 0xa0, if every other character is ascii, the page is ascii
    if ((ABuffer[i] and $80) <> 0) and (ABuffer[i] <> $A0) then
    begin
      // we got a non-ascii byte (high-byte)
      if FInputState <> TInputState.Highbyte then
      begin
        FInputState := TInputState.Highbyte;
      end;
    end
    else
    begin
      if (FInputState = TInputState.PureASCII) and //
        ((ABuffer[i] = $1B) or ((ABuffer[i] = $7B) and (FLastChar = $7E))) then
      begin
        // found escape character or HZ "~{"
        FInputState := TInputState.EscASCII;
      end;
      FLastChar := ABuffer[i];
    end;
  end;
end;

class procedure TCharsetEnigma.ReadStream(AStream: TStream; const AMaxBytes: Int64; ADetector: TCharsetEnigma);
const
  BUFFER_SIZE: Integer = 1024;
var
  LBuffer: TArray<Byte>;
  LRead: Integer;
  LReadTotal: Int64;
  LToRead: Integer;
  LContinue: Boolean;
begin
  SetLength(LBuffer, BUFFER_SIZE);
  LReadTotal := 0;
  LToRead := CalcToRead(AMaxBytes, LReadTotal, BUFFER_SIZE);
  LContinue := True;
  while LContinue do
  begin
    LRead := AStream.Read(LBuffer, 0, LToRead);
    LContinue := LRead > 0;
    if not LContinue then
      Break;
    ADetector.Feed(LBuffer, 0, LRead);
    Inc(LReadTotal, LRead);
    if AMaxBytes <> -1 then
    begin
      if LReadTotal >= AMaxBytes then
        Exit;
      LToRead := CalcToRead(AMaxBytes, LReadTotal, BUFFER_SIZE);
    end;
    if (ADetector.FDone) then
      Exit;
  end;
end;

class procedure TCharsetEnigma.RegisterProber(AProber: ICharsetProber; const AGroupName: string);
begin
  TProberService.Current.RegisterProber(AProber, AGroupName);
end;

function TCharsetEnigma.RunProber(ABuffer: TArray<Byte>; const AOffset, ALength:
  Integer; ACharsetProber: ICharsetProber): Boolean;
var
  LProbingState: TProbingState;
begin
  LProbingState := ACharsetProber.HandleData(ABuffer, AOffset, ALength);
  if LProbingState = TProbingState.FoundIt then
  begin
    FDone := True;
    FDetectionDetail := TDetectionDetail.Create(TCharsetProber(ACharsetProber));
    Result := True;
  end
  else
    Result := False;
end;

end.

