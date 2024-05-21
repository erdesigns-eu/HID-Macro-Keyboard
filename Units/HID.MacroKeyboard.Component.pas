//------------------------------------------------------------------------------
// UNIT           : HID.MacroKeyboard.Component.pas
// CONTENTS       : HID MacroKeyboard Visual Component
// VERSION        : 1.0
// TARGET         : Embarcadero Delphi 11 or higher
// AUTHOR         : Ernst Reidinga (ERDesigns)
// STATUS         : Open source under Apache 2.0 library
// COMPATIBILITY  : Windows 7, 8/8.1, 10, 11
// RELEASE DATE   : 20/05/2024
//------------------------------------------------------------------------------
unit HID.MacroKeyboard.Component;

interface

uses
  System.SysUtils, System.Classes, Winapi.Windows, Vcl.Controls, Vcl.Graphics,
  Winapi.Messages, System.Types, Vcl.Menus, Vcl.ExtCtrls, Vcl.Themes, Vcl.Forms,
  Winapi.GDIPAPI, Winapi.GDIPOBJ, HID.MacroKeyboard.Config;

const
  /// <summary>
  ///   Keyboard Width in Milimeters
  /// </summary>
  KeyboardWidth = 140;
  /// <summary>
  ///   Keyboard Height in Milimeters
  /// </summary>
  KeyboardHeight = 83;
  /// <summary>
  ///   Keyboard Border Radius in Milimeters
  /// </summary>
  KeyboardBorderRadius = 10;

  /// <summary>
  ///   Key Cap Width in Milimeters
  /// </summary>
  KeyCapWidth = 18;
  /// <summary>
  ///   Key Cap Height in Milimeters
  /// </summary>
  KeyCapHeight = 18;
  /// <summary>
  ///   Key Cap Border Radius in Milimeters
  /// </summary>
  KeyCapBorderRadius = 2;
  /// <summary>
  ///   Key Cap Offset in Milimeters
  /// </summary>
  KeyCapOffset = 10;
  /// <summary>
  ///   Key Cap Space Between in Milimeters
  /// </summary>
  KeyCapSpaceBetween = 4;

  /// <summary>
  ///   Rotary Encoder Width in Milimeters
  /// </summary>
  RotaryEncoderWidth = 20;
  /// <summary>
  ///   Rotary Encoder Height in Milimeters
  /// </summary>
  RotaryEncoderHeight = 20;
  /// <summary>
  ///   Rotary Encoder Offset in Milimeters
  /// </summary>
  RotaryEncoderOffset = 4;
  /// <summary>
  ///   Rotary Encoder Space Between in Milimeters
  /// </summary>
  RotaryEncoderSpaceBetween = 5;

  /// <summary>
  ///   Screw offset in Milimeters
  /// </summary>
  ScrewOffset = 4.5;
  /// <summary>
  ///   Screw Width in Milimeters
  /// </summary>
  ScrewWidth = 3.5;
  /// <summary>
  ///   Screw Height in Milimeters
  /// </summary>
  ScrewHeight = 3.5;

const
  /// <summary>
  ///   Keyboard from color (Background)
  /// </summary>
  KeyboardBackgroundFromColor = $00383838;
  /// <summary>
  ///   Keyboard to color (Background)
  /// </summary>
  KeyboardBackgroundToColor = $00232323;
  /// <summary>
  ///   Keyboard Border color
  /// </summary>
  KeyboardBorderColor = $00161616;

  /// <summary>
  ///   Screw color (Background)
  /// </summary>
  ScrewBackgroundColor = $005A5A5A;
  /// <summary>
  ///   Screw line color
  /// </summary>
  ScrewLineColor = $00A0A0A0;

  /// <summary>
  ///   Keycap outer from color (Background)
  /// </summary>
  KeyCapOuterBackgroundFromColor = $00414141;
  /// <summary>
  ///   Keycap outer to color (Background)
  /// </summary>
  KeyCapOuterBackgroundToColor = $00525252;
  /// <summary>
  ///   Keycap inner from color (Background)
  /// </summary>
  KeyCapInnerBackgroundFromColor = $004E4E4E;
  /// <summary>
  ///   Keycap inner to color (Background)
  /// </summary>
  KeyCapInnerBackgroundToColor = $00606060;
  /// <summary>
  ///   Keycap Border color
  /// </summary>
  KeyCapBorderColor = $00161616;

type
  /// <summary>
  ///   Keyboard Button Rects
  /// </summary>
  TMacroKeyboardButtonRects = Array of TGPRectF;

type
  /// <summary>
  ///   On Key or Rotary Encoder Select
  /// </summary>
  TMacroKeyboardSelect = procedure(Sender: TObject; Index: Integer) of object;

