unit dataModuleSig;

interface

uses
  SysUtils, Classes, DB, ADODB;

type
  TDataModule1 = class(TDataModule)
    ds1: TADODataSet;
    dsfinishfile: TDataSource;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DataModule1: TDataModule1;

implementation
uses xmlSigRun;
{$R *.dfm}

end.
