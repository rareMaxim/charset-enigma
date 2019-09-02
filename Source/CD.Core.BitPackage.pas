unit CD.Core.BitPackage;

interface

type
  IBitPackage = interface
    ['{3206B45C-7257-4BE1-94BE-7758324226B0}']
    function Unpack(i: Integer): Integer;
  end;

  TBitPackage = class(TInterfacedObject, IBitPackage)
  public
    const
      INDEX_SHIFT_4BITS = 3;
      INDEX_SHIFT_8BITS = 2;
      INDEX_SHIFT_16BITS = 1;
      SHIFT_MASK_4BITS = 7;
      SHIFT_MASK_8BITS = 3;
      SHIFT_MASK_16BITS = 1;
      BIT_SHIFT_4BITS = 2;
      BIT_SHIFT_8BITS = 3;
      BIT_SHIFT_16BITS = 4;
      UNIT_MASK_4BITS = $0000000F;
      UNIT_MASK_8BITS = $000000FF;
      UNIT_MASK_16BITS = $0000FFFF;
  private
    indexShift: Integer;
    shiftMask: Integer;
    bitShift: Integer;
    unitMask: Integer;
    data: TArray<Integer>;
  public
    constructor Create(AIndexShift, AShiftMask, ABitShift, AUnitMask: Integer; AData: TArray<Integer>);
    function Unpack(i: Integer): Integer;
    class function Pack16bits(a, b: Integer): Integer;
    class function Pack8bits(a, b, c, d: Integer): Integer;
    class function Pack4bits(a, b, c, d, e, f, g, h: Integer): Integer;
  end;

implementation

{ TBitPackage }

constructor TBitPackage.Create(AIndexShift, AShiftMask, ABitShift, AUnitMask: Integer; AData: TArray<Integer>);
begin
  Self.indexShift := AIndexShift;
  Self.shiftMask := AShiftMask;
  Self.bitShift := ABitShift;
  Self.unitMask := AUnitMask;
  Self.data := AData;
end;

class function TBitPackage.Pack16bits(a, b: Integer): Integer;
begin
  Result := ((b shl 16) or a);
end;

class function TBitPackage.Pack4bits(a, b, c, d, e, f, g, h: Integer): Integer;
begin
  Result := Pack8bits((b shl 4) or a, (d shl 4) or c, (f shl 4) or e, (h shl 4) or g);
end;

function TBitPackage.Unpack(i: Integer): Integer;
begin
  Result := (data[i shr indexShift] shr ((i and shiftMask) shl bitShift)) and unitMask;
end;

class function TBitPackage.Pack8bits(a, b, c, d: Integer): Integer;
begin
  Result := Pack16bits((b shl 8) or a, (d shl 8) or c);
end;

end.

