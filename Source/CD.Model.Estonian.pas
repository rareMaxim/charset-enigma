unit CD.Model.Estonian;

interface

uses
  CD.Model.Sequence;

type
  TEstonianModel = class abstract(TSequenceModel)
  protected
    class function LANG_MODEL: TArray<Byte>;
  public
    constructor Create(charToOrderMap: TArray<Byte>; name: string);
  end;

implementation

{ TEstonianModel }

constructor TEstonianModel.Create(charToOrderMap: TArray<Byte>; name: string);
begin
  inherited Create(charToOrderMap, LANG_MODEL, 33, 0.9972721312183132, True, name);
end;

class function TEstonianModel.LANG_MODEL: TArray<Byte>;
begin
  Result := [{$I ..\Source\Inc\EstonianModel.inc}];
end;

end.

