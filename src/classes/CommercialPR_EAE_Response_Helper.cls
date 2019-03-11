/*
* Name      : CommercialPR_EAE_Response_Helper
* Company   : ET Marlabs
* Purpose   : Helper class of CommercialPR_EAE_Response_Handler. 
* Author    : Raushan
*/
public with sharing class CommercialPR_EAE_Response_Helper {
    
    public static void getCommercialPRDetails(CommercialPR_EAE_Response.cls_RawResponse commercialPRRes) {
        If(commercialPRRes != null) {
            
            List < CommercialPR_EAE_Response.Out_msg > listOutMsg = commercialPRRes.out_msg;
            
            List < CommercialPR_EAE_Response.LocationInformation > listlocationInformation;
            List < CommercialPR_EAE_Response.RelationshipDetails > listrelationshipDetails;
            List < CommercialPR_EAE_Response.CreditFacilityDetailsasBorrowerSec > listcreditFacilityDetailsasBorrowerSec;
            List < CommercialPR_EAE_Response.CFHistoryforACOrDPDupto24Months > listCFHistoryforACOrDPDupto24Months;
            List < CommercialPR_EAE_Response.EnquiryDetailsInLast24Month > listenquiryDetailsInLast24Month;
            
            //List of DeveloperName
            List<String> listDeveloperName = new List<String>{'Enquiry_Address','Borrwer_ID_Details','Location_Details','Relationship_ID_Details'};
                
                Map<String,id> recordtypeIdMap = Utility.getRecordTypeID(listDeveloperName);
            
            //External ID for Application CommercialPR Statge Update.
            String externalId_App   = '';
            //List<String> extIdList = new List<String>();
            
            If(listOutMsg != null && listOutMsg.size() > 0) {
                for (CommercialPR_EAE_Response.Out_msg outMsgObj: listOutMsg) {
                    
                    ints__TransUnion_Credit_Report__c transunionObj = new ints__TransUnion_Credit_Report__c();
                    Account accountObj    = new Account();
                    String TranExternalId = String.valueOf(Math.random()) + 'transcreditreport';
                    System.debug('ExternalID####@@@@'+TranExternalId);
                    transunionObj.External_Id__c = TranExternalId;
                    If(outMsgObj != null) {
                        String customerId;
                        //ReportHeaderRec
                        CommercialPR_EAE_Response.ResponseReport responseReportObj = outMsgObj.responseReport;
                        If(responseReportObj != null) {
                            //ReportHeaderRec
                            CommercialPR_EAE_Response.ReportHeaderRec reportHeaderRecObj = responseReportObj.reportHeaderRec;
                            If(!Utility.ISStringBlankorNull(reportHeaderRecObj.reportOrderNumber))
                                transunionObj.Report_Order_Number__c = reportHeaderRecObj.reportOrderNumber.deleteWhitespace();
                            If(!Utility.ISStringBlankorNull(reportHeaderRecObj.reportOrderDate))
                                transunionObj.Report_Order_Date__c = reportHeaderRecObj.reportOrderDate.deleteWhitespace();
                            If(!Utility.ISStringBlankorNull(reportHeaderRecObj.reportOrderedBy))
                                transunionObj.Report_OrderBy__c = reportHeaderRecObj.reportOrderedBy.deleteWhitespace();
                            If(!Utility.ISStringBlankorNull(reportHeaderRecObj.memberDetails))
                                transunionObj.Member_Details__c = reportHeaderRecObj.memberDetails.deleteWhitespace();
                            If(!Utility.ISStringBlankorNull(reportHeaderRecObj.applicationReferenceNumber)) {
                                customerId          =   reportHeaderRecObj.applicationReferenceNumber.deleteWhitespace();
                                accountObj.CBS_Customer_ID__c = reportHeaderRecObj.applicationReferenceNumber.deleteWhitespace();
                                transunionObj.Application_Reference_Number__c = reportHeaderRecObj.applicationReferenceNumber.deleteWhitespace();
                                transunionObj.Account__r = new Account(CBS_Customer_ID__c = String.valueOf(reportHeaderRecObj.applicationReferenceNumber.deleteWhitespace()));
                                //CommercialPR_EAE_Batch.accountObj.CBS_Customer_ID__c      = String.valueOf(reportHeaderRecObj.applicationReferenceNumber);
                                externalId_App  =   reportHeaderRecObj.applicationReferenceNumber.deleteWhitespace();
                                CommercialPR_EAE_Batch.extIdList.add(reportHeaderRecObj.applicationReferenceNumber.deleteWhitespace());
                            }
                            If(!Utility.ISStringBlankorNull(reportHeaderRecObj.inquiryPurpose))
                                transunionObj.Inquiry_Purpose__c = reportHeaderRecObj.inquiryPurpose.deleteWhitespace();
                        }
                        List<CommercialPR_EAE_Response.ReportIssuesVec> listreportIssuesVec =   responseReportObj.reportIssuesVec;
                        If(listreportIssuesVec !=null && !listreportIssuesVec.isEmpty()){
                            for(CommercialPR_EAE_Response.ReportIssuesVec   reportIssuesVecObj  :   listreportIssuesVec) {
                                If(reportIssuesVecObj !=null){
                                    TU_Error__c      tuErrorObj  = new TU_Error__c();
                                    If(!Utility.ISStringBlankorNull(reportIssuesVecObj.code)){
                                        tuErrorObj.Member_Code__c    =   reportIssuesVecObj.code.deleteWhitespace();
                                        If(!Utility.ISStringBlankorNull(customerId))
                                            tuErrorObj.Account__r    =   new Account(CBS_Customer_ID__c = customerId);
                                    }
                                    If(!Utility.ISStringBlankorNull(reportIssuesVecObj.message)){
                                        tuErrorObj.Response__c       =   reportIssuesVecObj.message.deleteWhitespace();
                                        accountObj.Bureau_Score__c   =   reportIssuesVecObj.message.deleteWhitespace();
                                        CommercialPR_EAE_Batch.listAccount.add(accountObj);    
                                    }
                                    If(!Utility.ISStringBlankorNull(reportIssuesVecObj.description)) 
                                        tuErrorObj.Error_Description__c  = reportIssuesVecObj.description.deleteWhitespace();
                                    system.debug('tuErrorObj/customerId=====> '+customerId);
                                    system.debug('tuErrorObj=====> '+tuErrorObj);
                                    CommercialPR_EAE_Batch.listTUError.add(tuErrorObj);
                                }
                            }
                        }
                        
                        //EnquiryInformationRec
                        CommercialPR_EAE_Response.EnquiryInformationRec enquiryInformationRecObj = responseReportObj.enquiryInformationRec;
                        If(enquiryInformationRecObj != null) {
                            If(!Utility.ISStringBlankorNull(enquiryInformationRecObj.borrowerName))
                                transunionObj.Borrower_Name__c = enquiryInformationRecObj.borrowerName;
                            If(!Utility.ISStringBlankorNull(enquiryInformationRecObj.pan))
                                transunionObj.Pan_Card_Number__c = enquiryInformationRecObj.pan.deleteWhitespace();
                            If(!Utility.ISStringBlankorNull(enquiryInformationRecObj.cin))
                                transunionObj.Cin__c = enquiryInformationRecObj.cin.deleteWhitespace();
                            If(!Utility.ISStringBlankorNull(enquiryInformationRecObj.tin))
                                transunionObj.Tin__c = enquiryInformationRecObj.tin.deleteWhitespace();
                            If(!Utility.ISStringBlankorNull(enquiryInformationRecObj.crn))
                                transunionObj.Crn__c = enquiryInformationRecObj.crn.deleteWhitespace();
                            If(!Utility.ISStringBlankorNull(enquiryInformationRecObj.addressCount))
                                transunionObj.Address_Count__c = Integer.valueOf(enquiryInformationRecObj.addressCount.deleteWhitespace());
                            
                            //AddressVec
                            CommercialPR_EAE_Response.AddressVec addressVecObj = enquiryInformationRecObj.addressVec;
                            If(addressVecObj != null) {
                                //Address
                                try{
                                    If(addressVecObj.address != null) {
                                        List <CommercialPR_EAE_Response.Address> listAddress = addressVecObj.address;
                                        If(listAddress != null) {
                                            for (CommercialPR_EAE_Response.Address addressObj: listAddress) {
                                                Location_Detail__c enquiryAddressObj = new Location_Detail__c();
                                                If(addressObj != null) {
                                                    If(!Utility.ISStringBlankorNull(addressObj.addressLine))
                                                        enquiryAddressObj.Address__c = addressObj.addressLine;
                                                    If(!Utility.ISStringBlankorNull(addressObj.city))
                                                        enquiryAddressObj.City__c = addressObj.city;
                                                    If(!Utility.ISStringBlankorNull(addressObj.state))
                                                        enquiryAddressObj.State_Name__c = addressObj.state;
                                                    If(!Utility.ISStringBlankorNull(addressObj.pinCode))
                                                        enquiryAddressObj.Pin_Code__c = addressObj.pinCode.deleteWhitespace();
                                                    
                                                    String recordtypeIDStr = recordtypeIdMap.get('Enquiry_Address');
                                                    enquiryAddressObj.recordtypeId  =   recordtypeIDStr;
                                                    enquiryAddressObj.Tu_Credit_Report__r = new ints__TransUnion_Credit_Report__c(External_Id__c = TranExternalId);
                                                    CommercialPR_EAE_Batch.listlocationDetail.add(enquiryAddressObj);
                                                }
                                            }
                                        }
                                        
                                    } 
                                }catch(Exception ex){
                                    System.debug('Line Number::'+ex.getLineNumber());
                                }
                                
                            }
                            
                        }
                        //ProductSec
                        CommercialPR_EAE_Response.ProductSec productSecObj = responseReportObj.productSec;
                        If(productSecObj != null) {
                            TU_Message__c messageObj = new TU_Message__c();
                            //BorrowerProfileSec
                            CommercialPR_EAE_Response.BorrowerProfileSec borrowerProfileSecObj = productSecObj.borrowerProfileSec;
                            If(borrowerProfileSecObj != null) {
                                //BorrwerDetails
                                CommercialPR_EAE_Response.BorrwerDetails borrwerDetailsObj = borrowerProfileSecObj.borrwerDetails;
                                If(borrwerDetailsObj != null) {
                                    If(!Utility.ISStringBlankorNull(borrwerDetailsObj.name))
                                        transunionObj.Borrower_Name__c = borrwerDetailsObj.name;
                                    If(!Utility.ISStringBlankorNull(borrwerDetailsObj.borrowersLegalConstitution))
                                        transunionObj.Borrowers_Legal_Constitution__c = borrwerDetailsObj.borrowersLegalConstitution.deleteWhitespace();
                                    If(!Utility.ISStringBlankorNull(borrwerDetailsObj.businessCategory))
                                        transunionObj.Business_Category__c = borrwerDetailsObj.businessCategory.deleteWhitespace();
                                    If(!Utility.ISStringBlankorNull(borrwerDetailsObj.businessIndustryType))
                                        transunionObj.Business_IndustryType__c = borrwerDetailsObj.businessIndustryType.deleteWhitespace();
                                    If(!Utility.ISStringBlankorNull(borrwerDetailsObj.numberOfEmployees))
                                        transunionObj.Number_Of_Employees__c = Integer.valueOf(borrwerDetailsObj.numberOfEmployees.deleteWhitespace());
                                    If(!Utility.ISStringBlankorNull(borrwerDetailsObj.dateOfIncorporation))
                                        transunionObj.Date_Of_Incorporation__c = borrwerDetailsObj.dateOfIncorporation.deleteWhitespace();
                                    If(!Utility.ISStringBlankorNull(borrwerDetailsObj.salesFigure))
                                        transunionObj.Sales_Figure__c = borrwerDetailsObj.salesFigure.deleteWhitespace();
                                    If(!Utility.ISStringBlankorNull(borrwerDetailsObj.year))
                                        transunionObj.Year__c = borrwerDetailsObj.year.deleteWhitespace();
                                    // classOfActivityVec
                                    If(borrwerDetailsObj.classOfActivityVec !=null){
                                        CommercialPR_EAE_Response.ClassOfActivityVec  classOfActivityVecObj          =   borrwerDetailsObj.classOfActivityVec;
                                        If(classOfActivityVecObj !=null){
                                            List<String> listclassOfActivity    = classOfActivityVecObj.classOfActivity;
                                            String classOfActiveTrans='';
                                            If(listclassOfActivity !=null){
                                                for(String classOfActivityObj   :   listclassOfActivity) {
                                                    If(classOfActivityObj !=null){
                                                        classOfActiveTrans += classOfActivityObj;
                                                        
                                                    }   
                                                }
                                                If(classOfActiveTrans != null && classOfActiveTrans !='') {
                                                    transunionObj.Class_of_Activity__c  = classOfActiveTrans;
                                                }
                                            }
                                        }
                                    }
                                }
                                
                                //BorrwerAddressContactDetails
                                CommercialPR_EAE_Response.BorrwerAddressContactDetails borrwerAddressContactDetailsObj = borrowerProfileSecObj.borrwerAddressContactDetails;
                                If(borrwerAddressContactDetailsObj != null) {
                                    If(!Utility.ISStringBlankorNull(borrwerAddressContactDetailsObj.address))
                                        transunionObj.Address__c = borrwerAddressContactDetailsObj.address;
                                    If(!Utility.ISStringBlankorNull(borrwerAddressContactDetailsObj.faxNumber))
                                        transunionObj.Fax_Number__c = borrwerAddressContactDetailsObj.faxNumber.deleteWhitespace();
                                    If(!Utility.ISStringBlankorNull(borrwerAddressContactDetailsObj.mobileNumber))
                                        transunionObj.Mobile_Number__c = borrwerAddressContactDetailsObj.mobileNumber.deleteWhitespace();
                                    If(!Utility.ISStringBlankorNull(borrwerAddressContactDetailsObj.telephoneNumber))
                                        transunionObj.Phone_Number__c = borrwerAddressContactDetailsObj.telephoneNumber.deleteWhitespace();
                                }
                                
                                //BorrwerIDDetailsVec
                                CommercialPR_EAE_Response.BorrwerIDDetailsVec borrwerIDDetailsVecObj = borrowerProfileSecObj.borrwerIDDetailsVec;
                                If(borrwerIDDetailsVecObj != null) {
                                    If(!Utility.ISStringBlankorNull(borrwerIDDetailsVecObj.lastReportedDate))
                                        transunionObj.Last_Reported_Date__c = borrwerIDDetailsVecObj.lastReportedDate.deleteWhitespace();
                                    //BorrwerIDDetails
                                    List < CommercialPR_EAE_Response.BorrwerIDDetails > listBorrwerIDDetails = borrwerIDDetailsVecObj.borrwerIDDetails;
                                    If(listBorrwerIDDetails != null) {
                                        
                                        for (CommercialPR_EAE_Response.BorrwerIDDetails borrwerIDDetailsObj: listBorrwerIDDetails) {
                                            TU_ID_s__c tuIDsObj = new TU_ID_s__c();
                                            If(borrwerIDDetailsObj != null) {
                                                
                                                If(!Utility.ISStringBlankorNull(borrwerIDDetailsObj.pan))
                                                    tuIDsObj.Pan_Card_Number__c = borrwerIDDetailsObj.pan.deleteWhitespace();
                                                If(!Utility.ISStringBlankorNull(borrwerIDDetailsObj.registrationNumber))
                                                    tuIDsObj.Registration_Number__c = borrwerIDDetailsObj.registrationNumber.deleteWhitespace();
                                                If(!Utility.ISStringBlankorNull(borrwerIDDetailsObj.cin))
                                                    tuIDsObj.Cin__c = borrwerIDDetailsObj.cin.deleteWhitespace();
                                                If(!Utility.ISStringBlankorNull(borrwerIDDetailsObj.tin))
                                                    tuIDsObj.Tin__c = borrwerIDDetailsObj.tin.deleteWhitespace();
                                                If(!Utility.ISStringBlankorNull(borrwerIDDetailsObj.serviceTaxNumber))
                                                    tuIDsObj.Service_Tax_Number__c = borrwerIDDetailsObj.serviceTaxNumber.deleteWhitespace();
                                                
                                                String recordtypeIDStr = recordtypeIdMap.get('Borrwer_ID_Details');
                                                tuIDsObj.recordtypeId   =   recordtypeIDStr;
                                                //tuIDsObj.recordtype.developerName = 'Borrwer_ID_Details';
                                                tuIDsObj.TU_Credit_Report__r = new ints__TransUnion_Credit_Report__c(External_Id__c = TranExternalId);
                                                CommercialPR_EAE_Batch.listTUIDs.add(tuIDsObj);
                                                
                                            }
                                            
                                        }
                                        
                                    }
                                    
                                }
                                
                                // BorrowerDelinquencyReportedOnBorrower  
                                CommercialPR_EAE_Response.BorrowerDelinquencyReportedOnBorrower borrowerDelinquencyReportedOnBorrowerObj = borrowerProfileSecObj.borrowerDelinquencyReportedOnBorrower;
                                If(borrowerDelinquencyReportedOnBorrowerObj != null) {
                                    //YourInstitution
                                    CommercialPR_EAE_Response.YourInstitution yourInstitutionObj = borrowerDelinquencyReportedOnBorrowerObj.yourInstitution;
                                    If(yourInstitutionObj != null) {
                                        transunionObj = CommercialPR_EAE_Response_Utility.getYourInstitution(yourInstitutionObj, transunionObj);
                                    }
                                    //Outside Institution
                                    CommercialPR_EAE_Response.YourInstitution yourInstitutionObj1 = borrowerDelinquencyReportedOnBorrowerObj.outsideInstitution;
                                    If(yourInstitutionObj1 != null) {
                                        transunionObj = CommercialPR_EAE_Response_Utility.getOutsideInstitution(yourInstitutionObj1, transunionObj);
                                    }
                                }
                                //BorrowerDelinquencyReportedOnRSOrGSOftheBorrowerIn24MonthsVec 
                                CommercialPR_EAE_Response.BorrowerDelinquencyReportedOnRSOrGSOftheBorrowerIn24MonthsVec borrowerDelinquencyReportedOnRSOrGSOftheBorrowerIn24MonthsVecObj = borrowerProfileSecObj.borrowerDelinquencyReportedOnRSOrGSOftheBorrowerIn24MonthsVec;
                                If(borrowerDelinquencyReportedOnRSOrGSOftheBorrowerIn24MonthsVecObj != null) {
                                    If(!Utility.ISStringBlankorNull(borrowerDelinquencyReportedOnRSOrGSOftheBorrowerIn24MonthsVecObj.message))
                                        transunionObj.Message__c = borrowerDelinquencyReportedOnRSOrGSOftheBorrowerIn24MonthsVecObj.message.deleteWhitespace();
                                    If(borrowerDelinquencyReportedOnRSOrGSOftheBorrowerIn24MonthsVecObj.borrowerDelinquencyReportedOnRSOrGSOftheBorrowerIn24Months !=null) {
                                        List<CommercialPR_EAE_Response.BorrowerDelinquencyReportedOnRSOrGSOftheBorrowerIn24Months>  listBorrowerDelinquencyReportedOnRSOrGSOftheBorrowerIn24Months = borrowerDelinquencyReportedOnRSOrGSOftheBorrowerIn24MonthsVecObj.borrowerDelinquencyReportedOnRSOrGSOftheBorrowerIn24Months; 
                                        If(listBorrowerDelinquencyReportedOnRSOrGSOftheBorrowerIn24Months !=null){
                                            for(CommercialPR_EAE_Response.BorrowerDelinquencyReportedOnRSOrGSOftheBorrowerIn24Months borrowerDelinquencyReportedOnRSOrGSOftheBorrowerIn24MonthsObj       :   listBorrowerDelinquencyReportedOnRSOrGSOftheBorrowerIn24Months) {
                                                Borrower_Delinquency_Report__c  borrowerDelinquencyReportObj    = new Borrower_Delinquency_Report__c();
                                                If(borrowerDelinquencyReportedOnRSOrGSOftheBorrowerIn24MonthsObj != null) {
                                                    If(!Utility.ISStringBlankorNull(borrowerDelinquencyReportedOnRSOrGSOftheBorrowerIn24MonthsObj.detail))
                                                        borrowerDelinquencyReportObj.Detail__c   =   borrowerDelinquencyReportedOnRSOrGSOftheBorrowerIn24MonthsObj.detail.deleteWhitespace();
                                                    If(!Utility.ISStringBlankorNull(borrowerDelinquencyReportedOnRSOrGSOftheBorrowerIn24MonthsObj.relationship))
                                                        borrowerDelinquencyReportObj.Relationship__c =   borrowerDelinquencyReportedOnRSOrGSOftheBorrowerIn24MonthsObj.relationship.deleteWhitespace(); 
                                                    If(!Utility.ISStringBlankorNull(borrowerDelinquencyReportedOnRSOrGSOftheBorrowerIn24MonthsObj.tl_count))
                                                        borrowerDelinquencyReportObj.tl_count__c =   borrowerDelinquencyReportedOnRSOrGSOftheBorrowerIn24MonthsObj.tl_count.deleteWhitespace(); 
                                                    If(!Utility.ISStringBlankorNull(borrowerDelinquencyReportedOnRSOrGSOftheBorrowerIn24MonthsObj.tl_outstanding))
                                                        borrowerDelinquencyReportObj.tl_outstanding__c   =   borrowerDelinquencyReportedOnRSOrGSOftheBorrowerIn24MonthsObj.tl_outstanding.deleteWhitespace();
                                                    If(!Utility.ISStringBlankorNull(borrowerDelinquencyReportedOnRSOrGSOftheBorrowerIn24MonthsObj.wc_count))
                                                        borrowerDelinquencyReportObj.wc_count__c =   borrowerDelinquencyReportedOnRSOrGSOftheBorrowerIn24MonthsObj.wc_count.deleteWhitespace();
                                                    If(!Utility.ISStringBlankorNull(borrowerDelinquencyReportedOnRSOrGSOftheBorrowerIn24MonthsObj.wc_outstanding))
                                                        borrowerDelinquencyReportObj.wc_outstanding__c   =   borrowerDelinquencyReportedOnRSOrGSOftheBorrowerIn24MonthsObj.wc_outstanding.deleteWhitespace();
                                                    If(!Utility.ISStringBlankorNull(borrowerDelinquencyReportedOnRSOrGSOftheBorrowerIn24MonthsObj.nf_count))
                                                        borrowerDelinquencyReportObj.nf_count__c =   borrowerDelinquencyReportedOnRSOrGSOftheBorrowerIn24MonthsObj.nf_count.deleteWhitespace();
                                                    If(!Utility.ISStringBlankorNull(borrowerDelinquencyReportedOnRSOrGSOftheBorrowerIn24MonthsObj.nf_outstanding))
                                                        borrowerDelinquencyReportObj.nf_outstanding__c   =   borrowerDelinquencyReportedOnRSOrGSOftheBorrowerIn24MonthsObj.nf_outstanding.deleteWhitespace();
                                                    If(!Utility.ISStringBlankorNull(borrowerDelinquencyReportedOnRSOrGSOftheBorrowerIn24MonthsObj.fx_count))
                                                        borrowerDelinquencyReportObj.fx_count__c =   borrowerDelinquencyReportedOnRSOrGSOftheBorrowerIn24MonthsObj.fx_count.deleteWhitespace();
                                                    If(!Utility.ISStringBlankorNull(borrowerDelinquencyReportedOnRSOrGSOftheBorrowerIn24MonthsObj.fx_outstanding))
                                                        borrowerDelinquencyReportObj.fx_outstanding__c   =   borrowerDelinquencyReportedOnRSOrGSOftheBorrowerIn24MonthsObj.fx_outstanding.deleteWhitespace();
                                                    
                                                    borrowerDelinquencyReportObj.Tu_Credit_Report__r = new ints__TransUnion_Credit_Report__c(External_Id__c = TranExternalId);
                                                    CommercialPR_EAE_Batch.listBorrowerDelinquencyReport.add(borrowerDelinquencyReportObj);
                                                }
                                            }
                                        }
                                    }
                                    
                                }
                            }
                            // RankSec   
                            CommercialPR_EAE_Response.RankSec rankSecObj = productSecObj.rankSec;
                            If(rankSecObj != null) {
                                //RankVec
                                List < CommercialPR_EAE_Response.RankVec > listRankVec = rankSecObj.rankVec;
                                
                                If(listRankVec != null && !listRankVec.isEmpty()) {
                                    
                                    for (CommercialPR_EAE_Response.RankVec rankVecObj: listRankVec) {
                                        RankVec__c rankVecObject = new RankVec__c();
                                        If(rankVecObj != null) {
                                            If(!Utility.ISStringBlankorNull(rankVecObj.rankName))
                                                rankVecObject.Rank_Name__c = rankVecObj.rankName;
                                            If(!Utility.ISStringBlankorNull(rankVecObj.rankValue)){
                                                if(rankVecObj.rankValue =='NA'){
                                                    rankVecObject.Rank_Value__c = rankVecObj.rankValue; 
                                                    accountObj.Bureau_Score__c  = rankVecObj.rankValue;      
                                                }else{
                                                    rankVecObject.Rank_Value__c = rankVecObj.rankValue;
                                                    String rankValue            =   rankVecObj.rankValue;
                                                    accountObj.Bureau_Score__c  = rankValue.split('-')[1];        
                                                }
                                                CommercialPR_EAE_Batch.listAccount.add(accountObj);
                                                  
                                            }
                                            system.debug('CommercialPR_EAE_Batch.rankVecObject'+rankVecObject);
                                            If(!Utility.ISStringBlankorNull(rankVecObj.exclusionReason))
                                                rankVecObject.Exclusion_Reason__c = rankVecObj.exclusionReason;
                                            
                                            rankVecObject.Tu_Credit_Report__r = new ints__TransUnion_Credit_Report__c(External_Id__c = TranExternalId);
                                            CommercialPR_EAE_Batch.listRankVecObj.add(rankVecObject);
                                            system.debug('CommercialPR_EAE_Batch.listRankVecObj'+CommercialPR_EAE_Batch.listRankVecObj);
                                        }
                                    }
                                    
                                }
                                
                            }
                            //CreditProfileSummarySec               
                            CommercialPR_EAE_Response.CreditProfileSummarySec creditProfileSummarySecObj = productSecObj.creditProfileSummarySec;
                            If(creditProfileSummarySecObj != null) {
                                //YourInstitution_Z
                                CommercialPR_EAE_Response.YourInstitution_Z yourInstitutionObj = creditProfileSummarySecObj.yourInstitution;
                                If(yourInstitutionObj != null) {
                                    //Credit Profile
                                    try {
                                        Credit_Profile__c creditProfileObj = new Credit_Profile__c();
                                        creditProfileObj.Type__c = 'Your Institution';
                                        If(!Utility.ISStringBlankorNull(yourInstitutionObj.totalLenders))
                                            creditProfileObj.Total_Lender__c = Integer.valueOf(yourInstitutionObj.totalLenders.deleteWhitespace());
                                        If(!Utility.ISStringBlankorNull(yourInstitutionObj.openCF))
                                            creditProfileObj.Open_CF__c = Integer.valueOf(yourInstitutionObj.openCF.deleteWhitespace());
                                        If(!Utility.ISStringBlankorNull(yourInstitutionObj.latestCFOpenedDate))
                                            creditProfileObj.Latest_Opened_CF_Date__c = yourInstitutionObj.latestCFOpenedDate.deleteWhitespace();
                                        
                                        //TotalCF
                                        CommercialPR_EAE_Response.TotalCF totalCFObj = yourInstitutionObj.totalCF;
                                        If(totalCFObj != null) {
                                            creditProfileObj = CommercialPR_EAE_Response_Utility.getTotalCF(totalCFObj, creditProfileObj);
                                        }
                                        //TotalCF
                                        CommercialPR_EAE_Response.TotalCF delinquentCFObj = yourInstitutionObj.delinquentCF;
                                        If(delinquentCFObj != null) {
                                            creditProfileObj = CommercialPR_EAE_Response_Utility.getDelinquentCF(delinquentCFObj, creditProfileObj);
                                        }
                                        //TotalOutstanding
                                        CommercialPR_EAE_Response.TotalCF totalOutstandingObj = yourInstitutionObj.totalOutstanding;
                                        If(totalOutstandingObj != null) {
                                            creditProfileObj = CommercialPR_EAE_Response_Utility.getTotalCF(totalOutstandingObj, creditProfileObj);
                                        }
                                        //TotalOutstanding
                                        CommercialPR_EAE_Response.TotalCF delinquentOutstandingObj = yourInstitutionObj.delinquentOutstanding;
                                        If(delinquentOutstandingObj != null) {
                                            creditProfileObj = CommercialPR_EAE_Response_Utility.getTotalCF(delinquentOutstandingObj, creditProfileObj);
                                        }
                                        
                                        creditProfileObj.TuCredit_Report__r = new ints__TransUnion_Credit_Report__c(External_Id__c = TranExternalId);
                                        CommercialPR_EAE_Batch.listcreditProfile.add(creditProfileObj);
                                    } catch (Exception Ex) {
                                        System.debug('Exception' + Ex);
                                        System.debug('Line Number' + Ex.getLineNumber());
                                    }
                                    
                                }
                                //OutsideInstitution
                                CommercialPR_EAE_Response.OutsideInstitution outsideInstitutionObj = creditProfileSummarySecObj.outsideInstitution;
                                If(outsideInstitutionObj != null) {
                                    
                                    //OtherPublicSectorBanks
                                    CommercialPR_EAE_Response.YourInstitution_Z otherPublicSectorBanksObj = outsideInstitutionObj.otherPublicSectorBanks;
                                    
                                    If(otherPublicSectorBanksObj != null) {
                                        Credit_Profile__c creditProfileObj = new Credit_Profile__c();
                                        creditProfileObj.Type__c = 'Outside Institution';
                                        creditProfileObj.Sub_Type__c = 'Other Public Sector Banks';
                                        If(!Utility.ISStringBlankorNull(otherPublicSectorBanksObj.message))
                                            creditProfileObj.Message__c = otherPublicSectorBanksObj.message.deleteWhitespace();
                                        If(!Utility.ISStringBlankorNull(otherPublicSectorBanksObj.totalLenders))
                                            creditProfileObj.Total_Lender__c = Integer.valueOf(otherPublicSectorBanksObj.totalLenders.deleteWhitespace());
                                        If(!Utility.ISStringBlankorNull(otherPublicSectorBanksObj.openCF))
                                            creditProfileObj.Open_CF__c = Integer.valueOf(otherPublicSectorBanksObj.openCF.deleteWhitespace());
                                        //TotalCF
                                        creditProfileObj = CommercialPR_EAE_Response_Utility.getTotalCF(otherPublicSectorBanksObj.totalCF, creditProfileObj);
                                        creditProfileObj = CommercialPR_EAE_Response_Utility.getTotalCF(otherPublicSectorBanksObj.totalOutstanding, creditProfileObj);
                                        creditProfileObj = CommercialPR_EAE_Response_Utility.getDelinquentCF(otherPublicSectorBanksObj.delinquentCF, creditProfileObj);
                                        creditProfileObj = CommercialPR_EAE_Response_Utility.getTotalCF(otherPublicSectorBanksObj.delinquentOutstanding, creditProfileObj);
                                        
                                        creditProfileObj.TuCredit_Report__r = new ints__TransUnion_Credit_Report__c(External_Id__c = TranExternalId);
                                        CommercialPR_EAE_Batch.listcreditProfile.add(creditProfileObj);
                                    }
                                    //OtherPrivateForeignBanks
                                    CommercialPR_EAE_Response.YourInstitution_Z otherPrivateForeignBanksObj = outsideInstitutionObj.otherPrivateForeignBanks;
                                    If(otherPrivateForeignBanksObj != null) {
                                        Credit_Profile__c creditProfileObj = new Credit_Profile__c();
                                        creditProfileObj.Type__c = 'Outside Institution';
                                        creditProfileObj.Sub_Type__c = 'Other Private Foreign Banks';
                                        If(!Utility.ISStringBlankorNull(otherPrivateForeignBanksObj.message))
                                            creditProfileObj.Message__c = otherPrivateForeignBanksObj.message.deleteWhitespace();
                                        If(!Utility.ISStringBlankorNull(otherPrivateForeignBanksObj.totalLenders))
                                            creditProfileObj.Total_Lender__c = Integer.valueOf(otherPrivateForeignBanksObj.totalLenders.deleteWhitespace());
                                        If(!Utility.ISStringBlankorNull(otherPrivateForeignBanksObj.openCF))
                                            creditProfileObj.Open_CF__c = Integer.valueOf(otherPrivateForeignBanksObj.openCF.deleteWhitespace());
                                        If(!Utility.ISStringBlankorNull(otherPrivateForeignBanksObj.latestCFOpenedDate))
                                            creditProfileObj.Latest_Opened_CF_Date__c = otherPrivateForeignBanksObj.latestCFOpenedDate.deleteWhitespace();
                                        //TotalCF
                                        creditProfileObj = CommercialPR_EAE_Response_Utility.getTotalCF(otherPrivateForeignBanksObj.totalCF, creditProfileObj);
                                        creditProfileObj = CommercialPR_EAE_Response_Utility.getTotalCF(otherPrivateForeignBanksObj.totalOutstanding, creditProfileObj);
                                        creditProfileObj = CommercialPR_EAE_Response_Utility.getDelinquentCF(otherPrivateForeignBanksObj.delinquentCF, creditProfileObj);
                                        creditProfileObj = CommercialPR_EAE_Response_Utility.getTotalCF(otherPrivateForeignBanksObj.delinquentOutstanding, creditProfileObj);
                                        
                                        creditProfileObj.TuCredit_Report__r = new ints__TransUnion_Credit_Report__c(External_Id__c = TranExternalId);
                                        CommercialPR_EAE_Batch.listcreditProfile.add(creditProfileObj);
                                    }
                                    //NBFC_Others
                                    CommercialPR_EAE_Response.YourInstitution_Z nBFC_OthersObj = outsideInstitutionObj.nBFC_Others;
                                    If(nBFC_OthersObj != null) {
                                        Credit_Profile__c creditProfileObj = new Credit_Profile__c();
                                        creditProfileObj.Type__c = 'Outside Institution';
                                        creditProfileObj.Sub_Type__c = 'NBFC Others';
                                        If(!Utility.ISStringBlankorNull(nBFC_OthersObj.totalLenders))
                                            creditProfileObj.Total_Lender__c = Integer.valueOf(nBFC_OthersObj.totalLenders.deleteWhitespace());
                                        If(!Utility.ISStringBlankorNull(nBFC_OthersObj.openCF))
                                            creditProfileObj.Open_CF__c = Integer.valueOf(nBFC_OthersObj.openCF.deleteWhitespace());
                                        If(!Utility.ISStringBlankorNull(nBFC_OthersObj.latestCFOpenedDate))
                                            creditProfileObj.Latest_Opened_CF_Date__c = nBFC_OthersObj.latestCFOpenedDate.deleteWhitespace();
                                        //TotalCF
                                        creditProfileObj = CommercialPR_EAE_Response_Utility.getTotalCF(nBFC_OthersObj.totalCF, creditProfileObj);
                                        creditProfileObj = CommercialPR_EAE_Response_Utility.getTotalCF(nBFC_OthersObj.totalOutstanding, creditProfileObj);
                                        creditProfileObj = CommercialPR_EAE_Response_Utility.getDelinquentCF(nBFC_OthersObj.delinquentCF, creditProfileObj);
                                        creditProfileObj = CommercialPR_EAE_Response_Utility.getTotalCF(nBFC_OthersObj.delinquentOutstanding, creditProfileObj);
                                        
                                        creditProfileObj.TuCredit_Report__r = new ints__TransUnion_Credit_Report__c(External_Id__c = TranExternalId);
                                        CommercialPR_EAE_Batch.listcreditProfile.add(creditProfileObj);
                                    }
                                    //YourInstitution_Z
                                    CommercialPR_EAE_Response.YourInstitution_Z OutsideTotalObj = outsideInstitutionObj.OutsideTotal;
                                    If(OutsideTotalObj != null) {
                                        //CreditProfile
                                        Credit_Profile__c creditProfileObj = new Credit_Profile__c();
                                        creditProfileObj.Type__c = 'Outside Institution';
                                        creditProfileObj.Sub_Type__c = 'Your Institution';
                                        
                                        If(!Utility.ISStringBlankorNull(yourInstitutionObj.totalLenders))
                                            creditProfileObj.Total_Lender__c = Integer.valueOf(OutsideTotalObj.totalLenders.deleteWhitespace());
                                        If(!Utility.ISStringBlankorNull(yourInstitutionObj.openCF))
                                            creditProfileObj.Open_CF__c = Integer.valueOf(yourInstitutionObj.openCF.deleteWhitespace());
                                        If(!Utility.ISStringBlankorNull(yourInstitutionObj.latestCFOpenedDate))
                                            creditProfileObj.Latest_Opened_CF_Date__c = OutsideTotalObj.latestCFOpenedDate.deleteWhitespace();
                                        
                                        //TotalCF
                                        If(OutsideTotalObj.totalCF !=null){
                                            CommercialPR_EAE_Response.TotalCF totalCFObj = OutsideTotalObj.totalCF;
                                            If(totalCFObj != null) {
                                                creditProfileObj = CommercialPR_EAE_Response_Utility.getTotalCF(totalCFObj, creditProfileObj);
                                            }  
                                        }
                                        
                                        //TotalCF
                                        CommercialPR_EAE_Response.TotalCF delinquentCFObj = OutsideTotalObj.delinquentCF;
                                        If(delinquentCFObj != null) {
                                            creditProfileObj = CommercialPR_EAE_Response_Utility.getDelinquentCF(delinquentCFObj, creditProfileObj);
                                        }
                                        //TotalOutstanding
                                        CommercialPR_EAE_Response.TotalCF totalOutstandingObj = OutsideTotalObj.totalOutstanding;
                                        If(totalOutstandingObj != null) {
                                            creditProfileObj = CommercialPR_EAE_Response_Utility.getTotalOutstanding(totalOutstandingObj, creditProfileObj);
                                        }
                                        //TotalOutstanding
                                        If(OutsideTotalObj.delinquentOutstanding !=null){
                                            CommercialPR_EAE_Response.TotalCF delinquentOutstandingObj = OutsideTotalObj.delinquentOutstanding;
                                            If(delinquentOutstandingObj != null) {
                                                creditProfileObj = CommercialPR_EAE_Response_Utility.getDelinquentOutstanding(delinquentOutstandingObj, creditProfileObj);
                                            } 
                                        }
                                        
                                        creditProfileObj.TuCredit_Report__r = new ints__TransUnion_Credit_Report__c(External_Id__c = TranExternalId);
                                        CommercialPR_EAE_Batch.listcreditProfile.add(creditProfileObj);
                                    }
                                    
                                }
                                //Total
                                CommercialPR_EAE_Response.Total totalObj = creditProfileSummarySecObj.total;
                                If(totalObj != null) {
                                    Credit_Profile__c creditProfileObj = new Credit_Profile__c();
                                    creditProfileObj.Type__c = 'Total';
                                    creditProfileObj = CommercialPR_EAE_Response_Utility.getTotal(totalObj, creditProfileObj);
                                    creditProfileObj.TuCredit_Report__r = new ints__TransUnion_Credit_Report__c(External_Id__c = TranExternalId);
                                    CommercialPR_EAE_Batch.listcreditProfile.add(creditProfileObj);
                                }
                            }
                            //EnquirySummarySec
                            CommercialPR_EAE_Response.EnquirySummarySec enquirySummarySecObj = productSecObj.enquirySummarySec;
                            If(enquirySummarySecObj != null) {
                                //EnquiryYourInstitution
                                CommercialPR_EAE_Response.EnquiryYourInstitution enquiryYourInstitutionObj = enquirySummarySecObj.enquiryYourInstitution;
                                If(enquiryYourInstitutionObj != null) {
                                    Enquiry_Summary__c enquirySummaryObj = new Enquiry_Summary__c();
                                    enquirySummaryObj.Type__c = 'Your Institution';
                                    
                                    CommercialPR_EAE_Response.NoOfEnquiries noOfEnquiriesObj = enquiryYourInstitutionObj.noOfEnquiries;
                                    If(noOfEnquiriesObj != null) {
                                        If(!Utility.ISStringBlankorNull(noOfEnquiriesObj.month1))
                                            enquirySummaryObj.Month1__c = Integer.valueOf(noOfEnquiriesObj.month1.deleteWhitespace());
                                        If(!Utility.ISStringBlankorNull(noOfEnquiriesObj.month2to3))
                                            enquirySummaryObj.Month2to3__c = Integer.valueOf(noOfEnquiriesObj.month2to3.deleteWhitespace());
                                        If(!Utility.ISStringBlankorNull(noOfEnquiriesObj.month4to6))
                                            enquirySummaryObj.Month4to6__c = Integer.valueOf(noOfEnquiriesObj.month4to6.deleteWhitespace());
                                        If(!Utility.ISStringBlankorNull(noOfEnquiriesObj.month7to12))
                                            enquirySummaryObj.Month7to12__c = Integer.valueOf(noOfEnquiriesObj.month7to12.deleteWhitespace());
                                        If(!Utility.ISStringBlankorNull(noOfEnquiriesObj.month12to24))
                                            enquirySummaryObj.Month12to24__c = Integer.valueOf(noOfEnquiriesObj.month12to24.deleteWhitespace());
                                        If(!Utility.ISStringBlankorNull(noOfEnquiriesObj.greaterthan24Month))
                                            enquirySummaryObj.Greater_than_24Month__c = Integer.valueOf(noOfEnquiriesObj.greaterthan24Month.deleteWhitespace());
                                        
                                        If(!Utility.ISStringBlankorNull(noOfEnquiriesObj.total))
                                            enquirySummaryObj.Total__c = Integer.valueOf(noOfEnquiriesObj.total.deleteWhitespace());
                                    }
                                    enquirySummaryObj.Tu_Credit_Report__r = new ints__TransUnion_Credit_Report__c(External_Id__c = TranExternalId);
                                    CommercialPR_EAE_Batch.listenquirySummary.add(enquirySummaryObj);
                                }
                                //EnquiryOutsideInstitution
                                CommercialPR_EAE_Response.EnquiryYourInstitution enquiryOutsideInstitutionObj = enquirySummarySecObj.enquiryOutsideInstitution;
                                If(enquiryOutsideInstitutionObj != null) {
                                    Enquiry_Summary__c enquirySummaryObj = new Enquiry_Summary__c();
                                    enquirySummaryObj.Type__c = 'Outside Institution';
                                    CommercialPR_EAE_Response.NoOfEnquiries noOfEnquiriesObj = enquiryOutsideInstitutionObj.noOfEnquiries;
                                    If(noOfEnquiriesObj != null) {
                                        If(!Utility.ISStringBlankorNull(noOfEnquiriesObj.month1))
                                            enquirySummaryObj.Month1__c = Integer.valueOf(noOfEnquiriesObj.month1.deleteWhitespace());
                                        If(!Utility.ISStringBlankorNull(noOfEnquiriesObj.month2to3))
                                            enquirySummaryObj.Month2to3__c = Integer.valueOf(noOfEnquiriesObj.month2to3.deleteWhitespace());
                                        If(!Utility.ISStringBlankorNull(noOfEnquiriesObj.month4to6))
                                            enquirySummaryObj.Month4to6__c = Integer.valueOf(noOfEnquiriesObj.month4to6.deleteWhitespace());
                                        If(!Utility.ISStringBlankorNull(noOfEnquiriesObj.month7to12))
                                            enquirySummaryObj.Month7to12__c = Integer.valueOf(noOfEnquiriesObj.month7to12.deleteWhitespace());
                                        If(!Utility.ISStringBlankorNull(noOfEnquiriesObj.month12to24))
                                            enquirySummaryObj.Month12to24__c = Integer.valueOf(noOfEnquiriesObj.month12to24.deleteWhitespace());
                                        If(!Utility.ISStringBlankorNull(noOfEnquiriesObj.greaterthan24Month))
                                            enquirySummaryObj.Greater_than_24Month__c = Integer.valueOf(noOfEnquiriesObj.greaterthan24Month.deleteWhitespace());
                                        If(!Utility.ISStringBlankorNull(noOfEnquiriesObj.total))
                                            enquirySummaryObj.Total__c = Integer.valueOf(noOfEnquiriesObj.total.deleteWhitespace());
                                        If(!Utility.ISStringBlankorNull(noOfEnquiriesObj.mostRecentDate))
                                            enquirySummaryObj.Most_Recent__c = noOfEnquiriesObj.mostRecentDate.deleteWhitespace();
                                    }
                                    enquirySummaryObj.Tu_Credit_Report__r = new ints__TransUnion_Credit_Report__c(External_Id__c = TranExternalId);
                                    CommercialPR_EAE_Batch.listenquirySummary.add(enquirySummaryObj);
                                }
                                //EnquiryYourInstitution
                                CommercialPR_EAE_Response.EnquiryYourInstitution enquiryTotalObj = enquirySummarySecObj.enquiryTotal;
                                If(enquiryTotalObj != null) {
                                    Enquiry_Summary__c enquirySummaryObj = new Enquiry_Summary__c();
                                    enquirySummaryObj.Type__c = 'Total';
                                    CommercialPR_EAE_Response.NoOfEnquiries noOfEnquiriesObj = enquiryTotalObj.noOfEnquiries;
                                    If(noOfEnquiriesObj != null) {
                                        If(!Utility.ISStringBlankorNull(noOfEnquiriesObj.month1))
                                            enquirySummaryObj.Month1__c = Integer.valueOf(noOfEnquiriesObj.month1.deleteWhitespace());
                                        If(!Utility.ISStringBlankorNull(noOfEnquiriesObj.month2to3))
                                            enquirySummaryObj.Month2to3__c = Integer.valueOf(noOfEnquiriesObj.month2to3.deleteWhitespace());
                                        If(!Utility.ISStringBlankorNull(noOfEnquiriesObj.month4to6))
                                            enquirySummaryObj.Month4to6__c = Integer.valueOf(noOfEnquiriesObj.month4to6.deleteWhitespace());
                                        If(!Utility.ISStringBlankorNull(noOfEnquiriesObj.month7to12))
                                            enquirySummaryObj.Month7to12__c = Integer.valueOf(noOfEnquiriesObj.month7to12.deleteWhitespace());
                                        If(!Utility.ISStringBlankorNull(noOfEnquiriesObj.month12to24))
                                            enquirySummaryObj.Month12to24__c = Integer.valueOf(noOfEnquiriesObj.month12to24.deleteWhitespace());
                                        If(!Utility.ISStringBlankorNull(noOfEnquiriesObj.greaterthan24Month))
                                            enquirySummaryObj.Greater_than_24Month__c = Integer.valueOf(noOfEnquiriesObj.greaterthan24Month.deleteWhitespace());
                                        
                                        If(!Utility.ISStringBlankorNull(noOfEnquiriesObj.total))
                                            enquirySummaryObj.Total__c = Integer.valueOf(noOfEnquiriesObj.total.deleteWhitespace());
                                    }
                                    enquirySummaryObj.Tu_Credit_Report__r = new ints__TransUnion_Credit_Report__c(External_Id__c = TranExternalId);
                                    CommercialPR_EAE_Batch.listenquirySummary.add(enquirySummaryObj);
                                }
                            }
                            //DerogatoryInformationSec
                            CommercialPR_EAE_Response.DerogatoryInformationSec derogatoryInformationSecObj = productSecObj.derogatoryInformationSec;
                            If(derogatoryInformationSecObj != null) {
                                Derogatory_Information__c derogatoryInformationObj = new Derogatory_Information__c();
                                
                                If(!Utility.ISStringBlankorNull(derogatoryInformationSecObj.message))
                                    derogatoryInformationObj.Message__c = derogatoryInformationSecObj.message.deleteWhitespace();
                                If(!Utility.ISStringBlankorNull(derogatoryInformationSecObj.messageOfBorrower))
                                    derogatoryInformationObj.Message_Of_Borrower__c = derogatoryInformationSecObj.messageOfBorrower.deleteWhitespace();
                                If(!Utility.ISStringBlankorNull(derogatoryInformationSecObj.messageOfBorrowerYourInstitution))
                                    derogatoryInformationObj.message_of_Borrower_Your_Institution__c = derogatoryInformationSecObj.messageOfBorrowerYourInstitution.deleteWhitespace();
                                If(!Utility.ISStringBlankorNull(derogatoryInformationSecObj.messageOfBorrowerOutsideInstitution))
                                    derogatoryInformationObj.Message_of_Borrower_Outside_Institution__c = derogatoryInformationSecObj.messageOfBorrowerOutsideInstitution.deleteWhitespace();
                                If(!Utility.ISStringBlankorNull(derogatoryInformationSecObj.messageOfRelatedParties))
                                    derogatoryInformationObj.Message_of_Related_Parties__c = derogatoryInformationSecObj.messageOfRelatedParties.deleteWhitespace();
                                If(!Utility.ISStringBlankorNull(derogatoryInformationSecObj.messageOfRelatedPartiesYourInstitution))
                                    derogatoryInformationObj.Message_ofRelatedParties_yourInstitution__c = derogatoryInformationSecObj.messageOfRelatedPartiesYourInstitution.deleteWhitespace();
                                If(!Utility.ISStringBlankorNull(derogatoryInformationSecObj.messageOfRelatedPartiesOutsideInstitution))
                                    derogatoryInformationObj.messageOfRelatedPartiesOutsideInstitutio__c = derogatoryInformationSecObj.messageOfRelatedPartiesOutsideInstitution.deleteWhitespace();
                                If(!Utility.ISStringBlankorNull(derogatoryInformationSecObj.messageOfGuarantedParties))
                                    derogatoryInformationObj.Message_of_Guaranted_Parties__c = derogatoryInformationSecObj.messageOfGuarantedParties.deleteWhitespace();
                                
                                //DerogatoryInformationReportedOnGuarantedPartiesVec
                                CommercialPR_EAE_Response.DerogatoryInformationReportedOnGuarantedPartiesVec     derogatoryInformationReportedOnGuarantedPartiesVecObj = derogatoryInformationSecObj.derogatoryInformationReportedOnGuarantedPartiesVec;
                                If(derogatoryInformationReportedOnGuarantedPartiesVecObj !=null){
                                    If(derogatoryInformationReportedOnGuarantedPartiesVecObj.derogatoryInformationReportedOnGuarantedParties !=null){
                                        List<String> listDerogatoryInformationReportedOnGuarantedParties   =   derogatoryInformationReportedOnGuarantedPartiesVecObj.derogatoryInformationReportedOnGuarantedParties;
                                        If(listDerogatoryInformationReportedOnGuarantedParties !=null) {
                                            String derogatoryInformationReportedOnGuarantedPartiesStr = '';
                                            for(String derogatoryInformationReportedOnGuarantedPartiesObj  : listDerogatoryInformationReportedOnGuarantedParties) {
                                                If(derogatoryInformationReportedOnGuarantedPartiesObj !=null) {
                                                    derogatoryInformationReportedOnGuarantedPartiesStr += derogatoryInformationReportedOnGuarantedPartiesObj;
                                                }   
                                            }
                                            If(derogatoryInformationReportedOnGuarantedPartiesStr !=null && derogatoryInformationReportedOnGuarantedPartiesStr !=''){
                                                derogatoryInformationObj.DerogatoryInformationReportedOnGuaranted__c = derogatoryInformationReportedOnGuarantedPartiesStr;
                                            }
                                        }    
                                    }
                                    
                                }
                                //DerogatoryInformationBorrower
                                CommercialPR_EAE_Response.DerogatoryInformationBorrower derogatoryInformationBorrowerObj = derogatoryInformationSecObj.derogatoryInformationBorrower;
                                If(derogatoryInformationBorrowerObj != null) {
                                    CommercialPR_EAE_Response.YourInstitution_Y yourInstitutionObj = derogatoryInformationBorrowerObj.yourInstitution;
                                    If(yourInstitutionObj != null) {
                                        Derogatory_Information__c derogatoryInformationObject = new Derogatory_Information__c();
                                        derogatoryInformationObject = CommercialPR_EAE_Response_Utility.getYourInstitution_Y(yourInstitutionObj, derogatoryInformationObject);
                                        derogatoryInformationObject.SubType__C = 'Your Institution';
                                        derogatoryInformationObject.Type__c = 'Derogatory Information Borrower';
                                        derogatoryInformationObject.Tu_Credit_Report__r = new ints__TransUnion_Credit_Report__c(External_Id__c = TranExternalId);
                                        CommercialPR_EAE_Batch.listderogatoryInformation.add(derogatoryInformationObject);
                                    }
                                    
                                    CommercialPR_EAE_Response.YourInstitution_Y outsideInstitutionObj = derogatoryInformationBorrowerObj.outsideInstitution;
                                    If(outsideInstitutionObj != null) {
                                        Derogatory_Information__c derogatoryInformationObject = new Derogatory_Information__c();
                                        derogatoryInformationObject.Type__c = 'Derogatory Information Borrower';
                                        derogatoryInformationObject.SubType__c = 'Outside Institution';
                                        derogatoryInformationObject = CommercialPR_EAE_Response_Utility.getYourInstitution_Y(outsideInstitutionObj, derogatoryInformationObject);
                                        derogatoryInformationObject.Tu_Credit_Report__r = new ints__TransUnion_Credit_Report__c(External_Id__c = TranExternalId);
                                        CommercialPR_EAE_Batch.listderogatoryInformation.add(derogatoryInformationObject);
                                    }
                                    CommercialPR_EAE_Response.YourInstitution_Y totalObj = derogatoryInformationBorrowerObj.total;
                                    If(totalObj != null) {
                                        Derogatory_Information__c derogatoryInformationObject = new Derogatory_Information__c();
                                        derogatoryInformationObject.Type__c = 'Derogatory Information Borrower';
                                        derogatoryInformationObject.SubType__c = 'Total';
                                        derogatoryInformationObject = CommercialPR_EAE_Response_Utility.getYourInstitution_Y(totalObj, derogatoryInformationObject);
                                        derogatoryInformationObject.Tu_Credit_Report__r = new ints__TransUnion_Credit_Report__c(External_Id__c = TranExternalId);
                                        CommercialPR_EAE_Batch.listderogatoryInformation.add(derogatoryInformationObject);
                                    }
                                    
                                }
                                //DerogatoryInformationBorrower
                                CommercialPR_EAE_Response.DerogatoryInformationBorrower derogatoryInformationOnRelatedPartiesOrGuarantorsOfBorrowerSecObj = derogatoryInformationSecObj.derogatoryInformationOnRelatedPartiesOrGuarantorsOfBorrowerSec;
                                If(derogatoryInformationOnRelatedPartiesOrGuarantorsOfBorrowerSecObj != null) {
                                    CommercialPR_EAE_Response.YourInstitution_Y yourInstitutionObj = derogatoryInformationOnRelatedPartiesOrGuarantorsOfBorrowerSecObj.yourInstitution;
                                    If(yourInstitutionObj != null) {
                                        Derogatory_Information__c derogatoryInformationObject = new Derogatory_Information__c();
                                        derogatoryInformationObject.SubType__c = 'Your Institution';
                                        derogatoryInformationObject.Type__c = 'Derogatory Information on Related Parties or Guarantors of BorrowerSec';
                                        derogatoryInformationObject = CommercialPR_EAE_Response_Utility.getYourInstitution_Y(yourInstitutionObj, derogatoryInformationObject);
                                        derogatoryInformationObject.Tu_Credit_Report__r = new ints__TransUnion_Credit_Report__c(External_Id__c = TranExternalId);
                                        CommercialPR_EAE_Batch.listderogatoryInformation.add(derogatoryInformationObject);
                                    }
                                    
                                    CommercialPR_EAE_Response.YourInstitution_Y outsideInstitutionObj = derogatoryInformationOnRelatedPartiesOrGuarantorsOfBorrowerSecObj.outsideInstitution;
                                    If(outsideInstitutionObj != null) {
                                        //transunionObj =   CommercialPR_EAE_Response_Utility.getYourInstitution_Y(outsideInstitutionObj,transunionObj);
                                        Derogatory_Information__c derogatoryInformationObject = new Derogatory_Information__c();
                                        derogatoryInformationObject.Type__c = 'Derogatory Information on Related Parties or Guarantors of BorrowerSec';
                                        derogatoryInformationObject.SubType__c = 'Outside Institution';
                                        derogatoryInformationObject = CommercialPR_EAE_Response_Utility.getYourInstitution_Y(outsideInstitutionObj, derogatoryInformationObject);
                                        derogatoryInformationObject.Tu_Credit_Report__r = new ints__TransUnion_Credit_Report__c(External_Id__c = TranExternalId);
                                        CommercialPR_EAE_Batch.listderogatoryInformation.add(derogatoryInformationObject);
                                    }
                                    CommercialPR_EAE_Response.YourInstitution_Y totalObj = derogatoryInformationOnRelatedPartiesOrGuarantorsOfBorrowerSecObj.total;
                                    If(totalObj != null) {
                                        //transunionObj =   CommercialPR_EAE_Response_Utility.getYourInstitution_Y(totalObj,transunionObj);
                                        Derogatory_Information__c derogatoryInformationObject = new Derogatory_Information__c();
                                        derogatoryInformationObject.Type__c = 'Derogatory Information on Related Parties or Guarantors of BorrowerSec';
                                        derogatoryInformationObject.SubType__c = 'Total';
                                        derogatoryInformationObject = CommercialPR_EAE_Response_Utility.getYourInstitution_Y(totalObj, derogatoryInformationObject);
                                        derogatoryInformationObject.Tu_Credit_Report__r = new ints__TransUnion_Credit_Report__c(External_Id__c = TranExternalId);
                                        CommercialPR_EAE_Batch.listderogatoryInformation.add(derogatoryInformationObject);
                                    }
                                }
                                derogatoryInformationObj.Tu_Credit_Report__r = new ints__TransUnion_Credit_Report__c(External_Id__c = TranExternalId);
                                CommercialPR_EAE_Batch.listderogatoryInformationParent.add(derogatoryInformationObj);
                            }
                            //OustandingBalanceByCFAndAssetClasificationSec
                            CommercialPR_EAE_Response.OustandingBalanceByCFAndAssetClasificationSec oustandingBalanceByCFAndAssetClasificationSecObj = productSecObj.oustandingBalanceByCFAndAssetClasificationSec;
                            If(oustandingBalanceByCFAndAssetClasificationSecObj != null) {
                                //YourInstitution_X
                                CommercialPR_EAE_Response.YourInstitution_X yourInstitutionObj = oustandingBalanceByCFAndAssetClasificationSecObj.yourInstitution;
                                If(yourInstitutionObj != null) {
                                    OustandingBalancebyCF__c oustandingBalancebyCFObj = new OustandingBalancebyCF__c();
                                    oustandingBalancebyCFObj.Type__c = 'Your Institution';
                                    oustandingBalancebyCFObj = CommercialPR_EAE_Response_Utility.getNonFunded(yourInstitutionObj.nonFunded, oustandingBalancebyCFObj);
                                    oustandingBalancebyCFObj = CommercialPR_EAE_Response_Utility.getNonFunded(yourInstitutionObj.workingCapital, oustandingBalancebyCFObj);
                                    oustandingBalancebyCFObj = CommercialPR_EAE_Response_Utility.getNonFunded(yourInstitutionObj.termLoan, oustandingBalancebyCFObj);
                                    oustandingBalancebyCFObj = CommercialPR_EAE_Response_Utility.getNonFunded(yourInstitutionObj.forex, oustandingBalancebyCFObj);
                                    oustandingBalancebyCFObj = CommercialPR_EAE_Response_Utility.getNonFunded(yourInstitutionObj.total, oustandingBalancebyCFObj);
                                    oustandingBalancebyCFObj.Tu_Credit_Report__r = new ints__TransUnion_Credit_Report__c(External_Id__c = TranExternalId);
                                    CommercialPR_EAE_Batch.listOustandingBalancebyCF.add(oustandingBalancebyCFObj);
                                }
                                //YourInstitution_X
                                CommercialPR_EAE_Response.YourInstitution_X outsideInstitutionObj = oustandingBalanceByCFAndAssetClasificationSecObj.outsideInstitution;
                                If(outsideInstitutionObj != null) {
                                    OustandingBalancebyCF__c oustandingBalancebyCFObj = new OustandingBalancebyCF__c();
                                    oustandingBalancebyCFObj.Type__c = 'Outside Institution';
                                    oustandingBalancebyCFObj = CommercialPR_EAE_Response_Utility.getNonFunded(outsideInstitutionObj.nonFunded, oustandingBalancebyCFObj);
                                    oustandingBalancebyCFObj = CommercialPR_EAE_Response_Utility.getNonFunded(outsideInstitutionObj.workingCapital, oustandingBalancebyCFObj);
                                    oustandingBalancebyCFObj = CommercialPR_EAE_Response_Utility.getNonFunded(outsideInstitutionObj.termLoan, oustandingBalancebyCFObj);
                                    oustandingBalancebyCFObj = CommercialPR_EAE_Response_Utility.getNonFunded(outsideInstitutionObj.forex, oustandingBalancebyCFObj);
                                    oustandingBalancebyCFObj = CommercialPR_EAE_Response_Utility.getNonFunded(outsideInstitutionObj.total, oustandingBalancebyCFObj);
                                    oustandingBalancebyCFObj.Tu_Credit_Report__r = new ints__TransUnion_Credit_Report__c(External_Id__c = TranExternalId);
                                    CommercialPR_EAE_Batch.listOustandingBalancebyCF.add(oustandingBalancebyCFObj);
                                }
                            }
                            //LocationDetailsSec
                            CommercialPR_EAE_Response.LocationDetailsSec locationDetailsSecObj = productSecObj.locationDetailsSec;
                            If(locationDetailsSecObj != null) {
                                //LocationInformationVec
                                CommercialPR_EAE_Response.LocationInformationVec locationInformationVecObj = locationDetailsSecObj.locationInformationVec;
                                If(locationInformationVecObj != null) {
                                    
                                    listlocationInformation = locationInformationVecObj.locationInformation;
                                    If(listlocationInformation != null) {
                                        for (CommercialPR_EAE_Response.LocationInformation locationInformationObj: listlocationInformation) {
                                            Location_Detail__c locationDetailsObj = new Location_Detail__c();
                                            If(locationInformationObj != null) {
                                                If(!Utility.ISStringBlankorNull(locationInformationObj.borrowerOfficeLocationType))
                                                    locationDetailsObj.Borrower_Office_Location_Type__c = locationInformationObj.borrowerOfficeLocationType.deleteWhitespace();
                                                If(!Utility.ISStringBlankorNull(locationInformationObj.address))
                                                    locationDetailsObj.Address__c = locationInformationObj.address;
                                                If(!Utility.ISStringBlankorNull(locationInformationObj.firstReportedDate))
                                                    locationDetailsObj.First_Reported_Date__c = locationInformationObj.firstReportedDate.deleteWhitespace();
                                                If(!Utility.ISStringBlankorNull(locationInformationObj.lastReportedDate))
                                                    locationDetailsObj.Last_Reported_Date__c = locationInformationObj.lastReportedDate.deleteWhitespace();
                                                If(!Utility.ISStringBlankorNull(locationInformationObj.numberOfInstitutions))
                                                    locationDetailsObj.No_of_Institution__c = Integer.valueOf(locationInformationObj.numberOfInstitutions.deleteWhitespace());
                                                
                                            }
                                            If(!Utility.ISStringBlankorNull(locationDetailsSecObj.message))
                                                locationDetailsObj.Message__c = locationDetailsSecObj.message.deleteWhitespace();
                                            If(!Utility.ISStringBlankorNull(locationDetailsSecObj.contactNumber))
                                                locationDetailsObj.Contact_Number__c = locationDetailsSecObj.contactNumber.deleteWhitespace();
                                            If(!Utility.ISStringBlankorNull(locationDetailsSecObj.faxNumber))
                                                locationDetailsObj.Fax_Number__c = locationDetailsSecObj.faxNumber.deleteWhitespace();
                                            
                                            String recordtypeIDStr = recordtypeIdMap.get('Location_Details');
                                            locationDetailsObj.recordtypeId     =   recordtypeIDStr;
                                            //locationDetailsObj.recordtype.developerName = 'Location_Details';
                                            locationDetailsObj.Tu_Credit_Report__r = new ints__TransUnion_Credit_Report__c(External_Id__c = TranExternalId);
                                            CommercialPR_EAE_Batch.listlocationDetail.add(locationDetailsObj);
                                            
                                        }
                                    }
                                    
                                }
                                
                                
                            }
                            //List of RelationshipDetailsVec
                            CommercialPR_EAE_Response.RelationshipDetailsVec relationshipDetailsVecObj = productSecObj.relationshipDetailsVec;
                            If(relationshipDetailsVecObj != null) {
                                listrelationshipDetails = relationshipDetailsVecObj.relationshipDetails;
                                If(listrelationshipDetails != null) {
                                    for (CommercialPR_EAE_Response.RelationshipDetails relationshipDetailsObj: listrelationshipDetails) {
                                        Relationship_Detail__c relationshipDetailObj = new Relationship_Detail__c();
                                        String relationExternalId = String.valueOf(Math.random());
                                        relationshipDetailObj.External_Id__c = relationExternalId;
                                        If(relationshipDetailsObj != null) {
                                            If(!Utility.ISStringBlankorNull(relationshipDetailsObj.relationshipHeader))
                                                relationshipDetailObj.Relationship_Header__c = relationshipDetailsObj.relationshipHeader;
                                            
                                            //RelationshipInformation
                                            CommercialPR_EAE_Response.RelationshipInformation relationshipInformationObj = relationshipDetailsObj.relationshipInformation;
                                            If(relationshipInformationObj != null) {
                                                If(!Utility.ISStringBlankorNull(relationshipInformationObj.name))
                                                    relationshipDetailObj.Name__c = relationshipInformationObj.name;
                                                If(!Utility.ISStringBlankorNull(relationshipInformationObj.relatedType))
                                                    relationshipDetailObj.Related_Type__c = relationshipInformationObj.relatedType.deleteWhitespace();
                                                If(!Utility.ISStringBlankorNull(relationshipInformationObj.relationship))
                                                    relationshipDetailObj.Relationship__c = relationshipInformationObj.relationship.deleteWhitespace();
                                                If(!Utility.ISStringBlankorNull(relationshipInformationObj.percentageOfControl))
                                                    relationshipDetailObj.Percentage_of_Control__c = relationshipInformationObj.percentageOfControl.deleteWhitespace();
                                                If(!Utility.ISStringBlankorNull(relationshipInformationObj.dateOfBirth))
                                                    relationshipDetailObj.Date_of_Birth__c = relationshipInformationObj.dateOfBirth.deleteWhitespace();
                                                If(!Utility.ISStringBlankorNull(relationshipInformationObj.gender))
                                                    relationshipDetailObj.Gender__c = relationshipInformationObj.gender.deleteWhitespace();
                                                If(!Utility.ISStringBlankorNull(relationshipInformationObj.businessCategory))
                                                    relationshipDetailObj.Business_Category__c = relationshipInformationObj.businessCategory.deleteWhitespace();
                                                If(!Utility.ISStringBlankorNull(relationshipInformationObj.businessIndustryType))
                                                    relationshipDetailObj.Business_Industry_Type__c = relationshipInformationObj.businessIndustryType.deleteWhitespace();
                                            }
                                            //BorrwerAddressContactDetails_Z
                                            CommercialPR_EAE_Response.BorrwerAddressContactDetails borrwerAddressContactDetailsObj = relationshipDetailsObj.borrwerAddressContactDetails;
                                            If(borrwerAddressContactDetailsObj != null) {
                                                If(!Utility.ISStringBlankorNull(borrwerAddressContactDetailsObj.address))
                                                    relationshipDetailObj.Address__c = borrwerAddressContactDetailsObj.address;
                                                If(!Utility.ISStringBlankorNull(borrwerAddressContactDetailsObj.faxNumber))
                                                    relationshipDetailObj.Fax_Number__c = borrwerAddressContactDetailsObj.faxNumber.deleteWhitespace();
                                                If(!Utility.ISStringBlankorNull(borrwerAddressContactDetailsObj.mobileNumber))
                                                    relationshipDetailObj.Mobile_Number__c = borrwerAddressContactDetailsObj.mobileNumber.deleteWhitespace();
                                            }
                                            //BorrwerIDDetailsVec_Z
                                            CommercialPR_EAE_Response.BorrwerIDDetailsVec_Z borrwerIDDetailsVecObj = relationshipDetailsObj.borrwerIDDetailsVec;
                                            If(borrwerIDDetailsVecObj != null) {
                                                If(!Utility.ISStringBlankorNull(borrwerIDDetailsVecObj.lastReportedDate))
                                                    relationshipDetailObj.Last_Reported_Date__c = borrwerIDDetailsVecObj.lastReportedDate;
                                                //BorrwerIDDetails_Z
                                                List < CommercialPR_EAE_Response.BorrwerIDDetails_Z > listborrwerIDDetails = borrwerIDDetailsVecObj.borrwerIDDetails;
                                                If(listborrwerIDDetails != null) {
                                                    for (CommercialPR_EAE_Response.BorrwerIDDetails_Z borrwerIDDetailsObj: listborrwerIDDetails) {
                                                        TU_ID_s__c tuIDsObj = new TU_ID_s__c();
                                                        
                                                        If(borrwerIDDetailsObj != null) {
                                                            
                                                            If(!Utility.ISStringBlankorNull(borrwerIDDetailsObj.pan))
                                                                tuIDsObj.Pan_Card_Number__c = borrwerIDDetailsObj.pan.deleteWhitespace();
                                                            If(!Utility.ISStringBlankorNull(borrwerIDDetailsObj.din))
                                                                tuIDsObj.DIN_Number__c = borrwerIDDetailsObj.din.deleteWhitespace();
                                                            If(!Utility.ISStringBlankorNull(borrwerIDDetailsObj.voterID))
                                                                tuIDsObj.Voter_ID_Number__c = borrwerIDDetailsObj.voterID.deleteWhitespace();
                                                            If(!Utility.ISStringBlankorNull(borrwerIDDetailsObj.passportNumber))
                                                                tuIDsObj.Passport_Number__c = borrwerIDDetailsObj.passportNumber.deleteWhitespace();
                                                            If(!Utility.ISStringBlankorNull(borrwerIDDetailsObj.drivingLicenseNo))
                                                                tuIDsObj.Driving_Licence_Number__c = borrwerIDDetailsObj.drivingLicenseNo.deleteWhitespace();
                                                            If(!Utility.ISStringBlankorNull(borrwerIDDetailsObj.uid))
                                                                tuIDsObj.Aadhar_card_number__c = borrwerIDDetailsObj.uid.deleteWhitespace();
                                                            If(!Utility.ISStringBlankorNull(borrwerIDDetailsObj.registrationNumber))
                                                                tuIDsObj.Registration_Number__c = borrwerIDDetailsObj.registrationNumber.deleteWhitespace();
                                                            If(!Utility.ISStringBlankorNull(borrwerIDDetailsObj.cin))
                                                                tuIDsObj.Cin__c = borrwerIDDetailsObj.cin.deleteWhitespace();
                                                            If(!Utility.ISStringBlankorNull(borrwerIDDetailsObj.tin))
                                                                tuIDsObj.Tin__c = borrwerIDDetailsObj.tin.deleteWhitespace();
                                                            If(!Utility.ISStringBlankorNull(borrwerIDDetailsObj.serviceTaxNumber))
                                                                tuIDsObj.Service_Tax_Number__c = borrwerIDDetailsObj.serviceTaxNumber.deleteWhitespace();
                                                            If(!Utility.ISStringBlankorNull(borrwerIDDetailsObj.rationCard))
                                                                tuIDsObj.Ration_Card_Number__c = borrwerIDDetailsObj.rationCard.deleteWhitespace();
                                                            
                                                            String recordtypeIDStr = recordtypeIdMap.get('Relationship_ID_Details');
                                                            tuIDsObj.recordtypeId   =   recordtypeIDStr;
                                                            // tuIDsObj.recordtype.developerName = 'Relationship_ID_Details';
                                                            tuIDsObj.Relationship_ID_Details__r = new Relationship_Detail__c(External_Id__c = relationExternalId);
                                                            CommercialPR_EAE_Batch.listTUIDs.add(tuIDsObj);
                                                        }
                                                        
                                                    }
                                                    
                                                    
                                                }
                                                
                                            }
                                            relationshipDetailObj.Tu_Credit_Report__r = new ints__TransUnion_Credit_Report__c(External_Id__c = TranExternalId);
                                            CommercialPR_EAE_Batch.listRelationshipDetail.add(relationshipDetailObj);
                                        }
                                    }
                                }
                                
                            }
                            
                            //CreditFacilityDetailsasBorrowerSecVec
                            CommercialPR_EAE_Response.CreditFacilityDetailsasBorrowerSecVec creditFacilityDetailsasBorrowerSecVecObj = productSecObj.creditFacilityDetailsasBorrowerSecVec;
                            If(creditFacilityDetailsasBorrowerSecVecObj != null) {
                                
                                If(!Utility.ISStringBlankorNull(creditFacilityDetailsasBorrowerSecVecObj.message))
                                    messageObj.Credit_Facility_Details_as_BorrowerSec__c = creditFacilityDetailsasBorrowerSecVecObj.message.deleteWhitespace();
                                
                                // List of CreditFacilityDetailsasBorrowerSec
                                listcreditFacilityDetailsasBorrowerSec = creditFacilityDetailsasBorrowerSecVecObj.creditFacilityDetailsasBorrowerSec;
                                If(listcreditFacilityDetailsasBorrowerSec != null && listcreditFacilityDetailsasBorrowerSec.size() > 0) {
                                    
                                    for (CommercialPR_EAE_Response.CreditFacilityDetailsasBorrowerSec creditFacilityDetailsasBorrowerSecObj: listcreditFacilityDetailsasBorrowerSec) {
                                        Credit_Facility_Detail__c creditFacilityObj = new Credit_Facility_Detail__c();
                                        String ExternalId = String.valueOf(Math.random());
                                        
                                        creditFacilityObj.External_Id__c = ExternalId;
                                        If(creditFacilityDetailsasBorrowerSecObj != null) {
                                            //CreditFacilityCurrentDetailsVec
                                            CommercialPR_EAE_Response.CreditFacilityCurrentDetailsVec creditFacilityCurrentDetailsVecObj = creditFacilityDetailsasBorrowerSecObj.creditFacilityCurrentDetailsVec;
                                            If(creditFacilityCurrentDetailsVecObj != null) {
                                                //CreditFacilityCurrentDetails
                                                CommercialPR_EAE_Response.CreditFacilityCurrentDetails  creditFacilityCurrentDetailsObj = creditFacilityCurrentDetailsVecObj.creditFacilityCurrentDetails;
                                                //Credit_Facility_Detail__c creditFacilityObject = new Credit_Facility_Detail__c();
                                                If(creditFacilityCurrentDetailsObj != null) {
                                                    
                                                    If(!Utility.ISStringBlankorNull(creditFacilityCurrentDetailsObj.derivative))
                                                        creditFacilityObj.Derivative__c = Boolean.valueOf(creditFacilityCurrentDetailsObj.derivative.deleteWhitespace());
                                                    If(!Utility.ISStringBlankorNull(creditFacilityCurrentDetailsObj.accountNumber))
                                                        creditFacilityObj.Account_Number__c = creditFacilityCurrentDetailsObj.accountNumber.deleteWhitespace();
                                                    If(!Utility.ISStringBlankorNull(creditFacilityCurrentDetailsObj.cfSerialNumber))
                                                        creditFacilityObj.CF_Serial_Number__c = creditFacilityCurrentDetailsObj.cfSerialNumber.deleteWhitespace();
                                                    If(!Utility.ISStringBlankorNull(creditFacilityCurrentDetailsObj.cfType))
                                                        creditFacilityObj.CF_Type__c = creditFacilityCurrentDetailsObj.cfType.deleteWhitespace();
                                                    If(!Utility.ISStringBlankorNull(creditFacilityCurrentDetailsObj.cfMember))
                                                        creditFacilityObj.CF_Member__c = creditFacilityCurrentDetailsObj.cfMember.deleteWhitespace();
                                                    If(!Utility.ISStringBlankorNull(creditFacilityCurrentDetailsObj.assetClassificationDaysPastDueDpd))
                                                        creditFacilityObj.Asset_Classification__c = creditFacilityCurrentDetailsObj.assetClassificationDaysPastDueDpd.deleteWhitespace();
                                                    If(!Utility.ISStringBlankorNull(creditFacilityCurrentDetailsObj.status))
                                                        creditFacilityObj.Status__c = creditFacilityCurrentDetailsObj.status.deleteWhitespace();
                                                    If(!Utility.ISStringBlankorNull(creditFacilityCurrentDetailsObj.lastReportedDate))
                                                        creditFacilityObj.Last_Reported_Date__c = creditFacilityCurrentDetailsObj.lastReportedDate.deleteWhitespace();
                                                    //Amount
                                                    CommercialPR_EAE_Response.Amount amountObject = creditFacilityCurrentDetailsObj.amount;
                                                    If(amountObject != null) {
                                                        If(!Utility.ISStringBlankorNull(amountObject.amount))
                                                            creditFacilityObj.Amount__c = amountObject.amount.deleteWhitespace();
                                                        If(!Utility.ISStringBlankorNull(amountObject.sanctionedAmt))
                                                            creditFacilityObj.Sanctioned_Amount__c = amountObject.sanctionedAmt.deleteWhitespace();
                                                        If(!Utility.ISStringBlankorNull(amountObject.drawingPower))
                                                            creditFacilityObj.Drawing_Power__c = amountObject.drawingPower.deleteWhitespace();
                                                        If(!Utility.ISStringBlankorNull(amountObject.outstandingBalance))
                                                            creditFacilityObj.Outstanding_Balance__c = amountObject.outstandingBalance.deleteWhitespace();
                                                        If(!Utility.ISStringBlankorNull(amountObject.overdue))
                                                            creditFacilityObj.Over_Due__c = amountObject.overdue.deleteWhitespace();
                                                        If(!Utility.ISStringBlankorNull(amountObject.suitFiledAmt))
                                                            creditFacilityObj.Suit_Filed_Amount__c = amountObject.suitFiledAmt.deleteWhitespace();
                                                        If(!Utility.ISStringBlankorNull(amountObject.markToMarket))
                                                            creditFacilityObj.Mark_To_Market__c = amountObject.markToMarket.deleteWhitespace();
                                                        If(!Utility.ISStringBlankorNull(amountObject.highCredit))
                                                            creditFacilityObj.High_Credit__c = amountObject.highCredit.deleteWhitespace();
                                                        If(!Utility.ISStringBlankorNull(amountObject.installmentAmt))
                                                            creditFacilityObj.Installment_Amount__c = amountObject.installmentAmt.deleteWhitespace();
                                                        If(!Utility.ISStringBlankorNull(amountObject.lastRepaid))
                                                            creditFacilityObj.Last_Repaid__c = amountObject.lastRepaid.deleteWhitespace();
                                                        If(!Utility.ISStringBlankorNull(amountObject.writtenOFF))
                                                            creditFacilityObj.Written_OFF__c = amountObject.writtenOFF.deleteWhitespace();
                                                        If(!Utility.ISStringBlankorNull(amountObject.settled))
                                                            creditFacilityObj.Settled__c = amountObject.settled.deleteWhitespace();
                                                        If(!Utility.ISStringBlankorNull(amountObject.naorc))
                                                            creditFacilityObj.Naorc__c = amountObject.naorc.deleteWhitespace();
                                                        If(!Utility.ISStringBlankorNull(amountObject.notionalAmountOfContracts))
                                                            creditFacilityObj.Notional_Amount_of_Contracts__c = amountObject.notionalAmountOfContracts.deleteWhitespace();
                                                        If(!Utility.ISStringBlankorNull(amountObject.contractsClassifiedAsNPA))
                                                            creditFacilityObj.Contracts_Classified_as_NPA__c = amountObject.contractsClassifiedAsNPA.deleteWhitespace();
                                                    }
                                                    //Dates
                                                    CommercialPR_EAE_Response.Dates datesObj = creditFacilityCurrentDetailsObj.dates;
                                                    If(datesObj != null) {
                                                        If(!Utility.ISStringBlankorNull(datesObj.sanctionedDt))
                                                            creditFacilityObj.Sanction_Date__c = datesObj.sanctionedDt.deleteWhitespace();
                                                    }
                                                    //OtherDetails
                                                    CommercialPR_EAE_Response.OtherDetails otherDetailsObj = creditFacilityCurrentDetailsObj.otherDetails;
                                                    If(otherDetailsObj != null) {
                                                        If(!Utility.ISStringBlankorNull(otherDetailsObj.repaymentFrequency))
                                                            creditFacilityObj.Repayment_Frequency__c = otherDetailsObj.repaymentFrequency.deleteWhitespace();
                                                    }
                                                }
                                            }
                                            //List of CFHistoryforACOrDPDupto24MonthsVec
                                            CommercialPR_EAE_Response.CFHistoryforACOrDPDupto24MonthsVec cFHistoryforACOrDPDupto24MonthsVecObj = creditFacilityDetailsasBorrowerSecObj.cFHistoryforACOrDPDupto24MonthsVec;
                                            If(cFHistoryforACOrDPDupto24MonthsVecObj != null) {
                                                listCFHistoryforACOrDPDupto24Months = cFHistoryforACOrDPDupto24MonthsVecObj.cFHistoryforACOrDPDupto24Months;
                                                If(listCFHistoryforACOrDPDupto24Months != null && listCFHistoryforACOrDPDupto24Months.size() > 0) {
                                                    for (CommercialPR_EAE_Response.CFHistoryforACOrDPDupto24Months CFHistoryforACOrDPDupto24MonthsObj: listCFHistoryforACOrDPDupto24Months) {
                                                        
                                                        TU_CFHistory__c tuCFHistoryObject = new TU_CFHistory__c();
                                                        If(CFHistoryforACOrDPDupto24MonthsObj != null) {
                                                            If(!Utility.ISStringBlankorNull(CFHistoryforACOrDPDupto24MonthsObj.month))
                                                                tuCFHistoryObject.Month__c = CFHistoryforACOrDPDupto24MonthsObj.month.deleteWhitespace();
                                                            If(!Utility.ISStringBlankorNull(CFHistoryforACOrDPDupto24MonthsObj.ACorDPD))
                                                                tuCFHistoryObject.ACorDPD__c = CFHistoryforACOrDPDupto24MonthsObj.ACorDPD;
                                                            If(!Utility.ISStringBlankorNull(CFHistoryforACOrDPDupto24MonthsObj.OSAmount))
                                                                tuCFHistoryObject.OS_Amount__c = CFHistoryforACOrDPDupto24MonthsObj.OSAmount.deleteWhitespace();
                                                            
                                                            tuCFHistoryObject.Credit_Facility_Detail__r = new Credit_Facility_Detail__c(External_Id__c = ExternalId);
                                                            CommercialPR_EAE_Batch.listTUCFHistory.add(tuCFHistoryObject);
                                                            
                                                        }
                                                    }
                                                }
                                            }
                                            
                                            //CreditFacilityOverdueDetailsVec
                                            CommercialPR_EAE_Response.CreditFacilityOverdueDetailsVec creditFacilityOverdueDetailsVecObj = creditFacilityDetailsasBorrowerSecObj.creditFacilityOverdueDetailsVec;
                                            If(creditFacilityOverdueDetailsVecObj != null) {
                                                //CreditFacilityOverdueDetails
                                                CommercialPR_EAE_Response.CreditFacilityOverdueDetails creditFacilityOverdueDetailsObj = creditFacilityOverdueDetailsVecObj.creditFacilityOverdueDetails;
                                                If(creditFacilityOverdueDetailsObj != null) {
                                                    If(!Utility.ISStringBlankorNull(creditFacilityOverdueDetailsObj.DPD1to30amt))
                                                        creditFacilityObj.DPD1_to_30amt__c = creditFacilityOverdueDetailsObj.DPD1to30amt.deleteWhitespace();
                                                    If(!Utility.ISStringBlankorNull(creditFacilityOverdueDetailsObj.DPD31to60amt))
                                                        creditFacilityObj.DPD31_to_60_amt__c = creditFacilityOverdueDetailsObj.DPD31to60amt.deleteWhitespace();
                                                    If(!Utility.ISStringBlankorNull(creditFacilityOverdueDetailsObj.DPD61t090amt))
                                                        creditFacilityObj.DPD61_to_90_amt__c = creditFacilityOverdueDetailsObj.DPD61t090amt.deleteWhitespace();
                                                    If(!Utility.ISStringBlankorNull(creditFacilityOverdueDetailsObj.DPD91to180amt))
                                                        creditFacilityObj.DPD91_to_180_amt__c = creditFacilityOverdueDetailsObj.DPD91to180amt.deleteWhitespace();
                                                    If(!Utility.ISStringBlankorNull(creditFacilityOverdueDetailsObj.DPDabove180amt))
                                                        creditFacilityObj.DPD_above_180_amt__c = creditFacilityOverdueDetailsObj.DPDabove180amt.deleteWhitespace();
                                                }
                                            }
                                            //ChequeDishounouredDuetoInsufficientFunds
                                            CommercialPR_EAE_Response.ChequeDishounouredDuetoInsufficientFunds chequeDishounouredDuetoInsufficientFundsObj = creditFacilityDetailsasBorrowerSecObj.chequeDishounouredDuetoInsufficientFunds;
                                            If(chequeDishounouredDuetoInsufficientFundsObj != null) {
                                                If(!Utility.ISStringBlankorNull(chequeDishounouredDuetoInsufficientFundsObj.message))
                                                    creditFacilityObj.Cheque_Dishounoured_Due_Message__c = chequeDishounouredDuetoInsufficientFundsObj.message.deleteWhitespace();
                                                If(!Utility.ISStringBlankorNull(chequeDishounouredDuetoInsufficientFundsObj.CD3monthcount))
                                                    creditFacilityObj.CD_3month_count__c = chequeDishounouredDuetoInsufficientFundsObj.CD3monthcount.deleteWhitespace();
                                                If(!Utility.ISStringBlankorNull(chequeDishounouredDuetoInsufficientFundsObj.CD4to6monthcount))
                                                    creditFacilityObj.CD_4to6_month_count__c = chequeDishounouredDuetoInsufficientFundsObj.CD4to6monthcount.deleteWhitespace();
                                                If(!Utility.ISStringBlankorNull(chequeDishounouredDuetoInsufficientFundsObj.CD7to9monthcount))
                                                    creditFacilityObj.CD_7to9_month_count__c = chequeDishounouredDuetoInsufficientFundsObj.CD7to9monthcount.deleteWhitespace();
                                                If(!Utility.ISStringBlankorNull(chequeDishounouredDuetoInsufficientFundsObj.CD10to12monthcount))
                                                    creditFacilityObj.CD_10to12_month_count__c = chequeDishounouredDuetoInsufficientFundsObj.CD10to12monthcount.deleteWhitespace();
                                            }
                                            
                                            //CreditFacilitySecurityDetailsVec
                                            CommercialPR_EAE_Response.CreditFacilitySecurityDetailsVec creditFacilitySecurityDetailsVecObj = creditFacilityDetailsasBorrowerSecObj.creditFacilitySecurityDetailsVec;
                                            If(creditFacilitySecurityDetailsVecObj != null) {
                                                If(!Utility.ISStringBlankorNull(creditFacilitySecurityDetailsVecObj.message))
                                                    creditFacilityObj.Credit_Facility_Security_Details_Message__c = creditFacilitySecurityDetailsVecObj.message.deleteWhitespace();
                                                If(creditFacilitySecurityDetailsVecObj.creditFacilitySecurityDetails !=null) {
                                                    List<CommercialPR_EAE_Response.CreditFacilitySecurityDetails> listCreditFacilitySecurityDetails  = creditFacilitySecurityDetailsVecObj.creditFacilitySecurityDetails;
                                                    for(CommercialPR_EAE_Response.CreditFacilitySecurityDetails creditFacilitySecurityDetailsObj     :   listCreditFacilitySecurityDetails) {
                                                        Credit_Facility_Detail__c creditFacilityObject = new Credit_Facility_Detail__c();
                                                        If(creditFacilitySecurityDetailsObj !=null) {
                                                            If(!Utility.ISStringBlankorNull(creditFacilitySecurityDetailsObj.relatedType))
                                                                creditFacilityObject.Related_Type__c = creditFacilitySecurityDetailsObj.relatedType.deleteWhitespace();
                                                            If(!Utility.ISStringBlankorNull(creditFacilitySecurityDetailsObj.classification))
                                                                creditFacilityObject.Classification__c = creditFacilitySecurityDetailsObj.classification.deleteWhitespace();
                                                            If(!Utility.ISStringBlankorNull(creditFacilitySecurityDetailsObj.value))
                                                                creditFacilityObject.Value__c = creditFacilitySecurityDetailsObj.value.deleteWhitespace();
                                                            If(!Utility.ISStringBlankorNull(creditFacilitySecurityDetailsObj.amount))
                                                                creditFacilityObject.Amount__c = creditFacilitySecurityDetailsObj.amount.deleteWhitespace();
                                                            If(!Utility.ISStringBlankorNull(creditFacilitySecurityDetailsObj.validationDt))
                                                                creditFacilityObject.Validation_Date__c = creditFacilitySecurityDetailsObj.validationDt.deleteWhitespace();
                                                            If(!Utility.ISStringBlankorNull(creditFacilitySecurityDetailsObj.lastReportedDt))
                                                                creditFacilityObject.Last_Reported_Date__c = creditFacilitySecurityDetailsObj.lastReportedDt.deleteWhitespace();
                                                            
                                                            creditFacilityObject.Tu_Credit_Report__r = new ints__TransUnion_Credit_Report__c(External_Id__c = TranExternalId);
                                                            CommercialPR_EAE_Batch.listCreditFacilityDetail.add(creditFacilityObject);
                                                        }
                                                    } 
                                                }
                                            }
                                            //CreditFacilityGuarantorDetailsVec
                                            CommercialPR_EAE_Response.CreditFacilityGuarantorDetailsVec creditFacilityGuarantorDetailsVecObj = creditFacilityDetailsasBorrowerSecObj.creditFacilityGuarantorDetailsVec;
                                            If(creditFacilityGuarantorDetailsVecObj != null) {
                                                If(!Utility.ISStringBlankorNull(creditFacilityGuarantorDetailsVecObj.message))
                                                    creditFacilityObj.Credit_Facility_GuarantorDetails_Message__c = creditFacilityGuarantorDetailsVecObj.message;
                                                //CreditFacilityGuarantorDetails
                                                List < CommercialPR_EAE_Response.CreditFacilityGuarantorDetails > listcreditFacilityGuarantorDetails = creditFacilityGuarantorDetailsVecObj.creditFacilityGuarantorDetails;
                                                If(listcreditFacilityGuarantorDetails != null) {
                                                    for (CommercialPR_EAE_Response.CreditFacilityGuarantorDetails creditFacilityGuarantorDetailsObj: listcreditFacilityGuarantorDetails) {
                                                        Relationship_Detail__c relationshipDetailObj = new Relationship_Detail__c();
                                                        String relationExternalId = String.valueOf(Math.random());
                                                        relationshipDetailObj.External_Id__c = relationExternalId;
                                                        If(creditFacilityGuarantorDetailsObj != null) {
                                                            //GuarantorDetails
                                                            CommercialPR_EAE_Response.GuarantorDetails guarantorDetailsObj = creditFacilityGuarantorDetailsObj.guarantorDetails;
                                                            If(guarantorDetailsObj != null) {
                                                                If(!Utility.ISStringBlankorNull(guarantorDetailsObj.name))
                                                                    relationshipDetailObj.Name__c = guarantorDetailsObj.name;
                                                                If(!Utility.ISStringBlankorNull(guarantorDetailsObj.relatedType))
                                                                    relationshipDetailObj.Related_Type__c = guarantorDetailsObj.relatedType.deleteWhitespace();
                                                                If(!Utility.ISStringBlankorNull(guarantorDetailsObj.businessCategory))
                                                                    relationshipDetailObj.Business_Category__c = guarantorDetailsObj.businessCategory.deleteWhitespace();
                                                                If(!Utility.ISStringBlankorNull(guarantorDetailsObj.businessIndustryType))
                                                                    relationshipDetailObj.Business_Industry_Type__c = guarantorDetailsObj.businessIndustryType.deleteWhitespace();
                                                            }
                                                            //BorrwerAddressContactDetails
                                                            CommercialPR_EAE_Response.BorrwerAddressContactDetails guarantorAddressContactDetailsObj = creditFacilityGuarantorDetailsObj.guarantorAddressContactDetails;
                                                            If(guarantorAddressContactDetailsObj != null) {
                                                                If(!Utility.ISStringBlankorNull(guarantorAddressContactDetailsObj.address))
                                                                    relationshipDetailObj.Address__c = guarantorAddressContactDetailsObj.address;
                                                                If(!Utility.ISStringBlankorNull(guarantorAddressContactDetailsObj.telephoneNumber))
                                                                    relationshipDetailObj.Phone_Number__c = guarantorAddressContactDetailsObj.telephoneNumber.deleteWhitespace();
                                                                If(!Utility.ISStringBlankorNull(guarantorAddressContactDetailsObj.faxNumber))
                                                                    relationshipDetailObj.Fax_Number__c = guarantorAddressContactDetailsObj.faxNumber.deleteWhitespace();
                                                                If(!Utility.ISStringBlankorNull(guarantorAddressContactDetailsObj.mobileNumber))
                                                                    relationshipDetailObj.Mobile_Number__c = guarantorAddressContactDetailsObj.mobileNumber.deleteWhitespace();
                                                            }
                                                            //GuarantorDetailsBorrwerIDDetailsVec
                                                            CommercialPR_EAE_Response.GuarantorDetailsBorrwerIDDetailsVec guarantorDetailsBorrwerIDDetailsVecObj = creditFacilityGuarantorDetailsObj.guarantorDetailsBorrwerIDDetailsVec;
                                                            If(guarantorDetailsBorrwerIDDetailsVecObj != null) {
                                                                If(!Utility.ISStringBlankorNull(guarantorDetailsBorrwerIDDetailsVecObj.lastReportedDate))
                                                                    relationshipDetailObj.Last_Reported_Date__c = guarantorDetailsBorrwerIDDetailsVecObj.lastReportedDate.deleteWhitespace();
                                                                //GuarantorIDDetails
                                                                List < CommercialPR_EAE_Response.GuarantorIDDetails > listGuarantorIDDetails = guarantorDetailsBorrwerIDDetailsVecObj.guarantorIDDetails;
                                                                If(listGuarantorIDDetails != null) {
                                                                    for (CommercialPR_EAE_Response.GuarantorIDDetails guarantorIDDetailsObj: listGuarantorIDDetails) {
                                                                        TU_ID_s__c tuIDsObj = new TU_ID_s__c();
                                                                        If(guarantorIDDetailsObj != null) {
                                                                            If(!Utility.ISStringBlankorNull(guarantorIDDetailsObj.pan))
                                                                                tuIDsObj.Pan_Card_Number__c = guarantorIDDetailsObj.pan.deleteWhitespace();
                                                                            If(!Utility.ISStringBlankorNull(guarantorIDDetailsObj.din))
                                                                                tuIDsObj.DIN_Number__c = guarantorIDDetailsObj.din.deleteWhitespace();
                                                                            If(!Utility.ISStringBlankorNull(guarantorIDDetailsObj.voterID))
                                                                                tuIDsObj.Voter_ID_Number__c = guarantorIDDetailsObj.voterID.deleteWhitespace();
                                                                            If(!Utility.ISStringBlankorNull(guarantorIDDetailsObj.passportNumber))
                                                                                tuIDsObj.Passport_Number__c = guarantorIDDetailsObj.passportNumber.deleteWhitespace();
                                                                            If(!Utility.ISStringBlankorNull(guarantorIDDetailsObj.uid))
                                                                                tuIDsObj.Aadhar_Card_Number__c = guarantorIDDetailsObj.uid.deleteWhitespace();
                                                                            If(!Utility.ISStringBlankorNull(guarantorIDDetailsObj.drivingLicenseNumber))
                                                                                tuIDsObj.Driving_Licence_Number__c = guarantorIDDetailsObj.drivingLicenseNumber.deleteWhitespace();
                                                                            If(!Utility.ISStringBlankorNull(guarantorIDDetailsObj.rationCard))
                                                                                tuIDsObj.Ration_Card_Number__c = guarantorIDDetailsObj.rationCard.deleteWhitespace();
                                                                            
                                                                            String recordtypeIDStr = recordtypeIdMap.get('Relationship_ID_Details');
                                                                            tuIDsObj.recordtypeId   =   recordtypeIDStr;
                                                                            //tuIDsObj.recordtype.developerName = 'Relationship_ID_Details';
                                                                            tuIDsObj.Relationship_ID_Details__r = new Relationship_Detail__c(External_Id__c = relationExternalId);
                                                                            CommercialPR_EAE_Batch.listTUIDs.add(tuIDsObj);
                                                                            
                                                                        }
                                                                    }
                                                                    
                                                                }
                                                                
                                                            }
                                                        }
                                                        relationshipDetailObj.Tu_Credit_Report__r = new ints__TransUnion_Credit_Report__c(External_Id__c = TranExternalId);
                                                        CommercialPR_EAE_Batch.listRelationshipDetail.add(relationshipDetailObj);
                                                    }
                                                    
                                                }
                                                
                                            }
                                            
                                        }
                                        creditFacilityObj.Tu_Credit_Report__r = new ints__TransUnion_Credit_Report__c(External_Id__c = TranExternalId);
                                        CommercialPR_EAE_Batch.listCreditFacilityDetail.add(creditFacilityObj);
                                        
                                    }
                                }
                            }
                            //CreditFacilityDetailsasGuarantorVec
                            CommercialPR_EAE_Response.CreditFacilityDetailsasGuarantorVec creditFacilityDetailsasGuarantorVecObj = productSecObj.creditFacilityDetailsasGuarantorVec;
                            //TU_Message__c messageObj = new TU_Message__c();
                            If(creditFacilityDetailsasGuarantorVecObj != null) {
                                If(!Utility.ISStringBlankorNull(creditFacilityDetailsasGuarantorVecObj.message))
                                    messageObj.CreditFacility_Details_as_Guarantor__c = creditFacilityDetailsasGuarantorVecObj.message.deleteWhitespace();
                                
                                //List of CreditFacilityDetailsasGuarantor
                                If(creditFacilityDetailsasGuarantorVecObj.creditFacilityDetailsasGuarantor !=null){
                                    
                                    List<CommercialPR_EAE_Response.CreditFacilityDetailsasGuarantor> listCreditFacilityDetailAS = creditFacilityDetailsasGuarantorVecObj.creditFacilityDetailsasGuarantor;
                                    If(listCreditFacilityDetailAS !=null){
                                        for(CommercialPR_EAE_Response.CreditFacilityDetailsasGuarantor   creditFacDetailObj      :   listCreditFacilityDetailAS){
                                            If(creditFacDetailObj !=null){
                                                
                                                Credit_facility_Details_as_Guarantor__c creditFacilityDetailGuaObj = new Credit_facility_Details_as_Guarantor__c();
                                                
                                                String ExternalId = String.valueOf(Math.random());
                                                
                                                List<CommercialPR_EAE_Response.CreditFacilityCurrentDetails> listCreditFacDetObj =   creditFacDetailObj.creditFacilityCurrentDetails;
                                                If(listCreditFacDetObj !=null){
                                                    for(CommercialPR_EAE_Response.CreditFacilityCurrentDetails   creditFacDetObj : listCreditFacDetObj) {
                                                        If(creditFacDetObj !=null){
                                                            Credit_Facility_Detail__c creditFacilityObj = new Credit_Facility_Detail__c();
                                                            
                                                            If(!Utility.ISStringBlankorNull(creditFacDetObj.derivative))
                                                                creditFacilityObj.Derivative__c = Boolean.valueOf(creditFacDetObj.derivative.deleteWhitespace());
                                                            If(!Utility.ISStringBlankorNull(creditFacDetObj.accountNumber))
                                                                creditFacilityObj.Account_Number__c = creditFacDetObj.accountNumber.deleteWhitespace();
                                                            If(!Utility.ISStringBlankorNull(creditFacDetObj.cfSerialNumber))
                                                                creditFacilityObj.CF_Serial_Number__c = creditFacDetObj.cfSerialNumber.deleteWhitespace();
                                                            If(!Utility.ISStringBlankorNull(creditFacDetObj.cfType))
                                                                creditFacilityObj.CF_Type__c = creditFacDetObj.cfType.deleteWhitespace();
                                                            If(!Utility.ISStringBlankorNull(creditFacDetObj.cfMember))
                                                                creditFacilityObj.CF_Member__c = creditFacDetObj.cfMember.deleteWhitespace();
                                                            If(!Utility.ISStringBlankorNull(creditFacDetObj.assetClassificationDaysPastDueDpd))
                                                                creditFacilityObj.Asset_Classification__c = creditFacDetObj.assetClassificationDaysPastDueDpd.deleteWhitespace();
                                                            If(!Utility.ISStringBlankorNull(creditFacDetObj.status))
                                                                creditFacilityObj.Status__c = creditFacDetObj.status.deleteWhitespace();
                                                            If(!Utility.ISStringBlankorNull(creditFacDetObj.lastReportedDate))
                                                                creditFacilityObj.Last_Reported_Date__c = creditFacDetObj.lastReportedDate.deleteWhitespace();
                                                            //Amount
                                                            CommercialPR_EAE_Response.Amount amountObject = creditFacDetObj.amount;
                                                            If(amountObject != null) {
                                                                If(!Utility.ISStringBlankorNull(amountObject.amount))
                                                                    creditFacilityObj.Amount__c = amountObject.amount.deleteWhitespace();
                                                                If(!Utility.ISStringBlankorNull(amountObject.sanctionedAmt))
                                                                    creditFacilityObj.Sanctioned_Amount__c = amountObject.sanctionedAmt.deleteWhitespace();
                                                                If(!Utility.ISStringBlankorNull(amountObject.drawingPower))
                                                                    creditFacilityObj.Drawing_Power__c = amountObject.drawingPower.deleteWhitespace();
                                                                If(!Utility.ISStringBlankorNull(amountObject.outstandingBalance))
                                                                    creditFacilityObj.Outstanding_Balance__c = amountObject.outstandingBalance.deleteWhitespace();
                                                                If(!Utility.ISStringBlankorNull(amountObject.overdue))
                                                                    creditFacilityObj.Over_Due__c = amountObject.overdue.deleteWhitespace();
                                                                If(!Utility.ISStringBlankorNull(amountObject.suitFiledAmt))
                                                                    creditFacilityObj.Suit_Filed_Amount__c = amountObject.suitFiledAmt.deleteWhitespace();
                                                                If(!Utility.ISStringBlankorNull(amountObject.markToMarket))
                                                                    creditFacilityObj.Mark_To_Market__c = amountObject.markToMarket.deleteWhitespace();
                                                                If(!Utility.ISStringBlankorNull(amountObject.highCredit))
                                                                    creditFacilityObj.High_Credit__c = amountObject.highCredit.deleteWhitespace();
                                                                If(!Utility.ISStringBlankorNull(amountObject.installmentAmt))
                                                                    creditFacilityObj.Installment_Amount__c = amountObject.installmentAmt.deleteWhitespace();
                                                                If(!Utility.ISStringBlankorNull(amountObject.lastRepaid))
                                                                    creditFacilityObj.Last_Repaid__c = amountObject.lastRepaid.deleteWhitespace();
                                                                If(!Utility.ISStringBlankorNull(amountObject.writtenOFF))
                                                                    creditFacilityObj.Written_OFF__c = amountObject.writtenOFF.deleteWhitespace();
                                                                If(!Utility.ISStringBlankorNull(amountObject.settled))
                                                                    creditFacilityObj.Settled__c = amountObject.settled.deleteWhitespace();
                                                                If(!Utility.ISStringBlankorNull(amountObject.naorc))
                                                                    creditFacilityObj.Naorc__c = amountObject.naorc.deleteWhitespace();
                                                                If(!Utility.ISStringBlankorNull(amountObject.notionalAmountOfContracts))
                                                                    creditFacilityObj.Notional_Amount_of_Contracts__c = amountObject.notionalAmountOfContracts.deleteWhitespace();
                                                                If(!Utility.ISStringBlankorNull(amountObject.contractsClassifiedAsNPA))
                                                                    creditFacilityObj.Contracts_Classified_as_NPA__c = amountObject.contractsClassifiedAsNPA.deleteWhitespace();
                                                            }
                                                            //Dates
                                                            CommercialPR_EAE_Response.Dates datesObj = creditFacDetObj.dates;
                                                            If(datesObj != null) {
                                                                If(!Utility.ISStringBlankorNull(datesObj.sanctionedDt))
                                                                    creditFacilityObj.Sanction_Date__c = datesObj.sanctionedDt.deleteWhitespace();
                                                            }
                                                            //OtherDetails
                                                            CommercialPR_EAE_Response.OtherDetails otherDetailsObj = creditFacDetObj.otherDetails;
                                                            If(otherDetailsObj != null) {
                                                                If(!Utility.ISStringBlankorNull(otherDetailsObj.repaymentFrequency))
                                                                    creditFacilityObj.Repayment_Frequency__c = otherDetailsObj.repaymentFrequency.deleteWhitespace();
                                                            }
                                                            creditFacilityObj.Credit_Facility_Details_Guarantor__r = new Credit_facility_Details_as_Guarantor__c(External_Id__c = ExternalId);
                                                            CommercialPR_EAE_Batch.listCreditFacilityDetail.add(creditFacilityObj); 
                                                        }
                                                        
                                                    }
                                                }
                                                CommercialPR_EAE_Response.BorrwerInfo  borrwerInfoObj  =   creditFacDetailObj.borrwerInfo; 
                                                If(borrwerInfoObj !=null){
                                                    //BorrwerDetails
                                                    CommercialPR_EAE_Response.BorrwerDetails borrwerDetailsObj = borrwerInfoObj.borrwerDetails;
                                                    If(borrwerDetailsObj != null) {
                                                        If(!Utility.ISStringBlankorNull(borrwerDetailsObj.name))
                                                            creditFacilityDetailGuaObj.Borrower_Name__c = borrwerDetailsObj.name.deleteWhitespace();
                                                        If(!Utility.ISStringBlankorNull(borrwerDetailsObj.borrowersLegalConstitution))
                                                            creditFacilityDetailGuaObj.Borrowers_Legal_Constitution__c = borrwerDetailsObj.borrowersLegalConstitution.deleteWhitespace();
                                                        If(!Utility.ISStringBlankorNull(borrwerDetailsObj.businessCategory))
                                                            creditFacilityDetailGuaObj.Business_Category__c = borrwerDetailsObj.businessCategory.deleteWhitespace();
                                                        If(!Utility.ISStringBlankorNull(borrwerDetailsObj.businessIndustryType))
                                                            creditFacilityDetailGuaObj.Business_IndustryType__c = borrwerDetailsObj.businessIndustryType.deleteWhitespace();
                                                        If(!Utility.ISStringBlankorNull(borrwerDetailsObj.numberOfEmployees))
                                                            creditFacilityDetailGuaObj.Number_Of_Employees__c = borrwerDetailsObj.numberOfEmployees.deleteWhitespace();
                                                        If(!Utility.ISStringBlankorNull(borrwerDetailsObj.dateOfIncorporation))
                                                            creditFacilityDetailGuaObj.Date_Of_Incorporation__c = borrwerDetailsObj.dateOfIncorporation.deleteWhitespace();
                                                        If(!Utility.ISStringBlankorNull(borrwerDetailsObj.salesFigure))
                                                            creditFacilityDetailGuaObj.Sales_Figure__c = borrwerDetailsObj.salesFigure.deleteWhitespace();
                                                        If(!Utility.ISStringBlankorNull(borrwerDetailsObj.year))
                                                            creditFacilityDetailGuaObj.Year__c = borrwerDetailsObj.year.deleteWhitespace();
                                                        // classOfActivityVec
                                                        If(borrwerDetailsObj.classOfActivityVec !=null){
                                                            CommercialPR_EAE_Response.ClassOfActivityVec  classOfActivityVecObj          =   borrwerDetailsObj.classOfActivityVec;
                                                            If(classOfActivityVecObj !=null){
                                                                List<String> listclassOfActivity    = classOfActivityVecObj.classOfActivity;
                                                                String classOfActiveTrans='';
                                                                If(listclassOfActivity !=null){
                                                                    for(String classOfActivityObj   :   listclassOfActivity) {
                                                                        If(classOfActivityObj !=null){
                                                                            classOfActiveTrans += classOfActivityObj;
                                                                            
                                                                        }   
                                                                    }
                                                                    If(classOfActiveTrans != null && classOfActiveTrans !='') {
                                                                        creditFacilityDetailGuaObj.Class_of_Activity__c  = classOfActiveTrans;
                                                                    }
                                                                }
                                                            }
                                                        }
                                                    }
                                                    
                                                    //BorrwerAddressContactDetails
                                                    CommercialPR_EAE_Response.BorrwerAddressContactDetailsVec borrwerAddressContactDetailsVecObj = borrwerInfoObj.borrwerAddressContactDetailsVec;
                                                    If(borrwerAddressContactDetailsVecObj !=null){
                                                        List<CommercialPR_EAE_Response.BorrwerAddressContactDetails> listBorrwerAddressContactDetails = borrwerAddressContactDetailsVecObj.borrwerAddressContactDetails;
                                                        If(listBorrwerAddressContactDetails !=null){
                                                            for(CommercialPR_EAE_Response.BorrwerAddressContactDetails   borrwerAddressContactDetailsObj     :   listBorrwerAddressContactDetails){
                                                                Guarantor_Address__c   guarantorAddressObj =   new Guarantor_Address__c();
                                                                If(borrwerAddressContactDetailsObj != null) {
                                                                    If(!Utility.ISStringBlankorNull(borrwerAddressContactDetailsObj.address))
                                                                        guarantorAddressObj.Address__c = borrwerAddressContactDetailsObj.address;
                                                                    If(!Utility.ISStringBlankorNull(borrwerAddressContactDetailsObj.faxNumber))
                                                                        guarantorAddressObj.Fax_Number__c = borrwerAddressContactDetailsObj.faxNumber.deleteWhitespace();
                                                                    If(!Utility.ISStringBlankorNull(borrwerAddressContactDetailsObj.mobileNumber))
                                                                        guarantorAddressObj.Mobile_Number__c = borrwerAddressContactDetailsObj.mobileNumber.deleteWhitespace();
                                                                    If(!Utility.ISStringBlankorNull(borrwerAddressContactDetailsObj.telephoneNumber))
                                                                        guarantorAddressObj.Phone_Number__c = borrwerAddressContactDetailsObj.telephoneNumber.deleteWhitespace();
                                                                    
                                                                    guarantorAddressObj.credit_Facility_Details_Guarantor__r    = new Credit_facility_Details_as_Guarantor__c(External_Id__c = ExternalId);
                                                                    CommercialPR_EAE_Batch.listGuarantorAddress.add(guarantorAddressObj);
                                                                    
                                                                }   
                                                            }
                                                        }
                                                    }
                                                    //BorrwerIDDetailsVec
                                                    CommercialPR_EAE_Response.BorrwerIDDetailsVec borrwerIDDetailsVecObj = borrwerInfoObj.borrwerIDDetailsVec;
                                                    If(borrwerIDDetailsVecObj != null) {
                                                        //BorrwerIDDetails
                                                        List < CommercialPR_EAE_Response.BorrwerIDDetails > listBorrwerIDDetails = borrwerIDDetailsVecObj.borrwerIDDetails;
                                                        If(listBorrwerIDDetails != null) {
                                                            
                                                            for (CommercialPR_EAE_Response.BorrwerIDDetails borrwerIDDetailsObj: listBorrwerIDDetails) {
                                                                TU_ID_s__c tuIDsObj = new TU_ID_s__c();
                                                                If(borrwerIDDetailsObj != null) {
                                                                    
                                                                    If(!Utility.ISStringBlankorNull(borrwerIDDetailsObj.pan))
                                                                        tuIDsObj.Pan_Card_Number__c = borrwerIDDetailsObj.pan.deleteWhitespace();
                                                                    If(!Utility.ISStringBlankorNull(borrwerIDDetailsObj.registrationNumber))
                                                                        tuIDsObj.Registration_Number__c = borrwerIDDetailsObj.registrationNumber.deleteWhitespace();
                                                                    If(!Utility.ISStringBlankorNull(borrwerIDDetailsObj.cin))
                                                                        tuIDsObj.Cin__c = borrwerIDDetailsObj.cin.deleteWhitespace();
                                                                    If(!Utility.ISStringBlankorNull(borrwerIDDetailsObj.tin))
                                                                        tuIDsObj.Tin__c = borrwerIDDetailsObj.tin.deleteWhitespace();
                                                                    If(!Utility.ISStringBlankorNull(borrwerIDDetailsObj.serviceTaxNumber))
                                                                        tuIDsObj.Service_Tax_Number__c = borrwerIDDetailsObj.serviceTaxNumber.deleteWhitespace();
                                                                    
                                                                    String recordtypeIDStr = recordtypeIdMap.get('Borrwer_ID_Details');
                                                                    tuIDsObj.recordtypeId   =   recordtypeIDStr;
                                                                    
                                                                    tuIDsObj.Credit_Facility_Details_Guarantor__r = new Credit_facility_Details_as_Guarantor__c(External_Id__c = ExternalId);
                                                                    CommercialPR_EAE_Batch.listTUIDs.add(tuIDsObj);
                                                                    
                                                                }
                                                                
                                                            }
                                                            
                                                        }
                                                        
                                                    }
                                                    
                                                }
                                                If(creditFacilityDetailGuaObj !=null){
                                                    creditFacilityDetailGuaObj.External_Id__c = ExternalId;
                                                }
                                                creditFacilityDetailGuaObj.Tu_Credit_Report__r = new ints__TransUnion_Credit_Report__c(External_Id__c = TranExternalId);
                                                CommercialPR_EAE_Batch.listCreditfacilityDetailsGuarantor.add(creditFacilityDetailGuaObj);
                                                
                                            }
                                            
                                        }
                                    }
                                }
                            }
                            //SuitFiledVec
                            CommercialPR_EAE_Response.SuitFiledVec suitFiledVecObj = productSecObj.suitFiledVec;
                            If(suitFiledVecObj != null) {
                                If(!Utility.ISStringBlankorNull(suitFiledVecObj.message))
                                    messageObj.SuitFiled_Vec_Message__c = suitFiledVecObj.message.deleteWhitespace();
                                If(suitFiledVecObj.suitFilled !=null){
                                    List<CommercialPR_EAE_Response.SuitFilled_Z>     listSuitFilledObj   =   suitFiledVecObj.suitFilled;
                                    If(listSuitFilledObj !=null) {
                                        for(CommercialPR_EAE_Response.SuitFilled_Z   suitFilledObj   :   listSuitFilledObj) {
                                            SuitFilled__c   suitfilledObject    =   new SuitFilled__c();
                                            If(!Utility.ISStringBlankorNull(suitFilledObj.suitFilledBy))
                                                suitfilledObject.SuitFilled_By__c = suitFilledObj.suitFilledBy.deleteWhitespace(); 
                                            If(!Utility.ISStringBlankorNull(suitFilledObj.suitStatus))
                                                suitfilledObject.Suit_Status__c = suitFilledObj.suitStatus.deleteWhitespace();
                                            If(!Utility.ISStringBlankorNull(suitFilledObj.suitRefNumber))
                                                suitfilledObject.Suit_Ref_Number__c = suitFilledObj.suitRefNumber.deleteWhitespace();
                                            If(!Utility.ISStringBlankorNull(suitFilledObj.suitAmt))
                                                suitfilledObject.Suit_Amount__c = suitFilledObj.suitAmt.deleteWhitespace();
                                            If(!Utility.ISStringBlankorNull(suitFilledObj.dateSuit))
                                                suitfilledObject.Date_Suit__c = suitFilledObj.dateSuit.deleteWhitespace(); 
                                            
                                            suitfilledObject.Tu_Credit_Report__r = new ints__TransUnion_Credit_Report__c(External_Id__c = TranExternalId);
                                            CommercialPR_EAE_Batch.listSuitFilled.add(suitfilledObject);
                                        }
                                    }
                                }
                                
                            }
                            //CreditRatingSummaryVec
                            CommercialPR_EAE_Response.CreditRatingSummaryVec creditRatingSummaryVecObj = productSecObj.creditRatingSummaryVec;
                            If(creditRatingSummaryVecObj != null) {
                                If(!Utility.ISStringBlankorNull(creditRatingSummaryVecObj.message))
                                    messageObj.Credit_Rating_Summary_Message__c = creditRatingSummaryVecObj.message;
                                List<CommercialPR_EAE_Response.CreditRatingSummary> listCreditRatingSummaryObj   =   creditRatingSummaryVecObj.creditRatingSummary;
                                If(listCreditRatingSummaryObj !=null) {
                                    for(CommercialPR_EAE_Response.CreditRatingSummary    creditRatingSummaryObj  :   listCreditRatingSummaryObj) {
                                        If(creditRatingSummaryObj !=null){
                                            List<CommercialPR_EAE_Response.CreditRatingSummaryDetailsVec>   listCreditRatingSummaryDetailsVec =  creditRatingSummaryObj.creditRatingSummaryDetailsVec;
                                            If(listCreditRatingSummaryDetailsVec !=null){
                                                for(CommercialPR_EAE_Response.CreditRatingSummaryDetailsVec  creditRatingSummaryDetailsVecObj    :   listCreditRatingSummaryDetailsVec) {
                                                    Credit_Rating_Summary__c    creditRatingSummaryObject   = new Credit_Rating_Summary__c();
                                                    
                                                    If(!Utility.ISStringBlankorNull(creditRatingSummaryObj.creditRatingAgency))
                                                        creditRatingSummaryObject.creditRating_Agency__c = creditRatingSummaryObj.creditRatingAgency.deleteWhitespace();
                                                    
                                                    If(creditRatingSummaryDetailsVecObj !=null) {
                                                        If(!Utility.ISStringBlankorNull(creditRatingSummaryDetailsVecObj.creditRating))
                                                            creditRatingSummaryObject.Credit_Rating__c = creditRatingSummaryDetailsVecObj.creditRating.deleteWhitespace();
                                                        
                                                        If(!Utility.ISStringBlankorNull(creditRatingSummaryDetailsVecObj.ratingAsOn))
                                                            creditRatingSummaryObject.RatingAs_On__c = creditRatingSummaryDetailsVecObj.ratingAsOn.deleteWhitespace(); 
                                                        
                                                        If(!Utility.ISStringBlankorNull(creditRatingSummaryDetailsVecObj.ratingExpiryDt))
                                                            creditRatingSummaryObject.Rating_Expiry_Date__c = creditRatingSummaryDetailsVecObj.ratingExpiryDt.deleteWhitespace();
                                                        
                                                        If(!Utility.ISStringBlankorNull(creditRatingSummaryDetailsVecObj.lastReportedDt))
                                                            creditRatingSummaryObject.Last_Reported_Date__c = creditRatingSummaryDetailsVecObj.lastReportedDt.deleteWhitespace();
                                                    }
                                                    creditRatingSummaryObject.Tu_Credit_Report__r = new ints__TransUnion_Credit_Report__c(External_Id__c = TranExternalId);
                                                    CommercialPR_EAE_Batch.listCreditRatingSummary.add(creditRatingSummaryObject);
                                                }
                                            }
                                        }
                                    }   
                                }
                            }
                            
                            //EnquiryDetailsInLast24MonthVec
                            CommercialPR_EAE_Response.EnquiryDetailsInLast24MonthVec enquiryDetailsInLast24MonthVecObj = productSecObj.enquiryDetailsInLast24MonthVec;
                            If(enquiryDetailsInLast24MonthVecObj != null) {
                                If(!Utility.ISStringBlankorNull(enquiryDetailsInLast24MonthVecObj.message))
                                    messageObj.Enquiry_Details_In_Last_24Month_Message__c                                       =   enquiryDetailsInLast24MonthVecObj.message;
                                //List of EnquiryDetailsInLast24Month
                                listenquiryDetailsInLast24Month = enquiryDetailsInLast24MonthVecObj.enquiryDetailsInLast24Month;
                                If(listenquiryDetailsInLast24Month != null && listenquiryDetailsInLast24Month.size() > 0) {
                                    for (CommercialPR_EAE_Response.EnquiryDetailsInLast24Month enquiryDetailsInLast24MonthObj: listenquiryDetailsInLast24Month) {
                                        Enquiry_Summary__c enquirySummaryObj = new Enquiry_Summary__c();
                                        If(enquiryDetailsInLast24MonthObj != null) {
                                            If(!Utility.ISStringBlankorNull(enquiryDetailsInLast24MonthObj.creditLender))
                                                enquirySummaryObj.Credit_Lender__c = enquiryDetailsInLast24MonthObj.creditLender.deleteWhitespace();
                                            If(!Utility.ISStringBlankorNull(enquiryDetailsInLast24MonthObj.enquiryDt))
                                                enquirySummaryObj.Enquiry_Date__c = enquiryDetailsInLast24MonthObj.enquiryDt.deleteWhitespace();
                                            If(!Utility.ISStringBlankorNull(enquiryDetailsInLast24MonthObj.enquiryPurpose))
                                                enquirySummaryObj.Enquiry_Purpose__c = enquiryDetailsInLast24MonthObj.enquiryPurpose.deleteWhitespace();
                                            If(!Utility.ISStringBlankorNull(enquiryDetailsInLast24MonthObj.enquiryAmt))
                                                enquirySummaryObj.Enquiry_Amount__c = enquiryDetailsInLast24MonthObj.enquiryAmt.deleteWhitespace();
                                            enquirySummaryObj.Tu_Credit_Report__r = new ints__TransUnion_Credit_Report__c(External_Id__c = TranExternalId);
                                            CommercialPR_EAE_Batch.listenquirySummary.add(enquirySummaryObj);
                                        }
                                        
                                    }
                                }
                            }
                            //CreditFacilitiesSummary   
                            CommercialPR_EAE_Response.CreditFacilitiesSummary creditFacilitiesSummaryObj = productSecObj.creditFacilitiesSummary;
                            If(creditFacilitiesSummaryObj != null) {
                                //CountOfCreditFacilities
                                CommercialPR_EAE_Response.CountOfCreditFacilities countOfCreditFacilitiesObj = creditFacilitiesSummaryObj.countOfCreditFacilities;
                                If(countOfCreditFacilitiesObj != null) {
                                    //NoOfCreditFacilities
                                    CommercialPR_EAE_Response.NoOfCreditFacilities noOfCreditFacilitiesObj = countOfCreditFacilitiesObj.noOfCreditFacilities;
                                    If(noOfCreditFacilitiesObj != null) {
                                        If(!Utility.ISStringBlankorNull(noOfCreditFacilitiesObj.yourBank))
                                            transunionObj.Your_Bank__c = Integer.valueOf(noOfCreditFacilitiesObj.yourBank.deleteWhitespace());
                                        If(!Utility.ISStringBlankorNull(noOfCreditFacilitiesObj.others))
                                            transunionObj.Others__c = Integer.valueOf(noOfCreditFacilitiesObj.others.deleteWhitespace());
                                        If(!Utility.ISStringBlankorNull(noOfCreditFacilitiesObj.total))
                                            transunionObj.Total__c = Integer.valueOf(noOfCreditFacilitiesObj.total.deleteWhitespace());
                                    }
                                    //NoOfCreditFacilities
                                    CommercialPR_EAE_Response.NoOfCreditFacilities noOfCreditGrantorsObj = countOfCreditFacilitiesObj.noOfCreditGrantors;
                                    If(noOfCreditGrantorsObj != null) {
                                        If(!Utility.ISStringBlankorNull(noOfCreditGrantorsObj.yourBank))
                                            transunionObj.CreditGrantors_Your_Bank__c = noOfCreditGrantorsObj.yourBank.deleteWhitespace();
                                        If(!Utility.ISStringBlankorNull(noOfCreditGrantorsObj.others))
                                            transunionObj.CreditGrantors_Others__c = noOfCreditGrantorsObj.others.deleteWhitespace();
                                        If(!Utility.ISStringBlankorNull(noOfCreditGrantorsObj.total))
                                            transunionObj.CreditGrantors_Total__c = noOfCreditGrantorsObj.total.deleteWhitespace();
                                    }
                                }
                                CommercialPR_EAE_Response.SummaryOfCreditFacilitiesVec   summaryOfCreditFacilitiesVecObj =   creditFacilitiesSummaryObj.summaryOfCreditFacilitiesVec;
                                If(summaryOfCreditFacilitiesVecObj !=null){
                                    If(summaryOfCreditFacilitiesVecObj.summaryOfCreditFacilitiesRec !=null){
                                        List<CommercialPR_EAE_Response.SummaryOfCreditFacilitiesRec> listSummaryOfCreditFacilitiesRec =  summaryOfCreditFacilitiesVecObj.summaryOfCreditFacilitiesRec; 
                                        If(listSummaryOfCreditFacilitiesRec !=null) {
                                            for(CommercialPR_EAE_Response.SummaryOfCreditFacilitiesRec summaryOfCreditFacilitiesRecObj   :   listSummaryOfCreditFacilitiesRec){
                                                Summary_Credit_Facility__c  summaryCreditFacilityObj    =   new Summary_Credit_Facility__c();
                                                If(summaryOfCreditFacilitiesRecObj !=null){
                                                    If(!Utility.ISStringBlankorNull(summaryOfCreditFacilitiesRecObj.creditType))
                                                        summaryCreditFacilityObj.Credit_Type__c = summaryOfCreditFacilitiesRecObj.creditType.deleteWhitespace();
                                                    If(!Utility.ISStringBlankorNull(summaryOfCreditFacilitiesRecObj.yourBank))
                                                        summaryCreditFacilityObj.Your_Bank__c = summaryOfCreditFacilitiesRecObj.yourBank.deleteWhitespace();
                                                    If(!Utility.ISStringBlankorNull(summaryOfCreditFacilitiesRecObj.othersBank))
                                                        summaryCreditFacilityObj.Other_Bank__c = summaryOfCreditFacilitiesRecObj.othersBank.deleteWhitespace(); 
                                                    
                                                    summaryCreditFacilityObj.Tu_Credit_Report__r = new ints__TransUnion_Credit_Report__c(External_Id__c = TranExternalId);
                                                    CommercialPR_EAE_Batch.listSummaryCreditFacility.add(summaryCreditFacilityObj);
                                                }    
                                            }
                                        }
                                    }
                                }
                            }
                            CommercialPR_EAE_Response.CreditFacilitiesDetailsVec creditFacilitiesDetailsVecObj   =  productSecObj.creditFacilitiesDetailsVec;    
                            
                            If(creditFacilitiesDetailsVecObj !=null){
                                //Message
                                If(!Utility.ISStringBlankorNull(creditFacilitiesDetailsVecObj.message))
                                    messageObj.Credit_Facility_Details_Message__c = creditFacilitiesDetailsVecObj.message;
                                //Total
                                List<CommercialPR_EAE_Response.CreditFacilitiesDetails> listCreditFacilitiesDetails   = creditFacilitiesDetailsVecObj.creditFacilitiesDetails;
                                If(listCreditFacilitiesDetails !=null){
                                    for(CommercialPR_EAE_Response.CreditFacilitiesDetails    creditFacilitiesDetailsObj  :   listCreditFacilitiesDetails) {
                                        Credit_Facility_Detail__c creditFacilityObj = new Credit_Facility_Detail__c();
                                        If(creditFacilitiesDetailsObj !=null) {
                                            If(!Utility.ISStringBlankorNull(creditFacilitiesDetailsObj.creditType))
                                                creditFacilityObj.Credit_Type__c = creditFacilitiesDetailsObj.creditType.deleteWhitespace();
                                            If(!Utility.ISStringBlankorNull(creditFacilitiesDetailsObj.group_Z))
                                                creditFacilityObj.Group__c = creditFacilitiesDetailsObj.group_Z.deleteWhitespace();
                                            If(!Utility.ISStringBlankorNull(creditFacilitiesDetailsObj.accountNo))
                                                creditFacilityObj.Account_Number__c = creditFacilitiesDetailsObj.accountNo.deleteWhitespace();
                                            If(!Utility.ISStringBlankorNull(creditFacilitiesDetailsObj.reportedBy))
                                                creditFacilityObj.Reported_By__c = creditFacilitiesDetailsObj.reportedBy.deleteWhitespace();
                                            If(!Utility.ISStringBlankorNull(creditFacilitiesDetailsObj.currentBalance))
                                                creditFacilityObj.Current_Balance__c = creditFacilitiesDetailsObj.currentBalance.deleteWhitespace();
                                            If(!Utility.ISStringBlankorNull(creditFacilitiesDetailsObj.closedDate))
                                                creditFacilityObj.Closed_Date__c = creditFacilitiesDetailsObj.closedDate.deleteWhitespace();
                                            If(!Utility.ISStringBlankorNull(creditFacilitiesDetailsObj.lastReported))
                                                creditFacilityObj.Last_Reported__c = creditFacilitiesDetailsObj.lastReported.deleteWhitespace();
                                        }
                                        creditFacilityObj.Tu_Credit_Report__r = new ints__TransUnion_Credit_Report__c(External_Id__c = TranExternalId);
                                        CommercialPR_EAE_Batch.listCreditFacilityDetail.add(creditFacilityObj);
                                    }
                                }
                            }
                            
                            //Message
                            messageObj.TU_Credit_Report__r = new ints__TransUnion_Credit_Report__c(External_Id__c = TranExternalId);
                            CommercialPR_EAE_Batch.listMessage.add(messageObj);
                            
                        }
                        
                    }
                    Integer currentYear = Utility.getCurrentYear();
                    String cyString = String.valueOf(currentYear);
                    String currentFY = (currentYear-1)+'-'+Integer.valueOf(cyString.subString(cyString.length()-2,cyString.length())); 
                    transunionObj.Fiscal_year__c    = currentFY;
                    system.debug('transunionObj=====> '+transunionObj);    
                    CommercialPR_EAE_Batch.listTransUnion.add(transunionObj);
                    
                }
                
            }
        }
        
    }
    
}