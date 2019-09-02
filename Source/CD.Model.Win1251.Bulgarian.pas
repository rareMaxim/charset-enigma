unit CD.Model.Win1251.Bulgarian;

interface

uses
  CD.Model.Bulgarian;

type
  TWindows_1251_BulgarianModel = class(TBulgarianModel)
  protected
    function CHAR_TO_ORDER_MAP: TArray<Byte>;
  public
    constructor Create;
  end;

implementation

uses
  CD.Prober.SBCSGroup;

{ TWindows_1251_BulgarianModel }

constructor TWindows_1251_BulgarianModel.Create;
begin
  inherited Create(CHAR_TO_ORDER_MAP, 'windows-1251');
end;

function TWindows_1251_BulgarianModel.CHAR_TO_ORDER_MAP: TArray<Byte>;
begin
  Result := [{$I ..\Source\inc\Windows_1251_BulgarianModel.inc}];
end;

initialization
  TSBCSGroupProber.RegisterModel(
    function(): ISequenceModel
    begin
      Result := TWindows_1251_BulgarianModel.Create();
    end);

end.

