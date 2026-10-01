unit untMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.ComCtrls,
  Vcl.StdCtrls, Vcl.Menus, Vcl.StdActns, System.Actions, Vcl.ActnList, System.UITypes,
  System.Win.Registry, System.StrUtils,

  HID, HID.MacroKeyboard.Component, HID.MacroKeyboard.Config,
  HID.MacroKeyboard.DeviceDefinition, HID.MacroKeyboard.Protocol,
  HID.MacroKeyboard.Transport, HID.MacroKeyboard.Diagnostics;

type
  TfrmMain = class(TForm)
    MacroKeyboard: TMacroKeyboard;
    StatusBar: TStatusBar;
    ActionList: TActionList;
    acNew: TAction;
    MainMenu: TMainMenu;
    acOpen: TFileOpen;
    acOpenLayout: TFileOpen;
    acOpenDeviceDefinition: TFileOpen;
    acExportDiagnostics: TFileSaveAs;
    acSaveAs: TFileSaveAs;
    acSave: TAction;
    acExit: TAction;
    acSetMacroKey: TAction;
    acClearKey: TAction;
    acSetMacroKnobC: TAction;
    acSetMacroKnobCC: TAction;
    acSetMacroKnob: TAction;
    acClearKnob: TAction;
    acAbout: TAction;
    File1: TMenuItem;
    New1: TMenuItem;
    N1: TMenuItem;
    Open1: TMenuItem;
    Save1: TMenuItem;
    SaveAs1: TMenuItem;
    Exit1: TMenuItem;
    Key1: TMenuItem;
    SetMacro1: TMenuItem;
    Clear1: TMenuItem;
    N3: TMenuItem;
    Knob1: TMenuItem;
    SetClockwiseMacro1: TMenuItem;
    SetCounterClockwiseMacro1: TMenuItem;
    N4: TMenuItem;
    SetClickMacro1: TMenuItem;
    N5: TMenuItem;
    Clear2: TMenuItem;
    Help1: TMenuItem;
    About1: TMenuItem;
    ExportDiagnostics1: TMenuItem;
    acSettings: TAction;
    N6: TMenuItem;
    RepaintTimer: TTimer;
    PopupKey: TPopupMenu;
    PopupRotaryEncoder: TPopupMenu;
    SetMacro2: TMenuItem;
    N7: TMenuItem;
    Clear3: TMenuItem;
    SetClockwiseMacro2: TMenuItem;
    SetCounterClockwiseMacro2: TMenuItem;
    N8: TMenuItem;
    SetClickMacro2: TMenuItem;
    N9: TMenuItem;
    Clear4: TMenuItem;
    acZoomIn: TAction;
    acZoomOut: TAction;
    acZoom100: TAction;
    View1: TMenuItem;
    LoadLayout1: TMenuItem;
    N12: TMenuItem;
    LoadDeviceDefinition1: TMenuItem;
    ZoomIn1: TMenuItem;
    ZoomOut1: TMenuItem;
    N10: TMenuItem;
    Zoom1001: TMenuItem;
    MacroKeyboardConfig: TMacroKeyboardConfig;
    N2: TMenuItem;
    Settings1: TMenuItem;
    TrayIcon: TTrayIcon;
    PopupTrayIcon: TPopupMenu;
    Exit2: TMenuItem;
    N11: TMenuItem;
    Open2: TMenuItem;
    AboutDialog: TTaskDialog;
    ProgressDialog: TTaskDialog;
    procedure MacroKeyboardSelect(Sender: TObject; Index: Integer);
    procedure RepaintTimerTimer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure acAboutExecute(Sender: TObject);
    procedure acNewExecute(Sender: TObject);
    procedure acOpenAccept(Sender: TObject);
    /// <summary>Loads a user-selected visual keyboard layout.</summary>
    procedure acOpenLayoutAccept(Sender: TObject);
    /// <summary>Loads a user-selected device and protocol definition.</summary>
    procedure acOpenDeviceDefinitionAccept(Sender: TObject);
    /// <summary>Exports a sanitized JSON report for protocol investigation.</summary>
    procedure acExportDiagnosticsAccept(Sender: TObject);
    procedure acSaveExecute(Sender: TObject);
    procedure acSaveAsAccept(Sender: TObject);
    procedure acExitExecute(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure MacroKeyboardConfigFilename(Sender: TObject; Filename: string);
    procedure acZoomInExecute(Sender: TObject);
    procedure acZoomOutExecute(Sender: TObject);
    procedure acZoom100Execute(Sender: TObject);
    procedure acSetMacroKeyExecute(Sender: TObject);
    procedure acSetMacroKnobCExecute(Sender: TObject);
    procedure acSetMacroKnobCCExecute(Sender: TObject);
    procedure acSetMacroKnobExecute(Sender: TObject);
    procedure MacroKeyboardKeyKnobHint(Sender: TObject; Index: Integer; var Hint: string);
    procedure acSettingsExecute(Sender: TObject);
    procedure TrayIconDblClick(Sender: TObject);
    procedure MacroKeyboardKeyPress(Sender: TObject; Index: Integer; Key: Word;
      Shift: TShiftState);
    procedure acClearKeyExecute(Sender: TObject);
    procedure acClearKnobExecute(Sender: TObject);
  private
    /// <summary>
    ///   HID Devices
    /// </summary>
    FHID: THIDDeviceList;
    /// <summary>
    ///   Macro Keyboard HID Device
    /// </summary>
    FHIDDevice: THIDDevice;
    /// <summary>Active device identity, layout, and action mapping.</summary>
    FDeviceDefinition: TMacroKeyboardDeviceDefinition;
    /// <summary>Protocol adapter selected by the active device definition.</summary>
    FProtocol: IMacroKeyboardProtocol;
    /// <summary>
    ///   Debounces Windows device-change notifications on the main thread.
    /// </summary>
    FUSBUpdateTimer: TTimer;

    /// <summary>
    ///   Macro Keyboard connected flag
    /// </summary>
    FConnected: Boolean;
    /// <summary>
    ///   "Old" window state used in WndProc
    /// </summary>
    FOldWindowState: TWindowState;
    /// <summary>
    ///   Remember zoom level
    /// </summary>
    FRememberZoomLevel: Boolean;
    /// <summary>
    ///   Minimize to tray icon
    /// </summary>
    FMinimizeToTray: Boolean;
    /// <summary>
    ///   Load last opened config on application start
    /// </summary>
    FLoadLastOpenedConfigOnStart: Boolean;
    /// <summary>
    ///   Set macro keys on opening configuration file
    /// </summary>
    FSetMacroKeysOnOpenConfig: Boolean;
    /// <summary>
    ///   Remember window position
    /// </summary>
    FRememberWindowPosition: Boolean;
    /// <summary>
    ///   Remember window state
    /// </summary>
    FRememberWindowState: Boolean;

    /// <summary>
    ///   Set Macro Keyboard connected flag
    /// </summary>
    procedure SetConnected(const Connected: Boolean);
    /// <summary>
    ///   Refreshes the HID device selection and connection status.
    /// </summary>
    procedure RefreshHIDConnection;
    /// <summary>
    ///   Schedules a debounced HID device refresh.
    /// </summary>
    procedure ScheduleHIDRefresh;
    /// <summary>
    ///   Handles the delayed HID device refresh on the main thread.
    /// </summary>
    procedure USBUpdateTimerTimer(Sender: TObject);
    /// <summary>
    ///   Confirms whether unsaved configuration changes may be discarded.
    /// </summary>
    /// <returns>True when the pending operation may continue.</returns>
    function ConfirmSaveChanges: Boolean;
    /// <summary>
    ///   Programs every entry in the current configuration to the device.
    /// </summary>
    /// <returns>True when all entries were written successfully.</returns>
    function ProgramConfiguration: Boolean;
    /// <summary>Returns whether the loaded layout matches the supported CH552 action mapping.</summary>
    function SupportsCurrentProgrammingLayout: Boolean;
    /// <summary>Loads a device definition, its protocol adapter, and associated layout.</summary>
    procedure LoadDeviceDefinition(const FileName: string);
    /// <summary>Finds the active mapping for the selected visual control and action.</summary>
    function SelectedAction(const Action: TMacroKeyboardActionKind):
      TMacroKeyboardActionMapping;
    /// <summary>Programs one mapped action and reports transport errors.</summary>
    function ProgramMappedAction(const Mapping: TMacroKeyboardActionMapping): Boolean;
    /// <summary>Clears one mapped action and reports transport errors.</summary>
    function ClearMappedAction(const Mapping: TMacroKeyboardActionMapping): Boolean;
    /// <summary>
    ///   On USB Device Arrival
    /// </summary>
    procedure OnUSBArrival(Sender: TObject);
    /// <summary>
    ///   On USB Device Removal
    /// </summary>
    procedure OnUSBRemoval(Sender: TObject);
    /// <summary>
    ///   On Window Minimize
    /// </summary>
    procedure OnMinimize(Sender: TObject);
  protected
    /// <summary>
    ///   Override WndProc method
    /// </summary>
    procedure WndProc(var Msg: TMessage); override;
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
    ///   Macro Keyboard connected flag
    /// </summary>
    property Connected: Boolean read FConnected write SetConnected;
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.dfm}

