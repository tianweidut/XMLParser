program XMLSigRunNew;

uses
  Forms,
  xmlSigRun in 'xmlSigRun.pas' {sigRun},
  DBOperator in 'DBOperator.pas',
  xmlRecord in 'xmlRecord.pas',
  dataModuleSig in 'dataModuleSig.pas' {DataModule1: TDataModule},
  xmlSigThread in 'xmlSigThread.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TsigRun, sigRun);
  Application.CreateForm(TDataModule1, DataModule1);
  Application.Run;
end.
