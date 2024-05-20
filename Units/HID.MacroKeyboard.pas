//------------------------------------------------------------------------------
// UNIT           : HID.MacroKeyboard.pas
// CONTENTS       : HID MacroKeyboard Functions and Types
// VERSION        : 1.0
// TARGET         : Embarcadero Delphi 11 or higher
// AUTHOR         : Ernst Reidinga (ERDesigns)
// STATUS         : Open source under Apache 2.0 library
// COMPATIBILITY  : Windows 7, 8/8.1, 10, 11
// RELEASE DATE   : 19/05/2024
//------------------------------------------------------------------------------
unit HID.MacroKeyboard;

interface

uses HID, HID.Constants;

type
  /// <summary>
  ///   Macro Type
  /// </summary>
  TMacroType = Byte;
  /// <summary>
  ///   Key Code Type
  /// </summary>
  TKeyCode = Byte;
  /// <summary>
  ///   Media Code Type
  /// </summary>
  TMediaCode = Byte;
  /// <summary>
  ///   Mouse Key Code Type
  /// </summary>
  TMouseKeyCode = Byte;
  /// <summary>
  ///   Mouse Wheel Code Type
  /// </summary>
  TMouseWheelCode = Byte;
  /// <summary>
  ///   Modifier Code Type
  /// </summary>
  TModifierCode = Byte;

const
  /// <summary>
  ///   Macro Type KEY
  /// </summary>
  MACRO_KEY: TMacroType = $00;
  /// <summary>
  ///   Macro Type MOUSE
  /// </summary>
  MACRO_MOUSE: TMacroType = $01;
  /// <summary>
  ///   Macro Type MEDIA
  /// </summary>
  MACRO_MEDIA: TMacroType = $02;

const
  /// <summary>
  ///   Key 1
  /// </summary>
  KEYBOARD_KEY1: Byte = $01;
  /// <summary>
  ///   Key 2
  /// </summary>
  KEYBOARD_KEY2: Byte = $02;
  /// <summary>
  ///   Key 3
  /// </summary>
  KEYBOARD_KEY3: Byte = $03;
  /// <summary>
  ///   Key 4
  /// </summary>
  KEYBOARD_KEY4: Byte = $04;
  /// <summary>
  ///   Key 5
  /// </summary>
  KEYBOARD_KEY5: Byte = $05;
  /// <summary>
  ///   Key 6
  /// </summary>
  KEYBOARD_KEY6: Byte = $06;
  /// <summary>
  ///   Key 7
  /// </summary>
  KEYBOARD_KEY7: Byte = $07;
  /// <summary>
  ///   Key 8
  /// </summary>
  KEYBOARD_KEY8: Byte = $08;
  /// <summary>
  ///   Key 9
  /// </summary>
  KEYBOARD_KEY9: Byte = $09;
  /// <summary>
  ///   Key 10
  /// </summary>
  KEYBOARD_KEY10: Byte = $0A;
  /// <summary>
  ///   Key 11
  /// </summary>
  KEYBOARD_KEY11: Byte = $0B;
  /// <summary>
  ///   Key 12
  /// </summary>
  KEYBOARD_KEY12: Byte = $0C;

const
  /// <summary>
  ///   Rotary encoder 1 - Left
  /// </summary>
  KEYBOARD_ROT1_LEFT: Byte = $A1;
  /// <summary>
  ///   Rotary encoder 1 - Click
  /// </summary>
  KEYBOARD_ROT1_CLICK: Byte = $A2;
  /// <summary>
  ///   Rotary encoder 1 - Right
  /// </summary>
  KEYBOARD_ROT1_RIGHT: Byte = $A3;
  /// <summary>
  ///   Rotary encoder 2 - Left
  /// </summary>
  KEYBOARD_ROT2_LEFT: Byte = $A4;
  /// <summary>
  ///   Rotary encoder 2 - Click
  /// </summary>
  KEYBOARD_ROT2_CLICK: Byte = $A5;
  /// <summary>
  ///   Rotary encoder 2 - Right
  /// </summary>
  KEYBOARD_ROT2_RIGHT: Byte = $A6;
  /// <summary>
  ///   Rotary encoder 3 - Left
  /// </summary>
  KEYBOARD_ROT3_LEFT: Byte = $A7;
  /// <summary>
  ///   Rotary encoder 3 - Click
  /// </summary>
  KEYBOARD_ROT3_CLICK: Byte = $A8;
  /// <summary>
  ///   Rotary encoder 3 - Right
  /// </summary>
  KEYBOARD_ROT3_RIGHT: Byte = $A9;

