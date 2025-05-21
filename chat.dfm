object frmChat: TfrmChat
  Left = 0
  Top = 0
  Caption = 'Chat'
  ClientHeight = 672
  ClientWidth = 550
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnCreate = FormCreate
  TextHeight = 15
  object pnlHlavny: TPanel
    Left = 0
    Top = 112
    Width = 550
    Height = 560
    Align = alBottom
    TabOrder = 0
    object memChat: TMemo
      Left = 1
      Top = 37
      Width = 548
      Height = 522
      Align = alBottom
      ScrollBars = ssBoth
      TabOrder = 0
    end
    object edtSprava: TEdit
      Left = 0
      Top = 8
      Width = 449
      Height = 23
      TabOrder = 1
      Text = 'Zadaj spr'#225'vu'
      OnClick = edtSpravaClick
      OnKeyPress = edtSpravaKeyPress
    end
    object btnPoslat: TButton
      Left = 470
      Top = 6
      Width = 75
      Height = 25
      Caption = 'Posla'#357
      TabOrder = 2
      OnClick = btnPoslatClick
    end
  end
  object pnlNastavenie: TPanel
    Left = 0
    Top = 0
    Width = 550
    Height = 112
    Align = alClient
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    object lblIPV4: TLabel
      Left = 9
      Top = 21
      Width = 37
      Height = 21
      Caption = 'IPv4:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblPort: TLabel
      Left = 285
      Top = 19
      Width = 36
      Height = 21
      Caption = 'Port:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblPripojenie: TLabel
      Left = 197
      Top = 50
      Width = 159
      Height = 21
      Caption = 'Pripojenie neakt'#237'vne'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clCrimson
      Font.Height = -16
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblHeslo: TLabel
      Left = 197
      Top = 80
      Width = 156
      Height = 21
      Caption = 'Heslo pre '#353'ifrovanie:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object edtPort: TEdit
      Left = 327
      Top = 16
      Width = 137
      Height = 29
      NumbersOnly = True
      TabOrder = 0
      Text = 'Port'
    end
    object btnPripoj: TButton
      Left = 470
      Top = 18
      Width = 75
      Height = 25
      Caption = 'Pripoj'
      TabOrder = 1
      OnClick = btnPripojClick
    end
    object rbtServer: TRadioButton
      Left = 9
      Top = 54
      Width = 144
      Height = 17
      Caption = 'Ja som server'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 2
      OnClick = rbtServerClick
    end
    object rbtKlient: TRadioButton
      Left = 9
      Top = 84
      Width = 136
      Height = 17
      Caption = 'Ja som klient'
      Checked = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 3
      TabStop = True
      OnClick = rbtKlientClick
    end
    object edtHeslo: TEdit
      Left = 360
      Top = 77
      Width = 177
      Height = 29
      TabOrder = 4
      Text = 'HelloWorld'
    end
    object medIPAdresa: TMaskEdit
      Left = 50
      Top = 16
      Width = 174
      Height = 29
      EditMask = '!099.099.099.099;'
      MaxLength = 15
      TabOrder = 5
      Text = '   .   .   .   '
    end
  end
  object tcpKlient: TIdTCPClient
    ConnectTimeout = 0
    Port = 0
    ReadTimeout = -1
    Left = 424
    Top = 120
  end
  object tcpServer: TIdTCPServer
    Bindings = <>
    DefaultPort = 0
    OnExecute = tcpServerExecute
    Left = 368
    Top = 120
  end
  object tmrCasovac: TTimer
    Enabled = False
    Interval = 100
    OnTimer = tmrCasovacTimer
    Left = 320
    Top = 120
  end
end
