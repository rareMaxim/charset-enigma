unit CD.Prober.Latin1;

interface

uses
  CD.Prober.Charset,
  CD.ProbingState,
  System.SysUtils;

type
  TLatin1Prober = class(TCharsetProber)
  private
    const
      FREQ_CAT_NUM = 4;
      UDF = 0; // undefined
      OTH = 1; // other
      ASC = 2; // ascii capital letter
      ASS = 3; // ascii small letter
      ACV = 4; // accent capital vowel
      ACO = 5; // accent capital other
      ASV = 6; // accent small vowel
      ASO = 7; // accent small other
      CLASS_NUM = 8; // total classes
  private
    FLastCharClass: Byte;
    FFreqCounter: TArray<Integer>;
    function Latin1_CharToClass: TArray<Byte>;
    function Latin1ClassModel: TArray<Byte>;
  public
    constructor Create; override;
    function GetCharsetName: string; override;
    procedure Reset; override;
    function HandleData(ABuffer: TArray<Byte>; const AOffset, ALength: Integer): TProbingState; override;
    function GetConfidence(status: TStringBuilder = nil): Single; override;
    function DumpStatus: string; override;
  end;

implementation


{ TLatin1Prober }

constructor TLatin1Prober.Create;
begin
  inherited;
  SetLength(FFreqCounter, FREQ_CAT_NUM);
  Reset;
end;

function TLatin1Prober.DumpStatus: string;
begin
  Result := Format(' Latin1Prober: %f [%s]', [GetConfidence(), GetCharsetName()]);
end;

function TLatin1Prober.GetCharsetName: string;
begin
  Result := 'WINDOWS-1252';
end;

function TLatin1Prober.GetConfidence(status: TStringBuilder): Single;
var
  confidence: Single;
  total: Integer;
  i: Integer;
begin
  if (FState = TProbingState.NotMe) then
    Exit(0.01);
  // confidence := 0.0;
  total := 0;
  for i := 0 to FREQ_CAT_NUM - 1 do
  begin
    Inc(total, FFreqCounter[i]);
  end;
  if (total <= 0) then
  begin
    confidence := 0.0;
  end
  else
  begin
    confidence := FFreqCounter[3] * 1.0 / total;
    confidence := confidence - FFreqCounter[1] * 20.0 / total;
  end;
  // lower the confidence of latin1 so that other more accurate detector
  // can take priority.
  if confidence < 0 then
    Result := 0
  else
    Result := confidence * 0.5;
end;

function TLatin1Prober.HandleData(ABuffer: TArray<Byte>; const AOffset, ALength: Integer): TProbingState;
var
  newbuf: TArray<Byte>;
  charClass, freq: Byte;
  i: Integer;
begin
  newbuf := FilterWithEnglishLetters(ABuffer, AOffset, ALength);
  for i := Low(newbuf) to High(newbuf) do
  begin
    charClass := Latin1_CharToClass[newbuf[i]];
    freq := Latin1ClassModel[FLastCharClass * CLASS_NUM + charClass];
    if (freq = 0) then
    begin
      FState := TProbingState.NotMe;
      Break;
    end;
    Inc(FFreqCounter[freq]);
    FLastCharClass := charClass;
  end;
  Result := FState;
end;

function TLatin1Prober.Latin1ClassModel: TArray<Byte>;
begin
  Result := [{$I ..\Source\inc\Latin1ClassModel.inc}];
end;

function TLatin1Prober.Latin1_CharToClass: TArray<Byte>;
begin
  Result := [{$I ..\Source\inc\Latin1_CharToClass.inc}];
end;

procedure TLatin1Prober.Reset;
var
  i: Integer;
begin
  inherited;
  FState := TProbingState.Detecting;
  FLastCharClass := OTH;
  for i := 0 to FREQ_CAT_NUM - 1 do
    FFreqCounter[i] := 0;
end;

end.

