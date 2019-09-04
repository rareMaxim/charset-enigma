unit CD.Analizer.Japanese.EUCJPContext;

interface

uses
  CD.Analizer.Japanese.ContextAnalyser;

type
  TEUCJPContextAnalyser = class(TJapaneseContextAnalyser)
  private
    const
      HIRAGANA_FIRST_BYTE = $A4;
  protected
    function GetOrder(buf: TArray<Byte>; offset: Integer; out charLen: Integer): Integer; overload; override;
    function GetOrder(buf: System.TArray<System.Byte>; offset: Integer): Integer; overload; override;
  end;

implementation

{ TEUCJPContextAnalyser }
function TEUCJPContextAnalyser.GetOrder(buf: TArray<Byte>; offset: Integer; out charLen: Integer): Integer;
var
  high: Byte;
  low: Byte;
begin
  high := buf[offset];
  // find out current char's byte length
  if (high = $8E) or (high >= $A1) and (high <= $FE) then
    charLen := 2
  else if (high = $BF) then
    charLen := 3
  else
    charLen := 1;
  // return its order if it is hiragana
  if (high = HIRAGANA_FIRST_BYTE) then
  begin
    low := buf[offset + 1];
    if (low >= $A1) and (low <= $F3) then
      Exit(low - $A1);
  end;
  Exit(-1);
end;

function TEUCJPContextAnalyser.GetOrder(buf: System.TArray<System.Byte>; offset: Integer): Integer;
var
  low: Integer;
begin
  // We are only interested in Hiragana
  if (buf[offset] = HIRAGANA_FIRST_BYTE) then
  begin
    low := buf[offset + 1];
    if (low >= $A1) and (low <= $F3) then
      Exit(low - $A1);
  end;
  Exit(-1);
end;

end.

