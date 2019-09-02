unit CD.Model.Windows_1252.German;

interface

uses
  CD.Model.German;

type
  TWindows_1252_GermanModel = class(TGermanModel)
  private
    class function CHAR_TO_ORDER_MAP: TArray<Byte>; static;
  public
    constructor Create();
  end;

implementation

uses
  CD.Prober.SBCSGroup;

{ TWindows_1252_GermanModel }

class function TWindows_1252_GermanModel.CHAR_TO_ORDER_MAP: TArray<Byte>;
begin
  Result := [{$I ..\Source\Inc\Windows_1252_GermanModel.inc}];
end;

constructor TWindows_1252_GermanModel.Create;
begin
  inherited Create(CHAR_TO_ORDER_MAP, 'WINDOWS-1252');
end;

initialization
  TSBCSGroupProber.RegisterModel(
    function(): ISequenceModel
    begin
      Result := TWindows_1252_GermanModel.Create();
    end);

end.