type
  TMacroKeyboard = class(TCustomControl)
  private
    /// <summary>
    ///   Class constructor
    /// </summary>
    class constructor Create;
    /// <summary>
    ///   Class destructor
    /// </summary>
    class destructor Destroy;
  private
    /// <summary>
    ///   Buffer (This is the canvas we draw on)
    /// </summary>
    FBuffer: TBitmap;
    /// <summary>
    ///   Update rect (Invalidated rectangle)
    /// </summary>
    FUpdateRect: TRect;
    /// <summary>
    ///   Button Rects
    /// </summary>
    FButtonRects: TMacroKeyboardButtonRects;
  private
    /// <summary>
    ///   WM_PAINT message handler
    /// </summary>
    procedure WMPaint(var Msg: TWMPaint); message WM_PAINT;
    /// <summary>
    ///   WM_ERASEBKGND message handler
    /// </summary>
    procedure WMEraseBkGnd(var Msg: TWMEraseBkGnd); message WM_ERASEBKGND;
    /// <summary>
    ///   WM_KILLFOCUS message handler
    /// </summary>
    procedure WMKillFocus(var Message: TWMKillFocus); message WM_KILLFOCUS;
    /// <summary>
    ///   CM_ENABLEDCHANGED message handler
    /// </summary>
    procedure CMEnabledChanged(var Message: TMessage); message CM_ENABLEDCHANGED;
    /// <summary>
    ///   CM_MOUSELEAVE message handler
    /// </summary>
    procedure CMMouseLeave(var Message: TMessage); message CM_MOUSELEAVE;
  private
    /// <summary>
    ///   Selected Key/Rotary Encoder Index
    /// </summary>
    FSelectedIndex: Integer;
    /// <summary>
    ///   Key PopupMenu
    /// </summary>
    FKeyPopupMenu: TPopupMenu;
    /// <summary>
    ///   Rotary Encoder PopupMenu
    /// </summary>
    FRotaryEncoderPopupMenu: TPopupMenu;
    /// <summary>
    ///   Zoom
    /// </summary>
    FZoom: Integer;
    /// <summary>
    ///   On Select handler
    /// </summary>
    FOnSelect: TMacroKeyboardSelect;

    /// <summary>
    ///   Set selected Key/Rotary Encoder Index
    /// </summary>
    procedure SetSelectedIndex(const Index: Integer);
    /// <summary>
    ///   Set Key PopupMenu
    /// </summary>
    procedure SetKeyPopupMenu(const PopupMenu: TPopupMenu);
    /// <summary>
    ///   Set Rotary Encoder PopupMenu
    /// </summary>
    procedure SetRotaryEncoderPopupMenu(const PopupMenu: TPopupMenu);
    /// <summary>
    ///   Set Zoom
    /// </summary>
    procedure SetZoom(const Zoom: Integer);
  protected
    /// <summary>
    ///   Buffer (This is the canvas we draw on)
    /// </summary>
    property Buffer: TBitmap read FBuffer;
    /// <summary>
    ///   Button Rects
    /// </summary>
    property ButtonRects: TMacroKeyboardButtonRects read FButtonRects write FButtonRects;

    /// <summary>
    ///   Override CreateParams method
    /// </summary>
    procedure CreateParams(var Params: TCreateParams); override;
    /// <summary>
    ///   Override Paint method
    /// </summary>
    procedure Paint; override;
    /// <summary>
    ///   Override Resize method
    /// </summary>
    procedure Resize; override;
    /// <summary>
    ///   Override UpdateStyleElements method
    /// </summary>
    procedure UpdateStyleElements; override;

    /// <summary>
    ///   Override MouseMove method
    /// </summary>
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    /// <summary>
    ///   Override MouseDown method
    /// </summary>
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    /// <summary>
    ///   Override KeyDown method
    /// </summary>
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    /// <summary>
    ///   Override WMGetDlgCode method
    /// </summary>
    procedure WMGetDlgCode(var Message: TWMGetDlgCode); message WM_GETDLGCODE;
    /// <summary>
    ///   Override DoMouseWheel method
    /// </summary>
    function DoMouseWheel(Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint): Boolean; override;
  protected
    /// <summary>
    ///   Paint buffer
    /// </summary>
    procedure PaintBuffer; virtual;
    /// <summary>
    ///   On change handler
    /// </summary>
    procedure SettingsChanged(Sender: TObject);
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
    ///   Override assign method
    /// </summary>
    procedure Assign(Source: TPersistent); override;
    /// <summary>
    ///   Override repaint method
    /// </summary>
    procedure Repaint; override;
  published
    /// <summary>
    ///   Set selected Key/Rotary Encoder Index
    /// </summary>
    property SelectedIndex: Integer read FSelectedIndex write SetSelectedIndex default -1;
    /// <summary>
    ///   Key PopupMenu
    /// </summary>
    property KeyPopupMenu: TPopupMenu read FKeyPopupMenu write SetKeyPopupMenu;
    /// <summary>
    ///   Rotary Encoder PopupMenu
    /// </summary>
    property RotaryEncoderPopupMenu: TPopupMenu read FRotaryEncoderPopupMenu write SetRotaryEncoderPopupMenu;
    /// <summary>
    ///   Zoom
    /// </summary>
    property Zoom: Integer read FZoom write SetZoom default 100;

    /// <summary>
    ///   On Select handler
    /// </summary>
    property OnSelect: TMacroKeyboardSelect read FOnSelect write FOnSelect;

    /// <summary>
    ///   Alignment
    /// </summary>
    property Align;
    /// <summary>
    ///   Anchors
    /// </summary>
    property Anchors;
    /// <summary>
    ///   Color
    /// </summary>
    property Color default clBtnFace;
    /// <summary>
    ///   Enabled
    /// </summary>
    property Enabled;
    /// <summary>
    ///   Font
    /// </summary>
    property Font;
    /// <summary>
    ///   Taborder
    /// </summary>
    property TabOrder;
    /// <summary>
    ///   Visible
    /// </summary>
    property Visible;
  end;

procedure Register;

implementation

uses System.Math;

//------------------------------------------------------------------------------
// POINT IN TGPRECTF
//------------------------------------------------------------------------------
function PtInTGPRectF(const Rect: TGPRectF; const P: TPoint): Boolean;
begin
  Result := (P.X >= Rect.X) and (P.X < (Rect.X + Rect.Width)) and
            (P.Y >= Rect.Y) and (P.Y < (Rect.Y + Rect.Height));
end;

//------------------------------------------------------------------------------
// CLASS CONSTRUCTOR
//------------------------------------------------------------------------------
class constructor TMacroKeyboard.Create;
begin
  TCustomStyleEngine.RegisterStyleHook(TMacroKeyboard, TPanelStyleHook);
end;

//------------------------------------------------------------------------------
// CLASS DESTRUCTOR
//------------------------------------------------------------------------------
class destructor TMacroKeyboard.Destroy;
begin
  TCustomStyleEngine.UnRegisterStyleHook(TMacroKeyboard, TPanelStyleHook);
