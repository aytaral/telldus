program TelldusDataLogger;

uses
  FMX.Forms,
  tdMain in 'tdMain.pas' {frmTelldus},
  tdData in 'tdData.pas' {dmData: TDataModule},
  tdTelldus in 'tdTelldus.pas',
  tdSettings in 'tdSettings.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmTelldus, frmTelldus);
  Application.CreateForm(TdmData, dmData);
  Application.Run;
end.
