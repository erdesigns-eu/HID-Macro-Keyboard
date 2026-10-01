# Additional macro-keyboard protocol investigation

## Status and evidence limitation

Network research was attempted against Amazon, QMK documentation, VIA documentation, Vial's repository, and Elgato's SDK documentation. The provided browser service returned HTTP 401 and the environment proxy returned HTTP 403 for direct requests. Consequently, this document contains **implementation proposals to verify**, not claims that a specific product is already compatible.

No additional protocol should be enabled for writes until its primary specification or real-device captures have been reviewed and converted into tests.

## What the new architecture supports

The application now separates:

1. physical layout JSON;
2. USB HID matching;
3. control/action-to-profile mappings;
4. protocol-specific framing;
5. profile editing and UI.

The HID session is also behind `IMacroKeyboardTransport`, with an in-memory implementation for packet capture and deterministic open/write failure injection.

`ch552-v1` is the first `IMacroKeyboardProtocol` implementation. Device definitions are inert data and cannot introduce executable protocol code. This is the safe extension point for additional families.

## Candidate protocol families

### 1. Closely related CH55x/CH57x macro pads

**Potential value:** high, because many inexpensive pads share similar enclosures and configuration concepts.

**Unknowns to verify:** VID/PID ownership, interface selection, output-report length, report ID, command IDs, checksum/acknowledgement behavior, firmware variants, and whether visually identical boards share firmware.

**Proposal:** acquire representative 3/6/9/12-key devices, collect USB descriptors and writes from their official tools in an isolated test environment, then implement one adapter per proven report family rather than one adapter per marketplace name.

### 2. QMK Raw HID

**Potential value:** medium for custom firmware, but Raw HID is an application-defined transport rather than a universal keyboard configuration protocol.

**Unknowns to verify:** usage page, report size, command namespace, and the firmware-side feature installed on each board.

**Proposal:** support Raw HID only through an explicit protocol ID and definition contract describing report size and an application-specific command set. Do not assume every QMK keyboard is remotely programmable merely because QMK exposes Raw HID capability.

### 3. VIA-compatible dynamic keymaps

**Potential value:** high because VIA-capable firmware is intended for runtime keymap configuration.

**Unknowns to verify:** current protocol/version negotiation, definition format, layer/keycode operations, macro storage, supported firmware revisions, and licensing/attribution requirements.

**Proposal:** create a dedicated `via` adapter with capability negotiation and read-before-write support. Import or translate VIA layout metadata rather than embedding VIA protocol details into the visual layout schema. Start read-only by showing identity and capabilities, then enable writes after golden tests against at least two devices.

### 4. Vial-compatible firmware

**Potential value:** high for advanced keymaps, encoders, tap-dance, combos, and macros.

**Unknowns to verify:** Vial protocol/version discovery, keyboard UID/security model, unlock requirements, feature availability, and compatibility with upstream QMK/VIA behavior.

**Proposal:** keep Vial separate from VIA even where transports overlap. The adapter should negotiate features and expose only those confirmed by the connected firmware. Security/unlock operations require explicit user confirmation and must not be inferred from a visual definition.

### 5. Standard USB HID keyboards

**Potential value:** low for onboard programming. Standard keyboard HID defines input reports but generally does not define a vendor-neutral way to rewrite firmware keymaps.

**Proposal:** optionally support software-side profiles by listening for input and executing actions on the PC, but treat this as a distinct runtime remapping feature. It requires device-specific input identification, background operation, loop prevention, security review, and clear disclosure that mappings are not stored on the keyboard.

### 6. Serial/USB-CDC macro pads

**Potential value:** medium for open or hobbyist devices with documented command shells.

**Proposal:** add a transport abstraction below the protocol interface before implementing CDC. The present adapter receives `THIDDevice`, so non-HID transports should not be forced through it. Candidate interfaces are `IMacroKeyboardTransport`, `IHIDTransport`, and `ISerialTransport`, with exclusive session ownership and cancellation.

### 7. Stream Deck and similar display-key devices

**Potential value:** separate product category rather than a direct extension of fixed macro pads.

**Unknowns to verify:** official SDK scope, direct device access terms, image transfer, events, brightness, firmware behavior, and application/plugin lifecycle.

**Proposal:** prefer the vendor SDK/plugin ecosystem where required. Display image transfer and event streaming need a different device model and should not be squeezed into the current one-command-per-action profile format.

## Recommended implementation order

1. **Diagnostics export (implemented foundation):** sanitized VID, PID, interface, descriptors, and HID capability counts are now exportable; explicit sensitive export can be added if a support workflow requires it.
2. **Protocol test harness (implemented foundation):** the in-memory transport captures writes and injects open/write failures; formal DUnitX golden-vector tests remain to be added.
3. **Transport interface (implemented for HID):** adapters now use `IMacroKeyboardTransport`; serial/CDC will still need a separate concrete transport.
4. **Definition catalog:** scan a trusted directory, report conflicts, select the most specific match, and never auto-load executable code.
5. **Second adapter:** choose either a verified related fixed-report pad for a small step or VIA for a standards-oriented larger step.
6. **Capability UI:** show read-only identity/protocol/capability data before allowing writes.
7. **Signed community definitions:** schema validation, source metadata, checksums, review process, and safe update mechanism.

## Selection criteria for the second protocol

Score candidates on documentation quality, hardware availability, protocol stability, ability to read back state, uniqueness of USB matching, legal clarity, test coverage potential, and number of users served. A protocol with strong primary documentation and read-back support is preferable to a popular but opaque marketplace device.

## Immediate proposal

The diagnostics and transport-test foundations are now present. The safest next pull request is a **DUnitX golden-vector suite plus a device-definition catalog**, followed by collecting primary documentation or real-device captures for the second protocol.
