unit CD.Prober.Store;

interface

uses
  CD.Prober.Charset,
  System.Generics.Collections;

type
  TProberService = class
  private
    type
      TProberStore = TDictionary<string, ICharsetProber>;
  private
    class var
      FCurrent: TProberService;
      FProbers: TProberStore;
    class constructor Create;
    class destructor Destroy;
    class function GetProber(AName: string): ICharsetProber; static;
  public
    constructor Create;
    destructor Destroy; override;
    class procedure RegisterProber(AProber: ICharsetProber; const AGroupName: string = '');
    class function Filtered(const AFilter: string = ''; const Include: Boolean = True): TArray<ICharsetProber>;
    class function IsEscCharsetProber(ACharsetProber: ICharsetProber): Boolean;
    class property Probers: TProberStore read FProbers;
    class property Prober[AName: string]: ICharsetProber read GetProber; default;
    class function HasCurrent: Boolean;
    class property Current: TProberService read FCurrent;
  end;

implementation

uses
  System.SysUtils;

class function TProberService.Filtered(const AFilter: string = ''; const Include:
  Boolean = True): TArray<ICharsetProber>;
var
  LProber: TPair<string, ICharsetProber>;
  LReturn: TList<ICharsetProber>;
begin
  LReturn := TList<ICharsetProber>.Create;
  try
    for LProber in FProbers do
      if Include and LProber.Key.Contains(AFilter) then
        LReturn.Add(LProber.Value);
    Result := LReturn.ToArray;
  finally
    LReturn.Free;
  end;
end;

class function TProberService.IsEscCharsetProber(ACharsetProber: ICharsetProber): Boolean;
begin
  Result := ACharsetProber.Name = 'TEscCharsetProber';
end;

class procedure TProberService.RegisterProber(AProber: ICharsetProber; const AGroupName: string = '');
var
  LFullname: string;
begin
  if not AGroupName.IsEmpty then
    LFullname := AGroupName + '.';
  LFullname := LFullname + AProber.Name;
  Current.FProbers.AddOrSetValue(LFullname, AProber);
end;

class constructor TProberService.Create;
begin
  FCurrent := TProberService.Create;
end;

class destructor TProberService.Destroy;
begin
  FreeAndNil(FCurrent);
end;

destructor TProberService.Destroy;
begin
  FProbers.Free;
end;

class function TProberService.HasCurrent: Boolean;
begin
  Result := FCurrent <> nil;
end;

constructor TProberService.Create;
begin
  FProbers := TProberStore.Create();
end;

class function TProberService.GetProber(AName: string): ICharsetProber;
begin
  if FProbers.ContainsKey(AName) then
    Result := FProbers.Items[AName]
  else
    raise EArgumentException.Create('AName not found in FProbers');
end;

end.

