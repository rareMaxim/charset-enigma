unit CD.Model.Hebrew;

interface

uses
  CD.Model.Sequence;

type
  THebrewModel = class(TSequenceModel)
  protected
    function HEBREW_LANG_MODEL: TArray<Byte>;
  public
    constructor Create(charToOrderMap: TArray<Byte>; name: string);
  end;

implementation

{ THebrewModel }

constructor THebrewModel.Create(charToOrderMap: TArray<Byte>; name: string);
begin
  inherited Create(charToOrderMap, HEBREW_LANG_MODEL, 64, 0.984004,
    false, name);
end;

function THebrewModel.HEBREW_LANG_MODEL: TArray<Byte>;
begin
  Result := [{$I ..\Source\inc\HEBREW_LANG_MODEL.inc}];
end;

end.
