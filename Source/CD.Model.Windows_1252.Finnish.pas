unit CD.Model.Windows_1252.Finnish;

interface

uses
  CD.Model.Finnish;

type
  TWindows_1252_FinnishModel = class(TFinnishModel)
  private
    class function CHAR_TO_ORDER_MAP: TArray<Byte>; static;
  public
    constructor Create();
  end;

implementation

uses
  CD.Prober.SBCSGroup;

{ TWindows_1252_FinnishModel }

class function TWindows_1252_FinnishModel.CHAR_TO_ORDER_MAP: TArray<Byte>;
begin
  Result := [{$I ..\Source\inc\Windows_1252_FinnishModel.inc}];
end;

constructor TWindows_1252_FinnishModel.Create;
begin
  inherited Create(CHAR_TO_ORDER_MAP, 'WINDOWS-1252');
end;

initialization
  TSBCSGroupProber.RegisterModel(
    function(): ISequenceModel
    begin
      Result := TWindows_1252_FinnishModel.Create();
    end);

end.

