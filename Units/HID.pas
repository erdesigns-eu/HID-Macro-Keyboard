//------------------------------------------------------------------------------
// UNIT           : HID.pas
// CONTENTS       : HID Device Class
// VERSION        : 1.0
// TARGET         : Embarcadero Delphi 11 or higher
// AUTHOR         : Ernst Reidinga (ERDesigns)
// STATUS         : Open source under Apache 2.0 library
// COMPATIBILITY  : Windows 7, 8/8.1, 10, 11
// RELEASE DATE   : 19/05/2024
//------------------------------------------------------------------------------
unit HID;

interface

uses
  WinApi.Windows, System.SysUtils, System.Classes, WinApi.Messages, Vcl.Forms,
  HID.Types, HID.Constants, dialogs;

type
  THIDMacro = array of Byte;

  /// <summary>
  ///   HID Device Class.
  /// </summary>
  THIDDevice = class
  private
    /// <summary>
    ///   Path to the HID device.
    /// </summary>
    FDevicePath: string;
    /// <summary>
    ///   Description of the HID device.
    /// </summary>
    FDescription: string;
    /// <summary>
    ///   Manufacturer of the HID device.
    /// </summary>
    FManufacturer: string;
    /// <summary>
    ///   Friendly name of the HID device.
    /// </summary>
    FFriendlyName: string;
    /// <summary>
    ///   Location information of the HID device.
    /// </summary>
    FLocation: string;
    /// <summary>
    ///   Hardware ID of the HID device.
    /// </summary>
    FHardwareID: string;
    /// <summary>
    ///   Compatible IDs of the HID device.
    /// </summary>
    FCompatibleIDs: string;
    /// <summary>
    ///   Service associated with the HID device.
    /// </summary>
    FService: string;
    /// <summary>
    ///   Device class of the HID device.
    /// </summary>
    FDeviceClass: string;
    /// <summary>
    ///   Class GUID of the HID device.
    /// </summary>
    FClassGUID: string;
    /// <summary>
    ///   Driver associated with the HID device.
    /// </summary>
    FDriver: string;
    /// <summary>
    ///   Physical device object name of the HID device.
    /// </summary>
    FPhysicalDeviceObjectName: string;
    /// <summary>
    ///   Capabilities of the HID device.
    /// </summary>
    FCapabilities: string;
    /// <summary>
    ///   UI number of the HID device.
    /// </summary>
    FUIDNumber: string;
    /// <summary>
    ///   Manufacturer string from the HID device.
    /// </summary>
    FManufacturerString: string;
    /// <summary>
    ///   Product string from the HID device.
    /// </summary>
    FProductString: string;
    /// <summary>
    ///   Serial number string from the HID device.
    /// </summary>
    FSerialNumberString: string;
    /// <summary>
    ///   Number of input buttons on the HID device.
    /// </summary>
    FNumberInputButtons: WORD;
    /// <summary>
    ///   Number of output buttons on the HID device.
    /// </summary>
    FNumberOutputButtons: WORD;
    /// <summary>
    ///   Number of feature buttons on the HID device.
    /// </summary>
    FNumberFeatureButtons: WORD;
    /// <summary>
    ///   Number of input axes on the HID device.
    /// </summary>
    FNumberInputAxes: WORD;
    /// <summary>
    ///   Number of output axes on the HID device.
    /// </summary>
    FNumberOutputAxes: WORD;
    /// <summary>
    ///   Number of feature axes on the HID device.
    /// </summary>
    FNumberFeatureAxes: WORD;
    /// <summary>
    ///   Interface number of the HID device.
    /// </summary>
    FInterfaceNumber: Integer;
  private
    /// <summary>
    ///   HID Device Handle.
    /// </summary>
    FDeviceHandle: THandle;
  public
    /// <summary>
    ///   Opens the HID device.
    /// </summary>
    function Open: Boolean;
    /// <summary>
    ///   Closes the HID device.
    /// </summary>
    procedure Close;
    /// <summary>
    ///   Writes data to the HID device.
    /// </summary>
    function Write(const Macro: THIDMacro): Boolean;
  public
    /// <summary>
    ///   Path to the HID device.
    /// </summary>
    property DevicePath: string read FDevicePath write FDevicePath;
    /// <summary>
    ///   Description of the HID device.
    /// </summary>
    property Description: string read FDescription write FDescription;
    /// <summary>
    ///   Manufacturer of the HID device.
    /// </summary>
    property Manufacturer: string read FManufacturer write FManufacturer;
    /// <summary>
    ///   Friendly name of the HID device.
    /// </summary>
    property FriendlyName: string read FFriendlyName write FFriendlyName;
    /// <summary>
    ///   Location information of the HID device.
    /// </summary>
    property Location: string read FLocation write FLocation;
    /// <summary>
    ///   Hardware ID of the HID device.
    /// </summary>
    property HardwareID: string read FHardwareID write FHardwareID;
    /// <summary>
    ///   Compatible IDs of the HID device.
    /// </summary>
    property CompatibleIDs: string read FCompatibleIDs write FCompatibleIDs;
    /// <summary>
    ///   Service associated with the HID device.
    /// </summary>
    property Service: string read FService write FService;
    /// <summary>
    ///   Device class of the HID device.
    /// </summary>
    property DeviceClass: string read FDeviceClass write FDeviceClass;
    /// <summary>
    ///   Class GUID of the HID device.
    /// </summary>
    property ClassGUID: string read FClassGUID write FClassGUID;
    /// <summary>
    ///   Driver associated with the HID device.
    /// </summary>
    property Driver: string read FDriver write FDriver;
    /// <summary>
    ///   Physical device object name of the HID device.
    /// </summary>
    property PhysicalDeviceObjectName: string read FPhysicalDeviceObjectName write FPhysicalDeviceObjectName;
    /// <summary>
    ///   Capabilities of the HID device.
    /// </summary>
    property Capabilities: string read FCapabilities write FCapabilities;
    /// <summary>
    ///   UI number of the HID device.
    /// </summary>
    property UIDNumber: string read FUIDNumber write FUIDNumber;
    /// <summary>
    ///   Manufacturer string from the HID device.
    /// </summary>
    property ManufacturerString: string read FManufacturerString write FManufacturerString;
    /// <summary>
    ///   Product string from the HID device.
    /// </summary>
    property ProductString: string read FProductString write FProductString;
    /// <summary>
    ///   Serial number string from the HID device.
    /// </summary>
    property SerialNumberString: string read FSerialNumberString write FSerialNumberString;
    /// <summary>
    ///   Number of input buttons on the HID device.
    /// </summary>
    property NumberInputButtons: WORD read FNumberInputButtons write FNumberInputButtons;
    /// <summary>
    ///   Number of output buttons on the HID device.
    /// </summary>
    property NumberOutputButtons: WORD read FNumberOutputButtons write FNumberOutputButtons;
    /// <summary>
    ///   Number of feature buttons on the HID device.
    /// </summary>
    property NumberFeatureButtons: WORD read FNumberFeatureButtons write FNumberFeatureButtons;
    /// <summary>
    ///   Number of input axes on the HID device.
    /// </summary>
    property NumberInputAxes: WORD read FNumberInputAxes write FNumberInputAxes;
    /// <summary>
    ///   Number of output axes on the HID device.
    /// </summary>
    property NumberOutputAxes: WORD read FNumberOutputAxes write FNumberOutputAxes;
    /// <summary>
    ///   Number of feature axes on the HID device.
    /// </summary>
    property NumberFeatureAxes: WORD read FNumberFeatureAxes write FNumberFeatureAxes;
    /// <summary>
    ///   Interface number of the HID device.
    /// </summary>
    property InterfaceNumber: Integer read FInterfaceNumber write FInterfaceNumber;
  end;

