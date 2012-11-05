//数据库通用操作类：完成数据的增加，删除，修改，查询和保存操作。
//实现原理：通过指针传递要操作的数据集对象，然后调用类的方法进行实现对数据的处理
//具体实现：数据处理功能封装在类中，对类用户透明
unit DBOperatorMain;

interface
uses
    Forms,Windows,DB,ADODB;
type
    TCommonOperator =class(TObject)            //通用操作类声明
    public
          OperatorDS:^TADODataSet;
          TableDesc:String;
          TableName:String;
          SqlStr:String;                       //SQL语句
          PrimaryFieldName:String;
          PrimaryFieldValue:String;
          FilterStr:String;                   //过滤字符串
          procedure Insert;
          procedure Delete;
          procedure Save(isShowMessage:Boolean);     //保存修改记录
          procedure Open;                            //打开数据集
          Function  RecordCount:integer;             //计算数据集中记录数量
          function  ExecSql:Boolean;
          function  ExecSqlUpdate:Boolean;
          procedure Cancel;                          //取消修改操作
          Function GetFieldValue(FieldName:String):String;        //获取域值
          procedure FilterRecord;                       //根据过滤条件进行记录查询
          Function  RecordCountSql(sql:string):integer;
          Function  RecordValueSql(sql:string;Val:string):string;
          constructor Create;                           //构造函数
          destructor Destroy;                           //析构函数
    Private
           MesStr:String;                               //消息字符串
           Qry:TADOQuery;                               //查询对象

    end;
implementation
uses xmlMain;

{$DEFINE __DEBUG}                 //测试开关

//取消数据集操作:插入和编辑时取消操作
procedure TCommonOperator.Cancel;
begin
     if((OperatorDS.state = dsInsert)or(OperatorDS.state = dsEdit)) then
          OperatorDS.cancel;
end;

//构造函数，完成类的初始化
constructor  TCommonOperator.Create;
begin
     Qry := TADOQuery.Create(nil);     //TADOQuery 数据库查询组件
     Qry.connection := xmlMainFrm.conDB;         //对登录窗口的ADO连接进行指定
     Qry.ParamCheck := false;                   //防止SQL出现错误
end;

//产出记录，针对OperatorDS(TADODataSet)数据集进行操作
procedure TCommonOperator.Delete;
begin
     if ((not OperatorDS.Active )or(OperatorDS.RecordCount =0)) then
        Exit;
     MesStr := '是否确定删除'+TableDesc+'记录？';
     if Application.MessageBox(pchar(MesStr),'提示',MB_YESNO)=IDYES then
     try
        OperatorDS.delete;
        MesStr := '删除'+TableDesc+'记录成功！';
        Application.MessageBox(pChar(MesStr),'提示',MB_OK);
     except
        MesStr := '删除'+TableDesc+'记录失败！';
        Application.MessageBox(pChar(MesStr),'提示',MB_OK);
        Exit;
     end;
end;

//根据SQLStr语句执行，查询组件的SQL语句执行
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
        Application.MessageBox(pChar('数据错误,重启软件！！！'),'提示',MB_OK);
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
        Qry.close;      //关闭插叙组件
        Qry.SQL.Clear;  //清除语句
        Qry.SQL.Text := SqlStr;
        Qry.ExecSQL;
        ExecSqlUpdate:=true;             //此种用于不返回结果的
     except
        Application.MessageBox(pChar('数据错误，重启软件！！！'),'提示',MB_OK);
        ExecSqlUpdate:=false;
        //ExecSqlUpdate:=true;
     end;
end;


procedure  TCommonOperator.FilterRecord;
begin
     if FilterStr = '' then
     Exit;
     OperatorDS.close;         //数据集操作
{$IFDEF __DEBUG}
     Application.MessageBox(pChar(FilterStr),'提示',MB_OK);
{$ENDIF}
     OperatorDS.CommandText := 'select * from '+TableName+' where '+FilterStr;       //字符串书写时，需要注意空格 符合SQL语法
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
    OperatorDS.Close;                 //关闭数据对象
    if PrimaryFieldName = '' then
    	OperatorDS.CommandText := 'Select * from '+TableName       //设置查询字符串 //设置查询字符串 ,注意此处没有；结尾
    else
      OperatorDS.CommandText := 'Select * from '+TableName+' where '+PrimaryFieldName+'='''+PrimaryFieldValue+'''';          //根据关键值检索
    OperatorDS.Open;                  //打开数据对象                            
  except
    MesStr := '打开'+TableDesc+'失败！';
    Application.MessageBox(pChar(MesStr),'提示',MB_OK);
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
    	MesStr := '保存'+TableDesc+'成功！';
    	Application.MessageBox(pChar(MesStr),'提示',MB_OK);
    end;
  except
    if isShowMessage then
    begin
    	MesStr := '保存'+TableDesc+'失败！';
    	Application.MessageBox(pChar(MesStr),'提示',MB_OK);
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
