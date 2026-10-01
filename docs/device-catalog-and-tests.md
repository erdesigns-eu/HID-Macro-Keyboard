# Device catalog and protocol regression tests

## Why this phase comes before more protocols

Supporting multiple manufacturers requires two safeguards: deterministic device
selection and repeatable packet tests. A wrong match can send a valid packet to
the wrong HID interface, while an untested adapter can silently change firmware
commands. This phase adds both safeguards without enabling unknown hardware.

## Trusted device catalog

`TMacroKeyboardDeviceCatalog` owns validated copies of definitions. Loading a
directory is transactional: JSON files are parsed and checked in a temporary
collection, duplicate IDs are rejected case-insensitively, and the active
catalog is replaced only after every file succeeds.

Matching considers all constraints in a definition. More constrained matches
win according to these weights:

| Constraint | Weight |
| --- | ---: |
| Vendor ID | 8 |
| Product ID | 8 |
| HID interface | 4 |
| Product string | 2 |

An equal top score is an error instead of depending on directory order. This is
intentional: contributors must disambiguate overlapping definitions before the
application may select either device.

Definition-relative layout paths are resolved from the definition's source
file. A definition remains portable when its containing directory is moved.

## DUnitX suite

Open `Tests/MacroKeyboard.Tests.dpr` in Delphi 11 or newer and build or run the
console target. The tests use `TMemoryMacroKeyboardTransport`; no USB device is
opened and no HID report leaves the process.

The initial regression set checks:

- all 21 default CH552 actions are emitted in definition order;
- transport sessions close after success, open failure, validation failure, and
  a mid-stream write failure;
- programming stops at the first failed write and reports the affected entry;
- out-of-range protocol commands are rejected before conversion to a byte;
- clear packets contain only the command byte and zero payload;
- the catalog chooses a more specific definition; and
- ambiguous definitions are rejected deterministically.

## Next protocol acceptance gate

Before a new adapter is enabled for physical devices, add golden-vector tests
for every supported action and error path, document its report size and report
ID, and test it against an explicitly matched VID/PID/interface definition.
Reverse-engineered or inferred packets should remain opt-in until confirmed on
hardware.
