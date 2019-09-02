unit CD.Model.SM.EUCTW;

interface

uses
  CD.Model.StateMachine;

type
  TEUCTWSMModel = class(TSMModel)
  private
    function EUCTW_cls: TArray<Integer>;
    function EUCTW_st: TArray<Integer>;
    function EUCTWCharLenTable: TArray<Integer>;
  public
    constructor Create;
  end;

implementation

uses
  CD.Core.BitPackage;

{ TEUCTWSMModel }

constructor TEUCTWSMModel.Create;
begin
  inherited Create(TBitPackage.Create(TBitPackage.INDEX_SHIFT_4BITS,
    TBitPackage.SHIFT_MASK_4BITS, TBitPackage.BIT_SHIFT_4BITS,
    TBitPackage.UNIT_MASK_4BITS, EUCTW_cls), 7,
    TBitPackage.Create(TBitPackage.INDEX_SHIFT_4BITS,
    TBitPackage.SHIFT_MASK_4BITS, TBitPackage.BIT_SHIFT_4BITS,
    TBitPackage.UNIT_MASK_4BITS, EUCTW_st), EUCTWCharLenTable, 'EUC-TW');
end;

function TEUCTWSMModel.EUCTWCharLenTable: TArray<Integer>;
begin
  Result := [0, 0, 1, 2, 2, 2, 3];
end;

function TEUCTWSMModel.EUCTW_cls: TArray<Integer>;
begin
  Result := [ //
    TBitPackage.Pack4bits(2, 2, 2, 2, 2, 2, 2, 2), // 00 - 07
  TBitPackage.Pack4bits(2, 2, 2, 2, 2, 2, 0, 0), // 08 - 0f
  TBitPackage.Pack4bits(2, 2, 2, 2, 2, 2, 2, 2), // 10 - 17
  TBitPackage.Pack4bits(2, 2, 2, 0, 2, 2, 2, 2), // 18 - 1f
  TBitPackage.Pack4bits(2, 2, 2, 2, 2, 2, 2, 2), // 20 - 27
  TBitPackage.Pack4bits(2, 2, 2, 2, 2, 2, 2, 2), // 28 - 2f
  TBitPackage.Pack4bits(2, 2, 2, 2, 2, 2, 2, 2), // 30 - 37
  TBitPackage.Pack4bits(2, 2, 2, 2, 2, 2, 2, 2), // 38 - 3f
  TBitPackage.Pack4bits(2, 2, 2, 2, 2, 2, 2, 2), // 40 - 47
  TBitPackage.Pack4bits(2, 2, 2, 2, 2, 2, 2, 2), // 48 - 4f
  TBitPackage.Pack4bits(2, 2, 2, 2, 2, 2, 2, 2), // 50 - 57
  TBitPackage.Pack4bits(2, 2, 2, 2, 2, 2, 2, 2), // 58 - 5f
  TBitPackage.Pack4bits(2, 2, 2, 2, 2, 2, 2, 2), // 60 - 67
  TBitPackage.Pack4bits(2, 2, 2, 2, 2, 2, 2, 2), // 68 - 6f
  TBitPackage.Pack4bits(2, 2, 2, 2, 2, 2, 2, 2), // 70 - 77
  TBitPackage.Pack4bits(2, 2, 2, 2, 2, 2, 2, 2), // 78 - 7f
  TBitPackage.Pack4bits(0, 0, 0, 0, 0, 0, 0, 0), // 80 - 87
  TBitPackage.Pack4bits(0, 0, 0, 0, 0, 0, 6, 0), // 88 - 8f
  TBitPackage.Pack4bits(0, 0, 0, 0, 0, 0, 0, 0), // 90 - 97
  TBitPackage.Pack4bits(0, 0, 0, 0, 0, 0, 0, 0), // 98 - 9f
  TBitPackage.Pack4bits(0, 3, 4, 4, 4, 4, 4, 4), // a0 - a7
  TBitPackage.Pack4bits(5, 5, 1, 1, 1, 1, 1, 1), // a8 - af
  TBitPackage.Pack4bits(1, 1, 1, 1, 1, 1, 1, 1), // b0 - b7
  TBitPackage.Pack4bits(1, 1, 1, 1, 1, 1, 1, 1), // b8 - bf
  TBitPackage.Pack4bits(1, 1, 3, 1, 3, 3, 3, 3), // c0 - c7
  TBitPackage.Pack4bits(3, 3, 3, 3, 3, 3, 3, 3), // c8 - cf
  TBitPackage.Pack4bits(3, 3, 3, 3, 3, 3, 3, 3), // d0 - d7
  TBitPackage.Pack4bits(3, 3, 3, 3, 3, 3, 3, 3), // d8 - df
  TBitPackage.Pack4bits(3, 3, 3, 3, 3, 3, 3, 3), // e0 - e7
  TBitPackage.Pack4bits(3, 3, 3, 3, 3, 3, 3, 3), // e8 - ef
  TBitPackage.Pack4bits(3, 3, 3, 3, 3, 3, 3, 3), // f0 - f7
  TBitPackage.Pack4bits(3, 3, 3, 3, 3, 3, 3, 0) // f8 - ff
    ];
end;

function TEUCTWSMModel.EUCTW_st: TArray<Integer>;
begin
  Result := [TBitPackage.Pack4bits(ERROR, ERROR, START, 3, 3, 3, 4, ERROR),
  // 00-07
  TBitPackage.Pack4bits(ERROR, ERROR, ERROR, ERROR, ERROR, ERROR, ITSME, ITSME),
  // 08-0f
  TBitPackage.Pack4bits(ITSME, ITSME, ITSME, ITSME, ITSME, ERROR, START, ERROR),
  // 10-17
  TBitPackage.Pack4bits(START, START, START, ERROR, ERROR, ERROR, ERROR, ERROR),
  // 18-1f
  TBitPackage.Pack4bits(5, ERROR, ERROR, ERROR, START, ERROR, START, START),
  // 20-27
  TBitPackage.Pack4bits(START, ERROR, START, START, START, START, START, START)
  // 28-2f
    ];
end;

end.
