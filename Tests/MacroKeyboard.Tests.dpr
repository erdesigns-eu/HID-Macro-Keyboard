program MacroKeyboardTests;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  DUnitX.Loggers.Console,
  DUnitX.RunResults,
  DUnitX.TestFramework,
  Test.HID.MacroKeyboard.Protocol in 'Test.HID.MacroKeyboard.Protocol.pas',
  HID in '..\Units\HID.pas',
  HID.Constants in '..\Units\HID.Constants.pas',
  HID.Types in '..\Units\HID.Types.pas',
  HID.MacroKeyboard in '..\Units\HID.MacroKeyboard.pas',
  HID.MacroKeyboard.Config in '..\Units\HID.MacroKeyboard.Config.pas',
  HID.MacroKeyboard.DeviceCatalog in '..\Units\HID.MacroKeyboard.DeviceCatalog.pas',
  HID.MacroKeyboard.DeviceDefinition in '..\Units\HID.MacroKeyboard.DeviceDefinition.pas',
  HID.MacroKeyboard.Layout in '..\Units\HID.MacroKeyboard.Layout.pas',
  HID.MacroKeyboard.Protocol in '..\Units\HID.MacroKeyboard.Protocol.pas',
  HID.MacroKeyboard.Transport in '..\Units\HID.MacroKeyboard.Transport.pas',
  HID.MacroKeyboard.Transport.Memory in '..\Units\HID.MacroKeyboard.Transport.Memory.pas';

var
  Runner: ITestRunner;
  Results: IRunResults;
begin
  try
    TDUnitX.CheckCommandLine;
    Runner := TDUnitX.CreateRunner;
    Runner.UseRTTI := True;
    Runner.AddLogger(TDUnitXConsoleLogger.Create(True));
    Results := Runner.Execute;
    if not Results.AllPassed then
      ExitCode := EXIT_ERRORS;
  except
    on E: Exception do
    begin
      Writeln(E.ClassName, ': ', E.Message);
      ExitCode := EXIT_ERRORS;
    end;
  end;
end.
