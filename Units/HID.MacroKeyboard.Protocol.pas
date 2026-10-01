//------------------------------------------------------------------------------
// UNIT           : HID.MacroKeyboard.Protocol.pas
// CONTENTS       : Pluggable macro-keyboard programming protocols
// TARGET         : Embarcadero Delphi 11 or higher
//------------------------------------------------------------------------------
unit HID.MacroKeyboard.Protocol;

interface

uses
  HID, HID.MacroKeyboard.Config, HID.MacroKeyboard.DeviceDefinition,
  HID.MacroKeyboard.Transport;

type
  /// <summary>Programs a profile through one specific macro-keyboard protocol.</summary>
  IMacroKeyboardProtocol = interface
    ['{186A0E79-90D2-4E7C-B3C8-A38679AFD06F}']
    /// <summary>Returns the stable identifier used by device definitions.</summary>
    function ProtocolID: string;
    /// <summary>Programs every mapped profile entry through the supplied transport.</summary>
    function ProgramDevice(const Transport: IMacroKeyboardTransport;
      const Config: TMacroKeyboardConfig;
      const Definition: TMacroKeyboardDeviceDefinition;
      out ErrorMessage: string): Boolean;
    /// <summary>Programs one mapped profile entry through the supplied transport.</summary>
    function ProgramAction(const Transport: IMacroKeyboardTransport;
      const MacroKey: TMacroKey;
      const Mapping: TMacroKeyboardActionMapping;
      out ErrorMessage: string): Boolean;
    /// <summary>Clears one mapped action through the supplied transport.</summary>
    function ClearAction(const Transport: IMacroKeyboardTransport;
      const Mapping: TMacroKeyboardActionMapping;
      out ErrorMessage: string): Boolean;
  end;

  /// <summary>Implements the original fixed-report CH552 programming protocol.</summary>
  TCH552MacroKeyboardProtocol = class(TInterfacedObject, IMacroKeyboardProtocol)
  public
    /// <summary>Returns the CH552 protocol identifier.</summary>
    function ProtocolID: string;
    /// <summary>Programs the mapped configuration using CH552 output reports.</summary>
    function ProgramDevice(const Transport: IMacroKeyboardTransport;
      const Config: TMacroKeyboardConfig;
      const Definition: TMacroKeyboardDeviceDefinition;
      out ErrorMessage: string): Boolean;
    /// <summary>Programs one CH552 action mapping.</summary>
    function ProgramAction(const Transport: IMacroKeyboardTransport;
      const MacroKey: TMacroKey;
      const Mapping: TMacroKeyboardActionMapping;
      out ErrorMessage: string): Boolean;
    /// <summary>Clears one CH552 action mapping.</summary>
    function ClearAction(const Transport: IMacroKeyboardTransport;
      const Mapping: TMacroKeyboardActionMapping;
      out ErrorMessage: string): Boolean;
  end;

/// <summary>Creates the protocol adapter registered for an identifier.</summary>
/// <returns>The adapter, or nil when the protocol is not implemented.</returns>
function CreateMacroKeyboardProtocol(const ProtocolID: string): IMacroKeyboardProtocol;

implementation

uses
  System.SysUtils, HID.MacroKeyboard;

function TCH552MacroKeyboardProtocol.ProtocolID: string;
begin
  Result := 'ch552-v1';
end;

function TCH552MacroKeyboardProtocol.ProgramDevice(
  const Transport: IMacroKeyboardTransport;
  const Config: TMacroKeyboardConfig;
  const Definition: TMacroKeyboardDeviceDefinition;
  out ErrorMessage: string): Boolean;
var
  Action: TMacroKeyboardActionMapping;
  I: Integer;
  Macro: THIDMacro;
begin
  Result := False;
  ErrorMessage := '';
  if not Assigned(Transport) then
  begin
    ErrorMessage := 'No transport was supplied.';
    Exit;
  end;
  if not Assigned(Config) or not Assigned(Definition) then
  begin
    ErrorMessage := 'The configuration or device definition is missing.';
    Exit;
  end;
  if not SameText(Definition.ProtocolID, Self.ProtocolID) then
  begin
    ErrorMessage := Format('Protocol "%s" cannot handle definition "%s".',
      [Self.ProtocolID, Definition.ProtocolID]);
    Exit;
  end;
  if not Transport.Open(ErrorMessage) then Exit;

  try
    for I := 0 to Definition.ActionCount - 1 do
    begin
      Action := Definition[I];
      if (Action.ProfileIndex < 0) or
        (Action.ProfileIndex >= Config.Keys.Count) then
      begin
        ErrorMessage := Format('Profile index %d is not available.',
          [Action.ProfileIndex]);
        Exit;
      end;
      if (Action.Command < 0) or (Action.Command > 255) then
      begin
        ErrorMessage := Format('Command %d for profile entry %d is outside '
          + 'the supported byte range.', [Action.Command, Action.ProfileIndex + 1]);
        Exit;
      end;
      Macro := Config.Keys[Action.ProfileIndex].ToHIDMacro(Byte(Action.Command));
      if not Transport.Write(Macro, ErrorMessage) then
      begin
        ErrorMessage := Format('Failed to program profile entry %d: %s',
          [Action.ProfileIndex + 1, ErrorMessage]);
        Exit;
      end;
    end;
    Result := True;
  finally
    Transport.Close;
  end;
end;

function TCH552MacroKeyboardProtocol.ProgramAction(
  const Transport: IMacroKeyboardTransport; const MacroKey: TMacroKey;
  const Mapping: TMacroKeyboardActionMapping;
  out ErrorMessage: string): Boolean;
var
  Macro: THIDMacro;
begin
  Result := False;
  ErrorMessage := '';
  if not Assigned(Transport) or not Assigned(MacroKey) or
    not Assigned(Mapping) then
  begin
    ErrorMessage := 'The transport, macro, or action mapping is missing.';
    Exit;
  end;
  if (Mapping.Command < 0) or (Mapping.Command > 255) then
  begin
    ErrorMessage := 'The action command is outside the supported byte range.';
    Exit;
  end;
  if not Transport.Open(ErrorMessage) then Exit;
  try
    Macro := MacroKey.ToHIDMacro(Byte(Mapping.Command));
    Result := Transport.Write(Macro, ErrorMessage);
    if not Result then
      ErrorMessage := 'Failed to program the action: ' + ErrorMessage;
  finally
    Transport.Close;
  end;
end;

function TCH552MacroKeyboardProtocol.ClearAction(
  const Transport: IMacroKeyboardTransport;
  const Mapping: TMacroKeyboardActionMapping; out ErrorMessage: string): Boolean;
begin
  Result := False;
  ErrorMessage := '';
  if not Assigned(Transport) or not Assigned(Mapping) then
  begin
    ErrorMessage := 'The transport or action mapping is missing.';
    Exit;
  end;
  if (Mapping.Command < 0) or (Mapping.Command > 255) then
  begin
    ErrorMessage := 'The action command is outside the supported byte range.';
    Exit;
  end;
  if not Transport.Open(ErrorMessage) then Exit;
  try
    Result := Transport.Write(CreateClearKeyMacro(Byte(Mapping.Command)),
      ErrorMessage);
    if not Result then
      ErrorMessage := 'Failed to clear the action: ' + ErrorMessage;
  finally
    Transport.Close;
  end;
end;

function CreateMacroKeyboardProtocol(const ProtocolID: string): IMacroKeyboardProtocol;
begin
  if SameText(ProtocolID, 'ch552-v1') then
    Result := TCH552MacroKeyboardProtocol.Create
  else
    Result := nil;
end;

end.
