unit CD.Model.Windows_1252.Portuguese;

interface

uses
  CD.Model.Portuguese;

type
  TWindows_1252_PortugueseModel = class(TPortugueseModel)
  protected
    class function CHAR_TO_ORDER_MAP: TArray<Byte>; static;
  public
    constructor Create;
  end;

implementation

uses
  CD.Prober.SBCSGroup;

{ TWindows_1252_PortugueseModel }

class function TWindows_1252_PortugueseModel.CHAR_TO_ORDER_MAP: TArray<Byte>;
begin
  Result := [{$I ..\Source\inc\Windows_1252_PortugueseModel.inc}];
end;

constructor TWindows_1252_PortugueseModel.Create;
begin
  inherited Create(CHAR_TO_ORDER_MAP, 'WINDOWS-1252');
end;

initialization
  TSBCSGroupProber.RegisterModel(
    function(): ISequenceModel
    begin
      Result := TWindows_1252_PortugueseModel.Create();
    end);

end.

