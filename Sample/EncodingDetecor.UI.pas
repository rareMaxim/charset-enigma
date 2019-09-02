unit EncodingDetecor.UI;

interface

uses
  System.SysUtils,
  System.Types,
  System.Classes,
  System.Generics.Collections,
  FMX.Types,
  FMX.Controls,
  FMX.Forms,
  System.Rtti,
  FMX.Grid,
  FMX.Grid.Style,
  FMX.Controls.Presentation,
  FMX.ScrollBox;

type
  TDataGrid = class
    FileName: string;
    Encoding: string;
  end;

  TForm4 = class(TForm)
    grd1: TGrid;
    strngclmn1: TStringColumn;
    strngclmn2: TStringColumn;
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure grd1DragDrop(Sender: TObject; const Data: TDragObject; const Point: TPointF);
    procedure grd1DragOver(Sender: TObject; const Data: TDragObject; const Point:
      TPointF; var Operation: TDragOperation);
    procedure grd1GetValue(Sender: TObject; const ACol, ARow: Integer; var Value: TValue);
  private
    { Private declarations }
    FData: TObjectList<TDataGrid>;
  public
    { Public declarations }
    procedure AddToGrid(AFile, AEnc: string);
    procedure ScanEncoding(AFiles: TArray<string>); overload;
    procedure ScanEncoding(AFile: string); overload;
  end;

var
  Form4: TForm4;

implementation

uses
  CharsetEnigma.Lite,
  System.IOUtils;
{$R *.fmx}

procedure TForm4.FormDestroy(Sender: TObject);
begin
  FData.Free;
end;

procedure TForm4.AddToGrid(AFile, AEnc: string);
var
  x: TDataGrid;
begin
  x := TDataGrid.Create;
  x.FileName := AFile;
  x.Encoding := AEnc;
  FData.Add(x);
end;

procedure TForm4.FormCreate(Sender: TObject);
begin
  ReportMemoryLeaksOnShutdown := True;
  FData := TObjectList<TDataGrid>.Create;
  grd1.RowCount := 0;
end;

procedure TForm4.grd1DragDrop(Sender: TObject; const Data: TDragObject; const Point: TPointF);
var
  LFiles: TList<string>;
  I: Integer;
begin
  LFiles := TList<string>.Create;
  grd1.BeginUpdate;
  try
    FData.Clear;
    for I := Low(Data.Files) to High(Data.Files) do
    begin
      if FileExists(Data.Files[I]) then
        LFiles.Add(Data.Files[I]);
      if DirectoryExists(Data.Files[I]) then
        LFiles.AddRange(TDirectory.GetFiles(Data.Files[I], '*.*', TSearchOption.soAllDirectories));
    end;
    ScanEncoding(LFiles.ToArray);
    grd1.RowCount := FData.Count;
  finally
    grd1.EndUpdate;
    LFiles.Free;
  end;
end;

procedure TForm4.grd1DragOver(Sender: TObject; const Data: TDragObject; const
  Point: TPointF; var Operation: TDragOperation);
begin
  Operation := TDragOperation.Copy;
end;

procedure TForm4.grd1GetValue(Sender: TObject; const ACol, ARow: Integer; var Value: TValue);
begin
  if ACol = 0 then
    Value := FData[ARow].FileName;
  if ACol = 1 then
    Value := FData[ARow].Encoding;
end;

procedure TForm4.ScanEncoding(AFile: string);
var
  result: IDetectionResult;
begin
  result := TCharsetEnigma.DetectFromFile(AFile);

  if (result <> nil) and (result.Detected <> nil) then
    AddToGrid(AFile, result.Detected.EncodingName)
  else
    AddToGrid(AFile, 'Detecting failed')

end;

procedure TForm4.ScanEncoding(AFiles: TArray<string>);
var
  LFile: string;
begin
  for LFile in AFiles do
  begin
    ScanEncoding(LFile);
  end;
end;

end.

