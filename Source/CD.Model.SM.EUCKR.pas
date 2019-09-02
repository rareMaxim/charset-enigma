unit CD.Model.SM.EUCKR;

interface

uses
  CD.Model.StateMachine;

type
  TEUCKRSMModel = class(TSMModel)
  private
    function EUCKR_cls: TArray<Integer>;
    function EUCKR_st: TArray<Integer>;
    function EUCKRCharLenTable: TArray<Integer>;
  public
    constructor Create;
  end;

implementation

uses
  CD.Core.BitPackage;

{ TEUCKRSMModel }

constructor TEUCKRSMModel.Create;
begin
  inherited Create(TBitPackage.Create(TBitPackage.INDEX_SHIFT_4BITS,
    TBitPackage.SHIFT_MASK_4BITS, TBitPackage.BIT_SHIFT_4BITS,
    TBitPackage.UNIT_MASK_4BITS, EUCKR_cls), 4,
    TBitPackage.Create(TBitPackage.INDEX_SHIFT_4BITS,
    TBitPackage.SHIFT_MASK_4BITS, TBitPackage.BIT_SHIFT_4BITS,
    TBitPackage.UNIT_MASK_4BITS, EUCKR_st), EUCKRCharLenTable, 'EUC-KR');
end;

function TEUCKRSMModel.EUCKRCharLenTable: TArray<Integer>;
begin
  Result := [0, 1, 2, 0];
end;

function TEUCKRSMModel.EUCKR_cls: TArray<Integer>;
begin
  Result := [
  // TBitPacket.Pack4bits(0,1,1,1,1,1,1,1),  // 00 - 07
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
  TBitPackage.Pack4bits(0, 0, 0, 0, 0, 0, 0, 0), // 80 - 87
  TBitPackage.Pack4bits(0, 0, 0, 0, 0, 0, 0, 0), // 88 - 8f
  TBitPackage.Pack4bits(0, 0, 0, 0, 0, 0, 0, 0), // 90 - 97
  TBitPackage.Pack4bits(0, 0, 0, 0, 0, 0, 0, 0), // 98 - 9f
  TBitPackage.Pack4bits(0, 2, 2, 2, 2, 2, 2, 2), // a0 - a7
  TBitPackage.Pack4bits(2, 2, 2, 2, 2, 3, 3, 3), // a8 - af
  TBitPackage.Pack4bits(2, 2, 2, 2, 2, 2, 2, 2), // b0 - b7
  TBitPackage.Pack4bits(2, 2, 2, 2, 2, 2, 2, 2), // b8 - bf
  TBitPackage.Pack4bits(2, 2, 2, 2, 2, 2, 2, 2), // c0 - c7
  TBitPackage.Pack4bits(2, 3, 2, 2, 2, 2, 2, 2), // c8 - cf
  TBitPackage.Pack4bits(2, 2, 2, 2, 2, 2, 2, 2), // d0 - d7
  TBitPackage.Pack4bits(2, 2, 2, 2, 2, 2, 2, 2), // d8 - df
  TBitPackage.Pack4bits(2, 2, 2, 2, 2, 2, 2, 2), // e0 - e7
  TBitPackage.Pack4bits(2, 2, 2, 2, 2, 2, 2, 2), // e8 - ef
  TBitPackage.Pack4bits(2, 2, 2, 2, 2, 2, 2, 2), // f0 - f7
  TBitPackage.Pack4bits(2, 2, 2, 2, 2, 2, 2, 0) // f8 - ff
    ];
end;

function TEUCKRSMModel.EUCKR_st: TArray<Integer>;
begin
  Result := [TBitPackage.Pack4bits(ERROR, START, 3, ERROR, ERROR, ERROR, ERROR,
    ERROR), // 00-07
  TBitPackage.Pack4bits(ITSME, ITSME, ITSME, ITSME, ERROR, ERROR, START, START)
  // 08-0f
    ];
end;

end.
