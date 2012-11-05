//���ݿ�ͨ�ò����ࣺ������ݵ����ӣ�ɾ�����޸ģ���ѯ�ͱ��������
//ʵ��ԭ��ͨ��ָ�봫��Ҫ���������ݼ�����Ȼ�������ķ�������ʵ�ֶ����ݵĴ���
//����ʵ�֣����ݴ����ܷ�װ�����У������û�͸��
unit DBOperatorMain;

interface
uses
    Forms,Windows,DB,ADODB;
type
    TCommonOperator =class(TObject)            //ͨ�ò���������
    public
          OperatorDS:^TADODataSet;
          TableDesc:String;
          TableName:String;
          SqlStr:String;                       //SQL���
          PrimaryFieldName:String;
          PrimaryFieldValue:String;
          FilterStr:String;                   //�����ַ���
          procedure Insert;
          procedure Delete;
          procedure Save(isShowMessage:Boolean);     //�����޸ļ�¼
          procedure Open;                            //�����ݼ�
          Function  RecordCount:integer;             //�������ݼ��м�¼����
          function  ExecSql:Boolean;
          function  ExecSqlUpdate:Boolean;
          procedure Cancel;                          //ȡ���޸Ĳ���
          Function GetFieldValue(FieldName:String):String;        //��ȡ��ֵ
          procedure FilterRecord;                       //���ݹ����������м�¼��ѯ
          Function  RecordCountSql(sql:string):integer;
          Function  RecordValueSql(sql:string;Val:string):string;
          constructor Create;                           //���캯��
          destructor Destroy;                           //��������
    Private
           MesStr:String;                               //��Ϣ�ַ���
           Qry:TADOQuery;                               //��ѯ����

    end;
implementation
uses xmlMain;

{$DEFINE __DEBUG}                 //���Կ���

//ȡ�����ݼ�����:����ͱ༭ʱȡ������
procedure TCommonOperator.Cancel;
begin
     if((OperatorDS.state = dsInsert)or(OperatorDS.state = dsEdit)) then
          OperatorDS.cancel;
end;

//���캯���������ĳ�ʼ��
constructor  TCommonOperator.Create;
begin
     Qry := TADOQuery.Create(nil);     //TADOQuery ���ݿ��ѯ���
     Qry.connection := xmlMainFrm.conDB;         //�Ե�¼���ڵ�ADO���ӽ���ָ��
     Qry.ParamCheck := false;                   //��ֹSQL���ִ���
end;

//������¼�����OperatorDS(TADODataSet)���ݼ����в���
procedure TCommonOperator.Delete;
begin
     if ((not OperatorDS.Active )or(OperatorDS.RecordCount =0)) then
        Exit;
     MesStr := '�Ƿ�ȷ��ɾ��'+TableDesc+'��¼��';
     if Application.MessageBox(pchar(MesStr),'��ʾ',MB_YESNO)=IDYES then
     try
        OperatorDS.delete;
        MesStr := 'ɾ��'+TableDesc+'��¼�ɹ���';
        Application.MessageBox(pChar(MesStr),'��ʾ',MB_OK);
     except
        MesStr := 'ɾ��'+TableDesc+'��¼ʧ�ܣ�';
        Application.MessageBox(pChar(MesStr),'��ʾ',MB_OK);
        Exit;
     end;
end;

//����SQLStr���ִ�У���ѯ�����SQL���ִ��
function  TCommonOperator.ExecSql:Boolean;
begin
     if SqlStr = '' then
        begin
           ExecSql:=false;
           exit;
        end;
     try
        OperatorDS.Close;
        OperatorDS.CommandText := SqlStr;
        OperatorDS.ExecuteOptions;
        OperatorDS.Open;
        ExecSql:=true;
     except
        Application.MessageBox(pChar('���ݴ���,�������������'),'��ʾ',MB_OK);
        ExecSql:=false;
        //ExecSql:=true;
     end;
end;

function  TCommonOperator.ExecSqlUpdate:Boolean;
begin
     if SqlStr = '' then
        begin
           ExecSqlUpdate:=false;
           exit;
        end;
     try
        Qry.close;      //�رղ������
        Qry.SQL.Clear;  //������
        Qry.SQL.Text := SqlStr;
        Qry.ExecSQL;
        ExecSqlUpdate:=true;             //�������ڲ����ؽ����
     except
        Application.MessageBox(pChar('���ݴ����������������'),'��ʾ',MB_OK);
        ExecSqlUpdate:=false;
        //ExecSqlUpdate:=true;
     end;
