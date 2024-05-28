unit untKnobMacro;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.ComCtrls, Vcl.Menus,
  HID.MacroKeyboard, HID.MacroKeyboard.Config, HID.MacroKeyboard.Hotkey;

type
  TfrmKnobMacro = class(TForm)
    pnlBottom: TPanel;
    btnOK: TButton;
    btnCancel: TButton;
    rgMouse: TRadioGroup;
    rgMacroType: TRadioGroup;
    gbModifiers: TGroupBox;
    cbCtrl: TCheckBox;
    cbAlt: TCheckBox;
    cbShift: TCheckBox;
    cbWin: TCheckBox;
    rgMedia: TRadioGroup;
    gbName: TGroupBox;
    edtName: TEdit;
    gbKeyboard: TGroupBox;
    Panel1: TPanel;
    Label1: TLabel;
    Panel2: TPanel;
    Label2: TLabel;
    Panel3: TPanel;
    Label3: TLabel;
    Panel4: TPanel;
    Label4: TLabel;
    Panel5: TPanel;
    Label5: TLabel;
    edtKey1: TMacroKeyboardHotKey;
    btnClear1: TButton;
    edtKey2: TMacroKeyboardHotKey;
    btnClear2: TButton;
    edtKey3: TMacroKeyboardHotKey;
    btnClear3: TButton;
    edtKey4: TMacroKeyboardHotKey;
    btnClear4: TButton;
    edtKey5: TMacroKeyboardHotKey;
    btnClear5: TButton;
    procedure rgMacroTypeClick(Sender: TObject);
    procedure btnClear1Click(Sender: TObject);
  public
    /// <summary>
    ///   Execute Knob Macro dialog
    /// </summary>
    function Execute(const KeyIndex: Integer; const Key: TMacroKey; const Action: string): TModalResult;
    /// <summary>
    ///   Update Macro Key
    /// </summary>
    procedure UpdateMacroKey(const Key: TMacroKey);
  end;

var
  frmKnobMacro: TfrmKnobMacro;

implementation

{$R *.dfm}

//------------------------------------------------------------------------------
// EXECUTE DIALOG
//------------------------------------------------------------------------------
function TfrmKnobMacro.Execute(const KeyIndex: Integer; const Key: TMacroKey; const Action: string): TModalResult;

  procedure LoadKeySettings;
  begin
    // Set Name
    edtName.Text := Key.Name;

    // Set Modifiers
    cbCtrl.Checked  := Key.Ctrl;
    cbAlt.Checked   := Key.Alt;
    cbShift.Checked := Key.Shift;
    cbWin.Checked   := Key.Win;

    // Set macro type
    if (Key.Key1 <> '') or (Key.Key2 <> '') or (Key.Key3 <> '') or
       (Key.Key4 <> '') or (Key.Key5 <> '') or ((Key.Mouse = '') and
       (Key.Media = '')) then rgMacroType.ItemIndex := 0 else
    if (Key.Mouse <> '') then rgMacroType.ItemIndex := 1 else
    if (Key.Media <> '') then rgMacroType.ItemIndex := 2;

    // Set Mouse
    if Key.Mouse = MouseLeft   then rgMouse.ItemIndex := 0;
    if Key.Mouse = MouseMiddle then rgMouse.ItemIndex := 2;
    if Key.Mouse = MouseRight  then rgMouse.ItemIndex := 4;
    if Key.Mouse = WheelUp     then rgMouse.ItemIndex := 3;
    if Key.Mouse = WheelDown   then rgMouse.ItemIndex := 1;
    if Key.Mouse = ''          then rgMouse.ItemIndex := 0;

    // Set Media
    if Key.Media = MediaPlayPause  then rgMedia.ItemIndex := 0;
    if Key.Media = MediaPrevious   then rgMedia.ItemIndex := 3;
    if Key.Media = MediaNext       then rgMedia.ItemIndex := 5;
    if Key.Media = MediaMute       then rgMedia.ItemIndex := 1;
    if Key.Media = MediaVolumeUp   then rgMedia.ItemIndex := 2;
    if Key.Media = MediaVolumeDown then rgMedia.ItemIndex := 4;
    if Key.Media = ''              then rgMedia.ItemIndex := 0;

    // Set Keys
    edtKey1.Text := Key.Key1;
    edtKey2.Text := Key.Key2;
    edtKey3.Text := Key.Key3;
    edtKey4.Text := Key.Key4;
    edtKey5.Text := Key.Key5;
  end;

