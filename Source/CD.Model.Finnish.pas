unit CD.Model.Finnish;

interface

uses
  CD.Model.Sequence;

type
  TFinnishModel = class abstract(TSequenceModel)
  protected
    class function LANG_MODEL: TArray<Byte>;
  public
    constructor Create(charToOrderMap: TArray<Byte>; name: string);
  end;

implementation

{ TFinnishModel }

constructor TFinnishModel.Create(charToOrderMap: TArray<Byte>; name: string);
begin
  inherited Create(charToOrderMap, LANG_MODEL, 30, 0.9985378147555799, true, name);
end;

class function TFinnishModel.LANG_MODEL: TArray<Byte>;
begin
  Result := [{$I ..\Source\Inc\FinnishModel.inc}];
end;

end.