type
  /// <summary>
  ///   HID Device List Class.
  /// </summary>
  THIDDeviceList = class
  private
    /// <summary>
    ///   Handle for a hidden window. We need this to be able to
    ///   listen to usb device insert/removal events.
    /// </summary>
    FUSBHandle: HWND;
    /// <summary>
    ///   Event when new USB devices is added
    /// </summary>
    FOnUSBArrival: TNotifyEvent;
    /// <summary>
    ///   Event when USB device is removed
    /// </summary>
    FOnUSBRemoval: TNotifyEvent;
    /// <summary>
    ///   Event for both arrival/removal
    /// </summary>
    FOnUSBChanged: TNotifyEvent;

    /// <summary>
    ///   Hidden window message handler
    /// </summary>
    procedure USBWndProc(var Msg: TMessage);
  private
    /// <summary>
    ///   List containing the HID devices.
    /// </summary>
    FDevices: TList;
    /// <summary>
    ///   Retrieves a device property as a string.
    /// </summary>
    /// <param name="DeviceInfoSet">Handle to the device information set.</param>
    /// <param name="DeviceInfoData">Pointer to the SP_DEVINFO_DATA structure.</param>
    /// <param name="Property_">Property identifier.</param>
    /// <returns>Property value as a string.</returns>
    function GetDevicePropertyW(DeviceInfoSet: HDEVINFO; DeviceInfoData: PSP_DEVINFO_DATA; Property_: DWORD): string;
    /// <summary>
    ///   Retrieves a HID string.
    /// </summary>
    /// <param name="DeviceHandle">Handle to the HID device.</param>
    /// <param name="HIDStringType">Type of HID string to retrieve.</param>
    /// <returns>HID string.</returns>
    function GetHIDString(DeviceHandle: THandle; HIDStringType: DWORD): string;
    /// <summary>
    ///   Retrieves the capabilities of a HID device.
    /// </summary>
    /// <param name="DeviceHandle">Handle to the HID device.</param>
    /// <param name="Caps">Output HIDP_CAPS structure.</param>
    /// <returns>True if successful, otherwise False.</returns>
    function GetHIDCapabilities(DeviceHandle: THandle; out Caps: HIDP_CAPS): Boolean;
    /// <summary>
    ///   Adds a HID device to the list.
    /// </summary>
    /// <param name="DeviceInfoSet">Handle to the device information set.</param>
    /// <param name="DeviceInterfaceData">SP_DEVICE_INTERFACE_DATA structure.</param>
    procedure AddDevice(DeviceInfoSet: HDEVINFO; DeviceInterfaceData: SP_DEVICE_INTERFACE_DATA);

    /// <summary>
    ///   Get a HID device from the list.
    /// </summary>
    /// <param name="Index">Index of the device in the list.</param>
    function GetDevice(Index: Integer): THIDDevice;
  public
    /// <summary>
    ///   Constructor
    /// </summary>
    constructor Create; virtual;
    /// <summary>
    ///   Destructor
    /// </summary>
    destructor Destroy; override;

    /// <summary>
    ///   Refresh the list of HID devices.
    /// </summary>
    function Refresh: Boolean;
    /// <summary>
    ///   Clear the list of HID devices.
    /// </summary>
    procedure Clear;
    /// <summary>
    ///   Get the number of devices in the list
    /// </summary>
    function Count: Integer;
    /// <summary>
    ///   Find device based on product string and interface number
    /// </summary>
    function FindDevice(const ProductString: string; const InterfaceNumber: Integer): THIDDevice;

    /// <summary>
    ///   Panels
    /// </summary>
    property Devices[Index: Integer]: THIDDevice read GetDevice; default;

    /// <summary>
    ///   Event when new USB devices is added
    /// </summary>
    property OnUSBArrival: TNotifyEvent read FOnUSBArrival write FOnUSBArrival;
    /// <summary>
    ///   Event when USB device is removed
    /// </summary>
    property OnUSBRemoval: TNotifyEvent read FOnUSBRemoval write FOnUSBRemoval;
    /// <summary>
    ///   Event for both arrival/removal
    /// </summary>
    property OnUSBChanged: TNotifyEvent read FOnUSBChanged write FOnUSBChanged;
  end;

