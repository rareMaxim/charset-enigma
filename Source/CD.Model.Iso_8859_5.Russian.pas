unit CD.Model.Iso_8859_5.Russian;

interface

uses
  CD.Model.Russian;

type
  TIso_8859_5_RussianModel = class(TRussianModel)
  private
    class function CHAR_TO_ORDER_MAP: TArray<Byte>;
  public
    constructor Create;
  end;

implementation

uses
  CD.Prober.SBCSGroup;

{ TIso_8859_5_RussianModel }

class function TIso_8859_5_RussianModel.CHAR_TO_ORDER_MAP: TArray<Byte>;
begin
  Result := [{$I ..\Source\Inc\Iso_8859_5_RussianModel.inc}];
end;

constructor TIso_8859_5_RussianModel.Create;
begin
  inherited Create(CHAR_TO_ORDER_MAP, 'ISO-8859-5');
end;

initialization
  TSBCSGroupProber.RegisterModel(
    function(): ISequenceModel
    begin
      Result := TIso_8859_5_RussianModel.Create();
    end);

end.

