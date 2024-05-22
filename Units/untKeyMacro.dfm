object frmKeyMacro: TfrmKeyMacro
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'frmKeyMacro'
  ClientHeight = 571
  ClientWidth = 368
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  TextHeight = 15
  object pnlBottom: TPanel
    Left = 0
    Top = 531
    Width = 368
    Height = 40
    Align = alBottom
    BevelOuter = bvNone
    ShowCaption = False
    TabOrder = 2
    object btnOK: TButton
      AlignWithMargins = True
      Left = 166
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
      ExplicitLeft = 164
      ExplicitHeight = 25
    end
    object btnCancel: TButton
      AlignWithMargins = True
      Left = 267
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
      ExplicitLeft = 265
      ExplicitHeight = 25
    end
  end
  object rgMouse: TRadioGroup
    AlignWithMargins = True
    Left = 4
    Top = 381
    Width = 360
    Height = 68
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
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
    ExplicitLeft = 9
    ExplicitTop = 582
    ExplicitWidth = 362
  end
  object rgMacroType: TRadioGroup
    AlignWithMargins = True
    Left = 4
    Top = 61
    Width = 360
    Height = 53
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 0
    Align = alTop
    Caption = ' Macro Type: '
    Columns = 3
    ItemIndex = 0
    Items.Strings = (
      'Keyboard'
      'Mouse'
      'Media')
    TabOrder = 0
    OnClick = rgMacroTypeClick
    ExplicitWidth = 358
  end
  object gbModifiers: TGroupBox
    AlignWithMargins = True
    Left = 4
    Top = 118
    Width = 360
    Height = 76
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 0
    Align = alTop
    Caption = ' Modifier Keys: '
    TabOrder = 3
    ExplicitWidth = 358
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
    Left = 4
    Top = 453
    Width = 360
    Height = 68
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
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
    ExplicitLeft = 28
    ExplicitTop = 582
    ExplicitWidth = 362
  end
  object gbName: TGroupBox
    AlignWithMargins = True
    Left = 4
    Top = 4
    Width = 360
    Height = 53
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 0
    Align = alTop
    Caption = ' Name: '
    TabOrder = 5
    ExplicitWidth = 358
    object edtName: TEdit
      AlignWithMargins = True
      Left = 10
      Top = 20
      Width = 340
      Height = 21
      Margins.Left = 8
      Margins.Right = 8
      Margins.Bottom = 10
      Align = alClient
      TabOrder = 0
      TextHint = 'Enter a name for this macro key..'
      ExplicitWidth = 338
      ExplicitHeight = 23
    end
  end
  object gbKeyboard: TGroupBox
    AlignWithMargins = True
    Left = 4
    Top = 198
    Width = 360
    Height = 179
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 0
    Align = alTop
    Caption = ' Keyboard: '
    TabOrder = 6
    ExplicitWidth = 362
    object Panel1: TPanel
      Left = 2
      Top = 17
      Width = 356
      Height = 32
      Align = alTop
      BevelOuter = bvNone
      ShowCaption = False
      TabOrder = 0
      ExplicitWidth = 358
      DesignSize = (
        356
        32)
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
      object edtKey1: THotKey
        Left = 47
        Top = 4
        Width = 301
        Height = 23
        Anchors = [akLeft, akTop, akRight, akBottom]
        HotKey = 0
        InvalidKeys = [hcShift, hcCtrl, hcAlt, hcShiftCtrl, hcShiftAlt, hcCtrlAlt, hcShiftCtrlAlt]
        Modifiers = []
        TabOrder = 0
        ExplicitWidth = 303
      end
    end
    object Panel2: TPanel
      Left = 2
      Top = 49
      Width = 356
      Height = 32
      Align = alTop
      BevelOuter = bvNone
      ShowCaption = False
      TabOrder = 1
      ExplicitLeft = 3
      ExplicitTop = 113
      ExplicitWidth = 358
      DesignSize = (
        356
        32)
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
      object edtKey2: THotKey
        Left = 47
        Top = 4
        Width = 301
        Height = 23
        Anchors = [akLeft, akTop, akRight, akBottom]
        HotKey = 0
        InvalidKeys = [hcShift, hcCtrl, hcAlt, hcShiftCtrl, hcShiftAlt, hcCtrlAlt, hcShiftCtrlAlt]
        Modifiers = []
        TabOrder = 0
        ExplicitWidth = 303
      end
    end
    object Panel3: TPanel
      Left = 2
      Top = 81
      Width = 356
      Height = 32
      Align = alTop
      BevelOuter = bvNone
      ShowCaption = False
      TabOrder = 2
      ExplicitLeft = 1
      ExplicitTop = 145
      ExplicitWidth = 358
      DesignSize = (
        356
        32)
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
      object edtKey3: THotKey
        Left = 47
        Top = 4
        Width = 301
        Height = 23
        Anchors = [akLeft, akTop, akRight, akBottom]
        HotKey = 0
        InvalidKeys = [hcShift, hcCtrl, hcAlt, hcShiftCtrl, hcShiftAlt, hcCtrlAlt, hcShiftCtrlAlt]
        Modifiers = []
        TabOrder = 0
        ExplicitWidth = 303
      end
    end
    object Panel4: TPanel
      Left = 2
      Top = 113
      Width = 356
      Height = 32
      Align = alTop
      BevelOuter = bvNone
      ShowCaption = False
      TabOrder = 3
      ExplicitLeft = 3
      ExplicitTop = 176
      ExplicitWidth = 358
      DesignSize = (
        356
        32)
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
      object edtKey4: THotKey
        Left = 47
        Top = 4
        Width = 301
        Height = 23
        Anchors = [akLeft, akTop, akRight, akBottom]
        HotKey = 0
        InvalidKeys = [hcShift, hcCtrl, hcAlt, hcShiftCtrl, hcShiftAlt, hcCtrlAlt, hcShiftCtrlAlt]
        Modifiers = []
        TabOrder = 0
        ExplicitWidth = 303
      end
    end
    object Panel5: TPanel
      Left = 2
      Top = 145
      Width = 356
      Height = 32
      Align = alTop
      BevelOuter = bvNone
      ShowCaption = False
      TabOrder = 4
      ExplicitLeft = -6
      ExplicitTop = 193
      ExplicitWidth = 358
      DesignSize = (
        356
        32)
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
      object edtKey5: THotKey
        Left = 47
        Top = 4
        Width = 301
        Height = 23
        Anchors = [akLeft, akTop, akRight, akBottom]
        HotKey = 0
        InvalidKeys = [hcShift, hcCtrl, hcAlt, hcShiftCtrl, hcShiftAlt, hcCtrlAlt, hcShiftCtrlAlt]
        Modifiers = []
        TabOrder = 0
        ExplicitWidth = 303
      end
    end
  end
end
