unit CD.Model.Ibm855.Russian;

interface

uses
  CD.Model.Russian;

type
  TIbm855_RussianModel = class(TRussianModel)
  protected
    function IBM855_BYTE_TO_ORDER_MAP: TArray<Byte>;
  public
    constructor Create;
  end;

implementation

uses
  CD.Prober.SBCSGroup;

{ TIbm855_RussianModel }

constructor TIbm855_RussianModel.Create;
begin
  inherited Create(IBM855_BYTE_TO_ORDER_MAP, 'IBM855');
end;

function TIbm855_RussianModel.IBM855_BYTE_TO_ORDER_MAP: TArray<Byte>;
begin
  Result := [{$I ..\Source\Inc\IBM855_BYTE_TO_ORDER_MAP.inc}];
end;

initialization
  TSBCSGroupProber.RegisterModel(
    function(): ISequenceModel
    begin
      Result := TIbm855_RussianModel.Create();
    end);

end.

