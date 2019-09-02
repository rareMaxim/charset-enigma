unit CharsetEnigmaTest.Test;

interface

uses
  CharsetEnigma.Lite,
  DUnitX.TestFramework,
  System.Classes;

type
  [TestFixture]
  TCharsetDetectorTest = class(TObject)
  private
    function AsciiToSteam(const s: string): TMemoryStream;
  public
    [Test]
    [TestCase('1', '1024,1024,0')]
    [TestCase('2', '2048,2048,0')]
    [TestCase('3', '20,20,0')]
    [TestCase('4', '20,30,10')]
    [TestCase('5', '-1,10000,0')]
    [TestCase('6', '1000000,10000,0')]
    [TestCase('7', '-1,10000,10')]
    procedure DetectFromStreamMaxBytes(maxBytes, expectedPosition, start: Integer);
    [Test]
    procedure TestAscii;
    [Test]
    procedure TestUTF8_1;
    [Test]
    procedure TestIssue3;
    [Test]
    procedure TestOutOfRange;
    [Test]
    procedure TestOutOfRange2;
    [Test]
    procedure TestSingleChar;
  end;

implementation

uses
  System.SysUtils,
  CharsetEnigmaTest.Charsets;

function TCharsetDetectorTest.AsciiToSteam(const s: string): TMemoryStream;
var
  Data: TArray<Byte>;
begin
  Result := TMemoryStream.Create;
  Data := TEncoding.ASCII.GetBytes(s);
  Result.Write(Data, Length(Data));
  Result.Position := 0;
end;

procedure TCharsetDetectorTest.DetectFromStreamMaxBytes(maxBytes, expectedPosition, start: Integer);
var
  text: string;
  stream: TMemoryStream;
begin
  // Arrange
  text := string.Create('a', 10000);
  stream := AsciiToSteam(text);
  stream.Position := start;
  // Act
  TCharsetEnigma.DetectFromStream(stream, maxBytes);
  // Assert
  Assert.AreEqual(Int64(expectedPosition), stream.Position);
end;

procedure TCharsetDetectorTest.TestAscii;
var
  s: string;
  MS: TMemoryStream;
  return: IDetectionResult;
begin
  s := 'The Documentation of the libraries is not complete ' +
    'and your contributions would be greatly appreciated ' + 'the documentation you want to contribute to and '
    + 'click on the [Edit] link to start writing';
  MS := AsciiToSteam(s);
  try
    return := TCharsetEnigma.DetectFromStream(MS);
    Assert.AreEqual(TCharsets.ASCII, return.Detected.EncodingName);
    Assert.AreEqual(Double(1.0), Double(return.Detected.Confidence));
  finally
    MS.Free;
  end;
end;

procedure TCharsetDetectorTest.TestIssue3;
var
  buf: TArray<Byte>;
  return: IDetectionResult;
begin
  buf := TEncoding.UTF8.GetBytes('3');
  return := TCharsetEnigma.DetectFromBytes(buf);
  Assert.AreEqual(TCharsets.ASCII, return.Detected.EncodingName);
  Assert.AreEqual(Double(1.0), Double(return.Detected.Confidence));
end;

procedure TCharsetDetectorTest.TestOutOfRange;
var
  buf: TArray<Byte>;
  return: IDetectionResult;
begin
  buf := TEncoding.UTF8.GetBytes('3');
  return := TCharsetEnigma.DetectFromBytes(buf);
  Assert.AreEqual(TCharsets.ASCII, return.Detected.EncodingName);
  Assert.AreEqual(Double(1.0), Double(return.Detected.Confidence));
end;

procedure TCharsetDetectorTest.TestOutOfRange2;
var
  buf: TArray<Byte>;
  return: IDetectionResult;
begin
  buf := TEncoding.UTF8.GetBytes('1234567890');
  return := TCharsetEnigma.DetectFromBytes(buf);
  Assert.AreEqual(TCharsets.ASCII, return.Detected.EncodingName);
  Assert.AreEqual(Double(1.0), Double(return.Detected.Confidence));
end;

procedure TCharsetDetectorTest.TestSingleChar;
var
  buf: TArray<Byte>;
  return: IDetectionResult;
begin
  buf := TEncoding.UTF8.GetBytes('3');
  return := TCharsetEnigma.DetectFromBytes(buf);
  Assert.AreEqual(TCharsets.ASCII, return.Detected.EncodingName);
  Assert.AreEqual(Double(1.0), Double(return.Detected.Confidence));
end;

procedure TCharsetDetectorTest.TestUTF8_1;
var
  s: string;
  buf: TArray<Byte>;
  return: IDetectionResult;
begin
  s := 'ウィキペディアはオープンコンテントの百科事典です。基本方針に賛同し' +  //
    'ていただけるなら、誰でも記事を編集したり新しく作成したりできます。' +  //
    'ガイドブックを読んでから、サンドボックスで練習してみましょう。質問は' + //
    '利用案内でどうぞ。';
  buf := TEncoding.UTF8.GetBytes(s);
  return := TCharsetEnigma.DetectFromBytes(buf);
  Assert.AreEqual(TCharsets.UTF8, return.Detected.EncodingName);
  Assert.AreEqual(Double(1.0), Double(return.Detected.Confidence));
end;

initialization
  TDUnitX.RegisterTestFixture(TCharsetDetectorTest);

end.

