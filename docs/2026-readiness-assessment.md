# 2026 readiness assessment

## Purpose and scope

This document is a source-level assessment of the current Macro Keyboard application and a proposed order of work. It intentionally recommends stabilizing the existing product before adding advanced features.

The review covered the Delphi project metadata, VCL forms, custom keyboard control, configuration model and JSON persistence, HID discovery and I/O, hot-key/model units, repository hygiene, and the available build/test infrastructure. No behavior has been changed as part of this assessment.

## Executive summary

The repository is a compact Windows-only Delphi/VCL beta with a useful separation between the visual control, configuration model, HID protocol construction, and forms. It is small enough to modernize incrementally rather than rewrite. However, it is **not yet a safe base for feature work**: device refresh has ownership and concurrency hazards, device-change tasks update VCL state from worker threads, full-profile programming is incorrect, malformed configuration files can crash the application, and there is no automated test or CI safety net.

The first milestone should therefore be a stabilization release, not a feature release. The recommended sequence is:

1. establish a reproducible Delphi build and tests;
2. fix correctness and resource-lifetime defects;
3. isolate and serialize all HID work;
4. make rendering DPI-aware and event-driven;
5. version and validate configuration files;
6. only then introduce advanced actions, profiles, and device support.

## Current-state inventory

| Area | Current implementation | Assessment |
| --- | --- | --- |
| Application | Native Windows VCL application, nominally version 1.0 from May 2024 | A reasonable desktop foundation, but release metadata and documentation are stale |
| Toolchain | Delphi project version 19.5; source comments target Delphi 11+ | Exact supported compiler/SDK is not pinned and no command-line build script exists |
| Platforms | Win32 is the default and only targeted platform in project metadata | Appropriate for an initial hardware utility, but Win64 should be validated |
| Hardware | Device selected by product string `CH552` and interface number `1` | Too broad for reliable multi-device support; VID/PID/serial are not part of identity |
| Protocol | Fixed byte-array macro builders for keys, mouse, wheel, and media actions | Protocol code is separable and testable, but currently lacks golden-vector tests |
| Configuration | A component-owned collection of 21 macro entries serialized as a bare JSON array | Human-readable, but unversioned, unvalidated, and not forward-compatible |
| Drawing | Custom VCL control with a 32-bit bitmap back buffer and GDI+ primitives | Visually ambitious, but does redundant full redraws and uses global-screen DPI |
| Concurrency | `TTask.Run` after USB arrival/removal, including a fixed 500 ms sleep | Unsafe: shared objects and VCL controls are touched without synchronization or cancellation |
| Distribution | A committed RAR archive linked from the README | Not reproducible, signed, checksummed, or tied to an automated release |
| Quality | No tests, CI workflow, formatter/linter configuration, or issue template found | The largest process risk for modernization |

## What is already worth preserving

- Protocol constants and macro construction are mostly separated from the UI, which makes deterministic unit tests practical.
- The configuration model has explicit macro types and conversion to HID commands rather than embedding protocol bytes throughout every form.
- HID enumeration and visual rendering are already in their own units.
- Debug builds enable range and overflow checking in the project file.
- Public declarations commonly have XML documentation. New and changed declarations should consistently retain that convention, including methods, functions, procedures, events, properties, interfaces, and classes.
- The control uses a back buffer and suppresses background erase, both of which are sound starting points for flicker-free VCL rendering.

## Critical stabilization findings

### P0 — device refresh leaks objects and invalidates references

`THIDDeviceList` stores raw objects in a non-owning `TList`. `Refresh` and `Clear` call `FDevices.Clear` without freeing the existing `THIDDevice` instances. This leaks every enumerated device on every refresh. At the same time, `FHIDDevice` points into that list, so a correct ownership fix would expose the existing stale-pointer design unless callers stop retaining list-owned objects across refreshes.

The device-list destructor also does not retain/unregister the device-notification handle and does not deallocate the hidden window created by `AllocateHWnd`. Those OS resources should have explicit, exception-safe lifetimes.

**First fix:** use an owning `TObjectList<THIDDevice>` (or immutable device descriptors), unregister notification, call `DeallocateHWnd`, and replace retained object pointers with a stable device identity or a session object.

### P0 — USB tasks have UI-thread and shutdown races

Arrival/removal handlers start untracked `TTask` jobs, sleep, refresh a shared mutable list, assign `FHIDDevice`, and set `Connected`. The `Connected` setter writes the status bar and tray icon. VCL controls must only be accessed on the main thread. Multiple rapid device events can overlap, race through `FDevices`, complete out of order, or continue after the form and `FHID` have been destroyed.

