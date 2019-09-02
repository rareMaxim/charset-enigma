unit CD.Model.SM.UCS2LE;

interface

uses
  CD.Model.StateMachine;

type
  {TODO -oOwner -cGeneral :  то хоз€ин этой херни?}
  TUCS2LE_SMModel = class(TSMModel)
    function UCS2LE_cls: TArray<Integer>;
    function UCS2LE_st: TArray<Integer>;
    function UCS2LECharLenTable: TArray<Integer>;
    constructor Create;
  end;

implementation

uses
  CD.Core.BitPackage;

{ TUCS2LE_SMModel }

constructor TUCS2LE_SMModel.Create;
begin
  inherited Create( //
    TBitPackage.Create(TBitPackage.INDEX_SHIFT_4BITS,   //
    TBitPackage.SHIFT_MASK_4BITS,       //
    TBitPackage.BIT_SHIFT_4BITS,     //
    TBitPackage.UNIT_MASK_4BITS, UCS2LE_cls),     //
    6,                                           //
    TBitPackage.Create(TBitPackage.INDEX_SHIFT_4BITS,  //
    TBitPackage.SHIFT_MASK_4BITS,                //
    TBitPackage.BIT_SHIFT_4BITS,                //
    TBitPackage.UNIT_MASK_4BITS, UCS2LE_st),     //
    UCS2LECharLenTable, 'UTF-16LE');
end;

function TUCS2LE_SMModel.UCS2LECharLenTable: TArray<Integer>;
begin
  Result := [2, 2, 2, 2, 2, 2];
end;

function TUCS2LE_SMModel.UCS2LE_cls: TArray<Integer>;
begin
  Result := [ //
    TBitPackage.Pack4bits(0, 0, 0, 0, 0, 0, 0, 0),  // 00 - 07
    TBitPackage.Pack4bits(0, 0, 1, 0, 0, 2, 0, 0),  // 08 - 0f
    TBitPackage.Pack4bits(0, 0, 0, 0, 0, 0, 0, 0),  // 10 - 17
    TBitPackage.Pack4bits(0, 0, 0, 3, 0, 0, 0, 0),  // 18 - 1f
    TBitPackage.Pack4bits(0, 0, 0, 0, 0, 0, 0, 0),  // 20 - 27
    TBitPackage.Pack4bits(0, 3, 3, 3, 3, 3, 0, 0),  // 28 - 2f
    TBitPackage.Pack4bits(0, 0, 0, 0, 0, 0, 0, 0),  // 30 - 37
    TBitPackage.Pack4bits(0, 0, 0, 0, 0, 0, 0, 0),  // 38 - 3f
    TBitPackage.Pack4bits(0, 0, 0, 0, 0, 0, 0, 0),  // 40 - 47
    TBitPackage.Pack4bits(0, 0, 0, 0, 0, 0, 0, 0),  // 48 - 4f
    TBitPackage.Pack4bits(0, 0, 0, 0, 0, 0, 0, 0),  // 50 - 57
    TBitPackage.Pack4bits(0, 0, 0, 0, 0, 0, 0, 0),  // 58 - 5f
    TBitPackage.Pack4bits(0, 0, 0, 0, 0, 0, 0, 0),  // 60 - 67
    TBitPackage.Pack4bits(0, 0, 0, 0, 0, 0, 0, 0),  // 68 - 6f
    TBitPackage.Pack4bits(0, 0, 0, 0, 0, 0, 0, 0),  // 70 - 77
    TBitPackage.Pack4bits(0, 0, 0, 0, 0, 0, 0, 0),  // 78 - 7f
    TBitPackage.Pack4bits(0, 0, 0, 0, 0, 0, 0, 0),  // 80 - 87
    TBitPackage.Pack4bits(0, 0, 0, 0, 0, 0, 0, 0),  // 88 - 8f
    TBitPackage.Pack4bits(0, 0, 0, 0, 0, 0, 0, 0),  // 90 - 97
    TBitPackage.Pack4bits(0, 0, 0, 0, 0, 0, 0, 0),  // 98 - 9f
    TBitPackage.Pack4bits(0, 0, 0, 0, 0, 0, 0, 0),  // a0 - a7
    TBitPackage.Pack4bits(0, 0, 0, 0, 0, 0, 0, 0),  // a8 - af
    TBitPackage.Pack4bits(0, 0, 0, 0, 0, 0, 0, 0),  // b0 - b7
    TBitPackage.Pack4bits(0, 0, 0, 0, 0, 0, 0, 0),  // b8 - bf
    TBitPackage.Pack4bits(0, 0, 0, 0, 0, 0, 0, 0),  // c0 - c7
    TBitPackage.Pack4bits(0, 0, 0, 0, 0, 0, 0, 0),  // c8 - cf
    TBitPackage.Pack4bits(0, 0, 0, 0, 0, 0, 0, 0),  // d0 - d7
    TBitPackage.Pack4bits(0, 0, 0, 0, 0, 0, 0, 0),  // d8 - df
    TBitPackage.Pack4bits(0, 0, 0, 0, 0, 0, 0, 0),  // e0 - e7
    TBitPackage.Pack4bits(0, 0, 0, 0, 0, 0, 0, 0),  // e8 - ef
    TBitPackage.Pack4bits(0, 0, 0, 0, 0, 0, 0, 0),  // f0 - f7
    TBitPackage.Pack4bits(0, 0, 0, 0, 0, 0, 4, 5)   // f8 - ff
    ];
end;

function TUCS2LE_SMModel.UCS2LE_st: TArray<Integer>;
begin
  Result := [ //
    TBitPackage.Pack4bits(6, 6, 7, 6, 4, 3, ERROR, ERROR), //00-07
    TBitPackage.Pack4bits(ERROR, ERROR, ERROR, ERROR, ITSME, ITSME, ITSME, ITSME), //08-0f
    TBitPackage.Pack4bits(ITSME, ITSME, 5, 5, 5, ERROR, ITSME, ERROR), //10-17
    TBitPackage.Pack4bits(5, 5, 5, ERROR, 5, ERROR, 6, 6), //18-1f
    TBitPackage.Pack4bits(7, 6, 8, 8, 5, 5, 5, ERROR), //20-27
    TBitPackage.Pack4bits(5, 5, 5, ERROR, ERROR, ERROR, 5, 5), //28-2f
    TBitPackage.Pack4bits(5, 5, 5, ERROR, 5, ERROR, START, START) //30-37
    ];
end;

end.

