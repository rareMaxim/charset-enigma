unit CD.Model.Windows_1252.Spanish;

interface

uses
  CD.Model.Spanish;

type
  TWindows_1252_SpanishModel = class(TSpanishModel)
  private
    class function CHAR_TO_ORDER_MAP: TArray<Byte>; static;
  public
    constructor Create();
  end;

implementation

uses
  CD.Prober.SBCSGroup;

{ TWindows_1252_SpanishModel }

class function TWindows_1252_SpanishModel.CHAR_TO_ORDER_MAP: TArray<Byte>;
begin
  Result := [{$I ..\Source\Inc\Windows_1252_SpanishModel.inc}];
end;

constructor TWindows_1252_SpanishModel.Create;
begin
  inherited Create(CHAR_TO_ORDER_MAP, 'WINDOWS-1252');
end;

initialization
  TSBCSGroupProber.RegisterModel(
    function(): ISequenceModel
    begin
      Result := TWindows_1252_SpanishModel.Create();
    end);

end.

