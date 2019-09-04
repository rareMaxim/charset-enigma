unit CharsetEnigmaTest.BitPackage;

interface

uses
  CD.Core.BitPackage,
  DUnitX.TestFramework;

type
  [TestFixture]
  TBitPackageTest = class(TObject)
  public
    [Test]
    procedure TestPack();
    [Test]
    procedure TestUnpack();
  end;

implementation

procedure TBitPackageTest.TestPack;
begin
  Assert.AreEqual(TBitPackage.Pack4bits(0, 0, 0, 0, 0, 0, 0, 0), 0);
  Assert.AreEqual(TBitPackage.Pack4bits(1, 1, 1, 1, 1, 1, 1, 1), 286331153);
  Assert.AreEqual(TBitPackage.Pack4bits(2, 2, 2, 2, 2, 2, 2, 2), 572662306);
  Assert.AreEqual(TBitPackage.Pack4bits(15, 15, 15, 15, 15, 15, 15, 15), -1);
end;

procedure TBitPackageTest.TestUnpack;
var
  data: TArray<Integer>;
  Pkg: TBitPackage;
  I: Integer;
  n: Integer;
begin
  data := [//
    TBitPackage.Pack4bits(0, 1, 2, 3, 4, 5, 6, 7), //
    TBitPackage.Pack4bits(8, 9, 10, 11, 12, 13, 14, 15)];

  Pkg := TBitPackage.Create(
 {} TBitPackage.INDEX_SHIFT_4BITS,
 {} TBitPackage.SHIFT_MASK_4BITS,
 {} TBitPackage.BIT_SHIFT_4BITS,
 {} TBitPackage.UNIT_MASK_4BITS,
 {} data);
  try
    for I := 0 to 15 do
    begin
      n := Pkg.Unpack(I);
      Assert.AreEqual(n, I);
    end;
  finally
    Pkg.Free;
  end;
end;

initialization
  TDUnitX.RegisterTestFixture(TBitPackageTest);

end.

