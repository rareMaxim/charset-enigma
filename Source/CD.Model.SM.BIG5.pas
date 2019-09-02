unit CD.Model.SM.BIG5;

interface

uses
  CD.Model.StateMachine;

type
  TBIG5SMModel = class(TSMModel)
  private
    function BIG5_cls: TArray<Integer>;
    function BIG5_st: TArray<Integer>;
    function BIG5CharLenTable: TArray<Integer>;
  public
    constructor Create;
  end;

implementation

uses
  CD.Core.BitPackage;

{ TBIG5SMModel }

function TBIG5SMModel.BIG5CharLenTable: TArray<Integer>;
begin
  Result := [0, 1, 1, 2, 0];
end;

function TBIG5SMModel.BIG5_cls: TArray<Integer>;
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
    TBitPackage.Pack4bits(2, 2, 2, 2, 2, 2, 2, 2), // 40 - 47
    TBitPackage.Pack4bits(2, 2, 2, 2, 2, 2, 2, 2), // 48 - 4f
    TBitPackage.Pack4bits(2, 2, 2, 2, 2, 2, 2, 2), // 50 - 57
    TBitPackage.Pack4bits(2, 2, 2, 2, 2, 2, 2, 2), // 58 - 5f
    TBitPackage.Pack4bits(2, 2, 2, 2, 2, 2, 2, 2), // 60 - 67
    TBitPackage.Pack4bits(2, 2, 2, 2, 2, 2, 2, 2), // 68 - 6f
    TBitPackage.Pack4bits(2, 2, 2, 2, 2, 2, 2, 2), // 70 - 77
    TBitPackage.Pack4bits(2, 2, 2, 2, 2, 2, 2, 1), // 78 - 7f
    TBitPackage.Pack4bits(4, 4, 4, 4, 4, 4, 4, 4), // 80 - 87
    TBitPackage.Pack4bits(4, 4, 4, 4, 4, 4, 4, 4), // 88 - 8f
    TBitPackage.Pack4bits(4, 4, 4, 4, 4, 4, 4, 4), // 90 - 97
    TBitPackage.Pack4bits(4, 4, 4, 4, 4, 4, 4, 4), // 98 - 9f
    TBitPackage.Pack4bits(4, 3, 3, 3, 3, 3, 3, 3), // a0 - a7
    TBitPackage.Pack4bits(3, 3, 3, 3, 3, 3, 3, 3), // a8 - af
    TBitPackage.Pack4bits(3, 3, 3, 3, 3, 3, 3, 3), // b0 - b7
    TBitPackage.Pack4bits(3, 3, 3, 3, 3, 3, 3, 3), // b8 - bf
    TBitPackage.Pack4bits(3, 3, 3, 3, 3, 3, 3, 3), // c0 - c7
    TBitPackage.Pack4bits(3, 3, 3, 3, 3, 3, 3, 3), // c8 - cf
    TBitPackage.Pack4bits(3, 3, 3, 3, 3, 3, 3, 3), // d0 - d7
    TBitPackage.Pack4bits(3, 3, 3, 3, 3, 3, 3, 3), // d8 - df
    TBitPackage.Pack4bits(3, 3, 3, 3, 3, 3, 3, 3), // e0 - e7
    TBitPackage.Pack4bits(3, 3, 3, 3, 3, 3, 3, 3), // e8 - ef
    TBitPackage.Pack4bits(3, 3, 3, 3, 3, 3, 3, 3), // f0 - f7
    TBitPackage.Pack4bits(3, 3, 3, 3, 3, 3, 3, 0) // f8 - ff
    ];
end;

function TBIG5SMModel.BIG5_st: TArray<Integer>;
begin
  Result := [ //
    TBitPackage.Pack4bits(ERROR, START, START, 3, ERROR, ERROR, ERROR, ERROR),  // 00-07
    TBitPackage.Pack4bits(ERROR, ERROR, ITSME, ITSME, ITSME, ITSME, ITSME, ERROR),  // 08-0f
    TBitPackage.Pack4bits(ERROR, START, START, START, START, START, START, START)  // 10-17
    ];
end;

constructor TBIG5SMModel.Create;
begin
  inherited Create(TBitPackage.Create(TBitPackage.INDEX_SHIFT_4BITS, TBitPackage.SHIFT_MASK_4BITS,
    TBitPackage.BIT_SHIFT_4BITS, TBitPackage.UNIT_MASK_4BITS, BIG5_cls), 5,
    TBitPackage.Create(TBitPackage.INDEX_SHIFT_4BITS, TBitPackage.SHIFT_MASK_4BITS,
    TBitPackage.BIT_SHIFT_4BITS, TBitPackage.UNIT_MASK_4BITS, BIG5_st), BIG5CharLenTable, 'Big5');
end;

end.

