object frmMain: TfrmMain
  Left = 0
  Top = 0
  Caption = 'frmMain'
  ClientHeight = 442
  ClientWidth = 628
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Menu = MainMenu
  Position = poScreenCenter
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  TextHeight = 15
  object MacroKeyboard: TMacroKeyboard
    Left = 0
    Top = 0
    Width = 628
    Height = 423
    KeyPopupMenu = PopupKey
    RotaryEncoderPopupMenu = PopupRotaryEncoder
    OnSelect = MacroKeyboardSelect
    Align = alClient
    TabOrder = 0
    ExplicitWidth = 624
    ExplicitHeight = 422
  end
  object StatusBar: TStatusBar
    Left = 0
    Top = 423
    Width = 628
    Height = 19
    Panels = <
      item
        Width = 50
      end>
    ExplicitTop = 422
    ExplicitWidth = 624
  end
  object ActionList: TActionList
    Left = 96
    Top = 8
    object acNew: TAction
      Category = 'File'
      Caption = '&New..'
      OnExecute = acNewExecute
    end
    object acOpen: TFileOpen
      Category = 'File'
      Caption = '&Open...'
      Dialog.DefaultExt = '*.mkc'
      Dialog.Filter = 'Macro Keyboard Config|*.mkc'
      ShortCut = 16463
      BeforeExecute = acOpenBeforeExecute
      OnAccept = acOpenAccept
    end
    object acSave: TAction
      Category = 'File'
      Caption = 'Save..'
      OnExecute = acSaveExecute
    end
    object acSaveAs: TFileSaveAs
      Category = 'File'
      Caption = 'Save &As...'
      Dialog.DefaultExt = '*.mkc'
      Dialog.Filter = 'Macro Keyboard Config|*.mkc'
      OnAccept = acSaveAsAccept
    end
    object acExit: TAction
      Category = 'File'
      Caption = 'Exit..'
      OnExecute = acExitExecute
    end
    object acSetMacroKey: TAction
      Category = 'Key'
      Caption = 'Set Macro..'
      OnExecute = acSetMacroKeyExecute
    end
    object acClearKey: TAction
      Category = 'Key'
      Caption = 'Clear..'
    end
    object acSetMacroKnobC: TAction
      Category = 'Knob'
      Caption = 'Set Clockwise Macro..'
    end
    object acSetMacroKnobCC: TAction
      Category = 'Knob'
      Caption = 'Set Counter Clockwise Macro..'
    end
    object acSetMacroKnob: TAction
      Category = 'Knob'
      Caption = 'Set Click Macro..'
    end
    object acClearKnob: TAction
      Category = 'Knob'
      Caption = 'Clear..'
    end
    object acAbout: TAction
      Category = 'Help'
      Caption = 'About..'
      OnExecute = acAboutExecute
    end
    object acSettings: TAction
      Category = 'File'
      Caption = 'Settings..'
    end
    object acZoomIn: TAction
      Caption = 'Zoom In..'
      OnExecute = acZoomInExecute
    end
    object acZoomOut: TAction
      Caption = 'Zoom Out..'
      OnExecute = acZoomOutExecute
    end
    object acZoom100: TAction
      Caption = 'Zoom 100%..'
      OnExecute = acZoom100Execute
    end
  end
  object MainMenu: TMainMenu
    Left = 24
    Top = 8
    object File1: TMenuItem
      Caption = 'File'
      object New1: TMenuItem
        Action = acNew
      end
      object Open1: TMenuItem
        Action = acOpen
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object Save1: TMenuItem
        Action = acSave
      end
      object SaveAs1: TMenuItem
        Action = acSaveAs
      end
      object N2: TMenuItem
        Caption = '-'
      end
      object Settings1: TMenuItem
        Action = acSettings
      end
      object N6: TMenuItem
        Caption = '-'
      end
      object Exit1: TMenuItem
        Action = acExit
      end
    end
    object Key1: TMenuItem
      Caption = 'Key'
      Enabled = False
      object SetMacro1: TMenuItem
        Action = acSetMacroKey
      end
      object N3: TMenuItem
        Caption = '-'
      end
      object Clear1: TMenuItem
        Action = acClearKey
      end
    end
    object Knob1: TMenuItem
      Caption = 'Knob'
      Enabled = False
      object SetClockwiseMacro1: TMenuItem
        Action = acSetMacroKnobC
      end
      object SetCounterClockwiseMacro1: TMenuItem
        Action = acSetMacroKnobCC
      end
      object N4: TMenuItem
        Caption = '-'
      end
      object SetClickMacro1: TMenuItem
        Action = acSetMacroKnob
      end
      object N5: TMenuItem
        Caption = '-'
      end
      object Clear2: TMenuItem
        Action = acClearKnob
      end
    end
    object View1: TMenuItem
      Caption = 'View'
      object ZoomIn1: TMenuItem
        Action = acZoomIn
      end
      object ZoomOut1: TMenuItem
        Action = acZoomOut
      end
      object N10: TMenuItem
        Caption = '-'
      end
      object Zoom1001: TMenuItem
        Action = acZoom100
      end
    end
    object Help1: TMenuItem
      Caption = 'Help'
      object About1: TMenuItem
        Action = acAbout
      end
    end
  end
  object RepaintTimer: TTimer
    Enabled = False
    Interval = 10
    OnTimer = RepaintTimerTimer
    Left = 168
    Top = 8
  end
  object PopupKey: TPopupMenu
    Left = 240
    Top = 8
    object SetMacro2: TMenuItem
      Action = acSetMacroKey
    end
    object N7: TMenuItem
      Caption = '-'
    end
    object Clear3: TMenuItem
      Action = acClearKey
    end
  end
  object PopupRotaryEncoder: TPopupMenu
    Left = 336
    Top = 8
    object SetClockwiseMacro2: TMenuItem
      Action = acSetMacroKnobC
    end
    object SetCounterClockwiseMacro2: TMenuItem
      Action = acSetMacroKnobCC
    end
    object N8: TMenuItem
      Caption = '-'
    end
    object SetClickMacro2: TMenuItem
      Action = acSetMacroKnob
    end
    object N9: TMenuItem
      Caption = '-'
    end
    object Clear4: TMenuItem
      Action = acClearKnob
    end
  end
  object MacroKeyboardConfig: TMacroKeyboardConfig
    Modified = False
    Left = 464
    Top = 8
  end
end
