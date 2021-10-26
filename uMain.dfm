object Form4: TForm4
  Left = 0
  Top = 0
  ActiveControl = Button1
  Caption = #50864#54200#48264#54840' '#44160#49353
  ClientHeight = 242
  ClientWidth = 539
  Color = clBtnFace
  Font.Charset = HANGEUL_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #47569#51008' '#44256#46357
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 15
  object Label1: TLabel
    Left = 8
    Top = 14
    Width = 48
    Height = 15
    Caption = #50864#54200#48264#54840
  end
  object Label2: TLabel
    Left = 8
    Top = 44
    Width = 24
    Height = 15
    Caption = #51452#49548
  end
  object Label3: TLabel
    Left = 8
    Top = 73
    Width = 48
    Height = 15
    Caption = #49345#49464#51452#49548
  end
  object Label4: TLabel
    Left = 8
    Top = 180
    Width = 24
    Height = 15
    Caption = #51452#49548
  end
  object Label5: TLabel
    Left = 8
    Top = 209
    Width = 48
    Height = 15
    Caption = #49345#49464#51452#49548
  end
  object Label6: TLabel
    Left = 8
    Top = 120
    Width = 343
    Height = 15
    Caption = #51452#49548' '#51077#47141#52285#50640#49436' '#54876#50857#54616#45716' '#44221#50864', '#44160#49353#50612#47484' '#45347#44256' '#50644#53552#53412#47484' '#45572#47480#45796
  end
  object Label7: TLabel
    Left = 8
    Top = 150
    Width = 48
    Height = 15
    Caption = #50864#54200#48264#54840
  end
  object Button1: TButton
    Left = 167
    Top = 10
    Width = 75
    Height = 25
    Caption = #52286#44592
    TabOrder = 1
    OnClick = Button1Click
  end
  object eZip: TEdit
    Left = 82
    Top = 11
    Width = 79
    Height = 23
    Color = clBtnFace
    TabOrder = 0
  end
  object eAddr1: TEdit
    Left = 82
    Top = 40
    Width = 446
    Height = 23
    TabOrder = 2
  end
  object eAddr2: TEdit
    Left = 82
    Top = 69
    Width = 446
    Height = 23
    TabOrder = 3
  end
  object Edit1: TEdit
    Left = 82
    Top = 176
    Width = 446
    Height = 23
    TabOrder = 5
    OnKeyPress = Edit1KeyPress
  end
  object Edit2: TEdit
    Left = 82
    Top = 205
    Width = 446
    Height = 23
    TabOrder = 6
  end
  object Edit3: TEdit
    Left = 82
    Top = 147
    Width = 79
    Height = 23
    Color = clBtnFace
    ReadOnly = True
    TabOrder = 4
  end
end
