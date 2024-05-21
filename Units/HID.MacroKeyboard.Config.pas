//------------------------------------------------------------------------------
// UNIT           : HID.MacroKeyboard.Config.pas
// CONTENTS       : HID MacroKeyboard Configuration
// VERSION        : 1.0
// TARGET         : Embarcadero Delphi 11 or higher
// AUTHOR         : Ernst Reidinga (ERDesigns)
// STATUS         : Open source under Apache 2.0 library
// COMPATIBILITY  : Windows 7, 8/8.1, 10, 11
// RELEASE DATE   : 21/05/2024
//------------------------------------------------------------------------------
unit HID.MacroKeyboard.Config;

interface

uses
  System.SysUtils, System.Classes, System.JSON, System.IOUtils;

type
  TMacroKey = class(TCollectionItem)
  private
    /// <summary>
    ///   Macro Key name (Friendly name as indicator / reference)
    /// </summary>
    FName: string;
    /// <summary>
    ///   Ctrl Modifier
    /// </summary>
    FCtrl: Boolean;
    /// <summary>
    ///   Shift Modifier
    /// </summary>
    FShift: Boolean;
    /// <summary>
    ///   Alt Modifier
    /// </summary>
    FAlt: Boolean;
    /// <summary>
    ///   Win Modifier
    /// </summary>
    FWin: Boolean;
    /// <summary>
    ///   Key 1
    /// </summary>
    FKey1: string;
    /// <summary>
    ///   Key 2
    /// </summary>
    FKey2: string;
    /// <summary>
    ///   Key 3
    /// </summary>
    FKey3: string;
    /// <summary>
    ///   Key 4
    /// </summary>
    FKey4: string;
    /// <summary>
    ///   Key 5
    /// </summary>
    FKey5: string;

    /// <summary>
    ///   Set Macro Key name
    /// </summary>
    procedure SetName(const Name: string);
    /// <summary>
    ///   Set Ctrl Modifier
    /// </summary>
    procedure SetCtrl(const Ctrl: Boolean);
    /// <summary>
    ///   Set Shift Modifier
    /// </summary>
    procedure SetShift(const Shift: Boolean);
    /// <summary>
    ///   Set Alt Modifier
    /// </summary>
    procedure SetAlt(const Alt: Boolean);
    /// <summary>
    ///   Set Win Modifier
    /// </summary>
    procedure SetWin(const Win: Boolean);
    /// <summary>
    ///   Set Key 1
    /// </summary>
    procedure SetKey1(const Key: string);
    /// <summary>
    ///   Set Key 2
    /// </summary>
    procedure SetKey2(const Key: string);
    /// <summary>
    ///   Set Key 3
    /// </summary>
    procedure SetKey3(const Key: string);
    /// <summary>
    ///   Set Key 4
    /// </summary>
    procedure SetKey4(const Key: string);
    /// <summary>
    ///   Set Key 5
    /// </summary>
    procedure SetKey5(const Key: string);
  protected
    /// <summary>
    ///   Get Display name
    /// </summary>
    function GetDisplayName: string; override;
  public
    /// <summary>
    ///   Constructor
    /// </summary>
    constructor Create(AOWner: TCollection); override;
    /// <summary>
    ///   Destructor
    /// </summary>
    destructor Destroy; override;

    /// <summary>
    ///   Assign
    /// </summary>
    procedure Assign(Source: TPersistent); override;
  published
    /// <summary>
    ///   Macro Key name (Friendly name as indicator / reference)
    /// </summary>
    property Name: string read FName write SetName;
    /// <summary>
    ///   Ctrl Modifier
    /// </summary>
    property Ctrl: Boolean read FCtrl write SetCtrl;
    /// <summary>
    ///   Shift Modifier
    /// </summary>
    property Shift: Boolean read FShift write SetShift;
    /// <summary>
    ///   Alt Modifier
    /// </summary>
    property Alt: Boolean read FAlt write SetAlt;
    /// <summary>
    ///   Win Modifier
    /// </summary>
    property Win: Boolean read FWin write SetWin;
    /// <summary>
    ///   Key 1
    /// </summary>
    property Key1: string read FKey1 write SetKey1;
    /// <summary>
    ///   Key 2
    /// </summary>
    property Key2: string read FKey2 write SetKey2;
    /// <summary>
    ///   Key 3
    /// </summary>
    property Key3: string read FKey3 write SetKey3;
    /// <summary>
    ///   Key 4
    /// </summary>
    property Key4: string read FKey4 write SetKey4;
    /// <summary>
    ///   Key 5
    /// </summary>
    property Key5: string read FKey5 write SetKey5;
  end;

  TMacroKeys = class(TOwnedCollection)
  private
    /// <summary>
    ///   On Change Event
    /// </summary>
    FOnChange : TNotifyEvent;

    /// <summary>
    ///   Item Changed handler
    /// </summary>
    procedure ItemChanged(Sender: TObject);

    /// <summary>
    ///   Get Macro Key Item
    /// </summary>
    function GetItem(Index: Integer): TMacroKey;
    /// <summary>
    ///   Set Macro Key Item
    /// </summary>
    procedure SetItem(Index: Integer; const Value: TMacroKey);
  protected
    /// <summary>
    ///   Update
    /// </summary>
    procedure Update(Item: TCollectionItem); override;
  public
    /// <summary>
    ///   Constructor
    /// </summary>
    constructor Create(AOwner: TPersistent);

    /// <summary>
    ///   Add Macro Key
    /// </summary>
    function Add: TMacroKey;
    /// <summary>
    ///   Assign
    /// </summary>
    procedure Assign(Source: TPersistent); override;

    /// <summary>
    ///   Macro Key Items
    /// </summary>
    property Items[Index: Integer]: TMacroKey read GetItem write SetItem; default;
    /// <summary>
    ///   On Change Event
    /// </summary>
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
  end;

  TMacroKeyboardFilenameEvent = procedure(Sender: TObject; Filename: string) of object;
  TMacroKeyboardModifiedEvent = procedure(Sender: TObject; Modified: Boolean) of object;

  TMacroKeyboardConfig = class(TComponent)
  private
    /// <summary>
    ///   Configuration filename
    /// </summary>
    FFileName: string;
    /// <summary>
    ///   Modified flag
    /// </summary>
    FModified: Boolean;
    /// <summary>
    ///   Macro key collection
    /// </summary>
    FKeys: TMacroKeys;

    /// <summary>
    ///   Filename change event
    /// </summary>
    FOnFilename: TMacroKeyboardFilenameEvent;
    /// <summary>
    ///   Modified changed event
    /// </summary>
    FOnModified: TMacroKeyboardModifiedEvent;

    /// <summary>
    ///   Keys changed event handler
    /// </summary>
    procedure KeysChanged(Sender: TObject);
    /// <summary>
    ///   Set filename
    /// </summary>
    procedure SetFileName(const Filename: string);
    /// <summary>
    ///   Set modified flag
    /// </summary>
    procedure SetModified(const Modified: Boolean);
  public
    /// <summary>
    ///   Constructor
    /// </summary>
    constructor Create(AOwner: TComponent); override;
    /// <summary>
    ///   Destructor
    /// </summary>
    destructor Destroy; override;

    /// <summary>
    ///   Assign
    /// </summary>
    procedure Assign(Source: TPersistent); override;

    /// <summary>
    ///   New config
    /// </summary>
    procedure New;
    /// <summary>
    ///   Load from file
    /// </summary>
    procedure LoadFromFile(const FileName: string);
    /// <summary>
    ///   Save to file
    /// </summary>
    procedure SaveToFile(const Filename: string);
  published
    /// <summary>
    ///   Configuration filename
    /// </summary>
    property FileName: string read FFileName write SetFileName;
    /// <summary>
    ///   Modified flag
    /// </summary>
    property Modified: Boolean read FModified write SetModified;
    /// <summary>
    ///   Macro key collection
    /// </summary>
    property Keys: TMacroKeys read FKeys;

    /// <summary>
    ///   Filename change event
    /// </summary>
    property OnFilename: TMacroKeyboardFilenameEvent read FOnFilename write FOnFilename;
    /// <summary>
    ///   Modified changed event
    /// </summary>
    property OnModified: TMacroKeyboardModifiedEvent read FOnModified write FOnModified;
  end;

