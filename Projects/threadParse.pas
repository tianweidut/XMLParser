unit threadParse;
//多线程类：调用处理进程，产生相应的处理
//进程执行时挂起线程，线程执行完毕发射完成信号，
//改变线程数量变量，减少多少个就重启多少个线程

interface

uses Classes, Graphics, ExtCtrls,ShellAPI, Windows, Messages, SysUtils, Variants,  Controls, Forms,
  Dialogs, StdCtrls;

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
 ShExecInfo:SHELLEXECUTEINFO;
 tmp:Boolean;
begin
  NameThreadForDebugging(AnsiString(ClassName));
  cmd := '';
  for I := 0 to fileCnt - 1 do
  begin
     if fileName[I] = '' then
     begin
       Continue;
     end;
     cmd := cmd + fileName[I] + ' ';
  end;

  //启动命令行，传递参数
   FillChar(ShExecInfo,SizeOf(ShExecInfo),0);
   ShExecInfo.cbSize  :=  sizeof(ShExecInfo);
   ShExecInfo.fMask   :=  SEE_MASK_NOCLOSEPROCESS;
   ShExecInfo.lpVerb  :=  nil;
   ShExecInfo.lpFile  :=  PChar('XMLSigRunNew.exe');
   ShExecInfo.lpParameters  :=  PChar(cmd);
   ShExecInfo.lpDirectory   :=  nil;
   ShExecInfo.nShow   :=  SW_SHOW;
   ShExecInfo.Wnd     :=  Application.Handle;
   tmp := ShellExecuteEx(@ShExecInfo);
   if tmp then
   begin
     WaitForSingleObject(ShExecInfo.hProcess,INFINITE);
   end;
  //ShellExecute(0,PChar('open'),PChar('XMLSigRunNew.exe'), Pchar(cmd),nil,1);
end;

end.
