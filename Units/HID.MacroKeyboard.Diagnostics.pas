//------------------------------------------------------------------------------
// UNIT           : HID.MacroKeyboard.Diagnostics.pas
// CONTENTS       : Sanitized device diagnostics export
// TARGET         : Embarcadero Delphi 11 or higher
//------------------------------------------------------------------------------
unit HID.MacroKeyboard.Diagnostics;

interface

uses
  HID, HID.MacroKeyboard.DeviceDefinition;

type
  /// <summary>Builds and saves diagnostics for enumerated macro-keyboard devices.</summary>
  TMacroKeyboardDiagnostics = class sealed
  public
    /// <summary>Builds a JSON diagnostics report.</summary>
    /// <param name="Devices">Current enumerated HID device list.</param>
    /// <param name="Definition">Active device definition, when available.</param>
    /// <param name="IncludeSensitive">Includes paths, serial numbers, and location details when true.</param>
    /// <returns>The complete diagnostics report as JSON text.</returns>
    class function BuildJSON(const Devices: THIDDeviceList;
      const Definition: TMacroKeyboardDeviceDefinition;
      const IncludeSensitive: Boolean): string; static;
    /// <summary>Atomically saves a JSON diagnostics report.</summary>
    /// <param name="FileName">Destination report filename.</param>
    /// <param name="Devices">Current enumerated HID device list.</param>
    /// <param name="Definition">Active device definition, when available.</param>
    /// <param name="IncludeSensitive">Includes paths, serial numbers, and location details when true.</param>
    class procedure SaveToFile(const FileName: string;
      const Devices: THIDDeviceList;
      const Definition: TMacroKeyboardDeviceDefinition;
      const IncludeSensitive: Boolean); static;
  end;

implementation

uses
  System.Classes, System.DateUtils, System.IOUtils, System.JSON, System.SysUtils,
  Winapi.Windows;

class function TMacroKeyboardDiagnostics.BuildJSON(const Devices: THIDDeviceList;
  const Definition: TMacroKeyboardDeviceDefinition;
  const IncludeSensitive: Boolean): string;
var
  Capabilities: TJSONObject;
  DefinitionObject: TJSONObject;
  Device: THIDDevice;
  DeviceArray: TJSONArray;
  DeviceObject: TJSONObject;
  I: Integer;
  MatchesDefinition: Boolean;
  Root: TJSONObject;
begin
  Root := TJSONObject.Create;
  try
    Root.AddPair('schemaVersion', TJSONNumber.Create(1));
    Root.AddPair('generatedAtUtc', DateToISO8601(
      TTimeZone.Local.ToUniversalTime(Now), True));
    Root.AddPair('containsSensitiveData', TJSONBool.Create(IncludeSensitive));
    Root.AddPair('privacyNotice',
      'Serial numbers, device paths, hardware IDs, and locations are excluded unless explicitly requested.');

    if Assigned(Definition) then
    begin
      DefinitionObject := TJSONObject.Create;
      DefinitionObject.AddPair('id', Definition.ID);
      DefinitionObject.AddPair('name', Definition.Name);
      DefinitionObject.AddPair('protocol', Definition.ProtocolID);
      Root.AddPair('activeDefinition', DefinitionObject);
    end;

    DeviceArray := TJSONArray.Create;
    Root.AddPair('devices', DeviceArray);
    if Assigned(Devices) then
      for I := 0 to Devices.Count - 1 do
      begin
        Device := Devices[I];
        DeviceObject := TJSONObject.Create;
        DeviceObject.AddPair('vendorId', Format('0x%.4x', [Device.VendorID]));
        DeviceObject.AddPair('productId', Format('0x%.4x', [Device.ProductID]));
        DeviceObject.AddPair('interfaceNumber', TJSONNumber.Create(Device.InterfaceNumber));
        MatchesDefinition := Assigned(Definition);
        if MatchesDefinition then
          MatchesDefinition := Definition.Match.Matches(Device);
        DeviceObject.AddPair('matchesActiveDefinition',
          TJSONBool.Create(MatchesDefinition));
        DeviceObject.AddPair('manufacturer', Device.ManufacturerString);
        DeviceObject.AddPair('product', Device.ProductString);
        DeviceObject.AddPair('description', Device.Description);
        DeviceObject.AddPair('friendlyName', Device.FriendlyName);
        DeviceObject.AddPair('service', Device.Service);
        DeviceObject.AddPair('deviceClass', Device.DeviceClass);
        DeviceObject.AddPair('classGuid', Device.ClassGUID);
        DeviceObject.AddPair('serialNumberAvailable', TJSONBool.Create(
          Device.SerialNumberString <> ''));

        Capabilities := TJSONObject.Create;
        Capabilities.AddPair('inputButtons', TJSONNumber.Create(Device.NumberInputButtons));
        Capabilities.AddPair('outputButtons', TJSONNumber.Create(Device.NumberOutputButtons));
        Capabilities.AddPair('featureButtons', TJSONNumber.Create(Device.NumberFeatureButtons));
        Capabilities.AddPair('inputAxes', TJSONNumber.Create(Device.NumberInputAxes));
        Capabilities.AddPair('outputAxes', TJSONNumber.Create(Device.NumberOutputAxes));
        Capabilities.AddPair('featureAxes', TJSONNumber.Create(Device.NumberFeatureAxes));
        DeviceObject.AddPair('capabilities', Capabilities);

        if IncludeSensitive then
        begin
          DeviceObject.AddPair('serialNumber', Device.SerialNumberString);
          DeviceObject.AddPair('devicePath', Device.DevicePath);
          DeviceObject.AddPair('location', Device.Location);
          DeviceObject.AddPair('hardwareId', Device.HardwareID);
          DeviceObject.AddPair('compatibleIds', Device.CompatibleIDs);
          DeviceObject.AddPair('driver', Device.Driver);
          DeviceObject.AddPair('physicalDeviceObjectName',
            Device.PhysicalDeviceObjectName);
        end;
        DeviceArray.AddElement(DeviceObject);
      end;
    Result := Root.ToJSON;
  finally
    Root.Free;
  end;
end;

class procedure TMacroKeyboardDiagnostics.SaveToFile(const FileName: string;
  const Devices: THIDDeviceList;
  const Definition: TMacroKeyboardDeviceDefinition;
  const IncludeSensitive: Boolean);
var
  TargetFileName: string;
  TemporaryFileName: string;
begin
  TargetFileName := TPath.GetFullPath(FileName);
  TemporaryFileName := TPath.Combine(TPath.GetDirectoryName(TargetFileName),
    TPath.GetRandomFileName);
  try
    TFile.WriteAllText(TemporaryFileName,
      BuildJSON(Devices, Definition, IncludeSensitive), TEncoding.UTF8);
    if not MoveFileEx(PChar(TemporaryFileName), PChar(TargetFileName),
      MOVEFILE_REPLACE_EXISTING or MOVEFILE_WRITE_THROUGH) then
      RaiseLastOSError;
  finally
    if TFile.Exists(TemporaryFileName) then
      TFile.Delete(TemporaryFileName);
  end;
end;

end.
