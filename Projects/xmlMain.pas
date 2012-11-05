unit xmlMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, ADODB,DBOperatorMain, Grids, DBGrids, bsSkinCtrls,
  bsSkinBoxCtrls, ComCtrls, StdCtrls, ExtCtrls,ShellAPI;

type
  TxmlMainFrm = class(TForm)
    conDB: TADOConnection;
    dlgOpen1: TOpenDialog;
    pnl3: TPanel;
    pnl5: TPanel;
    mmodbg: TMemo;
    pnl8: TPanel;
    spl3: TSplitter;
    pnl9: TPanel;
    pnl11: TPanel;
    lbl1: TLabel;
    btnLoadFile: TButton;
    btnClearDB: TButton;
    btnUpdate: TButton;
    pgc1: TPageControl;
    ts1: TTabSheet;
    lstFileName: TbsSkinListBox;
    btn1: TbsSkinButtonsBar;
    btnDown: TbsSkinButton;
    btnDel: TbsSkinButton;
    ts2: TTabSheet;
    dbgrdgrd1: TDBGrid;
    btnParse: TButton;
    btnUp: TbsSkinButton;
    procedure btnUpdateClick(Sender: TObject);
    procedure btnClearDBClick(Sender: TObject);
    procedure btn2Click(Sender: TObject);
    procedure btnDownClick(Sender: TObject);
    procedure btnDelClick(Sender: TObject);
    procedure btnLoadFileClick(Sender: TObject);
    procedure btnParseClick(Sender: TObject);
    procedure lstFileNameListBoxMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
    commonFile:TCommonOperator;
    ThreadsRunning: Integer;
    listCnt:Integer;            //�����б����
    listSum:Integer;            //ʵ�ʴ�����������
    MyThread: TRTLCriticalSection;
    procedure ThreadDone(Sender: TObject);
    procedure openDB();
    procedure threadRun();
    function  checkFileName(Filename:string):Boolean;        //�����ݿ��м���ļ��Ƿ����
  public
    { Public declarations }
  end;

var
  xmlMainFrm: TxmlMainFrm;
  cntSum:Integer=6;           //ÿ���߳�ִ�е��ļ�����
  threadNum:Integer=24;        //������е��߳�����
  dataArray:array   of   array   of   string;

implementation
uses dataModuleMain,threadParse;
{$R *.dfm}

procedure TxmlMainFrm.btn2Click(Sender: TObject);
begin
     lstFileName.Items.Move(lstFileName.ItemIndex,lstFileName.ItemIndex-1);
     btnUp.Enabled := false;
     btnDown.Enabled := False;
end;

procedure TxmlMainFrm.btnClearDBClick(Sender: TObject);
var
  sql:string;
begin
     commonFile :=TCommonOperator.Create;
     commonFile.OperatorDS :=@DataModuleTestMain.ds1;     //�������ݼ�
     commonFile.TableDesc := '�ļ���Ϣ��';
     commonFile.TableName :='finishFile';
     commonFile.PrimaryFieldName :='filename';                        //��������
     commonFile.Open;

     sql := 'delete from finishFile';
     commonFile.SqlStr := sql;
     commonFile.ExecSqlUpdate;
end;

procedure TxmlMainFrm.btnDelClick(Sender: TObject);
begin
     lstFileName.Items.Delete(lstFileName.ItemIndex);

     btnUp.Enabled := False;
     btnDown.Enabled := false;
end;

procedure TxmlMainFrm.btnDownClick(Sender: TObject);
begin
     lstFileName.Items.Move(lstFileName.ItemIndex,lstFileName.ItemIndex+1);
     btnUp.Enabled := false;
     btnDown.Enabled := False;
end;

procedure TxmlMainFrm.btnLoadFileClick(Sender: TObject);
var
  I:Integer;
begin
     //�˴����������ļ�����������ļ�д���б���
     lstFileName.Clear;
     //�����ļ�ѡ��
     if dlgOpen1.Execute then
     begin
       for I := 0 to dlgOpen1.Files.Count - 1 do    // Iterate
         begin
            lstFileName.Items.Add(dlgOpen1.Files[i]);
         end;    // for
     end;
     mmodbg.Lines.Append('�˴�����:'+inttostr(dlgOpen1.Files.Count)+'���ļ�');

     btnLoadFile.Caption := '�ٴ������ļ�...'
end;

procedure TxmlMainFrm.btnParseClick(Sender: TObject);
var
  I:Integer;
  cnt:Integer;
  storeFileName:string;
  cntx,cnty:Integer;
  tmp:Integer;
  str:string;
