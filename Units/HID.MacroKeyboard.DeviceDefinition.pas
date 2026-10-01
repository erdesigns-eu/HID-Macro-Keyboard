//------------------------------------------------------------------------------
// UNIT           : HID.MacroKeyboard.DeviceDefinition.pas
// CONTENTS       : Data-driven device identity and protocol mappings
// TARGET         : Embarcadero Delphi 11 or higher
//------------------------------------------------------------------------------
unit HID.MacroKeyboard.DeviceDefinition;

interface

uses
  System.Classes, System.Generics.Collections, System.JSON, System.SysUtils,
  HID, HID.MacroKeyboard, HID.MacroKeyboard.Layout;

const
  /// <summary>Current JSON device-definition schema version.</summary>
  MacroKeyboardDeviceSchemaVersion = 1;
  /// <summary>Maximum accepted device-definition file size.</summary>
  MaximumDeviceDefinitionSize = 1024 * 1024;
  /// <summary>Maximum action mappings accepted in one device definition.</summary>
  MaximumDeviceActionCount = 256;

type
  /// <summary>Logical hardware action represented by a profile entry.</summary>
  TMacroKeyboardActionKind = (makPress, makClockwise, makCounterClockwise,
    makEncoderClick);

  /// <summary>Matches a definition to a USB HID device.</summary>
  TMacroKeyboardDeviceMatch = class(TPersistent)
  private
    FInterfaceNumber: Integer;
    FProductID: Word;
    FProductString: string;
    FVendorID: Word;
  public
    /// <summary>Copies another device matcher.</summary>
    procedure Assign(Source: TPersistent); override;
    /// <summary>Returns whether the HID device satisfies every configured matcher.</summary>
    function Matches(const Device: THIDDevice): Boolean;
    /// <summary>USB vendor ID, or zero when the definition does not constrain it.</summary>
    property VendorID: Word read FVendorID write FVendorID;
    /// <summary>USB product ID, or zero when the definition does not constrain it.</summary>
    property ProductID: Word read FProductID write FProductID;
    /// <summary>Case-insensitive HID product string, or empty when unconstrained.</summary>
    property ProductString: string read FProductString write FProductString;
    /// <summary>HID interface number, or -1 when unconstrained.</summary>
    property InterfaceNumber: Integer read FInterfaceNumber write FInterfaceNumber;
  end;

  /// <summary>Maps one profile entry and visual control action to a protocol command.</summary>
  TMacroKeyboardActionMapping = class(TPersistent)
  private
    FAction: TMacroKeyboardActionKind;
    FCommand: Integer;
    FControlID: string;
    FProfileIndex: Integer;
  public
    /// <summary>Copies another action mapping.</summary>
    procedure Assign(Source: TPersistent); override;
    /// <summary>Zero-based entry in the macro profile.</summary>
    property ProfileIndex: Integer read FProfileIndex write FProfileIndex;
    /// <summary>Stable visual-layout control identifier.</summary>
    property ControlID: string read FControlID write FControlID;
    /// <summary>Physical action performed by the user.</summary>
    property Action: TMacroKeyboardActionKind read FAction write FAction;
    /// <summary>Protocol-specific command identifier between 0 and 255.</summary>
    property Command: Integer read FCommand write FCommand;
  end;

  /// <summary>Describes device identity, visual layout, protocol, and action mappings.</summary>
  TMacroKeyboardDeviceDefinition = class(TPersistent)
  private
    FActions: TObjectList<TMacroKeyboardActionMapping>;
    FID: string;
    FLayoutFile: string;
    FMatch: TMacroKeyboardDeviceMatch;
    FName: string;
    FProtocolID: string;
    FSourceFile: string;
    /// <summary>Returns the action mapping at a validated index.</summary>
    function GetAction(const Index: Integer): TMacroKeyboardActionMapping;
  public
    /// <summary>Creates an empty device definition.</summary>
    constructor Create;
    /// <summary>Releases match and action objects owned by the definition.</summary>
    destructor Destroy; override;
    /// <summary>Copies another device definition.</summary>
    procedure Assign(Source: TPersistent); override;
    /// <summary>Adds and returns a new action mapping.</summary>
    function AddAction: TMacroKeyboardActionMapping;
    /// <summary>Returns the number of action mappings.</summary>
    function ActionCount: Integer;
    /// <summary>Finds the profile index for a visual control and physical action.</summary>
    /// <returns>The zero-based profile index, or -1 when no mapping exists.</returns>
    function FindProfileIndex(const ControlID: string;
      const Action: TMacroKeyboardActionKind): Integer;
    /// <summary>Finds the mapping for a visual control and physical action.</summary>
    /// <returns>The owned mapping, or nil when no mapping exists.</returns>
    function FindAction(const ControlID: string;
      const Action: TMacroKeyboardActionKind): TMacroKeyboardActionMapping;
    /// <summary>Builds the legacy CH552 12-key/3-encoder definition.</summary>
    procedure CreateDefaultCH552;
    /// <summary>Loads and validates a UTF-8 JSON device definition.</summary>
    procedure LoadFromFile(const FileName: string);
    /// <summary>Loads and validates a device definition from JSON text.</summary>
    procedure LoadFromJSON(const JSON: string);
    /// <summary>Resolves the configured layout relative to the definition source file.</summary>
    function ResolveLayoutFile: string;
    /// <summary>Returns whether every action refers to a control in the layout.</summary>
    function SupportsLayout(const Layout: TMacroKeyboardLayout): Boolean;
    /// <summary>Validates identity, protocol, matcher, and action mappings.</summary>
    procedure Validate;
    /// <summary>Stable device-definition identifier.</summary>
    property ID: string read FID write FID;
    /// <summary>Human-readable device name.</summary>
    property Name: string read FName write FName;
    /// <summary>Protocol adapter identifier.</summary>
    property ProtocolID: string read FProtocolID write FProtocolID;
    /// <summary>Absolute source filename, or empty for a built-in definition.</summary>
    property SourceFile: string read FSourceFile write FSourceFile;
    /// <summary>Relative or absolute JSON layout filename.</summary>
    property LayoutFile: string read FLayoutFile write FLayoutFile;
    /// <summary>USB HID matcher owned by the definition.</summary>
    property Match: TMacroKeyboardDeviceMatch read FMatch;
    /// <summary>Action mapping at the specified index.</summary>
    property Actions[const Index: Integer]: TMacroKeyboardActionMapping read GetAction; default;
  end;

