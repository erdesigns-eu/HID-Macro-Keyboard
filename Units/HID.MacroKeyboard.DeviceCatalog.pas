//------------------------------------------------------------------------------
// UNIT           : HID.MacroKeyboard.DeviceCatalog.pas
// CONTENTS       : Trusted device-definition catalog and matching
// TARGET         : Embarcadero Delphi 11 or higher
//------------------------------------------------------------------------------
unit HID.MacroKeyboard.DeviceCatalog;

interface

uses
  System.Generics.Collections, HID, HID.MacroKeyboard.DeviceDefinition;

type
  /// <summary>Owns trusted device definitions and selects the most specific match.</summary>
  TMacroKeyboardDeviceCatalog = class
  private
    FDefinitions: TObjectList<TMacroKeyboardDeviceDefinition>;
    /// <summary>Returns the definition at a validated zero-based index.</summary>
    function GetDefinition(const Index: Integer): TMacroKeyboardDeviceDefinition;
    /// <summary>Calculates matcher specificity for deterministic selection.</summary>
    function MatchScore(const Definition: TMacroKeyboardDeviceDefinition): Integer;
  public
    /// <summary>Creates an empty owning definition catalog.</summary>
    constructor Create;
    /// <summary>Releases every definition owned by the catalog.</summary>
    destructor Destroy; override;
    /// <summary>Adds a validated copy of a device definition.</summary>
    procedure Add(const Definition: TMacroKeyboardDeviceDefinition);
    /// <summary>Removes all device definitions.</summary>
    procedure Clear;
    /// <summary>Returns the number of loaded definitions.</summary>
    function Count: Integer;
    /// <summary>Transactionally loads every JSON definition in a trusted directory.</summary>
    procedure LoadDirectory(const DirectoryName: string);
    /// <summary>Finds the single most-specific definition matching a HID device.</summary>
    /// <param name="Device">Enumerated HID interface to match.</param>
    /// <param name="ErrorMessage">Conflict details when equally specific definitions match.</param>
    /// <returns>The catalog-owned definition, or nil when none or conflicting definitions match.</returns>
    function FindBestMatch(const Device: THIDDevice;
      out ErrorMessage: string): TMacroKeyboardDeviceDefinition;
    /// <summary>Definition at the specified zero-based index.</summary>
    property Definitions[const Index: Integer]: TMacroKeyboardDeviceDefinition read GetDefinition; default;
  end;

implementation

uses
  System.Classes, System.IOUtils, System.SysUtils;

constructor TMacroKeyboardDeviceCatalog.Create;
begin
  inherited Create;
  FDefinitions := TObjectList<TMacroKeyboardDeviceDefinition>.Create(True);
end;

destructor TMacroKeyboardDeviceCatalog.Destroy;
begin
  FDefinitions.Free;
  inherited Destroy;
end;

procedure TMacroKeyboardDeviceCatalog.Add(
  const Definition: TMacroKeyboardDeviceDefinition);
var
  CopyDefinition: TMacroKeyboardDeviceDefinition;
  I: Integer;
begin
  if not Assigned(Definition) then
    raise EArgumentNilException.Create('Definition');
  Definition.Validate;
  for I := 0 to Count - 1 do
    if SameText(Definitions[I].ID, Definition.ID) then
      raise EInvalidOperation.CreateFmt('Device definition ID "%s" is duplicated.',
        [Definition.ID]);
  CopyDefinition := TMacroKeyboardDeviceDefinition.Create;
  try
    CopyDefinition.Assign(Definition);
    FDefinitions.Add(CopyDefinition);
    CopyDefinition := nil;
  finally
    CopyDefinition.Free;
  end;
end;

procedure TMacroKeyboardDeviceCatalog.Clear;
begin
  FDefinitions.Clear;
end;

function TMacroKeyboardDeviceCatalog.Count: Integer;
begin
  Result := FDefinitions.Count;
end;

function TMacroKeyboardDeviceCatalog.GetDefinition(
  const Index: Integer): TMacroKeyboardDeviceDefinition;
begin
  if (Index < 0) or (Index >= Count) then
    raise ERangeError.CreateFmt('Device definition index %d is out of range.', [Index]);
  Result := FDefinitions[Index];
end;

function TMacroKeyboardDeviceCatalog.MatchScore(
  const Definition: TMacroKeyboardDeviceDefinition): Integer;
begin
  Result := 0;
  if Definition.Match.VendorID <> 0 then Inc(Result, 8);
  if Definition.Match.ProductID <> 0 then Inc(Result, 8);
  if Definition.Match.InterfaceNumber >= 0 then Inc(Result, 4);
  if Definition.Match.ProductString <> '' then Inc(Result, 2);
end;

procedure TMacroKeyboardDeviceCatalog.LoadDirectory(const DirectoryName: string);
var
  Definition: TMacroKeyboardDeviceDefinition;
  FileName: string;
  FoundFiles: TArray<string>;
  FileNames: TStringList;
  I: Integer;
  Loaded: TObjectList<TMacroKeyboardDeviceDefinition>;
  IDs: TDictionary<string, Boolean>;
begin
  if not TDirectory.Exists(DirectoryName) then
    raise EDirectoryNotFoundException.CreateFmt(
      'Device-definition directory "%s" does not exist.', [DirectoryName]);

  Loaded := TObjectList<TMacroKeyboardDeviceDefinition>.Create(True);
  FileNames := TStringList.Create;
  IDs := TDictionary<string, Boolean>.Create;
  try
    FoundFiles := TDirectory.GetFiles(DirectoryName, '*.json',
      TSearchOption.soTopDirectoryOnly);
    for FileName in FoundFiles do
      FileNames.Add(FileName);
    FileNames.Sort;
    for I := 0 to FileNames.Count - 1 do
    begin
      FileName := FileNames[I];
      Definition := TMacroKeyboardDeviceDefinition.Create;
      try
        Definition.LoadFromFile(FileName);
        if IDs.ContainsKey(LowerCase(Definition.ID)) then
          raise EInvalidOperation.CreateFmt(
            'Device definition ID "%s" is duplicated.', [Definition.ID]);
        IDs.Add(LowerCase(Definition.ID), True);
        Loaded.Add(Definition);
        Definition := nil;
      finally
        Definition.Free;
      end;
    end;

    FDefinitions.Free;
    FDefinitions := Loaded;
    Loaded := nil;
  finally
    IDs.Free;
    FileNames.Free;
    Loaded.Free;
  end;
end;

function TMacroKeyboardDeviceCatalog.FindBestMatch(const Device: THIDDevice;
  out ErrorMessage: string): TMacroKeyboardDeviceDefinition;
var
  BestDefinition: TMacroKeyboardDeviceDefinition;
  BestScore: Integer;
  CandidateScore: Integer;
  Conflict: Boolean;
  I: Integer;
begin
  Result := nil;
  ErrorMessage := '';
  BestDefinition := nil;
  BestScore := -1;
  Conflict := False;
  if not Assigned(Device) then Exit;
  for I := 0 to Count - 1 do
    if Definitions[I].Match.Matches(Device) then
    begin
      CandidateScore := MatchScore(Definitions[I]);
      if CandidateScore > BestScore then
      begin
        BestDefinition := Definitions[I];
        BestScore := CandidateScore;
        Conflict := False;
        ErrorMessage := '';
      end else if CandidateScore = BestScore then
      begin
        ErrorMessage := Format(
          'Definitions "%s" and "%s" match with equal specificity.',
          [BestDefinition.ID, Definitions[I].ID]);
        Conflict := True;
      end;
    end;
  if not Conflict then
    Result := BestDefinition;
end;

end.