// SetupAPI.dll
function SetupDiGetClassDevsW(ClassGuid: PGUID; Enumerator: PWideChar; hwndParent: HWND; Flags: DWORD): HDEVINFO; stdcall; external SETUPAPI_DLL name 'SetupDiGetClassDevsW';
function SetupDiEnumDeviceInterfaces(DeviceInfoSet: HDEVINFO; DeviceInfoData: PSP_DEVINFO_DATA; InterfaceClassGuid: PGUID; MemberIndex: DWORD; DeviceInterfaceData: PSP_DEVICE_INTERFACE_DATA): BOOL; stdcall; external SETUPAPI_DLL name 'SetupDiEnumDeviceInterfaces';
function SetupDiGetDeviceInterfaceDetailW(DeviceInfoSet: HDEVINFO; DeviceInterfaceData: PSP_DEVICE_INTERFACE_DATA; DeviceInterfaceDetailData: PSP_DEVICE_INTERFACE_DETAIL_DATA_W; DeviceInterfaceDetailDataSize: DWORD; RequiredSize: PDWORD; DeviceInfoData: PSP_DEVINFO_DATA): BOOL; stdcall; external SETUPAPI_DLL name 'SetupDiGetDeviceInterfaceDetailW';
function SetupDiDestroyDeviceInfoList(DeviceInfoSet: HDEVINFO): BOOL; stdcall; external SETUPAPI_DLL name 'SetupDiDestroyDeviceInfoList';
function SetupDiGetDeviceRegistryPropertyW(DeviceInfoSet: HDEVINFO; DeviceInfoData: PSP_DEVINFO_DATA; Property_: DWORD; PropertyRegDataType: PDWORD; PropertyBuffer: PBYTE; PropertyBufferSize: DWORD; RequiredSize: PDWORD): BOOL; stdcall; external SETUPAPI_DLL name 'SetupDiGetDeviceRegistryPropertyW';

