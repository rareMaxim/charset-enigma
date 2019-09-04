unit CD.Model.Windows_1252.Swedish;

interface

uses
  CD.Model.Swedish;

type
  TWindows_1252_SwedishModel = class(TSwedishModel)
  private
    class function CHAR_TO_ORDER_MAP: TArray<Byte>; static;
  public
    constructor Create();
  end;

implementation

uses
  CD.Prober.SBCSGroup;

{ TWindows_1252_SwedishModel }

class function TWindows_1252_SwedishModel.CHAR_TO_ORDER_MAP: TArray<Byte>;
begin
  Result := [{$I ..\Source\Inc\Windows_1252_SwedishModel.inc}];
end;

constructor TWindows_1252_SwedishModel.Create;
begin
  inherited Create(CHAR_TO_ORDER_MAP, 'WINDOWS-1252');
end;

initialization
  TSBCSGroupProber.RegisterModel(
    function(): ISequenceModel
    begin
      Result := TWindows_1252_SwedishModel.Create();
    end);

end.

