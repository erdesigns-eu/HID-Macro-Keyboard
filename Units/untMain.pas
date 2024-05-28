unit untMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.ComCtrls,
  Vcl.StdCtrls, Vcl.Menus, Vcl.StdActns, System.Actions, Vcl.ActnList, System.UITypes,
  System.Win.Registry, System.StrUtils, System.Threading,

  HID, HID.MacroKeyboard.Component, HID.MacroKeyboard.Config, HID.MacroKeyboard;

type
  TfrmMain = class(TForm)
    MacroKeyboard: TMacroKeyboard;
    StatusBar: TStatusBar;
    ActionList: TActionList;
    acNew: TAction;
    MainMenu: TMainMenu;
    acOpen: TFileOpen;
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
    procedure MacroKeyboardSelect(Sender: TObject; Index: Integer);
    procedure RepaintTimerTimer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure acAboutExecute(Sender: TObject);
    procedure acNewExecute(Sender: TObject);
    procedure acOpenAccept(Sender: TObject);
    procedure acOpenBeforeExecute(Sender: TObject);
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
  ConfirmSaveMessage: string = 'You have unsafed changes, do you want to save them first?';
  /// <summary>
  ///   Not connected message
  /// </summary>
  NotConnectedMessage: string = 'The Macro Keyboard is not connected!';
  /// <summary>
  ///   Failed to set Macro message
  /// </summary>
  FailedSetMacroMessage: string = 'Failed to set Macro. Error code: %d, %s';
  /// <summary>
  ///   HID Device Product String
  /// </summary>
  ProductString: string = 'CH552';
  /// <summary>
  ///   HID Device Interface Number
  /// </summary>
  InterfaceNumber: Integer = 1;
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
// ON USB ARRIVAL
//------------------------------------------------------------------------------
procedure TfrmMain.OnUSBArrival(Sender: TObject);
begin
  if not Connected then
  TTask.Run(
    procedure
    begin
      // Wait for windows to update the device list
      Sleep(USBUpdateDelay);
      // Try to find the macro keyboard
      FHIDDevice := FHID.FindDevice(ProductString, InterfaceNumber);
      // Update connected flag
      Connected := FHIDDevice <> nil;
    end
  );
end;

//------------------------------------------------------------------------------
// ON USB REMOVAL
//------------------------------------------------------------------------------
procedure TfrmMain.OnUSBRemoval(Sender: TObject);
begin
  if Connected then
  TTask.Run(
    procedure
    begin
      // Wait for windows to update the device list
      Sleep(USBUpdateDelay);
      // Try to find the macro keyboard
      FHIDDevice := FHID.FindDevice(ProductString, InterfaceNumber);
      // Update connected flag
      Connected := FHIDDevice <> nil;
    end
  );
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
        // Open the configuration from the file
        if Reg.ValueExists('LastOpenedConfig') then MacroKeyboardConfig.LoadFromFile(Reg.ReadString('LastOpenedConfig'));
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
  Key1.Enabled := (Index >= 0) and (Index <= 11);
  Knob1.Enabled := (Index >= 12) and (Index <= 14);
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
  // Create HID device list
  FHID := THIDDeviceList.Create;
  // Assign on arrival event handler
  FHID.OnUSBArrival := OnUSBArrival;
  // Assign on removal event handler
  FHID.OnUSBRemoval := OnUSBRemoval;
  // Try to find the macro keyboard
  FHIDDevice := FHID.FindDevice(ProductString, InterfaceNumber);
  // Update connected flag
  Connected := FHIDDevice <> nil;
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
  // Destroy HID device list
  FHID.Destroy;
end;

//------------------------------------------------------------------------------
// ABOUT
//------------------------------------------------------------------------------
procedure TfrmMain.acAboutExecute(Sender: TObject);
const
  AboutText: string = 'Macro Keyboard Utility Software by ERDesigns.' + sLineBreak + sLineBreak + 'Copyright © Ernst Reidinga.' + sLineBreak + 'V1.0 (25/05/2024)';
begin
  TaskMessageDlg(ApplicationTitle, AboutText, mtInformation, [mbOK], 0, mbOK);
end;

