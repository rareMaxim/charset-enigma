unit CD.Model.Greek;

interface

uses
  CD.Model.Sequence;

type
  TGreekModel = class(TSequenceModel)
  private
    // Model Table:
    // Total sequences: 1579
    // First 512 sequences: 0.958419074626211
    // Next 512 sequences (512-1024): 0.03968891876305471
    // Rest: 0.0018920066107342773
    // Negative sequences: TODO
    class function LANG_MODEL: TArray<Byte>;
  public
    constructor Create(charToOrderMap: TArray<Byte>; name: string);
  end;

implementation

{ TGreekModel }

constructor TGreekModel.Create(charToOrderMap: TArray<Byte>; name: string);
begin
  inherited Create(charToOrderMap, LANG_MODEL, 46, 0.958419074626211,
    false, name);
end;

class function TGreekModel.LANG_MODEL: TArray<Byte>;
begin
  Result := [{$I ..\Source\Inc\GREEK_LANG_MODEL.inc}];
end;

end.