implementation

uses System.StrUtils;

//------------------------------------------------------------------------------
// SET NAME
//------------------------------------------------------------------------------
procedure TMacroKey.SetName(const Name: string);
begin
  if Name <> FName then
  begin
    FName := Name;
    Changed(False);
  end;
end;

//------------------------------------------------------------------------------
// SET CTRL
//------------------------------------------------------------------------------
procedure TMacroKey.SetCtrl(const Ctrl: Boolean);
begin
  if Ctrl <> FCtrl then
  begin
    FCtrl := Ctrl;
    Changed(False);
  end;
end;

//------------------------------------------------------------------------------
// SET SHIFT
//------------------------------------------------------------------------------
procedure TMacroKey.SetShift(const Shift: Boolean);
begin
  if Shift <> FShift then
  begin
    FShift := Shift;
    Changed(False);
  end;
end;

//------------------------------------------------------------------------------
// SET ALT
//------------------------------------------------------------------------------
procedure TMacroKey.SetAlt(const Alt: Boolean);
begin
  if Alt <> FAlt then
  begin
    FAlt := Alt;
    Changed(False);
  end;
end;

//------------------------------------------------------------------------------
// SET WIN
//------------------------------------------------------------------------------
procedure TMacroKey.SetWin(const Win: Boolean);
begin
  if Win <> FWin then
  begin
    FWin := Win;
    Changed(False);
  end;
