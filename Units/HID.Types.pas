//------------------------------------------------------------------------------
// UNIT           : HID.Types.pas
// CONTENTS       : HID Device related types
// VERSION        : 1.0
// TARGET         : Embarcadero Delphi 11 or higher
// AUTHOR         : Ernst Reidinga (ERDesigns)
// STATUS         : Open source under Apache 2.0 library
// COMPATIBILITY  : Windows 7, 8/8.1, 10, 11
// RELEASE DATE   : 19/05/2024
//------------------------------------------------------------------------------
unit HID.Types;

interface

uses
  WinApi.Windows;

type
  /// <summary>
  ///   Handle to a device information set.
  /// </summary>
  HDEVINFO = Pointer;

type
  /// <summary>
  ///   Pointer to a HID preparsed data structure.
  /// </summary>
  PHIDP_PREPARSED_DATA = Pointer;

type
  /// <summary>
  ///   Structure containing information about a device interface.
  /// </summary>
  SP_DEVICE_INTERFACE_DATA = record
    /// <summary>
    ///   Size of the structure.
    /// </summary>
    cbSize: DWORD;
    /// <summary>
    ///   GUID of the device interface class.
    /// </summary>
    InterfaceClassGuid: TGUID;
    /// <summary>
    ///   Flags that provide additional information about the interface.
    /// </summary>
    Flags: DWORD;
    /// <summary>
    ///   Reserved for future use.
    /// </summary>
    Reserved: ULONG_PTR;
  end;
  PSP_DEVICE_INTERFACE_DATA = ^SP_DEVICE_INTERFACE_DATA;

  /// <summary>
  ///   Structure containing detailed information about a device interface.
  /// </summary>
  SP_DEVICE_INTERFACE_DETAIL_DATA_W = record
    /// <summary>
    ///   Size of the structure.
    /// </summary>
    cbSize: DWORD;
    /// <summary>
    ///   Path to the device interface.
    /// </summary>
    DevicePath: array[0..ANYSIZE_ARRAY - 1] of WideChar;
  end;
  PSP_DEVICE_INTERFACE_DETAIL_DATA_W = ^SP_DEVICE_INTERFACE_DETAIL_DATA_W;

  /// <summary>
  ///   Structure containing information about a device.
  /// </summary>
  SP_DEVINFO_DATA = record
    /// <summary>
    ///   Size of the structure.
    /// </summary>
    cbSize: DWORD;
    /// <summary>
    ///   GUID of the device's setup class.
    /// </summary>
    ClassGuid: TGUID;
    /// <summary>
    ///   Handle to the device instance.
    /// </summary>
    DevInst: DWORD;
    /// <summary>
    ///   Reserved for future use.
    /// </summary>
    Reserved: ULONG_PTR;
  end;
  PSP_DEVINFO_DATA = ^SP_DEVINFO_DATA;

type
  /// <summary>
  ///   Structure containing capabilities of a HID device.
  /// </summary>
  HIDP_CAPS = record
    /// <summary>
    ///   Top-level collection's usage ID.
    /// </summary>
    Usage: USHORT;
    /// <summary>
    ///   Top-level collection's usage page.
    /// </summary>
    UsagePage: USHORT;
    /// <summary>
    ///   Size of the input report in bytes.
    /// </summary>
    InputReportByteLength: USHORT;
    /// <summary>
    ///   Size of the output report in bytes.
    /// </summary>
    OutputReportByteLength: USHORT;
    /// <summary>
    ///   Size of the feature report in bytes.
    /// </summary>
    FeatureReportByteLength: USHORT;
    /// <summary>
    ///   Reserved for future use.
    /// </summary>
    Reserved: array[0..16] of USHORT;
    /// <summary>
    ///   Number of link collection nodes.
    /// </summary>
    NumberLinkCollectionNodes: USHORT;
    /// <summary>
    ///   Number of input button capabilities structures.
    /// </summary>
    NumberInputButtonCaps: USHORT;
    /// <summary>
    ///   Number of input value capabilities structures.
    /// </summary>
    NumberInputValueCaps: USHORT;
    /// <summary>
    ///   Number of input data indices.
    /// </summary>
    NumberInputDataIndices: USHORT;
    /// <summary>
    ///   Number of output button capabilities structures.
    /// </summary>
    NumberOutputButtonCaps: USHORT;
    /// <summary>
    ///   Number of output value capabilities structures.
    /// </summary>
    NumberOutputValueCaps: USHORT;
    /// <summary>
    ///  Number of output data indices.
    /// </summary>
    NumberOutputDataIndices: USHORT;
    /// <summary>
    ///   Number of feature button capabilities structures.
    /// </summary>
    NumberFeatureButtonCaps: USHORT;
    /// <summary>
    ///   Number of feature value capabilities structures.
    /// </summary>
    NumberFeatureValueCaps: USHORT;
    /// <summary>
    ///   Number of feature data indices.
    /// </summary>
    NumberFeatureDataIndices: USHORT;
  end;
  PHIDP_CAPS = ^HIDP_CAPS;

type
  /// <summary>
  /// Structure used to receive device event notifications. This header is part
  /// of a larger structure that varies depending on the type of event being reported.
  /// </summary>
  DEV_BROADCAST_HDR = packed record
    /// <summary>
    /// Size of this structure, in bytes. This size includes the size of the
    /// header and any additional data that follows the header.
    /// </summary>
    dbch_size: DWORD;
    /// <summary>
    /// The type of device being described.
    /// </summary>
    dbch_devicetype: DWORD;
    /// <summary>
    /// Reserved; do not use.
    /// </summary>
    dbch_reserved: DWORD;
  end;
  PDEV_BROADCAST_HDR = ^DEV_BROADCAST_HDR;

type
  /// <summary>
  /// Structure that defines a device interface class notification filter.
  /// It specifies the class of device interfaces that an application wants
  /// to receive notifications for.
  /// </summary>
  DEV_BROADCAST_DEVICEINTERFACE = record
    /// <summary>
    /// Size of this structure, in bytes. This size includes this header and
    /// the device interface name that follows the header.
    /// </summary>
    dbcc_size: DWORD;
    /// <summary>
    /// Set to DBT_DEVTYP_DEVICEINTERFACE.
    /// </summary>
    dbcc_devicetype: DWORD;
    /// <summary>
    /// Reserved; do not use.
    /// </summary>
    dbcc_reserved: DWORD;
    /// <summary>
    /// The GUID for the interface device class.
    /// </summary>
    dbcc_classguid: TGUID;
    /// <summary>
    /// The first character of the device interface name. This is a variable-length
    /// field that specifies the null-terminated name of the device interface.
    /// </summary>
    dbcc_name: short;
  end;
  PDEV_BROADCAST_DEVICEINTERFACE = ^DEV_BROADCAST_DEVICEINTERFACE;

implementation

end.
