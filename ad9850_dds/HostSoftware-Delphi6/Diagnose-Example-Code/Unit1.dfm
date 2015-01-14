object Form1: TForm1
  Left = 221
  Top = 164
  Width = 744
  Height = 544
  Caption = 'Form1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  DesignSize = (
    736
    517)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 399
    Width = 146
    Height = 13
    Anchors = [akLeft, akBottom]
    Caption = 'request         value           index'
  end
  object Label2: TLabel
    Left = 192
    Top = 381
    Width = 22
    Height = 13
    Anchors = [akLeft, akBottom]
    Caption = 'HEX'
  end
  object Label3: TLabel
    Left = 452
    Top = 480
    Width = 32
    Height = 13
    Anchors = [akLeft, akBottom]
    Caption = 'Label3'
  end
  object Label4: TLabel
    Left = 8
    Top = 480
    Width = 73
    Height = 13
    Caption = 'Data to be sent'
  end
  object Label5: TLabel
    Left = 320
    Top = 461
    Width = 22
    Height = 13
    Anchors = [akLeft, akBottom]
    Caption = 'HEX'
  end
  object Label6: TLabel
    Left = 280
    Top = 379
    Width = 15
    Height = 13
    Caption = 'n ='
  end
  object LBusy: TLabel
    Left = 560
    Top = 416
    Width = 71
    Height = 37
    Caption = 'done'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -32
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object ListBox1: TListBox
    Left = 0
    Top = 0
    Width = 736
    Height = 329
    Align = alTop
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clHighlight
    Font.Height = -16
    Font.Name = 'Terminal'
    Font.Style = []
    ItemHeight = 16
    ParentFont = False
    TabOrder = 5
  end
  object Button1: TButton
    Left = 456
    Top = 336
    Width = 273
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = 'TestUSB'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Button4: TButton
    Left = 8
    Top = 336
    Width = 217
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = 'USB_control_msg      data to host'
    TabOrder = 1
    OnClick = Button4Click
  end
  object Edit1: TEdit
    Left = 8
    Top = 376
    Width = 57
    Height = 21
    Anchors = [akLeft, akBottom]
    TabOrder = 2
    Text = '3'
  end
  object Edit2: TEdit
    Left = 72
    Top = 376
    Width = 49
    Height = 21
    Anchors = [akLeft, akBottom]
    TabOrder = 3
    Text = '0'
  end
  object Edit3: TEdit
    Left = 128
    Top = 376
    Width = 57
    Height = 21
    Anchors = [akLeft, akBottom]
    TabOrder = 4
    Text = '0'
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 498
    Width = 736
    Height = 19
    Panels = <>
    SimplePanel = False
  end
  object Button2: TButton
    Left = 8
    Top = 424
    Width = 217
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = 'USB_control_msg      data to USB device'
    TabOrder = 7
    OnClick = Button2Click
  end
  object E0: TEdit
    Left = 8
    Top = 455
    Width = 33
    Height = 21
    Anchors = [akLeft, akBottom]
    TabOrder = 8
    Text = 'E0'
  end
  object E1: TEdit
    Left = 40
    Top = 455
    Width = 33
    Height = 21
    Anchors = [akLeft, akBottom]
    TabOrder = 9
    Text = 'E1'
  end
  object E2: TEdit
    Left = 72
    Top = 455
    Width = 33
    Height = 21
    Anchors = [akLeft, akBottom]
    TabOrder = 10
    Text = 'E2'
  end
  object E3: TEdit
    Left = 104
    Top = 455
    Width = 33
    Height = 21
    Anchors = [akLeft, akBottom]
    TabOrder = 11
    Text = 'E3'
  end
  object E4: TEdit
    Left = 136
    Top = 455
    Width = 33
    Height = 21
    Anchors = [akLeft, akBottom]
    TabOrder = 12
    Text = 'E4'
  end
  object ELen: TEdit
    Left = 280
    Top = 455
    Width = 33
    Height = 21
    Anchors = [akLeft, akBottom]
    TabOrder = 13
    Text = 'Len'
  end
  object E7: TEdit
    Left = 232
    Top = 455
    Width = 33
    Height = 21
    Anchors = [akLeft, akBottom]
    TabOrder = 14
    Text = 'E7'
  end
  object E6: TEdit
    Left = 200
    Top = 455
    Width = 33
    Height = 21
    Anchors = [akLeft, akBottom]
    TabOrder = 15
    Text = 'E6'
  end
  object E5: TEdit
    Left = 168
    Top = 455
    Width = 33
    Height = 21
    Anchors = [akLeft, akBottom]
    TabOrder = 16
    Text = 'E5'
  end
  object Button3: TButton
    Left = 224
    Top = 336
    Width = 217
    Height = 25
    Caption = 'n times USB_control_msg alt. value'
    TabOrder = 17
    OnClick = Button3Click
  end
  object Edit4: TEdit
    Left = 320
    Top = 376
    Width = 89
    Height = 21
    TabOrder = 18
    Text = '1000'
  end
end
