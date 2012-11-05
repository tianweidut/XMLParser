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
    listCnt:Integer;            //名称列表计数
    listSum:Integer;            //实际处理名称总数
    MyThread: TRTLCriticalSection;
    procedure ThreadDone(Sender: TObject);
    procedure openDB();
    procedure threadRun();
    function  checkFileName(Filename:string):Boolean;        //在数据库中检测文件是否存在
  public
    { Public declarations }
  end;

var
  xmlMainFrm: TxmlMainFrm;
  cntSum:Integer=6;           //每个线程执行的文件数量
  threadNum:Integer=24;        //最多运行的线程数量
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
     commonFile.OperatorDS :=@DataModuleTestMain.ds1;     //设置数据集
     commonFile.TableDesc := '文件信息表';
     commonFile.TableName :='finishFile';
     commonFile.PrimaryFieldName :='filename';                        //设置主键
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
     //此处批量载入文件，将载入的文件写入列表中
     lstFileName.Clear;
     //批量文件选入
     if dlgOpen1.Execute then
     begin
       for I := 0 to dlgOpen1.Files.Count - 1 do    // Iterate
         begin
            lstFileName.Items.Add(dlgOpen1.Files[i]);
         end;    // for
     end;
     mmodbg.Lines.Append('此次载入:'+inttostr(dlgOpen1.Files.Count)+'个文件');

     btnLoadFile.Caption := '再次载入文件...'
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
      //开启数据库
     openDB();
     //进行文件列表解析
     if lstFileName.Items.Count = 0 then
     begin
       ShowMessage('提示，请选择载入文件，批量导入文件！！！');
       btnLoadFileClick(Sender);
     end;

     //动态申请数组
     tmp :=  Trunc(((lstFileName.Items.Count)/(cntSum))+1);
     SetLength(dataArray,tmp);
     for I := 0 to High(dataArray) do
     begin
        SetLength(dataArray[I],cntSum);
     end;

     //step2:写记录
     cntx := 0;
     cnty := 0;
     cnt  := 0;
     for I:=0 to lstFileName.Items.Count-1 do//Iterate
     begin
       if   checkFileName(ExtractFileName(lstFileName.Items[i])) then
       begin
            //此处应该分割文件，加入不同的数组中，同时启动线程
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
     listSum := Trunc(((cnt)/(cntSum))+1);    //总线程数量或者是文件分组后筛选过后的数量
     //step 3: 启动多线程
     threadRun;

     mmodbg.Lines.Append('筛选后,总共有:'+inttostr(cnt)+'个文件');
end;

procedure TxmlMainFrm.threadRun();
var
  threadArr:array of TThreadParse;
  I:Integer;
begin
    //初始化临界区
    InitializeCriticalSection(MyThread);      //初始化临界区:注意临界区的使用需要初始化
    //根据名称列表，启动相应的多线程
    ThreadsRunning := threadNum;
    listCnt := 0;     //名称列表计数
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
  //进入临界区
  EnterCriticalSection(MyThread);
  try
    //临界区处理代码，观察线程变化
    Dec(ThreadsRunning);
    mmodbg.Lines.Add('某个线程执行完毕，当前数量：'+inttoStr(ThreadsRunning));
    if listCnt < listSum then
    begin
          threadArr := TThreadParse.Create(High(dataArray[listCnt])+1,dataArray[listCnt]);
          threadArr.OnTerminate := ThreadDone;
          listCnt := listCnt + 1;
          Inc(ThreadsRunning);
          mmodbg.Lines.Add('重新启动了线程:'+inttoStr(ThreadsRunning)+':'+inttoStr(listCnt)+'<'+inttoStr(listSum))
    end
    else
    begin
         mmodbg.Lines.Add('*_* 恭喜完成所有文件分析')
    end;
  finally
     LeaveCriticalSection(MyThread);
  end;
end;

procedure TxmlMainFrm.btnUpdateClick(Sender: TObject);
var
  sql:string;
begin
     //刷新数据库
     commonFile :=TCommonOperator.Create;
     commonFile.OperatorDS :=@DataModuleTestMain.ds1;     //设置数据集
     commonFile.TableDesc := '文件信息表';
     commonFile.TableName :='finishFile';
     commonFile.PrimaryFieldName :='filename';                        //设置主键
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

function  TxmlMainFrm.checkFileName(Filename:string):Boolean;        //在数据库中检测文件是否存在
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
  DeleteCriticalSection(MyThread);//删除临界界
end;

end.
