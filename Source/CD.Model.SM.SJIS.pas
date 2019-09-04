unit CD.Model.SM.SJIS;

interface

uses
  CD.Model.StateMachine;

type
  TSJISSMModel = class(TSMModel)
  private
    function SJIS_cls: TArray<Integer>;
    function SJIS_st: TArray<Integer>;
    function SJISCharLenTable: TArray<Integer>;
  public
    constructor Create;
  end;

implementation

uses
  CD.Core.BitPackage;

{ TSJISSMModel }

constructor TSJISSMModel.Create;
begin
  inherited Create(TBitPackage.Create(TBitPackage.INDEX_SHIFT_4BITS,
    TBitPackage.SHIFT_MASK_4BITS, TBitPackage.BIT_SHIFT_4BITS,
    TBitPackage.UNIT_MASK_4BITS, SJIS_cls), 6,
    TBitPackage.Create(TBitPackage.INDEX_SHIFT_4BITS,
    TBitPackage.SHIFT_MASK_4BITS, TBitPackage.BIT_SHIFT_4BITS,
    TBitPackage.UNIT_MASK_4BITS, SJIS_st), SJISCharLenTable, 'Shift_JIS');
end;

function TSJISSMModel.SJISCharLenTable: TArray<Integer>;
begin
  Result := [0, 1, 1, 2, 0, 0];
end;

function TSJISSMModel.SJIS_cls: TArray<Integer>;
begin
  Result := [
  // BitPacket.Pack4bits(0,1,1,1,1,1,1,1),  // 00 - 07
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
  TBitPackage.Pack4bits(3, 3, 3, 3, 3, 3, 3, 3), // 80 - 87
  TBitPackage.Pack4bits(3, 3, 3, 3, 3, 3, 3, 3), // 88 - 8f
  TBitPackage.Pack4bits(3, 3, 3, 3, 3, 3, 3, 3), // 90 - 97
  TBitPackage.Pack4bits(3, 3, 3, 3, 3, 3, 3, 3), // 98 - 9f
  // 0xa0 is illegal in sjis encoding, but some pages does
  // contain such byte. We need to be more error forgiven.
  TBitPackage.Pack4bits(2, 2, 2, 2, 2, 2, 2, 2), // a0 - a7
  TBitPackage.Pack4bits(2, 2, 2, 2, 2, 2, 2, 2), // a8 - af
  TBitPackage.Pack4bits(2, 2, 2, 2, 2, 2, 2, 2), // b0 - b7
  TBitPackage.Pack4bits(2, 2, 2, 2, 2, 2, 2, 2), // b8 - bf
  TBitPackage.Pack4bits(2, 2, 2, 2, 2, 2, 2, 2), // c0 - c7
  TBitPackage.Pack4bits(2, 2, 2, 2, 2, 2, 2, 2), // c8 - cf
  TBitPackage.Pack4bits(2, 2, 2, 2, 2, 2, 2, 2), // d0 - d7
  TBitPackage.Pack4bits(2, 2, 2, 2, 2, 2, 2, 2), // d8 - df
  TBitPackage.Pack4bits(3, 3, 3, 3, 3, 3, 3, 3), // e0 - e7
  TBitPackage.Pack4bits(3, 3, 3, 3, 3, 4, 4, 4), // e8 - ef
  TBitPackage.Pack4bits(4, 4, 4, 4, 4, 4, 4, 4), // f0 - f7
  TBitPackage.Pack4bits(4, 4, 4, 4, 4, 0, 0, 0) // f8 - ff
    ];
end;

function TSJISSMModel.SJIS_st: TArray<Integer>;
begin
  Result := [ //
    TBitPackage.Pack4bits(ERROR, START, START, 3, ERROR, ERROR, ERROR, ERROR),
  // 00-07
  TBitPackage.Pack4bits(ERROR, ERROR, ERROR, ERROR, ITSME, ITSME, ITSME, ITSME),
  // 08-0f
  TBitPackage.Pack4bits(ITSME, ITSME, ERROR, ERROR, START, START, START, START)
  // 10-17
    ];
end;

end.
