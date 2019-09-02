unit CD.Model.Russian.MacCyrillic;

interface

uses
  CD.Model.Russian;

type
  TX_Mac_Cyrillic_RussianModel = class(TRussianModel)
  protected
    function MACCYRILLIC_CHAR_TO_ORDER_MAP(): TArray<Byte>;
  public
    constructor Create();
  end;

implementation

uses
  CD.Prober.SBCSGroup;

{ TX_Mac_Cyrillic_RussianModel }

constructor TX_Mac_Cyrillic_RussianModel.Create;
begin
  inherited Create(MACCYRILLIC_CHAR_TO_ORDER_MAP, 'x-mac-cyrillic');
end;

function TX_Mac_Cyrillic_RussianModel.MACCYRILLIC_CHAR_TO_ORDER_MAP: TArray<Byte>;
begin
  Result := [{$I ..\source\Inc\MACCYRILLIC_CHAR_TO_ORDER_MAP.inc}];
end;

initialization
  TSBCSGroupProber.RegisterModel(
    function(): ISequenceModel
    begin
      Result := TX_Mac_Cyrillic_RussianModel.Create();
    end);

end.

