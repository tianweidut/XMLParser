unit threadParse;
//多线程类：调用处理进程，产生相应的处理
//进程执行时挂起线程，线程执行完毕发射完成信号，
//改变线程数量变量，减少多少个就重启多少个线程

interface

uses Classes, Graphics, ExtCtrls,ShellAPI;

type
  TThreadParse = class(TThread)
    private
      fileName:array of string;      //文件名数组
      fileCnt:Integer;               //文件个数
      cmd:string;
    protected
      procedure Execute; override;
    public
      constructor Create(cnt:Integer; var fname :array of string);
  end;

implementation

constructor  TThreadParse.Create(cnt: Integer; var fname: array of string);
var
  I:Integer;
begin
  fileCnt := cnt;
  SetLength(fileName,filecnt);

  for I := 0 to filecnt - 1 do
  begin
     fileName[i] := fname[I]
  end;

  FreeOnTerminate := True;
  inherited Create(False);
end;
procedure TThreadParse.Execute;
var
 I:Integer;
begin
  NameThreadForDebugging(AnsiString(ClassName));
  cmd := '';
  for I := 0 to fileCnt - 1 do
  begin
     if fileName[I] = '' then
     begin
       Continue;
     end;
     cmd := cmd + '''' + fileName[I]+''''+ ' ';
  end;

  //启动命令行，传递参数
  ShellExecute(0,PChar('open'),PChar('XMLSigRunNew.exe'), Pchar(cmd),nil,1)
end;

end.
