unit xmlMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, ADODB,DBOperatorMain, Grids, DBGrids, bsSkinCtrls,
  bsSkinBoxCtrls, ComCtrls, StdCtrls, ExtCtrls;

type
  TxmlMainFrm = class(TForm)
    conDB: TADOConnection;
    pnl3: TPanel;
    pnl5: TPanel;
    mmodbg: TMemo;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    commonFile:TCommonOperator;

    procedure openDB();

  public
    { Public declarations }
  end;

var
  xmlMainFrm: TxmlMainFrm;


implementation
uses dataModuleMain;
{$R *.dfm}


procedure TxmlMainFrm.FormCreate(Sender: TObject);
begin
      //开启数据库
     openDB();
end;

procedure TxmlMainFrm.openDB();                                      //打开数据库
var
  sql:string;
begin
     //
     commonFile :=TCommonOperator.Create;
     commonFile.OperatorDS :=@DataModuleTestMain.ds1;     //设置数据集
     commonFile.TableDesc := '文件信息表';
     commonFile.TableName :='finishFile';
     commonFile.PrimaryFieldName :='filename';                        //设置主键

     commonFile.Open;
end;


end.
