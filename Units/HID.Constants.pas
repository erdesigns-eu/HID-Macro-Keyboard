//------------------------------------------------------------------------------
// UNIT           : HID.Constants.pas
// CONTENTS       : HID Device related constants
// VERSION        : 1.0
// TARGET         : Embarcadero Delphi 11 or higher
// AUTHOR         : Ernst Reidinga (ERDesigns)
// STATUS         : Open source under Apache 2.0 library
// COMPATIBILITY  : Windows 7, 8/8.1, 10, 11
// RELEASE DATE   : 19/05/2024
//------------------------------------------------------------------------------
unit HID.Constants;

interface

const
  /// <summary>
  ///   SetupAPI DLL Name.
  /// </summary>
  SETUPAPI_DLL = 'setupapi.dll';

const
  /// <summary>
  ///   HID DLL Name.
  /// </summary>
  HID_DLL = 'hid.dll';

const
  /// <summary>
  ///   Macro data length in Bytes. (HID report structure)
  ///   Byte 0 = Report ID, Byte 1 - 64 = Data
  /// </summary>
  MACRO_DATA_LENGTH = 65;

const
  /// <summary>
  ///   Retrieve only devices that are currently present.
  /// </summary>
  DIGCF_PRESENT = $00000002;
  /// <summary>
  ///   Retrieve devices that expose the specified device interface.
  /// </summary>
  DIGCF_DEVICEINTERFACE = $00000010;

const
  /// <summary>
  ///   GUID for HID device interfaces.
  /// </summary>
  GUID_DEVINTERFACE_HID: TGUID = '{4D1E55B2-F16F-11CF-88CB-001111000030}';

const
  /// <summary>
  ///   Device description property key.
  /// </summary>
  SPDRP_DEVICEDESC = $00000000;
  /// <summary>
  ///   Hardware ID property key.
  /// </summary>
  SPDRP_HARDWAREID = $00000001;
  /// <summary>
  ///   Compatible IDs property key.
  /// </summary>
  SPDRP_COMPATIBLEIDS = $00000002;
  /// <summary>
  ///   Service name property key.
  /// </summary>
  SPDRP_SERVICE = $00000004;
  /// <summary>
  ///   Device class property key.
  /// </summary>
  SPDRP_CLASS = $00000007;
  /// <summary>
  ///   Class GUID property key.
  /// </summary>
  SPDRP_CLASSGUID = $00000008;
  /// <summary>
  ///   Driver key property key.
  /// </summary>
  SPDRP_DRIVER = $00000009;
  /// <summary>
  ///   Manufacturer name property key.
  /// </summary>
  SPDRP_MFG = $0000000B;
  /// <summary>
  ///   Friendly name property key.
  /// </summary>
  SPDRP_FRIENDLYNAME = $0000000C;
  /// <summary>
  ///   Location information property key.
  /// </summary>
  SPDRP_LOCATION_INFORMATION = $0000000D;
  /// <summary>
  ///   Physical device object name property key.
  /// </summary>
  SPDRP_PHYSICAL_DEVICE_OBJECT_NAME = $0000000E;
  /// <summary>
  ///   Capabilities property key.
  /// </summary>
  SPDRP_CAPABILITIES = $0000000F;
  /// <summary>
  ///   UI number property key.
  /// </summary>
  SPDRP_UINUMBER = $00000010;
  /// <summary>
  ///   Indicates successful HIDP operation.
  /// </summary>
  HIDP_STATUS_SUCCESS = $00110000;

const
  /// <summary>
  /// The GUID for USB device interface class notifications.
  /// </summary>
  GUID_DEVINTERFACE_USB_DEVICE: TGUID = '{A5DCBF10-6530-11D2-901F-00C04FB951ED}';
  /// <summary>
  /// System detected a new device.
  /// </summary>
  DBT_DEVICEARRIVAL = $8000;
  /// <summary>
  /// Device is gone.
  /// </summary>
  DBT_DEVICEREMOVECOMPLETE = $8004;
  /// <summary>
  /// Device interface class. Used with DEV_BROADCAST_DEVICEINTERFACE.
  /// </summary>
  DBT_DEVTYP_DEVICEINTERFACE = $00000005;

const
  /// <summary>
  /// HID Manufacturer string.
  /// </summary>
  HID_MANUFACTURER_STRING = 1;
  /// <summary>
  /// HID Product string.
  /// </summary>
  HID_PRODUCT_STRING = 2;
  /// <summary>
  /// HID Serial Code string.
  /// </summary>
  HID_SERIALCODE_STRING = 3;

implementation

end.
