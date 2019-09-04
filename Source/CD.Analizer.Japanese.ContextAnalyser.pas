unit CD.Analizer.Japanese.ContextAnalyser;

interface

type
  TJapaneseContextAnalyser = class abstract
  protected
    const
      CATEGORIES_NUM = 6;
      ENOUGH_REL_THRESHOLD = 100;
      MAX_REL_THRESHOLD = 1000;
      MINIMUM_DATA_THRESHOLD = 4;
      DONT_KNOW = -1.0;
  protected
    // category counters, each integer counts sequence in its category
    FRelSample: TArray<Integer>;
    // total sequence received
    FTotalRel: Integer;
    // The order of previous char
    FLastCharOrder: Integer;
    // if last byte in current buffer is not the last byte of a character,
    // we need to know how many byte to skip in next buffer.
    FNeedToSkipCharNum: Integer;
    // If this flag is set to true, detection is done and conclusion has
    // been made
    FDone: Boolean;
    // hiragana frequency category table
    // This is hiragana 2-char sequence table, the number in each cell represents its frequency category
    function jp2CharContext: TArray<TArray<Byte>>;
    function GetOrder(buf: TArray<Byte>; offset: Integer; out charLen: Integer): Integer; overload; virtual; abstract;
    function GetOrder(buf: TArray<Byte>; offset: Integer): Integer; overload; virtual; abstract;
  public
    procedure HandleData(buf: TArray<Byte>; offset, len: Integer);
    procedure HandleOneChar(buf: TArray<Byte>; offset, charLen: Integer);
    procedure Reset();
    function GotEnoughData(): Boolean;
    constructor Create;
    function GetConfidence: Single;
  end;

implementation

{ TJapaneseContextAnalyser }

constructor TJapaneseContextAnalyser.Create;
begin
  SetLength(FRelSample, CATEGORIES_NUM);
  Reset;
end;

function TJapaneseContextAnalyser.GetConfidence: Single;
begin
  // This is just one way to calculate confidence. It works well for me.
  if (FTotalRel > MINIMUM_DATA_THRESHOLD) then
    Result := ((FTotalRel - FRelSample[0])) / FTotalRel
  else
    Result := DONT_KNOW;
end;

function TJapaneseContextAnalyser.GotEnoughData: Boolean;
begin
  Result := FTotalRel > ENOUGH_REL_THRESHOLD;
end;

procedure TJapaneseContextAnalyser.HandleData(buf: TArray<Byte>; offset, len: Integer);
var
  charLen: Integer;
  max: Integer;
  I: Integer;
  order: Integer;
begin
  charLen := 0;
  max := offset + len;
  if (FDone) then
    Exit;
  // The buffer we got is byte oriented, and a character may span
  // more than one buffer. In case the last one or two byte in last
  // buffer is not complete, we record how many byte needed to
  // complete that character and skip these bytes here. We can choose
  // to record those bytes as well and analyse the character once it
  // is complete, but since a character will not make much difference,
  // skipping it will simplify our logic and improve performance.
  I := FNeedToSkipCharNum + offset;
  while I < max do
  begin
    order := GetOrder(buf, I, charLen);
    Inc(I, charLen);
    if (I > max) then
    begin
      FNeedToSkipCharNum := I - max;
      FLastCharOrder := -1;
    end
    else
    begin
      if (order <> -1) and (FLastCharOrder <> -1) then
      begin
        Inc(FTotalRel);
        if (FTotalRel > MAX_REL_THRESHOLD) then
        begin
          FDone := True;
          Break;
        end;
        Inc(FRelSample[jp2CharContext[FLastCharOrder, order]]);
      end;
      FLastCharOrder := order;
    end;
    Inc(I);
  end;
end;

procedure TJapaneseContextAnalyser.HandleOneChar(buf: TArray<Byte>; offset, charLen: Integer);
var
  order: Integer;
begin
  if (FTotalRel > MAX_REL_THRESHOLD) then
    FDone := True;
  if (FDone) then
    Exit;
  // Only 2-bytes characters are of our interest
  if charLen = 2 then
    order := GetOrder(buf, offset)
  else
    order := -1;
  if (order <> -1) and (FLastCharOrder <> -1) then
  begin
    Inc(FTotalRel);
    // count this sequence to its category counter
    Inc(FRelSample[jp2CharContext[FLastCharOrder, order]]);
  end;
  FLastCharOrder := order;
end;

function TJapaneseContextAnalyser.jp2CharContext: TArray<TArray<Byte>>;
begin
  Result := {$I ..\Source\Inc\JapaneseContextAnalyser.inc};
end;

procedure TJapaneseContextAnalyser.Reset;
var
  I: Integer;
begin
  FTotalRel := 0;
  for I := 0 to CATEGORIES_NUM - 1 do
  begin
    FRelSample[I] := 0;
    FNeedToSkipCharNum := 0;
    FLastCharOrder := -1;
    FDone := False;
  end;
end;

end.