const
  /// <summary>
  ///   No key pressed
  /// </summary>
  KEY_NOKEY: TKeyCode = $00;
  /// <summary>
  ///   A key
  /// </summary>
  KEY_A: TKeyCode = $04;
  /// <summary>
  ///   B key
  /// </summary>
  KEY_B: TKeyCode = $05;
  /// <summary>
  ///   C key
  /// </summary>
  KEY_C: TKeyCode = $06;
  /// <summary>
  ///   D key
  /// </summary>
  KEY_D: TKeyCode = $07;
  /// <summary>
  ///   E key
  /// </summary>
  KEY_E: TKeyCode = $08;
  /// <summary>
  ///   F key
  /// </summary>
  KEY_F: TKeyCode = $09;
  /// <summary>
  ///   G key
  /// </summary>
  KEY_G: TKeyCode = $0A;
  /// <summary>
  ///   H key
  /// </summary>
  KEY_H: TKeyCode = $0B;
  /// <summary>
  ///   I key
  /// </summary>
  KEY_I: TKeyCode = $0C;
  /// <summary>
  ///   J key
  /// </summary>
  KEY_J: TKeyCode = $0D;
  /// <summary>
  ///   K key
  /// </summary>
  KEY_K: TKeyCode = $0E;
  /// <summary>
  ///   L key
  /// </summary>
  KEY_L: TKeyCode = $0F;
  /// <summary>
  ///   M key
  /// </summary>
  KEY_M: TKeyCode = $10;
  /// <summary>
  ///   N key
  /// </summary>
  KEY_N: TKeyCode = $11;
  /// <summary>
  ///   O key
  /// </summary>
  KEY_O: TKeyCode = $12;
  /// <summary>
  ///   P key
  /// </summary>
  KEY_P: TKeyCode = $13;
  /// <summary>
  ///   Q key
  /// </summary>
  KEY_Q: TKeyCode = $14;
  /// <summary>
  ///   R key
  /// </summary>
  KEY_R: TKeyCode = $15;
  /// <summary>
  ///   S key
  /// </summary>
  KEY_S: TKeyCode = $16;
  /// <summary>
  ///   T key
  /// </summary>
  KEY_T: TKeyCode = $17;
  /// <summary>
  ///   U key
  /// </summary>
  KEY_U: TKeyCode = $18;
  /// <summary>
  ///   V key
  /// </summary>
  KEY_V: TKeyCode = $19;
  /// <summary>
  ///   W key
  /// </summary>
  KEY_W: TKeyCode = $1A;
  /// <summary>
  ///   X key
  /// </summary>
  KEY_X: TKeyCode = $1B;
  /// <summary>
  ///   Y key
  /// </summary>
  KEY_Y: TKeyCode = $1C;
  /// <summary>
  ///   Z key
  /// </summary>
  KEY_Z: TKeyCode = $1D;
  /// <summary>
  ///   Number 1 key
  /// </summary>
  KEY_N1: TKeyCode = $1E;
  /// <summary>
  ///   Number 2 key
  /// </summary>
  KEY_N2: TKeyCode = $1F;
  /// <summary>
  ///   Number 3 key
  /// </summary>
  KEY_N3: TKeyCode = $20;
  /// <summary>
  ///   Number 4 key
  /// </summary>
  KEY_N4: TKeyCode = $21;
  /// <summary>
  ///   Number 5 key
  /// </summary>
  KEY_N5: TKeyCode = $22;
  /// <summary>
  ///   Number 6 key
  /// </summary>
  KEY_N6: TKeyCode = $23;
  /// <summary>
  ///   Number 7 key
  /// </summary>
  KEY_N7: TKeyCode = $24;
  /// <summary>
  ///   Number 8 key
  /// </summary>
  KEY_N8: TKeyCode = $25;
  /// <summary>
  ///   Number 9 key
  /// </summary>
  KEY_N9: TKeyCode = $26;
  /// <summary>
  ///   Number 0 key
  /// </summary>
  KEY_N0: TKeyCode = $27;
  /// <summary>
  ///   Enter key
  /// </summary>
  KEY_ENTER: TKeyCode = $28;
  /// <summary>
  ///   Escape key
  /// </summary>
  KEY_ESCAPE: TKeyCode = $29;
  /// <summary>
  ///   Backspace key
  /// </summary>
  KEY_BSPACE: TKeyCode = $2A;
  /// <summary>
  ///   Tab key
  /// </summary>
  KEY_TAB: TKeyCode = $2B;
  /// <summary>
  ///   Space key
  /// </summary>
  KEY_SPACE: TKeyCode = $2C;
  /// <summary>
  ///   Minus key
  /// </summary>
  KEY_MINUS: TKeyCode = $2D;
  /// <summary>
  ///   Equal key
  /// </summary>
  KEY_EQUAL: TKeyCode = $2E;
  /// <summary>
  ///   Left Bracket key
  /// </summary>
  KEY_LBRACKET: TKeyCode = $2F;
  /// <summary>
  ///   Right Bracket key
  /// </summary>
  KEY_RBRACKET: TKeyCode = $30;
  /// <summary>
  ///   Backslash key
  /// </summary>
  KEY_BSLASH: TKeyCode = $31;
  /// <summary>
  ///   Non US Hash key
  /// </summary>
  KEY_NONUS_HASH: TKeyCode = $32;
  /// <summary>
  ///   Semicolon key
  /// </summary>
  KEY_SCOLON: TKeyCode = $33;
  /// <summary>
  ///   Quote key
  /// </summary>
  KEY_QUOTE: TKeyCode = $34;
  /// <summary>
  ///   Grave key
  /// </summary>
  KEY_GRAVE: TKeyCode = $35;
  /// <summary>
  ///   Comma key
  /// </summary>
  KEY_COMMA: TKeyCode = $36;
  /// <summary>
  ///   Dot key
  /// </summary>
  KEY_DOT: TKeyCode = $37;
  /// <summary>
  ///   Slash key
  /// </summary>
  KEY_SLASH: TKeyCode = $38;
  /// <summary>
  ///   Capslock key
  /// </summary>
  KEY_CAPSLOCK: TKeyCode = $39;
  /// <summary>
  ///   F1 key
  /// </summary>
  KEY_F1: TKeyCode = $3A;
  /// <summary>
  ///   F2 key
  /// </summary>
  KEY_F2: TKeyCode = $3B;
  /// <summary>
  ///   F3 key
  /// </summary>
  KEY_F3: TKeyCode = $3C;
  /// <summary>
  ///   F4 key
  /// </summary>
  KEY_F4: TKeyCode = $3D;
  /// <summary>
  ///   F5 key
  /// </summary>
  KEY_F5: TKeyCode = $3E;
  /// <summary>
  ///   F6 key
  /// </summary>
  KEY_F6: TKeyCode = $3F;
  /// <summary>
  ///   F7 key
  /// </summary>
  KEY_F7: TKeyCode = $40;
  /// <summary>
  ///   F8 key
  /// </summary>
  KEY_F8: TKeyCode = $41;
  /// <summary>
  ///   F9 key
  /// </summary>
  KEY_F9: TKeyCode = $42;
  /// <summary>
  ///   F10 key
  /// </summary>
  KEY_F10: TKeyCode = $43;
  /// <summary>
  ///   F11 key
  /// </summary>
  KEY_F11: TKeyCode = $44;
  /// <summary>
  ///   F12 key
  /// </summary>
  KEY_F12: TKeyCode = $45;
  /// <summary>
  ///   Print Screen key
  /// </summary>
  KEY_PSCREEN: TKeyCode = $46;
  /// <summary>
  ///   Scroll Lock key
  /// </summary>
  KEY_SCROLLLOCK: TKeyCode = $47;
  /// <summary>
  ///   Pause key
  /// </summary>
  KEY_PAUSE: TKeyCode = $48;
  /// <summary>
  ///   Insert key
  /// </summary>
  KEY_INSERT: TKeyCode = $49;
  /// <summary>
  ///   Home key
  /// </summary>
  KEY_HOME: TKeyCode = $4A;
  /// <summary>
  ///   Page Up key
  /// </summary>
  KEY_PGUP: TKeyCode = $4B;
  /// <summary>
  ///   Delete key
  /// </summary>
  KEY_DELETE: TKeyCode = $4C;
  /// <summary>
  ///   End key
  /// </summary>
  KEY_END: TKeyCode = $4D;
  /// <summary>
  ///   Page Down key
  /// </summary>
  KEY_PGDOWN: TKeyCode = $4E;
  /// <summary>
  ///   Right Arrow key
  /// </summary>
  KEY_RIGHT: TKeyCode = $4F;
  /// <summary>
  ///   Left Arrow key
  /// </summary>
  KEY_LEFT: TKeyCode = $50;
  /// <summary>
  ///   Down Arrow key
  /// </summary>
  KEY_DOWN: TKeyCode = $51;
  /// <summary>
  ///   Up Arrow key
  /// </summary>
  KEY_UP: TKeyCode = $52;
  /// <summary>
  ///   Num Lock key
  /// </summary>
  KEY_NUMLOCK: TKeyCode = $53;
  /// <summary>
  ///   Keypad Slash key
  /// </summary>
  KEY_KP_SLASH: TKeyCode = $54;
  /// <summary>
  ///   Keypad Asterisk key
  /// </summary>
  KEY_KP_ASTERISK: TKeyCode = $55;
  /// <summary>
  ///   Keypad Minus key
  /// </summary>
  KEY_KP_MINUS: TKeyCode = $56;
  /// <summary>
  ///   Keypad Plus key
  /// </summary>
  KEY_KP_PLUS: TKeyCode = $57;
  /// <summary>
  ///   Keypad Enter key
  /// </summary>
  KEY_KP_ENTER: TKeyCode = $58;
  /// <summary>
  ///   Keypad 1 key
  /// </summary>
  KEY_KP_1: TKeyCode = $59;
  /// <summary>
  ///   Keypad 2 key
  /// </summary>
  KEY_KP_2: TKeyCode = $5A;
  /// <summary>
  ///   Keypad 3 key
  /// </summary>
  KEY_KP_3: TKeyCode = $5B;
  /// <summary>
  ///   Keypad 4 key
  /// </summary>
  KEY_KP_4: TKeyCode = $5C;
  /// <summary>
  ///   Keypad 5 key
  /// </summary>
  KEY_KP_5: TKeyCode = $5D;
  /// <summary>
  ///   Keypad 6 key
  /// </summary>
  KEY_KP_6: TKeyCode = $5E;
  /// <summary>
  ///   Keypad 7 key
  /// </summary>
  KEY_KP_7: TKeyCode = $5F;
  /// <summary>
  ///   Keypad 8 key
  /// </summary>
  KEY_KP_8: TKeyCode = $60;
  /// <summary>
  ///   Keypad 9 key
  /// </summary>
  KEY_KP_9: TKeyCode = $61;
  /// <summary>
  ///   Keypad 0 key
  /// </summary>
  KEY_KP_0: TKeyCode = $62;
  /// <summary>
  ///   Keypad Dot key
  /// </summary>
  KEY_KP_DOT: TKeyCode = $63;
  /// <summary>
  ///   Non US Backslash key
  /// </summary>
  KEY_NONUS_BSLASH: TKeyCode = $64;
  /// <summary>
  ///   Application key
  /// </summary>
  KEY_APPLICATION: TKeyCode = $65;
  /// <summary>
  ///   Power key
  /// </summary>
  KEY_POWER: TKeyCode = $66;
  /// <summary>
  ///   Keypad Equal key
  /// </summary>
  KEY_KP_EQUAL: TKeyCode = $67;

