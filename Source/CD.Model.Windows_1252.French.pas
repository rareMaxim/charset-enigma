unit CD.Model.Windows_1252.French;

interface

uses
  CD.Model.French;

type
  TWindows_1252_FrenchModel = class(TFrenchModel)
  private
    class function CHAR_TO_ORDER_MAP: TArray<Byte>; static;
  public
    constructor Create();
  end;

implementation

uses
  CD.Prober.SBCSGroup;

{ TWindows_1252_FrenchModel }

class function TWindows_1252_FrenchModel.CHAR_TO_ORDER_MAP: TArray<Byte>;
begin
  Result := [{$I ..\Source\Inc\Windows_1252_FrenchModel.inc}];
end;

constructor TWindows_1252_FrenchModel.Create;
begin
  inherited Create(CHAR_TO_ORDER_MAP, 'WINDOWS-1252');
end;

initialization
  TSBCSGroupProber.RegisterModel(
    function(): ISequenceModel
    begin
      Result := TWindows_1252_FrenchModel.Create();
    end);

end.

