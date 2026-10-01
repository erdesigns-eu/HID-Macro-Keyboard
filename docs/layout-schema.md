# Keyboard layout files

The visual `TMacroKeyboard` component is no longer limited to the original 12-key, 3-encoder enclosure. It can load a validated UTF-8 JSON layout and uses that data for drawing, hit testing, context-menu selection, labels, and spatial keyboard navigation.

This is the **visual/layout foundation** for supporting additional hardware. A layout does not by itself define a vendor's HID protocol. New hardware still needs a matching transport/protocol definition before the application may write commands to it safely.

## Included examples

The `Layouts` directory contains generic examples for form factors commonly advertised for small macro pads:

- `12-key-3-encoder.json` reproduces the existing component;
- `9-key-3-encoder.json` demonstrates a three-by-three pad with three encoders;
- `6-key-1-encoder.json` demonstrates a compact two-by-three pad with one encoder.

These examples describe physical arrangements, not guaranteed compatibility with a particular Amazon listing, manufacturer, VID/PID, firmware, or command protocol.

## Schema version 1

```json
{
  "schemaVersion": 1,
  "name": "6 keys + 1 encoder",
  "device": {
    "width": 106,
    "height": 62,
    "borderRadius": 7
  },
  "controls": [
    {
      "id": "key-1",
      "label": "1",
      "type": "key",
      "x": 8,
      "y": 8,
      "width": 18,
      "height": 18
    },
    {
      "id": "encoder-1",
      "label": "1",
      "type": "encoder",
      "x": 78,
      "y": 19,
      "width": 20,
      "height": 20
    }
  ]
}
```

All dimensions are millimetres relative to the top-left of the device outline.

### Root fields

| Field | Type | Meaning |
| --- | --- | --- |
| `schemaVersion` | integer | Must currently be `1`. |
| `name` | string | Non-empty human-readable layout name. |
| `device.width` | number | Positive finite enclosure width. |
| `device.height` | number | Positive finite enclosure height. |
| `device.borderRadius` | number | Finite, non-negative outline radius. |
| `controls` | array | Between 1 and 128 keys/encoders. |

### Control fields

| Field | Type | Meaning |
| --- | --- | --- |
| `id` | string | Required stable identifier, unique without regard to case. |
| `label` | string | Short text drawn inside the control. |
| `type` | string | `key` or `encoder`. |
| `x`, `y` | number | Top-left position in millimetres. |
| `width`, `height` | number | Positive size in millimetres. |

Every control must fit completely inside the device. Files larger than 1 MiB, unsupported schema versions, duplicate IDs, invalid numeric values, unknown types, and out-of-bounds controls are rejected before the live component layout changes.

## Loading a layout

```pascal
MacroKeyboard.LoadLayoutFromFile('Layouts\6-key-1-encoder.json');
```

The component owns its `Layout` property and copies assigned layouts, so callers may safely free a temporary layout after assignment.

```pascal
var
  Layout: TMacroKeyboardLayout;
begin
  Layout := TMacroKeyboardLayout.Create;
  try
    Layout.LoadFromFile(FileName);
    MacroKeyboard.Layout := Layout;
  finally
    Layout.Free;
  end;
end;
```

## Creating a layout

Start by copying the closest included example. Measure the enclosure and control locations, update the device size, then add one entry per visible key or encoder. Keep IDs stable after profiles begin referring to them; labels may change without breaking identity.

Before publishing a device definition:

1. validate the JSON by loading it in the component;
2. compare it at 100%, 150%, and 200% Windows scaling;
3. verify mouse hit testing and arrow-key navigation;
4. record the vendor, model, VID, PID, interface, firmware, and source of the HID protocol separately;
5. do not assume visually identical products use the same command protocol.

## Next compatibility layer

The next implementation stage should associate layout control IDs with logical actions and a separate device definition containing USB identity and protocol mappings. Keeping visual geometry separate from transport data allows multiple firmware variants to reuse a layout without allowing an untrusted layout file to issue arbitrary HID commands.
