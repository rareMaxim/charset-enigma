unit CD.Model.Windows_1252.Estonian;

interface

uses
  CD.Model.Estonian;

type
  TWindows_1252_EstonianModel = class(TEstonianModel)
  private
    class function CHAR_TO_ORDER_MAP: TArray<Byte>; static;
  public
    constructor Create();
  end;

implementation

uses
  CD.Prober.SBCSGroup;

{ TWindows_1252_EstonianModel }

class function TWindows_1252_EstonianModel.CHAR_TO_ORDER_MAP: TArray<Byte>;
begin
  Result := [{$I ..\Source\inc\Windows_1252_EstonianModel.inc}];
end;

constructor TWindows_1252_EstonianModel.Create;
begin
  inherited Create(CHAR_TO_ORDER_MAP, 'WINDOWS-1252');
end;

initialization
  TSBCSGroupProber.RegisterModel(
    function(): ISequenceModel
    begin
      Result := TWindows_1252_EstonianModel.Create();
    end);

end.