end;

//------------------------------------------------------------------------------
// SET KEY 1
//------------------------------------------------------------------------------
procedure TMacroKey.SetKey1(const Key: string);
begin
  if Key <> FKey1 then
  begin
    FKey1 := Key;
    Changed(False);
  end;
end;

//------------------------------------------------------------------------------
// SET KEY 2
//------------------------------------------------------------------------------
procedure TMacroKey.SetKey2(const Key: string);
begin
  if Key <> FKey2 then
  begin
    FKey2 := Key;
    Changed(False);
  end;
end;

//------------------------------------------------------------------------------
// SET KEY 3
//------------------------------------------------------------------------------
procedure TMacroKey.SetKey3(const Key: string);
begin
  if Key <> FKey3 then
  begin
    FKey3 := Key;
    Changed(False);
  end;
end;

//------------------------------------------------------------------------------
// SET KEY 4
//------------------------------------------------------------------------------
procedure TMacroKey.SetKey4(const Key: string);
begin
  if Key <> FKey4 then
  begin
    FKey4 := Key;
    Changed(False);
  end;
end;

//------------------------------------------------------------------------------
// SET KEY 5
//------------------------------------------------------------------------------
procedure TMacroKey.SetKey5(const Key: string);
begin
  if Key <> FKey5 then
  begin
    FKey5 := Key;
    Changed(False);
  end;
end;

//------------------------------------------------------------------------------
// GET DISPLAY NAME
//------------------------------------------------------------------------------
function TMacroKey.GetDisplayName: string;
var
  S: string;
begin
  if (Name <> '') then
    Result := Name
  else
  begin
    if Ctrl  then S := S + 'CTRL ';
    if Shift then S := S + 'SHIFT ';
    if Alt   then S := S + 'ALT ';
    if Win   then S := S + 'WIN ';
    if (Key1 <> '') then S := S + Key1 + ' ';
    if (Key2 <> '') then S := S + Key2 + ' ';
    if (Key3 <> '') then S := S + Key3 + ' ';
    if (Key4 <> '') then S := S + Key4 + ' ';
    if (Key5 <> '') then S := S + Key5 + ' ';
    Result := Trim(S);
  end;
end;

//------------------------------------------------------------------------------
// CONSTRUCTOR
//------------------------------------------------------------------------------
constructor TMacroKey.Create(AOWner: TCollection);
begin
  inherited Create(AOwner);
end;

//------------------------------------------------------------------------------
// DESTRUCTOR
//------------------------------------------------------------------------------
destructor TMacroKey.Destroy;
begin
  inherited Destroy;
end;

//------------------------------------------------------------------------------
// ASSIGN
//------------------------------------------------------------------------------
procedure TMacroKey.Assign(Source: TPersistent);
begin
  if (Source is TMacroKey) then
  begin
    FName  := (Source as TMacroKey).Name;
    FCtrl  := (Source as TMacroKey).Ctrl;
    FShift := (Source as TMacroKey).Shift;
    FAlt   := (Source as TMacroKey).Alt;
    FWin   := (Source as TMacroKey).Win;
    FKey1  := (Source as TMacroKey).Key1;
    FKey2  := (Source as TMacroKey).Key2;
    FKey3  := (Source as TMacroKey).Key3;
    FKey4  := (Source as TMacroKey).Key4;
    FKey5  := (Source as TMacroKey).Key5;
  end;
