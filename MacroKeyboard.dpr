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
  Vcl.Styles.Ext in '..\..\Component Packs\vcl-styles-utils-master\Common\Vcl.Styles.Ext.pas',
  Vcl.Styles.Fixes in '..\..\Component Packs\vcl-styles-utils-master\Common\Vcl.Styles.Fixes.pas',
  Vcl.Styles.Utils.ComCtrls in '..\..\Component Packs\vcl-styles-utils-master\Common\Vcl.Styles.Utils.ComCtrls.pas',
  Vcl.Styles.Utils.Forms in '..\..\Component Packs\vcl-styles-utils-master\Common\Vcl.Styles.Utils.Forms.pas',
  Vcl.Styles.Utils.Graphics in '..\..\Component Packs\vcl-styles-utils-master\Common\Vcl.Styles.Utils.Graphics.pas',
  Vcl.Styles.Utils.Menus in '..\..\Component Packs\vcl-styles-utils-master\Common\Vcl.Styles.Utils.Menus.pas',
  Vcl.Styles.Utils.Misc in '..\..\Component Packs\vcl-styles-utils-master\Common\Vcl.Styles.Utils.Misc.pas',
  Vcl.Styles.Utils in '..\..\Component Packs\vcl-styles-utils-master\Common\Vcl.Styles.Utils.pas',
  Vcl.Styles.Utils.ScreenTips in '..\..\Component Packs\vcl-styles-utils-master\Common\Vcl.Styles.Utils.ScreenTips.pas',
  Vcl.Styles.Utils.StdCtrls in '..\..\Component Packs\vcl-styles-utils-master\Common\Vcl.Styles.Utils.StdCtrls.pas',
  Vcl.Styles.Utils.SysControls in '..\..\Component Packs\vcl-styles-utils-master\Common\Vcl.Styles.Utils.SysControls.pas',
  Vcl.Styles.UxTheme in '..\..\Component Packs\vcl-styles-utils-master\Common\Vcl.Styles.UxTheme.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmMain, frmMain);
  Application.CreateForm(TfrmKeyMacro, frmKeyMacro);
  Application.Run;
end.
