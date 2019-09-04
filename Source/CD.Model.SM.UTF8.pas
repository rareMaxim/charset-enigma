unit CD.Model.SM.UTF8;

interface

uses
  CD.Model.StateMachine;

type
  TUTF8SMModel = class(TSMModel)
    function UTF8_cls: TArray<Integer>;
    function UTF8_st: TArray<Integer>;
    function UTF8CharLenTable: TArray<Integer>;
    constructor Create;
  end;

implementation

uses
  CD.Core.BitPackage;

{ TUTF8SMModel }

constructor TUTF8SMModel.Create;
begin
  inherited Create(TBitPackage.Create(TBitPackage.INDEX_SHIFT_4BITS, TBitPackage.SHIFT_MASK_4BITS,
    TBitPackage.BIT_SHIFT_4BITS, TBitPackage.UNIT_MASK_4BITS, UTF8_cls), 16,
    TBitPackage.Create(TBitPackage.INDEX_SHIFT_4BITS, TBitPackage.SHIFT_MASK_4BITS,
    TBitPackage.BIT_SHIFT_4BITS, TBitPackage.UNIT_MASK_4BITS, UTF8_st), UTF8CharLenTable, 'UTF-8');
end;

function TUTF8SMModel.UTF8CharLenTable: TArray<Integer>;
begin
  Result := [0, 1, 0, 0, 0, 0, 2, 3, 3, 3, 4, 4, 5, 5, 6, 6];
end;

function TUTF8SMModel.UTF8_cls: TArray<Integer>;
begin
  Result := [ //
    TBitPackage.Pack4bits(1, 1, 1, 1, 1, 1, 1, 1), // 00 - 07
    TBitPackage.Pack4bits(1, 1, 1, 1, 1, 1, 0, 0), // 08 - 0f
    TBitPackage.Pack4bits(1, 1, 1, 1, 1, 1, 1, 1), // 10 - 17
    TBitPackage.Pack4bits(1, 1, 1, 0, 1, 1, 1, 1), // 18 - 1f
    TBitPackage.Pack4bits(1, 1, 1, 1, 1, 1, 1, 1), // 20 - 27
    TBitPackage.Pack4bits(1, 1, 1, 1, 1, 1, 1, 1), // 28 - 2f
    TBitPackage.Pack4bits(1, 1, 1, 1, 1, 1, 1, 1), // 30 - 37
    TBitPackage.Pack4bits(1, 1, 1, 1, 1, 1, 1, 1), // 38 - 3f
    TBitPackage.Pack4bits(1, 1, 1, 1, 1, 1, 1, 1), // 40 - 47
    TBitPackage.Pack4bits(1, 1, 1, 1, 1, 1, 1, 1), // 48 - 4f
    TBitPackage.Pack4bits(1, 1, 1, 1, 1, 1, 1, 1), // 50 - 57
    TBitPackage.Pack4bits(1, 1, 1, 1, 1, 1, 1, 1), // 58 - 5f
    TBitPackage.Pack4bits(1, 1, 1, 1, 1, 1, 1, 1), // 60 - 67
    TBitPackage.Pack4bits(1, 1, 1, 1, 1, 1, 1, 1), // 68 - 6f
    TBitPackage.Pack4bits(1, 1, 1, 1, 1, 1, 1, 1), // 70 - 77
    TBitPackage.Pack4bits(1, 1, 1, 1, 1, 1, 1, 1), // 78 - 7f
    TBitPackage.Pack4bits(2, 2, 2, 2, 3, 3, 3, 3), // 80 - 87
    TBitPackage.Pack4bits(4, 4, 4, 4, 4, 4, 4, 4), // 88 - 8f
    TBitPackage.Pack4bits(4, 4, 4, 4, 4, 4, 4, 4), // 90 - 97
    TBitPackage.Pack4bits(4, 4, 4, 4, 4, 4, 4, 4), // 98 - 9f
    TBitPackage.Pack4bits(5, 5, 5, 5, 5, 5, 5, 5), // a0 - a7
    TBitPackage.Pack4bits(5, 5, 5, 5, 5, 5, 5, 5), // a8 - af
    TBitPackage.Pack4bits(5, 5, 5, 5, 5, 5, 5, 5), // b0 - b7
    TBitPackage.Pack4bits(5, 5, 5, 5, 5, 5, 5, 5), // b8 - bf
    TBitPackage.Pack4bits(0, 0, 6, 6, 6, 6, 6, 6), // c0 - c7
    TBitPackage.Pack4bits(6, 6, 6, 6, 6, 6, 6, 6), // c8 - cf
    TBitPackage.Pack4bits(6, 6, 6, 6, 6, 6, 6, 6), // d0 - d7
    TBitPackage.Pack4bits(6, 6, 6, 6, 6, 6, 6, 6), // d8 - df
    TBitPackage.Pack4bits(7, 8, 8, 8, 8, 8, 8, 8), // e0 - e7
    TBitPackage.Pack4bits(8, 8, 8, 8, 8, 9, 8, 8), // e8 - ef
    TBitPackage.Pack4bits(10, 11, 11, 11, 11, 11, 11, 11), // f0 - f7
    TBitPackage.Pack4bits(12, 13, 13, 13, 14, 15, 0, 0) // f8 - ff
    ];
