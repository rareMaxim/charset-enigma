unit CD.Model.Iso_8859_7.Greek;

interface

uses
  CD.Model.Greek;

type
  TIso_8859_7_GreekModel = class(TGreekModel)
  private
    class function CHAR_TO_ORDER_MAP: TArray<Byte>; static;
  public
    constructor Create();
  end;

implementation

uses
  CD.Prober.SBCSGroup;

{ TIso_8859_7_GreekModel }

class function TIso_8859_7_GreekModel.CHAR_TO_ORDER_MAP: TArray<Byte>;
begin
  Result := [{$I ..\Source\Inc\Iso_8859_7_GreekModel.inc}];
end;

constructor TIso_8859_7_GreekModel.Create;
begin
  inherited Create(CHAR_TO_ORDER_MAP, 'ISO-8859-7');
end;

initialization
  TSBCSGroupProber.RegisterModel(
    function(): ISequenceModel
    begin
      Result := TIso_8859_7_GreekModel.Create();
    end);

end.

