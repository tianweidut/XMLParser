unit dataModuleMain;

interface

uses
  SysUtils, Classes, DB, ADODB;

type
  TDataModuleMain2 = class(TDataModule)
    ds1: TADODataSet;
    dsfinishfile: TDataSource;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DataModuleTestMain: TDataModuleMain2;

implementation
uses xmlMain;
{$R *.dfm}

end.
