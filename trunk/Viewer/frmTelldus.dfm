object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Telldus'
  ClientHeight = 581
  ClientWidth = 990
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Chart1: TChart
    Left = 32
    Top = 28
    Width = 921
    Height = 545
    Title.Text.Strings = (
      'TChart')
    TabOrder = 0
    DefaultCanvas = 'TGDIPlusCanvas'
    ColorPaletteIndex = 7
    object Series1: TAreaSeries
      DataSource = DBCrossTabSource1
      AreaChartBrush.Color = clGray
      AreaChartBrush.BackColor = clDefault
      DrawArea = True
      Pointer.InflateMargins = True
      Pointer.Style = psRectangle
      Pointer.Visible = False
      XValues.Name = 'X'
      XValues.Order = loAscending
      YValues.Name = 'Y'
      YValues.Order = loNone
      Data = {0000000000}
    end
  end
  object SeriesDataSet1: TSeriesDataSet
    Series = Series1
    Left = 40
    Top = 16
    object SeriesDataSet1Color: TIntegerField
      FieldName = 'Color'
    end
    object SeriesDataSet1X: TFloatField
      FieldName = 'X'
    end
    object SeriesDataSet1Y: TFloatField
      FieldName = 'Y'
    end
    object SeriesDataSet1Label: TStringField
      FieldName = 'Label'
      Size = 128
    end
  end
  object ChartDataSet1: TChartDataSet
    Chart = Chart1
    Left = 376
    Top = 24
  end
  object DBCrossTabSource1: TDBCrossTabSource
    DataSet = ChartDataSet1
    Series = Series1
    Left = 160
    Top = 8
  end
end
