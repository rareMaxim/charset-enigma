unit CD.Model.Swedish;

interface

uses
  CD.Model.Sequence;

type
  TSwedishModel = class abstract(TSequenceModel)
  protected
    class function LANG_MODEL: TArray<Byte>;
  public
    constructor Create(charToOrderMap: TArray<Byte>; name: string);
  end;

implementation

{ TSwedishModel }

constructor TSwedishModel.Create(charToOrderMap: TArray<Byte>; name: string);
begin
  inherited Create(charToOrderMap, LANG_MODEL, 31, 0.997323508584682, true, name);
end;

class function TSwedishModel.LANG_MODEL: TArray<Byte>;
begin
  Result := [{$I ..\Source\Inc\SwedishModel.inc}];
end;

end.

