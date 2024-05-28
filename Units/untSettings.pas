unit untSettings;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, System.Win.Registry;

type
  TfrmSettings = class(TForm)
    pnlBottom: TPanel;
    btnOK: TButton;
    btnCancel: TButton;
    gbView: TGroupBox;
    cbZoomOnScroll: TCheckBox;
    GroupBox1: TGroupBox;
    cbLoadLastOpenedConfigOnStart: TCheckBox;
    cbRememberZoomLevel: TCheckBox;
    GroupBox2: TGroupBox;
    cbShowKeyKnobHint: TCheckBox;
    GroupBox3: TGroupBox;
    cbTrayIconVisible: TCheckBox;
    cbMinimizeToTray: TCheckBox;
    cbSetMacroKeysOnOpenConfig: TCheckBox;
    GroupBox4: TGroupBox;
    cbRememberWindowPosition: TCheckBox;
    cbRememberWindowState: TCheckBox;
  public
    /// <summary>
    ///   Load Settings from Registry
    /// </summary>
    procedure LoadSettings;
    /// <summary>
    ///   Save Settings to Registry
    /// </summary>
    procedure SaveSettings;
    /// <summary>
    ///   Execute settings dialog
    /// </summary>
    function Execute: TModalResult;
  end;

var
  frmSettings: TfrmSettings;

const
  /// <summary>
  ///   Registry Root Key
  /// </summary>
  RootKey: HKEY = HKEY_CURRENT_USER;
  /// <summary>
  ///   Registry Key
  /// </summary>
  RegKey: string = '\Software\ERDesigns\Macro Keyboard\';

implementation

{$R *.dfm}

//------------------------------------------------------------------------------
// READ REGISTRY BOOL DEFAULT
//------------------------------------------------------------------------------
function ReadBoolDefault(const Reg: TRegistry; const Name: string; const Default: Boolean): Boolean;
begin
  try
    if Reg.ValueExists(Name) then
      Result := Reg.ReadBool(Name)
    else
      Result := Default;
  except
    Result := Default;
  end;
end;

//------------------------------------------------------------------------------
// LOAD SETTINGS
//------------------------------------------------------------------------------
procedure TfrmSettings.LoadSettings;
var
  Reg: TRegistry;
begin
  Reg := TRegistry.Create;
  try
    // Set root key
    Reg.RootKey := RootKey;
    // Open registry key
    if Reg.OpenKeyReadOnly(RegKey) then
    begin
      // Zoom
      cbZoomOnScroll.Checked := ReadBoolDefault(Reg, 'ZoomOnScroll', True);
      cbRememberZoomLevel.Checked := ReadBoolDefault(Reg, 'RememberZoomLevel', True);
      // Hints
      cbShowKeyKnobHint.Checked := ReadBoolDefault(Reg, 'ShowKeyKnobHint', True);
      // Tray Icon
      cbTrayIconVisible.Checked := ReadBoolDefault(Reg, 'TrayIconVisible', True);
      cbMinimizeToTray.Checked := ReadBoolDefault(Reg, 'MinimizeToTray', True);
      // Config
      cbLoadLastOpenedConfigOnStart.Checked := ReadBoolDefault(Reg, 'LoadLastOpenedConfigOnStart', True);
      cbSetMacroKeysOnOpenConfig.Checked := ReadBoolDefault(Reg, 'SetMacroKeysOnOpenConfig', True);
      // Window
      cbRememberWindowPosition.Checked := ReadBoolDefault(Reg, 'RememberWindowPosition', True);
      cbRememberWindowState.Checked := ReadBoolDefault(Reg, 'RememberWindowState', True);
    end else
    begin
      // Zoom
      cbZoomOnScroll.Checked := True;
      cbRememberZoomLevel.Checked := True;
      // Hints
      cbShowKeyKnobHint.Checked := True;
      // Tray Icon
      cbTrayIconVisible.Checked := True;
      cbMinimizeToTray.Checked := True;
      // Config
      cbLoadLastOpenedConfigOnStart.Checked := True;
      cbSetMacroKeysOnOpenConfig.Checked := True;
      // Window
      cbRememberWindowPosition.Checked := True;
      cbRememberWindowState.Checked := True;
    end;
  finally
    Reg.Free;
  end;
end;

//------------------------------------------------------------------------------
// SAVE SETTINGS
//------------------------------------------------------------------------------
procedure TfrmSettings.SaveSettings;
var
  Reg: TRegistry;
begin
  Reg := TRegistry.Create;
  try
    // Set root key
    Reg.RootKey := RootKey;
    // Open registry key
    if Reg.OpenKey(RegKey, True) then
    begin
      // Zoom
      Reg.WriteBool('ZoomOnScroll', cbZoomOnScroll.Checked);
      Reg.WriteBool('RememberZoomLevel', cbRememberZoomLevel.Checked);
      // Hints
      Reg.WriteBool('ShowKeyKnobHint', cbShowKeyKnobHint.Checked);
      // Tray Icon
      Reg.WriteBool('TrayIconVisible', cbTrayIconVisible.Checked);
      Reg.WriteBool('MinimizeToTray', cbMinimizeToTray.Checked);
      // Config
      Reg.WriteBool('LoadLastOpenedConfigOnStart', cbLoadLastOpenedConfigOnStart.Checked);
      Reg.WriteBool('SetMacroKeysOnOpenConfig', cbSetMacroKeysOnOpenConfig.Checked);
      // Window
      Reg.WriteBool('RememberWindowPosition', cbRememberWindowPosition.Checked);
      Reg.WriteBool('RememberWindowState', cbRememberWindowState.Checked);
    end;
  finally
    Reg.Free;
  end;
end;

//------------------------------------------------------------------------------
// EXECUTE DIALOG
//------------------------------------------------------------------------------
function TfrmSettings.Execute: TModalResult;
begin
  // Load settings from registry
  LoadSettings;
  // Set caption
  Caption := 'Settings';
  // Show dialog modal
  Result := ShowModal;
end;

end.