end;

//------------------------------------------------------------------------------
// WM_PAINT MESSAGE HANDLER
//------------------------------------------------------------------------------
procedure TMacroKeyboard.WMPaint(var Msg: TWMPaint);
begin
  inherited;
  // Retrieve the invalidated rectangle
  if not GetUpdateRect(Handle, FUpdateRect, False) then
  // If no update region, default to the entire client area
  FUpdateRect := Rect(0, 0, Width, Height);
end;

//------------------------------------------------------------------------------
// WM_ERASEBKGND MESSAGE HANDLER
//------------------------------------------------------------------------------
procedure TMacroKeyboard.WMEraseBkGnd(var Msg: TWMEraseBkgnd);
begin
  // Set the handled flag
  Msg.Result := 1;
end;

//------------------------------------------------------------------------------
// WM_KILLFOCUS MESSAGE HANDLER
//------------------------------------------------------------------------------
procedure TMacroKeyboard.WMKillFocus(var Message: TWMKillFocus);
begin
  inherited;

  // Reset cursor
  Cursor := crDefault;
end;

//------------------------------------------------------------------------------
// CM_ENABLEDCHANGED MESSAGE HANDLER
//------------------------------------------------------------------------------
procedure TMacroKeyboard.CMEnabledChanged(var Message: TMessage);
begin
  inherited;

  // Reset cursor
  Cursor := crDefault;
end;

//------------------------------------------------------------------------------
// CM_MOUSELEAVE MESSAGE HANDLER
//------------------------------------------------------------------------------
procedure TMacroKeyboard.CMMouseLeave(var Message: TMessage);
begin
  inherited;

  // Reset cursor
  Cursor := crDefault;
end;

//------------------------------------------------------------------------------
// SET SELECTED KEY/ROTARY ENCODER INDEX
//------------------------------------------------------------------------------
procedure TMacroKeyboard.SetSelectedIndex(const Index: Integer);
begin
  if (Index <> FSelectedIndex) and (Index >= -1) and (Index <= 14) then
  begin
    // Set selected Key/Rotary encoder index
    FSelectedIndex := Index;
    // Notify change
    if Assigned(FOnSelect) then FOnSelect(Self, Index);
    // Repaint buffer
    PaintBuffer;
    // Invalidate component
    Invalidate;
  end;
end;

//------------------------------------------------------------------------------
// SET KEY POPUPMENU
//------------------------------------------------------------------------------
procedure TMacroKeyboard.SetKeyPopupMenu(const PopupMenu: TPopupMenu);
begin
  if (FKeyPopupMenu <> PopupMenu) then
  begin
    FKeyPopupMenu := PopupMenu;
  end;
end;

//------------------------------------------------------------------------------
// SET ROTARY ENCODER POPUPMENU
//------------------------------------------------------------------------------
procedure TMacroKeyboard.SetRotaryEncoderPopupMenu(const PopupMenu: TPopupMenu);
begin
  if (FRotaryEncoderPopupMenu <> PopupMenu) then
  begin
    FRotaryEncoderPopupMenu := PopupMenu;
  end;
end;

//------------------------------------------------------------------------------
// SET ZOOM
//------------------------------------------------------------------------------
procedure TMacroKeyboard.SetZoom(const Zoom: Integer);
begin
  if (Zoom >= 1) and (Zoom <= 1000) then
  begin
    // Set zoom
    FZoom := Zoom;
    // Invalidate buffer
    PaintBuffer;
    //
    Invalidate;
  end;
end;

//------------------------------------------------------------------------------
// CREATE PARAMS
//------------------------------------------------------------------------------
procedure TMacroKeyboard.CreateParams(var Params: TCreateParams);
begin
  inherited;
  // Adjust window style to avoid unnecessary redraws on size changes,
  // optimizing performance for custom drawing.
  with Params do Style := Style and not (CS_HREDRAW or CS_VREDRAW);
end;

//------------------------------------------------------------------------------
// PAINT
//------------------------------------------------------------------------------
procedure TMacroKeyboard.Paint;
var
  X, Y, W, H: Integer;
begin
  // Call inherited Paint
  inherited;

  // Draw the buffer to the component canvas
  X := FUpdateRect.Left;
  Y := FUpdateRect.Top;
  W := FUpdateRect.Right - FUpdateRect.Left;
  H := FUpdateRect.Bottom - FUpdateRect.Top;

  if (W <> 0) and (H <> 0) then
    // Only update invalidated part
    BitBlt(Canvas.Handle, X, Y, W, H, FBuffer.Canvas.Handle, X,  Y, SRCCOPY)
  else
    // Repaint the whole buffer to the surface
    BitBlt(Canvas.Handle, 0, 0, Width, Height, FBuffer.Canvas.Handle, X,  Y, SRCCOPY);
end;

//------------------------------------------------------------------------------
// RESIZE
//------------------------------------------------------------------------------
procedure TMacroKeyboard.Resize;
begin
  // Call inherited Resize
  inherited;
  // Update the size of the buffer
  FBuffer.SetSize(Width, Height);
  // Invalidate buffer
  PaintBuffer;
end;

//------------------------------------------------------------------------------
// UPDATE STYLE ELEMENTS
//------------------------------------------------------------------------------
procedure TMacroKeyboard.UpdateStyleElements;
begin
  // Call inherited Loaded
  inherited;
  // Invalidate buffer
  PaintBuffer;
end;

