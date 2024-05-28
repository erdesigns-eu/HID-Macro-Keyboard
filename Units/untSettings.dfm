object frmSettings: TfrmSettings
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'frmSettings'
  ClientHeight = 432
  ClientWidth = 401
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
    Top = 392
    Width = 401
    Height = 40
    Align = alBottom
    BevelOuter = bvNone
    ShowCaption = False
    TabOrder = 5
    ExplicitTop = 391
    ExplicitWidth = 397
    object btnOK: TButton
      AlignWithMargins = True
      Left = 199
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
      ExplicitLeft = 195
    end
    object btnCancel: TButton
      AlignWithMargins = True
      Left = 300
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
      ExplicitLeft = 296
    end
  end
  object gbView: TGroupBox
    AlignWithMargins = True
    Left = 8
    Top = 4
    Width = 385
    Height = 77
    Margins.Left = 8
    Margins.Top = 4
    Margins.Right = 8
    Margins.Bottom = 0
    Align = alTop
    Caption = ' Zoom: '
    TabOrder = 0
    ExplicitWidth = 381
    DesignSize = (
      385
      77)
    object cbZoomOnScroll: TCheckBox
      Left = 16
      Top = 24
      Width = 345
      Height = 17
      Anchors = [akLeft, akTop, akRight]
      Caption = 'Zoom in/out with scroll'
      TabOrder = 0
      ExplicitWidth = 341
    end
    object cbRememberZoomLevel: TCheckBox
      Left = 16
      Top = 47
      Width = 345
      Height = 17
      Anchors = [akLeft, akTop, akRight]
      Caption = 'Remember zoom level'
      TabOrder = 1
      ExplicitWidth = 341
    end
  end
  object GroupBox1: TGroupBox
    AlignWithMargins = True
    Left = 8
    Top = 221
    Width = 385
    Height = 76
    Margins.Left = 8
    Margins.Top = 4
    Margins.Right = 8
    Margins.Bottom = 0
    Align = alTop
    Caption = ' Config: '
    TabOrder = 3
    ExplicitWidth = 381
    DesignSize = (
      385
      76)
    object cbLoadLastOpenedConfigOnStart: TCheckBox
      Left = 16
      Top = 24
      Width = 345
      Height = 17
      Anchors = [akLeft, akTop, akRight]
      Caption = 'Load last opened config on application start'
      TabOrder = 0
      ExplicitWidth = 341
    end
    object cbSetMacroKeysOnOpenConfig: TCheckBox
      Left = 16
      Top = 47
      Width = 345
      Height = 17
      Anchors = [akLeft, akTop, akRight]
      Caption = 'Set macro keys on opening config'
      TabOrder = 1
      ExplicitWidth = 341
    end
  end
  object GroupBox2: TGroupBox
    AlignWithMargins = True
    Left = 8
    Top = 85
    Width = 385
    Height = 52
    Margins.Left = 8
    Margins.Top = 4
    Margins.Right = 8
    Margins.Bottom = 0
    Align = alTop
    Caption = ' Hints: '
    TabOrder = 1
    ExplicitWidth = 381
    DesignSize = (
      385
      52)
    object cbShowKeyKnobHint: TCheckBox
      Left = 16
      Top = 23
      Width = 345
      Height = 17
      Anchors = [akLeft, akTop, akRight]
      Caption = 'Show hint with name on Key/Knob'
      TabOrder = 0
      ExplicitWidth = 341
    end
  end
  object GroupBox3: TGroupBox
    AlignWithMargins = True
    Left = 8
    Top = 141
    Width = 385
    Height = 76
    Margins.Left = 8
    Margins.Top = 4
    Margins.Right = 8
    Margins.Bottom = 0
    Align = alTop
    Caption = ' Tray Icon: '
    TabOrder = 2
    ExplicitWidth = 381
    DesignSize = (
      385
      76)
    object cbTrayIconVisible: TCheckBox
      Left = 16
      Top = 23
      Width = 345
      Height = 17
      Anchors = [akLeft, akTop, akRight]
      Caption = 'Visible'
      TabOrder = 0
      ExplicitWidth = 341
    end
    object cbMinimizeToTray: TCheckBox
      Left = 16
      Top = 46
      Width = 345
      Height = 17
      Anchors = [akLeft, akTop, akRight]
      Caption = 'Minimize to tray'
      TabOrder = 1
      ExplicitWidth = 341
    end
  end
  object GroupBox4: TGroupBox
    AlignWithMargins = True
    Left = 8
    Top = 301
    Width = 385
    Height = 76
    Margins.Left = 8
    Margins.Top = 4
    Margins.Right = 8
    Margins.Bottom = 0
    Align = alTop
    Caption = ' Window: '
    TabOrder = 4
    ExplicitWidth = 381
    DesignSize = (
      385
      76)
    object cbRememberWindowPosition: TCheckBox
      Left = 16
      Top = 24
      Width = 345
      Height = 17
      Anchors = [akLeft, akTop, akRight]
      Caption = 'Remember position'
      TabOrder = 0
      ExplicitWidth = 341
    end
    object cbRememberWindowState: TCheckBox
      Left = 16
      Top = 47
      Width = 345
      Height = 17
      Anchors = [akLeft, akTop, akRight]
      Caption = 'Remember state'
      TabOrder = 1
      ExplicitWidth = 341
    end
  end
end
