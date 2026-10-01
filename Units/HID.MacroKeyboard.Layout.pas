//------------------------------------------------------------------------------
// UNIT           : HID.MacroKeyboard.Layout.pas
// CONTENTS       : Data-driven Macro Keyboard Layouts
// TARGET         : Embarcadero Delphi 11 or higher
//------------------------------------------------------------------------------
unit HID.MacroKeyboard.Layout;

interface

uses
  System.Classes, System.Generics.Collections, System.JSON, System.SysUtils,
  System.Types;

const
  /// <summary>Current JSON layout schema version.</summary>
  MacroKeyboardLayoutSchemaVersion = 1;
  /// <summary>Maximum accepted layout file size in bytes.</summary>
  MaximumLayoutFileSize = 1024 * 1024;
  /// <summary>Maximum number of visual controls in one layout.</summary>
  MaximumLayoutControlCount = 128;

type
  /// <summary>Visual control types supported by a macro-keyboard layout.</summary>
  TMacroKeyboardControlKind = (mckKey, mckEncoder);

  /// <summary>Describes one key or rotary encoder in device coordinates.</summary>
  TMacroKeyboardLayoutControl = class(TPersistent)
  private
    FBounds: TRectF;
    FID: string;
    FKind: TMacroKeyboardControlKind;
    FLabel: string;
  public
    /// <summary>Copies another layout control into this instance.</summary>
    procedure Assign(Source: TPersistent); override;
    /// <summary>Stable identifier used to associate the visual control with an action.</summary>
    property ID: string read FID write FID;
    /// <summary>Short text displayed in the visual control.</summary>
    property LabelText: string read FLabel write FLabel;
    /// <summary>Whether the visual control is a key or rotary encoder.</summary>
    property Kind: TMacroKeyboardControlKind read FKind write FKind;
    /// <summary>Position and size in millimetres relative to the device top-left.</summary>
    property Bounds: TRectF read FBounds write FBounds;
  end;

  /// <summary>Owns and validates a complete data-driven macro-keyboard layout.</summary>
  TMacroKeyboardLayout = class(TPersistent)
  private
    FBorderRadius: Single;
    FControls: TObjectList<TMacroKeyboardLayoutControl>;
    FHeight: Single;
    FName: string;
    FWidth: Single;
    function GetControl(const Index: Integer): TMacroKeyboardLayoutControl;
  public
    /// <summary>Creates an empty layout.</summary>
    constructor Create;
    /// <summary>Releases all controls owned by the layout.</summary>
    destructor Destroy; override;
    /// <summary>Copies another layout into this instance.</summary>
    procedure Assign(Source: TPersistent); override;
    /// <summary>Adds and returns a new visual control.</summary>
    function AddControl: TMacroKeyboardLayoutControl;
    /// <summary>Removes all visual controls.</summary>
    procedure Clear;
    /// <summary>Returns the number of visual controls.</summary>
    function Count: Integer;
    /// <summary>Creates the original twelve-key, three-encoder layout.</summary>
    procedure CreateDefault;
    /// <summary>Loads and validates a layout from a UTF-8 JSON file.</summary>
    procedure LoadFromFile(const FileName: string);
    /// <summary>Loads and validates a layout from JSON text.</summary>
    procedure LoadFromJSON(const JSON: string);
    /// <summary>Saves the current validated layout to a UTF-8 JSON file.</summary>
    procedure SaveToFile(const FileName: string);
    /// <summary>Serializes the current validated layout to JSON text.</summary>
    function ToJSON: string;
    /// <summary>Validates dimensions, identifiers, bounds, and control count.</summary>
    procedure Validate;
    /// <summary>Human-readable layout name.</summary>
    property Name: string read FName write FName;
    /// <summary>Physical device width in millimetres.</summary>
    property Width: Single read FWidth write FWidth;
    /// <summary>Physical device height in millimetres.</summary>
    property Height: Single read FHeight write FHeight;
    /// <summary>Device outline radius in millimetres.</summary>
    property BorderRadius: Single read FBorderRadius write FBorderRadius;
    /// <summary>Visual control at the specified zero-based index.</summary>
    property Controls[const Index: Integer]: TMacroKeyboardLayoutControl read GetControl; default;
  end;

