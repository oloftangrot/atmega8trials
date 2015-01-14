object Form1: TForm1
  Left = 86
  Top = 117
  Width = 495
  Height = 365
  Caption = 'DG8SAQ USB-DDS-Controller (example for AD9850/51)'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 9
    Top = 80
    Width = 64
    Height = 20
    Caption = 'f = 0 Hz'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label2: TLabel
    Left = 168
    Top = 16
    Width = 69
    Height = 13
    Caption = 'USB diagnosis'
  end
  object Label3: TLabel
    Left = 8
    Top = 160
    Width = 53
    Height = 13
    Caption = 'DDS Clock'
  end
  object Label4: TLabel
    Left = 8
    Top = 224
    Width = 71
    Height = 13
    Caption = 'Clock Multiplier'
  end
  object Label5: TLabel
    Left = 128
    Top = 186
    Width = 22
    Height = 13
    Caption = 'MHz'
  end
  object Label6: TLabel
    Left = 168
    Top = 307
    Width = 96
    Height = 13
    Caption = 'Received WORD = '
  end
  object Edit1: TEdit
    Left = 7
    Top = 24
    Width = 97
    Height = 21
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 0
    Text = '0'
    OnChange = Edit1Exit
    OnClick = Edit1Exit
    OnExit = Edit1Exit
  end
  object ComboBox1: TComboBox
    Left = 103
    Top = 24
    Width = 49
    Height = 21
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ItemHeight = 13
    ItemIndex = 0
    ParentFont = False
    TabOrder = 1
    Text = 'Hz'
    OnChange = ComboBox1Change
    Items.Strings = (
      'Hz'
      'kHz'
      'MHz')
  end
  object Button1: TButton
    Left = 7
    Top = 9
    Width = 33
    Height = 17
    Caption = '&+M'
    TabOrder = 2
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 39
    Top = 9
    Width = 33
    Height = 17
    Caption = '+k'
    TabOrder = 3
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 71
    Top = 9
    Width = 33
    Height = 17
    Caption = '+'
    TabOrder = 4
    OnClick = Button3Click
  end
  object Button4: TButton
    Left = 7
    Top = 44
    Width = 33
    Height = 17
    Caption = '&-M'
    TabOrder = 5
    OnClick = Button4Click
  end
  object Button5: TButton
    Left = 39
    Top = 44
    Width = 33
    Height = 17
    Caption = '-k'
    TabOrder = 6
    OnClick = Button5Click
  end
  object Button6: TButton
    Left = 71
    Top = 44
    Width = 33
    Height = 17
    Caption = '-'
    TabOrder = 7
    OnClick = Button6Click
  end
  object ListBox1: TListBox
    Left = 168
    Top = 40
    Width = 305
    Height = 249
    ItemHeight = 13
    TabOrder = 8
  end
  object Button7: TButton
    Left = 256
    Top = 12
    Width = 217
    Height = 21
    Caption = 'Update'
    TabOrder = 9
    OnClick = Button7Click
  end
  object Edit2: TEdit
    Left = 8
    Top = 184
    Width = 113
    Height = 21
    TabOrder = 10
    Text = '160'
    OnChange = Edit2Exit
    OnClick = Edit2Exit
    OnExit = Edit2Exit
  end
  object Edit3: TEdit
    Left = 8
    Top = 248
    Width = 113
    Height = 21
    Enabled = False
    TabOrder = 11
    Text = '1'
  end
  object Button8: TButton
    Left = 8
    Top = 304
    Width = 121
    Height = 25
    Caption = 'Receive Data Demo'
    TabOrder = 12
    OnClick = Button8Click
  end
end