**First fix:** introduce one device coordinator with cancellation and a serialized work queue. Perform enumeration/I/O away from the UI thread, then publish an immutable result with `TThread.Queue` after verifying the owner is still alive. Coalesce bursts of device notifications instead of creating one sleeping task per event. Shutdown must cancel and wait for work before releasing dependencies.

### P0 — full-profile upload is functionally incorrect

When a configuration is opened, the key loop converts `Keys[SelectedIndex]` for every physical key rather than `Keys[I]`. With the normal initial selection of `-1`, this can index outside the collection. The rotary loop creates commands but never writes them. The current branch also shows a disconnected warning when automatic programming is disabled, because the `else` belongs to the combined `FSetMacroKeysOnOpenConfig and Connected` condition.

**First fix:** move upload into a tested `ProgramProfile` service that maps all 21 logical actions to explicit physical command identifiers, validates the model first, writes every command, stops or reports coherently on failure, and returns structured progress/results to the UI.

### P0 — configuration input is trusted

`LoadFromFile` casts the parser result directly to `TJSONArray`, assumes every item is an object, requires every field with the expected type, clears the current collection before parsing completes, and does not enforce exactly 21 valid actions. Invalid or future JSON can therefore cause access violations, leave a partial profile, and later trigger unsafe indexing in hints and programming.

**First fix:** parse into a temporary model, validate schema/ranges/counts, supply migration defaults, and swap it into the live model only after success. Report actionable errors without destroying the current configuration. Save atomically through a temporary file and replacement.

### P0 — save/close flow can discard work

The close-query handler unconditionally sets `CanClose := True` after its decision logic. A cancelled or failed Save As can therefore still close the application. Similar save-before-open/new logic is duplicated, making outcomes hard to reason about. Write exceptions are not converted to a clear user-facing result.

**First fix:** centralize the workflow in a `ConfirmSaveChanges` function with explicit `saved`, `discarded`, and `cancelled/failed` outcomes. Only save settings and close after a successful outcome.

## High-priority engineering findings

### P1 — HID I/O needs a safe session boundary

- `Open` overwrites the handle without guarding against an already-open session.
- `Close` does not check or reset the handle, making repeated close or error recovery unsafe.
- `Write` indexes `Macro[0]` without rejecting an empty buffer and treats any successful `WriteFile` call as success without verifying the byte count.
- Open failures are usually silent, and `GetLastError` is sometimes read more than once while formatting a message.
- Open/write/close sequences are repeated in the form and are not protected with `try/finally`.
- Device identification relies on a generic product string rather than VID, PID, usage/interface, and optionally serial number.

Create an `IHIDTransport` abstraction and a short-lived session API. A single worker should own the transport. Return structured errors containing operation, native error code, message, and command index. This also enables a fake transport for tests without hardware.

### P1 — rendering does unnecessary work and is not monitor-DPI correct

The component already owns a bitmap buffer, but most state changes call `PaintBuffer` immediately and then invalidate. `Repaint` first invokes inherited painting and only afterwards rebuilds the buffer and invalidates again. Resize also sizes the buffer before calling a paint routine that sizes it again. GDI+ brushes, pens, paths, font families, fonts, and string formats are recreated for every key/knob on every full render.

Geometry uses `Screen.PixelsPerInch`, not the control's current monitor DPI. This is particularly risky because the application declares per-monitor-v2 DPI awareness. Text sizing mixes VCL point conversion, screen DPI, and zoom. The custom `WM_PAINT` tracking is complex and records the update rectangle after inherited painting, while the main form uses a timer workaround to repaint after window-state changes.

**Recommended rendering design:**

1. separate layout calculation, static keyboard rendering, and transient overlays (selection/focus/hover);
2. store device-independent dimensions and derive pixels from `CurrentPPI`/`ChangeScale`;
3. mark the buffer dirty on property/layout/style/DPI changes and rebuild at most once during `Paint`;
4. cache reusable GDI+ resources per render or per style/DPI generation;
5. invalidate only old/new selection or hover bounds when the static layer is unchanged;
6. handle DPI/style/font changes explicitly and remove the form timer workaround;
7. verify all GDI+ status results and zero-sized control states;
8. add visual regression captures at 100%, 150%, and 200% DPI, light/dark VCL styles, disabled state, and keyboard focus.

Do not render on a background thread: VCL window/control access and the live canvas belong on the UI thread. Optimize invalidation and caching instead. Background work is appropriate for device discovery, I/O, config parsing, and update checks.

### P1 — model, service, and UI responsibilities are mixed

The main form currently owns settings persistence, lifecycle, device discovery, device programming, error presentation, and document workflows. Macro-to-command index mapping is repeated as numeric conditions. Global forms are created eagerly at startup, and dialogs mutate shared objects.

