unit CD.Model.Bulgarian;

interface

uses
  CD.Model.Sequence;

type
  TBulgarianModel = class(TSequenceModel)
  protected
    function BULGARIAN_LANG_MODEL: TArray<Byte>;
  public
    constructor Create(charToOrderMap: TArray<Byte>; name: string);
  end;

implementation

{ TBulgarianModel }

function TBulgarianModel.BULGARIAN_LANG_MODEL: TArray<Byte>;
begin
  Result := [{$I ..\Source\Inc\BULGARIAN_LANG_MODEL.inc}];
end;

constructor TBulgarianModel.Create(charToOrderMap: TArray<Byte>; name: string);
begin
  inherited Create(charToOrderMap, BULGARIAN_LANG_MODEL, 64, 0.969392,
    False, name);
end;

end.
