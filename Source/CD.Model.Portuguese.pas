unit CD.Model.Portuguese;

interface

uses
  CD.Model.Sequence;

type
  TPortugueseModel = class abstract(TSequenceModel)
  private
    // Model Table:
    // Total sequences: 891
    // First 512 sequences: 0.9953179582313172
    // Next 512 sequences (512-1024): 0.00468204176868278556
    // Rest: 2.42861286636753e-17
    // Negative sequences: TODO
    class function LANG_MODEL: TArray<Byte>; static;
  public
    constructor Create(charToOrderMap: TArray<Byte>; name: string);
  end;

implementation

{ TPortugueseModel }

constructor TPortugueseModel.Create(charToOrderMap: TArray<Byte>; name: string);
begin
  inherited Create(charToOrderMap, LANG_MODEL, 38, 0.9953179582313172,
    true, name);
end;

class function TPortugueseModel.LANG_MODEL: TArray<Byte>;
begin
  Result := [{$I ..\Source\Inc\PortugueseModel.inc}];
end;

end.
