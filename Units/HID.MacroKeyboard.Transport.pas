//------------------------------------------------------------------------------
// UNIT           : HID.MacroKeyboard.Transport.pas
// CONTENTS       : Testable macro-keyboard transport abstraction
// TARGET         : Embarcadero Delphi 11 or higher
//------------------------------------------------------------------------------
unit HID.MacroKeyboard.Transport;

interface

uses
  HID;

type
  /// <summary>Owns one exclusive communication session with a macro keyboard.</summary>
  IMacroKeyboardTransport = interface
    ['{25BF9A19-D5C3-492F-A424-5302A8A3E124}']
    /// <summary>Opens the transport session and returns a user-facing error on failure.</summary>
    function Open(out ErrorMessage: string): Boolean;
    /// <summary>Writes one complete protocol packet and returns a user-facing error on failure.</summary>
    function Write(const Data: THIDMacro; out ErrorMessage: string): Boolean;
    /// <summary>Closes the transport session safely.</summary>
    procedure Close;
  end;

  /// <summary>Adapts the existing Windows HID device to the transport interface.</summary>
  THIDMacroKeyboardTransport = class(TInterfacedObject, IMacroKeyboardTransport)
  private
    FDevice: THIDDevice;
  public
    /// <summary>Creates a non-owning transport wrapper for a HID device.</summary>
    constructor Create(const Device: THIDDevice);
    /// <summary>Opens the wrapped HID device.</summary>
    function Open(out ErrorMessage: string): Boolean;
    /// <summary>Writes a complete packet to the wrapped HID device.</summary>
    function Write(const Data: THIDMacro; out ErrorMessage: string): Boolean;
    /// <summary>Closes the wrapped HID device.</summary>
    procedure Close;
  end;

/// <summary>Creates a transport wrapper for an enumerated HID device.</summary>
/// <returns>The transport, or nil when the device is not assigned.</returns>
function CreateHIDTransport(const Device: THIDDevice): IMacroKeyboardTransport;

implementation

uses
  System.SysUtils, Winapi.Windows;

constructor THIDMacroKeyboardTransport.Create(const Device: THIDDevice);
begin
  inherited Create;
  FDevice := Device;
end;

function THIDMacroKeyboardTransport.Open(out ErrorMessage: string): Boolean;
var
  ErrorCode: DWORD;
begin
  ErrorMessage := '';
  if not Assigned(FDevice) then
  begin
    ErrorMessage := 'No HID device is available.';
    Exit(False);
  end;
  Result := FDevice.Open;
  if not Result then
  begin
    ErrorCode := GetLastError;
    ErrorMessage := Format('Unable to open the HID device. Error %d: %s',
      [ErrorCode, SysErrorMessage(ErrorCode)]);
  end;
end;

function THIDMacroKeyboardTransport.Write(const Data: THIDMacro;
  out ErrorMessage: string): Boolean;
var
  ErrorCode: DWORD;
begin
  ErrorMessage := '';
  if not Assigned(FDevice) then
  begin
    ErrorMessage := 'No HID device is available.';
    Exit(False);
  end;
  Result := FDevice.Write(Data);
  if not Result then
  begin
    ErrorCode := GetLastError;
    ErrorMessage := Format('Unable to write the HID packet. Error %d: %s',
      [ErrorCode, SysErrorMessage(ErrorCode)]);
  end;
end;

procedure THIDMacroKeyboardTransport.Close;
begin
  if Assigned(FDevice) then
    FDevice.Close;
end;

function CreateHIDTransport(const Device: THIDDevice): IMacroKeyboardTransport;
begin
  if Assigned(Device) then
    Result := THIDMacroKeyboardTransport.Create(Device)
  else
    Result := nil;
end;

end.
