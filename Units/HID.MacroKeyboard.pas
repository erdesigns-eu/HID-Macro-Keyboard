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

type
  /// <summary>
  ///   Key Codes Array Type
  /// </summary>
  TKeyCodes = array of TKeyCode;
  /// <summary>
  ///   Modifier Codes Array Type
  /// </summary>
  TModifierCodes = array of TModifierCode;

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
  KEYBOARD_ROT1_LEFT: Byte = $A3;
  /// <summary>
  ///   Rotary encoder 1 - Click
  /// </summary>
  KEYBOARD_ROT1_CLICK: Byte = $A2;
  /// <summary>
  ///   Rotary encoder 1 - Right
  /// </summary>
  KEYBOARD_ROT1_RIGHT: Byte = $A1;
  /// <summary>
  ///   Rotary encoder 2 - Left
  /// </summary>
  KEYBOARD_ROT2_LEFT: Byte = $A6;
  /// <summary>
  ///   Rotary encoder 2 - Click
  /// </summary>
  KEYBOARD_ROT2_CLICK: Byte = $A5;
  /// <summary>
  ///   Rotary encoder 2 - Right
  /// </summary>
  KEYBOARD_ROT2_RIGHT: Byte = $A4;
  /// <summary>
  ///   Rotary encoder 3 - Left
  /// </summary>
  KEYBOARD_ROT3_LEFT: Byte = $A9;
  /// <summary>
  ///   Rotary encoder 3 - Click
  /// </summary>
  KEYBOARD_ROT3_CLICK: Byte = $A8;
  /// <summary>
  ///   Rotary encoder 3 - Right
  /// </summary>
  KEYBOARD_ROT3_RIGHT: Byte = $A7;

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
  MEDIA_VOL_UP: TMediaCode = $ea;
  /// <summary>
  ///   Media Volume Down key
  /// </summary>
  MEDIA_VOL_DN: TMediaCode = $e9;

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

const
  MouseLeft   = 'Left';
  MouseMiddle = 'Middle';
  MouseRight  = 'Right';
  WheelDown   = 'Up';
  WheelUp     = 'Down';

const
  MediaPlayPause  = 'PlayPause';
  MediaPrevious   = 'Previous';
  MediaNext       = 'Next';
  MediaMute       = 'Mute';
  MediaVolumeUp   = 'VolumeUp';
  MediaVolumeDown = 'VolumeDown';

/// <summary>
///   Create a Clear Key Macro
/// </summary>
/// <param name="MacroKey">Index of the key in the Macro Keyboard</param>
/// <returns>Macro as array of Bytes.</returns>
function CreateClearKeyMacro(const MacroKey: Byte): THIDMacro;
/// <summary>
///   Create a Keyboard Key Macro
/// </summary>
/// <param name="MacroKey">Index of the key in the Macro Keyboard</param>
/// <param name="KeyCodes">Key codes</param>
/// <param name="Modifiers">Modifier keys (Ctrl, Shift, Alt)</param>
/// <returns>Macro as array of Bytes.</returns>
function CreateKeyboardKeyMacro(const MacroKey: Byte; const KeyCodes: TKeyCodes; const Modifiers: TModifierCodes): THIDMacro;
/// <summary>
///   Create a Mouse Key Macro
/// </summary>
/// <param name="MacroKey">Index of the key in the Macro Keyboard</param>
/// <param name="MouseKey">Mouse Key</param>
/// <returns>Macro as array of Bytes.</returns>
function CreateMouseKeyMacro(const MacroKey: Byte; const MouseKey: TMouseKeyCode; const Modifiers: TModifierCodes): THIDMacro;
/// <summary>
///   Create a Mouse Wheel Macro
/// </summary>
/// <param name="MacroKey">Index of the key in the Macro Keyboard</param>
/// <param name="Wheel">Wheel direction/click</param>
/// <param name="Modifiers">Modifier keys (Ctrl, Shift, Alt)</param>
/// <returns>Macro as array of Bytes.</returns>
function CreateMouseWheelMacro(const MacroKey: Byte; const Wheel: TMouseWheelCode; const Modifiers: TModifierCodes): THIDMacro;
/// <summary>
///   Create a Media Macro
/// </summary>
/// <param name="MacroKey">Index of the key in the Macro Keyboard</param>
/// <param name="Media">Media Key</param>
/// <returns>Macro as array of Bytes.</returns>
function CreateMediaMacro(const MacroKey: Byte; const MediaKey: TMediaCode): THIDMacro;
/// <summary>
///   TExt to KeyCode
/// </summary>
/// <param name="Text">Text representation of the keycode</param>
/// <returns>Keycode</returns>
function TextToKeyCode(const Text: string): TKeyCode;