//------------------------------------------------------------------------------
// PAINT BUFFER
//------------------------------------------------------------------------------
procedure TMacroKeyboard.PaintBuffer;
var
  SS: TCustomStyleServices;
  Graphics: TGPGraphics;
  KeyboardRect: TGPRectF;

  //----------------------------------------------------------------------------
  // GET GDI+ ROUNDRECT PATH
  //----------------------------------------------------------------------------
  function CreateRoundRectPath(Rect: TGPRectF; Corner: Single): TGPGraphicsPath;
  begin
    Result := TGPGraphicsPath.Create;
    // Start the figure
    Result.StartFigure;
    // Add arc left top corner
    Result.AddArc(Rect.X, Rect.Y, Corner, Corner, 180, 90);
    // Add arc top right corner
    Result.AddArc((Rect.X + Rect.Width) - Corner, Rect.Y, Corner, Corner, 270, 90);
    // Add arc bottom right corner
    Result.AddArc((Rect.X + Rect.Width) - Corner, (Rect.Y + Rect.Height) - Corner, Corner, Corner, 0, 90);
    // Add arc bottom left corner
    Result.AddArc(Rect.X, (Rect.Y + Rect.Height) - Corner, Corner, Corner, 90, 90);
    // Close the figure
    Result.CloseFigure;
  end;

  //----------------------------------------------------------------------------
  // GET APPROPRIATE COLOR (THEMED COLOR IF THEMES ENABLED)
  //----------------------------------------------------------------------------
  function GetAppropriateColor(Color: TColor): TColor;
  begin
    // Check if VCL styles are enabled
    if TStyleManager.IsCustomStyleActive then
    begin
      // Get style services
      SS := StyleServices;
      // Get styled system color
      Result := SS.GetSystemColor(Color);
    end else
      Result := Color;
  end;

  //----------------------------------------------------------------------------
  // CONVERT COLOR TO GDI+ COLOR
  //----------------------------------------------------------------------------
  function SafeColorRefToARGB(Color: TColor): DWORD;
  var
    RGBColor: COLORREF;
  begin
    // Convert TColor to a RGB color if it's a system color
    RGBColor := ColorToRGB(GetAppropriateColor(Color));
    // Now convert the RGB color to ARGB format expected by GDI+
    Result := (GetRValue(RGBColor) shl RedShift) or
              (GetGValue(RGBColor) shl GreenShift) or
              (GetBValue(RGBColor) shl BlueShift) or
              (AlphaMask);
  end;

  //----------------------------------------------------------------------------
  // MILIMETERS TO PIXELS
  //----------------------------------------------------------------------------
  function MmToPixels(MM: Double): Single;
  const
    MM_PER_INCH = 25.4;
  var
    DPI: Integer;
  begin
    // Get the DPI of the current screen
    DPI := Screen.PixelsPerInch;
    // Convert millimeters to inches and then multiply by the DPI to get pixels
    Result := (((MM / MM_PER_INCH) * DPI) / 100) * Zoom;
  end;

  //----------------------------------------------------------------------------
  // GET GDI+ FONTSTYLE FROM FONT
  //----------------------------------------------------------------------------
  function FontStyle(Font: TFont): TFontStyle;
  begin
    if (fsBold in Font.Style) and (fsItalic in Font.Style) then
      Result := FontStyleBoldItalic
    else
    if (fsBold in Font.Style) then
      Result := FontStyleBold
    else
    if (fsItalic in Font.Style) then
      Result := FontStyleItalic
    else
    if (fsUnderline in Font.Style) then
      Result := FontStyleUnderline
    else
    if (fsStrikeOut in Font.Style) then
      Result := FontStyleStrikeout
    else
      Result := FontStyleRegular;
  end;

  //----------------------------------------------------------------------------
  // DRAW KEYBOARD
  //----------------------------------------------------------------------------
  procedure DrawKeyboard;
  var
    W, H: Single;
    X, Y: Single;
    Brush: TGPBrush;
    Pen: TGPPen;
    Path: TGPGraphicsPath;
  begin
    // Calculate keyboard width
    W := MmToPixels(KeyboardWidth);
    // Calculate keyboard height
    H := MmToPixels(KeyboardHeight);

    // Calculate X position
    X := (Width / 2) - (W / 2);
    // Calculate Y postition
    Y := (Height / 2) - (H / 2);

    // Calculate the keyboard rect
    KeyboardRect := MakeRect(X, Y, W, H);

    // Create the keyboard background brush
    Brush := TGPLinearGradientBrush.Create(KeyboardRect, SafeColorRefToARGB(KeyboardBackgroundFromColor), SafeColorRefToARGB(KeyboardBackgroundToColor), LinearGradientModeVertical);
    // Create the keyboard border pen
    Pen := TGPPen.Create(SafeColorRefToARGB(KeyboardBorderColor), MmToPixels(0.1));

    // Create the keyboard path
    Path := CreateRoundRectPath(KeyboardRect, MMToPixels(KeyboardBorderRadius));

    try
      // Draw the keyboard background
      Graphics.FillPath(Brush, Path);
      // Draw the keyboard border
      Graphics.DrawPath(Pen, Path);
    finally
      Brush.Free;
      Pen.Free;
      Path.Free;
    end;
  end;

  //----------------------------------------------------------------------------
  // DRAW SCREW
  //----------------------------------------------------------------------------
  procedure DrawScrew(const X: Single; const Y: Single);
  var
    W, H: Single;
    LX, LY, LW, LH: Single;
    Brush: TGPBrush;
    Pen: TGPPen;
    Rect: TGPRectF;
  begin
    // Calculate screw width
    W :=  MmToPixels(ScrewWidth);
    // Calculate screw height
    H :=  MmToPixels(ScrewHeight);

    // Create the screw rect
    Rect := MakeRect(X - (W / 2), Y - (H / 2), W, H);
    // Create the screw brush
    Brush := TGPSolidBrush.Create(SafeColorRefToARGB(ScrewBackgroundColor));
    // Create the screw pen
    Pen := TGPPen.Create(SafeColorRefToARGB(ScrewLineColor), MmToPixels(0.4));

    try
      // Draw the screw background
      Graphics.FillEllipse(Brush, Rect);

      // Calculate the line Width
      LW := Rect.Width * 0.65;
      // Calculate the line height
      LH := Rect.Height * 0.65;

      // Calculate the line X
      LX := Rect.X + ((Rect.Width / 2) - (LW / 2));
      // Calculate the line Y
      LY := Rect.Y + (Rect.Height / 2);
      // Draw the first line
      Graphics.DrawLine(Pen, LX, LY, LX + LW, LY);

      // Calculate the line X
      LX := Rect.X + (Rect.Width / 2);
      // Calculate the line Y
      LY := Rect.Y + ((Rect.Height / 2) - (LH / 2));
      // Draw the second line
      Graphics.DrawLine(Pen, LX, LY, LX, LY + LH);
    finally
      Brush.Free;
      Pen.Free;
    end;
  end;

  //----------------------------------------------------------------------------
  // DRAW KEY
  //----------------------------------------------------------------------------
  procedure DrawKey(const Index: Integer);
  var
    IW, IH: Single;
    OuterRect, InnerRect: TGPRectF;
    OuterBrush, InnerBrush, FontBrush: TGPBrush;
    OuterPen, InnerPen: TGPPen;
    OuterPath, InnerPath: TGPGraphicsPath;
    Font: TGPFont;
    FontFamily: TGPFontFamily;
    StringFormat: TGPStringFormat;
    S: string;
  begin
    // Calculate the inner width
    IW := MmToPixels(KeyCapWidth * 0.75);
    // Calculate the inner height
    IH := MmToPixels(KeyCapHeight * 0.75);

    // Create the outer rect
    OuterRect := MakeRect(
      ButtonRects[Index].X,                                                // Left
      ButtonRects[Index].Y,                                                // Top
      ButtonRects[Index].Width,                                            // Width
      ButtonRects[Index].Height                                            // Height
    );
    // Create the inner rect
    InnerRect := MakeRect(
      ButtonRects[Index].X + ((ButtonRects[Index].Width / 2) - (IW / 2)),  // Left
      ButtonRects[Index].Y + ((ButtonRects[Index].Height / 2) - (IH / 2)), // Top
      IW,                                                                  // Width
      IH                                                                   // Height
    );

    // Create the outer path
    OuterPath := CreateRoundRectPath(OuterRect, MMToPixels(KeyCapBorderRadius));
    // Create the inner path
    InnerPath := CreateRoundRectPath(InnerRect, MMToPixels(KeyCapBorderRadius));

    // Create the outer brush
    OuterBrush := TGPLinearGradientBrush.Create(KeyboardRect, SafeColorRefToARGB(KeyCapOuterBackgroundFromColor), SafeColorRefToARGB(KeyCapOuterBackgroundToColor), LinearGradientModeVertical);
    // Create the outer pen
    if (Index = SelectedIndex) then
      OuterPen := TGPPen.Create(SafeColorRefToARGB(clHighlight),  MmToPixels(0.5))
    else
      OuterPen := TGPPen.Create(SafeColorRefToARGB(KeyCapBorderColor),  MmToPixels(0.5));

    // Create the inner brush
    InnerBrush := TGPLinearGradientBrush.Create(KeyboardRect, SafeColorRefToARGB(KeyCapInnerBackgroundFromColor), SafeColorRefToARGB(KeyCapInnerBackgroundToColor), LinearGradientModeVertical);
    // Create the inner pen
    InnerPen := TGPPen.Create(SafeColorRefToARGB(KeyCapBorderColor),  MmToPixels(0.1));

    // Create font
    FontBrush := TGPSolidBrush.Create(SafeColorRefToARGB(KeyCapBorderColor));
    FontFamily := TGPFontFamily.Create(Self.Font.Name);
    Font := TGPFont.Create(FontFamily, (MulDiv(Self.Font.Size, Screen.PixelsPerInch, 96) / 100) * Zoom, FontStyle(Self.Font), UnitPoint);
    StringFormat := TGPStringFormat.Create;
    StringFormat.SetAlignment(StringAlignmentCenter);
    StringFormat.SetLineAlignment(StringAlignmentCenter);

    try
      // Draw outer keycap
      Graphics.DrawPath(OuterPen, OuterPath);
      Graphics.FillPath(OuterBrush, OuterPath);

      // Draw extra outline when selected
      if (Index = SelectedIndex) then Graphics.DrawPath(OuterPen, OuterPath);

      // Draw inner keycap
      Graphics.DrawPath(InnerPen, InnerPath);
      Graphics.FillPath(InnerBrush, InnerPath);

      // Draw key number
      S := IntToStr(Index + 1);
      Graphics.DrawString(S, Length(S), Font, InnerRect, StringFormat, FontBrush);
    finally
      OuterPath.Free;
      InnerPath.Free;
      OuterBrush.Free;
      OuterPen.Free;
      InnerBrush.Free;
      InnerPen.Free;
      FontFamily.Free;
      Font.Free;
      StringFormat.Free;
      FontBrush.Free;
    end;
  end;

  //----------------------------------------------------------------------------
  // DRAW ROTARY ENCODER
  //----------------------------------------------------------------------------
  procedure DrawRotaryEncoder(const Index: Integer);
  var
    IW, IH, X, Y: Single;
    OuterRect, InnerRect: TGPRectF;
    OuterBrush, InnerBrush, FontBrush: TGPBrush;
    OuterPen, InnerPen: TGPPen;
    Font: TGPFont;
    FontFamily: TGPFontFamily;
    StringFormat: TGPStringFormat;
    S: string;
  begin
    // Calculate the inner width
    IW := MmToPixels(KeyCapWidth * 0.9);
    // Calculate the inner height
    IH := MmToPixels(KeyCapHeight * 0.9);

    // Create the outer rect
    OuterRect := MakeRect(
      ButtonRects[Index].X,                                                // Left
      ButtonRects[Index].Y,                                                // Top
      ButtonRects[Index].Width,                                            // Width
      ButtonRects[Index].Height                                            // Height
    );
    // Create the inner rect
    InnerRect := MakeRect(
      ButtonRects[Index].X + ((ButtonRects[Index].Width / 2) - (IW / 2)),  // Left
      ButtonRects[Index].Y + ((ButtonRects[Index].Height / 2) - (IH / 2)), // Top
      IW,                                                                  // Width
      IH                                                                   // Height
    );

    // Create the outer brush
    OuterBrush := TGPLinearGradientBrush.Create(KeyboardRect, SafeColorRefToARGB(KeyCapOuterBackgroundFromColor), SafeColorRefToARGB(KeyCapOuterBackgroundToColor), LinearGradientModeVertical);
    // Create the outer pen
    if (Index = SelectedIndex) then
      OuterPen := TGPPen.Create(SafeColorRefToARGB(clHighlight),  MmToPixels(0.5))
    else
      OuterPen := TGPPen.Create(SafeColorRefToARGB(KeyCapBorderColor),  MmToPixels(0.5));

    // Create the inner brush
    InnerBrush := TGPLinearGradientBrush.Create(KeyboardRect, SafeColorRefToARGB(KeyCapInnerBackgroundFromColor), SafeColorRefToARGB(KeyCapInnerBackgroundToColor), LinearGradientModeVertical);
    // Create the inner pen
    InnerPen := TGPPen.Create(SafeColorRefToARGB(KeyCapBorderColor),  MmToPixels(0.1));

    // Create font
    FontBrush := TGPSolidBrush.Create(SafeColorRefToARGB(KeyCapBorderColor));
    FontFamily := TGPFontFamily.Create(Self.Font.Name);
    Font := TGPFont.Create(FontFamily, (MulDiv(Self.Font.Size, Screen.PixelsPerInch, 96) / 100) * Zoom, FontStyle(Self.Font), UnitPoint);
    StringFormat := TGPStringFormat.Create;
    StringFormat.SetAlignment(StringAlignmentCenter);
    StringFormat.SetLineAlignment(StringAlignmentCenter);

    try
      // Draw outer rotary encoder
      Graphics.DrawEllipse(OuterPen, OuterRect);
      Graphics.FillEllipse(OuterBrush, OuterRect);

      // Draw extra outline when selected
      if (Index = SelectedIndex) then Graphics.DrawEllipse(OuterPen, OuterRect);

      // Draw inner rotary encoder
      Graphics.DrawEllipse(InnerPen, InnerRect);
      Graphics.FillEllipse(InnerBrush, InnerRect);

      // Draw rotary encoder indicator line
      X := InnerRect.X + (InnerRect.Width / 2);
      Y := InnerRect.Y;
      Graphics.DrawLine(InnerPen, X, Y, X, Y + (InnerRect.Height / 4));

      // Draw rotary encoder number
      S := IntToStr(Index - 11);
      Graphics.DrawString(S, Length(S), Font, InnerRect, StringFormat, FontBrush);
    finally
      OuterBrush.Free;
      OuterPen.Free;
      InnerBrush.Free;
      InnerPen.Free;
      FontFamily.Free;
      Font.Free;
      StringFormat.Free;
      FontBrush.Free;
    end;
  end;

