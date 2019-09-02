unit CD.Model.Koi8r.Russian;

interface

uses
  CD.Model.Russian;

type
  TKoi8rModel = class(TRussianModel)
  protected
    function KOI8R_CHAR_TO_ORDER_MAP: TArray<Byte>;
  public
    constructor Create;
  end;

implementation

uses
  CD.Prober.SBCSGroup;

{ TKoi8rModel }

constructor TKoi8rModel.Create;
begin
  inherited Create(KOI8R_CHAR_TO_ORDER_MAP, 'KOI8-R');
end;

function TKoi8rModel.KOI8R_CHAR_TO_ORDER_MAP: TArray<Byte>;
begin
  Result := [{$I ..\Source\inc\KOI8R_CHAR_TO_ORDER_MAP.inc}];
end;

initialization
  TSBCSGroupProber.RegisterModel(
    function(): ISequenceModel
    begin
      Result := TKoi8rModel.Create();
    end);

end.

