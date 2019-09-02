unit CD.Model.Irish;

interface

uses
  CD.Model.Sequence;

type
  TIrishModel = class abstract(TSequenceModel)
  protected
    class function LANG_MODEL: TArray<Byte>;
  public
    constructor Create(charToOrderMap: TArray<Byte>; name: string);
  end;

implementation

{ TIrishModel }

constructor TIrishModel.Create(charToOrderMap: TArray<Byte>; name: string);
begin
  inherited Create(charToOrderMap, LANG_MODEL, 31, 0.9974076651249096, true, name);
end;

class function TIrishModel.LANG_MODEL: TArray<Byte>;
begin
  Result := [{$I ..\Source\Inc\IrishModel.inc}];
end;

end.

