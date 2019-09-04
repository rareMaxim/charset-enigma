unit CD.Analizer.Japanese.SJISContext;

interface

uses
  CD.Analizer.Japanese.ContextAnalyser;

type
  TSJISContextAnalyser = class(TJapaneseContextAnalyser)
  private
    const
      HIRAGANA_FIRST_BYTE = $82;
  private
  protected
    function GetOrder(buf: TArray<Byte>; offset: Integer; out charLen: Integer): Integer; overload; override;
    function GetOrder(buf: System.TArray<System.Byte>; offset: Integer): Integer; overload; override;
  end;

implementation

{ TSJISContextAnalyser }

function TSJISContextAnalyser.GetOrder(buf: TArray<Byte>; offset: Integer; out charLen: Integer): Integer;
var
  low: Byte;
begin
  // find out current char's byte length
  if (buf[offset] >= $81) and (buf[offset] <= $9F) or (buf[offset] >= $E0) and (buf[offset] <= $FC) then
    charLen := 2
  else
    charLen := 1;
  // return its order if it is hiragana
  { TODO -oOwner -cGeneral : Дубляж в GetOrder? }
  if (buf[offset] = HIRAGANA_FIRST_BYTE) then
  begin
    low := buf[offset + 1];
    if (low >= $9F) and (low <= $F1) then
      Exit(low - $9F);
  end;
  Exit(-1);
end;

function TSJISContextAnalyser.GetOrder(buf: System.TArray<System.Byte>; offset: Integer): Integer;
var
  low: Byte;
begin
  // We are only interested in Hiragana
  if (buf[offset] = HIRAGANA_FIRST_BYTE) then
  begin
    low := buf[offset + 1];
    if (low >= $9F) and (low <= $F1) then
      Exit(low - $9F);
  end;
  Exit(-1);
end;

end.