end;


procedure  TCommonOperator.FilterRecord;
begin
     if FilterStr = '' then
     Exit;
     OperatorDS.close;         //���ݼ�����
{$IFDEF __DEBUG}
     Application.MessageBox(pChar(FilterStr),'��ʾ',MB_OK);
{$ENDIF}
     OperatorDS.CommandText := 'select * from '+TableName+' where '+FilterStr;       //�ַ�����дʱ����Ҫע��ո� ����SQL�﷨
     OperatorDS.open;
end;


Function TCommonOperator.GetFieldValue(FieldName:String):String;
begin
     if ((not OperatorDS.Active) or (OperatorDS.RecordCount = 0 )) then
  begin
  	GetFieldValue := '';
        Exit;
  end else
    GetFieldValue := OperatorDS.FieldByName(FieldName).AsString;
end;

procedure  TCommonOperator.Insert;
begin
     if ((OperatorDS.State = dsInsert) or
      (OperatorDS.State = dsEdit)) then Save(False);
	if not OperatorDS.Active then
  begin
  	OperatorDS.Close;
  	OperatorDS.CommandText := 'Select * from '+TableName+' where 1<>1 ';
    OperatorDS.Open;
    OperatorDS.Append;
  end else
    OperatorDS.Append;
end;

procedure TCommonOperator.open;
begin
	try
    OperatorDS.Close;                 //�ر����ݶ���
    if PrimaryFieldName = '' then
    	OperatorDS.CommandText := 'Select * from '+TableName       //���ò�ѯ�ַ��� //���ò�ѯ�ַ��� ,ע��˴�û�У���β
    else
      OperatorDS.CommandText := 'Select * from '+TableName+' where '+PrimaryFieldName+'='''+PrimaryFieldValue+'''';          //���ݹؼ�ֵ����
    OperatorDS.Open;                  //�����ݶ���                            
  except
    MesStr := '��'+TableDesc+'ʧ�ܣ�';
    Application.MessageBox(pChar(MesStr),'��ʾ',MB_OK);
  end;
end;

Function  TCommonOperator.RecordCount:integer;
begin
  if PrimaryFieldName = '' then
		Qry.SQL.Text := 'Select Count(*) from '+ TableName
  else
    Qry.SQL.Text := 'Select Count(*) from '+ TableName +' where '+PrimaryFieldName
                   +'='''+PrimaryFieldValue+'''';
  Qry.Open;
  RecordCount := Qry.Fields[0].AsInteger;
end;

Function  TCommonOperator.RecordCountSql(sql:string):integer;
begin
    Qry.SQL.Text := sql;
    Qry.Open;
    RecordCountSql := Qry.Fields[0].AsInteger;
end;

procedure TCommonOperator.Save(isShowMessage:Boolean);
begin
	if ((OperatorDS.State = dsInsert) or
  	  (OperatorDS.State = dsEdit)) then
  try
  	if PrimaryFieldName<>'' then
      OperatorDS.FieldByName(PrimaryFieldName).AsString := PrimaryFieldValue;
    OperatorDS.Post;
    if isShowMessage then
    begin
    	MesStr := '����'+TableDesc+'�ɹ���';
    	Application.MessageBox(pChar(MesStr),'��ʾ',MB_OK);
    end;
  except
    if isShowMessage then
    begin
    	MesStr := '����'+TableDesc+'ʧ�ܣ�';
    	Application.MessageBox(pChar(MesStr),'��ʾ',MB_OK);
    end;
  end;
end;

destructor TCommonOperator.Destroy;
begin
     Qry.Free;
end;

Function  TCommonOperator.RecordValueSql(sql:string;Val:string):string;
var
  rst:string;
begin
    rst:='';
    Qry.SQL.Text := sql;
    Qry.Open;
    Qry.First;
    if Qry.FieldByName(Val).IsNull then
    begin
      RecordValueSql := '_tianwei_NULL';
    end else
    begin
      RecordValueSql := Qry.FieldValues[Val];
    end;  

end;

end.
