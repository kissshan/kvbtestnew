/*
* Name      : CommercialPR_EAE_Individual_Helper
* Company   : ET Marlabs
* Purpose   : Helper class of CommercialPR_EAE_Response_Handler for Individual Cibil Score. 
* Author    : Raushan
*/
public class CommercialPR_EAE_Individual_Helper {
    
    public static void getRequest(CommercialPR_EAE_Response.cls_CreditReport  creditReportObj){
        
        /*// For ID Segments
        List<TU_ID_s__c> listIDsegments = new List<TU_ID_s__c>(); 
        // For telephone Segments
        List<TU_Telephone__c>    listTelephonesegment = new List<TU_Telephone__c>(); 
        // For EMail Segments
        List<TU_Email__c>    listEmailsegment = new List<TU_Email__c>(); 
        // For TU Account
        List<TU_Account__c>    listTUAccount = new List<TU_Account__c>(); 
        // For TU Enquiry
        List<Enquiry_Summary__c>    listTUEnquiry= new List<Enquiry_Summary__c>(); 
        // For TU Address
        List<Location_Detail__c>    listTUAddres= new List<Location_Detail__c>(); 
        // For TU scores    
        List<TU_Score__c>   listTUscores= new List<TU_Score__c>();
        */
        //RecordType Id
        List<String> listDeveloperName = new List<String>{'HL_TU'};
        Map<String,id> recordtypeIdMap = Utility.getRecordTypeID(listDeveloperName);
        Account accObj                 = new Account();
        ints__TransUnion_Credit_Report__c transunionObj     =   new ints__TransUnion_Credit_Report__c();
        String TranExternalId                               =   String.valueOf(Math.random())+'transcreditreport';
        transunionObj.External_Id__c                        =   TranExternalId;
        transunionObj.RecordTypeId                          =   recordtypeIdMap.get('HL_TU');
        
        If(creditReportObj !=null){
            
            CommercialPR_EAE_Response.cls_Header cHeaderObj = creditReportObj.header; 
            
            If(cHeaderObj!=null){
                If(!Utility.ISStringBlankorNull(cHeaderObj.ReferenceNumber)){
                    accObj.CBS_Customer_ID__c               =   cHeaderObj.ReferenceNumber;
                    transunionObj.Account__r                =   new Account(CBS_Customer_ID__c = cHeaderObj.ReferenceNumber);
                }
                If(!Utility.ISStringBlankorNull(cHeaderObj.MemberCode))
                    transunionObj.Member_Code__c            =   cHeaderObj.MemberCode;
                If(!Utility.ISStringBlankorNull(cHeaderObj.EnquiryControlNumber))
                    transunionObj.EnquiryControlNumber__c   =   cHeaderObj.EnquiryControlNumber;
                If((!Utility.ISStringBlankorNull(cHeaderObj.DateProcessed)) && (!Utility.ISStringBlankorNull(cHeaderObj.TimeProcessed))){     
                    String DTime                            =   cHeaderObj.DateProcessed+cHeaderObj.TimeProcessed;
                }
                If(!Utility.ISStringBlankorNull(cHeaderObj.SubjectReturnCode))
                    transunionObj.SubjectReturnCode__c      =   cHeaderObj.SubjectReturnCode;
            }
            CommercialPR_EAE_Response.cls_NameSegment   nameSegmentObj  =   creditReportObj.nameSegment;
            If(nameSegmentObj !=null){
                If(!Utility.ISStringBlankorNull(nameSegmentObj.ConsumerName1))
                    transunionObj.Borrower_Name__c          =   nameSegmentObj.ConsumerName1;
                If(!Utility.ISStringBlankorNull(nameSegmentObj.Gender)){
                    //transunionObj.Gender__c =cNamesegment.Gender;
                }
               If(!Utility.ISStringBlankorNull(nameSegmentObj.DateOfBirth))
                   transunionObj.ints__DOB__c               =   nameSegmentObj.DateOfBirth; 
            }
            //List of cls_IDSegment
            List<CommercialPR_EAE_Response.cls_IDSegment>   listiDsegment   =   creditReportObj.iDSegment;
            
            If(listiDsegment !=null){
                for(CommercialPR_EAE_Response.cls_IDSegment     iDSegmentObj    :   listiDsegment) {
                    If(iDSegmentObj !=null){
                        TU_ID_s__c tuIdObj                  =   new TU_ID_s__c();
                        if(!Utility.ISStringBlankorNull(iDSegmentObj.IDNumber))
                            tuIdObj.ID_Number__c            =   iDSegmentObj.IDNumber;
                        if(!Utility.ISStringBlankorNull(iDSegmentObj.IDType))
                            tuIdObj.ID_Type__c              =   iDSegmentObj.IDType;
                        tuIdObj.TU_Credit_Report__r         =   new ints__TransUnion_Credit_Report__c(External_Id__c=TranExternalId);
                        
                        CommercialPR_EAE_Batch.listTUIDs.add(tuIdObj);
                    }
                }   
            }
           List<CommercialPR_EAE_Response.cls_ScoreSegment> listScoreSegment    =   creditReportObj.scoreSegment;
            If(listScoreSegment !=null){
                for(CommercialPR_EAE_Response.cls_ScoreSegment  scoreSegmentObj     : listScoreSegment) {
                    If(scoreSegmentObj  !=null){
                        
                        TU_Score__c tuScoreObj                  =   new TU_Score__c();
                        
                        If(!Utility.ISStringBlankorNull(scoreSegmentObj.ScoreName))
                            tuScoreObj.Score_Name__c            =   scoreSegmentObj.ScoreName;
                        If(!Utility.ISStringBlankorNull(scoreSegmentObj.ScoreCardName))
                            tuScoreObj.Score_Card_Name__c       =   scoreSegmentObj.ScoreCardName;
                        If(!Utility.ISStringBlankorNull(scoreSegmentObj.ScoreCardVersion))
                            tuScoreObj.Score_Card_Version__c    =   scoreSegmentObj.ScoreCardVersion;
                        If(!Utility.ISStringBlankorNull(scoreSegmentObj.ScoreDate))
                            tuScoreObj.Score_Date__c            =   scoreSegmentObj.ScoreDate;
                        If(!Utility.ISStringBlankorNull(scoreSegmentObj.Score)){
                            If(scoreSegmentObj.Score =='000-1'){
                              tuScoreObj.Score__c = -1;
                              accObj.CIBIL_Score__c    = -1;
                              accObj.CIBIL_Status__pc           = 'Complete';  
                            }else if(scoreSegmentObj.Score !='0'){
                              tuScoreObj.Score__c                 =   Decimal.valueOf(scoreSegmentObj.Score);
                              accObj.CIBIL_Score__c               =   Decimal.valueOf(scoreSegmentObj.Score);
                              accObj.CIBIL_Status__pc             = 'Complete'; 
                            }else{
                                tuScoreObj.Score__c                 =   Decimal.valueOf(scoreSegmentObj.Score);
                                accObj.CIBIL_Score__c               =   Decimal.valueOf(scoreSegmentObj.Score);    
                            }
                            CommercialPR_EAE_Batch.listAccount.add(accObj);
                        }
                        
                        tuScoreObj.TU_Credit_Report__r          =   new ints__TransUnion_Credit_Report__c(External_Id__c=TranExternalId);
                        CommercialPR_EAE_Batch.listTUscores.add(tuScoreObj);    
                    }  
                }
            }
            List<CommercialPR_EAE_Response.cls_Address_Z>   listAddress     =   creditReportObj.address;
            If(listAddress !=null){
                for(CommercialPR_EAE_Response.cls_Address_Z     addressObj  :   listAddress){
                    If(addressObj !=null){
                        Location_Detail__c locationObj      =   new Location_Detail__c();  
                    If(!Utility.ISStringBlankorNull(addressObj.AddressLine1))   
                        locationObj.Address__c              =   addressObj.AddressLine1;
                    If(!Utility.ISStringBlankorNull(addressObj.AddressSegmentTag))   
                        locationObj.Address_Segment_Tag__c  =   addressObj.AddressSegmentTag;
                    If(!Utility.ISStringBlankorNull(addressObj.StateCode))   
                        locationObj.State_Name__c           =   addressObj.StateCode;
                    If(!Utility.ISStringBlankorNull(addressObj.PinCode))   
                        locationObj.Pin_Code__c             =   addressObj.PinCode;
                    If(!Utility.ISStringBlankorNull(addressObj.AddressCategory))   
                        locationObj.Address_Category__c     =   addressObj.AddressCategory;
                    If(!Utility.ISStringBlankorNull(addressObj.DateReported))   
                        locationObj.Date_Reported__c        =   addressObj.DateReported;
                    If(!Utility.ISStringBlankorNull(addressObj.EnrichedThroughEnquiry))   
                        locationObj.Enriched_Through_Enquiry__c = addressObj.EnrichedThroughEnquiry;
                    
                    locationObj.Tu_Credit_Report__r =new ints__TransUnion_Credit_Report__c(External_Id__c=TranExternalId);
                    CommercialPR_EAE_Batch.listlocationDetail.add(locationObj);    
                    }
                }    
            }
            List<CommercialPR_EAE_Response.cls_TelephoneSegment>    listTelephoneObj    =   creditReportObj.telephoneSegment;
            If(listTelephoneObj !=null){
                for(CommercialPR_EAE_Response.cls_TelephoneSegment  telephoneObj        :   listTelephoneObj) {
                    If(telephoneObj !=null){
                        TU_Telephone__c tuPhoneObj                  =   new TU_Telephone__c();
                        If(!Utility.ISStringBlankorNull(telephoneObj.EnrichedThroughEnquiry))
                            tuPhoneObj.EnrichedThroughEnquiry__c    =   telephoneObj.EnrichedThroughEnquiry;
                        If(!Utility.ISStringBlankorNull(telephoneObj.TelephoneNumber))
                            tuPhoneObj.TelephoneNumber__c           =   telephoneObj.TelephoneNumber;
                        If(!Utility.ISStringBlankorNull(telephoneObj.TelephoneType))
                            tuPhoneObj.TelephoneType__c             =   telephoneObj.TelephoneType;
                        tuPhoneObj.TU_Credit_Report__r              =   new ints__TransUnion_Credit_Report__c(External_Id__c=TranExternalId);
                        
                        CommercialPR_EAE_Batch.listTelephonesegment.add(tuPhoneObj);
                    }
                }   
            }
           CommercialPR_EAE_Response.cls_End_Z  endObj              =   creditReportObj.end_Z;
            If(endObj !=null){
                //
            }
            CommercialPR_EAE_Batch.listTransUnion.add(transunionObj);
        }
       /* insert transunionObj;
        
        If(listIDsegments !=null && listIDsegments.size()>0){
            insert listIDsegments;
        }
        If(listTUscores !=null && listTUscores.size()>0){
            insert listTUscores;
        }
        If(listTUAddres !=null && listTUAddres.size()>0){
            insert listTUAddres;
        }
        If(listTelephonesegment !=null && listTelephonesegment.size()>0){
            insert listTelephonesegment;
        } */
    }
}