end;

//------------------------------------------------------------------------------
// ITEM CHANGED
//------------------------------------------------------------------------------
procedure TMacroKeys.ItemChanged(Sender: TObject);
begin
  // Notify item changed
  if Assigned(FOnChange) then FOnChange(Self);
end;

//------------------------------------------------------------------------------
// GET ITEM
//------------------------------------------------------------------------------
function TMacroKeys.GetItem(Index: Integer): TMacroKey;
begin
  Result := inherited GetItem(Index) as TMacroKey;
end;

//------------------------------------------------------------------------------
// SET ITEM
//------------------------------------------------------------------------------
procedure TMacroKeys.SetItem(Index: Integer; const Value: TMacroKey);
begin
  inherited SetItem(Index, Value);
  // Notify change
  ItemChanged(Self);
end;

//------------------------------------------------------------------------------
// UPDATE
//------------------------------------------------------------------------------
procedure TMacroKeys.Update(Item: TCollectionItem);
begin
  inherited Update(Item);
  // Notify change
  if Assigned(FOnChange) then FOnChange(Self);
end;

//------------------------------------------------------------------------------
// CONSTRUCTOR
//------------------------------------------------------------------------------
constructor TMacroKeys.Create(AOwner: TPersistent);
begin
  inherited Create(AOwner, TMacroKey);
end;

//------------------------------------------------------------------------------
// ADD
//------------------------------------------------------------------------------
function TMacroKeys.Add: TMacroKey;
begin
  Result := TMacroKey(inherited Add);
end;

//------------------------------------------------------------------------------
// ASSIGN
//------------------------------------------------------------------------------
procedure TMacroKeys.Assign(Source: TPersistent);
var
  Items: TMacroKeys;
  I: Integer;
begin
  inherited;
  // Assign items
  if (Source is TMacroKeys)  then
  begin
    // Assign Items
    Items := TMacroKeys(Source);
    // Clear all items
    Clear;
    // Loop over every item and add them to the collection
    for I := 0 to Items.Count - 1 do Add.Assign(Items.Items[I]);
  end;
end;

//------------------------------------------------------------------------------
// KEYS CHANGED
//------------------------------------------------------------------------------
procedure TMacroKeyboardConfig.KeysChanged(Sender: TObject);
begin
  FModified := True;
end;

//------------------------------------------------------------------------------
// SET FILENAME
//------------------------------------------------------------------------------
procedure TMacroKeyboardConfig.SetFileName(const Filename: string);
begin
  if (Filename <> FFilename) then
  begin
    // Update filename
    FFilename := Filename;
    // Notify change
    if Assigned(FOnFilename) then FOnFilename(Self, Filename);
  end;
end;

//------------------------------------------------------------------------------
// SET MODIFIED
//------------------------------------------------------------------------------
procedure TMacroKeyboardConfig.SetModified(const Modified: Boolean);
begin
  if (Modified <> FModified) then
  begin
    // Update modified flag
    FModified := Modified;
    // Notify change
    if Assigned(FOnModified) then FOnModified(Self, Modified);
  end;
end;

//------------------------------------------------------------------------------
// CONSTRUCTOR
//------------------------------------------------------------------------------
constructor TMacroKeyboardConfig.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  // Create macro keys collection
  FKeys := TMacroKeys.Create(Self);
  // Set change handler
  FKeys.OnChange := KeysChanged;
  // Create new config
  New;
end;

//------------------------------------------------------------------------------
// DESTRUCTOR
//------------------------------------------------------------------------------
destructor TMacroKeyboardConfig.Destroy;
begin
  // Free macro keys collection
  FKeys.Free;

  inherited Destroy;
end;

//------------------------------------------------------------------------------
// ASSIGN
//------------------------------------------------------------------------------
procedure TMacroKeyboardConfig.Assign(Source: TPersistent);
begin
  inherited;

  // Assign properties
  if (Source is TMacroKeyboardConfig) then
  begin
    FKeys.Assign((Source as TMacroKeyboardConfig).Keys);
    FFilename := (Source as TMacroKeyboardConfig).FileName;
    FModified := (Source as TMacroKeyboardConfig).Modified;
  end;
end;

