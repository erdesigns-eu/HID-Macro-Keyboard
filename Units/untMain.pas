unit untMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, HID.MacroKeyboard.Component,
  Vcl.ExtCtrls, Vcl.ComCtrls, Vcl.StdCtrls, Vcl.Menus, Vcl.StdActns,
  System.Actions, Vcl.ActnList;

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
    N2: TMenuItem;
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
    Settings1: TMenuItem;
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
    procedure MacroKeyboardSelect(Sender: TObject; Index: Integer);
    procedure RepaintTimerTimer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure acAboutExecute(Sender: TObject);
  private
    /// <summary>
    ///   "Old" window state used in WndProc
    /// </summary>
    FOldWindowState: TWindowState;
  protected
    /// <summary>
    ///   Override WndProc method
    /// </summary>
    procedure WndProc(var Msg: TMessage); override;
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.dfm}

const ApplicationTitle = 'Macro Keyboard';

//------------------------------------------------------------------------------
// WNDPROC HANDLER
//------------------------------------------------------------------------------
procedure TfrmMain.WndProc(var Msg: TMessage);
begin
  // Call inherited WndProc
  inherited WndProc(Msg);

  // Handle window messages that we need to repaint OBD controls
  // like the header, subheader and statusbar. This is because when the
  // window is Maximized or Restored there is no resize handler called
  // and the buffers of our custom components are not updated.
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
  // Set Caption
  Caption := ApplicationTitle;
  // Set Title
  Application.Title := ApplicationTitle;
end;

//------------------------------------------------------------------------------
// ABOUT
//------------------------------------------------------------------------------
procedure TfrmMain.acAboutExecute(Sender: TObject);
const
  AboutText: string = 'Macro Keyboard Utility by ERDesigns.' + sLineBreak + sLineBreak + 'Made by Ernst Reidinga.' + sLineBreak + 'V1.0 (20/05/2024)';
begin
  TaskMessageDlg(ApplicationTitle, AboutText, mtCustom, [mbOK], 0, mbOK);
end;

end.