implementation

uses
  System.IOUtils;

function ActionFromText(const Value: string): TMacroKeyboardActionKind;
begin
  if SameText(Value, 'press') then Exit(makPress);
  if SameText(Value, 'clockwise') then Exit(makClockwise);
  if SameText(Value, 'counterClockwise') then Exit(makCounterClockwise);
  if SameText(Value, 'encoderClick') then Exit(makEncoderClick);
  raise EConvertError.CreateFmt('Unsupported action "%s".', [Value]);
end;

procedure TMacroKeyboardDeviceMatch.Assign(Source: TPersistent);
begin
  if Source = Self then Exit;
  if Source is TMacroKeyboardDeviceMatch then
  begin
    FVendorID := TMacroKeyboardDeviceMatch(Source).VendorID;
    FProductID := TMacroKeyboardDeviceMatch(Source).ProductID;
    FProductString := TMacroKeyboardDeviceMatch(Source).ProductString;
    FInterfaceNumber := TMacroKeyboardDeviceMatch(Source).InterfaceNumber;
  end else
    inherited Assign(Source);
end;

function TMacroKeyboardDeviceMatch.Matches(const Device: THIDDevice): Boolean;
begin
  Result := Assigned(Device) and
    ((FVendorID = 0) or (Device.VendorID = FVendorID)) and
    ((FProductID = 0) or (Device.ProductID = FProductID)) and
    ((FProductString = '') or SameText(Device.ProductString, FProductString)) and
    ((FInterfaceNumber < 0) or (Device.InterfaceNumber = FInterfaceNumber));
end;

