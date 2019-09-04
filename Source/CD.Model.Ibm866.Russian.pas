unit CD.Model.Ibm866.Russian;

interface

uses
  CD.Model.Russian;

type
  TIbm866_RussianModel = class(TRussianModel)
  protected
    function IBM866_CHAR_TO_ORDER_MAP: TArray<Byte>;
  public
    constructor Create;
  end;

implementation

uses
  CD.Prober.SBCSGroup;

{ TIbm866_RussianModel }

constructor TIbm866_RussianModel.Create;
begin
  inherited Create(IBM866_CHAR_TO_ORDER_MAP, 'IBM866');
end;

function TIbm866_RussianModel.IBM866_CHAR_TO_ORDER_MAP: TArray<Byte>;
begin
  Result := [{$I ..\Source\Inc\IBM866_CHAR_TO_ORDER_MAP.inc}];
end;

initialization
  TSBCSGroupProber.RegisterModel(
    function(): ISequenceModel
    begin
      Result := TIbm866_RussianModel.Create();
    end);

end.

