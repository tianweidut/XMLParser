unit xmlSigRun;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, DB, ADODB,xmlRecord,NativeXml,DBOperator;

type
  TsigRun = class(TForm)
    mmoDebug: TMemo;
    conDB: TADOConnection;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    commondoc:TCommonOperator;
    commonFile:TCommonOperator;
    FileInfo:fileInfoRecord;
    FieldEvery:FieldRecord;           //全局field变量
    docEvery:docRecord;               //全局doc变量
    file_tianwei:TextFile;            //数据存储文件流
    usedCnt:Integer;                  //最终创建数据存储文件数量

    procedure ParseElement(ANode:TXmlNode);             //对每条记录进行解析
    procedure savetianweiFile();                        //临时保存到txt文件中
    procedure saveDocRecord();                         //存储文档信息储到数据库中
    function  checkField(Instring:string):string;            //检测field对转义的字符进行处理
    procedure openDB();                                      //打开数据库
    function  checkFileName(Filename:string):Boolean;        //在数据库中检测文件是否存在
    procedure SavefileName(Filename:string;cnt:integer);                 //当成功后，将完成的文件写入数据库中
    procedure runSingleFile(filename:string);
    procedure BatchRun();                                 //批处理入口
  public
    { Public declarations }
  end;

var
  sigRun: TsigRun;

implementation
uses dataModuleSig;
{$R *.dfm}

procedure TsigRun.saveDocRecord();                         //存储文档信息储到数据库中
var
  sql:string;
begin
     {commondoc :=TCommonOperator.Create;
     commondoc.OperatorDS :=@DataModuleTest.ds1;     //设置数据集
     commondoc.TableDesc := '文件信息表';
     commondoc.TableName :='docInfomation';
     commondoc.PrimaryFieldName :='file_name';                        //设置主键

     commondoc.Open;
     sql := 'select * from docInfomation';
     commondoc.SqlStr := sql;
     commondoc.ExecSql; }
end;

function TsigRun.checkField(InString:string):string;
var
  tmp:string;
begin
     //对写入数据的字符进行转义处理
     //需要处理的方面：1.存入字符串’字符串    2.dtd处理(根据具体的说明文档进行)
     //tmp := StringReplace(Instring,'''','''''',[rfReplaceAll]);    //!!!此处可能不需要
     //空字符串处理
     tmp:= Instring;
     if tmp = '' then
      tmp := ' ';

     Result := tmp;
end;

procedure TsigRun.savetianweiFile();
var
  sql :string;
begin
     //将每一条记录写入txt文本中
     with fieldEvery do
       begin
     sql :=   checkField(FieldId)+'|'+
              checkField(country)+'|'+ checkField(doc_number)+'|'+ checkField(kind)+'|'+checkField(date_publ)+'|'+checkField(family_id)+'|'+ checkField(is_representative)+'|'+checkField(date_of_last_exchange)+'|'+checkField(date_added_docdb)+'|'+checkField(originating_office)+'|'+
              checkField(date_of_previous_exchange)+'|'+ checkField(status)+'|'+
              checkField(publication_reference_data_format)+'|'+checkField(publication_reference_country)+'|'+checkField(publication_reference_doc_number)+'|'+ checkField(publication_reference_kind)+'|'+ checkField(publication_reference_date)+'|'+
              checkField(publication_reference_doc_lang)+'|'+checkField(previously_filed_app_text)+'|'+checkField(preceding_publication_date)+'|'+checkField(date_of_coming_into_force_date)+'|'+checkField(extended_kind_code_data_format)+'|'+checkField(extended_kind_code)+'|'+
              checkField(classification_ipc_text)+'|'+checkField(classification_ipc_edition)+'|'+ checkField(classification_ipc_main_class)+'|'+ checkField(classification_ipc_further_class)+'|'+checkField(classification_ipc_additional_info)+'|'+ checkField(classification_ipc_unlinked_indexing_code)+'|'+checkField(classification_ipc_linked_indexing_code_group_main)+'|'+checkField(classification_ipc_linked_indexing_code_group_sub)+'|'+
              checkField(classifications_ipcr_num)+'|'+checkField(classifications_ipcr_text)+'|'+checkField(classification_national_text)+'|'+
              checkField(classification_ecla)+'|'+checkField(application_reference_is)+'|'+checkField(application_reference_data_format)+'|'+checkField(application_reference_country)+'|'+checkField(application_reference_doc_number)+'|'+checkField(application_reference_kind)+'|'+checkField(application_reference_date)+'|'+
              checkField(application_reference_doc_lang)+'|'+checkField(application_reference_doc_id)+'|'+checkField(application_reference_status)+'|'+checkField(language_of_filing_statue)+'|'+checkField(language_of_filing_text)+'|'+checkField(language_of_publication_status)+'|'+checkField(language_of_publication_text)+'|'+
              checkField(priority_claims_sequence)+'|'+checkField(priority_claims_data_format)+'|'+checkField(priority_claims_country)+'|'+checkField(priority_claims_doc_number)+'|'+checkField(priority_claims_kind)+'|'+checkField(priority_claims_date)+'|'+checkField(priority_claims_active_indicator)+'|'+
              checkField(priority_claims_status)+'|'+checkField(priority_claims_doc_lang)+'|'+
              checkField(patries_applicants_sequence)+'|'+checkField(patries_applicants_data_format)+'|'+checkField(patries_applicants_name)+'|'+checkField(patries_applicants_country)+'|'+checkField(patries_applicants_address)+'|'+
              checkField(patries_inventors_sequence)+'|'+checkField(patries_inventors_data_format)+'|'+checkField(patries_inventors_name)+'|'+checkField(patries_inventors_address)+'|'+
              checkField(patries_applicants_status)+'|'+checkField(patries_applicants_name_data_format)+'|'+checkField(patries_inventors_status)+'|'+
              checkField(designation_of_states_EPC_contracting_states_country)+'|'+checkField(designation_of_states_EPC_extension_states_country)+'|'+checkField(designation_of_states_PCT_regional_country)+'|'+checkField(designation_of_states_PCT_countrys)+'|'+checkField(designation_of_states_PCT_national_country)+'|'+checkField(designation_of_states_contracting_states_country)+'|'+
              checkField(invention_title_lang)+'|'+checkField(invention_title_data_format)+'|'+checkField(invention_title_text)+'|'+
              checkField(invention_title_status)+'|'+
              checkField(dates_of_public_availability_unexamined)+'|'+ checkField(dates_of_public_availability_printed)+'|'+
              checkField(dates_of_public_availability_gazette_reference)+'|'+checkField(dates_of_public_availability_abstract_reference)+'|'+checkField(dates_of_public_availability_supplemental)+'|'+checkField(dates_of_public_availability_gazette_pub_announcement)+'|'+checkField(dates_of_public_availability_modified_first_page_pub)+'|'+checkField(dates_of_public_availability_modified_complete_spec_pub)+'|'+checkField(dates_of_public_availability_unexamined_not_printed_without_grant)+'|'+checkField(dates_of_public_availability_unexamined_printed_without_grant)+'|'+checkField(dates_of_public_availability_examined_printed_without_grant)+'|'+checkField(dates_of_public_availability_claims_only_available)+'|'+checkField(dates_of_public_availability_not_printed_with_grant)+'|'+
              checkField(references_cited_srep_phase)+'|'+ checkField(references_cited_sequence)+'|'+
              checkField(references_cited_srep_office)+'|'+checkField(references_cited_corresponding_docs_country)+'|'+checkField(references_cited_corresponding_docs_kind)+'|'+checkField(references_cited_corresponding_docs_doc_number)+'|'+checkField(references_cited_corresponding_docs_refno)+'|'+ checkField(references_cited_corresponding_docs_date)+'|'+ checkField(references_cited_category)+'|'+
              checkField(references_cited_nplcit)+'|'+checkField(references_cited_nplcit_text)+'|'+
              checkField(references_cited_patcit_doc_country)+'|'+ checkField(references_cited_patcit_doc_doc_number)+'|'+ checkField(references_cited_patcit_doc_kind)+'|'+checkField(references_cited_patcit_doc_date)+'|'+
              checkField(st50_republication_status)+'|'+ checkField(st50_republication_republcation_code)+'|'+ checkField(st50_republication_modified_bibliography_inid_code)+'|'+ checkField(st50_republication_correction_notice_date)+'|'+ checkField(st50_republication_correction_notice_gazette_date)+'|'+ checkField(st50_republication_modified_part_sequence)+'|'+ checkField(st50_republication_modified_part_lang)+'|'+ checkField(st50_republication_modified_part_name)+'|'+ checkField(st50_republication_republication_note_sequence)+'|'+ checkField(st50_republication_republication_note_lang)+'|'+ checkField(st50_republication_republication_note)+'|'+
              checkField(abstract_country)+'|'+ checkField(abstract_doc_number)+'|'+ checkField(abstract_kind)+'|'+ checkField(abstract_date_publ)+'|'+ checkField(abstract_status)+'|'+ checkField(abstract_date)+'|'+
              checkField(patent_family_publication_reference_sequence)+'|'+ checkField(patent_family_publication_reference_data_format)+'|'+ checkField(patent_family_publication_reference_country)+'|'+ checkField(patent_family_publication_reference_doc_number)+'|'+
              checkField(patent_family_publication_reference_kind)+'|'+ checkField(patent_family_publication_reference_date)+'|'+ checkField(patent_family_application_reference_data_format)+'|'+
              checkField(patent_family_application_reference_is)+'|'+ checkField(patent_family_application_reference_country)+'|'+ checkField(patent_family_application_reference_doc_number)+'|'+
              checkField(patent_family_application_reference_kind)+'|'+ checkField(patent_family_application_reference_date)+'|'+
              checkField(patent_family_abstract_lang)+'|'+ checkField(patent_family_abstract_data_format)+'|'+ checkField(patent_family_abstract_country)+'|'+
              checkField(patent_family_abstract_doc_number)+'|'+ checkField(patent_family_abstract_kind)+'|'+ checkField(patent_family_abstract_abstract_source)+'|'+
              checkField(patent_family_abstract_status)+'|'+checkField(patent_family_abstract_date)+'|'+checkField(patent_family_abstract_p)+'|'+
              checkField(abstract_lang)+'|'+checkField(abstract_data_format)+'|'+checkField(abstract_source)+'|'+checkField(abstract_p);
    end;    // with
    //ShowMessage(sql);
     Writeln(file_tianwei,sql);
