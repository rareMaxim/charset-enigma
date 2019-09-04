unit CharsetEnigmaTest.BOMs;

interface

uses
  DUnitX.TestFramework;

type
  [TestFixture]
  TCharsetEnigmaBOMsTest = class
  private
  public
    [Test]
    procedure TestBomUtf8;
    [Test]
    procedure TestBomUTF16_BE;
    [Test]
    procedure TestBomUTF_16BE;
    [Test]
    procedure TestBomUTF16_LE;
    [Test]
    procedure TestBomUTF32_BE;
    [Test]
    procedure TestBomUTF32_LE;
    [Test]
    procedure TestBomUTF7_1;
    [Test]
    procedure TestBomUTF7_2;
    [Test]
    procedure TestBomUTF7_3;
    [Test]
    procedure TestBomUTF7_4;
    [Test]
    procedure TestBomUTF1;
    [Test]
    procedure TestBomUTF_EBCDIC;
    [Test]
    procedure TestBomSCSU;
    [Test]
    procedure TestBomBOCU_1;
    [Test]
    procedure TestBomGB_18030;
  end;

implementation

uses
  CharsetEnigma.Lite,
  CharsetEnigmaTest.Charsets;

procedure TCharsetEnigmaBOMsTest.TestBomUtf8;
var
  buf: TArray<Byte>;
  return: IDetectionResult;
begin
  buf := [$EF, $BB, $BF, $68, $65, $6C, $6C, $6F, $21];
  return := TCharsetEnigma.DetectFromBytes(buf);
  Assert.AreEqual(TCharsets.UTF8, return.Detected.EncodingName);
  Assert.AreEqual(Double(1.0), Double(return.Detected.Confidence));
end;

procedure TCharsetEnigmaBOMsTest.TestBomBOCU_1;
var
  buf: TArray<Byte>;
  return: IDetectionResult;
begin
  buf := [$FB, $EE, $28, $68, $65, $6C, $6C, $6F, $21];
  return := TCharsetEnigma.DetectFromBytes(buf);
  Assert.AreEqual(TCharsets.BOCU_1, return.Detected.EncodingName);
  Assert.AreEqual(Double(1.0), Double(return.Detected.Confidence));
end;

procedure TCharsetEnigmaBOMsTest.TestBomGB_18030;
var
  buf: TArray<Byte>;
  return: IDetectionResult;
begin
  buf := [$84, $31, $95, $33, $68, $65, $6C, $6C, $6F, $21];
  return := TCharsetEnigma.DetectFromBytes(buf);
  Assert.AreEqual(TCharsets.GB_18030, return.Detected.EncodingName);
  Assert.AreEqual(Double(1.0), Double(return.Detected.Confidence));
end;

procedure TCharsetEnigmaBOMsTest.TestBomSCSU;
var
  buf: TArray<Byte>;
  return: IDetectionResult;
begin
  buf := [$0E, $FE, $FF, $33, $68, $65, $6C, $6C, $6F, $21];
  return := TCharsetEnigma.DetectFromBytes(buf);
  Assert.AreEqual(TCharsets.SCSU, return.Detected.EncodingName);
  Assert.AreEqual(Double(1.0), Double(return.Detected.Confidence));
end;

procedure TCharsetEnigmaBOMsTest.TestBomUTF1;
var
  buf: TArray<Byte>;
  return: IDetectionResult;
begin
  buf := [$F7, $64, $4C, $FF, $FE, $00, $00, $68, $00, $00, $00];
  return := TCharsetEnigma.DetectFromBytes(buf);
  Assert.AreEqual(TCharsets.UTF1, return.Detected.EncodingName);
  Assert.AreEqual(Double(1.0), Double(return.Detected.Confidence));
end;

procedure TCharsetEnigmaBOMsTest.TestBomUTF16_BE;
var
  buf: TArray<Byte>;
  return: IDetectionResult;
begin
  buf := [$FE, $FF, $00, $68, $00, $65];
  return := TCharsetEnigma.DetectFromBytes(buf);
  Assert.AreEqual(TCharsets.UTF16_BE, return.Detected.EncodingName);
  Assert.AreEqual(Double(1.0), Double(return.Detected.Confidence));
end;

procedure TCharsetEnigmaBOMsTest.TestBomUTF16_LE;
var
  buf: TArray<Byte>;
  return: IDetectionResult;
