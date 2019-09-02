unit CD.Prober.Charset;

interface

uses
  CD.ProbingState,
  System.SysUtils,
  CD.Model.Sequence;

type
  ICharsetProber = interface
    ['{0736F35C-4DF8-4C27-9684-659C1C98670E}']
    function HandleData(ABuffer: TArray<Byte>; const AOffset, ALength: Integer): TProbingState;
    procedure Reset();
    function GetCharsetName(): string;
    function GetConfidence(status: TStringBuilder = nil): Single;
    function GetState: TProbingState;
    function DumpStatus(): string;
    function Name: string;
  end;

  TCharsetProber = class abstract(TInterfacedObject, ICharsetProber)
  protected
    const
      SHORTCUT_THRESHOLD = 0.95;
    // ASCII codes
      SPACE = $20;
      CAPITAL_A = $41;
      CAPITAL_Z = $5A;
      SMALL_A = $61;
      SMALL_Z = $7A;
      LESS_THAN = $3C;
      GREATER_THAN = $3E;
  protected
    FState: TProbingState;
    //
    // Helper functions used in the Latin1 and Group probers
    //
    /// <summary>
    ///
    /// </summary>
    /// <returns>filtered buffer</returns>
    function FilterWithoutEnglishLetters(buf: TArray<Byte>; offset, len: Integer): TArray<Byte>;
    function FilterWithEnglishLetters(buf: TArray<Byte>; offset, len: Integer): TArray<Byte>;
  public
    constructor Create; virtual;
    /// <summary>
    /// Feed data to the prober
    /// </summary>
    /// <param name="buf">a buffer</param>
    /// <param name="offset">offset into buffer</param>
    /// <param name="len">number of bytes available into buffer</param>
    /// <returns>
    /// A <see cref="ProbingState"/>
    /// </returns>
    function HandleData(ABuffer: TArray<Byte>; const AOffset, ALength: Integer): TProbingState; virtual; abstract;
    procedure Reset(); virtual; abstract;
    function GetCharsetName(): string; virtual; abstract;
    function GetConfidence(status: TStringBuilder = nil): Single; virtual; abstract;
    function GetState: TProbingState; virtual;
    function DumpStatus(): string; virtual;
    function Name: string;
  end;

implementation

uses
  Helpers.TStream,
  System.Classes;

constructor TCharsetProber.Create;
begin
  FState := TProbingState.Detecting;
end;

{ TCharsetProber }

function TCharsetProber.DumpStatus: string;
begin
  Result := '';
end;

function TCharsetProber.FilterWithEnglishLetters(buf: TArray<Byte>; offset, len: Integer): TArray<Byte>;
var
  ms: TMemoryStream;
  max: Integer;
  prev: Integer;
  cur: Integer;
  b: Byte;
  inTag: Boolean;
begin
  Result := nil;
  ms := TMemoryStream.Create;
  try
    ms.Size := Length(buf);
    inTag := False;
    max := offset + len;
    prev := offset;
    cur := offset;
    while (cur < max) do
    begin
      b := buf[cur];
      if (b = GREATER_THAN) then
        inTag := False
      else if (b = LESS_THAN) then
        inTag := True;
      // it's ascii, but it's not a letter
      if ((b and $80) = 0) and ((b < CAPITAL_A) or ((b > CAPITAL_Z) and (b < SMALL_A)) or (b > SMALL_Z)) then
      begin
        if (cur > prev) and (not inTag) then
        begin
          ms.Write(buf, prev, cur - prev);
          ms.WriteByte(SPACE);
        end;
        prev := cur + 1;
      end;
      Inc(cur);
    end;
    // If the current segment contains more than just a symbol
    // and it is not inside a tag then keep it.
    if (not inTag) and (cur > prev) then
      ms.Write(buf, prev, cur - prev);
    ms.SetSize(ms.Position);
    Result := ms.ToArray();
  finally
    ms.Free;
  end;
end;

function TCharsetProber.FilterWithoutEnglishLetters(buf: TArray<Byte>; offset, len: Integer): TArray<Byte>;
var
  ms: TMemoryStream;
  meetMSB: Boolean;
  max: Integer;
  prev: Integer;
  cur: Integer;
  b: Byte;
begin
  Result := nil;
  ms := TMemoryStream.Create;
  try
    ms.Size := Length(buf);
    meetMSB := False;
    max := offset + len;
    prev := offset;
    cur := offset;
    while (cur < max) do
    begin
      b := buf[cur];
      if ((b and $80) <> 0) then
      begin
        meetMSB := True;
      end
      else if (b < CAPITAL_A) or ((b > CAPITAL_Z) and (b < SMALL_A)) or (b > SMALL_Z) then
      begin
        if meetMSB and (cur > prev) then
        begin
          ms.Write(buf, prev, cur - prev);
          ms.WriteByte(SPACE);
          meetMSB := False;
        end;
        prev := cur + 1;
      end;
      Inc(cur);
    end;
    if meetMSB and (cur > prev) then
      ms.Write(buf, prev, cur - prev);
    ms.SetSize(ms.Position);
    Result := ms.ToArray();
  finally
    ms.Free;
  end;
end;

function TCharsetProber.GetState: TProbingState;
begin
  Result := FState;
end;

function TCharsetProber.Name: string;
begin
  Result := ClassName;
end;

end.

