program MacroKeyboard;

uses
  Vcl.Forms,
  untMain in 'Units\untMain.pas' {frmMain},
  HID.Constants in 'Units\HID.Constants.pas',
  HID.Types in 'Units\HID.Types.pas',
  HID in 'Units\HID.pas',
  HID.MacroKeyboard in 'Units\HID.MacroKeyboard.pas',
  HID.MacroKeyboard.Component in 'Units\HID.MacroKeyboard.Component.pas',
  Vcl.Themes,
  Vcl.Styles,
  HID.MacroKeyboard.Config in 'Units\HID.MacroKeyboard.Config.pas',
  untKeyMacro in 'Units\untKeyMacro.pas' {frmKeyMacro},
  untKnobMacro in 'Units\untKnobMacro.pas' {frmKnobMacro},
  untSettings in 'Units\untSettings.pas' {frmSettings},
  HID.MacroKeyboard.Hotkey in 'Units\HID.MacroKeyboard.Hotkey.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmMain, frmMain);
  Application.CreateForm(TfrmKeyMacro, frmKeyMacro);
  Application.CreateForm(TfrmKnobMacro, frmKnobMacro);
  Application.CreateForm(TfrmSettings, frmSettings);
  Application.Run;
end.