implementation

uses System.SysUtils;

//------------------------------------------------------------------------------
// CREATE CLEAR KEY MACRO
//------------------------------------------------------------------------------
function CreateClearKeyMacro(const MacroKey: Byte): THIDMacro;
begin
  // Set length of the Macro command
  SetLength(Result, MACRO_DATA_LENGTH);
  // Fill the Macro command with zero's
  FillChar(Result[0], Length(Result) * SizeOf(Byte), 0);
  // Set the Macro Key Index
  Result[1] := MacroKey;
end;

//------------------------------------------------------------------------------
// CREATE KEYBOARD KEY MACRO
//------------------------------------------------------------------------------
function CreateKeyboardKeyMacro(const MacroKey: Byte; const KeyCodes: TKeyCodes; const Modifiers: TModifierCodes): THIDMacro;
var
  I: Integer;
  ModifiersCode: TModifierCode;
begin
  // Set length of the Macro command
  SetLength(Result, MACRO_DATA_LENGTH);
  // Fill the Macro command with zero's
  FillChar(Result[0], Length(Result) * SizeOf(Byte), 0);
  // Set the Macro Key Index
  Result[1] := MacroKey;
  // Append the modifiers to a single value
  ModifiersCode := $00;
  for I := Low(Modifiers) to High(Modifiers) do ModifiersCode := ModifiersCode + Modifiers[I];
  // Set the Modifier
  Result[2] := ModifiersCode;
  // Set Key 1
  if Length(KeyCodes) >= 1 then Result[4] := KeyCodes[0];
  // Set Key 2
  if Length(KeyCodes) >= 2 then Result[5] := KeyCodes[1];
  // Set Key 3
  if Length(KeyCodes) >= 3 then Result[6] := KeyCodes[2];
  // Set Key 4
  if Length(KeyCodes) >= 4 then Result[7] := KeyCodes[3];
  // Set Key 5
  if Length(KeyCodes)  = 5 then Result[8] := KeyCodes[4];
  // Set the Macro Type
  Result[9] := MACRO_KEY;
end;

//------------------------------------------------------------------------------
// CREATE MOUSE KEY MACRO
//------------------------------------------------------------------------------
function CreateMouseKeyMacro(const MacroKey: Byte; const MouseKey: TMouseKeyCode; const Modifiers: TModifierCodes): THIDMacro;
var
  I: Integer;
  ModifiersCode: TModifierCode;
begin
  // Set length of the Macro command
  SetLength(Result, MACRO_DATA_LENGTH);
  // Fill the Macro command with zero's
  FillChar(Result[0], Length(Result) * SizeOf(Byte), 0);
  // Set the Macro Key Index
  Result[1] := MacroKey;
  // Append the modifiers to a single value
  ModifiersCode := $00;
  for I := Low(Modifiers) to High(Modifiers) do ModifiersCode := ModifiersCode + Modifiers[I];
  // Set the Modifier
  Result[2] := ModifiersCode;
  // Set the Mouse Key
  Result[4] := MouseKey;
  // Set the Macro Type
  Result[9] := MACRO_MOUSE;
end;

//------------------------------------------------------------------------------
// CREATE MOUSE WHEEL MACRO
//------------------------------------------------------------------------------
function CreateMouseWheelMacro(const MacroKey: Byte; const Wheel: TMouseWheelCode; const Modifiers: TModifierCodes): THIDMacro;
var
  I: Integer;
  ModifiersCode: TModifierCode;
begin
  // Set length of the Macro command
  SetLength(Result, MACRO_DATA_LENGTH);
  // Fill the Macro command with zero's
  FillChar(Result[0], Length(Result) * SizeOf(Byte), 0);
  // Set the Macro Key Index
  Result[1] := MacroKey;
  // Append the modifiers to a single value
  ModifiersCode := $00;
  for I := Low(Modifiers) to High(Modifiers) do ModifiersCode := ModifiersCode + Modifiers[I];
  // Set the Modifier
  Result[2] := ModifiersCode;
  // Set the Mouse Wheel
  Result[6] := Wheel;
  // Set the Macro Type
  Result[9] := MACRO_MOUSE;
end;