Introduce small, documented boundaries rather than a framework-heavy rewrite:

- `IMacroKeyboardTransport`: open/session/write semantics;
- `IDeviceDiscovery`: immutable descriptors and change notifications;
- `IProfileRepository`: validated, versioned load/save;
- `TProfileProgrammer`: the single logical-to-physical mapping and batch operation;
- `IApplicationSettings`: typed settings independent of form controls;
- forms that bind data and display service results only.

### P1 — the project is not reproducibly buildable

The project files contain long machine-specific package lists, references to locally installed design-time packages, and a deployment path from a developer machine. There is no group project, build script, dependency manifest, or CI configuration. A binary RAR is committed as the advertised download.

Choose and document one supported Delphi release (with edition and required workloads/packages), remove accidental package dependencies, validate Win32 and Win64 Release builds, and create a command-line build entry point. CI should compile, run unit tests, archive symbols, generate hashes, and create versioned artifacts. Releases should be generated from tags; do not treat the checked-in archive as source of truth.

## Medium-priority findings

### P2 — configuration/settings evolution

Adopt a root JSON object rather than a bare array, for example:

```json
{
  "schemaVersion": 2,
  "device": { "layout": "12-key-3-knob" },
  "profile": { "name": "Default", "actions": [] }
}
```

Keep a reader for legacy arrays and write only the newest schema. Define limits for strings and actions, preserve unknown compatible fields where practical, and add migration tests. Consider moving application settings from ad-hoc registry reads into a typed settings repository while retaining a migration path.

### P2 — UX, accessibility, and observability

- Batch programming needs progress, cancellation between commands, and a final per-command result.
- Connection status should distinguish disconnected, discovering, connected, programming, and error.
- Commands should disable consistently when no compatible device or selection exists.
- Focus cues, keyboard navigation, high contrast, screen-reader names, and touch target behavior need explicit tests.
- Errors should be logged with timestamps and native codes; normal users should see concise remediation rather than raw messages alone.
- “Unsafed”/“jus” and other user-facing/documentation wording should be corrected during the stabilization pass.

### P2 — security and release hygiene

The utility writes commands to a USB device and consumes local profile files, so inputs and device identity should be treated as untrusted. Cap file size before parsing, reject invalid counts/types, avoid unbounded strings, and never select a device solely because it exposes a matching display name. Publish checksums and ideally Authenticode-sign installers/binaries. Add a vulnerability-reporting policy and document what telemetry—preferably none by default—is collected.

## Proposed stabilization backlog

### Milestone S0 — establish a baseline (1–2 focused pull requests)

- Pin the supported Delphi version and Windows SDK.
- Add a repeatable command-line build for Win32 Debug/Release; add Win64 once dependencies are clean.
- Add DUnitX test projects for protocol and model code.
- Capture known-device protocol fixtures from verified hardware/original software where legally and technically appropriate.
- Add CI on a Windows runner with compiler availability.
- Turn warnings, range checks, overflow checks, and memory-leak reporting into documented quality gates.
- Record manual hardware smoke-test steps and test device identifiers/firmware variants.

**Exit criteria:** a clean checkout builds predictably, unit tests run without hardware, and the existing behavior has a written smoke-test baseline.

### Milestone S1 — correctness and lifetime (2–4 pull requests)

- Fix device collection ownership, notification/window teardown, and handle state.
- Replace untracked tasks with a cancellable serialized coordinator.
- Fix full-profile upload and centralize all 21 command mappings.
- Make load/save transactional and schema-validated.
- Fix new/open/save/close cancellation and failure behavior.
- Audit every collection index, OS allocation, and open/write/close path.

**Exit criteria:** repeated reconnect/refresh does not leak; closing during discovery is safe; corrupt profiles do not alter live state; all 21 commands program correctly or produce a precise failure.

### Milestone S2 — drawing and interaction (2–3 pull requests)

- Refactor rendering into layout/static/overlay stages with dirty flags.
- Use per-monitor control DPI and explicitly handle DPI/style/font changes.
- Remove redundant paints and the window-state repaint timer.
- Add hover/focus/disabled visuals and accessibility metadata.
- Establish screenshot comparison scenarios and repaint/performance instrumentation.

**Exit criteria:** no visible flicker, clipping, stale pixels, or scale jumps across supported DPI/style combinations; interaction remains responsive while hardware work runs.

### Milestone S3 — release readiness (1–3 pull requests)

- Update version resources, About data, compatibility statement, and README.
- Add structured logging with opt-in diagnostic export.
- Produce an installer and portable archive from CI; sign and checksum artifacts.
- Run clean-VM tests on supported Windows versions and standard/non-admin accounts.
- Publish migration/rollback notes and a support matrix.