uses untKeyMacro, untKnobMacro, untSettings;

const
  /// <summary>
  ///   Application Title
  /// </summary>
  ApplicationTitle = 'Macro Keyboard';
  /// <summary>
  ///   Confirm save message
  /// </summary>
  ConfirmSaveMessage: string = 'You have unsaved changes. Do you want to save them first?';
  /// <summary>
  ///   Not connected message
  /// </summary>
  NotConnectedMessage: string = 'The Macro Keyboard is not connected!';
  /// <summary>
  ///   HID Device Arrival/Removal delay
  /// </summary>
  USBUpdateDelay: Integer = 500;

//------------------------------------------------------------------------------
// SET CONNECTED FLAG
//------------------------------------------------------------------------------
procedure TfrmMain.SetConnected(const Connected: Boolean);
begin
  if (FConnected <> Connected) then
  begin
    // Update connected flag
    FConnected := Connected;
    // Update statusbar panel indicator
    StatusBar.Panels[0].Text := IfThen(FConnected, 'Connected', 'Not Connected');
    // Update the trayicon hint
    TrayIcon.Hint := Format('%s - %s', [ApplicationTitle, IfThen(FConnected, 'Connected', 'Not Connected')]);
  end;
end;

//------------------------------------------------------------------------------
// REFRESH HID CONNECTION
//------------------------------------------------------------------------------
procedure TfrmMain.RefreshHIDConnection;
var
  I: Integer;