var
  X, Y, BX, BY: Single;
  I, J, Index: Integer;
begin
  // Update the size of the buffer
  Buffer.SetSize(Width, Height);

  // If VCL styles is available and enabled, then draw the VCL Style background
  // so it matches the active style background like on the Form or a Panel.
  if TStyleManager.IsCustomStyleActive then
  begin
    SS := StyleServices;
    // Draw the styled background
    SS.DrawElement(Buffer.Canvas.Handle, SS.GetElementDetails(twWindowRoot), Rect(0, 0, Width, Height));
  end else
  // Otherwise fill the background with the color.
  with Buffer.Canvas do
  begin
    // Use the component color
    Brush.Color := Self.Color;
    // Use a solid brush
    Brush.Style := bsSolid;
    // Fill the background with the component color
    FillRect(Rect(0, 0, Width, Height));
  end;

  // Initialize GDI+ Graphics object
  Graphics := TGPGraphics.Create(Buffer.Canvas.Handle);
  try
    // Set smoothing mode to high-quality
    Graphics.SetSmoothingMode(SmoothingModeHighQuality);
    // Set compositing quality to high-quality
    Graphics.SetCompositingQuality(CompositingQualityHighQuality);

    // Draw keyboard background
    DrawKeyboard;

    // Draw screw Top Left
    DrawScrew(KeyboardRect.X + MmToPixels(ScrewOffset), KeyboardRect.Y + MmToPixels(ScrewOffset));
    // Draw screw Top Right
    DrawScrew((KeyboardRect.X + KeyboardRect.Width) - MmToPixels(ScrewOffset), KeyboardRect.Y + MmToPixels(ScrewOffset));
    // Draw screw Bottom Left
    DrawScrew(KeyboardRect.X + MmToPixels(ScrewOffset), (KeyboardRect.Y + KeyboardRect.Height) - MmToPixels(ScrewOffset));
    // Draw screw Bottom Right
    DrawScrew((KeyboardRect.X + KeyboardRect.Width) - MmToPixels(ScrewOffset), (KeyboardRect.Y + KeyboardRect.Height) - MmToPixels(ScrewOffset));

    // Calculate the X and Y positions
    X := KeyboardRect.X + MmToPixels(KeyCapOffset);
    Y := KeyboardRect.Y + MmToPixels(KeyCapOffset);

    // Set the length of the array of key rects (12 Buttons + 3 Rotary encoders)
    SetLength(FButtonRects, 15);

    // Initialize rects array index
    Index := 0;

    // Calculate the key rects
    for J := 0 to 2 do
    begin
      BX := X;
      BY := Y + (MmToPixels(KeyCapHeight) * J) + (MmToPixels(KeyCapSpaceBetween) * J);
      for I := 0 to 3 do
      begin
        ButtonRects[Index].X := BX + (I * MmToPixels(KeyCapWidth)) + (I * MmToPixels(KeyCapSpaceBetween));
        ButtonRects[Index].Y := BY;
        ButtonRects[Index].Width  := MmToPixels(KeyCapWidth);
        ButtonRects[Index].Height := MmToPixels(KeyCapHeight);
        Inc(Index);
      end;
    end;

    // Calculate rotary encoder X position
    X := ((KeyboardRect.X + KeyboardRect.Width) - MmToPixels(KeyCapOffset)) - MmToPixels(RotaryEncoderWidth);

    // Calculate rotary encoder 1 rect
    ButtonRects[Index].X := X;
    ButtonRects[Index].Y := KeyboardRect.Y + MmToPixels(RotaryEncoderOffset);
    ButtonRects[Index].Width  := MmToPixels(RotaryEncoderWidth);
    ButtonRects[Index].Height := MmToPixels(RotaryEncoderHeight);
    Inc(Index);

    // Calculate rotary encoder 2 rect
    ButtonRects[Index].X := X;
    ButtonRects[Index].Y := (KeyboardRect.Y + (KeyboardRect.Height / 2)) - (MmToPixels(RotaryEncoderHeight) / 2);
    ButtonRects[Index].Width  := MmToPixels(RotaryEncoderWidth);
    ButtonRects[Index].Height := MmToPixels(RotaryEncoderHeight);
    Inc(Index);

    // Calculate rotary encoder 3 rect
    ButtonRects[Index].X := X;
    ButtonRects[Index].Y := ((KeyboardRect.Y + KeyboardRect.Height) - MmToPixels(RotaryEncoderOffset)) - MmToPixels(RotaryEncoderHeight);
    ButtonRects[Index].Width  := MmToPixels(RotaryEncoderWidth);
    ButtonRects[Index].Height := MmToPixels(RotaryEncoderHeight);

    // Draw the keys
    for I := 0 to 11 do DrawKey(I);

    // Draw the rotary encoders
    for I := 12 to 14 do DrawRotaryEncoder(I);
  finally
    // Free GDI+ Graphics object
    Graphics.Free;
  end;