//------------------------------------------------------------------------------
// NEW CONFIG
//------------------------------------------------------------------------------
procedure TfrmMain.acNewExecute(Sender: TObject);
begin
  if MacroKeyboardConfig.Modified then
  begin
    case Application.MessageBox(PChar(ConfirmSaveMessage), PChar(ApplicationTitle), MB_ICONQUESTION + MB_YESNOCANCEL) of
      ID_YES:
      begin
        // if the file exists, save it
        if FileExists(MacroKeyboardConfig.FileName) then
          MacroKeyboardConfig.SaveToFile(MacroKeyboardConfig.FileName)
        else
          // Otherwise execute the save as dialog
          if not acSaveAs.Execute then Exit;
      end;

      ID_NO:
      begin
        // No need to save changes, do nothing here
      end;

      ID_CANCEL:
      begin
        // Exit here, dont create a new configuration
        Exit;
      end;
    end;
  end;

  // New configuration
  MacroKeyboardConfig.New;
  // Clear selected key/knob
  MacroKeyboard.SelectedIndex := -1;
end;

//------------------------------------------------------------------------------
// BEFORE OPEN
//------------------------------------------------------------------------------
procedure TfrmMain.acOpenBeforeExecute(Sender: TObject);
begin
  if MacroKeyboardConfig.Modified then
  case Application.MessageBox(PChar(ConfirmSaveMessage), PChar(ApplicationTitle), MB_ICONQUESTION + MB_YESNOCANCEL) of
    ID_YES:
    begin
      // if the file exists, save it
      if FileExists(MacroKeyboardConfig.FileName) then
        MacroKeyboardConfig.SaveToFile(MacroKeyboardConfig.FileName)
      else
        // Otherwise execute the save as dialog
        if not acSaveAs.Execute then Exit;
    end;

    ID_NO:
    begin
      // No need to save changes, do nothing here
    end;

    ID_CANCEL:
    begin
      // Exit here, dont create a new configuration
      Exit;
    end;
  end;
end;

//------------------------------------------------------------------------------
// OPEN ACCEPT
//------------------------------------------------------------------------------
procedure TfrmMain.acOpenAccept(Sender: TObject);
var
  I: Integer;
begin
  // Open the configuration from the file
  MacroKeyboardConfig.LoadFromFile(acOpen.Dialog.FileName);
  // Set Macro keys after opening config
  if FSetMacroKeysOnOpenConfig then
  begin
    //
  end;
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
  if MacroKeyboardConfig.Modified then
  case Application.MessageBox(PChar(ConfirmSaveMessage), PChar(ApplicationTitle), MB_ICONQUESTION + MB_YESNOCANCEL) of
    ID_YES:
    begin
      // if the file exists, save it
      if FileExists(MacroKeyboardConfig.FileName) then
        MacroKeyboardConfig.SaveToFile(MacroKeyboardConfig.FileName)
      else
        // Otherwise execute the save as dialog
        if not acSaveAs.Execute then Exit;
    end;

    ID_NO:
    begin
      // No need to save changes, do nothing here
    end;

    ID_CANCEL:
    begin
      // Dont close the form
      CanClose := False;
    end;
  end;

  // Save the settings
  SaveSettings;
  // If we make it until here we can close the form.
  CanClose := True;
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
  Macro: THIDMacro;
begin
  if (MacroKeyboard.SelectedIndex >= 0) and (MacroKeyboard.SelectedIndex <= 11) and (frmKeyMacro.Execute(MacroKeyboard.SelectedIndex, MacroKeyboardConfig.Keys[MacroKeyboard.SelectedIndex]) = MROK) then
  begin
    // Update the macro key
    frmKeyMacro.UpdateMacroKey(MacroKeyboardConfig.Keys[MacroKeyboard.SelectedIndex]);
    // Update the macro keyboard with the new macro key
    if Connected then
    begin
      if FHIDDevice.Open then
      begin
        Macro := MacroKeyboardConfig.Keys[MacroKeyboard.SelectedIndex].ToHIDMacro(MacroKeyboard.SelectedIndex + 1);
        if not FHIDDevice.Write(Macro) then showmessage(SysErrorMessage(GetLastError));
        FHIDDevice.Close;
      end;
    end else
      Application.MessageBox(PChar(NotConnectedMessage), PChar(ApplicationTitle), MB_ICONWARNING + MB_OK);
  end;
end;

//------------------------------------------------------------------------------
// SET KNOB MACRO - CLOCKWISE
//------------------------------------------------------------------------------
procedure TfrmMain.acSetMacroKnobCExecute(Sender: TObject);
var
  Index: Integer;
  Macro: THIDMacro;