begin
  FHIDDevice := nil;
  if Assigned(FHID) and Assigned(FDeviceDefinition) and FHID.Refresh then
    for I := 0 to FHID.Count - 1 do
      if FDeviceDefinition.Match.Matches(FHID[I]) then
      begin
        FHIDDevice := FHID[I];
        Break;
      end;
  Connected := Assigned(FHIDDevice);
end;

//------------------------------------------------------------------------------
// SCHEDULE HID REFRESH
//------------------------------------------------------------------------------
procedure TfrmMain.ScheduleHIDRefresh;
begin
  if Assigned(FUSBUpdateTimer) then
  begin
    // Restart the timer so a burst of notifications causes only one refresh.
    FUSBUpdateTimer.Enabled := False;
    FUSBUpdateTimer.Enabled := True;
  end;
end;

//------------------------------------------------------------------------------
// HID REFRESH TIMER
//------------------------------------------------------------------------------
procedure TfrmMain.USBUpdateTimerTimer(Sender: TObject);
begin
  FUSBUpdateTimer.Enabled := False;
  RefreshHIDConnection;
end;

//------------------------------------------------------------------------------
// CONFIRM SAVE CHANGES
//------------------------------------------------------------------------------
function TfrmMain.ConfirmSaveChanges: Boolean;
begin
  Result := True;
  if not MacroKeyboardConfig.Modified then Exit;

  case Application.MessageBox(PChar(ConfirmSaveMessage), PChar(ApplicationTitle),
    MB_ICONQUESTION + MB_YESNOCANCEL) of
    ID_YES:
      begin
        if FileExists(MacroKeyboardConfig.FileName) then
          MacroKeyboardConfig.SaveToFile(MacroKeyboardConfig.FileName)
        else
          acSaveAs.Execute;
        Result := not MacroKeyboardConfig.Modified;
      end;
    ID_NO:
      Result := True;
  else
    Result := False;
  end;
end;

//------------------------------------------------------------------------------
// PROGRAM CURRENT CONFIGURATION
//------------------------------------------------------------------------------
function TfrmMain.ProgramConfiguration: Boolean;
var
  ErrorMessage: string;
begin
  Result := False;
  if not Connected or not Assigned(FHIDDevice) then Exit;
  if not SupportsCurrentProgrammingLayout then
  begin
    Application.MessageBox(PChar(
      'The active visual layout does not have a compatible HID protocol definition.'),
      PChar(ApplicationTitle), MB_ICONWARNING + MB_OK);
    Exit;
  end;
  if not Assigned(FProtocol) then
  begin
    Application.MessageBox(PChar('No protocol adapter is available for this device.'),
      PChar(ApplicationTitle), MB_ICONERROR + MB_OK);
    Exit;
  end;
  Result := FProtocol.ProgramDevice(CreateHIDTransport(FHIDDevice),
    MacroKeyboardConfig, FDeviceDefinition, ErrorMessage);
  if not Result then
    Application.MessageBox(PChar(ErrorMessage), PChar(ApplicationTitle),
      MB_ICONERROR + MB_OK);
end;

//------------------------------------------------------------------------------
// CHECK PROGRAMMING LAYOUT SUPPORT
//------------------------------------------------------------------------------
function TfrmMain.SupportsCurrentProgrammingLayout: Boolean;
var
  I: Integer;
begin
  Result := Assigned(FDeviceDefinition) and Assigned(FProtocol) and
    FDeviceDefinition.SupportsLayout(MacroKeyboard.Layout);
  if not Result then Exit;
  for I := 0 to FDeviceDefinition.ActionCount - 1 do
    if (FDeviceDefinition[I].ProfileIndex < 0) or
      (FDeviceDefinition[I].ProfileIndex >= MacroKeyboardConfig.Keys.Count) then
      Exit(False);
end;

//------------------------------------------------------------------------------
// LOAD DEVICE DEFINITION
//------------------------------------------------------------------------------
procedure TfrmMain.LoadDeviceDefinition(const FileName: string);
var
  Definition: TMacroKeyboardDeviceDefinition;
  LayoutFileName: string;
  Protocol: IMacroKeyboardProtocol;
begin
  Definition := TMacroKeyboardDeviceDefinition.Create;
  try
    Definition.LoadFromFile(FileName);
    Protocol := CreateMacroKeyboardProtocol(Definition.ProtocolID);
    if not Assigned(Protocol) then
      raise EInvalidOperation.CreateFmt('Protocol "%s" is not implemented.',
        [Definition.ProtocolID]);
    LayoutFileName := Definition.ResolveLayoutFile;
    MacroKeyboard.LoadLayoutFromFile(LayoutFileName);
    FDeviceDefinition.Assign(Definition);
    FProtocol := Protocol;
    MacroKeyboard.SelectedIndex := -1;
    Caption := Format('%s - %s', [ApplicationTitle, Definition.Name]);
    RefreshHIDConnection;
  finally
    Definition.Free;
  end;
