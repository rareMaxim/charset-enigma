unit CD.Model.SM.HZ_GB_2312;

interface

uses
  CD.Model.StateMachine;

type
  THZ_GB_2312_SMModel = class(TSMModel)
  private
    function HZ_cls: TArray<Integer>;
    function HZ_st: TArray<Integer>;
    function HZCharLenTable: TArray<Integer>;
  public
    constructor Create;
  end;

implementation

uses
  CD.Core.BitPackage;
{ THZ_GB_2312_SMModel }

constructor THZ_GB_2312_SMModel.Create;
begin
  inherited Create(TBitPackage.Create(TBitPackage.INDEX_SHIFT_4BITS,
    TBitPackage.SHIFT_MASK_4BITS, TBitPackage.BIT_SHIFT_4BITS,
    TBitPackage.UNIT_MASK_4BITS, HZ_cls), 6,
    TBitPackage.Create(TBitPackage.INDEX_SHIFT_4BITS,
    TBitPackage.SHIFT_MASK_4BITS, TBitPackage.BIT_SHIFT_4BITS,
    TBitPackage.UNIT_MASK_4BITS, HZ_st), HZCharLenTable, 'HZ-GB-2312')
end;

function THZ_GB_2312_SMModel.HZCharLenTable: TArray<Integer>;
begin
  Result := [0, 0, 0, 0, 0, 0];
end;

function THZ_GB_2312_SMModel.HZ_cls: TArray<Integer>;
begin
  Result := [ //
    TBitPackage.Pack4bits(1, 0, 0, 0, 0, 0, 0, 0), // 00 - 07
  TBitPackage.Pack4bits(0, 0, 0, 0, 0, 0, 0, 0), // 08 - 0f
  TBitPackage.Pack4bits(0, 0, 0, 0, 0, 0, 0, 0), // 10 - 17
  TBitPackage.Pack4bits(0, 0, 0, 1, 0, 0, 0, 0), // 18 - 1f
  TBitPackage.Pack4bits(0, 0, 0, 0, 0, 0, 0, 0), // 20 - 27
  TBitPackage.Pack4bits(0, 0, 0, 0, 0, 0, 0, 0), // 28 - 2f
  TBitPackage.Pack4bits(0, 0, 0, 0, 0, 0, 0, 0), // 30 - 37
  TBitPackage.Pack4bits(0, 0, 0, 0, 0, 0, 0, 0), // 38 - 3f
  TBitPackage.Pack4bits(0, 0, 0, 0, 0, 0, 0, 0), // 40 - 47
  TBitPackage.Pack4bits(0, 0, 0, 0, 0, 0, 0, 0), // 48 - 4f
  TBitPackage.Pack4bits(0, 0, 0, 0, 0, 0, 0, 0), // 50 - 57
  TBitPackage.Pack4bits(0, 0, 0, 0, 0, 0, 0, 0), // 58 - 5f
  TBitPackage.Pack4bits(0, 0, 0, 0, 0, 0, 0, 0), // 60 - 67
  TBitPackage.Pack4bits(0, 0, 0, 0, 0, 0, 0, 0), // 68 - 6f
  TBitPackage.Pack4bits(0, 0, 0, 0, 0, 0, 0, 0), // 70 - 77
  TBitPackage.Pack4bits(0, 0, 0, 4, 0, 5, 2, 0), // 78 - 7f
  TBitPackage.Pack4bits(1, 1, 1, 1, 1, 1, 1, 1), // 80 - 87
  TBitPackage.Pack4bits(1, 1, 1, 1, 1, 1, 1, 1), // 88 - 8f
  TBitPackage.Pack4bits(1, 1, 1, 1, 1, 1, 1, 1), // 90 - 97
  TBitPackage.Pack4bits(1, 1, 1, 1, 1, 1, 1, 1), // 98 - 9f
  TBitPackage.Pack4bits(1, 1, 1, 1, 1, 1, 1, 1), // a0 - a7
  TBitPackage.Pack4bits(1, 1, 1, 1, 1, 1, 1, 1), // a8 - af
  TBitPackage.Pack4bits(1, 1, 1, 1, 1, 1, 1, 1), // b0 - b7
  TBitPackage.Pack4bits(1, 1, 1, 1, 1, 1, 1, 1), // b8 - bf
  TBitPackage.Pack4bits(1, 1, 1, 1, 1, 1, 1, 1), // c0 - c7
  TBitPackage.Pack4bits(1, 1, 1, 1, 1, 1, 1, 1), // c8 - cf
  TBitPackage.Pack4bits(1, 1, 1, 1, 1, 1, 1, 1), // d0 - d7
  TBitPackage.Pack4bits(1, 1, 1, 1, 1, 1, 1, 1), // d8 - df
  TBitPackage.Pack4bits(1, 1, 1, 1, 1, 1, 1, 1), // e0 - e7
  TBitPackage.Pack4bits(1, 1, 1, 1, 1, 1, 1, 1), // e8 - ef
  TBitPackage.Pack4bits(1, 1, 1, 1, 1, 1, 1, 1), // f0 - f7
  TBitPackage.Pack4bits(1, 1, 1, 1, 1, 1, 1, 1) // f8 - ff
    ];
end;

function THZ_GB_2312_SMModel.HZ_st: TArray<Integer>;
begin
  Result := [ //
    TBitPackage.Pack4bits(START, ERROR, 3, START, START, START, ERROR, ERROR),
  // 00-07
  TBitPackage.Pack4bits(ERROR, ERROR, ERROR, ERROR, ITSME, ITSME, ITSME, ITSME),
  // 08-0f
  TBitPackage.Pack4bits(ITSME, ITSME, ERROR, ERROR, START, START, 4, ERROR),
  // 10-17
  TBitPackage.Pack4bits(5, ERROR, 6, ERROR, 5, 5, 4, ERROR), // 18-1f
  TBitPackage.Pack4bits(4, ERROR, 4, 4, 4, ERROR, 4, ERROR), // 20-27
  TBitPackage.Pack4bits(4, ITSME, START, START, START, START, START, START)
  // 28-2f
    ];
end;

end.