begin
  // Set form height
  Height := 470;
  // Set form width
  Width := 370;
  // Load key settings
  LoadKeySettings;
  // Set caption
  Caption := Format('Set Macro for Knob %d - %s', [KeyIndex - 11, Action]);
  // Show dialog modal
  Result := ShowModal;
end;

//------------------------------------------------------------------------------
// UPDATE MACRO KEY
//------------------------------------------------------------------------------
procedure TfrmKnobMacro.UpdateMacroKey(const Key: TMacroKey);
begin
  // Set Name
  Key.Name := edtName.Text;

  // Set Modifiers
  Key.Ctrl  := cbCtrl.Checked;
  Key.Alt   := cbAlt.Checked;
  Key.Shift := cbShift.Checked;
  Key.Win   := cbWin.Checked;

  // Set Key type
  Key.&Type := rgMacroType.ItemIndex;

  case rgMacroType.ItemIndex of
    0: // Keyboard
    begin
      // Clear Mouse and Media
      Key.Mouse := '';
      Key.Media := '';

      // Set Keys
      Key.Key1 := edtKey1.Text;
      Key.Key2 := edtKey2.Text;
      Key.Key3 := edtKey3.Text;
      Key.Key4 := edtKey4.Text;
      Key.Key5 := edtKey5.Text;
    end;

    1: // Mouse
    begin
      // Clear Media and Keyboard
      Key.Media := '';
      Key.Key1  := '';
      Key.Key2  := '';
      Key.Key3  := '';
      Key.Key4  := '';
      Key.Key5  := '';

      // Set Mouse
      case rgMouse.ItemIndex of
        0: Key.Mouse := MouseLeft;
        1: Key.Mouse := WheelDown;
        2: Key.Mouse := MouseMiddle;
        3: Key.Mouse := WheelUp;
        4: Key.Mouse := MouseRight;
      end;
    end;

    2: // Media
    begin
      // Clear Mouse and Keyboard
      Key.Mouse := '';
      Key.Key1  := '';
      Key.Key2  := '';
      Key.Key3  := '';
      Key.Key4  := '';
      Key.Key5  := '';

      // Set Media
      case rgMedia.ItemIndex of
        0: Key.Media := MediaPlayPause;
        1: Key.Media := MediaMute;
        2: Key.Media := MediaVolumeUp;
        3: Key.Media := MediaPrevious;
        4: Key.Media := MediaVolumeDown;
        5: Key.Media := MediaNext;
      end;
    end;
  end;
end;

//------------------------------------------------------------------------------
// CHANGE MACRO TYPE
//------------------------------------------------------------------------------
procedure TfrmKnobMacro.rgMacroTypeClick(Sender: TObject);
begin
  case rgMacroType.ItemIndex of
    0: begin
      gbKeyboard.Visible := True;
      rgMouse.Visible := False;
      rgMedia.Visible := False;
    end;

    1: begin
      rgMouse.ItemIndex := 0;
      gbKeyboard.Visible := False;
      rgMouse.Visible := True;
      rgMedia.Visible := False;
    end;

    2: begin
      rgMedia.ItemIndex := 0;
      gbKeyboard.Visible := False;
      rgMouse.Visible := False;
      rgMedia.Visible := True;
    end;
  end;
end;

//------------------------------------------------------------------------------
// CLEAR KEYBOARD KEY
//------------------------------------------------------------------------------
procedure TfrmKnobMacro.btnClear1Click(Sender: TObject);
begin
  case (Sender as TButton).Tag of
    1: edtKey1.Clear;
    2: edtKey2.Clear;
    3: edtKey3.Clear;
    4: edtKey4.Clear;
    5: edtKey5.Clear;
  end;
end;

end.