end;

//------------------------------------------------------------------------------
// GET SELECTED ACTION MAPPING
//------------------------------------------------------------------------------
function TfrmMain.SelectedAction(const Action: TMacroKeyboardActionKind):
  TMacroKeyboardActionMapping;
begin
  Result := nil;
  if not Assigned(FDeviceDefinition) or
    (MacroKeyboard.SelectedIndex < 0) or
    (MacroKeyboard.SelectedIndex >= MacroKeyboard.Layout.Count) then Exit;
  Result := FDeviceDefinition.FindAction(
    MacroKeyboard.ControlID(MacroKeyboard.SelectedIndex), Action);
  if Assigned(Result) and ((Result.ProfileIndex < 0) or
    (Result.ProfileIndex >= MacroKeyboardConfig.Keys.Count)) then
    Result := nil;
end;

//------------------------------------------------------------------------------
// PROGRAM ONE MAPPED ACTION
//------------------------------------------------------------------------------
function TfrmMain.ProgramMappedAction(
  const Mapping: TMacroKeyboardActionMapping): Boolean;
var
  ErrorMessage: string;
begin
  Result := False;
  if not Assigned(Mapping) or not Assigned(FProtocol) then Exit;
  if not Connected or not Assigned(FHIDDevice) then
  begin
    Application.MessageBox(PChar(NotConnectedMessage), PChar(ApplicationTitle),
      MB_ICONWARNING + MB_OK);
    Exit;
  end;
  Result := FProtocol.ProgramAction(CreateHIDTransport(FHIDDevice),
    MacroKeyboardConfig.Keys[Mapping.ProfileIndex], Mapping, ErrorMessage);
  if not Result then
    Application.MessageBox(PChar(ErrorMessage), PChar(ApplicationTitle),
      MB_ICONERROR + MB_OK);
end;

//------------------------------------------------------------------------------
// CLEAR ONE MAPPED ACTION
//------------------------------------------------------------------------------
function TfrmMain.ClearMappedAction(
  const Mapping: TMacroKeyboardActionMapping): Boolean;
var
  ErrorMessage: string;
begin
  Result := False;
  if not Assigned(Mapping) or not Assigned(FProtocol) then Exit;
  if not Connected or not Assigned(FHIDDevice) then
  begin
    Application.MessageBox(PChar(NotConnectedMessage), PChar(ApplicationTitle),
      MB_ICONWARNING + MB_OK);
    Exit;
  end;
  Result := FProtocol.ClearAction(CreateHIDTransport(FHIDDevice), Mapping,
    ErrorMessage);
  if not Result then
    Application.MessageBox(PChar(ErrorMessage), PChar(ApplicationTitle),
      MB_ICONERROR + MB_OK);
end;

//------------------------------------------------------------------------------
// ON USB ARRIVAL
//------------------------------------------------------------------------------
procedure TfrmMain.OnUSBArrival(Sender: TObject);
begin
  ScheduleHIDRefresh;
end;

//------------------------------------------------------------------------------
// ON USB REMOVAL
//------------------------------------------------------------------------------
procedure TfrmMain.OnUSBRemoval(Sender: TObject);
begin
  // Prevent new writes through a device that Windows has just removed.
  FHIDDevice := nil;
  Connected := False;
  ScheduleHIDRefresh;
end;

//------------------------------------------------------------------------------
// ON APPLICATION MINIMIZE
//------------------------------------------------------------------------------
procedure TfrmMain.OnMinimize(Sender: TObject);
begin
  if FMinimizeToTray and TrayIcon.Visible then
  begin
    // Hide the window
    Hide;
    // Minimize the window
    WindowState := wsMinimized;
  end;
end;

//------------------------------------------------------------------------------
// WNDPROC HANDLER
//------------------------------------------------------------------------------
procedure TfrmMain.WndProc(var Msg: TMessage);
begin
  // Call inherited WndProc
  inherited WndProc(Msg);

  // Handle window messages that we need to repaint the MacroKeyboard
  // control. This is because when the window is Maximized or Restored
  // there is no resize handler called and the buffer of the control is not updated.
  if Msg.Msg = WM_WINDOWPOSCHANGED then
  begin
    // Check if the window state changed
    if (FOldWindowState <> WindowState) then
    begin
      // Update window state for next event, as we only need to repaint the
      // controls when the window state changed.
      FOldWindowState := WindowState;
      // Repaint the MacroKeyboard control
      RepaintTimer.Enabled := True;
    end;
  end;
end;

//------------------------------------------------------------------------------
// LOAD SETTINGS FROM REGISTRY
//------------------------------------------------------------------------------
procedure TfrmMain.LoadSettings;

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

  function ReadIntegerDefault(const Reg: TRegistry; const Name: string; const Default: Integer): Integer;
  begin
    try
      if Reg.ValueExists(Name) then
        Result := Reg.ReadInteger(Name)
      else
        Result := Default;
    except
      Result := Default;
    end;
  end;

