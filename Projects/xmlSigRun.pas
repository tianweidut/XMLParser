unit xmlSigRun;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, DB, ADODB,xmlRecord,NativeXml,DBOperator, ExtCtrls;

type
  TsigRun = class(TForm)
    mmoDebug: TMemo;
    conDB: TADOConnection;

    btn1: TButton;
    tmr: TTimer;                  //最终创建数据存储文件数量
    procedure tmrTimer(Sender: TObject);
    procedure btn1Click(Sender: TObject);
  private
    { Private declarations }
    procedure ThreadDone(Sender: TObject);
  public
    { Public declarations }
  end;
var
  sigRun:TsigRun;

implementation
uses dataModuleSig,xmlSigThread;
{$R *.dfm}

procedure TsigRun.tmrTimer(Sender: TObject);
var
   threadsig:TThreadParse;
begin
      tmr.Enabled := False;
      //窗口初始化创建时
      threadsig := TThreadParse.Create();
      threadsig.OnTerminate := ThreadDone;
end;

procedure TsigRun.btn1Click(Sender: TObject);
begin
     sigRun.Close;
end;

procedure TsigRun.ThreadDone(Sender: TObject);
begin
  mmoDebug.Lines.Add('所有程序处理完成');
  sigRun.Close;
end;
end.
