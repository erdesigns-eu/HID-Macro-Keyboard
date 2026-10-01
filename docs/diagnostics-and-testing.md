# Device diagnostics and protocol testing

## Sanitized diagnostics export

Use **Help > Export Diagnostics** after connecting a device. The JSON report contains:

- generation time in UTC;
- active device-definition ID, name, and protocol;
- VID, PID, and HID interface number;
- whether each enumerated interface matches the active definition;
- manufacturer, product, description, friendly name, service, class, and class GUID;
- input, output, and feature button/axis capability counts;
- whether a serial number exists, without exporting its value.

The UI always calls `SaveToFile(..., False)`. Consequently, serial values, device paths, port locations, hardware IDs, compatible IDs, driver paths, and physical device object names are excluded. The API has an explicit `IncludeSensitive` argument for a future consent-based support workflow, but no current UI enables it.

Review a report before sharing it. Even sanitized USB descriptors may reveal installed hardware and vendor names.

## Transport boundary

`IMacroKeyboardTransport` owns opening, complete-packet writing, closing, and operating-system error translation. `IMacroKeyboardProtocol` owns packet construction and the order in which packets are sent. This makes protocol behavior testable without SetupAPI, Windows handles, a VCL form, or physical hardware.

The production `THIDMacroKeyboardTransport` is a non-owning wrapper around an enumerated `THIDDevice`. A protocol must close every successfully opened session in a `finally` block.

## In-memory test transport

`TMemoryMacroKeyboardTransport` implements the same interface and provides:

- captured deep copies of all successfully written packets;
- an injected open failure through `FailOpen`;
- an injected zero-based write failure through `FailWriteIndex`;
- observable open state;
- reset between scenarios.

A future DUnitX protocol test can use it as follows:

```pascal
var
  ConcreteTransport: TMemoryMacroKeyboardTransport;
  Transport: IMacroKeyboardTransport;
begin
  ConcreteTransport := TMemoryMacroKeyboardTransport.Create;
  Transport := ConcreteTransport;
  Assert.IsTrue(Protocol.ProgramDevice(Transport, Config, Definition, ErrorMessage));
  Assert.AreEqual(21, ConcreteTransport.WriteCount);
  Assert.AreEqual(ExpectedFirstPacket, ConcreteTransport[0]);
end;
```

Keep the interface reference alive while inspecting the concrete object because it uses reference-counted lifetime management.

## Required automated scenarios

1. CH552 golden vectors for all 21 mapped actions.
2. Batch order follows the definition rather than visual layout order.
3. Unknown or out-of-range profile mappings fail before an invalid array access.
4. Open failure returns the injected message and captures no packets.
5. Failure at each write index stops the batch and closes the transport.
6. Empty/invalid macros are reported as write failures.
7. Single-action programming and clear commands use the mapping's command byte.
8. Definition/layout incompatibility prevents the protocol from being called.
9. Diagnostics omit all sensitive keys when `IncludeSensitive` is false.
10. Atomic diagnostics save leaves no temporary file after success or failure.
