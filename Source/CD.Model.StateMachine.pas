unit CD.Model.StateMachine;

interface

uses
  CD.Core.BitPackage;

type
  ISMModel = interface
    ['{D584C20B-91F0-4EE5-BDBA-27A4929CD87F}']
    function GetCharLenTable: TArray<Integer>;
    function GetClassFactor: Integer;
    function GetName: string;
    function GetStateTable: IBitPackage;
    //
    function GetClass(b: Byte): Integer;
    // property
    property CharLenTable: TArray<Integer> read GetCharLenTable;
    property stateTable: IBitPackage read GetStateTable;
    property Name: string read GetName;
    property ClassFactor: Integer read GetClassFactor;
  end;
  /// <summary>
  /// State machine model
  /// </summary>

  TSMModel = class(TInterfacedObject, ISMModel)
  public
    const
    /// <summary>
    /// Start node
    /// </summary>
      START = 0;
    /// <summary>
    /// Error node <see cref="ProbingState.NotMe"/> ?
    /// </summary>
      ERROR = 1;
    /// <summary>
    /// <see cref="ProbingState.FoundIt"/> ?
    /// </summary>
      ITSME = 2;
  private
    FName: string;
    FClassFactor: Integer;
    FClassTable: IBitPackage;
    FStateTable: IBitPackage;
    FCharLenTable: TArray<Integer>;
    function GetCharLenTable: TArray<Integer>;
    function GetClassFactor: Integer;
    function GetName: string;
    function GetStateTable: IBitPackage;
  public
    constructor Create(classTable: IBitPackage; ClassFactor: Integer; stateTable:
      IBitPackage; CharLenTable: TArray<Integer>; name: string);
    function GetClass(b: Byte): Integer;
    // property
    property CharLenTable: TArray<Integer> read GetCharLenTable;
    property stateTable: IBitPackage read GetStateTable;
    property Name: string read GetName;
    property ClassFactor: Integer read GetClassFactor;
  end;

implementation

{ TSMModel }

constructor TSMModel.Create(classTable: IBitPackage; ClassFactor: Integer;
  stateTable: IBitPackage; CharLenTable: TArray<Integer>; name: string);
begin
  Self.FClassTable := classTable;
  Self.FClassFactor := ClassFactor;
  Self.FStateTable := stateTable;
  Self.FCharLenTable := CharLenTable;
  Self.FName := name;
end;

function TSMModel.GetCharLenTable: TArray<Integer>;
begin
  Result := FCharLenTable;
end;

function TSMModel.GetClass(b: Byte): Integer;
begin
  Result := FClassTable.Unpack(Integer(b));
end;

function TSMModel.GetClassFactor: Integer;
begin
  Result := FClassFactor;
end;

function TSMModel.GetName: string;
begin
  Result := FName;
end;

function TSMModel.GetStateTable: IBitPackage;
begin
  Result := FStateTable;
end;

end.