end;

//------------------------------------------------------------------------------
// ON MOUSE MOVE
//------------------------------------------------------------------------------
procedure TMacroKeyboard.MouseMove(Shift: TShiftState; X, Y: Integer);
var
  I, Index: Integer;
begin
  // Call inherited MouseMove
  inherited;

  // Dont continue if the component is disabled
  if (not Enabled) then Exit;

  // Initialize index
  Index := -1;

  // Loop over the button/rotary encoder - rects
  for I := Low(FButtonRects) to High(FButtonRects) do
  // Check if mouse is in the rect
  if PtInTGPRectF(FButtonRects[I], Point(X, Y)) then
  begin
    // Set the index
    Index := I;
    // Break the loop
    Break;
  end;

  // Update cursor
  if (Index <> -1) then
  begin
    if (Cursor <> crHandpoint) then Cursor := crHandpoint;
  end else
  begin
    if (Cursor <> crDefault) then Cursor := crDefault;
  end;
end;

//------------------------------------------------------------------------------
// ON MOUSE DOWN
//------------------------------------------------------------------------------
procedure TMacroKeyboard.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  I, Index: Integer;
  P: TPoint;
begin
  // Call inherited MouseDown
  inherited;

  // Dont continue if the component is disabled
  if (not Enabled) then Exit;

  // Initialize index
  Index := -1;

  // Reset zoom
  if (Button = mbMiddle) then Zoom := 100;

  // Loop over the button/rotary encoder - rects
  for I := Low(FButtonRects) to High(FButtonRects) do
  // Check if mouse is in the rect
  if PtInTGPRectF(FButtonRects[I], Point(X, Y)) then
  begin
    // Set the index
    Index := I;
    // Break the loop
    Break;
  end;

  // Update selected index
  if Button = mbLeft then SelectedIndex := Index;

  // Execute the popupmenu
  if Button = mbRight then
  begin
    // Update selected index
    SelectedIndex := Index;
    // Create relative point
    P := TPoint(ClientToScreen(Point(X, Y)));
    // Key PopupMenu
    if (Index >= 0) and (Index <= 11) and Assigned(KeyPopupMenu) then
      KeyPopupMenu.Popup(P.X, P.Y);
    // Rotary Encoder PopupMenu
    if (Index >= 12) and (Index <= 14) and Assigned(RotaryEncoderPopupMenu) then
      RotaryEncoderPopupMenu.Popup(P.X, P.Y);
  end;
