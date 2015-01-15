program Telldus;

uses
  Vcl.Forms,
  frmTelldus in 'frmTelldus.pas' {Form1},
  Vcl.Themes,
  Vcl.Styles,
  dmData in 'dmData.pas' {DataModule1: TDataModule};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  TStyleManager.TrySetStyle('Glossy');
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TDataModule1, DataModule1);
  Application.Run;
end.
