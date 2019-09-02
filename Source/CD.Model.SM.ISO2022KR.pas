unit CD.Model.SM.ISO2022KR;

interface

uses
  CD.Model.StateMachine;

type
  TISO2022KRSMModel = class(TSMModel)
    function ISO2022KR_cls: TArray<Integer>;
    function ISO2022KR_st: TArray<Integer>;
    function ISO2022KRCharLenTable: TArray<Integer>;
    constructor Create;
  end;

implementation

uses
  CD.Core.BitPackage;

{ TISO2022KRSMModel }

constructor TISO2022KRSMModel.Create;
begin
  inherited Create(TBitPackage.Create(TBitPackage.INDEX_SHIFT_4BITS,
    TBitPackage.SHIFT_MASK_4BITS, TBitPackage.BIT_SHIFT_4BITS,
    TBitPackage.UNIT_MASK_4BITS, ISO2022KR_cls), 6,
    TBitPackage.Create(TBitPackage.INDEX_SHIFT_4BITS,
    TBitPackage.SHIFT_MASK_4BITS, TBitPackage.BIT_SHIFT_4BITS,
    TBitPackage.UNIT_MASK_4BITS, ISO2022KR_st), ISO2022KRCharLenTable,
    'ISO-2022-KR');
end;

function TISO2022KRSMModel.ISO2022KRCharLenTable: TArray<Integer>;
begin
  Result := [0, 0, 0, 0, 0, 0];
end;

function TISO2022KRSMModel.ISO2022KR_cls: TArray<Integer>;
begin
  Result := [ //
    TBitPackage.Pack4bits(2, 0, 0, 0, 0, 0, 0, 0), // 00 - 07
  TBitPackage.Pack4bits(0, 0, 0, 0, 0, 0, 0, 0), // 08 - 0f
  TBitPackage.Pack4bits(0, 0, 0, 0, 0, 0, 0, 0), // 10 - 17
  TBitPackage.Pack4bits(0, 0, 0, 1, 0, 0, 0, 0), // 18 - 1f
  TBitPackage.Pack4bits(0, 0, 0, 0, 3, 0, 0, 0), // 20 - 27
  TBitPackage.Pack4bits(0, 4, 0, 0, 0, 0, 0, 0), // 28 - 2f
  TBitPackage.Pack4bits(0, 0, 0, 0, 0, 0, 0, 0), // 30 - 37
  TBitPackage.Pack4bits(0, 0, 0, 0, 0, 0, 0, 0), // 38 - 3f
  TBitPackage.Pack4bits(0, 0, 0, 5, 0, 0, 0, 0), // 40 - 47
  TBitPackage.Pack4bits(0, 0, 0, 0, 0, 0, 0, 0), // 48 - 4f
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

function TISO2022KRSMModel.ISO2022KR_st: TArray<Integer>;
begin
  Result := [TBitPackage.Pack4bits(START, 3, ERROR, START, START, START, ERROR,
    ERROR), // 00-07
  TBitPackage.Pack4bits(ERROR, ERROR, ERROR, ERROR, ITSME, ITSME, ITSME, ITSME),
  // 08-0f
  TBitPackage.Pack4bits(ITSME, ITSME, ERROR, ERROR, ERROR, 4, ERROR, ERROR),
  // 10-17
  TBitPackage.Pack4bits(ERROR, ERROR, ERROR, ERROR, 5, ERROR, ERROR, ERROR),
  // 18-1f
  TBitPackage.Pack4bits(ERROR, ERROR, ERROR, ITSME, START, START, START, START)
  // 20-27 ];
    ];
end;

end.