**Exit criteria:** a tagged build produces traceable artifacts that install, upgrade, run, and uninstall cleanly.

## Test strategy

### Unit tests (no hardware)

- Golden byte vectors for every macro type, modifier combination, physical key, and knob direction/click.
- Bounds and empty-input tests for transport writes.
- All 21 logical-to-physical profile mappings.
- Legacy/current JSON read, malformed JSON, wrong types/counts, unknown fields, migration, Unicode, oversized input, and atomic-save failure.
- Settings defaults and corrupt-value recovery.
- Layout geometry and hit testing at representative control sizes and DPIs.

### Integration tests (fake transport)

- Full upload order, byte counts, progress, cancellation, retry policy, and partial failure.
- Arrival/removal bursts, stale results, multiple matching devices, and shutdown during enumeration.
- UI commands and status transitions for disconnected/connected/programming/error states.

### Hardware tests

- Verified supported VID/PID/interface/firmware matrix.
- Every key and all nine knob actions, including the currently reported mute and play/pause issue.
- Unplug during open/write, rapid reconnect, sleep/resume, lock/unlock, and two compatible devices.
- Long reconnect/refresh soak with handle and memory monitoring.

### Visual/manual tests

- 100%, 125%, 150%, 200%, and mixed-monitor DPI transitions.
- Default, light/dark custom styles, Windows high contrast, and large system fonts.
- Resize/maximize/restore, minimize-to-tray, keyboard-only navigation, hints near screen edges, and screen-reader inspection.

## Feature roadmap after stabilization

Features should use the new service/model boundaries rather than add more event-handler logic to the main form.

### Near-term, high value

1. **Profile library and quick switching** — named profiles, duplicate/import/export, recent profiles, and optional device-specific default.
2. **Reliable batch programming** — preview, progress, verification where the protocol permits it, and retry of failed commands.
3. **Richer action editor** — validation, conflict indication, search, templates, undo/redo, and copy/paste between controls.
4. **Multiple known layouts/devices** — descriptor-driven layouts keyed by verified VID/PID/interface/capabilities, not scattered constants.
5. **Diagnostics page** — sanitized device descriptors, protocol/app versions, logs, and exportable support bundle.

### Advanced features requiring architectural support

- Application-aware profile switching with clear security/consent controls.
- Multi-step sequences with delays, text entry, and repeat behavior, only if firmware/protocol capabilities are verified.
- Layers/modifiers and per-knob acceleration curves.
- Plugin/action-provider interface for launching applications, media control, HTTP/webhooks, and integrations. Plugins require signing/trust, permissions, timeouts, isolation, and a stable API before release.
- Community device-definition packs with schema validation and trusted-source policy.
- Optional update checking with signed metadata and explicit user control.

Cloud synchronization and telemetry should not be early priorities: they add privacy, authentication, migration, and operational burdens without first solving local reliability.

## Decisions needed before implementation

1. Which Delphi release and edition will be the supported 2026 toolchain?
2. Is Win32 still required, and should Win64 become the preferred build?
3. Which exact hardware revisions (VID, PID, interface, serial behavior, firmware) are owned and testable?
4. Is the device protocol documented, or must commands be characterized from captures/reference software?
5. Must old profile files remain compatible indefinitely?
6. Is a signed installer feasible, and who controls signing/release credentials?
7. Which Windows versions are in the support matrix?

## Recommended first implementation slice

Start with a narrow vertical slice rather than the renderer:

1. add protocol golden tests and a fake transport;
2. introduce the centralized 21-action mapping/profile programmer;
3. correct full-profile upload through that service;
4. make HID sessions handle-safe and return structured errors;
5. then replace device-change tasks with the serialized coordinator.

This order first prevents incorrect commands and data loss, creates seams for testing, and removes the most dangerous concurrency behavior. The rendering refactor can then proceed without competing changes in the main form and with a stable UI-thread policy.

## Definition of “ready for feature development”

The codebase is ready for advanced features when all of the following are true:

- reproducible Win32 and/or Win64 builds run in CI;
- core protocol, mapping, persistence, and coordinator behavior is covered by automated tests;
- no known object/handle leaks occur during reconnect and refresh soak tests;
- no background task accesses VCL controls or outlives its owner;
- profile load/save is versioned, transactional, and validated;
- all 21 physical actions pass a real-hardware programming matrix;
- drawing passes mixed-DPI/style/accessibility scenarios without timer workarounds;
- releases are generated from source with versioned, checksummed artifacts;
- all newly added declarations carry IntelliSense/XML documentation at the declaration site.
