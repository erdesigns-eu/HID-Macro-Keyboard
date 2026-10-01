# Device definitions and protocol adapters

A keyboard **layout** describes appearance. A **device definition** identifies compatible USB interfaces, selects a protocol adapter, and maps stable layout control IDs to profile entries and protocol commands.

Keeping these concerns separate prevents a community-authored visual layout from sending arbitrary bytes to an unrelated HID device.

## Schema version 1

```json
{
  "schemaVersion": 1,
  "id": "ch552-12-key-3-encoder",
  "name": "CH552 12-key / 3-encoder macro keyboard",
  "protocol": "ch552-v1",
  "layout": "../Layouts/12-key-3-encoder.json",
  "match": {
    "vendorId": 0,
    "productId": 0,
    "productString": "CH552",
    "interfaceNumber": 1
  },
  "actions": [
    {
      "profileIndex": 0,
      "controlId": "key-1",
      "action": "press",
      "command": 1
    }
  ]
}
```

Relative layout paths are resolved relative to the device-definition file.

## USB matching

`vendorId` and `productId` are decimal 16-bit USB identifiers; zero means unconstrained. `productString` is matched case-insensitively and may be empty when VID/PID provide sufficient identity. `interfaceNumber` is the HID `MI_` number and may be `-1` when unconstrained.

At least one of VID, PID, or product string must be specified. Prefer a verified VID/PID/interface combination over a generic product string. Serial number matching is intentionally not part of schema version 1 because definitions describe a model rather than one physical unit.

## Action mappings

Each profile index may appear once, each control/action pair may appear once, and a definition may contain at most 256 mappings. Supported action names are:

- `press` for a key;
- `clockwise` for encoder rotation;
- `counterClockwise` for encoder rotation;
- `encoderClick` for an encoder push action.

The command is an adapter-specific integer from 0 through 255. The current `ch552-v1` adapter converts the selected profile entry into the existing fixed output report and uses the command as its firmware action identifier.

Definitions cannot add executable code. A protocol named by a definition must already be implemented and registered in the application. Unknown protocol IDs are rejected before the active device or layout changes.

The current profile model still contains the original 21 entries. Definitions whose profile indexes do not fit the active profile are treated as incompatible. Making profile storage action-ID based and variable-length is the next required migration before smaller or larger devices can be fully edited and programmed.

## Loading definitions

Use **View > Load Device Definition**. The application performs the following transaction:

1. parse and validate the definition;
2. find a compiled protocol adapter with the requested ID;
3. resolve and validate the layout;
4. replace the active definition, protocol, and layout;
5. enumerate HID devices using the new USB matcher.

The bundled definition is `Devices/ch552-12-key-3-encoder.json`. A built-in equivalent remains the startup default so the original keyboard still works if external definition files are not deployed.

## Adding a protocol

Implement `IMacroKeyboardProtocol`, give it a stable ID, and register it in `CreateMacroKeyboardProtocol`. An adapter owns command framing while `IMacroKeyboardTransport` owns session and packet-I/O errors. The adapter receives a validated device definition, mapping, macro data, and transport; it does not open Windows handles directly.

Before enabling writes for a new model:

1. obtain VID, PID, interface, product string, and firmware revision from real hardware;
2. capture or document every command and response;
3. create golden byte-vector tests;
4. test interruption, reconnect, partial write, and invalid command behavior;
5. confirm whether configuration is volatile or written to device flash;
6. document protocol provenance and any redistribution restrictions.
