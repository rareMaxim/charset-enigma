unit CD.Model.Windows_1252.Irish;

interface

uses
  CD.Model.Irish;

type
  TWindows_1252_IrishModel = class(TIrishModel)
  private
    class function CHAR_TO_ORDER_MAP: TArray<Byte>; static;
  public
    constructor Create();
  end;

implementation

uses
  CD.Prober.SBCSGroup;

{ TWindows_1252_IrishModel }

class function TWindows_1252_IrishModel.CHAR_TO_ORDER_MAP: TArray<Byte>;
begin
  Result := [{$I ..\Source\inc\Windows_1252_IrishModel.inc}];
end;

constructor TWindows_1252_IrishModel.Create;
begin
  inherited Create(CHAR_TO_ORDER_MAP, 'WINDOWS-1252');
end;

initialization
  TSBCSGroupProber.RegisterModel(
    function(): ISequenceModel
    begin
      Result := TWindows_1252_IrishModel.Create();
    end);

end.