// hid.dll
function HidD_GetManufacturerString(HidDeviceObject: THandle; Buffer: PWideChar; BufferLength: ULONG): BOOL; stdcall; external HID_DLL name 'HidD_GetManufacturerString';
function HidD_GetProductString(HidDeviceObject: THandle; Buffer: PWideChar; BufferLength: ULONG): BOOL; stdcall; external HID_DLL name 'HidD_GetProductString';
function HidD_GetSerialNumberString(HidDeviceObject: THandle; Buffer: PWideChar; BufferLength: ULONG): BOOL; stdcall; external HID_DLL name 'HidD_GetSerialNumberString';
function HidD_GetPreparsedData(HidDeviceObject: THandle; var PreparsedData: PHIDP_PREPARSED_DATA): BOOL; stdcall; external HID_DLL name 'HidD_GetPreparsedData';
function HidD_FreePreparsedData(PreparsedData: PHIDP_PREPARSED_DATA): BOOL; stdcall; external HID_DLL name 'HidD_FreePreparsedData';
function HidP_GetCaps(PreparsedData: PHIDP_PREPARSED_DATA; var Capabilities: HIDP_CAPS): NTSTATUS; stdcall; external HID_DLL name 'HidP_GetCaps';

implementation

//------------------------------------------------------------------------------
// OPEN HID DEVICE
//------------------------------------------------------------------------------
function THIDDevice.Open: Boolean;
begin
  // Open a handle to the HID device
  FDeviceHandle := CreateFile(PChar(FDevicePath), GENERIC_WRITE, FILE_SHARE_WRITE, nil, OPEN_EXISTING, 0, 0);
  // Check if the handle is valid
  Result := FDeviceHandle <> INVALID_HANDLE_VALUE;
end;

//------------------------------------------------------------------------------
// CLOSE HID DEVICE
//------------------------------------------------------------------------------
procedure THIDDevice.Close;
begin
  // Close the handle to the HID device
  CloseHandle(FDeviceHandle);
end;

//------------------------------------------------------------------------------
// WRITE DATA TO HID DEVICE
//------------------------------------------------------------------------------
function THIDDevice.Write(const Macro: THIDMacro): Boolean;
var
  BytesWritten: Cardinal;
