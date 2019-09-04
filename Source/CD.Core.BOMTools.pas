unit CD.Core.BOMTools;

interface

uses
  System.Generics.Collections;

type
  TBomInfo = class
    Name: string;
    BomMarker: TArray<Byte>;
  public
    constructor Create(const AName: string; ABomMarker: TArray<Byte>);
  end;

  TBomTools = class
    class constructor Create;
    class destructor Destroy;
  private
    class var
      FBomSets: TObjectList<TBomInfo>;
      FIsSorted: Boolean;
  protected
    class function StartsWith(AData, ABomMarker: TArray<Byte>): boolean;
    class procedure SelfRegisterBoms;
  public
    class procedure Add(const AName: string; ABomMarker: TArray<Byte>); overload;
    class procedure Add(const AName: string; ABomMarkers: TArray<TArray<Byte>>); overload;
    class procedure DoSortBoms;
    class function FindCharset(AData: TArray<Byte>; const ALength: Integer): string;
  end;

implementation

uses
  System.Generics.Defaults,
  System.SysUtils;

class procedure TBomTools.Add(const AName: string; ABomMarkers: TArray<TArray<Byte>>);
var
  ABomMarker: TArray<Byte>;
begin
  for ABomMarker in ABomMarkers do
  begin
    Add(AName, ABomMarker);
  end;
end;

class constructor TBomTools.Create;
begin
  TBomTools.FIsSorted := False;
  FBomSets := TObjectList<TBomInfo>.Create;
  SelfRegisterBoms;
end;

class destructor TBomTools.Destroy;
begin
  FBomSets.Free;
end;

class procedure TBomTools.Add(const AName: string; ABomMarker: TArray<Byte>);
begin
  FBomSets.Add(TBomInfo.Create(AName, ABomMarker));
  FIsSorted := False;
end;

class procedure TBomTools.DoSortBoms;
begin
  FBomSets.Sort(TComparer<TBomInfo>.Construct(
    function(const L, R: TBomInfo): integer
    var
      LLengthL, LLengthR: Integer;
    begin
      LLengthL := Length(L.BomMarker);
      LLengthR := Length(R.BomMarker);

      if LLengthL = LLengthR then
        Result := 0
      else if LLengthL > LLengthR then
        Result := -1
      else
        Result := 1;
    end));
  FIsSorted := True;
end;

class function TBomTools.FindCharset(AData: TArray<Byte>; const ALength: Integer): string;
var
  ABomInfo: TBomInfo;
begin
  Result := '';
  if ALength > 3 then
  begin
    if FIsSorted = False then
      DoSortBoms;
    for ABomInfo in FBomSets do
      if StartsWith(AData, ABomInfo.BomMarker) then
        Exit(ABomInfo.Name);
  end;
end;

class procedure TBomTools.SelfRegisterBoms;
begin
  Add('UTF-8', [$EF, $BB, $BF]);
  Add('UTF-16BE', [$FE, $FF]);
  Add('UTF-16LE', [$FF, $FE]);
  Add('UTF-32BE', [$00, $00, $FE, $FF]);
  Add('UTF-32LE', [$FF, $FE, $00, $00]);
  Add('UTF-7', [[$2B, $2F, $76, $38], [$2B, $2F, $76, $39], [$2B, $2F, $76, $2B], [$2B, $2F, $76, $2F]]);
  Add('UTF-1', [$F7, $64, $4C]);
  Add('UTF-EBCDIC', [$DD, $73, $66, $73]);
  Add('SCSU', [$0E, $FE, $FF]);
  Add('BOCU-1', [$FB, $EE, $28]);
  Add('GB-18030', [$84, $31, $95, $33]);
end;

class function TBomTools.StartsWith(AData, ABomMarker: TArray<Byte>): boolean;
var
  I: Integer;
begin
  if Length(ABomMarker) > Length(AData) then
    Exit(false);
  Result := True;
  for I := Low(ABomMarker) to High(ABomMarker) do
    if ABomMarker[I] <> AData[I] then
    begin
      Result := False;
      Break;
    end;
end;

constructor TBomInfo.Create(const AName: string; ABomMarker: TArray<Byte>);
begin
  Name := AName;
  BomMarker := ABomMarker;
end;

end.

