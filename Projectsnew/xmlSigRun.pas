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
    FieldEvery:FieldRecord;           //ȫ��field����
    docEvery:docRecord;               //ȫ��doc����
    file_tianwei:TextFile;            //���ݴ洢�ļ���
    usedCnt:Integer;                  //���մ������ݴ洢�ļ�����

    procedure ParseElement(ANode:TXmlNode);             //��ÿ����¼���н���
    procedure savetianweiFile();                        //��ʱ���浽txt�ļ���
    procedure saveDocRecord();                         //�洢�ĵ���Ϣ�������ݿ���
    function  checkField(Instring:string):string;            //���field��ת����ַ����д���
    procedure openDB();                                      //�����ݿ�
    function  checkFileName(Filename:string):Boolean;        //�����ݿ��м���ļ��Ƿ����
    procedure SavefileName(Filename:string;cnt:integer);                 //���ɹ��󣬽���ɵ��ļ�д�����ݿ���
    procedure runSingleFile(filename:string);
    procedure BatchRun();                                 //���������
  public
    { Public declarations }
  end;

var
  sigRun: TsigRun;

implementation
uses dataModuleSig;
{$R *.dfm}

procedure TsigRun.saveDocRecord();                         //�洢�ĵ���Ϣ�������ݿ���
var
  sql:string;
begin
     {commondoc :=TCommonOperator.Create;
     commondoc.OperatorDS :=@DataModuleTest.ds1;     //�������ݼ�
     commondoc.TableDesc := '�ļ���Ϣ��';
     commondoc.TableName :='docInfomation';
     commondoc.PrimaryFieldName :='file_name';                        //��������

     commondoc.Open;
     sql := 'select * from docInfomation';
     commondoc.SqlStr := sql;
     commondoc.ExecSql; }
end;

function TsigRun.checkField(InString:string):string;
var
  tmp:string;
begin
     //��д�����ݵ��ַ�����ת�崦��
     //��Ҫ����ķ��棺1.�����ַ������ַ���    2.dtd����(���ݾ����˵���ĵ�����)
     //tmp := StringReplace(Instring,'''','''''',[rfReplaceAll]);    //!!!�˴����ܲ���Ҫ
     //���ַ�������
     tmp:= Instring;
     if tmp = '' then
      tmp := ' ';

     Result := tmp;
end;

procedure TsigRun.savetianweiFile();
var
  sql :string;
begin
     //��ÿһ����¼д��txt�ı���
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


function  TsigRun.checkFileName(Filename:string):Boolean;        //�����ݿ��м���ļ��Ƿ����
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
    //���ڳ�ʼ������ʱ
    BatchRun();
end;

procedure TsigRun.SavefileName(Filename:string;cnt:integer);                 //���ɹ��󣬽���ɵ��ļ�д�����ݿ���
var
  sql:string;
