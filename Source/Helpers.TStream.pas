unit Helpers.TStream;

interface

uses
  System.Classes;

type
  TStreamHelper = class helper for TStream
  public
    procedure WriteByte(Value: Byte);
    function ToArray: TArray<Byte>;
  end;

implementation

{ TStreamHelper }

function TStreamHelper.ToArray: TArray<Byte>;
var
  LCurrentPosition: Int64;
begin
  LCurrentPosition := Self.Position; // Запоминаем текущий курсор
  Self.Position := 0; // Переходим в начало
  SetLength(Result, Self.Size); // Задаем размер результата
  Self.Read(Result[0], Self.Size); // Записываем данные в результат
  Self.Position := LCurrentPosition; // Возвращаемся на исходную позицию
end;

procedure TStreamHelper.WriteByte(Value: Byte);
begin
  Self.Write(Value, SizeOf(Value));
end;

end.
