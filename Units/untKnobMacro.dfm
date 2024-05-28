object frmKnobMacro: TfrmKnobMacro
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'frmKnobMacro'
  ClientHeight = 586
  ClientWidth = 358
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poMainFormCenter
  TextHeight = 15
  object pnlBottom: TPanel
    Left = 0
    Top = 546
    Width = 358
    Height = 40
    Align = alBottom
    BevelOuter = bvNone
    ShowCaption = False
    TabOrder = 0
    ExplicitTop = 545
    ExplicitWidth = 354
    object btnOK: TButton
      AlignWithMargins = True
      Left = 156
      Top = 7
      Width = 93
      Height = 26
      Margins.Left = 0
      Margins.Top = 7
      Margins.Right = 8
      Margins.Bottom = 7
      Align = alRight
      Caption = 'OK'
      ModalResult = 1
      TabOrder = 0
      ExplicitLeft = 152
    end
    object btnCancel: TButton
      AlignWithMargins = True
      Left = 257
      Top = 7
      Width = 93
      Height = 26
      Margins.Left = 0
      Margins.Top = 7
      Margins.Right = 8
      Margins.Bottom = 7
      Align = alRight
      Caption = 'Cancel'
      ModalResult = 2
      TabOrder = 1
      ExplicitLeft = 253
    end
  end
  object rgMouse: TRadioGroup
    AlignWithMargins = True
    Left = 8
    Top = 389
    Width = 342
    Height = 68
    Margins.Left = 8
    Margins.Top = 4
    Margins.Right = 8
    Margins.Bottom = 0
    Align = alTop
    Caption = ' Mouse: '
    Columns = 3
    Items.Strings = (
      'Left Button'
      'Wheel Down'
      'Middle Button'
      'Wheel Up'
      'Right Button')
    TabOrder = 1
    Visible = False
    ExplicitWidth = 338
  end
  object rgMacroType: TRadioGroup
    AlignWithMargins = True
    Left = 8
    Top = 61
    Width = 342
    Height = 53
    Margins.Left = 8
    Margins.Top = 4
    Margins.Right = 8
    Margins.Bottom = 0
    Align = alTop
    Caption = ' Macro Type: '
    Columns = 3
    ItemIndex = 0
    Items.Strings = (
      'Keyboard'
      'Mouse'
      'Media')
    TabOrder = 2
    OnClick = rgMacroTypeClick
    ExplicitWidth = 338
  end
  object gbModifiers: TGroupBox
    AlignWithMargins = True
    Left = 8
    Top = 118
    Width = 342
    Height = 76
    Margins.Left = 8
    Margins.Top = 4
    Margins.Right = 8
    Margins.Bottom = 0
    Align = alTop
    Caption = ' Modifier Keys: '
    TabOrder = 3
    ExplicitWidth = 338
    object cbCtrl: TCheckBox
      Left = 8
      Top = 20
      Width = 97
      Height = 17
      Caption = 'Ctrl (Cmd)'
      TabOrder = 0
    end
    object cbAlt: TCheckBox
      Left = 8
      Top = 46
      Width = 97
      Height = 17
      Caption = 'Alt (Option)'
      TabOrder = 1
    end
    object cbShift: TCheckBox
      Left = 125
      Top = 20
      Width = 97
      Height = 17
      Caption = 'Shift'
      TabOrder = 2
    end
    object cbWin: TCheckBox
      Left = 125
      Top = 46
      Width = 97
      Height = 17
      Caption = 'Win'
      TabOrder = 3
    end
  end
  object rgMedia: TRadioGroup
    AlignWithMargins = True
    Left = 8
    Top = 461
    Width = 342
    Height = 68
    Margins.Left = 8
    Margins.Top = 4
    Margins.Right = 8
    Margins.Bottom = 0
    Align = alTop
    Caption = ' Media: '
    Columns = 3
    Items.Strings = (
      'Play/Pause'
      'Mute'
      'Volume Up'
      'Previous Track'
      'Volume Down'
      'Next Track')
    TabOrder = 4
    Visible = False
    ExplicitWidth = 338
  end
  object gbName: TGroupBox
    AlignWithMargins = True
    Left = 8
    Top = 4
    Width = 342
    Height = 53
    Margins.Left = 8
    Margins.Top = 4
    Margins.Right = 8
    Margins.Bottom = 0
    Align = alTop
    Caption = ' Name: '
    TabOrder = 5
    ExplicitWidth = 338
    object edtName: TEdit
      AlignWithMargins = True
      Left = 10
      Top = 20
      Width = 322
      Height = 21
      Margins.Left = 8
      Margins.Right = 8
      Margins.Bottom = 10
      Align = alClient
      TabOrder = 0
      TextHint = 'Enter a name for this macro key..'
      ExplicitWidth = 318
      ExplicitHeight = 23
    end
  end
  object gbKeyboard: TGroupBox
    AlignWithMargins = True
    Left = 8
    Top = 198
    Width = 342
    Height = 187
    Margins.Left = 8
    Margins.Top = 4
    Margins.Right = 8
    Margins.Bottom = 0
    Align = alTop
    Caption = ' Keyboard: '
    TabOrder = 6
    ExplicitWidth = 338
    object Panel1: TPanel
      Left = 2
      Top = 17
      Width = 338
      Height = 32
      Align = alTop
      BevelOuter = bvNone
      ShowCaption = False
      TabOrder = 0
      ExplicitWidth = 334
      object Label1: TLabel
        Left = 0
        Top = 0
        Width = 41
        Height = 32
        Align = alLeft
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'Key 1:'
        Layout = tlCenter
      end
      object edtKey1: TMacroKeyboardHotKey
        AlignWithMargins = True
        Left = 49
        Top = 6
        Width = 198
        Height = 22
        Margins.Left = 8
        Margins.Top = 6
        Margins.Right = 0
        Margins.Bottom = 4
        Align = alClient
        ReadOnly = True
        TabOrder = 0
        ExplicitWidth = 194
        ExplicitHeight = 23
      end
      object btnClear1: TButton
        Tag = 1
        AlignWithMargins = True
        Left = 255
        Top = 4
        Width = 75
        Height = 24
        Margins.Left = 8
        Margins.Top = 4
        Margins.Right = 8
        Margins.Bottom = 4
        Align = alRight
        Caption = 'Clear'
        TabOrder = 1
        OnClick = btnClear1Click
        ExplicitLeft = 251
      end
    end
    object Panel2: TPanel
      Left = 2
      Top = 49
      Width = 338
      Height = 32
      Align = alTop
      BevelOuter = bvNone
      ShowCaption = False
      TabOrder = 1
      ExplicitWidth = 334
      object Label2: TLabel
        Left = 0
        Top = 0
        Width = 41
        Height = 32
        Align = alLeft
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'Key 2:'
        Layout = tlCenter
      end
      object edtKey2: TMacroKeyboardHotKey
        AlignWithMargins = True
        Left = 49
        Top = 6
        Width = 198
        Height = 22
        Margins.Left = 8
        Margins.Top = 6
        Margins.Right = 0
        Margins.Bottom = 4
        Align = alClient
        ReadOnly = True
        TabOrder = 0
        ExplicitWidth = 194
        ExplicitHeight = 23
      end
      object btnClear2: TButton
        Tag = 2
        AlignWithMargins = True
        Left = 255
        Top = 4
        Width = 75
        Height = 24
        Margins.Left = 8
        Margins.Top = 4
        Margins.Right = 8
        Margins.Bottom = 4
        Align = alRight
        Caption = 'Clear'
        TabOrder = 1
        OnClick = btnClear1Click
        ExplicitLeft = 251
      end
    end
    object Panel3: TPanel
      Left = 2
      Top = 81
      Width = 338
      Height = 32
      Align = alTop
      BevelOuter = bvNone
      ShowCaption = False
      TabOrder = 2
      ExplicitWidth = 334
      object Label3: TLabel
        Left = 0
        Top = 0
        Width = 41
        Height = 32
        Align = alLeft
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'Key 3:'
        Layout = tlCenter
      end
      object edtKey3: TMacroKeyboardHotKey
        AlignWithMargins = True
        Left = 49
        Top = 6
        Width = 198
        Height = 22
        Margins.Left = 8
        Margins.Top = 6
        Margins.Right = 0
        Margins.Bottom = 4
        Align = alClient
        ReadOnly = True
        TabOrder = 0
        ExplicitWidth = 194
        ExplicitHeight = 23
      end
      object btnClear3: TButton
        Tag = 3
        AlignWithMargins = True
        Left = 255
        Top = 4
        Width = 75
        Height = 24
        Margins.Left = 8
        Margins.Top = 4
        Margins.Right = 8
        Margins.Bottom = 4
        Align = alRight
        Caption = 'Clear'
        TabOrder = 1
        OnClick = btnClear1Click
        ExplicitLeft = 251
      end
    end
    object Panel4: TPanel
      Left = 2
      Top = 113
      Width = 338
      Height = 32
      Align = alTop
      BevelOuter = bvNone
      ShowCaption = False
      TabOrder = 3
      ExplicitWidth = 334
      object Label4: TLabel
        Left = 0
        Top = 0
        Width = 41
        Height = 32
        Align = alLeft
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'Key 4:'
        Layout = tlCenter
      end
      object edtKey4: TMacroKeyboardHotKey
        AlignWithMargins = True
        Left = 49
        Top = 6
        Width = 198
        Height = 22
        Margins.Left = 8
        Margins.Top = 6
        Margins.Right = 0
        Margins.Bottom = 4
        Align = alClient
        ReadOnly = True
        TabOrder = 0
        ExplicitWidth = 194
        ExplicitHeight = 23
      end
      object btnClear4: TButton
        Tag = 4
        AlignWithMargins = True
        Left = 255
        Top = 4
        Width = 75
        Height = 24
        Margins.Left = 8
        Margins.Top = 4
        Margins.Right = 8
        Margins.Bottom = 4
        Align = alRight
        Caption = 'Clear'
        TabOrder = 1
        OnClick = btnClear1Click
        ExplicitLeft = 251
      end
    end
    object Panel5: TPanel
      Left = 2
      Top = 145
      Width = 338
      Height = 32
      Align = alTop
      BevelOuter = bvNone
      ShowCaption = False
      TabOrder = 4
      ExplicitWidth = 334
      object Label5: TLabel
        Left = 0
        Top = 0
        Width = 41
        Height = 32
        Align = alLeft
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'Key 5:'
        Layout = tlCenter
      end
      object edtKey5: TMacroKeyboardHotKey
        AlignWithMargins = True
        Left = 49
        Top = 6
        Width = 198
        Height = 22
        Margins.Left = 8
        Margins.Top = 6
        Margins.Right = 0
        Margins.Bottom = 4
        Align = alClient
        ReadOnly = True
        TabOrder = 0
        ExplicitWidth = 194
        ExplicitHeight = 23
      end
      object btnClear5: TButton
        Tag = 5
        AlignWithMargins = True
        Left = 255
        Top = 4
        Width = 75
        Height = 24
        Margins.Left = 8
        Margins.Top = 4
        Margins.Right = 8
        Margins.Bottom = 4
        Align = alRight
        Caption = 'Clear'
        TabOrder = 1
        OnClick = btnClear1Click
        ExplicitLeft = 251
      end
    end
  end
end