begin
  buf := [$FF, $FE, $68, $00, $65, $00];
  return := TCharsetEnigma.DetectFromBytes(buf);
  Assert.AreEqual(TCharsets.UTF16_LE, return.Detected.EncodingName);
  Assert.AreEqual(Double(1.0), Double(return.Detected.Confidence));
end;

procedure TCharsetEnigmaBOMsTest.TestBomUTF32_BE;
var
  buf: TArray<Byte>;
  return: IDetectionResult;
begin
  buf := [$00, $00, $FE, $FF, $00, $00, $00, $68];
  return := TCharsetEnigma.DetectFromBytes(buf);
  Assert.AreEqual(TCharsets.UTF32_BE, return.Detected.EncodingName);
  Assert.AreEqual(Double(1.0), Double(return.Detected.Confidence));
end;

procedure TCharsetEnigmaBOMsTest.TestBomUTF32_LE;
var
  buf: TArray<Byte>;
  return: IDetectionResult;
begin
  buf := [$FF, $FE, $00, $00, $68, $00, $00, $00];
  return := TCharsetEnigma.DetectFromBytes(buf);
  Assert.AreEqual(TCharsets.UTF32_LE, return.Detected.EncodingName);
  Assert.AreEqual(Double(1.0), Double(return.Detected.Confidence));
end;

procedure TCharsetEnigmaBOMsTest.TestBomUTF7_1;
var
  buf: TArray<Byte>;
  return: IDetectionResult;
begin
  buf := [$2B, $2F, $76, $38, $FF, $FE, $00, $00, $68, $00, $00, $00];
  return := TCharsetEnigma.DetectFromBytes(buf);
  Assert.AreEqual(TCharsets.UTF7, return.Detected.EncodingName);
  Assert.AreEqual(Double(1.0), Double(return.Detected.Confidence));
end;

procedure TCharsetEnigmaBOMsTest.TestBomUTF7_2;
var
  buf: TArray<Byte>;
  return: IDetectionResult;
begin
  buf := [$2B, $2F, $76, $39, $FF, $FE, $00, $00, $68, $00, $00, $00];
  return := TCharsetEnigma.DetectFromBytes(buf);
  Assert.AreEqual(TCharsets.UTF7, return.Detected.EncodingName);
  Assert.AreEqual(Double(1.0), Double(return.Detected.Confidence));
end;

procedure TCharsetEnigmaBOMsTest.TestBomUTF7_3;
var
  buf: TArray<Byte>;
  return: IDetectionResult;
begin
  buf := [$2B, $2F, $76, $2B, $FF, $FE, $00, $00, $68, $00, $00, $00];
  return := TCharsetEnigma.DetectFromBytes(buf);
  Assert.AreEqual(TCharsets.UTF7, return.Detected.EncodingName);
  Assert.AreEqual(Double(1.0), Double(return.Detected.Confidence));
end;

procedure TCharsetEnigmaBOMsTest.TestBomUTF7_4;
var
  buf: TArray<Byte>;
  return: IDetectionResult;
begin
  buf := [$2B, $2F, $76, $2F, $FF, $FE, $00, $00, $68, $00, $00, $00];
  return := TCharsetEnigma.DetectFromBytes(buf);
  Assert.AreEqual(TCharsets.UTF7, return.Detected.EncodingName);
  Assert.AreEqual(Double(1.0), Double(return.Detected.Confidence));
end;

procedure TCharsetEnigmaBOMsTest.TestBomUTF_16BE;
var
  buf: TArray<Byte>;
  return: IDetectionResult;
begin
  buf := [$FE, $FF, $00, $00, $65];
  return := TCharsetEnigma.DetectFromBytes(buf);
  Assert.AreEqual(TCharsets.UTF16_BE, return.Detected.EncodingName);
  Assert.AreEqual(Double(1.0), Double(return.Detected.Confidence));
end;

procedure TCharsetEnigmaBOMsTest.TestBomUTF_EBCDIC;
var
  buf: TArray<Byte>;
  return: IDetectionResult;
begin
  buf := [$DD, $73, $66, $73, $76, $2F, $FF, $FE, $00, $00, $68, $00, $00, $00];
  return := TCharsetEnigma.DetectFromBytes(buf);
  Assert.AreEqual(TCharsets.UTF_EBCDIC, return.Detected.EncodingName);
  Assert.AreEqual(Double(1.0), Double(return.Detected.Confidence));

end;

initialization
  TDUnitX.RegisterTestFixture(TCharsetEnigmaBOMsTest);

end.

