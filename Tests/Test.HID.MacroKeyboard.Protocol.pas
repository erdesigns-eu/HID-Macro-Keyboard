unit Test.HID.MacroKeyboard.Protocol;

interface

uses
  DUnitX.TestFramework, HID, HID.MacroKeyboard.Config,
  HID.MacroKeyboard.DeviceCatalog, HID.MacroKeyboard.DeviceDefinition,
  HID.MacroKeyboard.Protocol, HID.MacroKeyboard.Transport,
  HID.MacroKeyboard.Transport.Memory;

type
  /// <summary>Verifies CH552 packet generation and transport lifetime behavior.</summary>
  [TestFixture]
  TCH552ProtocolTests = class
  private
    FConfig: TMacroKeyboardConfig;
    FDefinition: TMacroKeyboardDeviceDefinition;
    FMemoryTransport: TMemoryMacroKeyboardTransport;
    FProtocol: IMacroKeyboardProtocol;
    FTransport: IMacroKeyboardTransport;
  public
    /// <summary>Creates a default profile, definition, protocol, and memory transport.</summary>
    [Setup]
    procedure SetUp;
    /// <summary>Releases objects and interface references created for a test.</summary>
    [TearDown]
    procedure TearDown;
    /// <summary>Ensures every mapped action produces one packet in mapping order.</summary>
    [Test]
    procedure ProgramsAllMappedActions;
    /// <summary>Ensures an injected write failure stops programming and closes the session.</summary>
    [Test]
    procedure StopsAtWriteFailure;
    /// <summary>Ensures an open failure emits no writes and leaves the session closed.</summary>
    [Test]
    procedure HandlesOpenFailure;
    /// <summary>Ensures invalid commands are rejected before narrowing to a byte.</summary>
    [Test]
    procedure RejectsOutOfRangeCommand;
    /// <summary>Ensures clearing an action emits a zero-filled packet with its command.</summary>
    [Test]
    procedure ClearsMappedAction;
  end;

  /// <summary>Verifies deterministic device-definition catalog selection.</summary>
  [TestFixture]
  TDeviceCatalogTests = class
  public
    /// <summary>Ensures a matcher with more constraints wins over a broad matcher.</summary>
    [Test]
    procedure SelectsMostSpecificDefinition;
    /// <summary>Ensures equally specific matches are reported rather than selected arbitrarily.</summary>
    [Test]
    procedure ReportsAmbiguousDefinitions;
  end;

implementation

uses
  System.SysUtils;

procedure TCH552ProtocolTests.SetUp;
begin
  FConfig := TMacroKeyboardConfig.Create(nil);
  FDefinition := TMacroKeyboardDeviceDefinition.Create;
  FDefinition.CreateDefaultCH552;
  FMemoryTransport := TMemoryMacroKeyboardTransport.Create;
  FTransport := FMemoryTransport;
  FProtocol := CreateMacroKeyboardProtocol(FDefinition.ProtocolID);
end;

procedure TCH552ProtocolTests.TearDown;
begin
  FProtocol := nil;
  FTransport := nil;
  FMemoryTransport := nil;
  FDefinition.Free;
  FConfig.Free;
end;

procedure TCH552ProtocolTests.ProgramsAllMappedActions;
var
  ErrorMessage: string;
  I: Integer;
begin
  Assert.IsTrue(FProtocol.ProgramDevice(FTransport, FConfig, FDefinition,
    ErrorMessage), ErrorMessage);
  Assert.AreEqual(FDefinition.ActionCount, FMemoryTransport.WriteCount);
  Assert.IsFalse(FMemoryTransport.IsOpen);
  for I := 0 to FDefinition.ActionCount - 1 do
    Assert.AreEqual(FDefinition[I].Command,
      Integer(FMemoryTransport[I][1]));
end;

procedure TCH552ProtocolTests.StopsAtWriteFailure;
var
  ErrorMessage: string;
begin
  FMemoryTransport.FailWriteIndex := 5;
  Assert.IsFalse(FProtocol.ProgramDevice(FTransport, FConfig, FDefinition,
    ErrorMessage));
  Assert.AreEqual(5, FMemoryTransport.WriteCount);
  Assert.IsFalse(FMemoryTransport.IsOpen);
  Assert.IsTrue(Pos('profile entry 6', ErrorMessage) > 0, ErrorMessage);
end;

procedure TCH552ProtocolTests.HandlesOpenFailure;
var
  ErrorMessage: string;
