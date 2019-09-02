unit CD.Model.SM.EUCJP;

interface

uses
  CD.Model.StateMachine;

type
  TEUCJPSMModel = class(TSMModel)
  private
    function EUCJP_cls: TArray<Integer>;
    function EUCJP_st: TArray<Integer>;
    function EUCJPCharLenTable: TArray<Integer>;
  public
    constructor Create;
  end;

implementation

uses
  CD.Core.BitPackage;

{ TEUCJPSMModel }

constructor TEUCJPSMModel.Create;
begin
  inherited Create(TBitPackage.Create(TBitPackage.INDEX_SHIFT_4BITS,
    TBitPackage.SHIFT_MASK_4BITS, TBitPackage.BIT_SHIFT_4BITS,
    TBitPackage.UNIT_MASK_4BITS, EUCJP_cls), 6,
    TBitPackage.Create(TBitPackage.INDEX_SHIFT_4BITS,
    TBitPackage.SHIFT_MASK_4BITS, TBitPackage.BIT_SHIFT_4BITS,
    TBitPackage.UNIT_MASK_4BITS, EUCJP_st), EUCJPCharLenTable, 'EUC-JP')
end;

function TEUCJPSMModel.EUCJPCharLenTable: TArray<Integer>;
begin
  Result := [2, 2, 2, 3, 1, 0];
end;

function TEUCJPSMModel.EUCJP_cls: TArray<Integer>;
begin
  Result := [
  // TBitPacket.Pack4bits(5,4,4,4,4,4,4,4),  // 00 - 07
    TBitPackage.Pack4bits(4, 4, 4, 4, 4, 4, 4, 4), // 00 - 07
  TBitPackage.Pack4bits(4, 4, 4, 4, 4, 4, 5, 5), // 08 - 0f
  TBitPackage.Pack4bits(4, 4, 4, 4, 4, 4, 4, 4), // 10 - 17
  TBitPackage.Pack4bits(4, 4, 4, 5, 4, 4, 4, 4), // 18 - 1f
  TBitPackage.Pack4bits(4, 4, 4, 4, 4, 4, 4, 4), // 20 - 27
  TBitPackage.Pack4bits(4, 4, 4, 4, 4, 4, 4, 4), // 28 - 2f
  TBitPackage.Pack4bits(4, 4, 4, 4, 4, 4, 4, 4), // 30 - 37
  TBitPackage.Pack4bits(4, 4, 4, 4, 4, 4, 4, 4), // 38 - 3f
  TBitPackage.Pack4bits(4, 4, 4, 4, 4, 4, 4, 4), // 40 - 47
  TBitPackage.Pack4bits(4, 4, 4, 4, 4, 4, 4, 4), // 48 - 4f
  TBitPackage.Pack4bits(4, 4, 4, 4, 4, 4, 4, 4), // 50 - 57
  TBitPackage.Pack4bits(4, 4, 4, 4, 4, 4, 4, 4), // 58 - 5f
  TBitPackage.Pack4bits(4, 4, 4, 4, 4, 4, 4, 4), // 60 - 67
  TBitPackage.Pack4bits(4, 4, 4, 4, 4, 4, 4, 4), // 68 - 6f
  TBitPackage.Pack4bits(4, 4, 4, 4, 4, 4, 4, 4), // 70 - 77
  TBitPackage.Pack4bits(4, 4, 4, 4, 4, 4, 4, 4), // 78 - 7f
  TBitPackage.Pack4bits(5, 5, 5, 5, 5, 5, 5, 5), // 80 - 87
  TBitPackage.Pack4bits(5, 5, 5, 5, 5, 5, 1, 3), // 88 - 8f
  TBitPackage.Pack4bits(5, 5, 5, 5, 5, 5, 5, 5), // 90 - 97
  TBitPackage.Pack4bits(5, 5, 5, 5, 5, 5, 5, 5), // 98 - 9f
  TBitPackage.Pack4bits(5, 2, 2, 2, 2, 2, 2, 2), // a0 - a7
  TBitPackage.Pack4bits(2, 2, 2, 2, 2, 2, 2, 2), // a8 - af
  TBitPackage.Pack4bits(2, 2, 2, 2, 2, 2, 2, 2), // b0 - b7
  TBitPackage.Pack4bits(2, 2, 2, 2, 2, 2, 2, 2), // b8 - bf
  TBitPackage.Pack4bits(2, 2, 2, 2, 2, 2, 2, 2), // c0 - c7
  TBitPackage.Pack4bits(2, 2, 2, 2, 2, 2, 2, 2), // c8 - cf
  TBitPackage.Pack4bits(2, 2, 2, 2, 2, 2, 2, 2), // d0 - d7
  TBitPackage.Pack4bits(2, 2, 2, 2, 2, 2, 2, 2), // d8 - df
  TBitPackage.Pack4bits(0, 0, 0, 0, 0, 0, 0, 0), // e0 - e7
  TBitPackage.Pack4bits(0, 0, 0, 0, 0, 0, 0, 0), // e8 - ef
  TBitPackage.Pack4bits(0, 0, 0, 0, 0, 0, 0, 0), // f0 - f7
  TBitPackage.Pack4bits(0, 0, 0, 0, 0, 0, 0, 5) // f8 - ff
    ];
end;

function TEUCJPSMModel.EUCJP_st: TArray<Integer>;
begin
  Result := [TBitPackage.Pack4bits(3, 4, 3, 5, START, ERROR, ERROR, ERROR),
  // 00-07
  TBitPackage.Pack4bits(ERROR, ERROR, ERROR, ERROR, ITSME, ITSME, ITSME, ITSME),
  // 08-0f
  TBitPackage.Pack4bits(ITSME, ITSME, START, ERROR, START, ERROR, ERROR, ERROR),
  // 10-17
  TBitPackage.Pack4bits(ERROR, ERROR, START, ERROR, ERROR, ERROR, 3, ERROR),
  // 18-1f
  TBitPackage.Pack4bits(3, ERROR, ERROR, ERROR, START, START, START, START)
  // 20-27
    ];
end;

end.