begin
   sql := 'insert into finishFile (filename,startTime,finishTime,usedTime) VALUES (''' +
       FileInfo.filename + ''',''' + FileInfo.startTime + ''',''' +
       FileInfo.endTime  + ''',''' + FileInfo.usedTime + ''')';
   //ShowMessage(sql);
   commonFile.SqlStr := sql;
   commonFile.ExecSqlUpdate;    //insert ֻ���ø������
end;

procedure TsigRun.openDB();                                      //�����ݿ�
var
  sql:string;
begin
     commonFile :=TCommonOperator.Create;
     commonFile.OperatorDS :=@DataModule1.ds1;     //�������ݼ�
     commonFile.TableDesc := '�ļ���Ϣ��';
     commonFile.TableName :='finishFile';
     commonFile.PrimaryFieldName :='filename';                        //��������

     commonFile.Open;
end;

//ÿ���ļ���������
procedure TsigRun.runSingleFile(filename:string);
var
  starttick:Integer;
  endtick:Integer;
  starttickWhole:Integer;
  endtickWhole:Integer;
  cnt:Integer;
  ANode:TXmlNode;           //xml�ڵ���
  AList:TList;              //�б���
  recordID:Integer;         //��¼keyֵ
  tmp:string;                 //��ʱ�ַ���
  docTypeNode:TXmlNode;
  tmp2:string;
  storeFileName:string;    //�ļ���������
  xmlRun:TNativeXml;
begin
     //�������ļ�����
     //��ʼ��ʾ

     mmoDebug.Lines.Append('������������'+filename+'������Ϣ,��ǰʱ��Ϊ��'+TimeToStr(Time));
     starttickWhole := GetTickCount;

     //��ʼ��
     recordID := 0;
     mmoDebug.Lines.Add('-------------------------------------------');
     //XML�ļ�����
     xmlRun := TNativeXml.Create;
     try
        //step0: �����ļ�
        try
           FileInfo.startTime := TimeToStr(Time);
           tmp := '��ʼ�����ļ�����ǰʱ��Ϊ:' + TimeToStr(Time); mmoDebug.Lines.Add(tmp);
           starttick := GetTickCount;

           xmlRun.LoadFromFile(filename);  //��ָ���ļ�������XML ,�Զ����н���ʱ��������XML�﷨�淶

           endtick   := GetTickCount;
           tmp := '��ϲ�ɹ������ļ�����ǰʱ��Ϊ:' + TimeToStr(Time); mmoDebug.Lines.Add(tmp);
           tmp := '-->�����ļ�����ʱ:'+floattostr((endtick- starttick)/1000.0)+'��'; mmoDebug.Lines.Add(tmp);
        except;
           ShowMessage('��ע����XML�ļ���ʽ����');
        end;

        //step1:ɾ��DOCTYPE�ڵ㣬����������root�ڵ�
        docTypeNode := xmlRun.RootNodeList.NodeByName('exch:exchange-documents');
        if Assigned(docTypeNode) then
        begin
             xmlRun.RootNodeList.NodeRemove(docTypeNode);
        end;

        //step2: �������ݴ洢�ļ�
        storeFileName := 'E:\txt\1\' + extractfilename(filename) + '.tianwei';
        //ShowMessage(storeFileName);
        AssignFile(file_tianwei,storeFileName);
        Rewrite(file_tianwei);

        //step3: �����б���
        AList := TList.Create;
        try
          ANode := xmlRun.RootNodeList.NodeByName('exch:exchange-documents');    //ָ�����ڵ�
          if not Assigned(ANode) then
          begin
            ShowMessage('root�ڵ㷢����������');
            exit;
          end;
          //�������ڵ�����
          FillChar(docEvery,SizeOf(docEvery),0);    //�ṹ���ʼ��
          docEvery.date_of_exchange    := ANode.AttributeByName['date-of-exchange'];
          docEvery.dtd_version         := ANode.AttributeByName['dtd-version'];
          docEvery.file_name           := ANode.AttributeByName['file'];
          docEvery.no_of_documents     := ANode.AttributeByName['no-of-documents'];
          docEvery.originating_office  := ANode.AttributeByName['originating-office'];

          //step4����ÿһ����¼�г����� exch:exchange-document Ϊһ�����㣬�г�list����
          ANode.NodesByName('exch:exchange-document',AList);

          //step5: ��ÿһ����¼����
          tmp := '��ʼ������¼����ǰʱ��Ϊ:' +  TimeToStr(Time); mmoDebug.Lines.Add(tmp);
          starttick := GetTickCount;

          for cnt := 0 to AList.Count - 1 do    // Iterate
            begin
               ParseElement(Alist[cnt]);       //��ÿ����¼���н���
               fieldEvery.FieldId := docEvery.file_name+ ':' + IntToStr(recordID);            //keyֵ���
               recordID := recordID +1;
               savetianweiFile();                             //��ÿ����¼�洢��txt�ļ���
               //tmp2 := IntToStr(recordID) + ' ';
               //mmodbg.Lines.Append(tmp2);
            end;    // for

          endtick   := GetTickCount;
          tmp := '��ϲ�ɹ�����������м�¼����ǰʱ��Ϊ:' + TimeToStr(Time); mmoDebug.Lines.Add(tmp);
          tmp := '-->�����ļ�����ʱ:'+floattostr((endtick- starttick)/1000.0)+'��'; mmoDebug.Lines.Add(tmp);
          FileInfo.endTime := TimeToStr(Time);
          FileInfo.usedTime := floattostr((endtick- starttick)/1000.0)+'��';

          //�ļ��洢
          //saveDocRecord();
        finally
          AList.Free;    //!!!!Alist�Ż������������
        end;
        //step5:�ر��ļ�
        CloseFile(file_tianwei);
     finally
        FreeAndNil(xmlRun);
     end;

     //������ʾ
     endtickWhole   := GetTickCount;
     mmoDebug.Lines.Append('(*_*)Success!���'+filename+'������Ϣ,����ʱ��Ϊ��'+TimeToStr(Time)+'����ʱ�乲��'+floattostr(((endtickWhole-starttickWhole)/1000.0)/60)+'����');
     mmoDebug.Lines.Append('<------------end------------->');
end;

procedure TsigRun.BatchRun();
var
  I:Integer;
  storeFileName:string;
begin
      //�������ݿ�
     openDB();

     //step1:���ݳ������в�������ȡ�ļ����б�
     if ParamCount = 0 then
     begin
        ShowMessage('��ʾ����ѡ�������ļ������������ļ�������');
        Exit;
     end;
     //step2:д��¼
     for  I:= 1 to ParamCount  do
     begin
          if ParamStr(I) <> ' ' then
          begin
            mmoDebug.Lines.Add(ParamStr(I));
          end;

          //runSingleFile(ParamStr(I));
          //Fileinfo.filename := ExtractFileName(ParamStr(I));
          //SavefileName(ParamStr(I),I);    //д���ļ����͵�ǰ����
     end;

     FillChar(fieldEvery,SizeOf(fieldEvery),0);
     mmoDebug.Lines.Append('�ܹ���:'+inttostr(ParamCount)+'���ļ�');
end;

procedure TsigRun.ParseElement(ANode:TXmlNode);       //��ÿ����¼���н���
var
  cnt:Integer;
  bibliographic_data_Node:TXmlNode;         //�����ڵ�
  abstract_node:TXmlNode;                   //�����ڵ�
  publication_reference_node:TXmlNode;      //�����ڵ�
  classification_ipc_node:TXmlNode;         //�����ڵ�
  classification_ipcr_node:TXmlNode;        //�����ڵ�
  classification_national_node:TXmlNode;    //�����ڵ�
  classification_ecla_node:TXmlNode;        //�����ڵ�
  priority_claims_node:TXmlNode;            //�����ڵ�
  patries_node:TXmlNode;                    //�����ڵ�
  patries_applicants_node:TXmlNode;         //�ļ��ڵ�
  patries_inventors_node:TXmlNode;          //�ļ��ڵ�
  invention_title_node:TXmlNode;            //�����ڵ�
  dates_of_public_availability_node:TXmlNode;   //�����ڵ�
  dates_of_public_availability_unexamined_node:TXmlNode;  //�ļ��ڵ�
  dates_of_public_availability_printed_node:TXmlNode;     //�ļ��ڵ�
  previously_filed_app_node:TXmlNode;            //�����ڵ� ++
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
  Alist:TList;                              //��ʱ�б�
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
     //�ֶγ�ʼ��
     AList := TList.Create;                 //����Alist
     Blist := TList.Create;
     Clist := TList.Create;
     tmpint := 0;
     FillChar(fieldEvery,SizeOf(fieldEvery),0);

     //��ÿһ�н��н�����������Լ5M����
     //exch:exchange-document һ���ڵ�
     //һ���ڵ�����ֵ
     fieldEvery.country                    :=  ANode.AttributeByName['country'];
     fieldEvery.doc_number                 :=  ANode.AttributeByName['doc-number'];
     fieldEvery.kind                       :=  ANode.AttributeByName['kind'];
     fieldEvery.date_publ                  :=  ANode.AttributeByName['date-publ'];
     fieldEvery.family_id                  :=  ANode.AttributeByName['family-id'];
     fieldEvery.is_representative          :=  ANode.AttributeByName['is-representative'];
     fieldEvery.date_of_last_exchange      :=  ANode.AttributeByName['date-of-last-exchange'];
     fieldEvery.date_added_docdb           :=  ANode.AttributeByName['date-added-docdb'];
     fieldEvery.originating_office         :=  ANode.AttributeByName['originating-office'];           //�������Ƿ�����������
     //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
     FieldEvery.date_of_previous_exchange  :=  ANode.AttributeByName['date-of-previous-exchange'];
     FieldEvery.status                     :=  ANode.AttributeByName['status'];
     //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
     //exch:bibliographic-data �����ڵ�
     bibliographic_data_Node :=  ANode.NodeByName('exch:bibliographic-data');
     if Assigned(bibliographic_data_Node) then
     begin
         //***************************************************************************************start
         //publication_reference �����ڵ�,�����ýڵ�::˵���ĵ�P43��Щ��������
         Alist.clear;
         bibliographic_data_Node.NodesByName('exch:publication-reference',Alist);
         for I:=0 to Alist.Count-1  do
         begin
            tmpstring :=  TXmlNode(Alist[i]).AttributeByName['data-format'];
            fieldEvery.publication_reference_data_format    :=   fieldEvery.publication_reference_data_format +
                  tmpstring + ',';

            //�����ӽڵ�:document-id
            tmpNode := TXmlNode(Alist[i]).NodeByName('document-id');
            if Assigned(tmpNode) then
            begin
                 //��ȡ����lang
                 tmplang := tmpNode.AttributeByName['lang'];
                 if not (tmplang = '')                                    then begin FieldEvery.publication_reference_doc_lang       :=    FieldEvery.publication_reference_doc_lang + '[' + tmpstring +':'+ tmplang +'];'    end;
                 if Assigned(TXmlNode(tmpNode.NodeByName('country')))     then begin fieldEvery.publication_reference_country        :=    tmpNode.ReadString('country');  end;     //coutry�ӽڵ�����
                 if Assigned(TXmlNode(tmpNode.NodeByName('kind')))        then begin fieldEvery.publication_reference_kind           :=    tmpNode.ReadString('kind');     end;     //kind �ӽڵ�����
                 if Assigned(TXmlNode(tmpNode.NodeByName('date')))        then begin fieldEvery.publication_reference_date           :=    tmpNode.ReadString('date');      end;    //date �ӽڵ�����
                 if Assigned(TXmlNode(tmpNode.NodeByName('doc-number'))) then
                 begin
                      fieldEvery.publication_reference_doc_number     :=    fieldEvery.publication_reference_doc_number +
                      '[' + tmpstring +':'+ tmpNode.ReadString('doc-number') +'];';         //��ͬ���Ͷ�Ӧ��ͬ��doc_number ��ʽΪ��<[data-fmt:doc-number];[data-fmt:doc-number]>
                 end;
            end;
         end;
         //***************************************************************************************end
         //***************************************************************************************start
         //exch:previously-filed-app �����ڵ�
          Alist.Clear;
          bibliographic_data_Node.NodesByName('exch:previously-filed-app',Alist);     //���ֿ��Կ��ǳ��ֶ�������
          for I:=0 to Alist.Count-1 do
          begin
             //����ýڵ�,ֱ�ӻ�ȡ����!!!!ע��ֱ�Ӷ�ȡ�ڵ�ķ���������ValueAsString
             FieldEvery.previously_filed_app_text := FieldEvery.previously_filed_app_text + TxmlNode(AList[i]).ValueAsString + ';';
			// FieldEvery.previously_filed_app_text := FieldEvery.previously_filed_app_text + bibliographic_data_Node.ReadString('exch:previously-filed-app') +';' ;
          end;
         //***************************************************************************************end
          //***************************************************************************************start
         //<exch:preceding-publication-date> �����ڵ�
         Alist.Clear;
         bibliographic_data_Node.NodesByName('exch:preceding-publication-date',Alist);     //���ֿ��Կ��ǳ��ֶ�������
          for I:=0 to Alist.Count-1 do
          begin
             //����ýڵ�,ֱ�ӻ�ȡ����
             FieldEvery.preceding_publication_date := FieldEvery.preceding_publication_date + (TXmlNode(Alist[i])).ReadString('date') +';' ;
          end;
         //***************************************************************************************end
          //***************************************************************************************start
         //<exch:date-of-coming-into-force>�����ڵ�
         Alist.Clear;
         bibliographic_data_Node.NodesByName('exch:date-of-coming-into-force',Alist);     //���ֿ��Կ��ǳ��ֶ�������
          for I:=0 to Alist.Count-1 do
          begin
             //����ýڵ�,ֱ�ӻ�ȡ����
             FieldEvery.date_of_coming_into_force_date := FieldEvery.date_of_coming_into_force_date + (TXmlNode(Alist[i])).ReadString('date') +';' ;
          end;
         //***************************************************************************************end
         //***************************************************************************************start
         //<exch:extended-kind-code>�����ڵ�
         Alist.Clear;
         bibliographic_data_Node.NodesByName('exch:extended-kind-code',Alist);     //���ֿ��Կ��ǳ��ֶ�������
          for I:=0 to Alist.Count-1 do
          begin
             //����ýڵ�,ֱ�ӻ�ȡ����,��ֱ�Ӵ洢dataformat��������[dataformat:code]��ʽ�洢
             {FieldEvery.extended_kind_code := FieldEvery.extended_kind_code +
               '['+(TXmlNode(Alist[i])).AttributeByName['data-format'] +':'+ bibliographic_data_Node.ReadString('exch:extended-kind-code') +'];' ;}
			 FieldEvery.extended_kind_code := FieldEvery.extended_kind_code +
               '['+(TXmlNode(Alist[i])).AttributeByName['data-format'] +':'+ TxmlNode(AList[i]).ValueAsString +'];' ;
		  end;
         //***************************************************************************************end
         //***************************************************************************************start
         //exch:classification-ipc  �����ڵ�
         classification_ipc_node := bibliographic_data_Node.NodeByName('exch:classification-ipc');
         if Assigned(classification_ipc_node) then
         begin
           //����ýڵ㣬����text�ڵ�
           Alist.Clear;            //��ʼ�����ܴ�������
           classification_ipc_node.NodesByName('text',Alist);
           for I := 0 to Alist.Count - 1 do    // Iterate
             begin
                 //fieldEvery.classification_ipc_text := fieldEvery.classification_ipc_text + classification_ipc_node.ReadString('text') +';';
				 fieldEvery.classification_ipc_text := fieldEvery.classification_ipc_text + TxmlNode(AList[i]).ValueAsString +';';
             end;    // for
           //����ýڵ㣬����edition�ڵ�
           Alist.Clear;
           classification_ipc_node.NodesByName('edition',Alist);
           for I := 0 to Alist.Count - 1 do    // Iterate
             begin
                 //FieldEvery.classification_ipc_edition := FieldEvery.classification_ipc_edition + classification_ipc_node.ReadString('edition') +';';
				 FieldEvery.classification_ipc_edition := FieldEvery.classification_ipc_edition + TxmlNode(AList[i]).ValueAsString +';';
             end;    // for
           //����ýڵ㣬����main-classification�ڵ�
           Alist.Clear;
           classification_ipc_node.NodesByName('main-classification',Alist);
           for I := 0 to Alist.Count - 1 do    // Iterate
             begin
                // FieldEvery.classification_ipc_main_class := FieldEvery.classification_ipc_main_class + classification_ipc_node.ReadString('edition') +';';
				 FieldEvery.classification_ipc_main_class := FieldEvery.classification_ipc_main_class + TxmlNode(AList[i]).ValueAsString +';';
			 end;    // for
           //����ýڵ㣬����further-classification�ڵ�
           Alist.Clear;
           classification_ipc_node.NodesByName('further-classification',Alist);
           for I := 0 to Alist.Count - 1 do    // Iterate
             begin
                // FieldEvery.classification_ipc_further_class := FieldEvery.classification_ipc_further_class + classification_ipc_node.ReadString('further-classification') +';';
				FieldEvery.classification_ipc_further_class := FieldEvery.classification_ipc_further_class + TxmlNode(AList[i]).ValueAsString +';';
			 end;    // for
           //����ýڵ㣬����additional-info�ڵ�
           Alist.Clear;
           classification_ipc_node.NodesByName('additional-info',Alist);
           for I := 0 to Alist.Count - 1 do    // Iterate
             begin
                // FieldEvery.classification_ipc_additional_info := FieldEvery.classification_ipc_additional_info + classification_ipc_node.ReadString('additional-info') +';';
                 FieldEvery.classification_ipc_additional_info := FieldEvery.classification_ipc_additional_info + TxmlNode(AList[i]).ValueAsString +';';

			 end;    // for
           //����ýڵ㣬����unlinked-indexing-code�ڵ�
           Alist.Clear;
           classification_ipc_node.NodesByName('unlinked-indexing-code',Alist);
           for I := 0 to Alist.Count - 1 do    // Iterate
             begin
                 //FieldEvery.classification_ipc_unlinked_indexing_code := FieldEvery.classification_ipc_unlinked_indexing_code + classification_ipc_node.ReadString('unlinked-indexing-code') +';';
                 FieldEvery.classification_ipc_unlinked_indexing_code := FieldEvery.classification_ipc_unlinked_indexing_code + TxmlNode(AList[i]).ValueAsString +';';
			 end;    // for
           //����ýڵ㣬����linked-indexing-code-group�ڵ�
           Alist.Clear;
           classification_ipc_node.NodesByName('linked-indexing-code-group',Alist);
           for I := 0 to Alist.Count - 1 do    // Iterate
             begin

                 //linked-indexing-code �ڲ�Ƕ�׶���ڵ�������û�п��ǣ�������
                 FieldEvery.classification_ipc_linked_indexing_code_group_main := FieldEvery.classification_ipc_linked_indexing_code_group_main +(TXmlNode(Alist[i])).ReadString('main-linked-indexing-code') +';';
                 FieldEvery.classification_ipc_linked_indexing_code_group_sub  := FieldEvery.classification_ipc_linked_indexing_code_group_sub  +(TXmlNode(Alist[i])).ReadString('sub-linked-indexing-code') +';';
             end;    // for

         end;
         //***************************************************************************************end
         //***************************************************************************************start
         //exch:classification-ipcr  �����ڵ�
         classification_ipcr_node := bibliographic_data_Node.NodeByName('exch:classifications-ipcr');
         if Assigned(classification_ipcr_node) then
         begin
           //����ýڵ㣬�����ڵ� classification-ipcr
           Alist.Clear;            //��ʼ�����ܴ�������
           tmpint := 0;
           classification_ipcr_node.NodesByName('classification-ipcr',Alist);
           for I := 0 to Alist.Count - 1 do    // Iterate
             begin
                 //ͨ����ͬ��sequence��������
                 //sequence��ֵ��ȡ���ֵ
                 tmpstring :=  (TXmlNode(Alist[i])).AttributeByName['sequence'];
                 if tmpint < StrToInt(tmpstring) then
                 begin
                   tmpint := StrToInt(tmpstring);
                 end;
                 //ȡtext��ֵ
                  //��ȡ�ڵ�list�������ַ�����Ϊsequence+text��Ӧ����ʽΪ<[sequence:text];[sequence:text]>
                 fieldEvery.classifications_ipcr_text := fieldEvery.classifications_ipcr_text +
                  '['+tmpstring+':'+TXmlNode(Alist[i]).ReadString('text')+'];' ;
             end;    // for
             fieldEvery.classifications_ipcr_num := IntToStr(tmpint);             //�������ֵ ���ԣ���ֵΪsequence����ֵ������Ϊ���ֵ
         end;
         //***************************************************************************************end
         //***************************************************************************************start
         //exch:classification-national  �����ڵ�
         classification_national_node := bibliographic_data_Node.NodeByName('exch:classification-national');
         if Assigned(classification_national_node) then
         begin
            //����ýڵ㣬�����ڵ�text
            Alist.Clear;
            classification_national_node.NodesByName('text',Alist);
            for I := 0 to Alist.Count - 1 do    // Iterate
              begin
                 //!!!!!!!!!!!!ע��ֱ�Ӷ�ȡ�ڵ�ķ���������ValueAsString,�������readstring������һֱ���ʵ�һ���ڵ�
                 fieldEvery.classification_national_text :=  fieldEvery.classification_national_text +TXmlNode(alist[i]).ValueAsString + ';';
              end;    // for
         end;
         //***************************************************************************************end
         //***************************************************************************************start
         //classification-ecla �����ڵ�,�����ýڵ�
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
         //exch:application-reference  �����ڵ�,�����ýڵ�
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

             //����document-id�ӽڵ�
             tmpNode := TXmlNode(Alist[i]).NodeByName('document-id');
             if Assigned(tmpNode) then
             begin
                 if not (tmpNode.AttributeByName['lang'] = '')            then begin FieldEvery.application_reference_doc_lang       :=    FieldEvery.application_reference_doc_lang  + tmpNode.AttributeByName['lang'] +';'; end;
                 if Assigned(TXmlNode(tmpNode.NodeByName('country')))     then begin fieldEvery.application_reference_country        :=    tmpNode.ReadString('country');  end;     //coutry�ӽڵ�����
                 if Assigned(TXmlNode(tmpNode.NodeByName('kind')))        then begin fieldEvery.application_reference_kind           :=    tmpNode.ReadString('kind');     end;     //kind �ӽڵ�����
                 if Assigned(TXmlNode(tmpNode.NodeByName('date')))        then begin fieldEvery.application_reference_date           :=    tmpNode.ReadString('date');      end;    //date �ӽڵ�����
                 if Assigned(TXmlNode(tmpNode.NodeByName('doc-number'))) then
                 begin
                      fieldEvery.application_reference_doc_number     :=    fieldEvery.application_reference_doc_number +
                      '[' + tmpstring +':'+ tmpNode.ReadString('doc-number') +'];';         //��ͬ���Ͷ�Ӧ��ͬ��doc_number ��ʽΪ��<[data-fmt:doc-number];[data-fmt:doc-number]>
                 end;
             end;
           end;    // for
         //***************************************************************************************end
         //***************************************************************************************start
         //exch:language-of-filing û���Ƕ���ڵ�����
         language_of_filing_node := bibliographic_data_Node.NodeByName('exch:language-of-filing');
         if Assigned(language_of_filing_node) then
         begin
           FieldEvery.language_of_filing_statue := language_of_filing_node.AttributeByName['status'];
           FieldEvery.language_of_filing_text := bibliographic_data_Node.ReadString('exch:language-of-filing');            //!!!���ܴ������⣬��Ϊû��ʵ��
         end;
         //***************************************************************************************end
         //***************************************************************************************start
         //exch:language-of-publication
         language_of_publication_node := bibliographic_data_Node.NodeByName('exch:language-of-publication');
         if Assigned(language_of_publication_node) then
         begin
           FieldEvery.language_of_publication_status := language_of_publication_node.AttributeByName['status'];
           FieldEvery.language_of_publication_text   := bibliographic_data_Node.ReadString('exch:language-of-publication');       //!!!���ܴ������⣬��Ϊû��ʵ��
         end;
         //***************************************************************************************end
         //***************************************************************************************start
         //exch:priority-claims �����ڵ�
         priority_claims_node := bibliographic_data_Node.NodeByName('exch:priority-claims');
         if Assigned(priority_claims_node) then
         begin
           //����ýڵ㣬�������ӽڵ�
           tmpint := 0;
           Alist.Clear;
           priority_claims_node.NodesByName('exch:priority-claim',Alist);
           for I := 0 to Alist.Count - 1 do    // Iterate
             begin
                 //ͨ����ͬ��sequence��������
                 //sequence��ֵ��ȡ���ֵ
                 tmpstring2 :=  (TXmlNode(Alist[i])).AttributeByName['sequence'];
                 if tmpint < StrToInt(tmpstring2) then
                 begin
                   tmpint := StrToInt(tmpstring2);
                 end;
                 //data-format����,��Ҫ����֪�Ĵ��н�������
                 tmpstring := (TXmlNode(Alist[i])).AttributeByName['data-format'];
                 if Pos(tmpstring,fieldEvery.priority_claims_data_format) = 0 then   //�����������ַ���
                 begin
                   fieldEvery.priority_claims_data_format :=  fieldEvery.priority_claims_data_format + tmpstring + ';';
                 end;
                 //status����
                 if not ((TXmlNode(Alist[i])).AttributeByName['status'] = '' ) then
                 begin
                   FieldEvery.priority_claims_status := FieldEvery.priority_claims_status +
                   '[' +tmpstring2+':'+tmpstring+':'+(TXmlNode(Alist[i])).AttributeByName['status']+ '];';
                 end;

                 //docment-id�ڵ���봦��
                 //����document-id�ӽڵ�
                 tmpNode := TXmlNode(Alist[i]).NodeByName('document-id');
                 if Assigned(tmpNode) then
                 begin
                     if not (tmpNode.AttributeByName['lang'] = '')            then begin FieldEvery.priority_claims_doc_lang       :=    FieldEvery.priority_claims_doc_lang  + tmpNode.AttributeByName['lang'] +';'; end;
                     if Assigned(TXmlNode(tmpNode.NodeByName('country')))     then begin fieldEvery.priority_claims_country        :=    tmpNode.ReadString('country');  end;     //coutry�ӽڵ�����
                     if Assigned(TXmlNode(tmpNode.NodeByName('kind')))        then begin fieldEvery.priority_claims_kind           :=    tmpNode.ReadString('kind');     end;     //kind �ӽڵ�����
                     if Assigned(TXmlNode(tmpNode.NodeByName('date')))        then begin fieldEvery.priority_claims_date           :=    tmpNode.ReadString('date');      end;    //date �ӽڵ�����
                     if Assigned(TXmlNode(tmpNode.NodeByName('doc-number'))) then
                     begin
                          fieldEvery.priority_claims_doc_number     :=    fieldEvery.priority_claims_doc_number +
                          '[' +tmpstring2+':'+tmpstring +':'+ tmpNode.ReadString('doc-number') +'];';         //��ͬ���Ͷ�Ӧ��ͬ��doc_number ��ʽΪ��<[sequence:data-fmt:doc-number];[data-fmt:doc-number]>
                     end;
                 end;
             end;    // for
             //sequence��ֵ��ȡ���ֵ�����ǿ��ܴ��ڵ�����
             fieldEvery.priority_claims_sequence := IntToStr(tmpint);
         end;
         //***************************************************************************************end
         //***************************************************************************************start
         //exch:parties �����ڵ�
         patries_node := bibliographic_data_Node.NodeByName('exch:parties');
         if Assigned(patries_node) then
         begin
           //����ýڵ�
           //������һ���ڵ�
           patries_applicants_node := patries_node.NodeByName('exch:applicants');
           if Assigned(patries_applicants_node) then
           begin
              //����ýڵ�
              Alist.Clear;
              tmpint := 0;
              patries_applicants_node.NodesByName('exch:applicant',Alist);
              for I := 0 to Alist.Count - 1 do    // Iterate
                begin
                     //ͨ����ͬ��sequence��������
                     //sequence��ֵ��ȡ���ֵ
                     tmpstring2 :=  (TXmlNode(Alist[i])).AttributeByName['sequence'];
                     if tmpint < StrToInt(tmpstring2) then
                     begin
                          tmpint := StrToInt(tmpstring2);
                     end;
                     //data-format����,��Ҫ����֪�Ĵ��н�������
                     tmpstring := (TXmlNode(Alist[i])).AttributeByName['data-format'];
                     if Pos(tmpstring,fieldEvery.patries_applicants_data_format) = 0  then   //�����������ַ���
                     begin
                       fieldEvery.patries_applicants_data_format :=  fieldEvery.patries_applicants_data_format + tmpstring + ';';
                     end;
                     //status����
                     if not ((TXmlNode(Alist[i])).AttributeByName['status'] = '' ) then
                     begin
                     FieldEvery.patries_applicants_status := FieldEvery.patries_applicants_status +
                     '[' +tmpstring2+':'+tmpstring+':'+(TXmlNode(Alist[i])).AttributeByName['status']+ '];';
                     end;
                     //����ýڵ���н���
                     tmpNode := TXmlNode(Alist[i]).NodeByName('exch:applicant-name');
                     if Assigned(tmpNode) then
                     begin
                       //��û�п���patries_applicants_name_data_format,��Ϊ��(TXmlNode(Alist[i])).AttributeByName['data-format'];�ظ�
                       fieldEvery.patries_applicants_name := fieldEvery.patries_applicants_name +
                         '['+ tmpstring2 + ':' + tmpstring + ':' + tmpNode.ReadString('name')+'];';
                     end;
                     tmpInNode :=TXmlNode(Alist[i]).NodeByName('residence');
                     if Assigned(tmpInNode) then
                     begin
                          fieldEvery.patries_applicants_country := tmpInNode.ReadString('country');       //�����Ƿ�Ҫ��չ
                     end;
                     tmpInNode := TXmlNode(Alist[i]).NodeByName('address');
                     if Assigned(tmpInNode)  then
                     begin
                          fieldEvery.patries_applicants_address := tmpInNode.ReadString('text');          //�����Ƿ�Ҫ��չ
                     end;
                end;    // for
                fieldEvery.patries_applicants_sequence := IntToStr(tmpint);
           end;
           //������һ���ڵ�
           patries_inventors_node  := patries_node.NodeByName('exch:inventors');
           if Assigned(patries_inventors_node) then
           begin
             //����ýڵ�
             Alist.Clear;
             tmpint := 0;
             patries_inventors_node.NodesByName('exch:inventor',Alist);
             for I := 0 to Alist.Count - 1 do    // Iterate
               begin
                     //ͨ����ͬ��sequence��������
                     //sequence��ֵ��ȡ���ֵ
                     tmpstring2 :=  (TXmlNode(Alist[i])).AttributeByName['sequence'];
                     if tmpint < StrToInt(tmpstring2) then
                     begin
                          tmpint := StrToInt(tmpstring2);
                     end;
                     //data-format����,��Ҫ����֪�Ĵ��н�������
                     tmpstring := (TXmlNode(Alist[i])).AttributeByName['data-format'];
                     if Pos(tmpstring,fieldEvery.patries_inventors_data_format) = 0 then   //�����������ַ���
                     begin
                       fieldEvery.patries_inventors_data_format :=  fieldEvery.patries_inventors_data_format + tmpstring + ';';
                     end;
                     //status����
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
                //!!!!!!�˴�������һ��EPC,PCT,Other�ڵ����
                // EPC�ڵ�
                designation_of_states_EPC_node := Txmlnode(Alist[i]).NodeByName('exch:designation-epc');
                if Assigned(designation_of_states_EPC_node ) then
                begin
                    //�˴�������ʵ������һ���ڵ�
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
                //PCT �ڵ�
                designation_of_states_PCT_node := TXmlNode(Alist[i]).NodeByName('designation-PCT');
                if Assigned( designation_of_states_PCT_node) then
                begin
                   Blist.Clear;
                   //regional
                   designation_of_states_PCT_node.NodesByName('regional',Blist);
                   for I2 := 0 to Blist.Count - 1 do    // Iterate
                     begin
                       //region�ڵ�
                       tmpNode :=  TXmlNode(Blist[i2]).NodeByName('region');
                       if Assigned(tmpNode) then
                       begin
                         FieldEvery.designation_of_states_PCT_regional_country := FieldEvery.designation_of_states_PCT_regional_country +
                          tmpNode.ReadString('country') + ';';
                       end;
                       //country�ڵ�
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
                //Other�ڵ�
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
         //exch:invention-title �����ڵ�     !!! �˴����ݿⷢ�����ģ�����
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
         //exch:dates-of-public-availability �����ڵ�     !!! �˴�������ʾ������ !!!��û�п��ǳ��ֶ�����
         dates_of_public_availability_node := bibliographic_data_Node.NodeByName('exch:dates-of-public-availability');
         if Assigned(dates_of_public_availability_node) then
         begin
           //������һ��
            //exch:unexamined-printed-without-grant �ڵ�
            dates_of_public_availability_unexamined_node := dates_of_public_availability_node.NodeByName('exch:unexamined-printed-without-grant');
            if Assigned(dates_of_public_availability_unexamined_node) then
            begin    //!!!!!!!!!!!!!!!!!!!�˴�˵���ĵ���ʵ����ͬ��ע��
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
            //exch:printed-with-grant �ڵ�
            dates_of_public_availability_printed_node    := dates_of_public_availability_node.NodeByName('exch:printed-with-grant');
            if Assigned(dates_of_public_availability_printed_node) then
            begin
              tmpNode := dates_of_public_availability_printed_node.NodeByName('document-id');
              if Assigned(tmpNode) then
              begin
                fieldEvery.dates_of_public_availability_printed := tmpNode.ReadString('date');
              end;
            end;
            //gazette-reference �ڵ�   !!! �˴�������ʾ������ !!!��û�п��ǳ��ֶ�����
            tmpNode := TXmlNode(dates_of_public_availability_node.NodeByName('exch:gazette-reference'));
            if Assigned(tmpNode) then
            begin
              //�˴����Ƕ������������˵���ĵ��;��������������Ϊ�˷�ֹ�����ݣ�ȫ�濼��
              tmpInNode := tmpNode.NodeByName('document-id');
              if Assigned( tmpInNode ) then
              begin
                FieldEvery.dates_of_public_availability_gazette_reference :=FieldEvery.dates_of_public_availability_gazette_reference + tmpInNode.ReadString('date') + ';' ;
              end;
              FieldEvery.dates_of_public_availability_gazette_reference := FieldEvery.dates_of_public_availability_gazette_reference  + tmpNode.ReadString('date');
            end;
            //abstract-reference �ڵ�   !!! �˴�������ʾ������ !!!��û�п��ǳ��ֶ�����
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
            //supplemental-srep-reference �ڵ�   !!! �˴�������ʾ������ !!!��û�п��ǳ��ֶ�����
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
            //exch:gazette-pub-announcement �ڵ�   !!! �˴�������ʾ������ !!!��û�п��ǳ��ֶ�����
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
            //exch:modified-first-page-pub �ڵ�   !!! �˴�������ʾ������ !!!��û�п��ǳ��ֶ�����
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
            //exch:modified-complete-spec-pub �ڵ�   !!! �˴�������ʾ������ !!!��û�п��ǳ��ֶ�����
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
            //exch:unexamined-printed-without-grant �ڵ�   !!! �˴�������ʾ������ !!!��û�п��ǳ��ֶ�����
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
            //exch:not-printed-with-grant �ڵ�   !!! �˴�������ʾ������ !!!��û�п��ǳ��ֶ�����
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
            //exch:claims-only-available �ڵ�   !!! �˴�������ʾ������ !!!��û�п��ǳ��ֶ�����
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
            //exch:examined-printed-without-grant �ڵ�   !!! �˴�������ʾ������ !!!��û�п��ǳ��ֶ�����
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
         //references-cited  �����ڵ� : ��Ҫ�����ڵ�
         references_cited_node := bibliographic_data_Node.NodeByName('exch:references-cited');
         if Assigned(references_cited_node) then
         begin
           Alist.Clear;
           tmpint := 0;
           references_cited_node.NodesByName('exch:citation',Alist);
           for I := 0 to Alist.Count - 1 do    // Iterate
             begin
                  //ͨ����ͬ��sequence��������
                  //sequence��ֵ��ȡ���ֵ
                  tmpstring2 :=  (TXmlNode(Alist[i])).AttributeByName['sequence'];
                  if tmpint < StrToInt(tmpstring2) then
                  begin
                       tmpint := StrToInt(tmpstring2);
                  end;
                  //srep-phase�����ַ���
                  tmpstring := (TXmlNode(Alist[i])).AttributeByName['srep-phase'];
                  if Pos(tmpstring,fieldEvery.references_cited_srep_phase) = 0 then   //�����������ַ���
                  begin
                       fieldEvery.references_cited_srep_phase :=  fieldEvery.references_cited_srep_phase + tmpstring + ';';
                  end;
                  //srep-office�����ַ���
                  tmpstring3 := (Txmlnode(Alist[i])).AttributeByName['srep-officesrep-office'];
                  if not (tmpstring3 = '') then
                  begin
                    if Pos(tmpstring3,fieldEvery.references_cited_srep_office) = 0 then
                    begin
                        fieldEvery.references_cited_srep_office := fieldEvery.references_cited_srep_office + tmpstring3 + ';';
                    end;
                  end;



                  //����patcit�ӽڵ�
                  Blist.Clear;
                  Txmlnode(Alist[i]).NodesByName('patcit',Blist);
                  for I2 := 0 to Blist.Count - 1 do    // Iterate      //�˴��������ڵ�
                    begin
                        tmpnode := Txmlnode(Blist[i2]);

                        tmpInNode := TXmlNode(tmpNode).NodeByName('document-id');
                        if assigned(tmpinnode) then      //�˴���ʽ��������
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

                  //����nplcit�ӽڵ�   !!!������ʾ����û�п����������
                  Blist.Clear;
                  Txmlnode(Alist[i]).NodesByName('nplcit',Blist);
                  for I2 := 0 to Blist.Count - 1 do    // Iterate
                    begin
                         fieldEvery.references_cited_nplcit_text := fieldEvery.references_cited_nplcit_text +
                    '['+ tmpstring2 +':' +tmpstring+':'+tmpstring3 +':(nplcit)'+ Txmlnode(Blist[i2]).AttributeByName['num'] + ':' +
                         Txmlnode(Blist[i2]).ReadString('text') + '];';
                    end;    // for
                  //����exch:corresponding-docs �ڵ�
                  tmpnode := Txmlnode(Alist[i]).nodebyname('exch:corresponding-docs');
                  if assigned(tmpnode) then
                  begin
                      tmpInNode := tmpnode.NodeByName('document-id');
                      if assigned(tmpinnode) then
                      begin        //�˴������������ʣ������۲��Ƿ����ֶ��
                         fieldEvery.references_cited_corresponding_docs_country    :=   fieldEvery.references_cited_corresponding_docs_country     +   tmpinnode.ReadString('country') +';';
                         fieldEvery.references_cited_corresponding_docs_kind       :=   fieldEvery.references_cited_corresponding_docs_kind        +   tmpinnode.ReadString('kind')+';';
                         fieldEvery.references_cited_corresponding_docs_doc_number :=   fieldEvery.references_cited_corresponding_docs_doc_number  +   tmpinnode.ReadString('doc-number')+';';     //����û��data-format���ԣ���û�ж�����ʽ
                         fieldEvery.references_cited_corresponding_docs_date       :=   fieldEvery.references_cited_corresponding_docs_date        +   tmpinnode.ReadString('date')+';';
                      end;
                      tmpinnode := tmpnode.NodeByName('refno');
                      if assigned(tmpinnode) then
                      begin
                        fieldEvery.references_cited_corresponding_docs_refno := fieldEvery.references_cited_corresponding_docs_refno  + tmpnode.ReadString('refno') + ';';
                      end;
                  end;
                  //category �ڵ�
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
         //<exch:st50-republication>  //�����Խ�����ʵ������

        st50_republication_node :=  bibliographic_data_Node.NodeByName('exch:st50-republication');
        if assigned(st50_republication_node) then
        begin
           //status ����
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
               //modified-bibliography �ڵ�
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
               //modified-part �ڵ�
               Alist.Clear;
               tmpnode.NodesByName('modified-part',Alist);
               for I := 0 to Alist.Count - 1 do    // Iterate
                 begin
                     //sequence attr��ֵ��ȡ���ֵ
                     tmpstring2 :=  (TXmlNode(Alist[i])).AttributeByName['sequence'];
                     if tmpint < StrToInt(tmpstring2) then
                     begin
                          tmpint := StrToInt(tmpstring2);
                     end;
                     //lang  attr����
                     tmpstring := (TXmlNode(Alist[i])).AttributeByName['lang'];
                     if Pos(tmpstring,fieldEvery.st50_republication_modified_part_lang) = 0  then   //�����������ַ���
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
                    //sequence attr��ֵ��ȡ���ֵ
                     tmpstring2 :=  (TXmlNode(Alist[i])).AttributeByName['sequence'];
                     if tmpint < StrToInt(tmpstring2) then
                     begin
                          tmpint := StrToInt(tmpstring2);
                     end;
                     //lang  attr����
                     tmpstring := (TXmlNode(Alist[i])).AttributeByName['lang'];
                     if Pos(tmpstring,fieldEvery.st50_republication_republication_note_lang) = 0  then   //�����������ַ���
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
     //exch: abstract �����ڵ�

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
     //exch:patent_family  �����ڵ�   ����ʵ�����н���
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

                       //����document-id�ӽڵ�
                       tmpNode := TXmlNode(blist[i2]).NodeByName('document-id');
                       if Assigned(tmpNode) then
                       begin

                           if Assigned(TXmlNode(tmpNode.NodeByName('country')))     then begin fieldEvery.patent_family_application_reference_country        := fieldEvery.patent_family_application_reference_country + tmpNode.ReadString('country') +';';  end;     //coutry�ӽڵ�����
                           if Assigned(TXmlNode(tmpNode.NodeByName('kind')))        then begin fieldEvery.patent_family_application_reference_kind           := fieldEvery.patent_family_application_reference_kind  +   tmpNode.ReadString('kind') +';';     end;     //kind �ӽڵ�����
                           if Assigned(TXmlNode(tmpNode.NodeByName('date')))        then begin fieldEvery.patent_family_application_reference_date           := fieldEvery.patent_family_application_reference_date +    tmpNode.ReadString('date') + ';';      end;    //date �ӽڵ�����
                           if Assigned(TXmlNode(tmpNode.NodeByName('doc-number'))) then
                           begin
                                fieldEvery.patent_family_application_reference_doc_number     :=   fieldEvery.patent_family_application_reference_doc_number  +
                                '[' + tmpstring +':'+ tmpNode.ReadString('doc-number') +'];';         //��ͬ���Ͷ�Ӧ��ͬ��doc_number ��ʽΪ��<[data-fmt:doc-number];[data-fmt:doc-number]>
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

                           //����document-id�ӽڵ�
                           tmpNode := TXmlNode(blist[i2]).NodeByName('document-id');
                           if Assigned(tmpNode) then
                           begin

                               if Assigned(TXmlNode(tmpNode.NodeByName('country')))     then begin fieldEvery.patent_family_publication_reference_country            := fieldEvery.patent_family_publication_reference_country + tmpNode.ReadString('country') +';';  end;     //coutry�ӽڵ�����
                               if Assigned(TXmlNode(tmpNode.NodeByName('kind')))        then begin fieldEvery.patent_family_publication_reference_kind               := fieldEvery.patent_family_publication_reference_kind  +   tmpNode.ReadString('kind') +';';     end;     //kind �ӽڵ�����
                               if Assigned(TXmlNode(tmpNode.NodeByName('date')))        then begin fieldEvery.patent_family_publication_reference_date               := fieldEvery.patent_family_publication_reference_date +    tmpNode.ReadString('date') + ';';      end;    //date �ӽڵ�����
                               if Assigned(TXmlNode(tmpNode.NodeByName('doc-number'))) then
                               begin
                                    fieldEvery.patent_family_publication_reference_doc_number     :=   fieldEvery.patent_family_publication_reference_doc_number  +
                                    '[' + tmpstring +':'+ tmpstring2+':'+ tmpNode.ReadString('doc-number') +'];';         //��ͬ���Ͷ�Ӧ��ͬ��doc_number ��ʽΪ��<[data-fmt:doc-number];[data-fmt:doc-number]>
                               end;
                           end;
                     end;    // for
                     fieldEvery.patent_family_publication_reference_sequence := inttostr(tmpint);
            end;    // for


          //3 level node
          //exch: abstract �����ڵ�
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
