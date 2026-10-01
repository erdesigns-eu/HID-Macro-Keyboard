//------------------------------------------------------------------------------
// UNIT           : HID.MacroKeyboard.Transport.Memory.pas
// CONTENTS       : In-memory protocol test transport
// TARGET         : Embarcadero Delphi 11 or higher
//------------------------------------------------------------------------------
unit HID.MacroKeyboard.Transport.Memory;

interface

uses
  System.Generics.Collections, HID, HID.MacroKeyboard.Transport;

type
  /// <summary>Captures protocol packets and injects deterministic transport failures.</summary>
  TMemoryMacroKeyboardTransport = class(TInterfacedObject, IMacroKeyboardTransport)
  private
    FFailOpen: Boolean;
    FFailWriteIndex: Integer;
    FIsOpen: Boolean;
    FWrites: TList<THIDMacro>;
    function GetWrite(const Index: Integer): THIDMacro;
  public
    /// <summary>Creates an empty in-memory transport.</summary>
    constructor Create;
    /// <summary>Releases captured packets.</summary>
    destructor Destroy; override;
    /// <summary>Opens the simulated session unless open failure is enabled.</summary>
    function Open(out ErrorMessage: string): Boolean;
    /// <summary>Captures a complete packet or injects the configured write failure.</summary>
    function Write(const Data: THIDMacro; out ErrorMessage: string): Boolean;
    /// <summary>Closes the simulated session.</summary>
    procedure Close;
    /// <summary>Clears captured packets and restores the closed state.</summary>
    procedure Reset;
    /// <summary>Returns the number of packets captured since the last reset.</summary>
    function WriteCount: Integer;
    /// <summary>Whether opening the simulated transport should fail.</summary>
    property FailOpen: Boolean read FFailOpen write FFailOpen;
    /// <summary>Zero-based write call that should fail, or -1 for no failure.</summary>
    property FailWriteIndex: Integer read FFailWriteIndex write FFailWriteIndex;
    /// <summary>Whether the simulated transport is currently open.</summary>
    property IsOpen: Boolean read FIsOpen;
    /// <summary>Captured packet at the specified zero-based index.</summary>
    property Writes[const Index: Integer]: THIDMacro read GetWrite; default;
  end;

implementation

uses
  System.SysUtils;

constructor TMemoryMacroKeyboardTransport.Create;
begin
  inherited Create;
  FWrites := TList<THIDMacro>.Create;
  FFailWriteIndex := -1;
end;

destructor TMemoryMacroKeyboardTransport.Destroy;
begin
  FWrites.Free;
  inherited Destroy;
end;

function TMemoryMacroKeyboardTransport.GetWrite(const Index: Integer): THIDMacro;
begin
  if (Index < 0) or (Index >= FWrites.Count) then
    raise ERangeError.CreateFmt('Captured write index %d is out of range.', [Index]);
  Result := System.Copy(FWrites[Index], 0, Length(FWrites[Index]));
end;

function TMemoryMacroKeyboardTransport.Open(out ErrorMessage: string): Boolean;
begin
  ErrorMessage := '';
  if FFailOpen then
  begin
    ErrorMessage := 'Injected transport open failure.';
    Exit(False);
  end;
  FIsOpen := True;
  Result := True;
end;

function TMemoryMacroKeyboardTransport.Write(const Data: THIDMacro;
  out ErrorMessage: string): Boolean;
begin
  ErrorMessage := '';
  if not FIsOpen then
  begin
    ErrorMessage := 'The in-memory transport is not open.';
    Exit(False);
  end;
  if FWrites.Count = FFailWriteIndex then
  begin
    ErrorMessage := 'Injected transport write failure.';
    Exit(False);
  end;
  FWrites.Add(System.Copy(Data, 0, Length(Data)));
  Result := True;
end;

procedure TMemoryMacroKeyboardTransport.Close;
begin
  FIsOpen := False;
end;

procedure TMemoryMacroKeyboardTransport.Reset;
begin
  FWrites.Clear;
  FIsOpen := False;
  FFailOpen := False;
  FFailWriteIndex := -1;
end;

function TMemoryMacroKeyboardTransport.WriteCount: Integer;
begin
  Result := FWrites.Count;
end;

end.