end;


function  TsigRun.checkFileName(Filename:string):Boolean;        //在数据库中检测文件是否存在
var
  sql:string;
begin
  //
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

procedure TsigRun.FormCreate(Sender: TObject);
begin
    //窗口初始化创建时
    BatchRun();
end;

procedure TsigRun.SavefileName(Filename:string;cnt:integer);                 //当成功后，将完成的文件写入数据库中
var
  sql:string;
begin
   sql := 'insert into finishFile (filename,startTime,finishTime,usedTime) VALUES (''' +
       FileInfo.filename + ''',''' + FileInfo.startTime + ''',''' +
       FileInfo.endTime  + ''',''' + FileInfo.usedTime + ''')';
   //ShowMessage(sql);
   commonFile.SqlStr := sql;
   commonFile.ExecSqlUpdate;    //insert 只能用改良版的
end;

procedure TsigRun.openDB();                                      //打开数据库
var
  sql:string;
begin
     commonFile :=TCommonOperator.Create;
     commonFile.OperatorDS :=@DataModule1.ds1;     //设置数据集
     commonFile.TableDesc := '文件信息表';
     commonFile.TableName :='finishFile';
     commonFile.PrimaryFieldName :='filename';                        //设置主键

     commonFile.Open;
end;

//每个文件单独运行
procedure TsigRun.runSingleFile(filename:string);
var
  starttick:Integer;
  endtick:Integer;
  starttickWhole:Integer;
  endtickWhole:Integer;
  cnt:Integer;
  ANode:TXmlNode;           //xml节点类
  AList:TList;              //列表类
  recordID:Integer;         //记录key值
  tmp:string;                 //临时字符串
  docTypeNode:TXmlNode;
  tmp2:string;
  storeFileName:string;    //文件操作变量
  xmlRun:TNativeXml;
begin
     //处理单独文件流程
     //开始提示

     mmoDebug.Lines.Append('！！！！进入'+filename+'处理信息,当前时刻为：'+TimeToStr(Time));
     starttickWhole := GetTickCount;

     //初始化
     recordID := 0;
     mmoDebug.Lines.Add('-------------------------------------------');
     //XML文件载入
     xmlRun := TNativeXml.Create;
     try
        //step0: 载入文件
        try
           FileInfo.startTime := TimeToStr(Time);
           tmp := '开始载入文件，当前时间为:' + TimeToStr(Time); mmoDebug.Lines.Add(tmp);
           starttick := GetTickCount;

           xmlRun.LoadFromFile(filename);  //从指定文件出载入XML ,自动进行解析时候必须符合XML语法规范

           endtick   := GetTickCount;
           tmp := '恭喜成功载入文件，当前时间为:' + TimeToStr(Time); mmoDebug.Lines.Add(tmp);
           tmp := '-->载入文件，用时:'+floattostr((endtick- starttick)/1000.0)+'秒'; mmoDebug.Lines.Add(tmp);
        except;
           ShowMessage('请注意检查XML文件格式错误');
        end;

        //step1:删除DOCTYPE节点，解析真正的root节点
        docTypeNode := xmlRun.RootNodeList.NodeByName('exch:exchange-documents');
        if Assigned(docTypeNode) then
        begin
             xmlRun.RootNodeList.NodeRemove(docTypeNode);
        end;

        //step2: 创建数据存储文件
        storeFileName := 'E:\txt\1\' + extractfilename(filename) + '.tianwei';
        //ShowMessage(storeFileName);
        AssignFile(file_tianwei,storeFileName);
        Rewrite(file_tianwei);

        //step3: 创建列表类
        AList := TList.Create;
        try
          ANode := xmlRun.RootNodeList.NodeByName('exch:exchange-documents');    //指定根节点
          if not Assigned(ANode) then
          begin
            ShowMessage('root节点发生错误，请检查');
            exit;
          end;
          //解析根节点属性
          FillChar(docEvery,SizeOf(docEvery),0);    //结构体初始化
          docEvery.date_of_exchange    := ANode.AttributeByName['date-of-exchange'];
          docEvery.dtd_version         := ANode.AttributeByName['dtd-version'];
          docEvery.file_name           := ANode.AttributeByName['file'];
          docEvery.no_of_documents     := ANode.AttributeByName['no-of-documents'];
          docEvery.originating_office  := ANode.AttributeByName['originating-office'];

          //step4：将每一条记录列出，以 exch:exchange-document 为一级几点，列出list集合
          ANode.NodesByName('exch:exchange-document',AList);

          //step5: 将每一条记录导入
          tmp := '开始分析记录，当前时间为:' +  TimeToStr(Time); mmoDebug.Lines.Add(tmp);
          starttick := GetTickCount;

          for cnt := 0 to AList.Count - 1 do    // Iterate
            begin
               ParseElement(Alist[cnt]);       //对每条记录进行解析
               fieldEvery.FieldId := docEvery.file_name+ ':' + IntToStr(recordID);            //key值标记
               recordID := recordID +1;
               savetianweiFile();                             //将每条记录存储在txt文件中
               //tmp2 := IntToStr(recordID) + ' ';
               //mmodbg.Lines.Append(tmp2);
            end;    // for

          endtick   := GetTickCount;
          tmp := '恭喜成功分析完成所有记录，当前时间为:' + TimeToStr(Time); mmoDebug.Lines.Add(tmp);
          tmp := '-->分析文件，用时:'+floattostr((endtick- starttick)/1000.0)+'秒'; mmoDebug.Lines.Add(tmp);
          FileInfo.endTime := TimeToStr(Time);
          FileInfo.usedTime := floattostr((endtick- starttick)/1000.0)+'秒';

          //文件存储
          //saveDocRecord();
        finally
          AList.Free;    //!!!!Alist优化，能提高性能
        end;
        //step5:关闭文件
        CloseFile(file_tianwei);
     finally
        FreeAndNil(xmlRun);
     end;

     //结束提示
     endtickWhole   := GetTickCount;
     mmoDebug.Lines.Append('(*_*)Success!完成'+filename+'处理信息,结束时刻为：'+TimeToStr(Time)+'处理时间共计'+floattostr(((endtickWhole-starttickWhole)/1000.0)/60)+'分钟');
     mmoDebug.Lines.Append('<------------end------------->');
end;

procedure TsigRun.BatchRun();
var
  I:Integer;
  storeFileName:string;
begin
      //开启数据库
     openDB();

     //step1:根据程序运行参数，获取文件名列表
     if ParamCount = 0 then
     begin
        ShowMessage('提示，请选择载入文件，批量导入文件！！！');
        Exit;
     end;
     //step2:写记录
     for  I:= 1 to ParamCount  do
     begin
          if ParamStr(I) <> ' ' then
          begin
            mmoDebug.Lines.Add(ParamStr(I));
          end;

          //runSingleFile(ParamStr(I));
          //Fileinfo.filename := ExtractFileName(ParamStr(I));
          //SavefileName(ParamStr(I),I);    //写入文件名和当前数字
     end;

     FillChar(fieldEvery,SizeOf(fieldEvery),0);
     mmoDebug.Lines.Append('总共有:'+inttostr(ParamCount)+'个文件');
end;

procedure TsigRun.ParseElement(ANode:TXmlNode);       //对每条记录进行解析
var
  cnt:Integer;
  bibliographic_data_Node:TXmlNode;         //二级节点
  abstract_node:TXmlNode;                   //二级节点
  publication_reference_node:TXmlNode;      //三级节点
  classification_ipc_node:TXmlNode;         //三级节点
  classification_ipcr_node:TXmlNode;        //三级节点
  classification_national_node:TXmlNode;    //三级节点
  classification_ecla_node:TXmlNode;        //三级节点
  priority_claims_node:TXmlNode;            //三级节点
  patries_node:TXmlNode;                    //三级节点
  patries_applicants_node:TXmlNode;         //四级节点
  patries_inventors_node:TXmlNode;          //四级节点
  invention_title_node:TXmlNode;            //三级节点
  dates_of_public_availability_node:TXmlNode;   //三级节点
  dates_of_public_availability_unexamined_node:TXmlNode;  //四级节点
  dates_of_public_availability_printed_node:TXmlNode;     //四级节点
  previously_filed_app_node:TXmlNode;            //三级节点 ++
  language_of_filing_node:TXmlNode;
  language_of_publication_node:TXmlNode;
  references_cited_node:TXmlNode;
  designation_of_states_EPC_node:TXmlNode;
  designation_of_states_PCT_node:TXmlNode;
  designation_of_states_Other_node:TXmlNode;
  st50_republication_node:TXmlNode;
  tmpNode:TXmlNode;
  tmpInNode:TXmlNode;
  patent_family_node:TXmlNode;
  family_member_node:TXmlNode;
  patent_abstract_node:TXmlNode;
   patent_family_publication_node:TXmlNode;
    patent_family_application_node:TXmlNode;
  Alist:TList;                              //临时列表
  Blist:TList;
  Clist:TList;
  tmpstring:string;
  tmpstring2:string;
  tmpstring3:string;
  tmpint:Integer;
  tmplang:string;
  I:Integer;
  I2:Integer;
  I3:Integer;
begin
     //字段初始化
     AList := TList.Create;                 //创建Alist
     Blist := TList.Create;
     Clist := TList.Create;
     tmpint := 0;
     FillChar(fieldEvery,SizeOf(fieldEvery),0);

     //对每一行进行解析，容量大约5M左右
     //exch:exchange-document 一级节点
     //一级节点属性值
     fieldEvery.country                    :=  ANode.AttributeByName['country'];
     fieldEvery.doc_number                 :=  ANode.AttributeByName['doc-number'];
     fieldEvery.kind                       :=  ANode.AttributeByName['kind'];
     fieldEvery.date_publ                  :=  ANode.AttributeByName['date-publ'];
     fieldEvery.family_id                  :=  ANode.AttributeByName['family-id'];
     fieldEvery.is_representative          :=  ANode.AttributeByName['is-representative'];
     fieldEvery.date_of_last_exchange      :=  ANode.AttributeByName['date-of-last-exchange'];
     fieldEvery.date_added_docdb           :=  ANode.AttributeByName['date-added-docdb'];
     fieldEvery.originating_office         :=  ANode.AttributeByName['originating-office'];           //！！！是否还有其他属性
     //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
     FieldEvery.date_of_previous_exchange  :=  ANode.AttributeByName['date-of-previous-exchange'];
     FieldEvery.status                     :=  ANode.AttributeByName['status'];
     //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
     //exch:bibliographic-data 二级节点
     bibliographic_data_Node :=  ANode.NodeByName('exch:bibliographic-data');
     if Assigned(bibliographic_data_Node) then
     begin
         //***************************************************************************************start
         //publication_reference 三级节点,搜索该节点::说明文档P43有些其他属性
         Alist.clear;
         bibliographic_data_Node.NodesByName('exch:publication-reference',Alist);
         for I:=0 to Alist.Count-1  do
         begin
            tmpstring :=  TXmlNode(Alist[i]).AttributeByName['data-format'];
            fieldEvery.publication_reference_data_format    :=   fieldEvery.publication_reference_data_format +
                  tmpstring + ',';

            //进入子节点:document-id
            tmpNode := TXmlNode(Alist[i]).NodeByName('document-id');
            if Assigned(tmpNode) then
            begin
                 //获取属性lang
                 tmplang := tmpNode.AttributeByName['lang'];
                 if not (tmplang = '')                                    then begin FieldEvery.publication_reference_doc_lang       :=    FieldEvery.publication_reference_doc_lang + '[' + tmpstring +':'+ tmplang +'];'    end;
                 if Assigned(TXmlNode(tmpNode.NodeByName('country')))     then begin fieldEvery.publication_reference_country        :=    tmpNode.ReadString('country');  end;     //coutry子节点内容
                 if Assigned(TXmlNode(tmpNode.NodeByName('kind')))        then begin fieldEvery.publication_reference_kind           :=    tmpNode.ReadString('kind');     end;     //kind 子节点内容
                 if Assigned(TXmlNode(tmpNode.NodeByName('date')))        then begin fieldEvery.publication_reference_date           :=    tmpNode.ReadString('date');      end;    //date 子节点内容
                 if Assigned(TXmlNode(tmpNode.NodeByName('doc-number'))) then
                 begin
                      fieldEvery.publication_reference_doc_number     :=    fieldEvery.publication_reference_doc_number +
                      '[' + tmpstring +':'+ tmpNode.ReadString('doc-number') +'];';         //不同类型对应不同的doc_number 格式为：<[data-fmt:doc-number];[data-fmt:doc-number]>
                 end;
            end;
         end;
         //***************************************************************************************end
         //***************************************************************************************start
         //exch:previously-filed-app 三级节点
          Alist.Clear;
          bibliographic_data_Node.NodesByName('exch:previously-filed-app',Alist);     //这种可以考虑出现多个的情况
          for I:=0 to Alist.Count-1 do
          begin
             //进入该节点,直接获取内容!!!!注意直接读取节点的方法，采用ValueAsString
             FieldEvery.previously_filed_app_text := FieldEvery.previously_filed_app_text + TxmlNode(AList[i]).ValueAsString + ';';
			// FieldEvery.previously_filed_app_text := FieldEvery.previously_filed_app_text + bibliographic_data_Node.ReadString('exch:previously-filed-app') +';' ;
          end;
         //***************************************************************************************end
          //***************************************************************************************start
         //<exch:preceding-publication-date> 三级节点
         Alist.Clear;
         bibliographic_data_Node.NodesByName('exch:preceding-publication-date',Alist);     //这种可以考虑出现多个的情况
          for I:=0 to Alist.Count-1 do
          begin
             //进入该节点,直接获取内容
             FieldEvery.preceding_publication_date := FieldEvery.preceding_publication_date + (TXmlNode(Alist[i])).ReadString('date') +';' ;
          end;
         //***************************************************************************************end
          //***************************************************************************************start
         //<exch:date-of-coming-into-force>三级节点
         Alist.Clear;
         bibliographic_data_Node.NodesByName('exch:date-of-coming-into-force',Alist);     //这种可以考虑出现多个的情况
          for I:=0 to Alist.Count-1 do
          begin
             //进入该节点,直接获取内容
             FieldEvery.date_of_coming_into_force_date := FieldEvery.date_of_coming_into_force_date + (TXmlNode(Alist[i])).ReadString('date') +';' ;
          end;
         //***************************************************************************************end
         //***************************************************************************************start
         //<exch:extended-kind-code>三级节点
         Alist.Clear;
         bibliographic_data_Node.NodesByName('exch:extended-kind-code',Alist);     //这种可以考虑出现多个的情况
          for I:=0 to Alist.Count-1 do
          begin
             //进入该节点,直接获取内容,不直接存储dataformat，而是以[dataformat:code]形式存储
             {FieldEvery.extended_kind_code := FieldEvery.extended_kind_code +
               '['+(TXmlNode(Alist[i])).AttributeByName['data-format'] +':'+ bibliographic_data_Node.ReadString('exch:extended-kind-code') +'];' ;}
			 FieldEvery.extended_kind_code := FieldEvery.extended_kind_code +
               '['+(TXmlNode(Alist[i])).AttributeByName['data-format'] +':'+ TxmlNode(AList[i]).ValueAsString +'];' ;
		  end;
         //***************************************************************************************end
         //***************************************************************************************start
         //exch:classification-ipc  三级节点
         classification_ipc_node := bibliographic_data_Node.NodeByName('exch:classification-ipc');
         if Assigned(classification_ipc_node) then
         begin
           //进入该节点，搜索text节点
           Alist.Clear;            //初始化可能存在问题
           classification_ipc_node.NodesByName('text',Alist);
           for I := 0 to Alist.Count - 1 do    // Iterate
             begin
                 //fieldEvery.classification_ipc_text := fieldEvery.classification_ipc_text + classification_ipc_node.ReadString('text') +';';
				 fieldEvery.classification_ipc_text := fieldEvery.classification_ipc_text + TxmlNode(AList[i]).ValueAsString +';';
             end;    // for
           //进入该节点，搜索edition节点
           Alist.Clear;
           classification_ipc_node.NodesByName('edition',Alist);
           for I := 0 to Alist.Count - 1 do    // Iterate
             begin
                 //FieldEvery.classification_ipc_edition := FieldEvery.classification_ipc_edition + classification_ipc_node.ReadString('edition') +';';
				 FieldEvery.classification_ipc_edition := FieldEvery.classification_ipc_edition + TxmlNode(AList[i]).ValueAsString +';';
             end;    // for
           //进入该节点，搜索main-classification节点
           Alist.Clear;
           classification_ipc_node.NodesByName('main-classification',Alist);
           for I := 0 to Alist.Count - 1 do    // Iterate
             begin
                // FieldEvery.classification_ipc_main_class := FieldEvery.classification_ipc_main_class + classification_ipc_node.ReadString('edition') +';';
				 FieldEvery.classification_ipc_main_class := FieldEvery.classification_ipc_main_class + TxmlNode(AList[i]).ValueAsString +';';
			 end;    // for
           //进入该节点，搜索further-classification节点
           Alist.Clear;
           classification_ipc_node.NodesByName('further-classification',Alist);
           for I := 0 to Alist.Count - 1 do    // Iterate
             begin
                // FieldEvery.classification_ipc_further_class := FieldEvery.classification_ipc_further_class + classification_ipc_node.ReadString('further-classification') +';';
				FieldEvery.classification_ipc_further_class := FieldEvery.classification_ipc_further_class + TxmlNode(AList[i]).ValueAsString +';';
			 end;    // for
           //进入该节点，搜索additional-info节点
           Alist.Clear;
           classification_ipc_node.NodesByName('additional-info',Alist);
           for I := 0 to Alist.Count - 1 do    // Iterate
             begin
                // FieldEvery.classification_ipc_additional_info := FieldEvery.classification_ipc_additional_info + classification_ipc_node.ReadString('additional-info') +';';
                 FieldEvery.classification_ipc_additional_info := FieldEvery.classification_ipc_additional_info + TxmlNode(AList[i]).ValueAsString +';';

			 end;    // for
           //进入该节点，搜索unlinked-indexing-code节点
           Alist.Clear;
           classification_ipc_node.NodesByName('unlinked-indexing-code',Alist);
           for I := 0 to Alist.Count - 1 do    // Iterate
             begin
                 //FieldEvery.classification_ipc_unlinked_indexing_code := FieldEvery.classification_ipc_unlinked_indexing_code + classification_ipc_node.ReadString('unlinked-indexing-code') +';';
                 FieldEvery.classification_ipc_unlinked_indexing_code := FieldEvery.classification_ipc_unlinked_indexing_code + TxmlNode(AList[i]).ValueAsString +';';
			 end;    // for
           //进入该节点，搜索linked-indexing-code-group节点
           Alist.Clear;
           classification_ipc_node.NodesByName('linked-indexing-code-group',Alist);
           for I := 0 to Alist.Count - 1 do    // Iterate
             begin

                 //linked-indexing-code 内部嵌套多个节点的情况，没有考虑！！！！
                 FieldEvery.classification_ipc_linked_indexing_code_group_main := FieldEvery.classification_ipc_linked_indexing_code_group_main +(TXmlNode(Alist[i])).ReadString('main-linked-indexing-code') +';';
                 FieldEvery.classification_ipc_linked_indexing_code_group_sub  := FieldEvery.classification_ipc_linked_indexing_code_group_sub  +(TXmlNode(Alist[i])).ReadString('sub-linked-indexing-code') +';';
             end;    // for

         end;
         //***************************************************************************************end
         //***************************************************************************************start
         //exch:classification-ipcr  三级节点
         classification_ipcr_node := bibliographic_data_Node.NodeByName('exch:classifications-ipcr');
         if Assigned(classification_ipcr_node) then
         begin
           //进入该节点，搜索节点 classification-ipcr
           Alist.Clear;            //初始化可能存在问题
           tmpint := 0;
           classification_ipcr_node.NodesByName('classification-ipcr',Alist);
           for I := 0 to Alist.Count - 1 do    // Iterate
             begin
                 //通过不同的sequence进行区分
                 //sequence的值，取最大值
                 tmpstring :=  (TXmlNode(Alist[i])).AttributeByName['sequence'];
                 if tmpint < StrToInt(tmpstring) then
                 begin
                   tmpint := StrToInt(tmpstring);
                 end;
                 //取text数值
                  //获取节点list载入多个字符串，为sequence+text对应，格式为<[sequence:text];[sequence:text]>
                 fieldEvery.classifications_ipcr_text := fieldEvery.classifications_ipcr_text +
                  '['+tmpstring+':'+TXmlNode(Alist[i]).ReadString('text')+'];' ;
             end;    // for
             fieldEvery.classifications_ipcr_num := IntToStr(tmpint);             //存入最大值 属性，该值为sequence递增值，最终为最大值
         end;
         //***************************************************************************************end
         //***************************************************************************************start
         //exch:classification-national  三级节点
         classification_national_node := bibliographic_data_Node.NodeByName('exch:classification-national');
         if Assigned(classification_national_node) then
         begin
            //进入该节点，搜索节点text
            Alist.Clear;
            classification_national_node.NodesByName('text',Alist);
            for I := 0 to Alist.Count - 1 do    // Iterate
              begin
                 //!!!!!!!!!!!!注意直接读取节点的方法，采用ValueAsString,否则采用readstring方法，一直访问第一个节点
                 fieldEvery.classification_national_text :=  fieldEvery.classification_national_text +TXmlNode(alist[i]).ValueAsString + ';';
              end;    // for
         end;
         //***************************************************************************************end
         //***************************************************************************************start
         //classification-ecla 三级节点,搜索该节点
         Alist.Clear;
         bibliographic_data_Node.NodesByName('exch:classification-ecla',Alist);
         for I := 0 to Alist.Count - 1 do    // Iterate
           begin
             fieldEvery.classification_ecla := fieldEvery.classification_ecla +
                  '[' + TXmlNode(Alist[i]).AttributeByName['country'] +':'+TXmlNode(Alist[i]).AttributeByName['classification-scheme'] +
                  ':'+ TXmlNode(Alist[i]).ReadString('classification-symbol')+'];';
           end;    // for
         //***************************************************************************************end
         //***************************************************************************************start
         //exch:application-reference  三级节点,搜索该节点
         Alist.Clear;
         bibliographic_data_Node.NodesByName('exch:application-reference',Alist);
         for I := 0 to Alist.Count - 1 do    // Iterate
           begin
             if not (TxmlNode(Alist[i]).AttributeByName['is-representative'] = '') then
             begin
                    fieldEvery.application_reference_is := fieldEvery.application_reference_is + TxmlNode(Alist[i]).AttributeByName['is-representative']+';';
             end;

             fieldEvery.application_reference_data_format := fieldEvery.application_reference_data_format + TxmlNode(Alist[i]).AttributeByName['data-format']+';';
             tmpstring :=  TxmlNode(Alist[i]).AttributeByName['data-format'];
             if  not (TxmlNode(Alist[i]).AttributeByName['status'] = '') then
             begin
               FieldEvery.application_reference_status := FieldEvery.application_reference_status + '['+tmpstring+':'+ TxmlNode(Alist[i]).AttributeByName['status'] +'];';
             end;
             if  not (TxmlNode(Alist[i]).AttributeByName['doc-id'] = '') then
             begin
               FieldEvery.application_reference_doc_id := FieldEvery.application_reference_doc_id + TxmlNode(Alist[i]).AttributeByName['doc-id'] +';';
             end;

             //进入document-id子节点
             tmpNode := TXmlNode(Alist[i]).NodeByName('document-id');
             if Assigned(tmpNode) then
             begin
                 if not (tmpNode.AttributeByName['lang'] = '')            then begin FieldEvery.application_reference_doc_lang       :=    FieldEvery.application_reference_doc_lang  + tmpNode.AttributeByName['lang'] +';'; end;
                 if Assigned(TXmlNode(tmpNode.NodeByName('country')))     then begin fieldEvery.application_reference_country        :=    tmpNode.ReadString('country');  end;     //coutry子节点内容
                 if Assigned(TXmlNode(tmpNode.NodeByName('kind')))        then begin fieldEvery.application_reference_kind           :=    tmpNode.ReadString('kind');     end;     //kind 子节点内容
                 if Assigned(TXmlNode(tmpNode.NodeByName('date')))        then begin fieldEvery.application_reference_date           :=    tmpNode.ReadString('date');      end;    //date 子节点内容
                 if Assigned(TXmlNode(tmpNode.NodeByName('doc-number'))) then
                 begin
                      fieldEvery.application_reference_doc_number     :=    fieldEvery.application_reference_doc_number +
                      '[' + tmpstring +':'+ tmpNode.ReadString('doc-number') +'];';         //不同类型对应不同的doc_number 格式为：<[data-fmt:doc-number];[data-fmt:doc-number]>
                 end;
             end;
           end;    // for
         //***************************************************************************************end
         //***************************************************************************************start
         //exch:language-of-filing 没考虑多个节点问题
         language_of_filing_node := bibliographic_data_Node.NodeByName('exch:language-of-filing');
         if Assigned(language_of_filing_node) then
         begin
           FieldEvery.language_of_filing_statue := language_of_filing_node.AttributeByName['status'];
           FieldEvery.language_of_filing_text := bibliographic_data_Node.ReadString('exch:language-of-filing');            //!!!可能存在问题，因为没有实例
         end;
         //***************************************************************************************end
         //***************************************************************************************start
         //exch:language-of-publication
         language_of_publication_node := bibliographic_data_Node.NodeByName('exch:language-of-publication');
         if Assigned(language_of_publication_node) then
         begin
           FieldEvery.language_of_publication_status := language_of_publication_node.AttributeByName['status'];
           FieldEvery.language_of_publication_text   := bibliographic_data_Node.ReadString('exch:language-of-publication');       //!!!可能存在问题，因为没有实例
         end;
         //***************************************************************************************end
         //***************************************************************************************start
         //exch:priority-claims 三级节点
         priority_claims_node := bibliographic_data_Node.NodeByName('exch:priority-claims');
         if Assigned(priority_claims_node) then
         begin
           //进入该节点，搜索其子节点
           tmpint := 0;
           Alist.Clear;
           priority_claims_node.NodesByName('exch:priority-claim',Alist);
           for I := 0 to Alist.Count - 1 do    // Iterate
             begin
                 //通过不同的sequence进行区分
                 //sequence的值，取最大值
                 tmpstring2 :=  (TXmlNode(Alist[i])).AttributeByName['sequence'];
                 if tmpint < StrToInt(tmpstring2) then
                 begin
                   tmpint := StrToInt(tmpstring2);
                 end;
                 //data-format解析,需要在已知的串中进行搜索
                 tmpstring := (TXmlNode(Alist[i])).AttributeByName['data-format'];
                 if Pos(tmpstring,fieldEvery.priority_claims_data_format) = 0 then   //若搜索不到字符串
                 begin
                   fieldEvery.priority_claims_data_format :=  fieldEvery.priority_claims_data_format + tmpstring + ';';
                 end;
                 //status问题
                 if not ((TXmlNode(Alist[i])).AttributeByName['status'] = '' ) then
                 begin
                   FieldEvery.priority_claims_status := FieldEvery.priority_claims_status +
                   '[' +tmpstring2+':'+tmpstring+':'+(TXmlNode(Alist[i])).AttributeByName['status']+ '];';
                 end;

                 //docment-id节点进入处理
                 //进入document-id子节点
                 tmpNode := TXmlNode(Alist[i]).NodeByName('document-id');
                 if Assigned(tmpNode) then
                 begin
                     if not (tmpNode.AttributeByName['lang'] = '')            then begin FieldEvery.priority_claims_doc_lang       :=    FieldEvery.priority_claims_doc_lang  + tmpNode.AttributeByName['lang'] +';'; end;
                     if Assigned(TXmlNode(tmpNode.NodeByName('country')))     then begin fieldEvery.priority_claims_country        :=    tmpNode.ReadString('country');  end;     //coutry子节点内容
                     if Assigned(TXmlNode(tmpNode.NodeByName('kind')))        then begin fieldEvery.priority_claims_kind           :=    tmpNode.ReadString('kind');     end;     //kind 子节点内容
                     if Assigned(TXmlNode(tmpNode.NodeByName('date')))        then begin fieldEvery.priority_claims_date           :=    tmpNode.ReadString('date');      end;    //date 子节点内容
                     if Assigned(TXmlNode(tmpNode.NodeByName('doc-number'))) then
                     begin
                          fieldEvery.priority_claims_doc_number     :=    fieldEvery.priority_claims_doc_number +
                          '[' +tmpstring2+':'+tmpstring +':'+ tmpNode.ReadString('doc-number') +'];';         //不同类型对应不同的doc_number 格式为：<[sequence:data-fmt:doc-number];[data-fmt:doc-number]>
                     end;
                 end;
             end;    // for
             //sequence的值，取最大值，考虑可能存在的问题
             fieldEvery.priority_claims_sequence := IntToStr(tmpint);
         end;
         //***************************************************************************************end
         //***************************************************************************************start
         //exch:parties 三级节点
         patries_node := bibliographic_data_Node.NodeByName('exch:parties');
         if Assigned(patries_node) then
         begin
           //进入该节点
           //进入下一级节点
           patries_applicants_node := patries_node.NodeByName('exch:applicants');
           if Assigned(patries_applicants_node) then
           begin
              //进入该节点
              Alist.Clear;
              tmpint := 0;
              patries_applicants_node.NodesByName('exch:applicant',Alist);
              for I := 0 to Alist.Count - 1 do    // Iterate
                begin
                     //通过不同的sequence进行区分
                     //sequence的值，取最大值
                     tmpstring2 :=  (TXmlNode(Alist[i])).AttributeByName['sequence'];
                     if tmpint < StrToInt(tmpstring2) then
                     begin
                          tmpint := StrToInt(tmpstring2);
                     end;
                     //data-format解析,需要在已知的串中进行搜索
                     tmpstring := (TXmlNode(Alist[i])).AttributeByName['data-format'];
                     if Pos(tmpstring,fieldEvery.patries_applicants_data_format) = 0  then   //若搜索不到字符串
                     begin
                       fieldEvery.patries_applicants_data_format :=  fieldEvery.patries_applicants_data_format + tmpstring + ';';
                     end;
                     //status问题
                     if not ((TXmlNode(Alist[i])).AttributeByName['status'] = '' ) then
                     begin
                     FieldEvery.patries_applicants_status := FieldEvery.patries_applicants_status +
                     '[' +tmpstring2+':'+tmpstring+':'+(TXmlNode(Alist[i])).AttributeByName['status']+ '];';
                     end;
                     //进入该节点进行解析
                     tmpNode := TXmlNode(Alist[i]).NodeByName('exch:applicant-name');
                     if Assigned(tmpNode) then
                     begin
                       //并没有考虑patries_applicants_name_data_format,因为与(TXmlNode(Alist[i])).AttributeByName['data-format'];重复
                       fieldEvery.patries_applicants_name := fieldEvery.patries_applicants_name +
                         '['+ tmpstring2 + ':' + tmpstring + ':' + tmpNode.ReadString('name')+'];';
                     end;
                     tmpInNode :=TXmlNode(Alist[i]).NodeByName('residence');
                     if Assigned(tmpInNode) then
                     begin
                          fieldEvery.patries_applicants_country := tmpInNode.ReadString('country');       //考虑是否要扩展
                     end;
                     tmpInNode := TXmlNode(Alist[i]).NodeByName('address');
                     if Assigned(tmpInNode)  then
                     begin
                          fieldEvery.patries_applicants_address := tmpInNode.ReadString('text');          //考虑是否要扩展
                     end;
                end;    // for
                fieldEvery.patries_applicants_sequence := IntToStr(tmpint);
           end;
           //进入下一级节点
           patries_inventors_node  := patries_node.NodeByName('exch:inventors');
           if Assigned(patries_inventors_node) then
           begin
             //进入该节点
             Alist.Clear;
             tmpint := 0;
             patries_inventors_node.NodesByName('exch:inventor',Alist);
             for I := 0 to Alist.Count - 1 do    // Iterate
               begin
                     //通过不同的sequence进行区分
                     //sequence的值，取最大值
                     tmpstring2 :=  (TXmlNode(Alist[i])).AttributeByName['sequence'];
                     if tmpint < StrToInt(tmpstring2) then
                     begin
                          tmpint := StrToInt(tmpstring2);
                     end;
                     //data-format解析,需要在已知的串中进行搜索
                     tmpstring := (TXmlNode(Alist[i])).AttributeByName['data-format'];
                     if Pos(tmpstring,fieldEvery.patries_inventors_data_format) = 0 then   //若搜索不到字符串
                     begin
                       fieldEvery.patries_inventors_data_format :=  fieldEvery.patries_inventors_data_format + tmpstring + ';';
                     end;
                     //status问题
                     if not ((TXmlNode(Alist[i])).AttributeByName['status'] = '' ) then
                     begin
                     FieldEvery.patries_inventors_status := FieldEvery.patries_inventors_status +
                     '[' +tmpstring2+':'+tmpstring+':'+(TXmlNode(Alist[i])).AttributeByName['status']+ '];';
                     end;
                     //exch:inventor-name
                     tmpNode :=(TXmlNode(Alist[i])).NodeByName('exch:inventor-name');
                     if Assigned(tmpNode)  then
                     begin
                       fieldEvery.patries_inventors_name := fieldEvery.patries_inventors_name +
                         '['+ tmpstring2 + ':' + tmpstring + ':' + tmpNode.ReadString('name')+'];';
                     end;
                     //exch:inventor-address
                     tmpNode :=(TXmlNode(Alist[i])).NodeByName('address');
                     if Assigned(tmpNode)  then
                     begin
                       fieldEvery.patries_inventors_address := fieldEvery.patries_inventors_address +
                         '['+ tmpstring2 + ':' + tmpstring + ':' + tmpNode.ReadString('text')+'];';
                     end;
               end;    // for
               fieldEvery.patries_inventors_sequence := IntToStr(tmpint);
           end;
         end;
         //***************************************************************************************end
         //***************************************************************************************start
          Alist.Clear;
          bibliographic_data_Node.NodesByName('exch:designation-of-states',Alist);
          for I := 0 to Alist.Count - 1 do    // Iterate
            begin
                //!!!!!!此处仅考虑一个EPC,PCT,Other节点情况
                // EPC节点
                designation_of_states_EPC_node := Txmlnode(Alist[i]).NodeByName('exch:designation-epc');
                if Assigned(designation_of_states_EPC_node ) then
                begin
                    //此处仅根据实例考虑一个节点
                    tmpNode := designation_of_states_EPC_node.NodeByName('exch:contracting-states');
                    Blist.Clear;
                    tmpNode.NodesByName('country',Blist);
                    for I2 := 0 to Blist.Count - 1 do    // Iterate
                      begin
                        FieldEvery.designation_of_states_EPC_contracting_states_country :=  FieldEvery.designation_of_states_EPC_contracting_states_country +
                          TXmlNode(blist[i2]).ValueAsString + ';';
						  //tmpNode.ReadString('country') +';';
                      end;    // for

                    tmpNode := designation_of_states_EPC_node.NodeByName('exch:extension-states');
                    Blist.Clear;
                    tmpNode.NodesByName('country',Blist);
                    for I2 := 0 to Blist.Count - 1 do    // Iterate
                      begin
                        FieldEvery.designation_of_states_EPC_extension_states_country :=  FieldEvery.designation_of_states_EPC_extension_states_country +
                           TXmlNode(blist[i2]).ValueAsString + ';';
						  //tmpNode.ReadString('country') +';';
                      end;    // for
                end;
                //PCT 节点
                designation_of_states_PCT_node := TXmlNode(Alist[i]).NodeByName('designation-PCT');
                if Assigned( designation_of_states_PCT_node) then
                begin
                   Blist.Clear;
                   //regional
                   designation_of_states_PCT_node.NodesByName('regional',Blist);
                   for I2 := 0 to Blist.Count - 1 do    // Iterate
                     begin
                       //region节点
                       tmpNode :=  TXmlNode(Blist[i2]).NodeByName('region');
                       if Assigned(tmpNode) then
                       begin
                         FieldEvery.designation_of_states_PCT_regional_country := FieldEvery.designation_of_states_PCT_regional_country +
                          tmpNode.ReadString('country') + ';';
                       end;
                       //country节点
                        Clist.Clear;
                        Txmlnode(Blist[i2]).NodesByName('country',Clist);
                        for I3 := 0 to Clist.Count - 1 do    // Iterate
                          begin
                              FieldEvery.designation_of_states_PCT_countrys := FieldEvery.designation_of_states_PCT_countrys  +
							   TXmlNode(clist[i3]).ValueAsString + ';';
                              // TXmlNode(Blist[i2]).ReadString('country')+';';
                          end;    // for
                     end;    // for
                   //national
                   Blist.Clear;
                   designation_of_states_PCT_node.NodesByName('national',Blist);
                   for I2 := 0 to Blist.Count - 1 do    // Iterate
                   begin
                        Clist.Clear;
                        Txmlnode(Blist[I2]).NodesByName('national',Clist);
                        for I3 := 0 to Clist.Count - 1 do    // Iterate
                          begin
                               FieldEvery.designation_of_states_PCT_national_country := FieldEvery.designation_of_states_PCT_national_country  +
                                   TXmlNode(Blist[I2]).ReadString('country') + ';';
                          end;    // for
                   end;    // for
                end;
                //Other节点
                designation_of_states_Other_node:=TXmlNode(Alist[i]).NodeByName('exch:contracting-states');
                if Assigned(designation_of_states_Other_node ) then
                begin
                   Blist.Clear;
                   designation_of_states_Other_node.NodesByName('country',Blist);
                   for i2 := 0 to Blist.Count - 1 do    // Iterate
                     begin
                        FieldEvery.designation_of_states_contracting_states_country := FieldEvery.designation_of_states_contracting_states_country +
                        TXmlNode(blist[i2]).ValueAsString + ';';
						 //designation_of_states_Other_node.ReadString('country') + ';';
                     end;    // for
                end;
            end;    // for
         //***************************************************************************************end
         //***************************************************************************************start
         //exch:invention-title 三级节点     !!! 此处数据库发生更改！！！
         Alist.Clear;
         bibliographic_data_Node.NodesByName('exch:invention-title',Alist);
         for I := 0 to Alist.Count - 1 do    // Iterate
           begin
             invention_title_node := TXmlNode(Alist[i]);
             fieldEvery.invention_title_text := fieldEvery.invention_title_text +
               '[' + invention_title_node.AttributeByName['lang'] +':' +invention_title_node.AttributeByName['data-format']  +':'+
               invention_title_node.AttributeByName['status'] +':'+
			   invention_title_node.ValueAsString +'];';
			   //bibliographic_data_Node.ReadString('exch:invention-title')+'];';
           end;    // for

         //***************************************************************************************end
         //***************************************************************************************start
         //exch:dates-of-public-availability 三级节点     !!! 此处仅根据示例而来 !!!并没有考虑出现多个情况
         dates_of_public_availability_node := bibliographic_data_Node.NodeByName('exch:dates-of-public-availability');
         if Assigned(dates_of_public_availability_node) then
         begin
           //进入下一级
            //exch:unexamined-printed-without-grant 节点
            dates_of_public_availability_unexamined_node := dates_of_public_availability_node.NodeByName('exch:unexamined-printed-without-grant');
            if Assigned(dates_of_public_availability_unexamined_node) then
            begin    //!!!!!!!!!!!!!!!!!!!此处说明文档与实例不同，注意
              tmpNode := dates_of_public_availability_unexamined_node.NodeByName('document-id');
              if Assigned(tmpNode) then
              begin
                tmpInNode := tmpNode.NodeByName('date');
                if Assigned(tmpInNode) then
                begin
                   fieldEvery.dates_of_public_availability_unexamined := fieldEvery.dates_of_public_availability_unexamined + tmpNode.ReadString('date') + ';';
                end;
              end;
              tmpNode :=  dates_of_public_availability_unexamined_node.NodeByName('date');
              if Assigned(tmpNode) then
              begin
                 fieldEvery.dates_of_public_availability_unexamined := fieldEvery.dates_of_public_availability_unexamined + dates_of_public_availability_unexamined_node.ReadString('date') + ';';
              end;

            end;
            //exch:printed-with-grant 节点
            dates_of_public_availability_printed_node    := dates_of_public_availability_node.NodeByName('exch:printed-with-grant');
            if Assigned(dates_of_public_availability_printed_node) then
            begin
              tmpNode := dates_of_public_availability_printed_node.NodeByName('document-id');
              if Assigned(tmpNode) then
              begin
                fieldEvery.dates_of_public_availability_printed := tmpNode.ReadString('date');
              end;
            end;
            //gazette-reference 节点   !!! 此处仅根据示例而来 !!!并没有考虑出现多个情况
            tmpNode := TXmlNode(dates_of_public_availability_node.NodeByName('exch:gazette-reference'));
            if Assigned(tmpNode) then
            begin
              //此处考虑多种情况，由于说明文档和具体的例子有区别，为了防止丢数据，全面考虑
              tmpInNode := tmpNode.NodeByName('document-id');
              if Assigned( tmpInNode ) then
              begin
                FieldEvery.dates_of_public_availability_gazette_reference :=FieldEvery.dates_of_public_availability_gazette_reference + tmpInNode.ReadString('date') + ';' ;
              end;
              FieldEvery.dates_of_public_availability_gazette_reference := FieldEvery.dates_of_public_availability_gazette_reference  + tmpNode.ReadString('date');
            end;
            //abstract-reference 节点   !!! 此处仅根据示例而来 !!!并没有考虑出现多个情况
            tmpNode := TXmlNode(dates_of_public_availability_node.NodeByName('exch:abstract-reference'));
            if Assigned(tmpNode) then
            begin
              tmpInNode := tmpNode.NodeByName('document-id');
              if Assigned( tmpInNode ) then
              begin
                FieldEvery.dates_of_public_availability_abstract_reference :=FieldEvery.dates_of_public_availability_abstract_reference + tmpInNode.ReadString('date') + ';' ;
              end;
              FieldEvery.dates_of_public_availability_abstract_reference :=FieldEvery.dates_of_public_availability_abstract_reference +  tmpNode.ReadString('date');
            end;
            //supplemental-srep-reference 节点   !!! 此处仅根据示例而来 !!!并没有考虑出现多个情况
            tmpNode := TXmlNode(dates_of_public_availability_node.NodeByName('exch:supplemental-srep-reference'));
            if Assigned(tmpNode) then
            begin
              tmpInNode := tmpNode.NodeByName('document-id');
              if Assigned( tmpInNode ) then
              begin
                FieldEvery.dates_of_public_availability_supplemental :=FieldEvery.dates_of_public_availability_supplemental + tmpInNode.ReadString('date') + ';' ;
              end;
              FieldEvery.dates_of_public_availability_supplemental := FieldEvery.dates_of_public_availability_supplemental + tmpNode.ReadString('date') ;
            end;
            //exch:gazette-pub-announcement 节点   !!! 此处仅根据示例而来 !!!并没有考虑出现多个情况
            tmpNode := TXmlNode(dates_of_public_availability_node.NodeByName('exch:gazette-pub-announcement'));
            if Assigned(tmpNode) then
            begin
              tmpInNode := tmpNode.NodeByName('document-id');
              if Assigned( tmpInNode ) then
              begin
                FieldEvery.dates_of_public_availability_gazette_pub_announcement :=FieldEvery.dates_of_public_availability_gazette_pub_announcement + tmpInNode.ReadString('date') + ';' ;
              end;
              FieldEvery.dates_of_public_availability_gazette_pub_announcement :=FieldEvery.dates_of_public_availability_gazette_pub_announcement +  tmpNode.ReadString('date')
            end;
            //exch:modified-first-page-pub 节点   !!! 此处仅根据示例而来 !!!并没有考虑出现多个情况
            tmpNode := TXmlNode(dates_of_public_availability_node.NodeByName('exch:modified-first-page-pub'));
            if Assigned(tmpNode) then
            begin
              tmpInNode := tmpNode.NodeByName('document-id');
              if Assigned( tmpInNode ) then
              begin
                FieldEvery.dates_of_public_availability_modified_first_page_pub:=FieldEvery.dates_of_public_availability_modified_first_page_pub + tmpInNode.ReadString('date') + ';' ;
              end;
              FieldEvery.dates_of_public_availability_modified_first_page_pub := FieldEvery.dates_of_public_availability_modified_first_page_pub + tmpNode.ReadString('date');
            end;
            //exch:modified-complete-spec-pub 节点   !!! 此处仅根据示例而来 !!!并没有考虑出现多个情况
            tmpNode := TXmlNode(dates_of_public_availability_node.NodeByName('exch:modified-complete-spec-pub'));
            if Assigned(tmpNode) then
            begin
              tmpInNode := tmpNode.NodeByName('document-id');
              if Assigned( tmpInNode ) then
              begin
                FieldEvery.dates_of_public_availability_modified_complete_spec_pub:=FieldEvery.dates_of_public_availability_modified_complete_spec_pub + tmpInNode.ReadString('date') + ';' ;
              end;
              FieldEvery.dates_of_public_availability_modified_complete_spec_pub :=FieldEvery.dates_of_public_availability_modified_complete_spec_pub + tmpNode.ReadString('date') ;
            end;
            //exch:unexamined-printed-without-grant 节点   !!! 此处仅根据示例而来 !!!并没有考虑出现多个情况
            tmpNode := TXmlNode(dates_of_public_availability_node.NodeByName('exch:unexamined-printed-without-grant'));
            if Assigned(tmpNode) then
            begin
              tmpInNode := tmpNode.NodeByName('document-id');
              if Assigned( tmpInNode ) then
              begin
                FieldEvery.dates_of_public_availability_unexamined_printed_without_grant:=FieldEvery.dates_of_public_availability_unexamined_printed_without_grant + tmpInNode.ReadString('date') + ';' ;
              end;
              FieldEvery.dates_of_public_availability_unexamined_printed_without_grant :=FieldEvery.dates_of_public_availability_unexamined_printed_without_grant +   tmpNode.ReadString('date');
            end;
            //exch:not-printed-with-grant 节点   !!! 此处仅根据示例而来 !!!并没有考虑出现多个情况
            tmpNode := TXmlNode(dates_of_public_availability_node.NodeByName('exch:not-printed-with-grant'));
            if Assigned(tmpNode) then
            begin
              tmpInNode := tmpNode.NodeByName('document-id');
              if Assigned( tmpInNode ) then
              begin
                FieldEvery.dates_of_public_availability_not_printed_with_grant:=FieldEvery.dates_of_public_availability_not_printed_with_grant + tmpInNode.ReadString('date') + ';' ;
              end;
              FieldEvery.dates_of_public_availability_not_printed_with_grant :=FieldEvery.dates_of_public_availability_not_printed_with_grant +  tmpNode.ReadString('date');
            end;
            //exch:claims-only-available 节点   !!! 此处仅根据示例而来 !!!并没有考虑出现多个情况
            tmpNode := TXmlNode(dates_of_public_availability_node.NodeByName('exch:claims-only-available'));
            if Assigned(tmpNode) then
            begin
              tmpInNode := tmpNode.NodeByName('document-id');
              if Assigned( tmpInNode ) then
              begin
                FieldEvery.dates_of_public_availability_claims_only_available :=FieldEvery.dates_of_public_availability_claims_only_available + tmpInNode.ReadString('date') + ';' ;
              end;
              FieldEvery.dates_of_public_availability_claims_only_available :=FieldEvery.dates_of_public_availability_claims_only_available +  tmpNode.ReadString('date');
            end;
            //exch:examined-printed-without-grant 节点   !!! 此处仅根据示例而来 !!!并没有考虑出现多个情况
            tmpNode := TXmlNode(dates_of_public_availability_node.NodeByName('exch:examined-printed-without-grant'));
            if Assigned(tmpNode) then
            begin
              tmpInNode := tmpNode.NodeByName('document-id');
              if Assigned( tmpInNode ) then
              begin
                FieldEvery.dates_of_public_availability_examined_printed_without_grant :=FieldEvery.dates_of_public_availability_examined_printed_without_grant + tmpInNode.ReadString('date') + ';' ;
              end;
              FieldEvery.dates_of_public_availability_examined_printed_without_grant :=FieldEvery.dates_of_public_availability_examined_printed_without_grant  +  tmpNode.ReadString('date') ;
            end;
         end;
         //***************************************************************************************end
         //***************************************************************************************start
         //references-cited  三级节点 : 重要解析节点
         references_cited_node := bibliographic_data_Node.NodeByName('exch:references-cited');
         if Assigned(references_cited_node) then
         begin
           Alist.Clear;
           tmpint := 0;
           references_cited_node.NodesByName('exch:citation',Alist);
           for I := 0 to Alist.Count - 1 do    // Iterate
             begin
                  //通过不同的sequence进行区分
                  //sequence的值，取最大值
                  tmpstring2 :=  (TXmlNode(Alist[i])).AttributeByName['sequence'];
                  if tmpint < StrToInt(tmpstring2) then
                  begin
                       tmpint := StrToInt(tmpstring2);
                  end;
                  //srep-phase查找字符串
                  tmpstring := (TXmlNode(Alist[i])).AttributeByName['srep-phase'];
                  if Pos(tmpstring,fieldEvery.references_cited_srep_phase) = 0 then   //若搜索不到字符串
                  begin
                       fieldEvery.references_cited_srep_phase :=  fieldEvery.references_cited_srep_phase + tmpstring + ';';
                  end;
                  //srep-office查找字符串
                  tmpstring3 := (Txmlnode(Alist[i])).AttributeByName['srep-officesrep-office'];
                  if not (tmpstring3 = '') then
                  begin
                    if Pos(tmpstring3,fieldEvery.references_cited_srep_office) = 0 then
                    begin
                        fieldEvery.references_cited_srep_office := fieldEvery.references_cited_srep_office + tmpstring3 + ';';
                    end;
                  end;



                  //搜索patcit子节点
                  Blist.Clear;
                  Txmlnode(Alist[i]).NodesByName('patcit',Blist);
                  for I2 := 0 to Blist.Count - 1 do    // Iterate      //此处检验多个节点
                    begin
                        tmpnode := Txmlnode(Blist[i2]);

                        tmpInNode := TXmlNode(tmpNode).NodeByName('document-id');
                        if assigned(tmpinnode) then      //此处格式存在问题
                        begin
                           if Assigned(tmpInNode.NodeByName('country')) then
                           begin
                               fieldEvery.references_cited_patcit_doc_country := fieldEvery.references_cited_patcit_doc_country +
                               '['+ tmpstring2 +':'+ tmpstring +':'+tmpstring3 +':(patcit)'+ tmpNode.AttributeByName['num'] +':' +
                               tmpNode.AttributeByName['dnum'] +':' + tmpNode.AttributeByName['dnum-type'] +':' +
                               tmpInNode.ReadString('country') + '];';
                           end;
                           if Assigned(tmpInNode.NodeByName('doc-number')) then
                           begin
                               fieldEvery.references_cited_patcit_doc_doc_number := fieldEvery.references_cited_patcit_doc_doc_number +
                               '['+ tmpstring2 +':'+ tmpstring+':'+tmpstring3  +':(patcit)'+ tmpNode.AttributeByName['num'] +':'+
                               tmpNode.AttributeByName['dnum'] +':' + tmpNode.AttributeByName['dnum-type'] +':' +
                               tmpInNode.ReadString('doc-number') + '];';
                           end;
                           if Assigned(tmpInNode.NodeByName('kind')) then
                           begin
                               fieldEvery.references_cited_patcit_doc_kind := fieldEvery.references_cited_patcit_doc_kind +
                               '['+ tmpstring2 +':'+ tmpstring+':'+tmpstring3  +':(patcit)'+ tmpNode.AttributeByName['num'] +':'+
                               tmpNode.AttributeByName['dnum'] +':' + tmpNode.AttributeByName['dnum-type'] +':' +
                               tmpInNode.ReadString('kind') + '];';
                           end;
                           if Assigned(tmpInNode.NodeByName('date')) then
                           begin
                               fieldEvery.references_cited_patcit_doc_date := fieldEvery.references_cited_patcit_doc_date +
                               '['+ tmpstring2 +':'+ tmpstring+':'+tmpstring3  +':(patcit)'+ tmpNode.AttributeByName['num'] +':'+
                               tmpNode.AttributeByName['dnum'] +':' + tmpNode.AttributeByName['dnum-type'] +':' +
                               tmpInNode.ReadString('date') + '];';
                           end;
                       end;
                    end;    // for

                  //搜索nplcit子节点   !!!仅根据示例，没有考虑其他情况
                  Blist.Clear;
                  Txmlnode(Alist[i]).NodesByName('nplcit',Blist);
                  for I2 := 0 to Blist.Count - 1 do    // Iterate
                    begin
                         fieldEvery.references_cited_nplcit_text := fieldEvery.references_cited_nplcit_text +
                    '['+ tmpstring2 +':' +tmpstring+':'+tmpstring3 +':(nplcit)'+ Txmlnode(Blist[i2]).AttributeByName['num'] + ':' +
                         Txmlnode(Blist[i2]).ReadString('text') + '];';
                    end;    // for
                  //搜索exch:corresponding-docs 节点
                  tmpnode := Txmlnode(Alist[i]).nodebyname('exch:corresponding-docs');
                  if assigned(tmpnode) then
                  begin
                      tmpInNode := tmpnode.NodeByName('document-id');
                      if assigned(tmpinnode) then
                      begin        //此处具有试验性质！！！观察是否会出现多个
                         fieldEvery.references_cited_corresponding_docs_country    :=   fieldEvery.references_cited_corresponding_docs_country     +   tmpinnode.ReadString('country') +';';
                         fieldEvery.references_cited_corresponding_docs_kind       :=   fieldEvery.references_cited_corresponding_docs_kind        +   tmpinnode.ReadString('kind')+';';
                         fieldEvery.references_cited_corresponding_docs_doc_number :=   fieldEvery.references_cited_corresponding_docs_doc_number  +   tmpinnode.ReadString('doc-number')+';';     //由于没有data-format属性，故没有多种形式
                         fieldEvery.references_cited_corresponding_docs_date       :=   fieldEvery.references_cited_corresponding_docs_date        +   tmpinnode.ReadString('date')+';';
                      end;
                      tmpinnode := tmpnode.NodeByName('refno');
                      if assigned(tmpinnode) then
                      begin
                        fieldEvery.references_cited_corresponding_docs_refno := fieldEvery.references_cited_corresponding_docs_refno  + tmpnode.ReadString('refno') + ';';
                      end;
                  end;
                  //category 节点
                  tmpnode := Txmlnode(Alist[i]).NodeByName('category');
                  if assigned(tmpnode) then
                  begin
                    fieldEvery.references_cited_category :=  fieldEvery.references_cited_category + Txmlnode(Alist[i]).ReadString('category') +';';
                  end;
             end;    // for
             fieldEvery.references_cited_sequence := IntToStr(tmpint);
         end;
         //***************************************************************************************end
         //***************************************************************************************start
         //<exch:st50-republication>  //此属性仅按照实例进行

        st50_republication_node :=  bibliographic_data_Node.NodeByName('exch:st50-republication');
        if assigned(st50_republication_node) then
        begin
           //status 属性
           fieldEvery.st50_republication_status := st50_republication_node.AttributeByName['status'];
           //st50_republication_republcation_code  node
           Alist.Clear;
           st50_republication_node.NodesByName('republication-code',Alist);
           for I := 0 to Alist.Count - 1 do    // Iterate
             begin
                //fieldEvery.st50_republication_republcation_code := fieldEvery.st50_republication_republcation_code +  st50_republication_node.ReadString('republication-code')+';';
				fieldEvery.st50_republication_republcation_code := fieldEvery.st50_republication_republcation_code +  TXmlNode(alist[i]).ValueAsString +';';
			 end;    // for

           //modifications node
           tmpnode := st50_republication_node.NodeByName('modifications');
           if assigned(tmpnode) then
           begin
               //modified-bibliography 节点
               tmpinnode := tmpnode.NodeByName('modified-bibliography');
               if assigned(tmpinnode) then
               begin
                 Alist.Clear;
                 tmpinnode.NodesByName('inid-code',Alist);
                 for I := 0 to Alist.Count - 1 do    // Iterate
                   begin
                     {fieldEvery.st50_republication_modified_bibliography_inid_code := fieldEvery.st50_republication_modified_bibliography_inid_code +
                      '['+Txmlnode(Alist[i]).AttributeByName['sequence'] +':'+tmpinnode.ReadString('inid-code') +'];';}
                     fieldEvery.st50_republication_modified_bibliography_inid_code := fieldEvery.st50_republication_modified_bibliography_inid_code +
                      '['+Txmlnode(Alist[i]).AttributeByName['sequence'] +':'+TXmlNode(alist[i]).ValueAsString +'];';
				   end;    // for
               end;
               //modified-part 节点
               Alist.Clear;
               tmpnode.NodesByName('modified-part',Alist);
               for I := 0 to Alist.Count - 1 do    // Iterate
                 begin
                     //sequence attr的值，取最大值
                     tmpstring2 :=  (TXmlNode(Alist[i])).AttributeByName['sequence'];
                     if tmpint < StrToInt(tmpstring2) then
                     begin
                          tmpint := StrToInt(tmpstring2);
                     end;
                     //lang  attr搜索
                     tmpstring := (TXmlNode(Alist[i])).AttributeByName['lang'];
                     if Pos(tmpstring,fieldEvery.st50_republication_modified_part_lang) = 0  then   //若搜索不到字符串
                     begin
                       fieldEvery.st50_republication_modified_part_lang :=  fieldEvery.st50_republication_modified_part_lang + tmpstring + ';';
                     end;
                     //modified-part-name node
                     if assigned((TXmlNode(Alist[i])).NodeByName('modified-part-name')) then
                     begin
                        fieldEvery.st50_republication_modified_part_name :=  fieldEvery.st50_republication_modified_part_name  +
                          '[' + tmpstring2 + ':' + tmpstring + ':' +(TXmlNode(Alist[i])).ReadString('modified-part-name') + '];';
                     end;
                 end;    // for
                 fieldEvery.st50_republication_modified_part_sequence := inttostr(tmpint);

           end;
           //republication-notes node
           tmpnode := st50_republication_node.NodeByName('republication-notes');
           if assigned(tmpnode) then
           begin
               Alist.Clear;
               tmpnode.NodesByName('republication-note',Alist);
               for I := 0 to Alist.Count - 1 do    // Iterate
                 begin
                    //sequence attr的值，取最大值
                     tmpstring2 :=  (TXmlNode(Alist[i])).AttributeByName['sequence'];
                     if tmpint < StrToInt(tmpstring2) then
                     begin
                          tmpint := StrToInt(tmpstring2);
                     end;
                     //lang  attr搜索
                     tmpstring := (TXmlNode(Alist[i])).AttributeByName['lang'];
                     if Pos(tmpstring,fieldEvery.st50_republication_republication_note_lang) = 0  then   //若搜索不到字符串
                     begin
                       fieldEvery.st50_republication_republication_note_lang :=  fieldEvery.st50_republication_republication_note_lang + tmpstring + ';';
                     end;
                     //modified-part-name node
                     if assigned((TXmlNode(Alist[i])).NodeByName('republication-note')) then
                     begin
                        fieldEvery.st50_republication_republication_note :=  fieldEvery.st50_republication_republication_note  +
                          '[' + tmpstring2 + ':' + tmpstring + ':' +(TXmlNode(Alist[i])).ReadString('republication-note') + '];';
                     end;
                 end;    // for
                 fieldEvery.st50_republication_republication_note_sequence := inttostr(tmpint);
           end;

           //exch:correction-notice node
           tmpnode :=  st50_republication_node.NodeByName('exch:correction-notice');
           if assigned(tmpnode) then
           begin
             if assigned(tmpnode.NodeByName('date')) then
             begin
               fieldevery.st50_republication_correction_notice_date := tmpnode.ReadString('date');
             end;
             if assigned(tmpnode.NodeByName('exch:gazette-reference')) then
             begin
                  if assigned(tmpnode.NodeByName('exch:gazette-reference').NodeByName('date')) then
                  begin
                       fieldevery.st50_republication_correction_notice_gazette_date := tmpnode.NodeByName('exch:gazette-reference').ReadString('date');
                  end;
             end;
           end;
        end;
     end;
     //***************************************************************************************end
     //***************************************************************************************start
     //exch: abstract 二级节点

     Alist.Clear;
     Anode.NodesByName('exch:abstract',Alist);
     for I := 0 to alist.Count - 1 do    // Iterate
       begin
           abstract_node       := Txmlnode(Alist[i]);
           if not(abstract_node.AttributeByName['lang'] = '') then                     begin fieldEvery.abstract_lang           :=  fieldEvery.abstract_lang         + abstract_node.AttributeByName['lang'] +';'; end;
           if not(abstract_node.AttributeByName['data-format'] = '') then              begin fieldEvery.abstract_data_format    :=  fieldEvery.abstract_data_format  + abstract_node.AttributeByName['data-format'] +';'; end;
           if not(abstract_node.AttributeByName['abstract-source'] = '') then          begin fieldEvery.abstract_source         :=  fieldEvery.abstract_source       + abstract_node.AttributeByName['abstract-source'] +';'; end;
           if not(abstract_node.AttributeByName['country'] = '') then                  begin fieldEvery.abstract_country        :=  fieldEvery.abstract_country      + abstract_node.AttributeByName['country'] +';';  end;
           if not(abstract_node.AttributeByName['doc-number'] = '') then               begin  fieldEvery.abstract_doc_number    :=  fieldEvery.abstract_doc_number   + abstract_node.AttributeByName['doc-number'] +';';  end;
           if not(abstract_node.AttributeByName['kind'] = '') then                     begin fieldEvery.abstract_kind           :=  fieldEvery.abstract_kind         + abstract_node.AttributeByName['kind'] +';';   end;
           if not(abstract_node.AttributeByName['date-publ'] = '') then                begin fieldEvery.abstract_date_publ      :=  fieldEvery.abstract_date_publ    + abstract_node.AttributeByName['date-publ']+';';  end;
           if not(abstract_node.AttributeByName['status'] = '') then                   begin fieldEvery.abstract_status         :=  fieldEvery.abstract_status       + abstract_node.AttributeByName['status']+';';     end;

           fieldEvery.abstract_p              :=  fieldEvery.abstract_p  +
              '['+abstract_node.AttributeByName['lang'] +':'+abstract_node.AttributeByName['data-format'] + ':'+
              abstract_node.AttributeByName['abstract-source'] +':'+ abstract_node.AttributeByName['country'] +':'+
              abstract_node.AttributeByName['doc-number'] +':'+ abstract_node.AttributeByName['kind']  +':' +
              abstract_node.AttributeByName['date-publ'] +':'+ abstract_node.AttributeByName['status'] +  ':'  +
              abstract_node.ReadString('exch:p') + '];';
       end;    // for
     //***************************************************************************************end
     //***************************************************************************************start
     //exch:patent_family  二级节点   仅对实例进行解析
      patent_family_node :=  Anode.NodeByName('exch:patent-family');
      if assigned(patent_family_node) then
      begin
          //3 level node
          Alist.Clear;
          patent_family_node.NodesByName('exch:family-member',alist);
          for I := 0 to alist.Count - 1 do    // Iterate
            begin
                 family_member_node := Txmlnode(Alist[i]);
                 Blist.Clear;
                 family_member_node.NodesByName('exch:application-reference',blist);
                 for I2 := 0 to blist.Count - 1 do    // Iterate
                   begin
                       if not (TxmlNode(blist[i2]).AttributeByName['is-representative'] = '') then
                       begin
                              fieldEvery.patent_family_application_reference_is := fieldEvery.patent_family_application_reference_is  + TxmlNode(blist[i2]).AttributeByName['is-representative']+';';
                       end;

                       fieldEvery.patent_family_application_reference_data_format:= fieldEvery.patent_family_application_reference_data_format + TxmlNode(blist[i2]).AttributeByName['data-format']+';';
                       tmpstring :=  TxmlNode(blist[i2]).AttributeByName['data-format'];

                       //进入document-id子节点
                       tmpNode := TXmlNode(blist[i2]).NodeByName('document-id');
                       if Assigned(tmpNode) then
                       begin

                           if Assigned(TXmlNode(tmpNode.NodeByName('country')))     then begin fieldEvery.patent_family_application_reference_country        := fieldEvery.patent_family_application_reference_country + tmpNode.ReadString('country') +';';  end;     //coutry子节点内容
                           if Assigned(TXmlNode(tmpNode.NodeByName('kind')))        then begin fieldEvery.patent_family_application_reference_kind           := fieldEvery.patent_family_application_reference_kind  +   tmpNode.ReadString('kind') +';';     end;     //kind 子节点内容
                           if Assigned(TXmlNode(tmpNode.NodeByName('date')))        then begin fieldEvery.patent_family_application_reference_date           := fieldEvery.patent_family_application_reference_date +    tmpNode.ReadString('date') + ';';      end;    //date 子节点内容
                           if Assigned(TXmlNode(tmpNode.NodeByName('doc-number'))) then
                           begin
                                fieldEvery.patent_family_application_reference_doc_number     :=   fieldEvery.patent_family_application_reference_doc_number  +
                                '[' + tmpstring +':'+ tmpNode.ReadString('doc-number') +'];';         //不同类型对应不同的doc_number 格式为：<[data-fmt:doc-number];[data-fmt:doc-number]>
                           end;
                       end;
                   end;    // for

                   Blist.Clear;
                   family_member_node.NodesByName('exch:publication-reference',blist);
                   for I2 := 0 to blist.Count - 1 do    // Iterate
                     begin
                           tmpstring2 :=  (TXmlNode(blist[i2])).AttributeByName['sequence'];
                           if tmpint < StrToInt(tmpstring2) then
                           begin
                                tmpint := StrToInt(tmpstring2);
                           end;

                           fieldEvery.patent_family_publication_reference_data_format:= fieldEvery.patent_family_publication_reference_data_format + TxmlNode(blist[i2]).AttributeByName['data-format']+';';
                           tmpstring :=  TxmlNode(blist[i2]).AttributeByName['data-format'];

                           //进入document-id子节点
                           tmpNode := TXmlNode(blist[i2]).NodeByName('document-id');
                           if Assigned(tmpNode) then
                           begin

                               if Assigned(TXmlNode(tmpNode.NodeByName('country')))     then begin fieldEvery.patent_family_publication_reference_country            := fieldEvery.patent_family_publication_reference_country + tmpNode.ReadString('country') +';';  end;     //coutry子节点内容
                               if Assigned(TXmlNode(tmpNode.NodeByName('kind')))        then begin fieldEvery.patent_family_publication_reference_kind               := fieldEvery.patent_family_publication_reference_kind  +   tmpNode.ReadString('kind') +';';     end;     //kind 子节点内容
                               if Assigned(TXmlNode(tmpNode.NodeByName('date')))        then begin fieldEvery.patent_family_publication_reference_date               := fieldEvery.patent_family_publication_reference_date +    tmpNode.ReadString('date') + ';';      end;    //date 子节点内容
                               if Assigned(TXmlNode(tmpNode.NodeByName('doc-number'))) then
                               begin
                                    fieldEvery.patent_family_publication_reference_doc_number     :=   fieldEvery.patent_family_publication_reference_doc_number  +
                                    '[' + tmpstring +':'+ tmpstring2+':'+ tmpNode.ReadString('doc-number') +'];';         //不同类型对应不同的doc_number 格式为：<[data-fmt:doc-number];[data-fmt:doc-number]>
                               end;
                           end;
                     end;    // for
                     fieldEvery.patent_family_publication_reference_sequence := inttostr(tmpint);
            end;    // for


          //3 level node
          //exch: abstract 二级节点
           Alist.Clear;
           patent_family_node.NodesByName('exch:family-member',alist);
           for I := 0 to alist.Count - 1 do    // Iterate
             begin
                 abstract_node       := Txmlnode(Alist[i]);
                 if not(abstract_node.AttributeByName['lang'] = '') then                     begin fieldEvery.patent_family_abstract_lang           :=  fieldEvery.patent_family_abstract_lang         + abstract_node.AttributeByName['lang'] +';'; end;
                 if not(abstract_node.AttributeByName['data-format'] = '') then              begin fieldEvery.patent_family_abstract_data_format    :=  fieldEvery.patent_family_abstract_data_format  + abstract_node.AttributeByName['data-format'] +';'; end;
                 if not(abstract_node.AttributeByName['abstract-source'] = '') then          begin fieldEvery.patent_family_abstract_abstract_source         :=  fieldEvery.patent_family_abstract_abstract_source       + abstract_node.AttributeByName['abstract-source'] +';'; end;
                 if not(abstract_node.AttributeByName['country'] = '') then                  begin fieldEvery.patent_family_abstract_country        :=  fieldEvery.patent_family_abstract_country      + abstract_node.AttributeByName['country'] +';';  end;
                 if not(abstract_node.AttributeByName['doc-number'] = '') then               begin  fieldEvery.patent_family_abstract_doc_number    :=  fieldEvery.patent_family_abstract_doc_number   + abstract_node.AttributeByName['doc-number'] +';';  end;
                 if not(abstract_node.AttributeByName['kind'] = '') then                     begin fieldEvery.patent_family_abstract_kind           :=  fieldEvery.patent_family_abstract_kind         + abstract_node.AttributeByName['kind'] +';';   end;
                 if not(abstract_node.AttributeByName['status'] = '') then                   begin fieldEvery.patent_family_abstract_status         :=  fieldEvery.patent_family_abstract_status       + abstract_node.AttributeByName['status']+';';     end;

                 fieldEvery.patent_family_abstract_p              :=  fieldEvery.patent_family_abstract_p  +
                    '['+abstract_node.AttributeByName['lang'] +':'+abstract_node.AttributeByName['data-format'] + ':'+
                    abstract_node.AttributeByName['abstract-source'] +':'+ abstract_node.AttributeByName['country'] +':'+
                    abstract_node.AttributeByName['doc-number'] +':'+ abstract_node.AttributeByName['kind']  +':' +
                    abstract_node.AttributeByName['status'] +  ':' +
                    abstract_node.ReadString('p') + '];';
             end;    // for
      end;



      {bibliographic_data_Node.Free;
      abstract_node.Free;
      patent_family_node.Free;}
      Alist.Clear;
      Blist.Clear;
      Clist.Clear;
      Alist.Free;
      Blist.Free;
      Clist.Free;

end;
end.