implementation

uses
  System.IOUtils, System.Math, Winapi.Windows;

function KindFromText(const Value: string): TMacroKeyboardControlKind;
begin
  if SameText(Value, 'key') then
    Exit(mckKey);
  if SameText(Value, 'encoder') then
    Exit(mckEncoder);
  raise EConvertError.CreateFmt('Unsupported control type "%s".', [Value]);
end;

function KindToText(const Value: TMacroKeyboardControlKind): string;
begin
  case Value of
    mckKey: Result := 'key';
    mckEncoder: Result := 'encoder';
  else
    raise EConvertError.Create('Unsupported control type.');
  end;
end;

procedure TMacroKeyboardLayoutControl.Assign(Source: TPersistent);
begin
  if Source = Self then Exit;
  if Source is TMacroKeyboardLayoutControl then
  begin
    FID := TMacroKeyboardLayoutControl(Source).ID;
    FLabel := TMacroKeyboardLayoutControl(Source).LabelText;
    FKind := TMacroKeyboardLayoutControl(Source).Kind;
    FBounds := TMacroKeyboardLayoutControl(Source).Bounds;
  end else
    inherited Assign(Source);
end;

constructor TMacroKeyboardLayout.Create;
begin
  inherited Create;
  FControls := TObjectList<TMacroKeyboardLayoutControl>.Create(True);
end;

destructor TMacroKeyboardLayout.Destroy;
begin
  FControls.Free;
  inherited Destroy;
end;

procedure TMacroKeyboardLayout.Assign(Source: TPersistent);
var
  I: Integer;
begin
  if Source = Self then Exit;
  if Source is TMacroKeyboardLayout then
  begin
    Clear;
    FName := TMacroKeyboardLayout(Source).Name;
    FWidth := TMacroKeyboardLayout(Source).Width;
    FHeight := TMacroKeyboardLayout(Source).Height;
    FBorderRadius := TMacroKeyboardLayout(Source).BorderRadius;
    for I := 0 to TMacroKeyboardLayout(Source).Count - 1 do
      AddControl.Assign(TMacroKeyboardLayout(Source)[I]);
  end else
    inherited Assign(Source);
end;

function TMacroKeyboardLayout.AddControl: TMacroKeyboardLayoutControl;
begin
  Result := TMacroKeyboardLayoutControl.Create;
  FControls.Add(Result);
end;

procedure TMacroKeyboardLayout.Clear;
begin
  FControls.Clear;
end;

function TMacroKeyboardLayout.Count: Integer;
begin
  Result := FControls.Count;
end;

procedure TMacroKeyboardLayout.CreateDefault;
var
  Control: TMacroKeyboardLayoutControl;
  Column: Integer;
  Index: Integer;
  Row: Integer;
begin
  Clear;
  FName := '12 keys + 3 encoders';
  FWidth := 140;
  FHeight := 83;
  FBorderRadius := 10;

  Index := 0;
  for Row := 0 to 2 do
    for Column := 0 to 3 do
    begin
      Control := AddControl;
      Control.ID := Format('key-%d', [Index + 1]);
      Control.LabelText := IntToStr(Index + 1);
      Control.Kind := mckKey;
      Control.Bounds := TRectF.Create(10 + (Column * 22), 10 + (Row * 22),
        28 + (Column * 22), 28 + (Row * 22));
      Inc(Index);
    end;

  for Row := 0 to 2 do
  begin
    Control := AddControl;
    Control.ID := Format('encoder-%d', [Row + 1]);
    Control.LabelText := IntToStr(Row + 1);
    Control.Kind := mckEncoder;
    Control.Bounds := TRectF.Create(110, 4 + (Row * 27.5), 130,
      24 + (Row * 27.5));
  end;
end;

function TMacroKeyboardLayout.GetControl(const Index: Integer): TMacroKeyboardLayoutControl;
begin
  if (Index < 0) or (Index >= FControls.Count) then
    raise ERangeError.CreateFmt('Layout control index %d is out of range.', [Index]);
  Result := FControls[Index];
end;

