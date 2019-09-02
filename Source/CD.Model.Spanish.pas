unit CD.Model.Spanish;

interface

uses
  CD.Model.Sequence;

type
  TSpanishModel = class abstract(TSequenceModel)
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

{ TSpanishModel }

constructor TSpanishModel.Create(charToOrderMap: TArray<Byte>; name: string);
begin
  inherited Create(charToOrderMap, LANG_MODEL, 33, 0.9970385677528184,
    true, name);
end;

class function TSpanishModel.LANG_MODEL: TArray<Byte>;
begin
  Result := [{$I ..\Source\Inc\SpanishModel.inc}];
end;

end.
