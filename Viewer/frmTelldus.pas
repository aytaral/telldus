unit frmTelldus;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, VclTee.TeeGDIPlus,
  VCLTee.TeEngine, VCLTee.DBChart, VCLTee.TeeDBCrossTab, VCLTee.TeeData,
  Data.DB, VCLTee.Series, Vcl.ExtCtrls, VCLTee.TeeProcs, VCLTee.Chart;

type
  TForm1 = class(TForm)
    Chart1: TChart;
    Series1: TAreaSeries;
    SeriesDataSet1: TSeriesDataSet;
    SeriesDataSet1Color: TIntegerField;
    SeriesDataSet1X: TFloatField;
    SeriesDataSet1Y: TFloatField;
    SeriesDataSet1Label: TStringField;
    ChartDataSet1: TChartDataSet;
    DBCrossTabSource1: TDBCrossTabSource;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

end.
