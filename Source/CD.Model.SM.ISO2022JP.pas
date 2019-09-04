unit CD.Model.SM.ISO2022JP;

interface

uses
  CD.Model.StateMachine;

type
  TISO2022JPSMModel = class(TSMModel)
    function ISO2022JP_cls: TArray<Integer>;
    function ISO2022JP_st: TArray<Integer>;
    function ISO2022JPCharLenTable: TArray<Integer>;
    constructor Create;
  end;

implementation

uses
  CD.Core.BitPackage;

{ TISO2022JPSMModel }

constructor TISO2022JPSMModel.Create;
begin
  inherited Create(TBitPackage.Create(TBitPackage.INDEX_SHIFT_4BITS,
    TBitPackage.SHIFT_MASK_4BITS, TBitPackage.BIT_SHIFT_4BITS,
    TBitPackage.UNIT_MASK_4BITS, ISO2022JP_cls), 10,
    TBitPackage.Create(TBitPackage.INDEX_SHIFT_4BITS,
    TBitPackage.SHIFT_MASK_4BITS, TBitPackage.BIT_SHIFT_4BITS,
    TBitPackage.UNIT_MASK_4BITS, ISO2022JP_st), ISO2022JPCharLenTable,
    'ISO-2022-JP');
end;

function TISO2022JPSMModel.ISO2022JPCharLenTable: TArray<Integer>;
begin
  Result := [0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
end;

function TISO2022JPSMModel.ISO2022JP_cls: TArray<Integer>;
begin
  Result := [ //
    TBitPackage.Pack4bits(2, 0, 0, 0, 0, 0, 0, 0), // 00 - 07
  TBitPackage.Pack4bits(0, 0, 0, 0, 0, 0, 2, 2), // 08 - 0f
  TBitPackage.Pack4bits(0, 0, 0, 0, 0, 0, 0, 0), // 10 - 17
  TBitPackage.Pack4bits(0, 0, 0, 1, 0, 0, 0, 0), // 18 - 1f
  TBitPackage.Pack4bits(0, 0, 0, 0, 7, 0, 0, 0), // 20 - 27
  TBitPackage.Pack4bits(3, 0, 0, 0, 0, 0, 0, 0), // 28 - 2f
  TBitPackage.Pack4bits(0, 0, 0, 0, 0, 0, 0, 0), // 30 - 37
  TBitPackage.Pack4bits(0, 0, 0, 0, 0, 0, 0, 0), // 38 - 3f
  TBitPackage.Pack4bits(6, 0, 4, 0, 8, 0, 0, 0), // 40 - 47
  TBitPackage.Pack4bits(0, 9, 5, 0, 0, 0, 0, 0), // 48 - 4f
  TBitPackage.Pack4bits(0, 0, 0, 0, 0, 0, 0, 0), // 50 - 57
  TBitPackage.Pack4bits(0, 0, 0, 0, 0, 0, 0, 0), // 58 - 5f
  TBitPackage.Pack4bits(0, 0, 0, 0, 0, 0, 0, 0), // 60 - 67
  TBitPackage.Pack4bits(0, 0, 0, 0, 0, 0, 0, 0), // 68 - 6f
  TBitPackage.Pack4bits(0, 0, 0, 0, 0, 0, 0, 0), // 70 - 77
  TBitPackage.Pack4bits(0, 0, 0, 0, 0, 0, 0, 0), // 78 - 7f
  TBitPackage.Pack4bits(2, 2, 2, 2, 2, 2, 2, 2), // 80 - 87
  TBitPackage.Pack4bits(2, 2, 2, 2, 2, 2, 2, 2), // 88 - 8f
  TBitPackage.Pack4bits(2, 2, 2, 2, 2, 2, 2, 2), // 90 - 97
  TBitPackage.Pack4bits(2, 2, 2, 2, 2, 2, 2, 2), // 98 - 9f
  TBitPackage.Pack4bits(2, 2, 2, 2, 2, 2, 2, 2), // a0 - a7
  TBitPackage.Pack4bits(2, 2, 2, 2, 2, 2, 2, 2), // a8 - af
  TBitPackage.Pack4bits(2, 2, 2, 2, 2, 2, 2, 2), // b0 - b7
  TBitPackage.Pack4bits(2, 2, 2, 2, 2, 2, 2, 2), // b8 - bf
  TBitPackage.Pack4bits(2, 2, 2, 2, 2, 2, 2, 2), // c0 - c7
  TBitPackage.Pack4bits(2, 2, 2, 2, 2, 2, 2, 2), // c8 - cf
  TBitPackage.Pack4bits(2, 2, 2, 2, 2, 2, 2, 2), // d0 - d7
  TBitPackage.Pack4bits(2, 2, 2, 2, 2, 2, 2, 2), // d8 - df
  TBitPackage.Pack4bits(2, 2, 2, 2, 2, 2, 2, 2), // e0 - e7
  TBitPackage.Pack4bits(2, 2, 2, 2, 2, 2, 2, 2), // e8 - ef
  TBitPackage.Pack4bits(2, 2, 2, 2, 2, 2, 2, 2), // f0 - f7
  TBitPackage.Pack4bits(2, 2, 2, 2, 2, 2, 2, 2) // f8 - ff
    ];
end;

function TISO2022JPSMModel.ISO2022JP_st: TArray<Integer>;
begin
  Result := [ //
    TBitPackage.Pack4bits(START, 3, ERROR, START, START, START, START, START),
  // 00-07
  TBitPackage.Pack4bits(START, START, ERROR, ERROR, ERROR, ERROR, ERROR, ERROR),
  // 08-0f
  TBitPackage.Pack4bits(ERROR, ERROR, ERROR, ERROR, ITSME, ITSME, ITSME, ITSME),
  // 10-17
  TBitPackage.Pack4bits(ITSME, ITSME, ITSME, ITSME, ITSME, ITSME, ERROR, ERROR),
  // 18-1f
  TBitPackage.Pack4bits(ERROR, 5, ERROR, ERROR, ERROR, 4, ERROR, ERROR),
  // 20-27
  TBitPackage.Pack4bits(ERROR, ERROR, ERROR, 6, ITSME, ERROR, ITSME, ERROR),
  // 28-2f
  TBitPackage.Pack4bits(ERROR, ERROR, ERROR, ERROR, ERROR, ERROR, ITSME, ITSME),
  // 30-37
  TBitPackage.Pack4bits(ERROR, ERROR, ERROR, ITSME, ERROR, ERROR, ERROR, ERROR),
  // 38-3f
  TBitPackage.Pack4bits(ERROR, ERROR, ERROR, ERROR, ITSME, ERROR, START, START)
  // 40-47
    ];
end;

end.
