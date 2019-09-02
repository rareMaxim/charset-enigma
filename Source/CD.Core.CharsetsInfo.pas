unit CD.Core.CharsetsInfo;

interface

uses
  System.Generics.Collections;

type
  ICharsetInfo = interface
    ['{BD6A100B-C1C6-434B-8472-F97FA207D06D}']
    function GetBomMarker: TArray<Byte>;
    function GetCodepage: Integer;
    function GetLanguage: string;
    function GetID: string;
    function GetCharset: string;
    //
    property ID: string read GetID;
    property Charset: string read GetCharset;
    property Codepage: Integer read GetCodepage;
    property BomMarker: TArray<Byte> read GetBomMarker;
    property Language: string read GetLanguage;
  end;

  TCharsetInfo = class(TInterfacedObject, ICharsetInfo)
  private
    FID: string;
    FCodepage: Integer;
    FBomMarker: TArray<Byte>;
    FCharset: string;
    FLanguage: string;
    function GetBomMarker: TArray<Byte>;
    function GetCharset: string;
    function GetCodepage: Integer;
    function GetLanguage: string;
    function GetID: string;
  public
    constructor Create(const AID, ACharset: string; const ACodepage: Integer;
      ABomMarker: TArray<Byte> = nil; const ALanguage: string = '');
  public
    property ID: string read GetID write FID;
    property Charset: string read GetCharset write FCharset;
    property Codepage: Integer read GetCodepage write FCodepage;
    property BomMarker: TArray<Byte> read GetBomMarker write FBomMarker;
    property Language: string read GetLanguage write FLanguage;
  end;

  TCharsetsInfo = class
  private
    class var
      FCharsets: TObjectList<TCharsetInfo>;
  public
    class constructor Create;
    class destructor Destroy;
    class procedure Add(const AID, ACharset: string; const ACodepage: Integer;
      ABomMarker: TArray<Byte> = nil; const ALanguage: string = '');
    class function FindByID(const AID: string): ICharsetInfo; static;
    class property ByName[const AName: string]: ICharsetInfo read FindByID; default;
  end;

implementation

uses
  System.SysUtils;

constructor TCharsetInfo.Create(const AID, ACharset: string; const ACodepage:
  Integer; ABomMarker: TArray<Byte> = nil; const ALanguage: string = '');
begin
  FID := AID;
  FCharset := ACharset;
  FCodepage := ACodepage;
  FBomMarker := ABomMarker;
  FLanguage := ALanguage;
end;

function TCharsetInfo.GetBomMarker: TArray<Byte>;
begin
  Result := FBomMarker;
end;

function TCharsetInfo.GetCharset: string;
begin
  Result := FCharset;
end;

function TCharsetInfo.GetCodepage: Integer;
begin
  Result := FCodepage;
end;

function TCharsetInfo.GetLanguage: string;
begin
  Result := FLanguage;
end;

function TCharsetInfo.GetID: string;
begin
  Result := FID;
end;

class constructor TCharsetsInfo.Create;
begin
  inherited;
  FCharsets := TObjectList<TCharsetInfo>.Create();
end;

class destructor TCharsetsInfo.Destroy;
begin
  inherited;
  FCharsets.Free;
end;

class procedure TCharsetsInfo.Add(const AID, ACharset: string; const ACodepage:
  Integer; ABomMarker: TArray<Byte> = nil; const ALanguage: string = '');
begin
  FCharsets.Add(TCharsetInfo.Create(AID, ACharset, ACodepage, ABomMarker, ALanguage));
end;

class function TCharsetsInfo.FindByID(const AID: string): ICharsetInfo;
var
  AInfo: TCharsetInfo;
begin
  for AInfo in FCharsets do
  begin
    if AInfo.ID = AID then
    begin
      Result := AInfo;
      Break;
    end;
  end;
end;

end.