end;

function TUTF8SMModel.UTF8_st: TArray<Integer>;
begin
  Result := [ //
    TBitPackage.Pack4bits(ERROR, START, ERROR, ERROR, ERROR, ERROR, 12, 10),  // 00-07
    TBitPackage.Pack4bits(9, 11, 8, 7, 6, 5, 4, 3), // 08-0f
    TBitPackage.Pack4bits(ERROR, ERROR, ERROR, ERROR, ERROR, ERROR, ERROR, ERROR),  // 10-17
    TBitPackage.Pack4bits(ERROR, ERROR, ERROR, ERROR, ERROR, ERROR, ERROR, ERROR),  // 18-1f
    TBitPackage.Pack4bits(ITSME, ITSME, ITSME, ITSME, ITSME, ITSME, ITSME, ITSME),  // 20-27
    TBitPackage.Pack4bits(ITSME, ITSME, ITSME, ITSME, ITSME, ITSME, ITSME, ITSME),  // 28-2f
    TBitPackage.Pack4bits(ERROR, ERROR, 5, 5, 5, 5, ERROR, ERROR), // 30-37
    TBitPackage.Pack4bits(ERROR, ERROR, ERROR, ERROR, ERROR, ERROR, ERROR, ERROR),  // 38-3f
    TBitPackage.Pack4bits(ERROR, ERROR, ERROR, 5, 5, 5, ERROR, ERROR), // 40-47
    TBitPackage.Pack4bits(ERROR, ERROR, ERROR, ERROR, ERROR, ERROR, ERROR, ERROR),  // 48-4f
    TBitPackage.Pack4bits(ERROR, ERROR, 7, 7, 7, 7, ERROR, ERROR), // 50-57
    TBitPackage.Pack4bits(ERROR, ERROR, ERROR, ERROR, ERROR, ERROR, ERROR, ERROR),  // 58-5f
    TBitPackage.Pack4bits(ERROR, ERROR, ERROR, ERROR, 7, 7, ERROR, ERROR),  // 60-67
    TBitPackage.Pack4bits(ERROR, ERROR, ERROR, ERROR, ERROR, ERROR, ERROR, ERROR),  // 68-6f
    TBitPackage.Pack4bits(ERROR, ERROR, 9, 9, 9, 9, ERROR, ERROR), // 70-77
    TBitPackage.Pack4bits(ERROR, ERROR, ERROR, ERROR, ERROR, ERROR, ERROR, ERROR),  // 78-7f
    TBitPackage.Pack4bits(ERROR, ERROR, ERROR, ERROR, ERROR, 9, ERROR, ERROR),  // 80-87
    TBitPackage.Pack4bits(ERROR, ERROR, ERROR, ERROR, ERROR, ERROR, ERROR, ERROR),  // 88-8f
    TBitPackage.Pack4bits(ERROR, ERROR, 12, 12, 12, 12, ERROR, ERROR), // 90-97
    TBitPackage.Pack4bits(ERROR, ERROR, ERROR, ERROR, ERROR, ERROR, ERROR, ERROR),  // 98-9f
    TBitPackage.Pack4bits(ERROR, ERROR, ERROR, ERROR, ERROR, 12, ERROR, ERROR),  // a0-a7
    TBitPackage.Pack4bits(ERROR, ERROR, ERROR, ERROR, ERROR, ERROR, ERROR, ERROR),  // a8-af
    TBitPackage.Pack4bits(ERROR, ERROR, 12, 12, 12, ERROR, ERROR, ERROR), // b0-b7
    TBitPackage.Pack4bits(ERROR, ERROR, ERROR, ERROR, ERROR, ERROR, ERROR, ERROR),  // b8-bf
    TBitPackage.Pack4bits(ERROR, ERROR, START, START, START, START, ERROR, ERROR),  // c0-c7
    TBitPackage.Pack4bits(ERROR, ERROR, ERROR, ERROR, ERROR, ERROR, ERROR, ERROR)  // c8-cf
    ];
end;

end.