var
  Reg: TRegistry;
  LastOpenedConfig: string;
  X, Y, W, H, S: Integer;
begin
  Reg := TRegistry.Create;
  try
    // Set root key
    Reg.RootKey := RootKey;
    // Open registry key
    if Reg.OpenKeyReadOnly(RegKey) then
    begin
      // Zoom
      MacroKeyboard.ZoomOnScroll := ReadBoolDefault(Reg, 'ZoomOnScroll', True);
      FRememberZoomLevel := ReadBoolDefault(Reg, 'RememberZoomLevel', True);
      // Hints
      MacroKeyboard.ShowKeyHint := ReadBoolDefault(Reg, 'ShowKeyKnobHint', True);
      // Tray Icon
      TrayIcon.Visible := ReadBoolDefault(Reg, 'TrayIconVisible', True);
      FMinimizeToTray := ReadBoolDefault(Reg, 'MinimizeToTray', True);
      // Config
      FLoadLastOpenedConfigOnStart := ReadBoolDefault(Reg, 'LoadLastOpenedConfigOnStart', True);
      FSetMacroKeysOnOpenConfig := ReadBoolDefault(Reg, 'SetMacroKeysOnOpenConfig', True);
      // Window
      FRememberWindowPosition := ReadBoolDefault(Reg, 'RememberWindowPosition', True);
      FRememberWindowState := ReadBoolDefault(Reg, 'RememberWindowState', True);

      // Recover zoom level
      if FRememberZoomLevel then MacroKeyboard.Zoom := ReadIntegerDefault(Reg, 'ZoomLevel', 100);

      // Recover window position
      if FRememberWindowPosition then
      begin
        X := ReadIntegerDefault(Reg, 'WindowLeft', -100);
        Y := ReadIntegerDefault(Reg, 'WindowTop', -100);
        W := ReadIntegerDefault(Reg, 'WindowWidth', 0);
        H := ReadIntegerDefault(Reg, 'WindowHeight', 0);
        if (X <> -100) and (Y <> -100) and (W > 0) and (H > 0) then
        begin
          Left   := X;
          Top    := Y;
          Width  := W;
          Height := H;
        end;
      end;

      // Recover window state
      if FRememberWindowState then
      begin
        S := ReadIntegerDefault(Reg, 'WindowState', -1);
        if (S > -1) then WindowState := TWindowState(S);
      end;

      // Load last opened config
      if FLoadLastOpenedConfigOnStart then
      begin
        if Reg.ValueExists('LastOpenedConfig') then
        begin
          LastOpenedConfig := Reg.ReadString('LastOpenedConfig');
          if FileExists(LastOpenedConfig) then
          try
            MacroKeyboardConfig.LoadFromFile(LastOpenedConfig);
          except
            on E: Exception do
              Application.MessageBox(PChar(Format(
                'The last configuration could not be loaded:%s%s',
                [sLineBreak, E.Message])), PChar(ApplicationTitle),
                MB_ICONWARNING + MB_OK);
          end;
        end;
      end;
    end else
    begin
      // Zoom
      MacroKeyboard.ZoomOnScroll := True;
      FRememberZoomLevel := True;
      // Hints
      MacroKeyboard.ShowKeyHint := True;
      // Tray Icon
      TrayIcon.Visible := True;
      FMinimizeToTray := True;
      // Config
      FLoadLastOpenedConfigOnStart := True;
      FSetMacroKeysOnOpenConfig := True;
      // Window
      FRememberWindowPosition := True;
      FRememberWindowState := True;
    end;
  finally
    Reg.Free;
  end;
end;

//------------------------------------------------------------------------------
// SAVE SETTINGS TO REGISTRY
//------------------------------------------------------------------------------
procedure TfrmMain.SaveSettings;
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
      // Save zoom level
      if FRememberZoomLevel then Reg.WriteInteger('ZoomLevel', MacroKeyboard.Zoom);

      // Save window position
      // Note: Only when windowstate is normal, otherwise if maximized or minimized
      //       the width/height and position are not correct.
      if FRememberWindowPosition and (WindowState = wsNormal) then
      begin
        Reg.WriteInteger('WindowLeft', Left);
        Reg.WriteInteger('WindowTop', Top);
        Reg.WriteInteger('WindowWidth', Width);
        Reg.WriteInteger('WindowHeight', Height);
      end;

      // Save window state
      if FRememberWindowState then Reg.WriteInteger('WindowState', Integer(WindowState));

      // Save last opened config
      if FLoadLastOpenedConfigOnStart and FileExists(MacroKeyboardConfig.FileName) then
        Reg.WriteString('LastOpenedConfig', MacroKeyboardConfig.FileName);
    end
  finally
    Reg.Free;
  end;
end;

//------------------------------------------------------------------------------
// ON KEY OR ROTARY ENCODER SELECT
//------------------------------------------------------------------------------
procedure TfrmMain.MacroKeyboardSelect(Sender: TObject; Index: Integer);
begin
  // Enable/Disable menu items
  Key1.Enabled := SupportsCurrentProgrammingLayout and
    Assigned(SelectedAction(makPress));
  Knob1.Enabled := SupportsCurrentProgrammingLayout and
    (Assigned(SelectedAction(makClockwise)) or
     Assigned(SelectedAction(makCounterClockwise)) or
     Assigned(SelectedAction(makEncoderClick)));
