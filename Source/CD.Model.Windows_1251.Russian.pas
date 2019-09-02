unit CD.Model.Windows_1251.Russian;

interface

uses
  CD.Model.Russian;

type
  TWindows_1251_RussianModel = class(TRussianModel)
  private
    class function CHAR_TO_ORDER_MAP: TArray<Byte>;
  public
    constructor Create();
  end;

implementation

uses
  CD.Prober.SBCSGroup;
{ TWindows_1251_RussianModel }

class function TWindows_1251_RussianModel.CHAR_TO_ORDER_MAP: TArray<Byte>;
begin
  Result := [{$I ..\Source\inc\Windows_1251_RussianModel.inc}];
end;

constructor TWindows_1251_RussianModel.Create;
begin
  inherited Create(CHAR_TO_ORDER_MAP, 'WINDOWS-1251');
end;

initialization
  TSBCSGroupProber.RegisterModel(
    function(): ISequenceModel
    begin
      result := TWindows_1251_RussianModel.Create();
    end);

end.