end;

//------------------------------------------------------------------------------
// ON KEY DOWN
//------------------------------------------------------------------------------
procedure TMacroKeyboard.KeyDown(var Key: Word; Shift: TShiftState);
var
  Index: Integer;
begin
  // Call inherited KeyDown
  inherited;

  // Dont continue if the component is disabled
  if (not Enabled) then Exit;

  // Initialize index
  Index := SelectedIndex;

  // Arrow left
  if (Key = VK_LEFT) then
  begin
    if ((Index >= 1) and (Index <= 3)) or     // Keys Row 1
       ((Index >= 5) and (Index <= 7)) or     // Keys Row 2
       ((Index >= 9) and (Index <= 11))       // keys Row 3
    then begin
      SelectedIndex := Index - 1;
    end;

    if (Index = 12) then SelectedIndex := 3;  // Rotary encoder 1
    if (Index = 13) then SelectedIndex := 7;  // Rotary encoder 2
    if (Index = 14) then SelectedIndex := 11; // Rotary encoder 3
  end;

  // Arrow up
  if (Key = VK_UP) then
  begin
    if (Index = 8) then SelectedIndex := 4;   // Row 3, Key 1
    if (Index = 4) then SelectedIndex := 0;   // Row 2, Key 1
    if (Index = 9) then SelectedIndex := 5;   // Row 3, Key 2
    if (Index = 5) then SelectedIndex := 1;   // Row 2, Key 2
    if (Index = 10) then SelectedIndex := 6;  // Row 3, Key 3
    if (Index = 6) then SelectedIndex := 2;   // Row 2, Key 3
    if (Index = 11) then SelectedIndex := 7;  // Row 3, Key 4
    if (Index = 7) then SelectedIndex := 3;   // Row 2, Key 4

    if (Index = 14) then SelectedIndex := 13; // Rotary Encoder 3
    if (Index = 13) then SelectedIndex := 12; // Rotary Encoder 2
  end;

  // Arrow right
  if (Key = VK_RIGHT) then
  begin
    if ((Index >= 0) and (Index <= 2)) or     // Keys Row 1
       ((Index >= 4) and (Index <= 6)) or     // Keys Row 2
       ((Index >= 8) and (Index <= 10))       // keys Row 3
    then begin
      SelectedIndex := Index + 1;
    end;

    if (Index = 3)  then SelectedIndex := 12; // Last key on Row 1
    if (Index = 7)  then SelectedIndex := 13; // Last key on Row 2
    if (Index = 11) then SelectedIndex := 14; // Last key on Row 3
  end;

  // Arrow down
  if (Key = VK_DOWN) then
  begin
    if (Index = 0) then SelectedIndex := 4;   // Row 1, Key 1
    if (Index = 4) then SelectedIndex := 8;   // Row 2, Key 1
    if (Index = 1) then SelectedIndex := 5;   // Row 1, Key 2
    if (Index = 5) then SelectedIndex := 9;   // Row 2, Key 2
    if (Index = 2) then SelectedIndex := 6;   // Row 1, Key 3
    if (Index = 6) then SelectedIndex := 10;  // Row 2, Key 3
    if (Index = 3) then SelectedIndex := 7;   // Row 1, Key 4
    if (Index = 7) then SelectedIndex := 11;  // Row 2, Key 4

    if (Index = 12) then SelectedIndex := 13; // Rotary Encoder 1
    if (Index = 13) then SelectedIndex := 14; // Rotary Encoder 2
  end;

  // Escape
  if (Key = VK_ESCAPE) then SelectedIndex := -1;

  // Home
  if (Key = VK_HOME) then SelectedIndex := 0;

  // End
  if (Key = VK_END) then SelectedIndex := 14;