end;

//------------------------------------------------------------------------------
// ON REPAINT TIMER
//------------------------------------------------------------------------------
procedure TfrmMain.RepaintTimerTimer(Sender: TObject);
begin
  // Set disabled
  RepaintTimer.Enabled := False;
  // Repaint control
  MacroKeyboard.Repaint;
end;

//------------------------------------------------------------------------------
// ON FORM CREATE
//------------------------------------------------------------------------------
procedure TfrmMain.FormCreate(Sender: TObject);
begin
  // Load settings
  LoadSettings;
  // Create the built-in definition and protocol before discovering devices.
  FDeviceDefinition := TMacroKeyboardDeviceDefinition.Create;
  FDeviceDefinition.CreateDefaultCH552;
  FDeviceDefinition.Validate;
  FProtocol := CreateMacroKeyboardProtocol(FDeviceDefinition.ProtocolID);
  // Create HID device list
  FHID := THIDDeviceList.Create;
  // Create the main-thread debounce timer for device notifications.
  FUSBUpdateTimer := TTimer.Create(Self);
  FUSBUpdateTimer.Enabled := False;
  FUSBUpdateTimer.Interval := USBUpdateDelay;
  FUSBUpdateTimer.OnTimer := USBUpdateTimerTimer;
  // Assign on arrival event handler
  FHID.OnUSBArrival := OnUSBArrival;
  // Assign on removal event handler
  FHID.OnUSBRemoval := OnUSBRemoval;
  // Find the macro keyboard and update the connection state.
  RefreshHIDConnection;
  // Set Caption
  Caption := ApplicationTitle;
  // Set Title
  Application.Title := ApplicationTitle;
  // Set tray icon title
  TrayIcon.Hint := Format('%s - %s', [ApplicationTitle, IfThen(FConnected, 'Connected', 'Not Connected')]);
  // Assign application minimize event handler
  Application.OnMinimize := OnMinimize;
end;

//------------------------------------------------------------------------------
// ON FORM DESTROY
//------------------------------------------------------------------------------
procedure TfrmMain.FormDestroy(Sender: TObject);
begin
  Application.OnMinimize := nil;
  if Assigned(FUSBUpdateTimer) then
    FUSBUpdateTimer.Enabled := False;
  if Assigned(FHID) then
  begin
    FHID.OnUSBArrival := nil;
    FHID.OnUSBRemoval := nil;
  end;
  FHIDDevice := nil;
  FProtocol := nil;
  // Destroy HID device list
  FreeAndNil(FHID);
  FreeAndNil(FDeviceDefinition);
end;

//------------------------------------------------------------------------------
// ABOUT
//------------------------------------------------------------------------------
procedure TfrmMain.acAboutExecute(Sender: TObject);
const
  AboutTitle   : string = 'Macro Keyboard Utility Software';
  AboutText    : string = 'This is a utility software for programming a 12 Key 3 Knob Macro Keyboard that uses a CH57 chip.' + sLineBreak + sLineBreak +
                          'These keyboards are commonly found on Amazon and AliExpress.' + sLineBreak + sLineBreak +
                          'This software might work with other Macro Keyboards too, but they are not directly supported.' + sLineBreak + sLineBreak +
                          'Copyright © ERDesigns - Ernst Reidinga.';
  AboutVersion : string = 'Version 1.0 (May 2024)';
begin
  AboutDialog.Caption      := ApplicationTitle;
  AboutDialog.Title        := AboutTitle;
  AboutDialog.Text         := AboutText;
  AboutDialog.ExpandedText := AboutVersion;
  AboutDialog.Execute(Handle);
end;

//------------------------------------------------------------------------------
// NEW CONFIG
//------------------------------------------------------------------------------
procedure TfrmMain.acNewExecute(Sender: TObject);
begin
  if not ConfirmSaveChanges then Exit;

  // New configuration
  MacroKeyboardConfig.New;
  // Clear selected key/knob
  MacroKeyboard.SelectedIndex := -1;
end;

//------------------------------------------------------------------------------
// OPEN ACCEPT
//------------------------------------------------------------------------------
procedure TfrmMain.acOpenAccept(Sender: TObject);
begin
  if not ConfirmSaveChanges then Exit;

  // Open the configuration from the file
  MacroKeyboardConfig.LoadFromFile(acOpen.Dialog.FileName);

  if FSetMacroKeysOnOpenConfig then
  begin
    if Connected then
      ProgramConfiguration
    else
      Application.MessageBox(PChar(NotConnectedMessage), PChar(ApplicationTitle),
        MB_ICONWARNING + MB_OK);
  end;
end;

