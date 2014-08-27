program AdbWirelessService;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  AWSMain in 'AWSMain.pas',
  Winapi.Windows;

var
  Main: TAWSMain;
  ParamPort, ParamAdb: string;
  Input: AnsiString;

begin
  try
    FindCmdLineSwitch('p', ParamPort, True);
    FindCmdLineSwitch('a', ParamAdb, True);

    if ParamAdb = '' then
      ParamAdb := 'adb';

    if ParamPort = '' then
      ParamPort := '8555';

    Writeln('adb wireless is runing');
    Writeln(Format('port - %s', [ParamPort]));
    Writeln(Format('adb - %s', [ParamAdb]));

    Main := TAWSMain.Create;
    try
      Main.start(StrToIntDef(ParamPort, 8555), ParamAdb);

      Writeln('please input your command:');
      while True do
      begin
        Readln(Input);
        WinExec(PAnsiChar(Input), SW_NORMAL);
      end;
    finally
      Main.Free;
    end;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
