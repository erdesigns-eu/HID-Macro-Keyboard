//------------------------------------------------------------------------------
// UNIT           : HID.MacroKeyboard.Hotkey.pas
// CONTENTS       : HID MacroKeyboard Hotkey Edit Component
// VERSION        : 1.0
// TARGET         : Embarcadero Delphi 11 or higher
// AUTHOR         : Ernst Reidinga (ERDesigns)
// STATUS         : Open source under Apache 2.0 library
// COMPATIBILITY  : Windows 7, 8/8.1, 10, 11
// RELEASE DATE   : 26/05/2024
//------------------------------------------------------------------------------
unit HID.MacroKeyboard.Hotkey;

interface

uses
  System.SysUtils, System.Classes, Vcl.Controls, Vcl.StdCtrls, Winapi.Messages,
  WinApi.Windows;

type
  TMacroKeyboardHotKey = class(TEdit)
  private
    /// <summary>
    ///   Key Down Event Handler
    /// </summary>
    procedure WMKeyDown(var Message: TWMKeyDown); message WM_KEYDOWN;
    /// <summary>
    ///   Key Up Event Handler
    /// </summary>
    procedure WMKeyUp(var Message: TWMKeyUp); message WM_KEYUP;
    /// <summary>
    ///   WM_CHAR Handler
    /// </summary>
    procedure WMChar(var Message: TWMChar); message WM_CHAR;
    /// <summary>
    ///   Convert Virtual Key Code to String
    /// </summary>
    function KeyToStr(Key: Word): string;
  public
    /// <summary>
    ///   Constructor
    /// </summary>
    constructor Create(AOwner: TComponent); override;
  end;

implementation

//------------------------------------------------------------------------------
// CONSTRUCTOR
//------------------------------------------------------------------------------
constructor TMacroKeyboardHotKey.Create(AOwner: TComponent);
begin
  // Call inherited constructor
  inherited;

  // Set read only to true because we are setting the text ourselves
  ReadOnly := True;
end;

//------------------------------------------------------------------------------
// ON KEY DOWN
//------------------------------------------------------------------------------
procedure TMacroKeyboardHotKey.WMKeyDown(var Message: TWMKeyDown);
begin
  // Update the text with the pressed key
  Text := KeyToStr(Message.CharCode);
  // Prevent the key from being processed further
  Message.Result := 0;
end;

//------------------------------------------------------------------------------
// ON KEY UP
//------------------------------------------------------------------------------
procedure TMacroKeyboardHotKey.WMKeyUp(var Message: TWMKeyUp);
begin
  // Prevent the key from being processed further
  Message.Result := 0;
end;

//------------------------------------------------------------------------------
// WM_CHAR HANDLER
//------------------------------------------------------------------------------
procedure TMacroKeyboardHotKey.WMChar(var Message: TWMChar);
begin
  // Prevent any character input
  Message.Result := 0;
end;

//------------------------------------------------------------------------------
// KEY CODE TO STRING
//------------------------------------------------------------------------------
function TMacroKeyboardHotKey.KeyToStr(Key: Word): string;
begin
  case Key of
    VK_F1..VK_F24:
      Result := 'F' + IntToStr(Key - VK_F1 + 1);
    VK_HOME:
      Result := 'HOME';
    VK_END:
      Result := 'END';
    VK_INSERT:
      Result := 'INSERT';
    VK_DELETE:
      Result := 'DELETE';
    VK_UP:
      Result := 'UP';
    VK_DOWN:
      Result := 'DOWN';
    VK_LEFT:
      Result := 'LEFT';
    VK_RIGHT:
      Result := 'RIGHT';
    VK_SPACE:
      Result := 'SPACE';
    VK_RETURN:
      Result := 'RETURN';
    VK_ESCAPE:
      Result := 'ESC';
    VK_BACK:
      Result := 'BACKSPACE';
    VK_PRIOR:
      Result := 'PAGE UP';
    VK_NEXT:
      Result := 'PAGE DOWN';
    VK_SNAPSHOT:
      Result := 'PRINT SCREEN';
    VK_TAB:
      Result := 'TAB';
    VK_NUMLOCK:
      Result := 'NUM LOCK';
    VK_SCROLL:
      Result := 'SCROLL LOCK';
    VK_CAPITAL:
      Result := 'CAPS LOCK';
    VK_PAUSE:
      Result := 'PAUSE';

    VK_NUMPAD0:
      Result := 'NUMPAD 0';
    VK_NUMPAD1:
      Result := 'NUMPAD 1';
    VK_NUMPAD2:
      Result := 'NUMPAD 2';
    VK_NUMPAD3:
      Result := 'NUMPAD 3';
    VK_NUMPAD4:
      Result := 'NUMPAD 4';
    VK_NUMPAD5:
      Result := 'NUMPAD 5';
    VK_NUMPAD6:
      Result := 'NUMPAD 6';
    VK_NUMPAD7:
      Result := 'NUMPAD 7';
    VK_NUMPAD8:
      Result := 'NUMPAD 8';
    VK_NUMPAD9:
      Result := 'NUMPAD 9';
    VK_MULTIPLY:
      Result := 'NUMPAD *';
    VK_ADD:
      Result := 'NUMPAD +';
    VK_SEPARATOR:
      Result := 'NUMPAD ,';
    VK_SUBTRACT:
      Result := 'NUMPAD -';
    VK_DECIMAL:
      Result := 'NUMPAD .';
    VK_DIVIDE:
      Result := 'NUMPAD /';

    VK_OEM_COMMA:
      Result := ',';
    VK_OEM_PERIOD:
      Result := '.';
    VK_OEM_1:
      Result := ';';
    VK_OEM_PLUS:
      Result := '+';
    VK_OEM_MINUS:
      Result := '-';
    VK_OEM_2:
      Result := '/';
    VK_OEM_3:
      Result := '`';
    VK_OEM_4:
      Result := '[';
    VK_OEM_5:
      Result := '\';
    VK_OEM_6:
      Result := ']';
    VK_OEM_7:
      Result := '''';
    VK_OEM_102:
      Result := '<';

    else
      Result := Chr(Key);
  end;
end;

end.