begin
  // Write data to the HID device
  Result := WriteFile(FDeviceHandle, Macro[0], Length(Macro), BytesWritten, nil);
end;

//------------------------------------------------------------------------------
// CONSTRUCTOR
//------------------------------------------------------------------------------
constructor THIDDeviceList.Create;
var
  DBI: DEV_BROADCAST_DEVICEINTERFACE;
  Size: Integer;
begin
  // Call inherited constructor
  inherited Create;
  // Create the list for storing the HID devices
  FDevices := TList.Create;
  // Create the hidden window for USB arrival/removal
  FUSBHandle := AllocateHWnd(USBWndProc);
  // Register the USB listener
  Size := SizeOf(DEV_BROADCAST_DEVICEINTERFACE);
  ZeroMemory(@DBI, Size);
  DBI.dbcc_size := Size;
  DBI.dbcc_devicetype := DBT_DEVTYP_DEVICEINTERFACE;
  DBI.dbcc_reserved := 0;
  DBI.dbcc_classguid  := GUID_DEVINTERFACE_USB_DEVICE;
  DBI.dbcc_name := 0;
  RegisterDeviceNotification(FUSBHandle, @DBI, DEVICE_NOTIFY_WINDOW_HANDLE);
end;

//------------------------------------------------------------------------------
// DESTRUCTOR
//------------------------------------------------------------------------------
destructor THIDDeviceList.Destroy;
var
  I: Integer;
begin
  // Free all the HID devices
  for I := 0 to FDevices.Count - 1 do THIDDevice(FDevices[I]).Free;
  // Free the HID device list
  FDevices.Free;
  // Call inherited destructor
  inherited;
end;

//------------------------------------------------------------------------------
// USB WND PROC
//------------------------------------------------------------------------------
procedure THIDDeviceList.USBWndProc(var Msg: TMessage);
var
  DeviceType: Integer;
  Data: PDEV_BROADCAST_HDR;
begin
  // Only handle device change messages
  if (Msg.Msg = WM_DEVICECHANGE) then
  begin
    try
      // Handle device arrival and removal
      if (Msg.wParam = DBT_DEVICEARRIVAL) or (Msg.wParam = DBT_DEVICEREMOVECOMPLETE) then
      begin
        // Get Data
        Data := PDEV_BROADCAST_HDR(Msg.lParam);
        // Get device type
        DeviceType := Data^.dbch_devicetype;
        // Make sure we are handling events for the right device type (USB) only
        if (DeviceType = DBT_DEVTYP_DEVICEINTERFACE) then
        begin
          // Arrival
          if Msg.wParam = DBT_DEVICEARRIVAL then
          begin
            if Assigned(OnUSBArrival) then OnUSBArrival(Self);
          end else
          // Removal
          begin
            if Assigned(OnUSBRemoval) then OnUSBRemoval(Self);
          end;
          // Both
          if Assigned(OnUSBChanged) then OnUSBChanged(Self);
        end;
      end;
    except
      // When an error occurs, let the application handle the exception
      Application.HandleException(Self);
    end;
  end else
  // Let Windows handle other messages.
  Msg.Result := DefWindowProc(FUSBHandle, Msg.Msg, Msg.wParam, Msg.lParam);
end;

//------------------------------------------------------------------------------
// GET HID DEVICE PROPERTY
//------------------------------------------------------------------------------
function THIDDeviceList.GetDevicePropertyW(DeviceInfoSet: Pointer; DeviceInfoData: PSP_DEVINFO_DATA; Property_: Cardinal): string;
var
  Buffer: array[0..1023] of WideChar;
  RequiredSize: DWORD;
  RegDataType: DWORD;
begin
  // Initialize result
  Result := '';
  // Try to get the Device Registry Property
  if SetupDiGetDeviceRegistryPropertyW(DeviceInfoSet, DeviceInfoData, Property_, @RegDataType, @Buffer[0], SizeOf(Buffer), @RequiredSize) then
  begin
    // Set the result
    Result := Buffer;
  end;
end;