//------------------------------------------------------------------------------
// OPEN VISUAL LAYOUT
//------------------------------------------------------------------------------
procedure TfrmMain.acOpenLayoutAccept(Sender: TObject);
begin
  MacroKeyboard.LoadLayoutFromFile(acOpenLayout.Dialog.FileName);
  MacroKeyboard.SelectedIndex := -1;
  Caption := Format('%s - %s', [ApplicationTitle, MacroKeyboard.Layout.Name]);
  if not SupportsCurrentProgrammingLayout then
    Application.MessageBox(PChar(
      'This layout can be previewed and navigated, but it has no compatible HID protocol definition yet. Device programming is disabled.'),
      PChar(ApplicationTitle), MB_ICONINFORMATION + MB_OK);
end;

//------------------------------------------------------------------------------
// OPEN DEVICE DEFINITION
//------------------------------------------------------------------------------
procedure TfrmMain.acOpenDeviceDefinitionAccept(Sender: TObject);
begin
  LoadDeviceDefinition(acOpenDeviceDefinition.Dialog.FileName);
end;

//------------------------------------------------------------------------------
// EXPORT SANITIZED DIAGNOSTICS
//------------------------------------------------------------------------------
procedure TfrmMain.acExportDiagnosticsAccept(Sender: TObject);
begin
  TMacroKeyboardDiagnostics.SaveToFile(acExportDiagnostics.Dialog.FileName,
    FHID, FDeviceDefinition, False);
end;

//------------------------------------------------------------------------------
// SAVE
//------------------------------------------------------------------------------
procedure TfrmMain.acSaveExecute(Sender: TObject);
begin
  // if the file exists, save it
  if FileExists(MacroKeyboardConfig.FileName) then
    MacroKeyboardConfig.SaveToFile(MacroKeyboardConfig.FileName)
  else
    // Otherwise execute the save as dialog
    acSaveAs.Execute;
end;

//------------------------------------------------------------------------------
// SAVE AS
//------------------------------------------------------------------------------
procedure TfrmMain.acSaveAsAccept(Sender: TObject);
begin
  MacroKeyboardConfig.SaveToFile(acSaveAs.Dialog.FileName);
end;

//------------------------------------------------------------------------------
// EXIT
//------------------------------------------------------------------------------
procedure TfrmMain.acExitExecute(Sender: TObject);
begin
  Close;
end;

//------------------------------------------------------------------------------
// FORM CLOSE QUERY
//------------------------------------------------------------------------------
procedure TfrmMain.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose := ConfirmSaveChanges;
  if CanClose then
    SaveSettings;
end;

//------------------------------------------------------------------------------
// CONFIGURATION FILENAME CHANGED
//------------------------------------------------------------------------------
procedure TfrmMain.MacroKeyboardConfigFilename(Sender: TObject; Filename: string);
begin
  // Set the filename in the statusbar
  StatusBar.Panels[1].Text := Filename;
end;

//------------------------------------------------------------------------------
// ZOOM IN
//------------------------------------------------------------------------------
procedure TfrmMain.acZoomInExecute(Sender: TObject);
begin
  MacroKeyboard.Zoom := MacroKeyboard.Zoom + 10;
end;

//------------------------------------------------------------------------------
// ZOOM OUT
//------------------------------------------------------------------------------
procedure TfrmMain.acZoomOutExecute(Sender: TObject);
begin
  MacroKeyboard.Zoom := MacroKeyboard.Zoom - 10;
end;

//------------------------------------------------------------------------------
// ZOOM 100%
//------------------------------------------------------------------------------
procedure TfrmMain.acZoom100Execute(Sender: TObject);
begin
  MacroKeyboard.Zoom := 100;
end;

//------------------------------------------------------------------------------
// SET KEY MACRO
//------------------------------------------------------------------------------
procedure TfrmMain.acSetMacroKeyExecute(Sender: TObject);
var
  Mapping: TMacroKeyboardActionMapping;
begin
  Mapping := SelectedAction(makPress);
  if Assigned(Mapping) and
    (frmKeyMacro.Execute(MacroKeyboard.SelectedIndex,
      MacroKeyboardConfig.Keys[Mapping.ProfileIndex]) = MROK) then
  begin
    // Update the macro key
    frmKeyMacro.UpdateMacroKey(MacroKeyboardConfig.Keys[Mapping.ProfileIndex]);
    ProgramMappedAction(Mapping);
  end;
end;

//------------------------------------------------------------------------------
// SET KNOB MACRO - CLOCKWISE
//------------------------------------------------------------------------------
procedure TfrmMain.acSetMacroKnobCExecute(Sender: TObject);
var
  Mapping: TMacroKeyboardActionMapping;
begin
  Mapping := SelectedAction(makClockwise);
  if Assigned(Mapping) and
    (frmKnobMacro.Execute(MacroKeyboard.SelectedIndex,
      MacroKeyboardConfig.Keys[Mapping.ProfileIndex], 'Clockwise') = MROK) then
  begin
    frmKnobMacro.UpdateMacroKey(MacroKeyboardConfig.Keys[Mapping.ProfileIndex]);
    ProgramMappedAction(Mapping);
  end;
end;

//------------------------------------------------------------------------------
// SET KNOB MACRO - COUNTER CLOCKWISE
//------------------------------------------------------------------------------
procedure TfrmMain.acSetMacroKnobCCExecute(Sender: TObject);
var
  Mapping: TMacroKeyboardActionMapping;