const
  /// <summary>
  ///   Media Next key
  /// </summary>
  MEDIA_NEXT: TMediaCode = $b5;
  /// <summary>
  ///   Media Previous key
  /// </summary>
  MEDIA_PREV: TMediaCode = $b6;
  /// <summary>
  ///   Media Stop key
  /// </summary>
  MEDIA_STOP: TMediaCode = $b7;
  /// <summary>
  ///   Media Play key
  /// </summary>
  MEDIA_PLAY: TMediaCode = $cd;
  /// <summary>
  ///   Media Mute key
  /// </summary>
  MEDIA_MUTE: TMediaCode = $e2;
  /// <summary>
  ///   Media Volume Up key
  /// </summary>
  MEDIA_VOL_UP: TMediaCode = $e9;
  /// <summary>
  ///   Media Volume Down key
  /// </summary>
  MEDIA_VOL_DN: TMediaCode = $ea;

const
  /// <summary>
  ///   Mouse Left button
  /// </summary>
  MOUSE_LEFT: TMouseKeyCode = $01;
  /// <summary>
  ///   Mouse Right button
  /// </summary>
  MOUSE_RIGHT: TMouseKeyCode = $02;
  /// <summary>
  ///   Mouse Center button
  /// </summary>
  MOUSE_CENTER: TMouseKeyCode = $04;