end;

//------------------------------------------------------------------------------
// GET DLG CODE HANDLER
//------------------------------------------------------------------------------
procedure TMacroKeyboard.WMGetDlgCode(var Message: TWMNoParams);
begin
  // We want to capture keys
  Message.Result := DLGC_WANTARROWS or DLGC_WANTCHARS;
end;

//------------------------------------------------------------------------------
// DO MOUSE WHEEL
//------------------------------------------------------------------------------
function TMacroKeyboard.DoMouseWheel(Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint): Boolean;
begin
  if WheelDelta > 0 then
    // Zoom in
    Zoom := Zoom + 10
  else
    // Zoom out
    Zoom := Zoom - 10;

  // Call inherited DoMouseWheel
  Result := inherited;
end;

//------------------------------------------------------------------------------
// ON CHANGE HANDLER
//------------------------------------------------------------------------------
procedure TMacroKeyboard.SettingsChanged(Sender: TObject);
begin
  // Invalidate buffer
  PaintBuffer;
end;

//------------------------------------------------------------------------------
// CONSTRUCTOR
//------------------------------------------------------------------------------
constructor TMacroKeyboard.Create(AOwner: TComponent);
begin
  // Call inherited constructor
  inherited Create(AOwner);

  // Prevent background erasure for smoother rendering and reduced flickering.
  ControlStyle := ControlStyle + [csCaptureMouse, csClickEvents, csOpaque, csDoubleClicks];

  // Create Buffer
  FBuffer := TBitmap.Create;
  // Set the buffer pixel format
  FBuffer.PixelFormat := pf32bit;

  // Set defaults
  TabStop := True;
  Width := 550;
  Height := 330;
  FSelectedIndex := -1;
  FZoom := 100;

  // Invalidate buffer
  PaintBuffer;
end;

//------------------------------------------------------------------------------
// DESTRUCTOR
//------------------------------------------------------------------------------
destructor TMacroKeyboard.Destroy;
begin
  // Free buffer
  FBuffer.Free;
  // Call inherited destructor
  inherited Destroy;
end;

//------------------------------------------------------------------------------
// ASSIGN
//------------------------------------------------------------------------------
procedure TMacroKeyboard.Assign(Source: TPersistent);
begin
  // Call inherited assign
  inherited;
  // Assign custom properties
  if (Source is TMacroKeyboard) then
  begin
    SelectedIndex := (Source as TMacroKeyboard).SelectedIndex;
    KeyPopupMenu := (Source as TMacroKeyboard).KeyPopupMenu;
    RotaryEncoderPopupMenu := (Source as TMacroKeyboard).RotaryEncoderPopupMenu;
    Zoom := (Source as TMacroKeyboard).Zoom;
  end;
end;

//------------------------------------------------------------------------------
// REPAINT
//------------------------------------------------------------------------------
procedure TMacroKeyboard.Repaint;
begin
  // Call inherited repaint
  inherited;

  // Invalidate Buffer
  PaintBuffer;
  // Invalidate control
  Invalidate;
end;

//------------------------------------------------------------------------------
// REGISTER COMPONENT
//------------------------------------------------------------------------------
procedure Register;
begin
  RegisterComponents('ERDesigns', [TMacroKeyboard, TMacroKeyboardConfig]);
end;

end.
