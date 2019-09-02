unit CD.Model.Italian;

interface

uses
  CD.Model.Sequence;

type
  TItalianModel = class abstract(TSequenceModel)
  protected
    class function LANG_MODEL: TArray<Byte>;
  public
    constructor Create(charToOrderMap: TArray<Byte>; name: string);
  end;

implementation

{ TItalianModel }

constructor TItalianModel.Create(charToOrderMap: TArray<Byte>; name: string);
begin
  inherited Create(charToOrderMap, LANG_MODEL, 34, 0.9989484485502651, true, name);
end;

class function TItalianModel.LANG_MODEL: TArray<Byte>;
begin
  Result := [{$I ..\Source\Inc\ItalianModel.inc}];
end;

end.