procedure TMacroKeyboardLayout.LoadFromFile(const FileName: string);
begin
  if not TFile.Exists(FileName) then
    raise EFileNotFoundException.CreateFmt('Layout file "%s" does not exist.', [FileName]);
  if TFile.GetSize(FileName) > MaximumLayoutFileSize then
    raise EStreamError.CreateFmt('Layout file "%s" is larger than %d bytes.',
      [FileName, MaximumLayoutFileSize]);
  LoadFromJSON(TFile.ReadAllText(FileName, TEncoding.UTF8));
end;

procedure TMacroKeyboardLayout.LoadFromJSON(const JSON: string);
var
  Control: TMacroKeyboardLayoutControl;
  ControlsArray: TJSONArray;
  DeviceObject: TJSONObject;
  I: Integer;
  ItemObject: TJSONObject;
  Parsed: TJSONValue;
  Root: TJSONObject;
  Temporary: TMacroKeyboardLayout;
  X: Double;
  Y: Double;
  W: Double;
  H: Double;
begin
  Parsed := TJSONObject.ParseJSONValue(JSON);
  if not (Parsed is TJSONObject) then
  begin
    Parsed.Free;
    raise EConvertError.Create('The layout root must be a JSON object.');
  end;

  Root := TJSONObject(Parsed);
  Temporary := TMacroKeyboardLayout.Create;
  try
    if Root.GetValue<Integer>('schemaVersion') <> MacroKeyboardLayoutSchemaVersion then
      raise EConvertError.CreateFmt('Unsupported layout schema version; expected %d.',
        [MacroKeyboardLayoutSchemaVersion]);
    Temporary.Name := Root.GetValue<string>('name');
    DeviceObject := Root.GetValue<TJSONObject>('device');
    if not Assigned(DeviceObject) then
      raise EConvertError.Create('The layout must contain a device object.');
    Temporary.Width := DeviceObject.GetValue<Double>('width');
    Temporary.Height := DeviceObject.GetValue<Double>('height');
    Temporary.BorderRadius := DeviceObject.GetValue<Double>('borderRadius');

    ControlsArray := Root.GetValue<TJSONArray>('controls');
    if not Assigned(ControlsArray) then
      raise EConvertError.Create('The layout must contain a controls array.');
    for I := 0 to ControlsArray.Count - 1 do
    begin
      if not (ControlsArray.Items[I] is TJSONObject) then
        raise EConvertError.CreateFmt('Layout control %d must be an object.', [I + 1]);
      ItemObject := TJSONObject(ControlsArray.Items[I]);
      Control := Temporary.AddControl;
      Control.ID := ItemObject.GetValue<string>('id');
      Control.LabelText := ItemObject.GetValue<string>('label');
      Control.Kind := KindFromText(ItemObject.GetValue<string>('type'));
      X := ItemObject.GetValue<Double>('x');
      Y := ItemObject.GetValue<Double>('y');
      W := ItemObject.GetValue<Double>('width');
      H := ItemObject.GetValue<Double>('height');
      Control.Bounds := TRectF.Create(X, Y, X + W, Y + H);
    end;
    Temporary.Validate;
    Assign(Temporary);
  finally
    Temporary.Free;
    Root.Free;
  end;
end;

procedure TMacroKeyboardLayout.SaveToFile(const FileName: string);
var
  TargetFileName: string;
  TemporaryFileName: string;
begin
  Validate;
  TargetFileName := TPath.GetFullPath(FileName);
  TemporaryFileName := TPath.Combine(TPath.GetDirectoryName(TargetFileName),
    TPath.GetRandomFileName);
  try
    TFile.WriteAllText(TemporaryFileName, ToJSON, TEncoding.UTF8);
    if not MoveFileEx(PChar(TemporaryFileName), PChar(TargetFileName),
      MOVEFILE_REPLACE_EXISTING or MOVEFILE_WRITE_THROUGH) then
      RaiseLastOSError;
  finally
    if TFile.Exists(TemporaryFileName) then
      TFile.Delete(TemporaryFileName);
  end;
end;