procedure TMacroKeyboardActionMapping.Assign(Source: TPersistent);
begin
  if Source = Self then Exit;
  if Source is TMacroKeyboardActionMapping then
  begin
    FProfileIndex := TMacroKeyboardActionMapping(Source).ProfileIndex;
    FControlID := TMacroKeyboardActionMapping(Source).ControlID;
    FAction := TMacroKeyboardActionMapping(Source).Action;
    FCommand := TMacroKeyboardActionMapping(Source).Command;
  end else
    inherited Assign(Source);
end;

constructor TMacroKeyboardDeviceDefinition.Create;
begin
  inherited Create;
  FMatch := TMacroKeyboardDeviceMatch.Create;
  FMatch.InterfaceNumber := -1;
  FActions := TObjectList<TMacroKeyboardActionMapping>.Create(True);
end;

destructor TMacroKeyboardDeviceDefinition.Destroy;
begin
  FActions.Free;
  FMatch.Free;
  inherited Destroy;
end;

procedure TMacroKeyboardDeviceDefinition.Assign(Source: TPersistent);
var
  I: Integer;
begin
  if Source = Self then Exit;
  if Source is TMacroKeyboardDeviceDefinition then
  begin
    FID := TMacroKeyboardDeviceDefinition(Source).ID;
    FName := TMacroKeyboardDeviceDefinition(Source).Name;
    FProtocolID := TMacroKeyboardDeviceDefinition(Source).ProtocolID;
    FSourceFile := TMacroKeyboardDeviceDefinition(Source).SourceFile;
    FLayoutFile := TMacroKeyboardDeviceDefinition(Source).LayoutFile;
    FMatch.Assign(TMacroKeyboardDeviceDefinition(Source).Match);
    FActions.Clear;
    for I := 0 to TMacroKeyboardDeviceDefinition(Source).ActionCount - 1 do
      AddAction.Assign(TMacroKeyboardDeviceDefinition(Source)[I]);
  end else
    inherited Assign(Source);
end;

function TMacroKeyboardDeviceDefinition.AddAction: TMacroKeyboardActionMapping;
begin
  Result := TMacroKeyboardActionMapping.Create;
  FActions.Add(Result);
end;

function TMacroKeyboardDeviceDefinition.ActionCount: Integer;
begin
  Result := FActions.Count;
end;

function TMacroKeyboardDeviceDefinition.FindProfileIndex(const ControlID: string;
  const Action: TMacroKeyboardActionKind): Integer;
var
  Mapping: TMacroKeyboardActionMapping;
begin
  Mapping := FindAction(ControlID, Action);
  if Assigned(Mapping) then
    Result := Mapping.ProfileIndex
  else
    Result := -1;
end;

function TMacroKeyboardDeviceDefinition.FindAction(const ControlID: string;
  const Action: TMacroKeyboardActionKind): TMacroKeyboardActionMapping;
var
  I: Integer;
begin
  Result := nil;
  for I := 0 to ActionCount - 1 do
    if SameText(Actions[I].ControlID, ControlID) and
      (Actions[I].Action = Action) then
      Exit(Actions[I]);
end;

procedure TMacroKeyboardDeviceDefinition.CreateDefaultCH552;
const
  Commands: array[0..20] of Byte = (
    1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12,
    KEYBOARD_ROT1_RIGHT, KEYBOARD_ROT1_LEFT, KEYBOARD_ROT1_CLICK,
    KEYBOARD_ROT2_RIGHT, KEYBOARD_ROT2_LEFT, KEYBOARD_ROT2_CLICK,
    KEYBOARD_ROT3_RIGHT, KEYBOARD_ROT3_LEFT, KEYBOARD_ROT3_CLICK);
var
  Action: TMacroKeyboardActionMapping;
  I: Integer;