begin
  Index := -1;
  if MacroKeyboard.SelectedIndex = 12 then Index := 12;
  if MacroKeyboard.SelectedIndex = 13 then Index := 15;
  if MacroKeyboard.SelectedIndex = 14 then Index := 18;
  if (Index >= 12) and (MacroKeyboard.SelectedIndex >= 12) and (MacroKeyboard.SelectedIndex <= 14) and (frmKnobMacro.Execute(MacroKeyboard.SelectedIndex, MacroKeyboardConfig.Keys[Index], 'Clockwise') = MROK) then
  begin
    // Update the macro key
    frmKnobMacro.UpdateMacroKey(MacroKeyboardConfig.Keys[Index]);
    // Update the macro keyboard with the new macro key
    if Connected then
    begin
      if FHIDDevice.Open then
      begin
        // Knob 1
        if MacroKeyboard.SelectedIndex = 12 then Macro := MacroKeyboardConfig.Keys[Index].ToHIDMacro(KEYBOARD_ROT1_RIGHT);
        // Knob 2
        if MacroKeyboard.SelectedIndex = 13 then Macro := MacroKeyboardConfig.Keys[Index].ToHIDMacro(KEYBOARD_ROT2_RIGHT);
        // Knob 3
        if MacroKeyboard.SelectedIndex = 14 then Macro := MacroKeyboardConfig.Keys[Index].ToHIDMacro(KEYBOARD_ROT3_RIGHT);

        if not FHIDDevice.Write(Macro) then Application.MessageBox(PChar(Format(FailedSetMacroMessage, [GetLastError, SysErrorMessage(GetLastError)])), PChar(ApplicationTitle), MB_ICONERROR + MB_OK);
        FHIDDevice.Close;
      end;
    end else
      Application.MessageBox(PChar(NotConnectedMessage), PChar(ApplicationTitle), MB_ICONWARNING + MB_OK);
  end;
end;

//------------------------------------------------------------------------------
// SET KNOB MACRO - COUNTER CLOCKWISE
//------------------------------------------------------------------------------
procedure TfrmMain.acSetMacroKnobCCExecute(Sender: TObject);
var
  Index: Integer;
  Macro: THIDMacro;
begin
  Index := -1;
  if MacroKeyboard.SelectedIndex = 12 then Index := 13;
  if MacroKeyboard.SelectedIndex = 13 then Index := 16;
  if MacroKeyboard.SelectedIndex = 14 then Index := 19;
  if (Index >= 13) and (MacroKeyboard.SelectedIndex >= 12) and (MacroKeyboard.SelectedIndex <= 14) and (frmKnobMacro.Execute(MacroKeyboard.SelectedIndex, MacroKeyboardConfig.Keys[Index], 'Counter Clockwise') = MROK) then
  begin
    // Update the macro key
    frmKnobMacro.UpdateMacroKey(MacroKeyboardConfig.Keys[Index]);
    // Update the macro keyboard with the new macro key
    if Connected then
    begin
      if FHIDDevice.Open then
      begin
        // Knob 1
        if MacroKeyboard.SelectedIndex = 12 then Macro := MacroKeyboardConfig.Keys[Index].ToHIDMacro(KEYBOARD_ROT1_LEFT);
        // Knob 2
        if MacroKeyboard.SelectedIndex = 13 then Macro := MacroKeyboardConfig.Keys[Index].ToHIDMacro(KEYBOARD_ROT2_LEFT);
        // Knob 3
        if MacroKeyboard.SelectedIndex = 14 then Macro := MacroKeyboardConfig.Keys[Index].ToHIDMacro(KEYBOARD_ROT3_LEFT);

        if not FHIDDevice.Write(Macro) then Application.MessageBox(PChar(Format(FailedSetMacroMessage, [GetLastError, SysErrorMessage(GetLastError)])), PChar(ApplicationTitle), MB_ICONERROR + MB_OK);
        FHIDDevice.Close;
      end;
    end else
      Application.MessageBox(PChar(NotConnectedMessage), PChar(ApplicationTitle), MB_ICONWARNING + MB_OK);
  end;
end;