function TMacroKeyboardLayout.ToJSON: string;
var
  Control: TMacroKeyboardLayoutControl;
  ControlsArray: TJSONArray;
  DeviceObject: TJSONObject;
  I: Integer;
  ItemObject: TJSONObject;
  Root: TJSONObject;
begin
  Validate;
  Root := TJSONObject.Create;
  try
    Root.AddPair('schemaVersion', TJSONNumber.Create(MacroKeyboardLayoutSchemaVersion));
    Root.AddPair('name', FName);
    DeviceObject := TJSONObject.Create;
    DeviceObject.AddPair('width', TJSONNumber.Create(FWidth));
    DeviceObject.AddPair('height', TJSONNumber.Create(FHeight));
    DeviceObject.AddPair('borderRadius', TJSONNumber.Create(FBorderRadius));
    Root.AddPair('device', DeviceObject);
    ControlsArray := TJSONArray.Create;
    Root.AddPair('controls', ControlsArray);
    for I := 0 to Count - 1 do
    begin
      Control := Controls[I];
      ItemObject := TJSONObject.Create;
      ItemObject.AddPair('id', Control.ID);
      ItemObject.AddPair('label', Control.LabelText);
      ItemObject.AddPair('type', KindToText(Control.Kind));
      ItemObject.AddPair('x', TJSONNumber.Create(Control.Bounds.Left));
      ItemObject.AddPair('y', TJSONNumber.Create(Control.Bounds.Top));
      ItemObject.AddPair('width', TJSONNumber.Create(Control.Bounds.Width));
      ItemObject.AddPair('height', TJSONNumber.Create(Control.Bounds.Height));
      ControlsArray.AddElement(ItemObject);
    end;
    Result := Root.ToJSON;
  finally
    Root.Free;
  end;
end;

procedure TMacroKeyboardLayout.Validate;
var
  Control: TMacroKeyboardLayoutControl;
  I: Integer;
  IDs: TDictionary<string, Boolean>;
begin
  if Trim(FName) = '' then
    raise EConvertError.Create('The layout name cannot be empty.');
  if (FWidth <= 0) or IsNan(FWidth) or IsInfinite(FWidth) then
    raise EConvertError.Create('The device width must be a finite positive number.');
  if (FHeight <= 0) or IsNan(FHeight) or IsInfinite(FHeight) then
    raise EConvertError.Create('The device height must be a finite positive number.');
  if (FBorderRadius < 0) or IsNan(FBorderRadius) or IsInfinite(FBorderRadius) then
    raise EConvertError.Create('The border radius must be a finite non-negative number.');
  if (Count = 0) or (Count > MaximumLayoutControlCount) then
    raise EConvertError.CreateFmt('A layout must contain between 1 and %d controls.',
      [MaximumLayoutControlCount]);

  IDs := TDictionary<string, Boolean>.Create;
  try
    for I := 0 to Count - 1 do
    begin
      Control := Controls[I];
      if Trim(Control.ID) = '' then
        raise EConvertError.CreateFmt('Layout control %d has no identifier.', [I + 1]);
      if IDs.ContainsKey(LowerCase(Control.ID)) then
        raise EConvertError.CreateFmt('Layout control identifier "%s" is duplicated.',
          [Control.ID]);
      IDs.Add(LowerCase(Control.ID), True);
      if (Control.Bounds.Width <= 0) or (Control.Bounds.Height <= 0) or
        IsNan(Control.Bounds.Left) or IsNan(Control.Bounds.Top) or
        IsNan(Control.Bounds.Right) or IsNan(Control.Bounds.Bottom) or
        IsInfinite(Control.Bounds.Left) or IsInfinite(Control.Bounds.Top) or
        IsInfinite(Control.Bounds.Right) or IsInfinite(Control.Bounds.Bottom) then
        raise EConvertError.CreateFmt('Layout control "%s" has invalid bounds.',
          [Control.ID]);
      if (Control.Bounds.Left < 0) or (Control.Bounds.Top < 0) or
        (Control.Bounds.Right > FWidth) or (Control.Bounds.Bottom > FHeight) then
        raise EConvertError.CreateFmt('Layout control "%s" is outside the device.',
          [Control.ID]);
    end;
  finally
    IDs.Free;
  end;
end;

end.