begin
  FActions.Clear;
  FID := 'ch552-12-key-3-encoder';
  FName := 'CH552 12-key / 3-encoder macro keyboard';
  FProtocolID := 'ch552-v1';
  FLayoutFile := '..\Layouts\12-key-3-encoder.json';
  FMatch.VendorID := 0;
  FMatch.ProductID := 0;
  FMatch.ProductString := 'CH552';
  FMatch.InterfaceNumber := 1;
  for I := 0 to High(Commands) do
  begin
    Action := AddAction;
    Action.ProfileIndex := I;
    Action.Command := Commands[I];
    if I < 12 then
    begin
      Action.ControlID := Format('key-%d', [I + 1]);
      Action.Action := makPress;
    end else
    begin
      Action.ControlID := Format('encoder-%d', [((I - 12) div 3) + 1]);
      case (I - 12) mod 3 of
        0: Action.Action := makClockwise;
        1: Action.Action := makCounterClockwise;
        2: Action.Action := makEncoderClick;
      end;
    end;
  end;
end;

function TMacroKeyboardDeviceDefinition.GetAction(const Index: Integer): TMacroKeyboardActionMapping;
begin
  if (Index < 0) or (Index >= FActions.Count) then
    raise ERangeError.CreateFmt('Action mapping index %d is out of range.', [Index]);
  Result := FActions[Index];
end;

procedure TMacroKeyboardDeviceDefinition.LoadFromFile(const FileName: string);
begin
  if not TFile.Exists(FileName) then
    raise EFileNotFoundException.CreateFmt('Device definition "%s" does not exist.',
      [FileName]);
  if TFile.GetSize(FileName) > MaximumDeviceDefinitionSize then
    raise EStreamError.CreateFmt('Device definition "%s" is too large.', [FileName]);
  LoadFromJSON(TFile.ReadAllText(FileName, TEncoding.UTF8));
  FSourceFile := TPath.GetFullPath(FileName);
end;

procedure TMacroKeyboardDeviceDefinition.LoadFromJSON(const JSON: string);
var
  Action: TMacroKeyboardActionMapping;
  ActionsArray: TJSONArray;
  I: Integer;
  Item: TJSONObject;
  MatchObject: TJSONObject;
  Parsed: TJSONValue;
  Root: TJSONObject;
  Temporary: TMacroKeyboardDeviceDefinition;
  ProductID: Integer;
  VendorID: Integer;
begin
  Parsed := TJSONObject.ParseJSONValue(JSON);
  if not (Parsed is TJSONObject) then
  begin
    Parsed.Free;
    raise EConvertError.Create('The device-definition root must be an object.');
  end;
  Root := TJSONObject(Parsed);
  Temporary := TMacroKeyboardDeviceDefinition.Create;
  try
    if Root.GetValue<Integer>('schemaVersion') <> MacroKeyboardDeviceSchemaVersion then
      raise EConvertError.CreateFmt('Unsupported device schema; expected %d.',
        [MacroKeyboardDeviceSchemaVersion]);
    Temporary.ID := Root.GetValue<string>('id');
    Temporary.Name := Root.GetValue<string>('name');
    Temporary.ProtocolID := Root.GetValue<string>('protocol');
    Temporary.LayoutFile := Root.GetValue<string>('layout');
    MatchObject := Root.GetValue<TJSONObject>('match');
    if not Assigned(MatchObject) then
      raise EConvertError.Create('The definition must contain a match object.');
    VendorID := MatchObject.GetValue<Integer>('vendorId');
    ProductID := MatchObject.GetValue<Integer>('productId');
    if (VendorID < 0) or (VendorID > High(Word)) or
      (ProductID < 0) or (ProductID > High(Word)) then
      raise EConvertError.Create('USB vendorId and productId must fit in 16 bits.');
    Temporary.Match.VendorID := VendorID;
    Temporary.Match.ProductID := ProductID;
    Temporary.Match.ProductString := MatchObject.GetValue<string>('productString');
    Temporary.Match.InterfaceNumber := MatchObject.GetValue<Integer>('interfaceNumber');
    ActionsArray := Root.GetValue<TJSONArray>('actions');
    if not Assigned(ActionsArray) then
      raise EConvertError.Create('The definition must contain an actions array.');
    for I := 0 to ActionsArray.Count - 1 do
    begin
      if not (ActionsArray.Items[I] is TJSONObject) then
        raise EConvertError.CreateFmt('Action mapping %d must be an object.', [I + 1]);
      Item := TJSONObject(ActionsArray.Items[I]);
      Action := Temporary.AddAction;
      Action.ProfileIndex := Item.GetValue<Integer>('profileIndex');
      Action.ControlID := Item.GetValue<string>('controlId');
      Action.Action := ActionFromText(Item.GetValue<string>('action'));
      Action.Command := Item.GetValue<Integer>('command');
    end;
    Temporary.Validate;
    Assign(Temporary);
  finally
    Temporary.Free;
    Root.Free;
  end;
