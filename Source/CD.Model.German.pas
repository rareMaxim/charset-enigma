unit CD.Model.German;

interface

uses
  CD.Model.Sequence;

type
  TGermanModel = class abstract(TSequenceModel)
  private
    // Model Table:
    // Total sequences: 1188
    // First 512 sequences: 0.9934041448127945
    // Next 512 sequences (512-1024): 0.006482829516922903
    // Rest: 0.0001130256702826099
    // Negative sequences: TODO
    class function LANG_MODEL: TArray<Byte>; static;
  public
    constructor Create(charToOrderMap: TArray<Byte>; name: string);
  end;

implementation

{ TGermanModel }

constructor TGermanModel.Create(charToOrderMap: TArray<Byte>; name: string);
begin
  inherited Create(charToOrderMap, LANG_MODEL, 31, 0.9934041448127945,
    True, name);
end;

class function TGermanModel.LANG_MODEL: TArray<Byte>;
begin
  Result := [{$I ..\Source\Inc\GermanModel.inc}];
end;

end.
