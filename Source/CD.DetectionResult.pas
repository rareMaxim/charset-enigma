unit CD.DetectionResult;

interface

uses
  CD.DetectionDetail,
  System.Generics.Collections;

type
  IDetectionResult = interface
    ['{E155D6C2-EEFC-415E-9EF7-B27522624CD9}']
    function GetDetected: IDetectionDetail;
    function GetDetails: TList<IDetectionDetail>;
    // public
    function ToString: string;
    function IsDetected: Boolean;
    /// <summary>
    /// Get the best Detection
    /// </summary>
    property Detected: IDetectionDetail read GetDetected;
    /// <summary>
    /// All results
    /// </summary>
    property Details: TList<IDetectionDetail> read GetDetails;
  end;
  /// <summary>
  /// Result of a detection.
  /// </summary>

  TDetectionResult = class(TInterfacedObject, IDetectionResult)
  private
    FDetails: TList<IDetectionDetail>;
    function GetDetected: IDetectionDetail;
    function GetDetails: TList<IDetectionDetail>;
  public
    /// <summary>
    /// Multiple results
    /// </summary>
    constructor Create(Details: TArray<IDetectionDetail>); overload;
    /// <summary>
    /// Single result
    /// </summary>
    /// <param name="detectionDetail"></param>
    constructor Create(DetectionDetail: IDetectionDetail); overload;
    destructor Destroy; override;
    function ToString: string; override;
    function IsDetected: Boolean;
    /// <summary>
    /// Get the best Detection
    /// </summary>
    property Detected: IDetectionDetail read GetDetected;
    /// <summary>
    /// All results
    /// </summary>
    property Details: TList<IDetectionDetail> read GetDetails;
  end;

implementation

uses
  System.SysUtils;
{ TDetectionResult }

constructor TDetectionResult.Create(Details: TArray<IDetectionDetail>);
begin
  FDetails := TList<IDetectionDetail>.Create;
  FDetails.AddRange(Details);
end;

constructor TDetectionResult.Create(DetectionDetail: IDetectionDetail);
begin
  FDetails := TList<IDetectionDetail>.Create;
  FDetails.Add(DetectionDetail);
end;

destructor TDetectionResult.Destroy;
begin
  FDetails.Free;
  inherited;
end;

function TDetectionResult.GetDetails: TList<IDetectionDetail>;
begin
  Result := FDetails;
end;

function TDetectionResult.GetDetected: IDetectionDetail;
begin
  if Assigned(FDetails) and (FDetails.Count > 0) then
    Result := FDetails.First
  else
    Result := TDetectionDetail.Create('', 0, nil, '');
end;

function TDetectionResult.IsDetected: Boolean;
begin
  Result := not Detected.EncodingName.IsEmpty;
end;

function TDetectionResult.ToString: string;
var
  LDetailsInfo: string;
  LDetail: IDetectionDetail;
begin
  LDetailsInfo := string.Empty;
  for LDetail in FDetails do
    LDetailsInfo := '   ' + LDetail.ToString;
  if Assigned(Detected) then
    Result := string.format('Detected: %s' + #13#10, [Detected.ToString]);
  Result := Result + string.format(' Details: %s', [LDetailsInfo]);
end;

end.

