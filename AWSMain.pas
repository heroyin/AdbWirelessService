unit AWSMain;

interface

uses
  IdHTTPServer, System.SysUtils, IdContext, IdCustomHTTPServer, System.Types;

type
  TAWSMain = class(TObject)
    procedure httpServerCommandGet(AContext: TIdContext; ARequestInfo:
        TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo);
  private
    FAdbPath: string;
    FServer: TIdHTTPServer;
  public
    constructor Create;
    destructor Destroy; override;
    procedure start(APort: Integer; AdbPath: string);
  end;

implementation

uses
  System.StrUtils, Winapi.Windows;


constructor TAWSMain.Create;
begin
  inherited;
  FServer := TIdHTTPServer.Create(nil);
  FServer.OnCommandGet := httpServerCommandGet;
end;

destructor TAWSMain.Destroy;
begin
  FreeAndNil(FServer);
  inherited;
end;

procedure TAWSMain.httpServerCommandGet(AContext: TIdContext; ARequestInfo:
    TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo);
var
  Uri: TStringDynArray;
  Cmd, Ip: string;
begin
  Uri := SplitString(ARequestInfo.URI, '/');
  if Length(Uri)<>3 then
    Exit;

  Cmd := Uri[1];
  Ip := Uri[2];

  if Cmd='c' then
  begin
    Writeln(Format('%s is ready, try to connect', [Ip]));
    WinExec(PAnsiChar(AnsiString(FAdbPath + ' connect '+Ip)), SW_NORMAL);
  end else if Cmd='d' then
  begin
    Writeln(Format('%s is offline!', [Ip]));
    WinExec(PAnsiChar(AnsiString(FAdbPath + ' disconnect '+Ip)), SW_NORMAL);
  end;

  ///connect is async£¬so wait
  Sleep(1000);
  WinExec(PAnsiChar(AnsiString(FAdbPath + ' devices')), SW_NORMAL);
end;

procedure TAWSMain.start(APort: Integer; AdbPath: string);
begin
  FServer.DefaultPort := APort;
  FServer.Active := true;

  FAdbPath := AdbPath;
  if FAdbPath = '' then
    FAdbPath := 'adb';
end;

end.