//------------------------------------------------------------------------------
// NEW CONFIG
//------------------------------------------------------------------------------
procedure TMacroKeyboardConfig.New;
var
  I: Integer;
begin
  // Clear macro keys
  FKeys.Clear;

  // Add keys
  for I := 1 to 12 do with FKeys.Add do Name := Format('Key %d', [I]);

  // Add knobs
  for I := 1 to 3 do
  begin
    // Clockwise
    with FKeys.Add do Name := Format('Knob %d (Clockwise)', [I]);
    // Counter clockwise
    with FKeys.Add do Name := Format('Knob %d (Counter Clockwise)', [I]);
    // Click
    with FKeys.Add do Name := Format('Knob %d (Click)', [I]);
  end;

  // Update modified flag
  Modified := False;
  // Clear filename
  Filename := '';
end;

//------------------------------------------------------------------------------
// LOAD FROM FILE
//------------------------------------------------------------------------------
procedure TMacroKeyboardConfig.LoadFromFile(const FileName: string);
var
  JSON: string;
  JSONArray: TJSONArray;
  JSONObject: TJSONObject;
  MacroKey: TMacroKey;
  I: Integer;
begin
  // Read the configuration file
  JSON := TFile.ReadAllText(FileName);
  // Parse the JSON
  JSONArray := TJSONObject.ParseJSONValue(JSON) as TJSONArray;
  try
    // Clear the macro keys
    FKeys.Clear;
    // Loop over the items in the configuration
    for I := 0 to JSONArray.Count - 1 do
    begin
      JSONObject := JSONArray.Items[i] as TJSONObject;
      MacroKey := FKeys.Add;
      MacroKey.Name := JSONObject.GetValue<string>('Name');
      MacroKey.Ctrl := JSONObject.GetValue<Boolean>('Ctrl');
      MacroKey.Shift := JSONObject.GetValue<Boolean>('Shift');
      MacroKey.Alt := JSONObject.GetValue<Boolean>('Alt');
      MacroKey.Win := JSONObject.GetValue<Boolean>('Win');
      MacroKey.Key1 := JSONObject.GetValue<string>('Key1');
      MacroKey.Key2 := JSONObject.GetValue<string>('Key2');
      MacroKey.Key3 := JSONObject.GetValue<string>('Key3');
      MacroKey.Key4 := JSONObject.GetValue<string>('Key4');
      MacroKey.Key5 := JSONObject.GetValue<string>('Key5');
    end;
    // Update the filename
    Self.FileName := FileName;
    // Update the modified flag
    Modified := False;
  finally
    JSONArray.Free;
  end;
end;

//------------------------------------------------------------------------------
// SAVE TO FILE
//------------------------------------------------------------------------------
procedure TMacroKeyboardConfig.SaveToFile(const Filename: string);
var
  JSONArray: TJSONArray;
  JSONObject: TJSONObject;
  I: Integer;
  MacroKey: TMacroKey;
  JSONString: string;
begin
  // Create a JSON array
  JSONArray := TJSONArray.Create;
  try
    // Loop over the macro keys
    for I := 0 to FKeys.Count - 1 do
    begin
      MacroKey := FKeys[I];
      JSONObject := TJSONObject.Create;
      JSONObject.AddPair('Name', MacroKey.Name);
      JSONObject.AddPair('Ctrl', TJSONBool.Create(MacroKey.Ctrl));
      JSONObject.AddPair('Shift', TJSONBool.Create(MacroKey.Shift));
      JSONObject.AddPair('Alt', TJSONBool.Create(MacroKey.Alt));
      JSONObject.AddPair('Win', TJSONBool.Create(MacroKey.Win));
      JSONObject.AddPair('Key1', MacroKey.Key1);
      JSONObject.AddPair('Key2', MacroKey.Key2);
      JSONObject.AddPair('Key3', MacroKey.Key3);
      JSONObject.AddPair('Key4', MacroKey.Key4);
      JSONObject.AddPair('Key5', MacroKey.Key5);
      JSONArray.AddElement(JSONObject);
    end;
    // Conver the JSON array to a string
    JSONString := JSONArray.ToString;
    // Write the JSON string to the configuration file
    TFile.WriteAllText(FileName, JSONString);
    // Update the filename
    Self.Filename := Filename;
    // Update the modified flag
    Modified := False;
  finally
    JSONArray.Free;
  end;
end;

end.