//------------------------------------------------------------------------------
// SET KNOB MACRO - CLICK
//------------------------------------------------------------------------------
procedure TfrmMain.acSetMacroKnobExecute(Sender: TObject);
var
  Index: Integer;
  Macro: THIDMacro;
begin
  Index := -1;
  if MacroKeyboard.SelectedIndex = 12 then Index := 14;
  if MacroKeyboard.SelectedIndex = 13 then Index := 17;
  if MacroKeyboard.SelectedIndex = 14 then Index := 20;
  if (Index >= 14) and (MacroKeyboard.SelectedIndex >= 12) and (MacroKeyboard.SelectedIndex <= 14) and (frmKnobMacro.Execute(MacroKeyboard.SelectedIndex, MacroKeyboardConfig.Keys[Index], 'Click') = MROK) then
  begin
    // Update the macro key
    frmKnobMacro.UpdateMacroKey(MacroKeyboardConfig.Keys[Index]);
    // Update the macro keyboard with the new macro key
    if Connected then
    begin
      if FHIDDevice.Open then
      begin
        // Knob 1
        if MacroKeyboard.SelectedIndex = 12 then Macro := MacroKeyboardConfig.Keys[Index].ToHIDMacro(KEYBOARD_ROT1_CLICK);
        // Knob 2
        if MacroKeyboard.SelectedIndex = 13 then Macro := MacroKeyboardConfig.Keys[Index].ToHIDMacro(KEYBOARD_ROT2_CLICK);
        // Knob 3
        if MacroKeyboard.SelectedIndex = 14 then Macro := MacroKeyboardConfig.Keys[Index].ToHIDMacro(KEYBOARD_ROT3_CLICK);

        if not FHIDDevice.Write(Macro) then Application.MessageBox(PChar(Format(FailedSetMacroMessage, [GetLastError, SysErrorMessage(GetLastError)])), PChar(ApplicationTitle), MB_ICONERROR + MB_OK);
        FHIDDevice.Close;
      end;
    end else
      Application.MessageBox(PChar(NotConnectedMessage), PChar(ApplicationTitle), MB_ICONWARNING + MB_OK);
  end;
end;

//------------------------------------------------------------------------------
// ON KEY / KNOB HINT
//------------------------------------------------------------------------------
procedure TfrmMain.MacroKeyboardKeyKnobHint(Sender: TObject; Index: Integer; var Hint: string);
var
  HintText: string;
begin
  if (Index >= 0) and (Index <= 11) then
  begin
    // Key Hint
    Hint := MacroKeyboardConfig.Keys[Index].Name;
  end;
  if (Index >= 12) and (Index <= 14) then
  begin
    // Knob  1
    if (Index = 12) then
    begin
      HintText := MacroKeyboardConfig.Keys[12].Name + ' - ' + MacroKeyboardConfig.Keys[13].Name + ' - ' + MacroKeyboardConfig.Keys[14].Name;
    end;
    // Knob 2
    if (Index = 13) then
    begin
      HintText := MacroKeyboardConfig.Keys[15].Name + ' - ' + MacroKeyboardConfig.Keys[16].Name + ' - ' + MacroKeyboardConfig.Keys[17].Name;
    end;
    // Knob 3
    if (Index = 14) then
    begin
      HintText := MacroKeyboardConfig.Keys[18].Name + ' - ' + MacroKeyboardConfig.Keys[19].Name + ' - ' + MacroKeyboardConfig.Keys[20].Name;
    end;
    Hint := HintText;
  end;
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
  // Key
  if (Index >= 0) and (Index <= 11) then
  begin
    // Enter/Return - Set Macro
    if (Key = VK_RETURN) then acSetMacroKey.Execute;
    // Delete - Clear Macro
    if (Key = VK_DELETE) then acClearKey.Execute;
  end;
  // Knob
  if (Index >= 12) and (Index <= 14) then
  begin
    // Enter/Return - Set Macro
    if (Key = VK_RETURN) then
    begin
      // Clockwise
      if Shift = [ssCtrl] then acSetMacroKnobC.Execute;
      // Counter clockwise
      if Shift = [ssAlt] then acSetMacroKnobCC.Execute;
      // Click
      if Shift = [] then acSetMacroKnob.Execute;
    end;
    // Delete - Clear Macro
    if (Key = VK_DELETE) then acClearKnob.Execute;
  end;
end;

