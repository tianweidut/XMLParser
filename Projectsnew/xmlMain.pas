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
      //�������ݿ�
     openDB();
end;

procedure TxmlMainFrm.openDB();                                      //�����ݿ�
var
  sql:string;
begin
     //
     commonFile :=TCommonOperator.Create;
     commonFile.OperatorDS :=@DataModuleTestMain.ds1;     //�������ݼ�
     commonFile.TableDesc := '�ļ���Ϣ��';
     commonFile.TableName :='finishFile';
     commonFile.PrimaryFieldName :='filename';                        //��������

     commonFile.Open;
end;


end.
