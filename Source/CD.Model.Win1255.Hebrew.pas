unit CD.Model.Win1255.Hebrew;

interface

uses
  CD.Model.Hebrew;

type
  TWindows_1255_HebrewModel = class(THebrewModel)
  protected
    function CHAR_TO_ORDER_MAP: TArray<Byte>;
  public
    constructor Create;
  end;

implementation

uses
  CD.Prober.SBCSGroup;

{ TWindows_1255_HebrewModel }

constructor TWindows_1255_HebrewModel.Create;
begin
  inherited Create(CHAR_TO_ORDER_MAP, 'windows-1255');
end;

function TWindows_1255_HebrewModel.CHAR_TO_ORDER_MAP: TArray<Byte>;
begin
  Result := [{$I ..\Source\inc\Windows_1255_HebrewModel.inc}];
end;

end.

