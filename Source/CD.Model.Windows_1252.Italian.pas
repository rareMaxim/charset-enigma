unit CD.Model.Windows_1252.Italian;

interface

uses
  CD.Model.Italian;

type
  TWindows_1252_ItalianModel = class(TItalianModel)
  private
    class function CHAR_TO_ORDER_MAP: TArray<Byte>; static;
  public
    constructor Create();
  end;

implementation

uses
  CD.Prober.SBCSGroup;

{ TWindows_1252_ItalianModel }

class function TWindows_1252_ItalianModel.CHAR_TO_ORDER_MAP: TArray<Byte>;
begin
  Result := [{$I ..\Source\inc\Windows_1252_ItalianModel.inc}];
end;

constructor TWindows_1252_ItalianModel.Create;
begin
  inherited Create(CHAR_TO_ORDER_MAP, 'WINDOWS-1252');
end;

initialization
  TSBCSGroupProber.RegisterModel(
    function(): ISequenceModel
    begin
      Result := TWindows_1252_ItalianModel.Create();
    end);

end.

