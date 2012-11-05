unit threadParse;
//���߳��ࣺ���ô�����̣�������Ӧ�Ĵ���
//����ִ��ʱ�����̣߳��߳�ִ����Ϸ�������źţ�
//�ı��߳��������������ٶ��ٸ����������ٸ��߳�

interface

uses Classes, Graphics, ExtCtrls,ShellAPI, Windows, Messages, SysUtils, Variants,  Controls, Forms,
  Dialogs, StdCtrls;

type
  TThreadParse = class(TThread)
    private
      fileName:array of string;      //�ļ�������
      fileCnt:Integer;               //�ļ�����
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

  //���������У����ݲ���
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