end;

function TMacroKeyboardDeviceDefinition.ResolveLayoutFile: string;
begin
  if TPath.IsPathRooted(FLayoutFile) or (FSourceFile = '') then
    Result := FLayoutFile
  else
    Result := TPath.GetFullPath(TPath.Combine(
      TPath.GetDirectoryName(FSourceFile), FLayoutFile));
end;

function TMacroKeyboardDeviceDefinition.SupportsLayout(
  const Layout: TMacroKeyboardLayout): Boolean;
var
  Found: Boolean;
  I: Integer;
  J: Integer;
begin
  Result := Assigned(Layout);
  if not Result then Exit;
  for I := 0 to ActionCount - 1 do
  begin
    Found := False;
    for J := 0 to Layout.Count - 1 do
      if SameText(Actions[I].ControlID, Layout[J].ID) then
      begin
        Found := ((Actions[I].Action = makPress) and
          (Layout[J].Kind = mckKey)) or
          ((Actions[I].Action <> makPress) and
          (Layout[J].Kind = mckEncoder));
        Break;
      end;
    if not Found then Exit(False);
  end;
end;

procedure TMacroKeyboardDeviceDefinition.Validate;
var
  Action: TMacroKeyboardActionMapping;
  ActionKeys: TDictionary<string, Boolean>;
  I: Integer;
  MappingKey: string;
  ProfileIndexes: TDictionary<Integer, Boolean>;
begin
  if Trim(FID) = '' then raise EConvertError.Create('The device ID cannot be empty.');
  if Trim(FName) = '' then raise EConvertError.Create('The device name cannot be empty.');
  if Trim(FProtocolID) = '' then raise EConvertError.Create('The protocol ID cannot be empty.');
  if Trim(FLayoutFile) = '' then raise EConvertError.Create('The layout filename cannot be empty.');
  if (FMatch.VendorID = 0) and (FMatch.ProductID = 0) and
    (Trim(FMatch.ProductString) = '') then
    raise EConvertError.Create('At least one USB identity matcher is required.');
  if (ActionCount = 0) or (ActionCount > MaximumDeviceActionCount) then
    raise EConvertError.CreateFmt('A definition must contain between 1 and %d actions.',
      [MaximumDeviceActionCount]);

  ProfileIndexes := TDictionary<Integer, Boolean>.Create;
  try
    ActionKeys := TDictionary<string, Boolean>.Create;
    try
      for I := 0 to ActionCount - 1 do
      begin
        Action := Actions[I];
        if Action.ProfileIndex < 0 then
          raise EConvertError.CreateFmt('Action %d has a negative profile index.', [I + 1]);
        if ProfileIndexes.ContainsKey(Action.ProfileIndex) then
          raise EConvertError.CreateFmt('Profile index %d is duplicated.', [Action.ProfileIndex]);
        ProfileIndexes.Add(Action.ProfileIndex, True);
        if Trim(Action.ControlID) = '' then
          raise EConvertError.CreateFmt('Action %d has no control ID.', [I + 1]);
        MappingKey := LowerCase(Action.ControlID) + ':' + IntToStr(Ord(Action.Action));
        if ActionKeys.ContainsKey(MappingKey) then
          raise EConvertError.CreateFmt('Control action "%s" is duplicated.',
            [Action.ControlID]);
        ActionKeys.Add(MappingKey, True);
        if (Action.Command < 0) or (Action.Command > 255) then
          raise EConvertError.CreateFmt('Action %d has an invalid command.', [I + 1]);
      end;
    finally
      ActionKeys.Free;
    end;
  finally
    ProfileIndexes.Free;
  end;
end;

end.
