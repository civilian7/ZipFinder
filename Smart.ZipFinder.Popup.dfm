object ZipFinderPopup: TZipFinderPopup
  Left = 0
  Top = 0
  ActiveControl = eText
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  BorderWidth = 1
  Caption = #50864#54200#48264#54840' '#52286#44592
  ClientHeight = 371
  ClientWidth = 585
  Color = clBtnFace
  DoubleBuffered = True
  Font.Charset = HANGEUL_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #47569#51008' '#44256#46357
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  OnKeyDown = FormKeyDown
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 15
  object lvZip: TListView
    AlignWithMargins = True
    Left = 3
    Top = 33
    Width = 579
    Height = 314
    Align = alClient
    Columns = <
      item
        Caption = #50864#54200#48264#54840
        Width = 64
      end
      item
        Caption = #51452#49548
        Width = 494
      end>
    ColumnClick = False
    ReadOnly = True
    RowSelect = True
    TabOrder = 0
    ViewStyle = vsReport
    OnDblClick = lvZipDblClick
    OnKeyDown = lvZipKeyDown
    ExplicitLeft = -2
  end
  object pnlSearch: TPanel
    Left = 0
    Top = 0
    Width = 585
    Height = 30
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    object eText: TLabeledEdit
      Left = 123
      Top = 4
      Width = 379
      Height = 23
      EditLabel.Width = 116
      EditLabel.Height = 15
      EditLabel.Caption = #44160#49353#54624' '#51452#49548'('#44148#47932#47749')  '
      ImeMode = imSHanguel
      LabelPosition = lpLeft
      MaxLength = 40
      TabOrder = 0
      TextHint = #46020#47196#47749#51452#49548' '#46608#45716' '#44148#47932#47749#51012' '#51077#47141#54616#49464#50836
      OnKeyPress = eTextKeyPress
    end
    object btnSearch: TButton
      AlignWithMargins = True
      Left = 507
      Top = 3
      Width = 75
      Height = 25
      Margins.Bottom = 2
      Align = alRight
      Caption = #52286#44592
      TabOrder = 1
      OnClick = btnSearchClick
    end
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 350
    Width = 585
    Height = 21
    Panels = <>
    SimplePanel = True
    SizeGrip = False
    ExplicitTop = 346
  end
end
