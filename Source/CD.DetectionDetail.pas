unit CD.DetectionDetail;

interface

uses
  CD.Prober.Charset,
  System.SysUtils;

type
  IDetectionDetail = interface
    ['{BBF5494C-9951-498C-9ED6-6BAB17EAFA8B}']
    function GetConfidence: Single;
    function GetEncoding: TEncoding;
    function GetEncodingName: string;
    function GetProber: TCharsetProber;
    procedure SetConfidence(const Value: Single);
    function GetStatusLog: string;
    // public
    function ToString: string;
    /// <summary>
    /// The (short) name of the detected encoding. For full details, check <see cref="Encoding"/>
    /// </summary>
    property EncodingName: string read GetEncodingName;
    /// <summary>
    /// The detected encoding.
    /// </summary>
    property Encoding: TEncoding read GetEncoding;
    /// <summary>
    /// The confidence of the found encoding. Between 0 and 1.
    /// </summary>
    property Confidence: Single read GetConfidence write SetConfidence;
    /// <summary>
    /// The used prober for detection
    /// </summary>
    property Prober: TCharsetProber read GetProber;
    property StatusLog: string read GetStatusLog;
  end;
  /// <summary>
  /// Detailed result of a detection
  /// </summary>

  TDetectionDetail = class(TInterfacedObject, IDetectionDetail)
  private
    FEncodingName: string;
    FEncoding: TEncoding;
    FConfidence: Single;
    FProber: TCharsetProber;
    FStatusLog: string;
    function GetConfidence: Single;
    function GetEncoding: TEncoding;
    function GetEncodingName: string;
    function GetProber: TCharsetProber;
    procedure SetConfidence(const Value: Single);
    function GetStatusLog: string;
    function ExtractTag(const AText, AFrom, ATo: string): string;
  public
    /// <summary>
    /// New result
    /// </summary>
    constructor Create(AEncodingShortName: string; AConfidence: Single; AProber:
      TCharsetProber = nil; AStatusLog: string = ''); overload;
    /// <summary>
    /// New Result
    /// </summary>
    constructor Create(AProber: TCharsetProber); overload;
    function ToString: string; override;
    destructor Destroy; override;
    /// <summary>
    /// The detected encoding.
    /// </summary>
    property Encoding: TEncoding read GetEncoding;
    /// <summary>
    /// The (short) name of the detected encoding. For full details, check <see cref="Encoding"/>
    /// </summary>
    property EncodingName: string read GetEncodingName;
    /// <summary>
    /// The confidence of the found encoding. Between 0 and 1.
    /// </summary>
    property Confidence: Single read GetConfidence write SetConfidence;
    /// <summary>
    /// The used prober for detection
    /// </summary>
    property Prober: TCharsetProber read GetProber;
    property StatusLog: string read GetStatusLog write FStatusLog;
  end;

implementation

{ TDetectionDetail }

constructor TDetectionDetail.Create(AEncodingShortName: string; AConfidence:
  Single; AProber: TCharsetProber = nil; AStatusLog: string = '');
var
  PublEnc, PrivEnc: string;
begin
  if AEncodingShortName.IsEmpty then
    Exit;
  PublEnc := AEncodingShortName.Split(['('])[0].Trim;
  PrivEnc := ExtractTag(AEncodingShortName, '(', ')');
  FEncodingName := PublEnc;
  FConfidence := AConfidence;
  FProber := AProber;
  FStatusLog := AStatusLog;
  try
    FEncoding := TEncoding.GetEncoding(AEncodingShortName);
  except
    on E: Exception do
    begin
      // Wrong name
    end;
  end;
end;

constructor TDetectionDetail.Create(AProber: TCharsetProber);
begin
  Self.Create(AProber.GetCharsetName(), AProber.GetConfidence(), AProber, AProber.DumpStatus);
end;

destructor TDetectionDetail.Destroy;
begin
  FreeAndNil(FEncoding);
  inherited;
end;

function TDetectionDetail.ExtractTag(const AText, AFrom, ATo: string): string;
var
  LFirst: Integer;
  LLast: Integer;
begin
  if AText.IsEmpty then
    Exit;
  Result := AText;
  LFirst := Result.IndexOf(AFrom) + AFrom.Length;
  Result := Result.Remove(0, LFirst);
  LLast := Result.IndexOf(ATo);
  Result := Result.Substring(0, LLast);
end;

function TDetectionDetail.GetConfidence: Single;
begin
  Result := FConfidence;
end;

function TDetectionDetail.GetEncoding: TEncoding;
begin
  Result := FEncoding;
end;

function TDetectionDetail.GetEncodingName: string;
begin
  Result := FEncodingName;
end;

function TDetectionDetail.GetProber: TCharsetProber;
begin
  Result := FProber;
end;

function TDetectionDetail.GetStatusLog: string;
begin
  Result := FStatusLog;
end;

procedure TDetectionDetail.SetConfidence(const Value: Single);
begin
  FConfidence := Value;
end;

function TDetectionDetail.ToString: string;
begin
  Result := string.format('Detected %s with confidence of %f', [EncodingName, Confidence]);
end;

end.