begin
  FMemoryTransport.FailOpen := True;
  Assert.IsFalse(FProtocol.ProgramDevice(FTransport, FConfig, FDefinition,
    ErrorMessage));
  Assert.AreEqual(0, FMemoryTransport.WriteCount);
  Assert.IsFalse(FMemoryTransport.IsOpen);
  Assert.IsTrue(Pos('open failure', ErrorMessage) > 0, ErrorMessage);
end;

procedure TCH552ProtocolTests.RejectsOutOfRangeCommand;
var
  ErrorMessage: string;
begin
  FDefinition[0].Command := 256;
  Assert.IsFalse(FProtocol.ProgramDevice(FTransport, FConfig, FDefinition,
    ErrorMessage));
  Assert.AreEqual(0, FMemoryTransport.WriteCount);
  Assert.IsFalse(FMemoryTransport.IsOpen);
  Assert.IsTrue(Pos('byte range', ErrorMessage) > 0, ErrorMessage);
end;

procedure TCH552ProtocolTests.ClearsMappedAction;
var
  ErrorMessage: string;
  I: Integer;
  Packet: THIDMacro;
begin
  Assert.IsTrue(FProtocol.ClearAction(FTransport, FDefinition[0],
    ErrorMessage), ErrorMessage);
  Assert.AreEqual(1, FMemoryTransport.WriteCount);
  Packet := FMemoryTransport[0];
  Assert.AreEqual(FDefinition[0].Command,
    Integer(Packet[1]));
  for I := 0 to High(Packet) do
    if I <> 1 then
      Assert.AreEqual(0, Integer(Packet[I]));
  Assert.IsFalse(FMemoryTransport.IsOpen);
end;

procedure TDeviceCatalogTests.SelectsMostSpecificDefinition;
var
  BroadDefinition: TMacroKeyboardDeviceDefinition;
  Catalog: TMacroKeyboardDeviceCatalog;
  Device: THIDDevice;
  ErrorMessage: string;
  SpecificDefinition: TMacroKeyboardDeviceDefinition;
begin
  Catalog := TMacroKeyboardDeviceCatalog.Create;
  Device := THIDDevice.Create;
  BroadDefinition := TMacroKeyboardDeviceDefinition.Create;
  SpecificDefinition := TMacroKeyboardDeviceDefinition.Create;
  try
    BroadDefinition.CreateDefaultCH552;
    BroadDefinition.ID := 'broad';
    BroadDefinition.Match.InterfaceNumber := -1;
    SpecificDefinition.Assign(BroadDefinition);
    SpecificDefinition.ID := 'specific';
    SpecificDefinition.Match.VendorID := $1189;
    SpecificDefinition.Match.ProductID := $8890;
    Catalog.Add(BroadDefinition);
    Catalog.Add(SpecificDefinition);
    Device.ProductString := 'CH552';
    Device.VendorID := $1189;
    Device.ProductID := $8890;

    Assert.AreEqual('specific', Catalog.FindBestMatch(Device,
      ErrorMessage).ID);
    Assert.AreEqual('', ErrorMessage);
  finally
    SpecificDefinition.Free;
    BroadDefinition.Free;
    Device.Free;
    Catalog.Free;
  end;
end;

procedure TDeviceCatalogTests.ReportsAmbiguousDefinitions;
var
  Catalog: TMacroKeyboardDeviceCatalog;
  Definition: TMacroKeyboardDeviceDefinition;
  Device: THIDDevice;
  ErrorMessage: string;
begin
  Catalog := TMacroKeyboardDeviceCatalog.Create;
  Device := THIDDevice.Create;
  Definition := TMacroKeyboardDeviceDefinition.Create;
  try
    Definition.CreateDefaultCH552;
    Definition.ID := 'first';
    Catalog.Add(Definition);
    Definition.ID := 'second';
    Catalog.Add(Definition);
    Device.ProductString := 'CH552';
    Device.InterfaceNumber := 1;

    Assert.IsNull(Catalog.FindBestMatch(Device, ErrorMessage));
    Assert.IsTrue(Pos('equal specificity', ErrorMessage) > 0,
      ErrorMessage);
  finally
    Definition.Free;
    Device.Free;
    Catalog.Free;
  end;
end;

initialization
  TDUnitX.RegisterTestFixture(TCH552ProtocolTests);
  TDUnitX.RegisterTestFixture(TDeviceCatalogTests);

end.