const
  /// <summary>
  ///   Mouse Wheel Click
  /// </summary>
  MOUSE_WHEEL_CLICK: TMouseWheelCode = $00;
  /// <summary>
  ///   Mouse Wheel Up
  /// </summary>
  MOUSE_WHEEL_UP: TMouseWheelCode = $01;
  /// <summary>
  ///   Mouse Wheel Down
  /// </summary>
  MOUSE_WHEEL_DOWN: TMouseWheelCode = $FF;

const
  /// <summary>
  ///   No modifier key pressed
  /// </summary>
  MOD_NOMOD: TModifierCode = $00;
  /// <summary>
  ///   Left Control key
  /// </summary>
  MOD_CTRL: TModifierCode = $01;
  /// <summary>
  ///   Left Shift key
  /// </summary>
  MOD_SHIFT: TModifierCode = $02;
  /// <summary>
  ///   Left Alt key
  /// </summary>
  MOD_ALT: TModifierCode = $04;
  /// <summary>
  ///   Left Win (Windows) key
  /// </summary>
  MOD_WIN: TModifierCode = $08;
  /// <summary>
  ///   Right Control key
  /// </summary>
  MOD_RCTRL: TModifierCode = $10;
  /// <summary>
  ///   Right Shift key
  /// </summary>
  MOD_RSHIFT: TModifierCode = $20;
  /// <summary>
  ///   Right Alt key
  /// </summary>
  MOD_RALT: TModifierCode = $40;
  /// <summary>
  ///   Right Win (Windows) key
  /// </summary>
  MOD_RWIN: TModifierCode = $80;