//------------------------------------------------------------------------------
// CLEAR KEY MACRO
//------------------------------------------------------------------------------
procedure TfrmMain.acClearKeyExecute(Sender: TObject);
begin
  if Connected then
  begin
    if FHIDDevice.Open then
    begin
      if not FHIDDevice.Write(CreateClearKeyMacro(MacroKeyboard.SelectedIndex + 1)) then
        Application.MessageBox(PChar(Format(FailedSetMacroMessage, [GetLastError, SysErrorMessage(GetLastError)])), PChar(ApplicationTitle), MB_ICONERROR + MB_OK);
      FHIDDevice.Close;
    end;
  end else
    Application.MessageBox(PChar(NotConnectedMessage), PChar(ApplicationTitle), MB_ICONWARNING + MB_OK);
end;

//------------------------------------------------------------------------------
// CLEAR KNOB MACRO
//------------------------------------------------------------------------------
procedure TfrmMain.acClearKnobExecute(Sender: TObject);
begin
  if Connected then
  begin
    if FHIDDevice.Open then
    begin
      case MacroKeyboard.SelectedIndex of
        // Knob 1
        12: begin
          if not FHIDDevice.Write(CreateClearKeyMacro(KEYBOARD_ROT1_LEFT)) then
            Application.MessageBox(PChar(Format(FailedSetMacroMessage, [GetLastError, SysErrorMessage(GetLastError)])), PChar(ApplicationTitle), MB_ICONERROR + MB_OK);
          if not FHIDDevice.Write(CreateClearKeyMacro(KEYBOARD_ROT1_CLICK)) then
            Application.MessageBox(PChar(Format(FailedSetMacroMessage, [GetLastError, SysErrorMessage(GetLastError)])), PChar(ApplicationTitle), MB_ICONERROR + MB_OK);
          if not FHIDDevice.Write(CreateClearKeyMacro(KEYBOARD_ROT1_RIGHT)) then
            Application.MessageBox(PChar(Format(FailedSetMacroMessage, [GetLastError, SysErrorMessage(GetLastError)])), PChar(ApplicationTitle), MB_ICONERROR + MB_OK);
        end;
        // Knob 2
        13: begin
          if not FHIDDevice.Write(CreateClearKeyMacro(KEYBOARD_ROT2_LEFT)) then
            Application.MessageBox(PChar(Format(FailedSetMacroMessage, [GetLastError, SysErrorMessage(GetLastError)])), PChar(ApplicationTitle), MB_ICONERROR + MB_OK);
          if not FHIDDevice.Write(CreateClearKeyMacro(KEYBOARD_ROT2_CLICK)) then
            Application.MessageBox(PChar(Format(FailedSetMacroMessage, [GetLastError, SysErrorMessage(GetLastError)])), PChar(ApplicationTitle), MB_ICONERROR + MB_OK);
          if not FHIDDevice.Write(CreateClearKeyMacro(KEYBOARD_ROT2_RIGHT)) then
            Application.MessageBox(PChar(Format(FailedSetMacroMessage, [GetLastError, SysErrorMessage(GetLastError)])), PChar(ApplicationTitle), MB_ICONERROR + MB_OK);
        end;
        // Knob 3
        14: begin
          if not FHIDDevice.Write(CreateClearKeyMacro(KEYBOARD_ROT3_LEFT)) then
            Application.MessageBox(PChar(Format(FailedSetMacroMessage, [GetLastError, SysErrorMessage(GetLastError)])), PChar(ApplicationTitle), MB_ICONERROR + MB_OK);
          if not FHIDDevice.Write(CreateClearKeyMacro(KEYBOARD_ROT3_CLICK)) then
            Application.MessageBox(PChar(Format(FailedSetMacroMessage, [GetLastError, SysErrorMessage(GetLastError)])), PChar(ApplicationTitle), MB_ICONERROR + MB_OK);
          if not FHIDDevice.Write(CreateClearKeyMacro(KEYBOARD_ROT3_RIGHT)) then
            Application.MessageBox(PChar(Format(FailedSetMacroMessage, [GetLastError, SysErrorMessage(GetLastError)])), PChar(ApplicationTitle), MB_ICONERROR + MB_OK);
        end;
      end;
      FHIDDevice.Close;
    end;
  end else
    Application.MessageBox(PChar(NotConnectedMessage), PChar(ApplicationTitle), MB_ICONWARNING + MB_OK);
end;

end.
