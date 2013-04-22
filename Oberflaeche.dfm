object Form1: TForm1
  Left = 101
  Top = 40
  Width = 997
  Height = 690
  HorzScrollBar.Visible = False
  Caption = 'Primzahlenspiel'
  Color = clWindow
  Constraints.MinHeight = 600
  Constraints.MinWidth = 800
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -19
  Font.Name = 'Lucida Console'
  Font.Style = [fsBold]
  Icon.Data = {
    0000010001002020100000000000E80200001600000028000000200000004000
    0000010004000000000080020000000000000000000000000000000000000000
    000000008000008000000080800080000000800080008080000080808000C0C0
    C0000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF000000
    0000000000999900000000000000000000000099999999999900000000000000
    0000999999999999900000000000000000099999999999900999000000000000
    099999999999999099099090000000009999FFF9999999099090990900000000
    9999FFF9999999099999990900000009999FFFF9999999099090990990000099
    999FFFF9999999909999909999000099999FFFF9999999900999009999000999
    999FFFF9999999999000999999900999999FFFF9999999999999999999900999
    999FFFF9999999999999999999909999999FFFF9999999999999999999999999
    999FFFFFFFFFFF999999999999999999999FFFFFFFFFFFFF9999999999999999
    999FFFFFFFFFFFFF9999999999999999999FFFFFFFFFFFFFF999999999999999
    999FFFFFFF9FFFFFF999999999990999999FFFFF9999FFFFF999999999900999
    999FFFF999999FFFF999999999900999999FFFFF9999FFFFF999999999900099
    999FFFFFFF9FFFFFF999999999000099999FFFFFFFFFFFFF9999999999000009
    999FFFFFFFFFFFFF99999999900000009999FFFFFFFFFF999999999900000000
    9999999999999999999999990000000009999999999999999999999000000000
    0009999999999999999990000000000000009999999999999999000000000000
    000000999999999999000000000000000000000000999900000000000000FFFC
    3FFFFFC003FFFF0007FFFE0018FFF800125FF0E0252FF0E0202FE1E02527C1E0
    1043C1E018C381E0070181E0000181E0000101E0000001FFC00001FFF00001FF
    F00001FFF80001FDF80081F0F80181E0780181F0F801C1FDF803C1FFF003E1FF
    F007F0FFC00FF000000FF800001FFE00007FFF0000FFFFC003FFFFFC3FFF}
  OldCreateOrder = False
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  OnKeyUp = FormKeyUp
  PixelsPerInch = 96
  TextHeight = 19
  object Image1: TImage
    Left = 0
    Top = 0
    Width = 981
    Height = 654
    Align = alClient
    AutoSize = True
  end
  object primzahlentest: TGroupBox
    Left = -1
    Top = 532
    Width = 281
    Height = 124
    Anchors = [akLeft, akBottom]
    Caption = 'primzahlentest'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 0
    Visible = False
    object Label1: TLabel
      Left = 8
      Top = 40
      Width = 5
      Height = 22
    end
    object SpinEdit1: TSpinEdit
      Left = 8
      Top = 24
      Width = 89
      Height = 32
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -19
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      MaxValue = 0
      MinValue = 0
      ParentFont = False
      TabOrder = 0
      Value = 0
    end
    object Button1: TButton
      Left = 104
      Top = 24
      Width = 25
      Height = 25
      Caption = '+'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -19
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 1
      OnClick = Button1Click
    end
    object Button2: TButton
      Left = 136
      Top = 24
      Width = 97
      Height = 25
      Caption = 'teiler:'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -19
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 2
      OnClick = Button2Click
    end
    object SpinEdit2: TSpinEdit
      Left = 240
      Top = 24
      Width = 33
      Height = 32
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -19
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      MaxValue = 0
      MinValue = 0
      ParentFont = False
      TabOrder = 3
      Value = 0
    end
  end
  object cbpause: TCheckBox
    Left = 868
    Top = 0
    Width = 121
    Height = 33
    Anchors = [akTop, akRight]
    Caption = 'Pause'
    Checked = True
    Enabled = False
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    State = cbChecked
    TabOrder = 1
    OnClick = cbpauseClick
    OnKeyDown = FormKeyDown
    OnKeyUp = FormKeyUp
  end
  object gbsteuerung: TGroupBox
    Left = 700
    Top = 192
    Width = 281
    Height = 113
    Anchors = [akTop, akRight]
    Caption = 'Steuerung'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 2
    object spielernummernlabel: TLabel
      Left = 8
      Top = 24
      Width = 72
      Height = 22
      Caption = 'Spieler:'
    end
    object Label3: TLabel
      Left = 120
      Top = 24
      Width = 17
      Height = 22
      Caption = '<-'
    end
    object Label4: TLabel
      Left = 152
      Top = 24
      Width = 17
      Height = 22
      Caption = '->'
    end
    object Label5: TLabel
      Left = 64
      Top = 48
      Width = 44
      Height = 22
      Caption = 'links'
    end
    object Label6: TLabel
      Left = 184
      Top = 48
      Width = 59
      Height = 22
      Caption = 'rechts'
    end
    object farbenlabel: TLabel
      Left = 200
      Top = 24
      Width = 65
      Height = 22
      AutoSize = False
    end
    object linksknopf: TButton
      Left = 120
      Top = 48
      Width = 17
      Height = 17
      TabOrder = 0
      OnKeyDown = linksknopfKeyDown
    end
    object rechtsknopf: TButton
      Left = 152
      Top = 48
      Width = 17
      Height = 17
      TabOrder = 1
      OnKeyDown = rechtsknopfKeyDown
    end
    object Button5: TButton
      Left = 8
      Top = 80
      Width = 105
      Height = 25
      Caption = 'Zum Spiel'
      TabOrder = 2
      OnClick = Button5Click
    end
    object Button6: TButton
      Left = 144
      Top = 80
      Width = 129
      Height = 25
      Caption = 'hinzufügen'
      TabOrder = 3
      OnClick = Button6Click
    end
  end
  object gbeinstellungen: TGroupBox
    Left = 700
    Top = 24
    Width = 281
    Height = 169
    Anchors = [akTop, akRight]
    Caption = 'Einstellungen'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 3
    object Label2: TLabel
      Left = 64
      Top = 96
      Width = 77
      Height = 22
      Caption = 'Zeitspiel'
    end
    object Label7: TLabel
      Left = 64
      Top = 128
      Width = 74
      Height = 22
      Caption = 'Bis Zahl'
    end
    object cbleicht: TRadioButton
      Left = 8
      Top = 40
      Width = 121
      Height = 17
      Caption = 'leicht'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -19
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 0
      OnClick = cbuebenClick
    end
    object cbmittel: TRadioButton
      Left = 8
      Top = 56
      Width = 121
      Height = 17
      Caption = 'mittel'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -19
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 1
      OnClick = cbuebenClick
    end
    object cbschwer: TRadioButton
      Left = 8
      Top = 72
      Width = 121
      Height = 17
      Caption = 'schwer'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -19
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 2
      OnClick = cbuebenClick
    end
    object cbirre: TRadioButton
      Left = 144
      Top = 24
      Width = 121
      Height = 17
      Caption = 'irre'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -19
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 3
      OnClick = cbuebenClick
    end
    object cbueben: TRadioButton
      Left = 8
      Top = 24
      Width = 121
      Height = 17
      Caption = 'üben'
      Checked = True
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -19
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 4
      TabStop = True
      OnClick = cbuebenClick
    end
    object cbirreirre: TRadioButton
      Left = 144
      Top = 40
      Width = 121
      Height = 17
      Caption = 'irre irre'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -19
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 5
      OnClick = cbuebenClick
    end
    object schluss: TSpinEdit
      Left = 144
      Top = 96
      Width = 121
      Height = 32
      Increment = 60
      MaxValue = 0
      MinValue = 0
      TabOrder = 6
      Value = 0
    end
    object maxzahl: TSpinEdit
      Left = 144
      Top = 128
      Width = 121
      Height = 32
      Increment = 100
      MaxValue = 100
      MinValue = 100
      TabOrder = 7
      Value = 0
    end
    object cbzufallsende: TCheckBox
      Left = 144
      Top = 64
      Width = 129
      Height = 17
      Caption = 'Zufallsende'
      Checked = True
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -19
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      State = cbChecked
      TabOrder = 8
    end
  end
  object gbgewonnen: TGroupBox
    Left = 232
    Top = 216
    Width = 247
    Height = 169
    BiDiMode = bdRightToLeftNoAlign
    Caption = 'Spiel gewonnen!'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentBiDiMode = False
    ParentFont = False
    TabOrder = 4
    Visible = False
    object Label15: TLabel
      Left = 8
      Top = 24
      Width = 179
      Height = 16
      Caption = 'Die Zeit ist abgelaufen oder '
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label16: TLabel
      Left = 8
      Top = 40
      Width = 232
      Height = 16
      Caption = 'die gewünschte Zahl wurde erreicht.'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label17: TLabel
      Left = 8
      Top = 64
      Width = 196
      Height = 16
      Caption = 'Das Spiel kann aber mit neuen'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label18: TLabel
      Left = 8
      Top = 80
      Width = 191
      Height = 16
      Caption = 'Werten weitergeführt werden.'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label19: TLabel
      Left = 8
      Top = 104
      Width = 64
      Height = 19
      Caption = 'Zeitspiel'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -17
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label20: TLabel
      Left = 8
      Top = 136
      Width = 62
      Height = 19
      Caption = 'Bis Zahl'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -17
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object seschlussgewonnen: TSpinEdit
      Left = 88
      Top = 96
      Width = 121
      Height = 32
      Increment = 60
      MaxValue = 0
      MinValue = 0
      TabOrder = 0
      Value = 0
    end
    object semaxzahlgewonnen: TSpinEdit
      Left = 88
      Top = 128
      Width = 121
      Height = 32
      Increment = 100
      MaxValue = 100
      MinValue = 100
      TabOrder = 1
      Value = 0
    end
    object bugewonnenok: TButton
      Left = 208
      Top = 104
      Width = 33
      Height = 49
      Caption = 'OK'
      TabOrder = 2
      OnClick = bugewonnenokClick
    end
  end
  object meersteHilfe: TMemo
    Left = 8
    Top = 8
    Width = 688
    Height = 635
    Anchors = [akLeft, akTop, akRight, akBottom]
    Enabled = False
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    Lines.Strings = (
      'Hilfe!!'
      ''
      'Oben rechts ist der Knopf für PAUSE.'
      
        'Während des Spiels ist er markiert und kann für gewöhnlich mit L' +
        'eertaste oder Maus ausgelöst werden.'
      ''
      'EINSTELLEN kann man den Schwierigkeitsgrad:'
      
        '<üben>, <leicht>, <mittel>, <schwer>, <irre> (sehr schwer), <irr' +
        'e irre> (doppelt schwer).'
      
        'ZEITSPIEL ist eingestellt, wenn die Zahl dahinter größer als 0 i' +
        'st.'
      'Dann wird bis zur eingegebenen Sekundenzahl gespielt.'
      'Oder bis zu einer bestimmten ZAHL, wenn diese auch größer 0 ist.'
      ''
      'ZUFALLSENDE verschiebt das Ende ein wenig nach vorn oder hinten.'
      ''
      
        'Um die STEUERUNG festzulegen muss ein leerer quadratischer Knopf' +
        ' angeklickt sein.'
      
        'Beim drücken einer Taste erscheint die im Knopf. Die Taste ist d' +
        'ann registriert und steuert ihren Schieber '
      'nach links bzw. nach rechts.'
      'Automatisch wird zum nächsten Knopf gesprungen.'
      'Das Viereck rechts darüber hat die Farbe des Spielers.'
      
        'Klick (oder Leertaste) >hinzufügen< und das Ganze für einen neue' +
        'n Spieler.'
      ''
      'Bevor das Spiel startet:'
      'Rechts erscheint neben dem Runden Spielfeld eine Statistik.'
      
        'X - Spielernummer, P - Punkte, Ges. - Zahlen gesamt, Prim - gesa' +
        'mmelte Primzahlen, Bewertung'
      ''
      
        'ZIEL des Spiels ist, so viele und hohe Primzahen zu sammeln, wie' +
        ' nur möglich.'
      
        'Gerät eine Primzahl hinter ihren Schieber, so kommt sie zur Punk' +
        'tzahl.'
      'Ist es keine Primzahl, wird ihr Wert abgezogen.'
      ''
      '')
    ParentFont = False
    TabOrder = 5
  end
  object Timer1: TTimer
    Interval = 10
    OnTimer = Timer1Timer
    Left = 88
    Top = 8
  end
end