//------------------------------------------------------------------------------
// GET HID DEVICE STRING
//------------------------------------------------------------------------------
function THIDDeviceList.GetHIDString(DeviceHandle: NativeUInt; HIDStringType: Cardinal): string;
var
  Buffer: array[0..255] of WideChar;
begin
  // Initialize result
  Result := '';

  case HIDStringType of
    // HID Manufacturer string.
    HID_MANUFACTURER_STRING:
      if HidD_GetManufacturerString(DeviceHandle, Buffer, SizeOf(Buffer)) then Result := Buffer;

    // HID Product string.
    HID_PRODUCT_STRING:
      if HidD_GetProductString(DeviceHandle, Buffer, SizeOf(Buffer)) then Result := Buffer;

    // HID Serial Code string.
    HID_SERIALCODE_STRING:
      if HidD_GetSerialNumberString(DeviceHandle, Buffer, SizeOf(Buffer)) then Result := Buffer;
  end;
end;

//------------------------------------------------------------------------------
// GET HID DEVICE CAPABILITIES
//------------------------------------------------------------------------------
function THIDDeviceList.GetHIDCapabilities(DeviceHandle: NativeUInt; out Caps: HIDP_CAPS): Boolean;
var
  PreparsedData: PHIDP_PREPARSED_DATA;
begin
  // Initialize result
  Result := False;
  // Try to get the Preparsed data
  if HidD_GetPreparsedData(DeviceHandle, PreparsedData) then
  try
    // Set result
    Result := HidP_GetCaps(PreparsedData, Caps) = HIDP_STATUS_SUCCESS;
  finally
    // Free the preparsed data
    HidD_FreePreparsedData(PreparsedData);
  end;
end;

//------------------------------------------------------------------------------
// ADD HID DEVICE
//------------------------------------------------------------------------------
procedure THIDDeviceList.AddDevice(DeviceInfoSet: HDEVINFO; DeviceInterfaceData: SP_DEVICE_INTERFACE_DATA);

  function GetInterfaceNumber(DevicePath: string): DWORD;
  var
    InterfaceNumberStr: string;
    VidPos, MiPos: Integer;
  begin
    // Initialize result
    Result := 0;
    // Find VID pos
    VidPos := Pos('#vid_', LowerCase(DevicePath));

    // If we found the VID pos
    if VidPos > 0 then
    begin
      // Find MI pos
      MiPos := Pos('mi_', LowerCase(Copy(DevicePath, VidPos + 1, Length(DevicePath) - VidPos)));
      // If we found MI pos
      if MiPos > 0 then
      begin
        // Adjust offset
        Inc(MiPos, VidPos);
        // Extract the interface number
        InterfaceNumberStr := Copy(DevicePath, MiPos + 3, 2);
        Result := StrToIntDef(InterfaceNumberStr, 1);
      end;
    end;
  end;

var
  DeviceInterfaceDetailData: PSP_DEVICE_INTERFACE_DETAIL_DATA_W;
  DeviceInfoData: SP_DEVINFO_DATA;
  RequiredSize, DetailDataSize: DWORD;
  DeviceHandle: THandle;
  HIDDevice: THIDDevice;
  HIDCaps: HIDP_CAPS;
