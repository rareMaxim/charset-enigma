unit CD.Core.CodingStateMachine;

interface

uses
  CD.Model.StateMachine;

type
  ICodingStateMachine = interface
    ['{1A69EE7F-F9EA-4B30-9244-F5393F4BB249}']
    function NextState(AByte: Byte): Integer;
    function ModelName: string;
    function CurrentCharLen: Integer;
    procedure Reset;
  end;
  /// <summary>
  /// Parallel state machine for the Coding Scheme Method
  /// </summary>

  TCodingStateMachine = class(TInterfacedObject, ICodingStateMachine)
  private
    FCurrentState: Integer;
    FModel: ISMModel;
    FCurrentCharLen: Integer;
    FCurrentBytePos: Integer;
  public
    constructor Create(AModel: ISMModel);
    function NextState(AByte: Byte): Integer;
    procedure Reset;
    function CurrentCharLen: Integer;
    function ModelName: string;
  end;

implementation

{ TCodingStateMachine }

constructor TCodingStateMachine.Create(AModel: ISMModel);
begin
  FCurrentState := TSMModel.START;
  FModel := AModel;
end;

function TCodingStateMachine.CurrentCharLen: Integer;
begin
  Result := FCurrentCharLen;
end;

function TCodingStateMachine.ModelName: string;
begin
  Result := FModel.name;
end;

function TCodingStateMachine.NextState(AByte: Byte): Integer;
var
  byteCls: Integer;
begin
  // for each byte we get its class, if it is first byte,
  // we also get byte length
  byteCls := FModel.GetClass(AByte);
  if (FCurrentState = TSMModel.START) then
  begin
    FCurrentBytePos := 0;
    FCurrentCharLen := FModel.charLenTable[byteCls];
  end;
  // from byte's class and stateTable, we get its next state
  FCurrentState := FModel.stateTable.Unpack(FCurrentState * FModel.ClassFactor + byteCls);
  Inc(FCurrentBytePos);
  Result := FCurrentState;
end;

procedure TCodingStateMachine.Reset;
begin
  FCurrentState := TSMModel.START;
end;

end.