begin
      //�������ݿ�
     openDB();
     //�����ļ��б����
     if lstFileName.Items.Count = 0 then
     begin
       ShowMessage('��ʾ����ѡ�������ļ������������ļ�������');
       btnLoadFileClick(Sender);
     end;

     //��̬��������
     tmp :=  Trunc(((lstFileName.Items.Count)/(cntSum))+1);
     SetLength(dataArray,tmp);
     for I := 0 to High(dataArray) do
     begin
        SetLength(dataArray[I],cntSum);
     end;

     //step2:д��¼
     cntx := 0;
     cnty := 0;
     cnt  := 0;
     for I:=0 to lstFileName.Items.Count-1 do//Iterate
     begin
       if   checkFileName(ExtractFileName(lstFileName.Items[i])) then
       begin
            //�˴�Ӧ�÷ָ��ļ������벻ͬ�������У�ͬʱ�����߳�
            dataArray[cnty][cntx] := lstFileName.Items[i];
            cntx := cntx +1;
            if cntx = cntSum then
            begin
              cntx :=  0;
              cnty := cnty + 1;
            end;
            cnt := cnt + 1;
       end;
     end;//for
     listSum := Trunc(((cnt)/(cntSum))+1);    //���߳������������ļ������ɸѡ���������
     //step 3: �������߳�
     threadRun;

     mmodbg.Lines.Append('ɸѡ��,�ܹ���:'+inttostr(cnt)+'���ļ�');
end;

procedure TxmlMainFrm.threadRun();
var
  threadArr:array of TThreadParse;
  I:Integer;
begin
    //��ʼ���ٽ���
    InitializeCriticalSection(MyThread);      //��ʼ���ٽ���:ע���ٽ�����ʹ����Ҫ��ʼ��
    //���������б�������Ӧ�Ķ��߳�
    ThreadsRunning := threadNum;
    listCnt := 0;     //�����б����
    SetLength(threadArr,threadnum);
    for I := 0 to threadNum - 1 do
    begin
        if listCnt < listSum then
        begin
          listCnt := listCnt + 1;
          threadArr[I] := TThreadParse.Create(High(dataArray[I])+1,dataArray[I]);
          threadArr[I].OnTerminate := ThreadDone;
        end;
    end;

end;

procedure TxmlMainFrm.ThreadDone(Sender: TObject);
var
  threadArr:TThreadParse ;
begin
  //�����ٽ���
  EnterCriticalSection(MyThread);
  try
    //�ٽ���������룬�۲��̱߳仯
    Dec(ThreadsRunning);
    mmodbg.Lines.Add('ĳ���߳�ִ����ϣ���ǰ������'+inttoStr(ThreadsRunning));
    if listCnt < listSum then
    begin
          threadArr := TThreadParse.Create(High(dataArray[listCnt])+1,dataArray[listCnt]);
          threadArr.OnTerminate := ThreadDone;
          listCnt := listCnt + 1;
          Inc(ThreadsRunning);
          mmodbg.Lines.Add('�����������߳�:'+inttoStr(ThreadsRunning)+':'+inttoStr(listCnt)+'<'+inttoStr(listSum))
    end
    else
    begin
         mmodbg.Lines.Add('*_* ��ϲ��������ļ�����')
    end;
  finally
     LeaveCriticalSection(MyThread);
  end;
end;

procedure TxmlMainFrm.btnUpdateClick(Sender: TObject);
var
  sql:string;
begin
     //ˢ�����ݿ�
     commonFile :=TCommonOperator.Create;
     commonFile.OperatorDS :=@DataModuleTestMain.ds1;     //�������ݼ�
     commonFile.TableDesc := '�ļ���Ϣ��';
     commonFile.TableName :='finishFile';
     commonFile.PrimaryFieldName :='filename';                        //��������
     commonFile.Open;

     sql := 'select * from finishFile';
     commonFile.SqlStr := sql;
     commonFile.ExecSql;
end;

procedure TxmlMainFrm.lstFileNameListBoxMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
     btnUp.Enabled   := True;
     btnDown.Enabled := True;
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

function  TxmlMainFrm.checkFileName(Filename:string):Boolean;        //�����ݿ��м���ļ��Ƿ����
var
  sql:string;
begin
   sql := 'select count(*) from finishFile where filename = '+''''+ Filename + '''';
   //ShowMessage(sql);
   if  commonFile.RecordCountSql(sql) = 0  then
   begin
     Result := True;
   end
   else
   begin
     Result := False;
   end;
end;
procedure TxmlMainFrm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  dataArray := nil;
  DeleteCriticalSection(MyThread);//ɾ���ٽ��
end;

end.
