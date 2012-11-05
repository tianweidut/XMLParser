unit xmlRecord;

interface

type

    fileInfoRecord = record
      filename:string;        //属性值
      startTime:string;             //属性值
      endTime:string;               //属性值
      usedTime:string;         //属性值
    end;
    docRecord = record
      //FieldId: String;        //key自动增量计数，格式为"file+行号"
      date_of_exchange:string;        //属性值
      dtd_version:string;             //属性值
      file_name:string;               //属性值
      no_of_documents:string;         //属性值
      originating_office:string;      //属性值
    end;
    //提示：目前系统写属性，仅考虑Attributes used项
    FieldRecord= record       //实际存储的字段
      FieldId: String;        //key自动增量计数，格式为"file+行号"
      //exch:exchange-document 一级节点
      country:string;                          //属性值
      doc_number:string;                       //属性值
      kind:string;                             //属性值
      date_publ:string;                        //属性值
      family_id:string;                        //属性值
      is_representative:string;                //属性值
      date_of_last_exchange:string;            //属性值
      date_added_docdb:string;                 //属性值
      originating_office:string;               //属性值   ！！！是否还有其他属性
      //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      date_of_previous_exchange:string;        //属性值++
      status:string;                           //属性值++
      //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      //publication_reference 二级节点
      publication_reference_data_format:string;    //属性值 //多个值存储在同一字段 (属性) 格式为：<docdb;epodoc;...>
      publication_reference_country:string;        //节点:docment-id子节点
      publication_reference_doc_number:string;     //节点:docment-id子节点 //不同类型对应不同的doc_number 格式为：<[data-fmt:doc-number];[data-fmt:doc-number]>
      publication_reference_kind:string;           //节点:docment-id子节点
      publication_reference_date:string;           //节点:docment-id子节点
      //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      publication_reference_doc_lang:string;       //节点:docment-id的属性++
      //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      //exch:previously-filed-app 二级节点
      previously_filed_app_text:string;            //节点previously
      //exch:preceding-publication-date 二级节点
      preceding_publication_date:string;
      //exch:date-of-coming-into-force  二级节点
      date_of_coming_into_force_date:string;
      //exch:extended-kind-code 二级节点
      extended_kind_code_data_format:string;
      extended_kind_code:string;
      //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      //classification-ipc
      classification_ipc_text:string;              //;分字符串，载入多个text，以回车作为区分
      //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      classification_ipc_edition:string;           //追加子节点
      classification_ipc_main_class:string;
      classification_ipc_further_class:string;
      classification_ipc_additional_info:string;
      classification_ipc_unlinked_indexing_code:string;
      classification_ipc_linked_indexing_code_group_main:string;
      classification_ipc_linked_indexing_code_group_sub:string;
      //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      //classifications-ipcr                       //未完全添加完成结构
      classifications_ipcr_num:string;             //属性，该值为sequence递增值，最终为最大值
      classifications_ipcr_text:string;            //获取节点list载入多个字符串，为sequence+text对应，格式为<[sequence:text];[sequence:text]>
      //classification-national                    //未完全添加完成结构
      classification_national_text:string;         //回车区分字符串，载入多个text
      //classification-ecla                        //存在多个相同的classification开头
      classification_ecla:string;                  //”属性+节点“组合，格式为<[country:scheme:text];[country:scheme:text]>,多次添加记录
      //application-reference                      //具有多个子节点
      application_reference_is:string;             //属性
      application_reference_data_format:string;    //属性,有多种,格式为：<docdb;epodoc;...>
      application_reference_country:string;        //节点:docment-id子节点 //下面为子节点内容
      application_reference_doc_number:string;     //节点:docment-id子节点 //有多种，故格式为<[data-format:doc-number]#[data-format:doc-number]>
      application_reference_kind:string;           //节点:docment-id子节点
      application_reference_date:string;           //节点:docment-id子节点
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
      priority_claims_sequence:string;              //属性，该值为sequence递增值，最终为最大值
      priority_claims_data_format:string;           //多个,格式<;;>
      priority_claims_country:string;               //节点:docment-id子节点
      priority_claims_doc_number:string;            //节点:docment-id子节点 //有多种，故格式为<[data-fmt:doc-number];[data-fmt:doc-number]>
      priority_claims_kind:string;                  //节点:docment-id子节点
      priority_claims_date:string;                  //节点:docment-id子节点
      priority_claims_active_indicator:string;      //节点:priority-active-indicator，同docment-id同一级
      //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
       priority_claims_status:string;
       priority_claims_doc_lang:string;
      //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      //parties
      patries_applicants_sequence:string;            //applicants子节点，属性，该值为sequence递增值，最终为最大值
      patries_applicants_data_format:string;         //多个,格式<;;>
      patries_applicants_name:string;                //格式<[sequence:data-format:name][sequence:data-format:name]>
      patries_applicants_country:string;             //reside子节点
      patries_applicants_address:string;             //！！！此处格式可能存在局限性，需要进一步考虑
      patries_inventors_sequence:string;             //inventors子节点，属性，该值为sequence递增值，最终为最大值
      patries_inventors_data_format:string;          //多个,格式<;;>
      patries_inventors_name:string;                 //inventor-name子节点，存在多个,格式为<[sequence:data-format:name]；[sequence:data-format:name]>
      patries_inventors_address:string;             //！！！此处格式可能存在局限性，需要进一步考虑
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
      invention_title_lang:string;                   //属性，可能会存在多个[,]
      invention_title_data_format:string;            //属性，可能会存在多个[,]
      invention_title_text:string;                   //可能会存在多个,格式为<[lang:fmt:text]#[lang:fmt:text]>
      //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      invention_title_status:string;
      //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      //dates-of-public-availability
      dates_of_public_availability_unexamined:string;    //两种节点都可能存在
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
      references_cited_srep_phase:string;            //属性值，多种,[,]
      references_cited_sequence:string;              //属性值，多种,[,]
      //references_cited_patcit_num:string;            //多种,<[sequence:num]#[sequence:num]>
      //references_cited_country:string;               //节点:docment-id子节点
      //references_cited_doc_number:string;            //<[srep_phase:sequence:patcit_num:docnumber];[]>
      //references_cited_kind:string;                  //节点:docment-id子节点
      references_cited_nplcit:string;                //与patcit向对应的另一种情况, 多种,<[sequence:num];[sequence:num]>
      references_cited_nplcit_text:string;           //nplcit对应内容
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
      //exch:abstract 一级节点
      abstract_lang:string;                          //属性值，多种,[,]
      abstract_data_format:string;                   //属性值，多种,[,]
      abstract_source:string;                        //属性值，多种,[,]
      abstract_p:string;                             //子节点内容，！！！是否有多种，<[sequence_fmt:p];[sequence_fmt:p]>
      //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      abstract_country:string;
      abstract_doc_number:string;
      abstract_kind:string;
      abstract_date_publ:string;
      abstract_status:string;
      abstract_date:string;
      //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      //patent-family    一级节点
      //<exch:family-member> 二级节点
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
      //<exch:abstract> 二级节点
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
