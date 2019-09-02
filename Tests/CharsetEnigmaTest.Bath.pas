unit CharsetEnigmaTest.Bath;

interface

uses
  System.Generics.Collections,
  DUnitX.Types,
  DUnitX.InternalDataProvider,
  DUnitX.TestDataProvider,
  DUnitX.TestFramework;

type
  TTestCase = class
  private
    FInputFile: string;
    FExpectedEncoding: string;
  public
    constructor Create(AFilename, AExpectedEncoding: string);
    function ToString: string; override;
    property InputFile: string read FInputFile write FInputFile;
    property expectedEncoding: string read FExpectedEncoding write FExpectedEncoding;
  end;

  TBathEncodingProvider = class(TTestDataProvider)
  private
    FTestCases: TObjectList<TTestCase>;
    function AllTestFiles: TArray<TTestCase>;
    function CreateTestCases(dirname: string): TArray<TTestCase>;
  public
      //The constructor, for initializing the data
    constructor Create; override;
      //Get the amount of cases, we want to create;
    function GetCaseCount(const methodName: string): Integer; override;
      //Get the name of the cases, depending on the Test-Function
    function GetCaseName(const methodName: string): string; override;
      //Get the Params for calling the Test-Function;Be aware of the order !
    function GetCaseParams(const methodName: string; const caseNumber: integer): TValuearray; override;
      //Cleanup the instance
    destructor Destroy; override;
    class function DATA_ROOT: string; static;
  end;

  [TestFixture('Bath Encoding Test', '')]
  TBathTestEncodings = class(TObject)
  public
    [Test]
    [TestCaseProvider(TBathEncodingProvider)]
    procedure Compare(const AInputFile, AExpectedEncoding: string);
    [Test]
    procedure PathWithData;
  end;

implementation

uses
  CharsetEnigma.Lite,
  System.IOUtils,
  System.SysUtils;


{ TBathEncodingProvider }

function TBathEncodingProvider.AllTestFiles: TArray<TTestCase>;
var
  testCases: TList<TTestCase>;
  dirs: TArray<string>;
  dir: string;
begin
  testCases := TList<TTestCase>.Create;
  try
    dirs := TDirectory.GetDirectories(DATA_ROOT);
    for dir in dirs do
    begin
      testCases.AddRange(CreateTestCases(dir));
    end;
    result := testCases.ToArray;
  finally
    testCases.Free;
  end;
end;

constructor TBathEncodingProvider.Create;
begin
  inherited;
  FTestCases := TObjectList<TTestCase>.create;
  FTestCases.AddRange(AllTestFiles);
end;

function TBathEncodingProvider.CreateTestCases(dirname: string): TArray<TTestCase>;
var
  expectedEncoding: string;
  files: TArray<string>;
  LFile: string;
  Cases: TList<TTestCase>;
begin
  expectedEncoding := ExtractFileName((dirname.Split(['('])[0].Trim()));
  files := TDirectory.GetFiles(dirname);
  Cases := TList<TTestCase>.Create;
  try
    for LFile in files do
    begin
      Cases.Add(TTestCase.Create(LFile, expectedEncoding));
    end;
    result := Cases.ToArray;
  finally
    Cases.Free;
  end;

end;

class function TBathEncodingProvider.DATA_ROOT: string;
begin
  result := '.\Data\';
end;

destructor TBathEncodingProvider.Destroy;
begin
  FTestCases.Free;
  inherited;
end;

function TBathEncodingProvider.GetCaseCount(const methodName: string): Integer;
begin
  result := FTestCases.Count;
end;

function TBathEncodingProvider.GetCaseName(const methodName: string): string;
begin
  result := methodName;
  if (methodName = 'Comparetest') then
    result := 'Compare Charset';
end;

function TBathEncodingProvider.GetCaseParams(const methodName: string; const caseNumber: integer): TValuearray;
begin
  SetLength(result, 0);
  if (caseNumber >= 0) and (caseNumber < FTestCases.Count) then
  begin
    SetLength(result, 2);
    result[0] := FTestCases[caseNumber].InputFile;
    result[1] := FTestCases[caseNumber].expectedEncoding;
  end;
end;

procedure TBathTestEncodings.Compare(const AInputFile, AExpectedEncoding: string);
var
  detected: IDetectionDetail;
  LInfo: string;
begin
  detected := TCharsetEnigma.DetectFromFile(AInputFile).detected;
  LInfo := 'Charset detection failed for [%s]. Expected: [%s], detected: [%s] (%f confidence)';
  Assert.AreEqual(AExpectedEncoding, detected.EncodingName, True, //
    Format(LInfo, [AInputFile, AExpectedEncoding, detected.EncodingName, detected.Confidence]));
end;

{ TTestCase }

constructor TTestCase.Create(AFilename, AExpectedEncoding: string);
begin
  FInputFile := AFilename;
  FExpectedEncoding := AExpectedEncoding;
end;

function TTestCase.ToString: string;
begin
  result := expectedEncoding + ': ' + InputFile;
end;

procedure TBathTestEncodings.PathWithData;
begin
  Assert.AreEqual(True, DirectoryExists(TBathEncodingProvider.DATA_ROOT))
end;

initialization
  TestDataProviderManager.RegisterProvider('BathEncodingProvider', TBathEncodingProvider);
  TDUnitX.RegisterTestFixture(TBathTestEncodings);

end.

