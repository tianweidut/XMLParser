program XMLMainProject;

uses
  Forms,
  xmlMain in 'xmlMain.pas' {xmlMainFrm},
  DBOperatorMain in 'DBOperatorMain.pas',
  dataModuleMain in 'dataModuleMain.pas' {DataModuleMain2: TDataModule},
  threadParse in 'threadParse.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TxmlMainFrm, xmlMainFrm);
  Application.CreateForm(TDataModuleMain2, DataModuleTestMain);
  Application.Run;
end.
