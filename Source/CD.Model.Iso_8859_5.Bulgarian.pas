unit CD.Model.Iso_8859_5.Bulgarian;

interface

uses
  CD.Model.Bulgarian;

type
  TIso_8859_5_BulgarianModel = class(TBulgarianModel)
  protected
    // CTR: Control characters that usually does not exist in any text
    // RET: Carriage/Return
    // SYM: symbol(punctuation) that does not belong to word
    // NUM: 0 - 9
    //
    // Character Mapping Table:
    // this table is modified base on win1251BulgarianCharToOrderMap, so
    // only number <64 is sure valid
    class function CHAR_TO_ORDER_MAP: TArray<Byte>; static;
  public
    constructor Create;
  end;

implementation

uses
  CD.Prober.SBCSGroup;

{ TIso_8859_5_BulgarianModel }

constructor TIso_8859_5_BulgarianModel.Create;
begin
  inherited Create(CHAR_TO_ORDER_MAP, 'ISO-8859-5');
end;

class function TIso_8859_5_BulgarianModel.CHAR_TO_ORDER_MAP: TArray<Byte>;
begin
  Result := [{$I ..\Source\inc\Iso_8859_5_BulgarianModel.inc}];
end;

initialization
  TSBCSGroupProber.RegisterModel(
    function(): ISequenceModel
    begin
      Result := TIso_8859_5_BulgarianModel.Create();
    end);

end.