begin
  // Retrieve the required size for the device interface detail data structure.
  SetupDiGetDeviceInterfaceDetailW(DeviceInfoSet, @DeviceInterfaceData, nil, 0, @RequiredSize, nil);
  DetailDataSize := RequiredSize;

  // Allocate memory for the device interface detail data structure.
  GetMem(DeviceInterfaceDetailData, DetailDataSize);
  try
    // Set the size of the device interface detail data structure.
    DeviceInterfaceDetailData.cbSize := SizeOf(DWORD) + SizeOf(WideChar);

    // Initialize the device information data structure to zero.
    ZeroMemory(@DeviceInfoData, SizeOf(DeviceInfoData));
    DeviceInfoData.cbSize := SizeOf(DeviceInfoData);

    // Retrieve the device interface detail.
    if SetupDiGetDeviceInterfaceDetailW(DeviceInfoSet, @DeviceInterfaceData, DeviceInterfaceDetailData, DetailDataSize, @RequiredSize, @DeviceInfoData) then
    begin
      // Create a new HID device instance.
      HIDDevice := THIDDevice.Create;

      // Store the device path in the HID device instance.
      HIDDevice.DevicePath := WideCharToString(@DeviceInterfaceDetailData.DevicePath);

      // Open a handle to the HID device.
      DeviceHandle := CreateFile(PChar(HIDDevice.DevicePath), GENERIC_READ or GENERIC_WRITE, FILE_SHARE_READ or FILE_SHARE_WRITE, nil, OPEN_EXISTING, 0, 0);
      if DeviceHandle <> INVALID_HANDLE_VALUE then
      begin
        // Retrieve and store the manufacturer string.
        HIDDevice.ManufacturerString := GetHIDString(DeviceHandle, 1);
        // Retrieve and store the product string.
        HIDDevice.ProductString := GetHIDString(DeviceHandle, 2);
        // Retrieve and store the serial number string.
        HIDDevice.SerialNumberString := GetHIDString(DeviceHandle, 3);

        // Retrieve and store the HID capabilities.
        if GetHIDCapabilities(DeviceHandle, HIDCaps) then
        begin
          HIDDevice.NumberInputButtons := HIDCaps.NumberInputButtonCaps;
          HIDDevice.NumberOutputButtons := HIDCaps.NumberOutputButtonCaps;
          HIDDevice.NumberFeatureButtons := HIDCaps.NumberFeatureButtonCaps;
          HIDDevice.NumberInputAxes := HIDCaps.NumberInputValueCaps;
          HIDDevice.NumberOutputAxes := HIDCaps.NumberOutputValueCaps;
          HIDDevice.NumberFeatureAxes := HIDCaps.NumberFeatureValueCaps;
        end;

        // Close the handle to the HID device.
        CloseHandle(DeviceHandle);
      end;

      // Retrieve and store the device description.
      HIDDevice.Description := GetDevicePropertyW(DeviceInfoSet, @DeviceInfoData, SPDRP_DEVICEDESC);
      // Retrieve and store the manufacturer name.
      HIDDevice.Manufacturer := GetDevicePropertyW(DeviceInfoSet, @DeviceInfoData, SPDRP_MFG);
      // Retrieve and store the friendly name.
      HIDDevice.FriendlyName := GetDevicePropertyW(DeviceInfoSet, @DeviceInfoData, SPDRP_FRIENDLYNAME);
      // Retrieve and store the location information.
      HIDDevice.Location := GetDevicePropertyW(DeviceInfoSet, @DeviceInfoData, SPDRP_LOCATION_INFORMATION);
      // Retrieve and store the hardware ID.
      HIDDevice.HardwareID := GetDevicePropertyW(DeviceInfoSet, @DeviceInfoData, SPDRP_HARDWAREID);
      // Retrieve and store the compatible IDs.
      HIDDevice.CompatibleIDs := GetDevicePropertyW(DeviceInfoSet, @DeviceInfoData, SPDRP_COMPATIBLEIDS);
      // Retrieve and store the service name.
      HIDDevice.Service := GetDevicePropertyW(DeviceInfoSet, @DeviceInfoData, SPDRP_SERVICE);
      // Retrieve and store the device class.
      HIDDevice.DeviceClass := GetDevicePropertyW(DeviceInfoSet, @DeviceInfoData, SPDRP_CLASS);
      // Retrieve and store the class GUID.
      HIDDevice.ClassGUID := GetDevicePropertyW(DeviceInfoSet, @DeviceInfoData, SPDRP_CLASSGUID);
      // Retrieve and store the driver key.
      HIDDevice.Driver := GetDevicePropertyW(DeviceInfoSet, @DeviceInfoData, SPDRP_DRIVER);
      // Retrieve and store the physical device object name.
      HIDDevice.PhysicalDeviceObjectName := GetDevicePropertyW(DeviceInfoSet, @DeviceInfoData, SPDRP_PHYSICAL_DEVICE_OBJECT_NAME);
      // Retrieve and store the capabilities.
      HIDDevice.Capabilities := GetDevicePropertyW(DeviceInfoSet, @DeviceInfoData, SPDRP_CAPABILITIES);
      // Retrieve and store the UI number.
      HIDDevice.UIDNumber := GetDevicePropertyW(DeviceInfoSet, @DeviceInfoData, SPDRP_UINUMBER);
      // Extract the interface number from the device path
      HIDDevice.InterfaceNumber := GetInterfaceNumber(HIDDevice.DevicePath);

      // Add the HID device to the device list.
      FDevices.Add(HIDDevice);
    end;
  finally
    // Free the allocated memory for the device interface detail data structure.
    FreeMem(DeviceInterfaceDetailData);
  end;