begin
  Mapping := SelectedAction(makCounterClockwise);
  if Assigned(Mapping) and
    (frmKnobMacro.Execute(MacroKeyboard.SelectedIndex,
      MacroKeyboardConfig.Keys[Mapping.ProfileIndex], 'Counter Clockwise') = MROK) then
  begin
    frmKnobMacro.UpdateMacroKey(MacroKeyboardConfig.Keys[Mapping.ProfileIndex]);
    ProgramMappedAction(Mapping);
  end;
end;

//------------------------------------------------------------------------------
// SET KNOB MACRO - CLICK
//------------------------------------------------------------------------------
procedure TfrmMain.acSetMacroKnobExecute(Sender: TObject);
var
  Mapping: TMacroKeyboardActionMapping;
begin
  Mapping := SelectedAction(makEncoderClick);
  if Assigned(Mapping) and
    (frmKnobMacro.Execute(MacroKeyboard.SelectedIndex,
      MacroKeyboardConfig.Keys[Mapping.ProfileIndex], 'Click') = MROK) then
  begin
    frmKnobMacro.UpdateMacroKey(MacroKeyboardConfig.Keys[Mapping.ProfileIndex]);
    ProgramMappedAction(Mapping);
  end;
end;

//------------------------------------------------------------------------------
// ON KEY / KNOB HINT
//------------------------------------------------------------------------------
procedure TfrmMain.MacroKeyboardKeyKnobHint(Sender: TObject; Index: Integer; var Hint: string);
var
  Mapping: TMacroKeyboardActionMapping;

  procedure AppendActionName(const Action: TMacroKeyboardActionKind);
  begin
    Mapping := FDeviceDefinition.FindAction(MacroKeyboard.ControlID(Index), Action);
    if Assigned(Mapping) and (Mapping.ProfileIndex < MacroKeyboardConfig.Keys.Count) then
    begin
      if Hint <> '' then Hint := Hint + ' - ';
      Hint := Hint + MacroKeyboardConfig.Keys[Mapping.ProfileIndex].Name;
    end;
  end;
begin
  Hint := '';
  if not Assigned(FDeviceDefinition) or (Index < 0) or
    (Index >= MacroKeyboard.Layout.Count) then Exit;
  AppendActionName(makPress);
  AppendActionName(makClockwise);
  AppendActionName(makCounterClockwise);
  AppendActionName(makEncoderClick);
end;

//------------------------------------------------------------------------------
// SETTINGS
//------------------------------------------------------------------------------
procedure TfrmMain.acSettingsExecute(Sender: TObject);
begin
  if (frmSettings.Execute = MROK) then
  begin
    // Save settings to registry
    frmSettings.SaveSettings;
    // Load settings here
    LoadSettings;
  end;
end;

//------------------------------------------------------------------------------
// ON TRAYICON DOUBLE CLICK
//------------------------------------------------------------------------------
procedure TfrmMain.TrayIconDblClick(Sender: TObject);
begin
  if not Visible then
  begin
    // Show the form
    Show;
    // Restore the window state to normal
    WindowState := wsNormal;
    // Restore application
    Application.Restore;
    // Bring application to foreground
    Application.BringToFront
  end;
end;

//------------------------------------------------------------------------------
// ON MACRO KEYBOARD COMPONENT KEYPRESS
//------------------------------------------------------------------------------
procedure TfrmMain.MacroKeyboardKeyPress(Sender: TObject; Index: Integer;
  Key: Word; Shift: TShiftState);
begin
  if Assigned(SelectedAction(makPress)) then
  begin
    if (Key = VK_RETURN) then acSetMacroKey.Execute;
    if (Key = VK_DELETE) then acClearKey.Execute;
  end;
  if Assigned(SelectedAction(makClockwise)) or
    Assigned(SelectedAction(makCounterClockwise)) or
    Assigned(SelectedAction(makEncoderClick)) then
  begin
    if (Key = VK_RETURN) then
    begin
      if Shift = [ssCtrl] then acSetMacroKnobC.Execute;
      if Shift = [ssAlt] then acSetMacroKnobCC.Execute;
      if Shift = [] then acSetMacroKnob.Execute;
    end;
    if (Key = VK_DELETE) then acClearKnob.Execute;
  end;
end;

//------------------------------------------------------------------------------
// CLEAR KEY MACRO
//------------------------------------------------------------------------------
procedure TfrmMain.acClearKeyExecute(Sender: TObject);
var
  Mapping: TMacroKeyboardActionMapping;
begin
  Mapping := SelectedAction(makPress);
  if Assigned(Mapping) then ClearMappedAction(Mapping);
end;

//------------------------------------------------------------------------------
// CLEAR KNOB MACRO
//------------------------------------------------------------------------------
procedure TfrmMain.acClearKnobExecute(Sender: TObject);
begin
  if not Connected then
  begin
    Application.MessageBox(PChar(NotConnectedMessage), PChar(ApplicationTitle),
      MB_ICONWARNING + MB_OK);
    Exit;
  end;
  ClearMappedAction(SelectedAction(makClockwise));
  ClearMappedAction(SelectedAction(makCounterClockwise));
  ClearMappedAction(SelectedAction(makEncoderClick));
end;

end.
