unit CD.Model.Russian;

interface

uses
  CD.Model.Sequence;

type
  TRussianModel = class abstract(TSequenceModel)
  protected
    class function LANG_MODEL: TArray<Byte>;
  public
    constructor Create(charToOrderMap: TArray<Byte>; name: string);
  end;

implementation

{ TRussianModel }

constructor TRussianModel.Create(charToOrderMap: TArray<Byte>; name: string);
begin
  inherited Create(charToOrderMap, LANG_MODEL, 64, 0.976601, false, name);
end;

class function TRussianModel.LANG_MODEL: TArray<Byte>;
begin
  Result := [{$I ..\Source\Inc\RUSSIAN_LANG_MODEL.inc}];
end;

end.