/// <summary>
///   Create a Mouse Key Macro
/// </summary>
/// <param name="MacroKey">Index of the key in the Macro Keyboard</param>
/// <param name="MouseKey">Mouse Key</param>
/// <returns>Macro as array of Bytes.</returns>
function CreateMouseKeyMacro(const MacroKey: TKeyCode; const MouseKey: TMouseKeyCode): THIDMacro;
/// <summary>
///   Create a Mouse Wheel Macro
/// </summary>
/// <param name="MacroKey">Index of the key in the Macro Keyboard</param>
/// <param name="Wheel">Wheel direction/click</param>
/// <param name="Modifier">Modifier key (Ctrl, Shift, Alt)</param>
/// <returns>Macro as array of Bytes.</returns>
function CreateMouseWheelMacro(const MacroKey: TKeyCode; const Wheel: TMouseWheelCode; const Modifier: TModifierCode): THIDMacro;
/// <summary>
///   Create a Media Macro
/// </summary>
/// <param name="MacroKey">Index of the key in the Macro Keyboard</param>
/// <param name="Media">Media Key</param>
/// <returns>Macro as array of Bytes.</returns>
function CreateMediaMacro(const MacroKey: TKeyCode; const MediaKey: TMediaCode): THIDMacro;

implementation

//------------------------------------------------------------------------------
// CREATE MOUSE KEY MACRO
//------------------------------------------------------------------------------
function CreateMouseKeyMacro(const MacroKey: TKeyCode; const MouseKey: TMouseKeyCode): THIDMacro;
begin
  // Set length of the Macro command
  SetLength(Result, MACRO_DATA_LENGTH);
  // Fill the Macro command with zero's
  FillChar(Result, MACRO_DATA_LENGTH, 0);
  // Set the Macro Key Index
  Result[0] := MacroKey;
  // Set the Mouse Key
  Result[3] := MouseKey;
  // Set the Macro Type
  Result[8] := MACRO_MOUSE;
end;

//------------------------------------------------------------------------------
// CREATE MOUSE WHEEL MACRO
//------------------------------------------------------------------------------
function CreateMouseWheelMacro(const MacroKey: TKeyCode; const Wheel: TMouseWheelCode; const Modifier: TModifierCode): THIDMacro;
begin
  // Set length of the Macro command
  SetLength(Result, MACRO_DATA_LENGTH);
  // Fill the Macro command with zero's
  FillChar(Result, MACRO_DATA_LENGTH, 0);
  // Set the Macro Key Index
  Result[0] := MacroKey;
  // Set the Modifier
  Result[1] := Modifier;
  // Set the Mouse Wheel
  Result[5] := Wheel;
  // Set the Macro Type
  Result[8] := MACRO_MOUSE;
end;

//------------------------------------------------------------------------------
// CREATE MEDIA KEY MACRO
//------------------------------------------------------------------------------
function CreateMediaMacro(const MacroKey: TKeyCode; const MediaKey: TMediaCode): THIDMacro;
begin
  // Set length of the Macro command
  SetLength(Result, MACRO_DATA_LENGTH);
  // Fill the Macro command with zero's
  FillChar(Result, MACRO_DATA_LENGTH, 0);
  // Set the Macro Key Index
  Result[0] := MacroKey;
  // Set the Media Key
  Result[1] := MediaKey;
  // Set the Macro Type
  Result[8] := MACRO_MEDIA;
end;

end.