end;

//------------------------------------------------------------------------------
// GET HID DEVICE BY INDEX
//------------------------------------------------------------------------------
function THIDDeviceList.GetDevice(Index: Integer): THIDDevice;
begin
  // Initialize result
  Result := nil;
  // Exit here if the index is out of range
  if (Index < 0) or (Index > FDevices.Count -1) then Exit;
  // Return the device from the list of devices
  Result := FDevices.Items[Index];
end;

//------------------------------------------------------------------------------
// REFRESH HID DEVICE LIST
//------------------------------------------------------------------------------
function THIDDeviceList.Refresh: Boolean;
var
  DeviceInfoSet: HDEVINFO;
  DeviceInterfaceData: SP_DEVICE_INTERFACE_DATA;
  MemberIndex: DWORD;
begin
  // Initialize result
  Result := False;

  // Clear the list with HID devices
  FDevices.Clear;

  // Retrieve a handle to a device information set that contains devices that
  // are currently present and expose the specified device interface.
  DeviceInfoSet := SetupDiGetClassDevsW(@GUID_DEVINTERFACE_HID, nil, 0, DIGCF_PRESENT or DIGCF_DEVICEINTERFACE);

  // Check if the handle to the device information set is valid.
  if DeviceInfoSet = nil then Exit;

  try
    MemberIndex := 0;
    while True do
    begin
      // Initialize the device interface data structure to zero.
      ZeroMemory(@DeviceInterfaceData, SizeOf(DeviceInterfaceData));
      DeviceInterfaceData.cbSize := SizeOf(DeviceInterfaceData);

      // Enumerate the device interfaces in the device information set.
      if not SetupDiEnumDeviceInterfaces(DeviceInfoSet, nil, @GUID_DEVINTERFACE_HID, MemberIndex, @DeviceInterfaceData) then Break;

      // Add the enumerated device to the list.
      AddDevice(DeviceInfoSet, DeviceInterfaceData);
      Inc(MemberIndex);
    end;
  finally
    // Destroy the device information set and release associated resources.
    SetupDiDestroyDeviceInfoList(DeviceInfoSet);
  end;

  // Set the result to true, indicating success
  Result := True;
end;

//------------------------------------------------------------------------------
// CLEAR DEVICES IN THE LIST
//------------------------------------------------------------------------------
procedure THIDDeviceList.Clear;
begin
  FDevices.Clear;
end;

//------------------------------------------------------------------------------
// GET THE NUMBER OF DEVICES IN THE LIST
//------------------------------------------------------------------------------
function THIDDeviceList.Count: Integer;
begin
  Result := FDevices.Count;
end;

//------------------------------------------------------------------------------
// FIND DEVICE BY PRODUCT STRING AND INTERFACE NUMBER
//------------------------------------------------------------------------------
function THIDDeviceList.FindDevice(const ProductString: string; const InterfaceNumber: Integer): THIDDevice;
var
  I: Integer;
begin
  // Set initial result
  Result := nil;
  // First refresh the list
  if not Refresh then Exit;
  // Try to find the device
  for I := 0 to Count - 1 do
  if (CompareText(Devices[I].ProductString, ProductString) = 0) and (Devices[I].InterfaceNumber = InterfaceNumber) then
  begin
    // Set result to found device
    Result := Devices[I];
    // Break the loop
    Break;
  end;
end;

end.
