unit xmlRecord;

interface

type

    fileInfoRecord = record
      filename:string;        //����ֵ
      startTime:string;             //����ֵ
      endTime:string;               //����ֵ
      usedTime:string;         //����ֵ
    end;
    docRecord = record
      //FieldId: String;        //key�Զ�������������ʽΪ"file+�к�"
      date_of_exchange:string;        //����ֵ
      dtd_version:string;             //����ֵ
      file_name:string;               //����ֵ
      no_of_documents:string;         //����ֵ
      originating_office:string;      //����ֵ
    end;
    //��ʾ��Ŀǰϵͳд���ԣ�������Attributes used��
    FieldRecord= record       //ʵ�ʴ洢���ֶ�
      FieldId: String;        //key�Զ�������������ʽΪ"file+�к�"
      //exch:exchange-document һ���ڵ�
      country:string;                          //����ֵ
      doc_number:string;                       //����ֵ
      kind:string;                             //����ֵ
      date_publ:string;                        //����ֵ
      family_id:string;                        //����ֵ
      is_representative:string;                //����ֵ
      date_of_last_exchange:string;            //����ֵ
      date_added_docdb:string;                 //����ֵ
      originating_office:string;               //����ֵ   �������Ƿ�����������
      //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      date_of_previous_exchange:string;        //����ֵ++
      status:string;                           //����ֵ++
      //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      //publication_reference �����ڵ�
      publication_reference_data_format:string;    //����ֵ //���ֵ�洢��ͬһ�ֶ� (����) ��ʽΪ��<docdb;epodoc;...>
      publication_reference_country:string;        //�ڵ�:docment-id�ӽڵ�
      publication_reference_doc_number:string;     //�ڵ�:docment-id�ӽڵ� //��ͬ���Ͷ�Ӧ��ͬ��doc_number ��ʽΪ��<[data-fmt:doc-number];[data-fmt:doc-number]>
      publication_reference_kind:string;           //�ڵ�:docment-id�ӽڵ�
      publication_reference_date:string;           //�ڵ�:docment-id�ӽڵ�
      //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      publication_reference_doc_lang:string;       //�ڵ�:docment-id������++
      //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      //exch:previously-filed-app �����ڵ�
      previously_filed_app_text:string;            //�ڵ�previously
      //exch:preceding-publication-date �����ڵ�
      preceding_publication_date:string;
      //exch:date-of-coming-into-force  �����ڵ�
      date_of_coming_into_force_date:string;
      //exch:extended-kind-code �����ڵ�
      extended_kind_code_data_format:string;
      extended_kind_code:string;
      //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      //classification-ipc
      classification_ipc_text:string;              //;���ַ�����������text���Իس���Ϊ����
      //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      classification_ipc_edition:string;           //׷���ӽڵ�
      classification_ipc_main_class:string;
      classification_ipc_further_class:string;
      classification_ipc_additional_info:string;
      classification_ipc_unlinked_indexing_code:string;
      classification_ipc_linked_indexing_code_group_main:string;
      classification_ipc_linked_indexing_code_group_sub:string;
      //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      //classifications-ipcr                       //δ��ȫ�����ɽṹ
      classifications_ipcr_num:string;             //���ԣ���ֵΪsequence����ֵ������Ϊ���ֵ
      classifications_ipcr_text:string;            //��ȡ�ڵ�list�������ַ�����Ϊsequence+text��Ӧ����ʽΪ<[sequence:text];[sequence:text]>
      //classification-national                    //δ��ȫ�����ɽṹ
      classification_national_text:string;         //�س������ַ�����������text
      //classification-ecla                        //���ڶ����ͬ��classification��ͷ
      classification_ecla:string;                  //������+�ڵ㡰��ϣ���ʽΪ<[country:scheme:text];[country:scheme:text]>,�����Ӽ�¼
      //application-reference                      //���ж���ӽڵ�
      application_reference_is:string;             //����
      application_reference_data_format:string;    //����,�ж���,��ʽΪ��<docdb;epodoc;...>
      application_reference_country:string;        //�ڵ�:docment-id�ӽڵ� //����Ϊ�ӽڵ�����
      application_reference_doc_number:string;     //�ڵ�:docment-id�ӽڵ� //�ж��֣��ʸ�ʽΪ<[data-format:doc-number]#[data-format:doc-number]>
      application_reference_kind:string;           //�ڵ�:docment-id�ӽڵ�
      application_reference_date:string;           //�ڵ�:docment-id�ӽڵ�
      //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      application_reference_doc_lang:string;
      application_reference_doc_id:string;
      application_reference_status:string;
      //exch:language-of-filing
      language_of_filing_statue:string;
      language_of_filing_text:string;
      //<exch:language-of-publication>
      language_of_publication_status:string;
      language_of_publication_text:string;
      //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      //priority-claims
      priority_claims_sequence:string;              //���ԣ���ֵΪsequence����ֵ������Ϊ���ֵ
      priority_claims_data_format:string;           //���,��ʽ<;;>
      priority_claims_country:string;               //�ڵ�:docment-id�ӽڵ�
      priority_claims_doc_number:string;            //�ڵ�:docment-id�ӽڵ� //�ж��֣��ʸ�ʽΪ<[data-fmt:doc-number];[data-fmt:doc-number]>
      priority_claims_kind:string;                  //�ڵ�:docment-id�ӽڵ�
      priority_claims_date:string;                  //�ڵ�:docment-id�ӽڵ�
      priority_claims_active_indicator:string;      //�ڵ�:priority-active-indicator��ͬdocment-idͬһ��
      //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
       priority_claims_status:string;
       priority_claims_doc_lang:string;
      //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      //parties
      patries_applicants_sequence:string;            //applicants�ӽڵ㣬���ԣ���ֵΪsequence����ֵ������Ϊ���ֵ
      patries_applicants_data_format:string;         //���,��ʽ<;;>
      patries_applicants_name:string;                //��ʽ<[sequence:data-format:name][sequence:data-format:name]>
      patries_applicants_country:string;             //reside�ӽڵ�
      patries_applicants_address:string;             //�������˴���ʽ���ܴ��ھ����ԣ���Ҫ��һ������
      patries_inventors_sequence:string;             //inventors�ӽڵ㣬���ԣ���ֵΪsequence����ֵ������Ϊ���ֵ
      patries_inventors_data_format:string;          //���,��ʽ<;;>
      patries_inventors_name:string;                 //inventor-name�ӽڵ㣬���ڶ��,��ʽΪ<[sequence:data-format:name]��[sequence:data-format:name]>
      patries_inventors_address:string;             //�������˴���ʽ���ܴ��ھ����ԣ���Ҫ��һ������
      //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      patries_applicants_status:string;
      patries_applicants_name_data_format:string;
      patries_inventors_status:string;
      //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      //<exch:designation-of-states>
      designation_of_states_EPC_contracting_states_country:string;
      designation_of_states_EPC_extension_states_country:string;
      designation_of_states_PCT_regional_country:string;
      designation_of_states_PCT_countrys:string;
      designation_of_states_PCT_national_country:string;
      designation_of_states_contracting_states_country:string;
      //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      //invention-title
      invention_title_lang:string;                   //���ԣ����ܻ���ڶ��[,]
      invention_title_data_format:string;            //���ԣ����ܻ���ڶ��[,]
      invention_title_text:string;                   //���ܻ���ڶ��,��ʽΪ<[lang:fmt:text]#[lang:fmt:text]>
      //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      invention_title_status:string;
      //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      //dates-of-public-availability
      dates_of_public_availability_unexamined:string;    //���ֽڵ㶼���ܴ���
      dates_of_public_availability_printed:string;
      //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      dates_of_public_availability_gazette_reference:string;
      dates_of_public_availability_abstract_reference:string;
      dates_of_public_availability_supplemental:string;
      dates_of_public_availability_gazette_pub_announcement:string;
      dates_of_public_availability_modified_first_page_pub:string;
      dates_of_public_availability_modified_complete_spec_pub:string;
      dates_of_public_availability_unexamined_not_printed_without_grant:string;
      dates_of_public_availability_unexamined_printed_without_grant:string;
      dates_of_public_availability_examined_printed_without_grant:string;
      dates_of_public_availability_claims_only_available:string;
      dates_of_public_availability_not_printed_with_grant:string;
      //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      //references-cited
      references_cited_srep_phase:string;            //����ֵ������,[,]
      references_cited_sequence:string;              //����ֵ������,[,]
      //references_cited_patcit_num:string;            //����,<[sequence:num]#[sequence:num]>
      //references_cited_country:string;               //�ڵ�:docment-id�ӽڵ�
      //references_cited_doc_number:string;            //<[srep_phase:sequence:patcit_num:docnumber];[]>
      //references_cited_kind:string;                  //�ڵ�:docment-id�ӽڵ�
      references_cited_nplcit:string;                //��patcit���Ӧ����һ�����, ����,<[sequence:num];[sequence:num]>
      references_cited_nplcit_text:string;           //nplcit��Ӧ����
      //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      references_cited_srep_office:string;
      references_cited_corresponding_docs_country:string;
      references_cited_corresponding_docs_kind:string;
      references_cited_corresponding_docs_doc_number:string;
      references_cited_corresponding_docs_refno:string;
      references_cited_corresponding_docs_date:string;
      references_cited_category:string;
      //references_cited_patcit_dnum:string;
      //references_cited_patcit_dnum_type:string;
      references_cited_patcit_doc_country:string;
      references_cited_patcit_doc_doc_number:string;
      references_cited_patcit_doc_kind:string;
      references_cited_patcit_doc_date:string;

      //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      //<exch:st50-republication>
      st50_republication_status:string;
      st50_republication_republcation_code:string;
      st50_republication_modified_bibliography_inid_code:string;
      st50_republication_correction_notice_date:string;
      st50_republication_correction_notice_gazette_date:string;
      st50_republication_modified_part_sequence:string;
      st50_republication_modified_part_lang:string;
      st50_republication_modified_part_name:string;
      st50_republication_republication_note_sequence:string;
      st50_republication_republication_note_lang:string;
      st50_republication_republication_note:string;
      //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      //exch:abstract һ���ڵ�
      abstract_lang:string;                          //����ֵ������,[,]
      abstract_data_format:string;                   //����ֵ������,[,]
      abstract_source:string;                        //����ֵ������,[,]
      abstract_p:string;                             //�ӽڵ����ݣ��������Ƿ��ж��֣�<[sequence_fmt:p];[sequence_fmt:p]>
      //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      abstract_country:string;
      abstract_doc_number:string;
      abstract_kind:string;
      abstract_date_publ:string;
      abstract_status:string;
      abstract_date:string;
      //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      //patent-family    һ���ڵ�
      //<exch:family-member> �����ڵ�
      patent_family_publication_reference_sequence:string;
      patent_family_publication_reference_data_format:string;
      patent_family_publication_reference_country:string;
      patent_family_publication_reference_doc_number:string;
      patent_family_publication_reference_kind:string;
      patent_family_publication_reference_date:string;
      patent_family_application_reference_data_format:string;
      patent_family_application_reference_is:string;
      patent_family_application_reference_country:string;
      patent_family_application_reference_doc_number:string;
      patent_family_application_reference_kind:string;
      patent_family_application_reference_date:string;
      //<exch:abstract> �����ڵ�
      patent_family_abstract_lang:string;
      patent_family_abstract_data_format:string;
      patent_family_abstract_country:string;
      patent_family_abstract_doc_number:string;
      patent_family_abstract_kind:string;
      patent_family_abstract_abstract_source:string;
      patent_family_abstract_status:string;
      patent_family_abstract_date:string;
      patent_family_abstract_p:string;
      //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    end;

implementation

end.
