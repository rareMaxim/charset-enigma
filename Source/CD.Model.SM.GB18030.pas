unit CD.Model.SM.GB18030;

interface

uses
  CD.Model.StateMachine;

type
  TGB18030SMModel = class(TSMModel)
  private
    function GB18030_cls: TArray<Integer>;
    function GB18030_st: TArray<Integer>;
    // To be accurate, the length of class 6 can be either 2 or 4.
    // But it is not necessary to discriminate between the two since
    // it is used for frequency analysis only, and we are validating
    // each code range there as well. So it is safe to set it to be
    // 2 here.
    function GB18030CharLenTable: TArray<Integer>;
  public
    constructor Create;
  end;

implementation

uses
  CD.Core.BitPackage;

{ TGB18030SMModel }

constructor TGB18030SMModel.Create;
begin
  inherited Create(TBitPackage.Create(TBitPackage.INDEX_SHIFT_4BITS,
    TBitPackage.SHIFT_MASK_4BITS, TBitPackage.BIT_SHIFT_4BITS,
    TBitPackage.UNIT_MASK_4BITS, GB18030_cls), 7,
    TBitPackage.Create(TBitPackage.INDEX_SHIFT_4BITS,
    TBitPackage.SHIFT_MASK_4BITS, TBitPackage.BIT_SHIFT_4BITS,
    TBitPackage.UNIT_MASK_4BITS, GB18030_st), GB18030CharLenTable, 'GB18030');
end;

function TGB18030SMModel.GB18030CharLenTable: TArray<Integer>;
begin
  Result := [0, 1, 1, 1, 1, 1, 2];
end;

function TGB18030SMModel.GB18030_cls: TArray<Integer>;
begin
  Result := [ //
    TBitPackage.Pack4bits(1, 1, 1, 1, 1, 1, 1, 1), // 00 - 07
  TBitPackage.Pack4bits(1, 1, 1, 1, 1, 1, 0, 0), // 08 - 0f
  TBitPackage.Pack4bits(1, 1, 1, 1, 1, 1, 1, 1), // 10 - 17
  TBitPackage.Pack4bits(1, 1, 1, 0, 1, 1, 1, 1), // 18 - 1f
  TBitPackage.Pack4bits(1, 1, 1, 1, 1, 1, 1, 1), // 20 - 27
  TBitPackage.Pack4bits(1, 1, 1, 1, 1, 1, 1, 1), // 28 - 2f
  TBitPackage.Pack4bits(3, 3, 3, 3, 3, 3, 3, 3), // 30 - 37
  TBitPackage.Pack4bits(3, 3, 1, 1, 1, 1, 1, 1), // 38 - 3f
  TBitPackage.Pack4bits(2, 2, 2, 2, 2, 2, 2, 2), // 40 - 47
  TBitPackage.Pack4bits(2, 2, 2, 2, 2, 2, 2, 2), // 48 - 4f
  TBitPackage.Pack4bits(2, 2, 2, 2, 2, 2, 2, 2), // 50 - 57
  TBitPackage.Pack4bits(2, 2, 2, 2, 2, 2, 2, 2), // 58 - 5f
  TBitPackage.Pack4bits(2, 2, 2, 2, 2, 2, 2, 2), // 60 - 67
  TBitPackage.Pack4bits(2, 2, 2, 2, 2, 2, 2, 2), // 68 - 6f
  TBitPackage.Pack4bits(2, 2, 2, 2, 2, 2, 2, 2), // 70 - 77
  TBitPackage.Pack4bits(2, 2, 2, 2, 2, 2, 2, 4), // 78 - 7f
  TBitPackage.Pack4bits(5, 6, 6, 6, 6, 6, 6, 6), // 80 - 87
  TBitPackage.Pack4bits(6, 6, 6, 6, 6, 6, 6, 6), // 88 - 8f
  TBitPackage.Pack4bits(6, 6, 6, 6, 6, 6, 6, 6), // 90 - 97
  TBitPackage.Pack4bits(6, 6, 6, 6, 6, 6, 6, 6), // 98 - 9f
  TBitPackage.Pack4bits(6, 6, 6, 6, 6, 6, 6, 6), // a0 - a7
  TBitPackage.Pack4bits(6, 6, 6, 6, 6, 6, 6, 6), // a8 - af
  TBitPackage.Pack4bits(6, 6, 6, 6, 6, 6, 6, 6), // b0 - b7
  TBitPackage.Pack4bits(6, 6, 6, 6, 6, 6, 6, 6), // b8 - bf
  TBitPackage.Pack4bits(6, 6, 6, 6, 6, 6, 6, 6), // c0 - c7
  TBitPackage.Pack4bits(6, 6, 6, 6, 6, 6, 6, 6), // c8 - cf
  TBitPackage.Pack4bits(6, 6, 6, 6, 6, 6, 6, 6), // d0 - d7
  TBitPackage.Pack4bits(6, 6, 6, 6, 6, 6, 6, 6), // d8 - df
  TBitPackage.Pack4bits(6, 6, 6, 6, 6, 6, 6, 6), // e0 - e7
  TBitPackage.Pack4bits(6, 6, 6, 6, 6, 6, 6, 6), // e8 - ef
  TBitPackage.Pack4bits(6, 6, 6, 6, 6, 6, 6, 6), // f0 - f7
  TBitPackage.Pack4bits(6, 6, 6, 6, 6, 6, 6, 0) // f8 - ff
    ];
end;

function TGB18030SMModel.GB18030_st: TArray<Integer>;
begin
  Result := [ //
    TBitPackage.Pack4bits(ERROR, START, START, START, START, START, 3, ERROR),
  // 00-07
  TBitPackage.Pack4bits(ERROR, ERROR, ERROR, ERROR, ERROR, ERROR, ITSME, ITSME),
  // 08-0f
  TBitPackage.Pack4bits(ITSME, ITSME, ITSME, ITSME, ITSME, ERROR, ERROR, START),
  // 10-17
  TBitPackage.Pack4bits(4, ERROR, START, START, ERROR, ERROR, ERROR, ERROR),
  // 18-1f
  TBitPackage.Pack4bits(ERROR, ERROR, 5, ERROR, ERROR, ERROR, ITSME, ERROR),
  // 20-27
  TBitPackage.Pack4bits(ERROR, ERROR, START, START, START, START, START, START)
  // 28-2f
    ];
end;

end.