//------------------------------------------------------------------------------
// CREATE MEDIA KEY MACRO
//------------------------------------------------------------------------------
function CreateMediaMacro(const MacroKey: Byte; const MediaKey: TMediaCode): THIDMacro;
begin
  // Set length of the Macro command
  SetLength(Result, MACRO_DATA_LENGTH);
  // Fill the Macro command with zero's
  FillChar(Result[0], Length(Result) * SizeOf(Byte), 0);
  // Set the Macro Key Index
  Result[1] := MacroKey;
  // Set the Media Key
  Result[2] := MediaKey;
  // Set the Macro Type
  Result[9] := MACRO_MEDIA;
end;

//------------------------------------------------------------------------------
// TEXT TO KEYCODE
//------------------------------------------------------------------------------
function TextToKeyCode(const Text: string): TKeyCode;
begin
  // Initialize result
  Result := KEY_NOKEY;

  // Alphabet (A-Z)
  if CompareText('A', Text) = 0 then Result := KEY_A;
  if CompareText('B', Text) = 0 then Result := KEY_B;
  if CompareText('C', Text) = 0 then Result := KEY_C;
  if CompareText('D', Text) = 0 then Result := KEY_D;
  if CompareText('E', Text) = 0 then Result := KEY_E;
  if CompareText('F', Text) = 0 then Result := KEY_F;
  if CompareText('G', Text) = 0 then Result := KEY_G;
  if CompareText('H', Text) = 0 then Result := KEY_H;
  if CompareText('I', Text) = 0 then Result := KEY_I;
  if CompareText('J', Text) = 0 then Result := KEY_J;
  if CompareText('K', Text) = 0 then Result := KEY_K;
  if CompareText('L', Text) = 0 then Result := KEY_L;
  if CompareText('M', Text) = 0 then Result := KEY_M;
  if CompareText('N', Text) = 0 then Result := KEY_N;
  if CompareText('O', Text) = 0 then Result := KEY_O;
  if CompareText('P', Text) = 0 then Result := KEY_P;
  if CompareText('Q', Text) = 0 then Result := KEY_Q;
  if CompareText('R', Text) = 0 then Result := KEY_R;
  if CompareText('S', Text) = 0 then Result := KEY_S;
  if CompareText('T', Text) = 0 then Result := KEY_T;
  if CompareText('U', Text) = 0 then Result := KEY_U;
  if CompareText('V', Text) = 0 then Result := KEY_V;
  if CompareText('W', Text) = 0 then Result := KEY_W;
  if CompareText('X', Text) = 0 then Result := KEY_X;
  if CompareText('Y', Text) = 0 then Result := KEY_Y;
  if CompareText('Z', Text) = 0 then Result := KEY_Z;

  // Numbers (1-0)
  if CompareText('1', Text) = 0 then Result := KEY_N1;
  if CompareText('2', Text) = 0 then Result := KEY_N2;
  if CompareText('3', Text) = 0 then Result := KEY_N3;
  if CompareText('4', Text) = 0 then Result := KEY_N4;
  if CompareText('5', Text) = 0 then Result := KEY_N5;
  if CompareText('6', Text) = 0 then Result := KEY_N6;
  if CompareText('7', Text) = 0 then Result := KEY_N7;
  if CompareText('8', Text) = 0 then Result := KEY_N8;
  if CompareText('9', Text) = 0 then Result := KEY_N9;
  if CompareText('0', Text) = 0 then Result := KEY_N0;

  // Others
  if CompareText('RETURN', Text)       = 0 then Result := KEY_ENTER;
  if CompareText('ESC', Text)          = 0 then Result := KEY_ESCAPE;
  if CompareText('BACKSPACE', Text)    = 0 then Result := KEY_BSPACE;
  if CompareText('TAB', Text)          = 0 then Result := KEY_TAB;
  if CompareText('SPACE', Text)        = 0 then Result := KEY_SPACE;
  if CompareText('PRINT SCREEN', Text) = 0 then Result := KEY_PSCREEN;
  if CompareText('PAUSE', Text)        = 0 then Result := KEY_PAUSE;
  if CompareText('INSERT', Text)       = 0 then Result := KEY_INSERT;
  if CompareText('DELETE', Text)       = 0 then Result := KEY_DELETE;
  if CompareText('HOME', Text)         = 0 then Result := KEY_HOME;
  if CompareText('END', Text)          = 0 then Result := KEY_END;
  if CompareText('PAGE UP', Text)      = 0 then Result := KEY_PGUP;
  if CompareText('PAGE DOWN', Text)    = 0 then Result := KEY_PGDOWN;

  // Special characters
  if CompareText('-', Text) = 0 then Result := KEY_MINUS;
  if CompareText('=', Text) = 0 then Result := KEY_EQUAL;
  if CompareText('[', Text) = 0 then Result := KEY_LBRACKET;
  if CompareText(']', Text) = 0 then Result := KEY_RBRACKET;
  if CompareText('\', Text) = 0 then Result := KEY_BSLASH;
  if CompareText('#', Text) = 0 then Result := KEY_NONUS_HASH;
  if CompareText(';', Text) = 0 then Result := KEY_SCOLON;
  if CompareText('"', Text) = 0 then Result := KEY_QUOTE;
  if CompareText('~', Text) = 0 then Result := KEY_GRAVE;
  if CompareText(',', Text) = 0 then Result := KEY_COMMA;
  if CompareText('.', Text) = 0 then Result := KEY_DOT;
  if CompareText('/', Text) = 0 then Result := KEY_SLASH;

  // Lock
  if CompareText('CAPS LOCK', Text)   = 0 then Result := KEY_CAPSLOCK;
  if CompareText('SCROLL LOCK', Text) = 0 then Result := KEY_SCROLLLOCK;
  if CompareText('NUM LOCK', Text)    = 0 then Result := KEY_NUMLOCK;

  // Function
  if CompareText('F1', Text)  = 0 then Result := KEY_F1;
  if CompareText('F2', Text)  = 0 then Result := KEY_F2;
  if CompareText('F3', Text)  = 0 then Result := KEY_F3;
  if CompareText('F4', Text)  = 0 then Result := KEY_F4;
  if CompareText('F5', Text)  = 0 then Result := KEY_F5;
  if CompareText('F6', Text)  = 0 then Result := KEY_F6;
  if CompareText('F7', Text)  = 0 then Result := KEY_F7;
  if CompareText('F8', Text)  = 0 then Result := KEY_F8;
  if CompareText('F9', Text)  = 0 then Result := KEY_F9;
  if CompareText('F10', Text) = 0 then Result := KEY_F10;
  if CompareText('F11', Text) = 0 then Result := KEY_F11;
  if CompareText('F13', Text) = 0 then Result := KEY_F12;

  // Arrow
  if CompareText('UP', Text)    = 0 then Result := KEY_UP;
  if CompareText('DOWN', Text)  = 0 then Result := KEY_DOWN;
  if CompareText('LEFT', Text)  = 0 then Result := KEY_LEFT;
  if CompareText('RIGHT', Text) = 0 then Result := KEY_RIGHT;

  // Numpad Numbers (1-0)
  if CompareText('NUMPAD 1', Text) = 0 then Result := KEY_KP_1;
  if CompareText('NUMPAD 2', Text) = 0 then Result := KEY_KP_2;
  if CompareText('NUMPAD 3', Text) = 0 then Result := KEY_KP_3;
  if CompareText('NUMPAD 4', Text) = 0 then Result := KEY_KP_4;
  if CompareText('NUMPAD 5', Text) = 0 then Result := KEY_KP_5;
  if CompareText('NUMPAD 6', Text) = 0 then Result := KEY_KP_6;
  if CompareText('NUMPAD 7', Text) = 0 then Result := KEY_KP_7;
  if CompareText('NUMPAD 8', Text) = 0 then Result := KEY_KP_8;
  if CompareText('NUMPAD 9', Text) = 0 then Result := KEY_KP_9;
  if CompareText('NUMPAD 0', Text) = 0 then Result := KEY_KP_0;

  // Numpad Others
  if CompareText('NUMPAD *', Text)      = 0 then Result := KEY_KP_ASTERISK;
  if CompareText('NUMPAD +', Text)      = 0 then Result := KEY_KP_PLUS;
  if CompareText('NUMPAD ,', Text)      = 0 then Result := KEY_KP_0;
  if CompareText('NUMPAD -', Text)      = 0 then Result := KEY_KP_MINUS;
  if CompareText('NUMPAD .', Text)      = 0 then Result := KEY_KP_DOT;
  if CompareText('NUMPAD /', Text)      = 0 then Result := KEY_KP_SLASH;
  if CompareText('NUMPAD =', Text)      = 0 then Result := KEY_KP_EQUAL;
  if CompareText('NUMPAD RETURN', Text) = 0 then Result := KEY_KP_ENTER;
  if CompareText('NUMPAD POWER', Text)  = 0 then Result := KEY_POWER;
end;

end.

