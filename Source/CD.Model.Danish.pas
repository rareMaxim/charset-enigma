unit CD.Model.Danish;

interface

uses
  CD.Model.Sequence;

type
  TDanishModel = class abstract(TSequenceModel)
  private
    // Model Table:
    // Total sequences: 964
    // First 512 sequences: 0.9968082796759031
    // Next 512 sequences (512-1024): 0.0031917203240968304
    // Rest: 3.903127820947816e-17
    // Negative sequences: TODO
    class function LANG_MODEL: TArray<Byte>; static;
  public
    constructor Create(charToOrderMap: TArray<Byte>; name: string);
  end;

implementation

{ TDanishModel }

constructor TDanishModel.Create(charToOrderMap: TArray<Byte>; name: string);
begin
  inherited Create(charToOrderMap, LANG_MODEL, 30, 0.9968082796759031,
    true, name);
end;

class function TDanishModel.LANG_MODEL: TArray<Byte>;
begin
  Result := [{$I ..\Source\Inc\DanishModel.inc}];
end;

end.
