unit CD.Model.French;

interface

uses
  CD.Model.Sequence;

type
  TFrenchModel = class abstract(TSequenceModel)
  private
    // Total sequences: 914
    // First 512 sequences: 0.997057879992383
    // Next 512 sequences (512-1024): 0.002942120007616917
    // Rest: 3.8163916471489756e-17
    // Negative sequences: TODO
    class function LANG_MODEL: TArray<Byte>;
  public
    constructor Create(charToOrderMap: TArray<Byte>; name: string);
  end;

implementation

{ TFrenchModel }

constructor TFrenchModel.Create(charToOrderMap: TArray<Byte>; name: string);
begin
  inherited Create(charToOrderMap, LANG_MODEL, 38, 0.997057879992383,
    true, name);
end;

class function TFrenchModel.LANG_MODEL: TArray<Byte>;
begin
  Result := [{$I ..\Source\Inc\FrenchModel.inc}];
end;

end.
