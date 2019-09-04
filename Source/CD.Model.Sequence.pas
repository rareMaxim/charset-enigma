unit CD.Model.Sequence;

interface

type
  ISequenceModel = interface
    ['{95AAF9FE-11DC-4DE9-A107-2E348DC15AEF}']
    function GetCharsetName: string;
    function GetFreqCharCount: Integer;
    function GetKeepEnglishLetter: Boolean;
    function GetTypicalPositiveRatio: Single;
    //
    function GetOrder(b: Byte): Byte;
    function GetPrecedence(Pos: Integer): Byte;
    property typicalPositiveRatio: Single read GetTypicalPositiveRatio;
    property keepEnglishLetter: Boolean read GetKeepEnglishLetter;
    property charsetName: string read GetCharsetName;
    property freqCharCount: Integer read GetFreqCharCount;
  end;

  TSequenceModel = class abstract(TInterfacedObject, ISequenceModel)
  public
  // Codepoints
    const
    // Illegal codepoints
    ILL = 255;
    // Control character
    CTR = 254;
    // Symbols and punctuation that does not belong to words
    SYM = 253;
    // Return/Line feeds
    RET = 252;
    // Numbers 0-9
    NUM = 251;
  private
    FCharsetName: string;

    // [256] table use to find a char's order
    FCharToOrderMap: TArray<Byte>;
    FFreqCharCount: Integer;
    function GetCharsetName: string;
    function GetFreqCharCount: Integer;
    function GetKeepEnglishLetter: Boolean;
    function GetTypicalPositiveRatio: Single;
  protected
    // [SAMPLE_SIZE][SAMPLE_SIZE] table to find a 2-char sequence's
    // frequency
    FPrecedenceMatrix: TArray<Byte>;
    FTypicalPositiveRatio: Single;
    /// <summary>
    /// TODO not used?
    /// </summary>
    FKeepEnglishLetter: Boolean;
  public
    function GetOrder(b: Byte): Byte;
    function GetPrecedence(Pos: Integer): Byte;
    constructor Create(charToOrderMap, precedenceMatrix: TArray<Byte>;
      freqCharCount: Integer; typicalPositiveRatio: Single;
      keepEnglishLetter: Boolean; charsetName: string);
    property typicalPositiveRatio: Single read GetTypicalPositiveRatio;
    property keepEnglishLetter: Boolean read GetKeepEnglishLetter;
    property charsetName: string read GetCharsetName;
    property freqCharCount: Integer read GetFreqCharCount;
  end;

implementation

{ TSequenceModel }

constructor TSequenceModel.Create(charToOrderMap, precedenceMatrix
  : TArray<Byte>; freqCharCount: Integer; typicalPositiveRatio: Single;
  keepEnglishLetter: Boolean; charsetName: string);
begin
  Self.FCharToOrderMap := charToOrderMap;
  Self.FPrecedenceMatrix := precedenceMatrix;
  Self.FFreqCharCount := freqCharCount;
  Self.FTypicalPositiveRatio := typicalPositiveRatio;
  Self.FKeepEnglishLetter := keepEnglishLetter;
  Self.FCharsetName := charsetName;
end;

function TSequenceModel.GetCharsetName: string;
begin
  Result := FCharsetName;
end;

function TSequenceModel.GetFreqCharCount: Integer;
begin
  Result := FFreqCharCount;
end;

function TSequenceModel.GetKeepEnglishLetter: Boolean;
begin
  Result := FKeepEnglishLetter;
end;

function TSequenceModel.GetOrder(b: Byte): Byte;
begin
  Result := FCharToOrderMap[b];
end;

function TSequenceModel.GetPrecedence(Pos: Integer): Byte;
begin
  Result := FPrecedenceMatrix[Pos];
end;

function TSequenceModel.GetTypicalPositiveRatio: Single;
begin
  Result := FTypicalPositiveRatio;
end;

end.
