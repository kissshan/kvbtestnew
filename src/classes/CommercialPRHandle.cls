/*
* Name     : CommercialPRHandle
* Company  : ET Marlabs
* Purpose  : TO used as a Handler class for CommercialPRCallout. 
* Author   : Raushan
*/
public with sharing class CommercialPRHandle {
    
    public static WS_CommercialPRResponse.Response getCommercialPRDetails(CommercialPRResponse commercialPRRes) {
        WS_CommercialPRResponse.Response res = new WS_CommercialPRResponse.Response();
        List<String> custIdList = new List<String>();
        List<Account> accList = new List<Account>();
        List<String> cbsIdToExclude = new List<String>();
        Integer tuValidationPeriod = Integer.valueOf(KVB_Company_Details__c.getInstance().TU_validation_period_months__c) * -1;
        If(commercialPRRes != null) {
            List <CommercialPRResponse.Out_msg> listOutMsg                          = commercialPRRes.out_msg;
            If(listOutMsg != null && listOutMsg.size() > 0) {
                
                for (CommercialPRResponse.Out_msg outMsgObj: listOutMsg) {
                    if(outMsgObj.responseReport != null && outMsgObj.responseReport.reportHeaderRec != null && outMsgObj.responseReport.reportHeaderRec.applicationReferenceNumber != null)
                        custIdList.add(outMsgObj.responseReport.reportHeaderRec.applicationReferenceNumber);
                }
                if(custIdList.size() > 0){
                    accList = [SELECT Id,CBS_Customer_ID__c,(SELECT Id,CreatedDate FROM TU_Errors__r ORDER By CreatedDate DESC),(SELECT Id,CreatedDate FROM TransUnion_Credit_Reports__r ORDER By CreatedDate DESC) FROM Account WHERE CBS_Customer_ID__c IN : custIdList];
                    if(accList.size() > 0){
                        for(Account acc : accList){
                            if(acc.TransUnion_Credit_Reports__r.size() > 0 && tuValidationPeriod != null && acc.TransUnion_Credit_Reports__r[0].CreatedDate > System.now().addMonths(tuValidationPeriod)){
                                cbsIdToExclude.add(acc.CBS_Customer_ID__c);
                            }
                            else if(acc.TU_Errors__r.size() > 0 && tuValidationPeriod != null && acc.TU_Errors__r[0].CreatedDate > System.now().addMonths(tuValidationPeriod)){
                                cbsIdToExclude.add(acc.CBS_Customer_ID__c);
                            }
                        }
                    }
                }
                for (CommercialPRResponse.Out_msg outMsgObj: listOutMsg) {
                    Savepoint sp = Database.setSavepoint();
                    
                    WS_CommercialPRResponse.InsertedDataResponse  successRes = new WS_CommercialPRResponse.InsertedDataResponse(); 
                    WS_CommercialPRResponse.FailedDataResponse failedRes = new WS_CommercialPRResponse.FailedDataResponse();
                    
                    ints__TransUnion_Credit_Report__c transunionObj = new ints__TransUnion_Credit_Report__c();
                    String TranExternalId = String.valueOf(Math.random()) + 'transcreditreport';
                    transunionObj.External_Id__c = TranExternalId;
                    String custId;
                    
                    List <ints__TransUnion_Credit_Report__c> listTransUnion                 = new List < ints__TransUnion_Credit_Report__c > ();
                    List <CommercialPRResponse.LocationInformation> listlocationInformation;
                    List <CommercialPRResponse.RelationshipDetails> listrelationshipDetails;
                    List <CommercialPRResponse.CreditFacilityDetailsasBorrowerSec> listcreditFacilityDetailsasBorrowerSec;
                    List <CommercialPRResponse.CFHistoryforACOrDPDupto24Months> listCFHistoryforACOrDPDupto24Months;
                    List <CommercialPRResponse.EnquiryDetailsInLast24Month> listenquiryDetailsInLast24Month;
                    //Credit Profile
                    List < Credit_Profile__c > listcreditProfile = new List < Credit_Profile__c > ();
                    
                    //Enquiry Summary
                    List < Enquiry_Summary__c > listenquirySummary = new List < Enquiry_Summary__c > ();
                    
                    //DerogatoryInformation Parent
                    List < Derogatory_Information__c > listderogatoryInformationParent = new List < Derogatory_Information__c > ();
                    
                    //DerogatoryInformation Child
                    List < Derogatory_Information__c > listderogatoryInformation = new List < Derogatory_Information__c > ();
                    
                    //OustandingBalancebyCF
                    List < OustandingBalancebyCF__c > listOustandingBalancebyCF = new List < OustandingBalancebyCF__c > ();
                    
                    //Location Detail
                    List < Location_Detail__c > listlocationDetail = new List < Location_Detail__c > ();
                    
                    //Relationship Detail
                    List < Relationship_Detail__c > listRelationshipDetail = new List < Relationship_Detail__c > ();
                    
                    //Credit Facility Detail
                    List < Credit_Facility_Detail__c > listCreditFacilityDetail = new List < Credit_Facility_Detail__c > ();
                    
                    //Message
                    List < TU_Message__c > listMessage = new List < TU_Message__c > ();
                    
                    //TU CFHistory
                    List < TU_CFHistory__c > listTUCFHistory = new List < TU_CFHistory__c > ();
                    
                    //TU IDs
                    List < TU_ID_s__c > listTUIDs = new List < TU_ID_s__c > ();
                    
                    //RankVec
                    List < RankVec__c > listRankVecObj = new List < RankVec__c > ();
                    //Borrower Delinquency Report
                    List<Borrower_Delinquency_Report__c> listBorrowerDelinquencyReport  = new List<Borrower_Delinquency_Report__c>();
                    
                    //Credit facility Details as Guarantor
                    List<Credit_facility_Details_as_Guarantor__c> listCreditfacilityDetailsGuarantor    = new List<Credit_facility_Details_as_Guarantor__c>();
                    
                    //Guarantor Addesss
                    List<Guarantor_Address__c> listGuarantorAddress     =   new List<Guarantor_Address__c>();
                    
                    //SuitFilled
                    List<SuitFilled__c> listSuitFilled      =   new List<SuitFilled__c>();
                    
                    //Credit Rating Summary
                    List<Credit_Rating_Summary__c>  listCreditRatingSummary     =   new  List<Credit_Rating_Summary__c>();
                    
                    //Summary of Credit Facility
                    List<Summary_Credit_Facility__c> listSummaryCreditFacility  =   new List<Summary_Credit_Facility__c>();
                    
                    //List of DeveloperName
                    List<String> listDeveloperName = new List<String>{'Enquiry_Address','Borrwer_ID_Details','Location_Details','Relationship_ID_Details'};
                        
                        Map<String,id> recordtypeIdMap = Utility.getRecordTypeID(listDeveloperName);
                    
                    //External ID for Application CommercialPR Statge Update.
                    String externalId_App   = '';
                    List<String> extIdList = new List<String>();
                    
                    If(outMsgObj != null) {
                        //ReportHeaderRec
                        CommercialPRResponse.ResponseReport responseReportObj = outMsgObj.responseReport;
                        if(responseReportObj.reportHeaderRec.applicationReferenceNumber != null){
                            custId = responseReportObj.reportHeaderRec.applicationReferenceNumber;
                            if(!cbsIdToExclude.contains(responseReportObj.reportHeaderRec.applicationReferenceNumber)){
                                If(responseReportObj != null) {
                                    //ReportHeaderRec
                                    try{
                                        CommercialPRResponse.ReportHeaderRec reportHeaderRecObj = responseReportObj.reportHeaderRec;
                                        
                                        If(!Utility.ISStringBlankorNull(reportHeaderRecObj.reportOrderNumber))
                                            transunionObj.Report_Order_Number__c = reportHeaderRecObj.reportOrderNumber;
                                        If(!Utility.ISStringBlankorNull(reportHeaderRecObj.reportOrderDate))
                                            transunionObj.Report_Order_Date__c = reportHeaderRecObj.reportOrderDate;
                                        If(!Utility.ISStringBlankorNull(reportHeaderRecObj.reportOrderedBy))
                                            transunionObj.Report_OrderBy__c = reportHeaderRecObj.reportOrderedBy;
                                        If(!Utility.ISStringBlankorNull(reportHeaderRecObj.memberDetails))
                                            transunionObj.Member_Details__c = reportHeaderRecObj.memberDetails;
                                        If(!Utility.ISStringBlankorNull(reportHeaderRecObj.applicationReferenceNumber)) {
                                            transunionObj.Application_Reference_Number__c = reportHeaderRecObj.applicationReferenceNumber;
                                            transunionObj.Account__r = new Account(CBS_Customer_ID__c = String.valueOf(reportHeaderRecObj.applicationReferenceNumber));
                                            externalId_App  =   reportHeaderRecObj.applicationReferenceNumber;
                                            extIdList.add(reportHeaderRecObj.applicationReferenceNumber);
                                        }
                                        If(!Utility.ISStringBlankorNull(reportHeaderRecObj.inquiryPurpose))
                                            transunionObj.Inquiry_Purpose__c = reportHeaderRecObj.inquiryPurpose;
                                    }
                                    catch(Exception ex){
                                        System.debug(ex.getMessage());
                                        Database.rollback(sp);
                                        res.status                  = Constants.WS_ERROR_STATUS;
                                        res.statusCode              = Constants.WS_ERROR_CODE;
                                        failedRes.cust_Id        = custId;
                                        failedRes.error_reason   = ex.getMessage(); 
                                        failedRes.error_table    = 'responseReport.reportHeaderRec parsing error';
                                        res.Error_List.add(failedRes);
                                        continue;
                                    }
                                }
                                
                                
                                //EnquiryInformationRec
                                CommercialPRResponse.EnquiryInformationRec enquiryInformationRecObj = responseReportObj.enquiryInformationRec;
                                If(enquiryInformationRecObj != null) {
                                    try{
                                        If(!Utility.ISStringBlankorNull(enquiryInformationRecObj.borrowerName))
                                            transunionObj.Borrower_Name__c = enquiryInformationRecObj.borrowerName;
                                        If(!Utility.ISStringBlankorNull(enquiryInformationRecObj.pan))
                                            transunionObj.Pan_Card_Number__c = enquiryInformationRecObj.pan;
                                        If(!Utility.ISStringBlankorNull(enquiryInformationRecObj.cin))
                                            transunionObj.Cin__c = enquiryInformationRecObj.cin;
                                        If(!Utility.ISStringBlankorNull(enquiryInformationRecObj.tin))
                                            transunionObj.Tin__c = enquiryInformationRecObj.tin;
                                        If(!Utility.ISStringBlankorNull(enquiryInformationRecObj.crn))
                                            transunionObj.Crn__c = enquiryInformationRecObj.crn;
                                        If(!Utility.ISStringBlankorNull(enquiryInformationRecObj.addressCount))
                                            transunionObj.Address_Count__c = Integer.valueOf(enquiryInformationRecObj.addressCount);
                                        
                                        //AddressVec
                                        CommercialPRResponse.AddressVec addressVecObj = enquiryInformationRecObj.addressVec;
                                        If(addressVecObj != null) {
                                            //Address
                                            If(addressVecObj.address != null) {
                                                List <CommercialPRResponse.Address> listAddress = addressVecObj.address;
                                                If(listAddress != null) {
                                                    for (CommercialPRResponse.Address addressObj: listAddress) {
                                                        Location_Detail__c enquiryAddressObj = new Location_Detail__c();
                                                        If(addressObj != null) {
                                                            If(!Utility.ISStringBlankorNull(addressObj.addressLine))
                                                                enquiryAddressObj.Address__c = addressObj.addressLine;
                                                            If(!Utility.ISStringBlankorNull(addressObj.city))
                                                                enquiryAddressObj.City__c = addressObj.city;
                                                            If(!Utility.ISStringBlankorNull(addressObj.state))
                                                                enquiryAddressObj.State_Name__c = addressObj.state;
                                                            If(!Utility.ISStringBlankorNull(addressObj.pinCode))
                                                                enquiryAddressObj.Pin_Code__c = addressObj.pinCode;
                                                            
                                                            String recordtypeIDStr = recordtypeIdMap.get('Enquiry_Address');
                                                            enquiryAddressObj.recordtypeId  =   recordtypeIDStr;
                                                            enquiryAddressObj.Tu_Credit_Report__r = new ints__TransUnion_Credit_Report__c(External_Id__c = TranExternalId);
                                                            listlocationDetail.add(enquiryAddressObj);
                                                        }
                                                    }
                                                }
                                                
                                            }
                                        }
                                    }
                                    catch(Exception ex){
                                        System.debug(ex.getMessage());
                                        Database.rollback(sp);
                                        res.status                  = Constants.WS_ERROR_STATUS;
                                        res.statusCode              = Constants.WS_ERROR_CODE;
                                        failedRes.cust_Id        = custId;
                                        failedRes.error_reason   = ex.getMessage(); 
                                        failedRes.error_table    = 'responseReport.enquiryInformationRec parsing error';
                                        res.Error_List.add(failedRes);
                                        continue;
                                    }
                                }
                                //ProductSec
                                CommercialPRResponse.ProductSec productSecObj = responseReportObj.productSec;
                                If(productSecObj != null) {
                                    try{
                                        TU_Message__c messageObj = new TU_Message__c();
                                        //BorrowerProfileSec
                                        CommercialPRResponse.BorrowerProfileSec borrowerProfileSecObj = productSecObj.borrowerProfileSec;
                                        If(borrowerProfileSecObj != null) {
                                            //BorrwerDetails
                                            CommercialPRResponse.BorrwerDetails borrwerDetailsObj = borrowerProfileSecObj.borrwerDetails;
                                            If(borrwerDetailsObj != null) {
                                                If(!Utility.ISStringBlankorNull(borrwerDetailsObj.name))
                                                    transunionObj.Borrower_Name__c = borrwerDetailsObj.name;
                                                If(!Utility.ISStringBlankorNull(borrwerDetailsObj.borrowersLegalConstitution))
                                                    transunionObj.Borrowers_Legal_Constitution__c = borrwerDetailsObj.borrowersLegalConstitution;
                                                If(!Utility.ISStringBlankorNull(borrwerDetailsObj.businessCategory))
                                                    transunionObj.Business_Category__c = borrwerDetailsObj.businessCategory;
                                                If(!Utility.ISStringBlankorNull(borrwerDetailsObj.businessIndustryType))
                                                    transunionObj.Business_IndustryType__c = borrwerDetailsObj.businessIndustryType;
                                                If(!Utility.ISStringBlankorNull(borrwerDetailsObj.numberOfEmployees))
                                                    transunionObj.Number_Of_Employees__c = Integer.valueOf(borrwerDetailsObj.numberOfEmployees);
                                                If(!Utility.ISStringBlankorNull(borrwerDetailsObj.dateOfIncorporation))
                                                    transunionObj.Date_Of_Incorporation__c = borrwerDetailsObj.dateOfIncorporation;
                                                If(!Utility.ISStringBlankorNull(borrwerDetailsObj.salesFigure))
                                                    transunionObj.Sales_Figure__c = borrwerDetailsObj.salesFigure;
                                                If(!Utility.ISStringBlankorNull(borrwerDetailsObj.year))
                                                    transunionObj.Year__c = borrwerDetailsObj.year;
                                                // classOfActivityVec
                                                If(borrwerDetailsObj.classOfActivityVec !=null){
                                                    CommercialPRResponse.ClassOfActivityVec  classOfActivityVecObj          =   borrwerDetailsObj.classOfActivityVec;
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
                                            CommercialPRResponse.BorrwerAddressContactDetails borrwerAddressContactDetailsObj = borrowerProfileSecObj.borrwerAddressContactDetails;
                                            If(borrwerAddressContactDetailsObj != null) {
                                                If(!Utility.ISStringBlankorNull(borrwerAddressContactDetailsObj.address))
                                                    transunionObj.Address__c = borrwerAddressContactDetailsObj.address;
                                                If(!Utility.ISStringBlankorNull(borrwerAddressContactDetailsObj.faxNumber))
                                                    transunionObj.Fax_Number__c = borrwerAddressContactDetailsObj.faxNumber.deleteWhitespace();
                                                If(!Utility.ISStringBlankorNull(borrwerAddressContactDetailsObj.mobileNumber))
                                                    transunionObj.Mobile_Number__c = borrwerAddressContactDetailsObj.mobileNumber;
                                                If(!Utility.ISStringBlankorNull(borrwerAddressContactDetailsObj.telephoneNumber))
                                                    transunionObj.Phone_Number__c = borrwerAddressContactDetailsObj.telephoneNumber;
                                            }
                                            
                                            //BorrwerIDDetailsVec
                                            CommercialPRResponse.BorrwerIDDetailsVec borrwerIDDetailsVecObj = borrowerProfileSecObj.borrwerIDDetailsVec;
                                            If(borrwerIDDetailsVecObj != null) {
                                                If(!Utility.ISStringBlankorNull(borrwerIDDetailsVecObj.lastReportedDate))
                                                    transunionObj.Last_Reported_Date__c = borrwerIDDetailsVecObj.lastReportedDate;
                                                //BorrwerIDDetails
                                                List < CommercialPRResponse.BorrwerIDDetails > listBorrwerIDDetails = borrwerIDDetailsVecObj.borrwerIDDetails;
                                                If(listBorrwerIDDetails != null) {
                                                    
                                                    for (CommercialPRResponse.BorrwerIDDetails borrwerIDDetailsObj: listBorrwerIDDetails) {
                                                        TU_ID_s__c tuIDsObj = new TU_ID_s__c();
                                                        If(borrwerIDDetailsObj != null) {
                                                            
                                                            If(!Utility.ISStringBlankorNull(borrwerIDDetailsObj.pan))
                                                                tuIDsObj.Pan_Card_Number__c = borrwerIDDetailsObj.pan;
                                                            If(!Utility.ISStringBlankorNull(borrwerIDDetailsObj.registrationNumber))
                                                                tuIDsObj.Registration_Number__c = borrwerIDDetailsObj.registrationNumber;
                                                            If(!Utility.ISStringBlankorNull(borrwerIDDetailsObj.cin))
                                                                tuIDsObj.Cin__c = borrwerIDDetailsObj.cin;
                                                            If(!Utility.ISStringBlankorNull(borrwerIDDetailsObj.tin))
                                                                tuIDsObj.Tin__c = borrwerIDDetailsObj.tin;
                                                            If(!Utility.ISStringBlankorNull(borrwerIDDetailsObj.serviceTaxNumber))
                                                                tuIDsObj.Service_Tax_Number__c = borrwerIDDetailsObj.serviceTaxNumber;
                                                            
                                                            String recordtypeIDStr = recordtypeIdMap.get('Borrwer_ID_Details');
                                                            tuIDsObj.recordtypeId   =   recordtypeIDStr;
                                                            //tuIDsObj.recordtype.developerName = 'Borrwer_ID_Details';
                                                            tuIDsObj.TU_Credit_Report__r = new ints__TransUnion_Credit_Report__c(External_Id__c = TranExternalId);
                                                            listTUIDs.add(tuIDsObj);
                                                            
                                                        }
                                                        
                                                    }
                                                    
                                                }
                                                
                                            }
                                            
                                            // BorrowerDelinquencyReportedOnBorrower  
                                            CommercialPRResponse.BorrowerDelinquencyReportedOnBorrower borrowerDelinquencyReportedOnBorrowerObj = borrowerProfileSecObj.borrowerDelinquencyReportedOnBorrower;
                                            If(borrowerDelinquencyReportedOnBorrowerObj != null) {
                                                //YourInstitution
                                                CommercialPRResponse.YourInstitution yourInstitutionObj = borrowerDelinquencyReportedOnBorrowerObj.yourInstitution;
                                                If(yourInstitutionObj != null) {
                                                    transunionObj = CommercialPRUtility.getYourInstitution(yourInstitutionObj, transunionObj);
                                                }
                                                //Outside Institution
                                                CommercialPRResponse.YourInstitution yourInstitutionObj1 = borrowerDelinquencyReportedOnBorrowerObj.outsideInstitution;
                                                If(yourInstitutionObj1 != null) {
                                                    transunionObj = CommercialPRUtility.getOutsideInstitution(yourInstitutionObj1, transunionObj);
                                                }
                                            }
                                            //BorrowerDelinquencyReportedOnRSOrGSOftheBorrowerIn24MonthsVec 
                                            CommercialPRResponse.BorrowerDelinquencyReportedOnRSOrGSOftheBorrowerIn24MonthsVec borrowerDelinquencyReportedOnRSOrGSOftheBorrowerIn24MonthsVecObj = borrowerProfileSecObj.borrowerDelinquencyReportedOnRSOrGSOftheBorrowerIn24MonthsVec;
                                            If(borrowerDelinquencyReportedOnRSOrGSOftheBorrowerIn24MonthsVecObj != null) {
                                                If(!Utility.ISStringBlankorNull(borrowerDelinquencyReportedOnRSOrGSOftheBorrowerIn24MonthsVecObj.message))
                                                    transunionObj.Message__c = borrowerDelinquencyReportedOnRSOrGSOftheBorrowerIn24MonthsVecObj.message;
                                                If(borrowerDelinquencyReportedOnRSOrGSOftheBorrowerIn24MonthsVecObj.borrowerDelinquencyReportedOnRSOrGSOftheBorrowerIn24Months !=null) {
                                                    List<CommercialPRResponse.BorrowerDelinquencyReportedOnRSOrGSOftheBorrowerIn24Months>  listBorrowerDelinquencyReportedOnRSOrGSOftheBorrowerIn24Months = borrowerDelinquencyReportedOnRSOrGSOftheBorrowerIn24MonthsVecObj.borrowerDelinquencyReportedOnRSOrGSOftheBorrowerIn24Months; 
                                                    If(listBorrowerDelinquencyReportedOnRSOrGSOftheBorrowerIn24Months !=null){
                                                        for(CommercialPRResponse.BorrowerDelinquencyReportedOnRSOrGSOftheBorrowerIn24Months borrowerDelinquencyReportedOnRSOrGSOftheBorrowerIn24MonthsObj       :   listBorrowerDelinquencyReportedOnRSOrGSOftheBorrowerIn24Months) {
                                                            Borrower_Delinquency_Report__c  borrowerDelinquencyReportObj    = new Borrower_Delinquency_Report__c();
                                                            If(borrowerDelinquencyReportedOnRSOrGSOftheBorrowerIn24MonthsObj != null) {
                                                                If(!Utility.ISStringBlankorNull(borrowerDelinquencyReportedOnRSOrGSOftheBorrowerIn24MonthsObj.detail))
                                                                    borrowerDelinquencyReportObj.Detail__c   =   borrowerDelinquencyReportedOnRSOrGSOftheBorrowerIn24MonthsObj.detail;
                                                                If(!Utility.ISStringBlankorNull(borrowerDelinquencyReportedOnRSOrGSOftheBorrowerIn24MonthsObj.relationship))
                                                                    borrowerDelinquencyReportObj.Relationship__c =   borrowerDelinquencyReportedOnRSOrGSOftheBorrowerIn24MonthsObj.relationship; 
                                                                If(!Utility.ISStringBlankorNull(borrowerDelinquencyReportedOnRSOrGSOftheBorrowerIn24MonthsObj.tl_count))
                                                                    borrowerDelinquencyReportObj.tl_count__c =   borrowerDelinquencyReportedOnRSOrGSOftheBorrowerIn24MonthsObj.tl_count; 
                                                                If(!Utility.ISStringBlankorNull(borrowerDelinquencyReportedOnRSOrGSOftheBorrowerIn24MonthsObj.tl_outstanding))
                                                                    borrowerDelinquencyReportObj.tl_outstanding__c   =   borrowerDelinquencyReportedOnRSOrGSOftheBorrowerIn24MonthsObj.tl_outstanding;
                                                                If(!Utility.ISStringBlankorNull(borrowerDelinquencyReportedOnRSOrGSOftheBorrowerIn24MonthsObj.wc_count))
                                                                    borrowerDelinquencyReportObj.wc_count__c =   borrowerDelinquencyReportedOnRSOrGSOftheBorrowerIn24MonthsObj.wc_count;
                                                                If(!Utility.ISStringBlankorNull(borrowerDelinquencyReportedOnRSOrGSOftheBorrowerIn24MonthsObj.wc_outstanding))
                                                                    borrowerDelinquencyReportObj.wc_outstanding__c   =   borrowerDelinquencyReportedOnRSOrGSOftheBorrowerIn24MonthsObj.wc_outstanding;
                                                                If(!Utility.ISStringBlankorNull(borrowerDelinquencyReportedOnRSOrGSOftheBorrowerIn24MonthsObj.nf_count))
                                                                    borrowerDelinquencyReportObj.nf_count__c =   borrowerDelinquencyReportedOnRSOrGSOftheBorrowerIn24MonthsObj.nf_count;
                                                                If(!Utility.ISStringBlankorNull(borrowerDelinquencyReportedOnRSOrGSOftheBorrowerIn24MonthsObj.nf_outstanding))
                                                                    borrowerDelinquencyReportObj.nf_outstanding__c   =   borrowerDelinquencyReportedOnRSOrGSOftheBorrowerIn24MonthsObj.nf_outstanding;
                                                                If(!Utility.ISStringBlankorNull(borrowerDelinquencyReportedOnRSOrGSOftheBorrowerIn24MonthsObj.fx_count))
                                                                    borrowerDelinquencyReportObj.fx_count__c =   borrowerDelinquencyReportedOnRSOrGSOftheBorrowerIn24MonthsObj.fx_count;
                                                                If(!Utility.ISStringBlankorNull(borrowerDelinquencyReportedOnRSOrGSOftheBorrowerIn24MonthsObj.fx_outstanding))
                                                                    borrowerDelinquencyReportObj.fx_outstanding__c   =   borrowerDelinquencyReportedOnRSOrGSOftheBorrowerIn24MonthsObj.fx_outstanding;
                                                                
                                                                borrowerDelinquencyReportObj.Tu_Credit_Report__r = new ints__TransUnion_Credit_Report__c(External_Id__c = TranExternalId);
                                                                listBorrowerDelinquencyReport.add(borrowerDelinquencyReportObj);
                                                            }
                                                        }
                                                    }
                                                }
                                                
                                            }
                                        }
                                        // RankSec   
                                        CommercialPRResponse.RankSec rankSecObj = productSecObj.rankSec;
                                        If(rankSecObj != null) {
                                            //RankVec
                                            List < CommercialPRResponse.RankVec > listRankVec = rankSecObj.rankVec;
                                            
                                            If(listRankVec != null) {
                                                
                                                for (CommercialPRResponse.RankVec rankVecObj: listRankVec) {
                                                    RankVec__c rankVecObject = new RankVec__c();
                                                    If(rankVecObj != null) {
                                                        If(!Utility.ISStringBlankorNull(rankVecObj.rankName))
                                                            rankVecObject.Rank_Name__c = rankVecObj.rankName;
                                                        If(!Utility.ISStringBlankorNull(rankVecObj.rankValue))
                                                            rankVecObject.Rank_Value__c = rankVecObj.rankValue;
                                                        If(!Utility.ISStringBlankorNull(rankVecObj.exclusionReason))
                                                            rankVecObject.Exclusion_Reason__c = rankVecObj.exclusionReason;
                                                        
                                                        rankVecObject.Tu_Credit_Report__r = new ints__TransUnion_Credit_Report__c(External_Id__c = TranExternalId);
                                                        listRankVecObj.add(rankVecObject);
                                                    }
                                                }
                                                
                                            }
                                            
                                        }
                                        //CreditProfileSummarySec               
                                        CommercialPRResponse.CreditProfileSummarySec creditProfileSummarySecObj = productSecObj.creditProfileSummarySec;
                                        If(creditProfileSummarySecObj != null) {
                                            //YourInstitution_Z
                                            CommercialPRResponse.YourInstitution_Z yourInstitutionObj = creditProfileSummarySecObj.yourInstitution;
                                            If(yourInstitutionObj != null) {
                                                //Credit Profile
                                                Credit_Profile__c creditProfileObj = new Credit_Profile__c();
                                                creditProfileObj.Type__c = 'Your Institution';
                                                If(!Utility.ISStringBlankorNull(yourInstitutionObj.totalLenders))
                                                    creditProfileObj.Total_Lender__c = Integer.valueOf(yourInstitutionObj.totalLenders);
                                                If(!Utility.ISStringBlankorNull(yourInstitutionObj.openCF))
                                                    creditProfileObj.Open_CF__c = Integer.valueOf(yourInstitutionObj.openCF);
                                                If(!Utility.ISStringBlankorNull(yourInstitutionObj.latestCFOpenedDate))
                                                    creditProfileObj.Latest_Opened_CF_Date__c = yourInstitutionObj.latestCFOpenedDate;
                                                
                                                //TotalCF
                                                CommercialPRResponse.TotalCF totalCFObj = yourInstitutionObj.totalCF;
                                                If(totalCFObj != null) {
                                                    creditProfileObj = CommercialPRUtility.getTotalCF(totalCFObj, creditProfileObj);
                                                }
                                                //TotalCF
                                                CommercialPRResponse.TotalCF delinquentCFObj = yourInstitutionObj.delinquentCF;
                                                If(delinquentCFObj != null) {
                                                    creditProfileObj = CommercialPRUtility.getDelinquentCF(delinquentCFObj, creditProfileObj);
                                                }
                                                //TotalOutstanding
                                                CommercialPRResponse.TotalCF totalOutstandingObj = yourInstitutionObj.totalOutstanding;
                                                If(totalOutstandingObj != null) {
                                                    creditProfileObj = CommercialPRUtility.getTotalCF(totalOutstandingObj, creditProfileObj);
                                                }
                                                //TotalOutstanding
                                                CommercialPRResponse.TotalCF delinquentOutstandingObj = yourInstitutionObj.delinquentOutstanding;
                                                If(delinquentOutstandingObj != null) {
                                                    creditProfileObj = CommercialPRUtility.getTotalCF(delinquentOutstandingObj, creditProfileObj);
                                                }
                                                
                                                creditProfileObj.TuCredit_Report__r = new ints__TransUnion_Credit_Report__c(External_Id__c = TranExternalId);
                                                listcreditProfile.add(creditProfileObj);
                                                
                                            }
                                            //OutsideInstitution
                                            CommercialPRResponse.OutsideInstitution outsideInstitutionObj = creditProfileSummarySecObj.outsideInstitution;
                                            If(outsideInstitutionObj != null) {
                                                
                                                //OtherPublicSectorBanks
                                                CommercialPRResponse.YourInstitution_Z otherPublicSectorBanksObj = outsideInstitutionObj.otherPublicSectorBanks;
                                                
                                                If(otherPublicSectorBanksObj != null) {
                                                    Credit_Profile__c creditProfileObj = new Credit_Profile__c();
                                                    creditProfileObj.Type__c = 'Outside Institution';
                                                    creditProfileObj.Sub_Type__c = 'Other Public Sector Banks';
                                                    If(!Utility.ISStringBlankorNull(otherPublicSectorBanksObj.message))
                                                        creditProfileObj.Message__c = otherPublicSectorBanksObj.message;
                                                    If(!Utility.ISStringBlankorNull(otherPublicSectorBanksObj.totalLenders))
                                                        creditProfileObj.Total_Lender__c = Integer.valueOf(otherPublicSectorBanksObj.totalLenders);
                                                    If(!Utility.ISStringBlankorNull(otherPublicSectorBanksObj.openCF))
                                                        creditProfileObj.Open_CF__c = Integer.valueOf(otherPublicSectorBanksObj.openCF);
                                                    //TotalCF
                                                    creditProfileObj = CommercialPRUtility.getTotalCF(otherPublicSectorBanksObj.totalCF, creditProfileObj);
                                                    creditProfileObj = CommercialPRUtility.getTotalCF(otherPublicSectorBanksObj.totalOutstanding, creditProfileObj);
                                                    creditProfileObj = CommercialPRUtility.getDelinquentCF(otherPublicSectorBanksObj.delinquentCF, creditProfileObj);
                                                    creditProfileObj = CommercialPRUtility.getTotalCF(otherPublicSectorBanksObj.delinquentOutstanding, creditProfileObj);
                                                    
                                                    creditProfileObj.TuCredit_Report__r = new ints__TransUnion_Credit_Report__c(External_Id__c = TranExternalId);
                                                    listcreditProfile.add(creditProfileObj);
                                                }
                                                //OtherPrivateForeignBanks
                                                CommercialPRResponse.YourInstitution_Z otherPrivateForeignBanksObj = outsideInstitutionObj.otherPrivateForeignBanks;
                                                If(otherPrivateForeignBanksObj != null) {
                                                    Credit_Profile__c creditProfileObj = new Credit_Profile__c();
                                                    creditProfileObj.Type__c = 'Outside Institution';
                                                    creditProfileObj.Sub_Type__c = 'Other Private Foreign Banks';
                                                    If(!Utility.ISStringBlankorNull(otherPrivateForeignBanksObj.message))
                                                        creditProfileObj.Message__c = otherPrivateForeignBanksObj.message;
                                                    If(!Utility.ISStringBlankorNull(otherPrivateForeignBanksObj.totalLenders))
                                                        creditProfileObj.Total_Lender__c = Integer.valueOf(otherPrivateForeignBanksObj.totalLenders);
                                                    If(!Utility.ISStringBlankorNull(otherPrivateForeignBanksObj.openCF))
                                                        creditProfileObj.Open_CF__c = Integer.valueOf(otherPrivateForeignBanksObj.openCF);
                                                    If(!Utility.ISStringBlankorNull(otherPrivateForeignBanksObj.latestCFOpenedDate))
                                                        creditProfileObj.Latest_Opened_CF_Date__c = otherPrivateForeignBanksObj.latestCFOpenedDate;
                                                    //TotalCF
                                                    creditProfileObj = CommercialPRUtility.getTotalCF(otherPrivateForeignBanksObj.totalCF, creditProfileObj);
                                                    creditProfileObj = CommercialPRUtility.getTotalCF(otherPrivateForeignBanksObj.totalOutstanding, creditProfileObj);
                                                    creditProfileObj = CommercialPRUtility.getDelinquentCF(otherPrivateForeignBanksObj.delinquentCF, creditProfileObj);
                                                    creditProfileObj = CommercialPRUtility.getTotalCF(otherPrivateForeignBanksObj.delinquentOutstanding, creditProfileObj);
                                                    
                                                    creditProfileObj.TuCredit_Report__r = new ints__TransUnion_Credit_Report__c(External_Id__c = TranExternalId);
                                                    listcreditProfile.add(creditProfileObj);
                                                }
                                                //NBFC_Others
                                                CommercialPRResponse.YourInstitution_Z nBFC_OthersObj = outsideInstitutionObj.nBFC_Others;
                                                If(nBFC_OthersObj != null) {
                                                    Credit_Profile__c creditProfileObj = new Credit_Profile__c();
                                                    creditProfileObj.Type__c = 'Outside Institution';
                                                    creditProfileObj.Sub_Type__c = 'NBFC Others';
                                                    If(!Utility.ISStringBlankorNull(nBFC_OthersObj.totalLenders))
                                                        creditProfileObj.Total_Lender__c = Integer.valueOf(nBFC_OthersObj.totalLenders);
                                                    If(!Utility.ISStringBlankorNull(nBFC_OthersObj.openCF))
                                                        creditProfileObj.Open_CF__c = Integer.valueOf(nBFC_OthersObj.openCF);
                                                    If(!Utility.ISStringBlankorNull(nBFC_OthersObj.latestCFOpenedDate))
                                                        creditProfileObj.Latest_Opened_CF_Date__c = nBFC_OthersObj.latestCFOpenedDate;
                                                    //TotalCF
                                                    creditProfileObj = CommercialPRUtility.getTotalCF(nBFC_OthersObj.totalCF, creditProfileObj);
                                                    creditProfileObj = CommercialPRUtility.getTotalCF(nBFC_OthersObj.totalOutstanding, creditProfileObj);
                                                    creditProfileObj = CommercialPRUtility.getDelinquentCF(nBFC_OthersObj.delinquentCF, creditProfileObj);
                                                    creditProfileObj = CommercialPRUtility.getTotalCF(nBFC_OthersObj.delinquentOutstanding, creditProfileObj);
                                                    
                                                    creditProfileObj.TuCredit_Report__r = new ints__TransUnion_Credit_Report__c(External_Id__c = TranExternalId);
                                                    listcreditProfile.add(creditProfileObj);
                                                }
                                                //YourInstitution_Z
                                                CommercialPRResponse.YourInstitution_Z OutsideTotalObj = outsideInstitutionObj.OutsideTotal;
                                                If(OutsideTotalObj != null) {
                                                    //CreditProfile
                                                    Credit_Profile__c creditProfileObj = new Credit_Profile__c();
                                                    creditProfileObj.Type__c = 'Outside Institution';
                                                    creditProfileObj.Sub_Type__c = 'Your Institution';
                                                    
                                                    If(!Utility.ISStringBlankorNull(yourInstitutionObj.totalLenders))
                                                        creditProfileObj.Total_Lender__c = Integer.valueOf(OutsideTotalObj.totalLenders);
                                                    If(!Utility.ISStringBlankorNull(yourInstitutionObj.openCF))
                                                        creditProfileObj.Open_CF__c = Integer.valueOf(yourInstitutionObj.openCF);
                                                    If(!Utility.ISStringBlankorNull(yourInstitutionObj.latestCFOpenedDate))
                                                        creditProfileObj.Latest_Opened_CF_Date__c = OutsideTotalObj.latestCFOpenedDate;
                                                    
                                                    //TotalCF
                                                    If(OutsideTotalObj.totalCF !=null){
                                                        CommercialPRResponse.TotalCF totalCFObj = OutsideTotalObj.totalCF;
                                                        If(totalCFObj != null) {
                                                            creditProfileObj = CommercialPRUtility.getTotalCF(totalCFObj, creditProfileObj);
                                                        }  
                                                    }
                                                    
                                                    //TotalCF
                                                    CommercialPRResponse.TotalCF delinquentCFObj = OutsideTotalObj.delinquentCF;
                                                    If(delinquentCFObj != null) {
                                                        creditProfileObj = CommercialPRUtility.getDelinquentCF(delinquentCFObj, creditProfileObj);
                                                    }
                                                    //TotalOutstanding
                                                    CommercialPRResponse.TotalCF totalOutstandingObj = OutsideTotalObj.totalOutstanding;
                                                    If(totalOutstandingObj != null) {
                                                        creditProfileObj = CommercialPRUtility.getTotalOutstanding(totalOutstandingObj, creditProfileObj);
                                                    }
                                                    //TotalOutstanding
                                                    If(OutsideTotalObj.delinquentOutstanding !=null){
                                                        CommercialPRResponse.TotalCF delinquentOutstandingObj = OutsideTotalObj.delinquentOutstanding;
                                                        If(delinquentOutstandingObj != null) {
                                                            creditProfileObj = CommercialPRUtility.getDelinquentOutstanding(delinquentOutstandingObj, creditProfileObj);
                                                        } 
                                                    }
                                                    
                                                    creditProfileObj.TuCredit_Report__r = new ints__TransUnion_Credit_Report__c(External_Id__c = TranExternalId);
                                                    listcreditProfile.add(creditProfileObj);
                                                }
                                                
                                            }
                                            //Total
                                            CommercialPRResponse.Total totalObj = creditProfileSummarySecObj.total;
                                            If(totalObj != null) {
                                                Credit_Profile__c creditProfileObj = new Credit_Profile__c();
                                                creditProfileObj.Type__c = 'Total';
                                                creditProfileObj = CommercialPRUtility.getTotal(totalObj, creditProfileObj);
                                                creditProfileObj.TuCredit_Report__r = new ints__TransUnion_Credit_Report__c(External_Id__c = TranExternalId);
                                                listcreditProfile.add(creditProfileObj);
                                            }
                                        }
                                        //EnquirySummarySec
                                        CommercialPRResponse.EnquirySummarySec enquirySummarySecObj = productSecObj.enquirySummarySec;
                                        If(enquirySummarySecObj != null) {
                                            //EnquiryYourInstitution
                                            CommercialPRResponse.EnquiryYourInstitution enquiryYourInstitutionObj = enquirySummarySecObj.enquiryYourInstitution;
                                            If(enquiryYourInstitutionObj != null) {
                                                Enquiry_Summary__c enquirySummaryObj = new Enquiry_Summary__c();
                                                enquirySummaryObj.Type__c = 'Your Institution';
                                                
                                                CommercialPRResponse.NoOfEnquiries noOfEnquiriesObj = enquiryYourInstitutionObj.noOfEnquiries;
                                                If(noOfEnquiriesObj != null) {
                                                    If(!Utility.ISStringBlankorNull(noOfEnquiriesObj.month1))
                                                        enquirySummaryObj.Month1__c = Integer.valueOf(noOfEnquiriesObj.month1);
                                                    If(!Utility.ISStringBlankorNull(noOfEnquiriesObj.month2to3))
                                                        enquirySummaryObj.Month2to3__c = Integer.valueOf(noOfEnquiriesObj.month2to3);
                                                    If(!Utility.ISStringBlankorNull(noOfEnquiriesObj.month4to6))
                                                        enquirySummaryObj.Month4to6__c = Integer.valueOf(noOfEnquiriesObj.month4to6);
                                                    If(!Utility.ISStringBlankorNull(noOfEnquiriesObj.month7to12))
                                                        enquirySummaryObj.Month7to12__c = Integer.valueOf(noOfEnquiriesObj.month7to12);
                                                    If(!Utility.ISStringBlankorNull(noOfEnquiriesObj.month12to24))
                                                        enquirySummaryObj.Month12to24__c = Integer.valueOf(noOfEnquiriesObj.month12to24);
                                                    If(!Utility.ISStringBlankorNull(noOfEnquiriesObj.greaterthan24Month))
                                                        enquirySummaryObj.Greater_than_24Month__c = Integer.valueOf(noOfEnquiriesObj.greaterthan24Month);
                                                    
                                                    If(!Utility.ISStringBlankorNull(noOfEnquiriesObj.total))
                                                        enquirySummaryObj.Total__c = Integer.valueOf(noOfEnquiriesObj.total);
                                                }
                                                enquirySummaryObj.Tu_Credit_Report__r = new ints__TransUnion_Credit_Report__c(External_Id__c = TranExternalId);
                                                listenquirySummary.add(enquirySummaryObj);
                                            }
                                            //EnquiryOutsideInstitution
                                            CommercialPRResponse.EnquiryYourInstitution enquiryOutsideInstitutionObj = enquirySummarySecObj.enquiryOutsideInstitution;
                                            If(enquiryOutsideInstitutionObj != null) {
                                                Enquiry_Summary__c enquirySummaryObj = new Enquiry_Summary__c();
                                                enquirySummaryObj.Type__c = 'Outside Institution';
                                                CommercialPRResponse.NoOfEnquiries noOfEnquiriesObj = enquiryOutsideInstitutionObj.noOfEnquiries;
                                                If(noOfEnquiriesObj != null) {
                                                    If(!Utility.ISStringBlankorNull(noOfEnquiriesObj.month1))
                                                        enquirySummaryObj.Month1__c = Integer.valueOf(noOfEnquiriesObj.month1);
                                                    If(!Utility.ISStringBlankorNull(noOfEnquiriesObj.month2to3))
                                                        enquirySummaryObj.Month2to3__c = Integer.valueOf(noOfEnquiriesObj.month2to3);
                                                    If(!Utility.ISStringBlankorNull(noOfEnquiriesObj.month4to6))
                                                        enquirySummaryObj.Month4to6__c = Integer.valueOf(noOfEnquiriesObj.month4to6);
                                                    If(!Utility.ISStringBlankorNull(noOfEnquiriesObj.month7to12))
                                                        enquirySummaryObj.Month7to12__c = Integer.valueOf(noOfEnquiriesObj.month7to12);
                                                    If(!Utility.ISStringBlankorNull(noOfEnquiriesObj.month12to24))
                                                        enquirySummaryObj.Month12to24__c = Integer.valueOf(noOfEnquiriesObj.month12to24);
                                                    If(!Utility.ISStringBlankorNull(noOfEnquiriesObj.greaterthan24Month))
                                                        enquirySummaryObj.Greater_than_24Month__c = Integer.valueOf(noOfEnquiriesObj.greaterthan24Month);
                                                    If(!Utility.ISStringBlankorNull(noOfEnquiriesObj.total))
                                                        enquirySummaryObj.Total__c = Integer.valueOf(noOfEnquiriesObj.total);
                                                    If(!Utility.ISStringBlankorNull(noOfEnquiriesObj.mostRecentDate))
                                                        enquirySummaryObj.Most_Recent__c = noOfEnquiriesObj.mostRecentDate;
                                                }
                                                enquirySummaryObj.Tu_Credit_Report__r = new ints__TransUnion_Credit_Report__c(External_Id__c = TranExternalId);
                                                listenquirySummary.add(enquirySummaryObj);
                                            }
                                            //EnquiryYourInstitution
                                            CommercialPRResponse.EnquiryYourInstitution enquiryTotalObj = enquirySummarySecObj.enquiryTotal;
                                            If(enquiryTotalObj != null) {
                                                Enquiry_Summary__c enquirySummaryObj = new Enquiry_Summary__c();
                                                enquirySummaryObj.Type__c = 'Total';
                                                CommercialPRResponse.NoOfEnquiries noOfEnquiriesObj = enquiryTotalObj.noOfEnquiries;
                                                If(noOfEnquiriesObj != null) {
                                                    If(!Utility.ISStringBlankorNull(noOfEnquiriesObj.month1))
                                                        enquirySummaryObj.Month1__c = Integer.valueOf(noOfEnquiriesObj.month1);
                                                    If(!Utility.ISStringBlankorNull(noOfEnquiriesObj.month2to3))
                                                        enquirySummaryObj.Month2to3__c = Integer.valueOf(noOfEnquiriesObj.month2to3);
                                                    If(!Utility.ISStringBlankorNull(noOfEnquiriesObj.month4to6))
                                                        enquirySummaryObj.Month4to6__c = Integer.valueOf(noOfEnquiriesObj.month4to6);
                                                    If(!Utility.ISStringBlankorNull(noOfEnquiriesObj.month7to12))
                                                        enquirySummaryObj.Month7to12__c = Integer.valueOf(noOfEnquiriesObj.month7to12);
                                                    If(!Utility.ISStringBlankorNull(noOfEnquiriesObj.month12to24))
                                                        enquirySummaryObj.Month12to24__c = Integer.valueOf(noOfEnquiriesObj.month12to24);
                                                    If(!Utility.ISStringBlankorNull(noOfEnquiriesObj.greaterthan24Month))
                                                        enquirySummaryObj.Greater_than_24Month__c = Integer.valueOf(noOfEnquiriesObj.greaterthan24Month);
                                                    
                                                    If(!Utility.ISStringBlankorNull(noOfEnquiriesObj.total))
                                                        enquirySummaryObj.Total__c = Integer.valueOf(noOfEnquiriesObj.total);
                                                }
                                                enquirySummaryObj.Tu_Credit_Report__r = new ints__TransUnion_Credit_Report__c(External_Id__c = TranExternalId);
                                                listenquirySummary.add(enquirySummaryObj);
                                            }
                                        }
                                        //DerogatoryInformationSec
                                        CommercialPRResponse.DerogatoryInformationSec derogatoryInformationSecObj = productSecObj.derogatoryInformationSec;
                                        If(derogatoryInformationSecObj != null) {
                                            Derogatory_Information__c derogatoryInformationObj = new Derogatory_Information__c();
                                            
                                            If(!Utility.ISStringBlankorNull(derogatoryInformationSecObj.message))
                                                derogatoryInformationObj.Message__c = derogatoryInformationSecObj.message;
                                            If(!Utility.ISStringBlankorNull(derogatoryInformationSecObj.messageOfBorrower))
                                                derogatoryInformationObj.Message_Of_Borrower__c = derogatoryInformationSecObj.messageOfBorrower;
                                            If(!Utility.ISStringBlankorNull(derogatoryInformationSecObj.messageOfBorrowerYourInstitution))
                                                derogatoryInformationObj.message_of_Borrower_Your_Institution__c = derogatoryInformationSecObj.messageOfBorrowerYourInstitution;
                                            If(!Utility.ISStringBlankorNull(derogatoryInformationSecObj.messageOfBorrowerOutsideInstitution))
                                                derogatoryInformationObj.Message_of_Borrower_Outside_Institution__c = derogatoryInformationSecObj.messageOfBorrowerOutsideInstitution;
                                            If(!Utility.ISStringBlankorNull(derogatoryInformationSecObj.messageOfRelatedParties))
                                                derogatoryInformationObj.Message_of_Related_Parties__c = derogatoryInformationSecObj.messageOfRelatedParties;
                                            If(!Utility.ISStringBlankorNull(derogatoryInformationSecObj.messageOfRelatedPartiesYourInstitution))
                                                derogatoryInformationObj.Message_ofRelatedParties_yourInstitution__c = derogatoryInformationSecObj.messageOfRelatedPartiesYourInstitution;
                                            If(!Utility.ISStringBlankorNull(derogatoryInformationSecObj.messageOfRelatedPartiesOutsideInstitution))
                                                derogatoryInformationObj.messageOfRelatedPartiesOutsideInstitutio__c = derogatoryInformationSecObj.messageOfRelatedPartiesOutsideInstitution;
                                            If(!Utility.ISStringBlankorNull(derogatoryInformationSecObj.messageOfGuarantedParties))
                                                derogatoryInformationObj.Message_of_Guaranted_Parties__c = derogatoryInformationSecObj.messageOfGuarantedParties;
                                            
                                            //DerogatoryInformationReportedOnGuarantedPartiesVec
                                            CommercialPRResponse.DerogatoryInformationReportedOnGuarantedPartiesVec     derogatoryInformationReportedOnGuarantedPartiesVecObj = derogatoryInformationSecObj.derogatoryInformationReportedOnGuarantedPartiesVec;
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
                                            CommercialPRResponse.DerogatoryInformationBorrower derogatoryInformationBorrowerObj = derogatoryInformationSecObj.derogatoryInformationBorrower;
                                            If(derogatoryInformationBorrowerObj != null) {
                                                CommercialPRResponse.YourInstitution_Y yourInstitutionObj = derogatoryInformationBorrowerObj.yourInstitution;
                                                If(yourInstitutionObj != null) {
                                                    Derogatory_Information__c derogatoryInformationObject = new Derogatory_Information__c();
                                                    derogatoryInformationObject = CommercialPRUtility.getYourInstitution_Y(yourInstitutionObj, derogatoryInformationObject);
                                                    derogatoryInformationObject.SubType__C = 'Your Institution';
                                                    derogatoryInformationObject.Type__c = 'Derogatory Information Borrower';
                                                    derogatoryInformationObject.Tu_Credit_Report__r = new ints__TransUnion_Credit_Report__c(External_Id__c = TranExternalId);
                                                    listderogatoryInformation.add(derogatoryInformationObject);
                                                }
                                                
                                                CommercialPRResponse.YourInstitution_Y outsideInstitutionObj = derogatoryInformationBorrowerObj.outsideInstitution;
                                                If(outsideInstitutionObj != null) {
                                                    Derogatory_Information__c derogatoryInformationObject = new Derogatory_Information__c();
                                                    derogatoryInformationObject.Type__c = 'Derogatory Information Borrower';
                                                    derogatoryInformationObject.SubType__c = 'Outside Institution';
                                                    derogatoryInformationObject = CommercialPRUtility.getYourInstitution_Y(outsideInstitutionObj, derogatoryInformationObject);
                                                    derogatoryInformationObject.Tu_Credit_Report__r = new ints__TransUnion_Credit_Report__c(External_Id__c = TranExternalId);
                                                    listderogatoryInformation.add(derogatoryInformationObject);
                                                }
                                                CommercialPRResponse.YourInstitution_Y totalObj = derogatoryInformationBorrowerObj.total;
                                                If(totalObj != null) {
                                                    Derogatory_Information__c derogatoryInformationObject = new Derogatory_Information__c();
                                                    derogatoryInformationObject.Type__c = 'Derogatory Information Borrower';
                                                    derogatoryInformationObject.SubType__c = 'Total';
                                                    derogatoryInformationObject = CommercialPRUtility.getYourInstitution_Y(totalObj, derogatoryInformationObject);
                                                    derogatoryInformationObject.Tu_Credit_Report__r = new ints__TransUnion_Credit_Report__c(External_Id__c = TranExternalId);
                                                    listderogatoryInformation.add(derogatoryInformationObject);
                                                }
                                                
                                            }
                                            //DerogatoryInformationBorrower
                                            CommercialPRResponse.DerogatoryInformationBorrower derogatoryInformationOnRelatedPartiesOrGuarantorsOfBorrowerSecObj = derogatoryInformationSecObj.derogatoryInformationOnRelatedPartiesOrGuarantorsOfBorrowerSec;
                                            If(derogatoryInformationOnRelatedPartiesOrGuarantorsOfBorrowerSecObj != null) {
                                                CommercialPRResponse.YourInstitution_Y yourInstitutionObj = derogatoryInformationOnRelatedPartiesOrGuarantorsOfBorrowerSecObj.yourInstitution;
                                                If(yourInstitutionObj != null) {
                                                    Derogatory_Information__c derogatoryInformationObject = new Derogatory_Information__c();
                                                    derogatoryInformationObject.SubType__c = 'Your Institution';
                                                    derogatoryInformationObject.Type__c = 'Derogatory Information on Related Parties or Guarantors of BorrowerSec';
                                                    derogatoryInformationObject = CommercialPRUtility.getYourInstitution_Y(yourInstitutionObj, derogatoryInformationObject);
                                                    derogatoryInformationObject.Tu_Credit_Report__r = new ints__TransUnion_Credit_Report__c(External_Id__c = TranExternalId);
                                                    listderogatoryInformation.add(derogatoryInformationObject);
                                                }
                                                
                                                CommercialPRResponse.YourInstitution_Y outsideInstitutionObj = derogatoryInformationOnRelatedPartiesOrGuarantorsOfBorrowerSecObj.outsideInstitution;
                                                If(outsideInstitutionObj != null) {
                                                    //transunionObj =   CommercialPRUtility.getYourInstitution_Y(outsideInstitutionObj,transunionObj);
                                                    Derogatory_Information__c derogatoryInformationObject = new Derogatory_Information__c();
                                                    derogatoryInformationObject.Type__c = 'Derogatory Information on Related Parties or Guarantors of BorrowerSec';
                                                    derogatoryInformationObject.SubType__c = 'Outside Institution';
                                                    derogatoryInformationObject = CommercialPRUtility.getYourInstitution_Y(outsideInstitutionObj, derogatoryInformationObject);
                                                    derogatoryInformationObject.Tu_Credit_Report__r = new ints__TransUnion_Credit_Report__c(External_Id__c = TranExternalId);
                                                    listderogatoryInformation.add(derogatoryInformationObject);
                                                }
                                                CommercialPRResponse.YourInstitution_Y totalObj = derogatoryInformationOnRelatedPartiesOrGuarantorsOfBorrowerSecObj.total;
                                                If(totalObj != null) {
                                                    //transunionObj =   CommercialPRUtility.getYourInstitution_Y(totalObj,transunionObj);
                                                    Derogatory_Information__c derogatoryInformationObject = new Derogatory_Information__c();
                                                    derogatoryInformationObject.Type__c = 'Derogatory Information on Related Parties or Guarantors of BorrowerSec';
                                                    derogatoryInformationObject.SubType__c = 'Total';
                                                    derogatoryInformationObject = CommercialPRUtility.getYourInstitution_Y(totalObj, derogatoryInformationObject);
                                                    derogatoryInformationObject.Tu_Credit_Report__r = new ints__TransUnion_Credit_Report__c(External_Id__c = TranExternalId);
                                                    listderogatoryInformation.add(derogatoryInformationObject);
                                                }
                                            }
                                            derogatoryInformationObj.Tu_Credit_Report__r = new ints__TransUnion_Credit_Report__c(External_Id__c = TranExternalId);
                                            listderogatoryInformationParent.add(derogatoryInformationObj);
                                        }
                                        //OustandingBalanceByCFAndAssetClasificationSec
                                        CommercialPRResponse.OustandingBalanceByCFAndAssetClasificationSec oustandingBalanceByCFAndAssetClasificationSecObj = productSecObj.oustandingBalanceByCFAndAssetClasificationSec;
                                        If(oustandingBalanceByCFAndAssetClasificationSecObj != null) {
                                            //YourInstitution_X
                                            CommercialPRResponse.YourInstitution_X yourInstitutionObj = oustandingBalanceByCFAndAssetClasificationSecObj.yourInstitution;
                                            If(yourInstitutionObj != null) {
                                                OustandingBalancebyCF__c oustandingBalancebyCFObj = new OustandingBalancebyCF__c();
                                                oustandingBalancebyCFObj.Type__c = 'Your Institution';
                                                oustandingBalancebyCFObj = CommercialPRUtility.getNonFunded(yourInstitutionObj.nonFunded, oustandingBalancebyCFObj);
                                                oustandingBalancebyCFObj = CommercialPRUtility.getNonFunded(yourInstitutionObj.workingCapital, oustandingBalancebyCFObj);
                                                oustandingBalancebyCFObj = CommercialPRUtility.getNonFunded(yourInstitutionObj.termLoan, oustandingBalancebyCFObj);
                                                oustandingBalancebyCFObj = CommercialPRUtility.getNonFunded(yourInstitutionObj.forex, oustandingBalancebyCFObj);
                                                oustandingBalancebyCFObj = CommercialPRUtility.getNonFunded(yourInstitutionObj.total, oustandingBalancebyCFObj);
                                                oustandingBalancebyCFObj.Tu_Credit_Report__r = new ints__TransUnion_Credit_Report__c(External_Id__c = TranExternalId);
                                                listOustandingBalancebyCF.add(oustandingBalancebyCFObj);
                                            }
                                            //YourInstitution_X
                                            CommercialPRResponse.YourInstitution_X outsideInstitutionObj = oustandingBalanceByCFAndAssetClasificationSecObj.outsideInstitution;
                                            If(outsideInstitutionObj != null) {
                                                OustandingBalancebyCF__c oustandingBalancebyCFObj = new OustandingBalancebyCF__c();
                                                oustandingBalancebyCFObj.Type__c = 'Outside Institution';
                                                oustandingBalancebyCFObj = CommercialPRUtility.getNonFunded(outsideInstitutionObj.nonFunded, oustandingBalancebyCFObj);
                                                oustandingBalancebyCFObj = CommercialPRUtility.getNonFunded(outsideInstitutionObj.workingCapital, oustandingBalancebyCFObj);
                                                oustandingBalancebyCFObj = CommercialPRUtility.getNonFunded(outsideInstitutionObj.termLoan, oustandingBalancebyCFObj);
                                                oustandingBalancebyCFObj = CommercialPRUtility.getNonFunded(outsideInstitutionObj.forex, oustandingBalancebyCFObj);
                                                oustandingBalancebyCFObj = CommercialPRUtility.getNonFunded(outsideInstitutionObj.total, oustandingBalancebyCFObj);
                                                oustandingBalancebyCFObj.Tu_Credit_Report__r = new ints__TransUnion_Credit_Report__c(External_Id__c = TranExternalId);
                                                listOustandingBalancebyCF.add(oustandingBalancebyCFObj);
                                            }
                                        }
                                        //LocationDetailsSec
                                        CommercialPRResponse.LocationDetailsSec locationDetailsSecObj = productSecObj.locationDetailsSec;
                                        If(locationDetailsSecObj != null) {
                                            //LocationInformationVec
                                            CommercialPRResponse.LocationInformationVec locationInformationVecObj = locationDetailsSecObj.locationInformationVec;
                                            If(locationInformationVecObj != null) {
                                                
                                                listlocationInformation = locationInformationVecObj.locationInformation;
                                                If(listlocationInformation != null) {
                                                    for (CommercialPRResponse.LocationInformation locationInformationObj: listlocationInformation) {
                                                        Location_Detail__c locationDetailsObj = new Location_Detail__c();
                                                        If(locationInformationObj != null) {
                                                            If(!Utility.ISStringBlankorNull(locationInformationObj.borrowerOfficeLocationType))
                                                                locationDetailsObj.Borrower_Office_Location_Type__c = locationInformationObj.borrowerOfficeLocationType;
                                                            If(!Utility.ISStringBlankorNull(locationInformationObj.address))
                                                                locationDetailsObj.Address__c = locationInformationObj.address;
                                                            If(!Utility.ISStringBlankorNull(locationInformationObj.firstReportedDate))
                                                                locationDetailsObj.First_Reported_Date__c = locationInformationObj.firstReportedDate;
                                                            If(!Utility.ISStringBlankorNull(locationInformationObj.lastReportedDate))
                                                                locationDetailsObj.Last_Reported_Date__c = locationInformationObj.lastReportedDate;
                                                            If(!Utility.ISStringBlankorNull(locationInformationObj.numberOfInstitutions))
                                                                locationDetailsObj.No_of_Institution__c = Integer.valueOf(locationInformationObj.numberOfInstitutions);
                                                            
                                                        }
                                                        If(!Utility.ISStringBlankorNull(locationDetailsSecObj.message))
                                                            locationDetailsObj.Message__c = locationDetailsSecObj.message;
                                                        If(!Utility.ISStringBlankorNull(locationDetailsSecObj.contactNumber))
                                                            locationDetailsObj.Contact_Number__c = locationDetailsSecObj.contactNumber.deleteWhitespace();
                                                        If(!Utility.ISStringBlankorNull(locationDetailsSecObj.faxNumber))
                                                            locationDetailsObj.Fax_Number__c = locationDetailsSecObj.faxNumber.deleteWhitespace();
                                                        
                                                        String recordtypeIDStr = recordtypeIdMap.get('Location_Details');
                                                        locationDetailsObj.recordtypeId     =   recordtypeIDStr;
                                                        //locationDetailsObj.recordtype.developerName = 'Location_Details';
                                                        locationDetailsObj.Tu_Credit_Report__r = new ints__TransUnion_Credit_Report__c(External_Id__c = TranExternalId);
                                                        listlocationDetail.add(locationDetailsObj);
                                                        
                                                    }
                                                }
                                                
                                            }
                                            
                                            
                                        }
                                        //List of RelationshipDetailsVec
                                        CommercialPRResponse.RelationshipDetailsVec relationshipDetailsVecObj = productSecObj.relationshipDetailsVec;
                                        If(relationshipDetailsVecObj != null) {
                                            listrelationshipDetails = relationshipDetailsVecObj.relationshipDetails;
                                            If(listrelationshipDetails != null) {
                                                for (CommercialPRResponse.RelationshipDetails relationshipDetailsObj: listrelationshipDetails) {
                                                    Relationship_Detail__c relationshipDetailObj = new Relationship_Detail__c();
                                                    String relationExternalId = String.valueOf(Math.random());
                                                    relationshipDetailObj.External_Id__c = relationExternalId;
                                                    If(relationshipDetailsObj != null) {
                                                        If(!Utility.ISStringBlankorNull(relationshipDetailsObj.relationshipHeader))
                                                            relationshipDetailObj.Relationship_Header__c = relationshipDetailsObj.relationshipHeader;
                                                        
                                                        //RelationshipInformation
                                                        CommercialPRResponse.RelationshipInformation relationshipInformationObj = relationshipDetailsObj.relationshipInformation;
                                                        If(relationshipInformationObj != null) {
                                                            If(!Utility.ISStringBlankorNull(relationshipInformationObj.name))
                                                                relationshipDetailObj.Name__c = relationshipInformationObj.name;
                                                            If(!Utility.ISStringBlankorNull(relationshipInformationObj.relatedType))
                                                                relationshipDetailObj.Related_Type__c = relationshipInformationObj.relatedType;
                                                            If(!Utility.ISStringBlankorNull(relationshipInformationObj.relationship))
                                                                relationshipDetailObj.Relationship__c = relationshipInformationObj.relationship;
                                                            If(!Utility.ISStringBlankorNull(relationshipInformationObj.percentageOfControl))
                                                                relationshipDetailObj.Percentage_of_Control__c = relationshipInformationObj.percentageOfControl;
                                                            If(!Utility.ISStringBlankorNull(relationshipInformationObj.dateOfBirth))
                                                                relationshipDetailObj.Date_of_Birth__c = relationshipInformationObj.dateOfBirth;
                                                            If(!Utility.ISStringBlankorNull(relationshipInformationObj.gender))
                                                                relationshipDetailObj.Gender__c = relationshipInformationObj.gender;
                                                            If(!Utility.ISStringBlankorNull(relationshipInformationObj.businessCategory))
                                                                relationshipDetailObj.Business_Category__c = relationshipInformationObj.businessCategory;
                                                            If(!Utility.ISStringBlankorNull(relationshipInformationObj.businessIndustryType))
                                                                relationshipDetailObj.Business_Industry_Type__c = relationshipInformationObj.businessIndustryType;
                                                        }
                                                        //BorrwerAddressContactDetails_Z
                                                        CommercialPRResponse.BorrwerAddressContactDetails borrwerAddressContactDetailsObj = relationshipDetailsObj.borrwerAddressContactDetails;
                                                        If(borrwerAddressContactDetailsObj != null) {
                                                            If(!Utility.ISStringBlankorNull(borrwerAddressContactDetailsObj.address))
                                                                relationshipDetailObj.Address__c = borrwerAddressContactDetailsObj.address;
                                                            If(!Utility.ISStringBlankorNull(borrwerAddressContactDetailsObj.faxNumber))
                                                                relationshipDetailObj.Fax_Number__c = borrwerAddressContactDetailsObj.faxNumber.deleteWhitespace();
                                                            If(!Utility.ISStringBlankorNull(borrwerAddressContactDetailsObj.mobileNumber))
                                                                relationshipDetailObj.Mobile_Number__c = borrwerAddressContactDetailsObj.mobileNumber;
                                                        }
                                                        //BorrwerIDDetailsVec_Z
                                                        CommercialPRResponse.BorrwerIDDetailsVec_Z borrwerIDDetailsVecObj = relationshipDetailsObj.borrwerIDDetailsVec;
                                                        If(borrwerIDDetailsVecObj != null) {
                                                            If(!Utility.ISStringBlankorNull(borrwerIDDetailsVecObj.lastReportedDate))
                                                                relationshipDetailObj.Last_Reported_Date__c = borrwerIDDetailsVecObj.lastReportedDate;
                                                            //BorrwerIDDetails_Z
                                                            List < CommercialPRResponse.BorrwerIDDetails_Z > listborrwerIDDetails = borrwerIDDetailsVecObj.borrwerIDDetails;
                                                            If(listborrwerIDDetails != null) {
                                                                for (CommercialPRResponse.BorrwerIDDetails_Z borrwerIDDetailsObj: listborrwerIDDetails) {
                                                                    TU_ID_s__c tuIDsObj = new TU_ID_s__c();
                                                                    
                                                                    If(borrwerIDDetailsObj != null) {
                                                                        
                                                                        If(!Utility.ISStringBlankorNull(borrwerIDDetailsObj.pan))
                                                                            tuIDsObj.Pan_Card_Number__c = borrwerIDDetailsObj.pan;
                                                                        If(!Utility.ISStringBlankorNull(borrwerIDDetailsObj.din))
                                                                            tuIDsObj.DIN_Number__c = borrwerIDDetailsObj.din;
                                                                        If(!Utility.ISStringBlankorNull(borrwerIDDetailsObj.voterID))
                                                                            tuIDsObj.Voter_ID_Number__c = borrwerIDDetailsObj.voterID;
                                                                        If(!Utility.ISStringBlankorNull(borrwerIDDetailsObj.passportNumber))
                                                                            tuIDsObj.Passport_Number__c = borrwerIDDetailsObj.passportNumber;
                                                                        If(!Utility.ISStringBlankorNull(borrwerIDDetailsObj.drivingLicenseNo))
                                                                            tuIDsObj.Driving_Licence_Number__c = borrwerIDDetailsObj.drivingLicenseNo;
                                                                        If(!Utility.ISStringBlankorNull(borrwerIDDetailsObj.uid))
                                                                            tuIDsObj.Aadhar_card_number__c = borrwerIDDetailsObj.uid;
                                                                        If(!Utility.ISStringBlankorNull(borrwerIDDetailsObj.registrationNumber))
                                                                            tuIDsObj.Registration_Number__c = borrwerIDDetailsObj.registrationNumber;
                                                                        If(!Utility.ISStringBlankorNull(borrwerIDDetailsObj.cin))
                                                                            tuIDsObj.Cin__c = borrwerIDDetailsObj.cin;
                                                                        If(!Utility.ISStringBlankorNull(borrwerIDDetailsObj.tin))
                                                                            tuIDsObj.Tin__c = borrwerIDDetailsObj.tin;
                                                                        If(!Utility.ISStringBlankorNull(borrwerIDDetailsObj.serviceTaxNumber))
                                                                            tuIDsObj.Service_Tax_Number__c = borrwerIDDetailsObj.serviceTaxNumber;
                                                                        If(!Utility.ISStringBlankorNull(borrwerIDDetailsObj.rationCard))
                                                                            tuIDsObj.Ration_Card_Number__c = borrwerIDDetailsObj.rationCard;
                                                                        
                                                                        String recordtypeIDStr = recordtypeIdMap.get('Relationship_ID_Details');
                                                                        tuIDsObj.recordtypeId   =   recordtypeIDStr;
                                                                        // tuIDsObj.recordtype.developerName = 'Relationship_ID_Details';
                                                                        tuIDsObj.Relationship_ID_Details__r = new Relationship_Detail__c(External_Id__c = relationExternalId);
                                                                        listTUIDs.add(tuIDsObj);
                                                                    }
                                                                    
                                                                }
                                                                
                                                                
                                                            }
                                                            
                                                        }
                                                        relationshipDetailObj.Tu_Credit_Report__r = new ints__TransUnion_Credit_Report__c(External_Id__c = TranExternalId);
                                                        listRelationshipDetail.add(relationshipDetailObj);
                                                    }
                                                }
                                            }
                                            
                                        }
                                        
                                        //CreditFacilityDetailsasBorrowerSecVec
                                        CommercialPRResponse.CreditFacilityDetailsasBorrowerSecVec creditFacilityDetailsasBorrowerSecVecObj = productSecObj.creditFacilityDetailsasBorrowerSecVec;
                                        If(creditFacilityDetailsasBorrowerSecVecObj != null) {
                                            
                                            If(!Utility.ISStringBlankorNull(creditFacilityDetailsasBorrowerSecVecObj.message))
                                                messageObj.Credit_Facility_Details_as_BorrowerSec__c = creditFacilityDetailsasBorrowerSecVecObj.message;
                                            
                                            // List of CreditFacilityDetailsasBorrowerSec
                                            listcreditFacilityDetailsasBorrowerSec = creditFacilityDetailsasBorrowerSecVecObj.creditFacilityDetailsasBorrowerSec;
                                            If(listcreditFacilityDetailsasBorrowerSec != null && listcreditFacilityDetailsasBorrowerSec.size() > 0) {
                                                
                                                for (CommercialPRResponse.CreditFacilityDetailsasBorrowerSec creditFacilityDetailsasBorrowerSecObj: listcreditFacilityDetailsasBorrowerSec) {
                                                    Credit_Facility_Detail__c creditFacilityObj = new Credit_Facility_Detail__c();
                                                    String ExternalId = String.valueOf(Math.random());
                                                    
                                                    creditFacilityObj.External_Id__c = ExternalId;
                                                    If(creditFacilityDetailsasBorrowerSecObj != null) {
                                                        //CreditFacilityCurrentDetailsVec
                                                        CommercialPRResponse.CreditFacilityCurrentDetailsVec creditFacilityCurrentDetailsVecObj = creditFacilityDetailsasBorrowerSecObj.creditFacilityCurrentDetailsVec;
                                                        If(creditFacilityCurrentDetailsVecObj != null) {
                                                            //CreditFacilityCurrentDetails
                                                            CommercialPRResponse.CreditFacilityCurrentDetails  creditFacilityCurrentDetailsObj = creditFacilityCurrentDetailsVecObj.creditFacilityCurrentDetails;
                                                            //Credit_Facility_Detail__c creditFacilityObject = new Credit_Facility_Detail__c();
                                                            If(creditFacilityCurrentDetailsObj != null) {
                                                                
                                                                If(!Utility.ISStringBlankorNull(creditFacilityCurrentDetailsObj.derivative))
                                                                    creditFacilityObj.Derivative__c = Boolean.valueOf(creditFacilityCurrentDetailsObj.derivative);
                                                                If(!Utility.ISStringBlankorNull(creditFacilityCurrentDetailsObj.accountNumber))
                                                                    creditFacilityObj.Account_Number__c = creditFacilityCurrentDetailsObj.accountNumber;
                                                                If(!Utility.ISStringBlankorNull(creditFacilityCurrentDetailsObj.cfSerialNumber))
                                                                    creditFacilityObj.CF_Serial_Number__c = creditFacilityCurrentDetailsObj.cfSerialNumber;
                                                                If(!Utility.ISStringBlankorNull(creditFacilityCurrentDetailsObj.cfType))
                                                                    creditFacilityObj.CF_Type__c = creditFacilityCurrentDetailsObj.cfType;
                                                                If(!Utility.ISStringBlankorNull(creditFacilityCurrentDetailsObj.cfMember))
                                                                    creditFacilityObj.CF_Member__c = creditFacilityCurrentDetailsObj.cfMember;
                                                                If(!Utility.ISStringBlankorNull(creditFacilityCurrentDetailsObj.assetClassificationDaysPastDueDpd))
                                                                    creditFacilityObj.Asset_Classification__c = creditFacilityCurrentDetailsObj.assetClassificationDaysPastDueDpd;
                                                                If(!Utility.ISStringBlankorNull(creditFacilityCurrentDetailsObj.status))
                                                                    creditFacilityObj.Status__c = creditFacilityCurrentDetailsObj.status;
                                                                If(!Utility.ISStringBlankorNull(creditFacilityCurrentDetailsObj.lastReportedDate))
                                                                    creditFacilityObj.Last_Reported_Date__c = creditFacilityCurrentDetailsObj.lastReportedDate;
                                                                //Amount
                                                                CommercialPRResponse.Amount amountObject = creditFacilityCurrentDetailsObj.amount;
                                                                If(amountObject != null) {
                                                                    If(!Utility.ISStringBlankorNull(amountObject.amount))
                                                                        creditFacilityObj.Amount__c = amountObject.amount;
                                                                    If(!Utility.ISStringBlankorNull(amountObject.sanctionedAmt))
                                                                        creditFacilityObj.Sanctioned_Amount__c = amountObject.sanctionedAmt;
                                                                    If(!Utility.ISStringBlankorNull(amountObject.drawingPower))
                                                                        creditFacilityObj.Drawing_Power__c = amountObject.drawingPower;
                                                                    If(!Utility.ISStringBlankorNull(amountObject.outstandingBalance))
                                                                        creditFacilityObj.Outstanding_Balance__c = amountObject.outstandingBalance;
                                                                    If(!Utility.ISStringBlankorNull(amountObject.overdue))
                                                                        creditFacilityObj.Over_Due__c = amountObject.overdue;
                                                                    If(!Utility.ISStringBlankorNull(amountObject.suitFiledAmt))
                                                                        creditFacilityObj.Suit_Filed_Amount__c = amountObject.suitFiledAmt;
                                                                    If(!Utility.ISStringBlankorNull(amountObject.markToMarket))
                                                                        creditFacilityObj.Mark_To_Market__c = amountObject.markToMarket;
                                                                    If(!Utility.ISStringBlankorNull(amountObject.highCredit))
                                                                        creditFacilityObj.High_Credit__c = amountObject.highCredit;
                                                                    If(!Utility.ISStringBlankorNull(amountObject.installmentAmt))
                                                                        creditFacilityObj.Installment_Amount__c = amountObject.installmentAmt;
                                                                    If(!Utility.ISStringBlankorNull(amountObject.lastRepaid))
                                                                        creditFacilityObj.Last_Repaid__c = amountObject.lastRepaid;
                                                                    If(!Utility.ISStringBlankorNull(amountObject.writtenOFF))
                                                                        creditFacilityObj.Written_OFF__c = amountObject.writtenOFF;
                                                                    If(!Utility.ISStringBlankorNull(amountObject.settled))
                                                                        creditFacilityObj.Settled__c = amountObject.settled;
                                                                    If(!Utility.ISStringBlankorNull(amountObject.naorc))
                                                                        creditFacilityObj.Naorc__c = amountObject.naorc;
                                                                    If(!Utility.ISStringBlankorNull(amountObject.notionalAmountOfContracts))
                                                                        creditFacilityObj.Notional_Amount_of_Contracts__c = amountObject.notionalAmountOfContracts;
                                                                    If(!Utility.ISStringBlankorNull(amountObject.contractsClassifiedAsNPA))
                                                                        creditFacilityObj.Contracts_Classified_as_NPA__c = amountObject.contractsClassifiedAsNPA;
                                                                }
                                                                //Dates
                                                                CommercialPRResponse.Dates datesObj = creditFacilityCurrentDetailsObj.dates;
                                                                If(datesObj != null) {
                                                                    If(!Utility.ISStringBlankorNull(datesObj.sanctionedDt))
                                                                        creditFacilityObj.Sanction_Date__c = datesObj.sanctionedDt;
                                                                }
                                                                //OtherDetails
                                                                CommercialPRResponse.OtherDetails otherDetailsObj = creditFacilityCurrentDetailsObj.otherDetails;
                                                                If(otherDetailsObj != null) {
                                                                    If(!Utility.ISStringBlankorNull(otherDetailsObj.repaymentFrequency))
                                                                        creditFacilityObj.Repayment_Frequency__c = otherDetailsObj.repaymentFrequency;
                                                                }
                                                            }
                                                        }
                                                        //List of CFHistoryforACOrDPDupto24MonthsVec
                                                        CommercialPRResponse.CFHistoryforACOrDPDupto24MonthsVec cFHistoryforACOrDPDupto24MonthsVecObj = creditFacilityDetailsasBorrowerSecObj.cFHistoryforACOrDPDupto24MonthsVec;
                                                        If(cFHistoryforACOrDPDupto24MonthsVecObj != null) {
                                                            listCFHistoryforACOrDPDupto24Months = cFHistoryforACOrDPDupto24MonthsVecObj.cFHistoryforACOrDPDupto24Months;
                                                            If(listCFHistoryforACOrDPDupto24Months != null && listCFHistoryforACOrDPDupto24Months.size() > 0) {
                                                                for (CommercialPRResponse.CFHistoryforACOrDPDupto24Months CFHistoryforACOrDPDupto24MonthsObj: listCFHistoryforACOrDPDupto24Months) {
                                                                    
                                                                    TU_CFHistory__c tuCFHistoryObject = new TU_CFHistory__c();
                                                                    If(CFHistoryforACOrDPDupto24MonthsObj != null) {
                                                                        If(!Utility.ISStringBlankorNull(CFHistoryforACOrDPDupto24MonthsObj.month))
                                                                            tuCFHistoryObject.Month__c = CFHistoryforACOrDPDupto24MonthsObj.month;
                                                                        If(!Utility.ISStringBlankorNull(CFHistoryforACOrDPDupto24MonthsObj.ACorDPD))
                                                                            tuCFHistoryObject.ACorDPD__c = CFHistoryforACOrDPDupto24MonthsObj.ACorDPD;
                                                                        If(!Utility.ISStringBlankorNull(CFHistoryforACOrDPDupto24MonthsObj.OSAmount))
                                                                            tuCFHistoryObject.OS_Amount__c = CFHistoryforACOrDPDupto24MonthsObj.OSAmount;
                                                                        
                                                                        tuCFHistoryObject.Credit_Facility_Detail__r = new Credit_Facility_Detail__c(External_Id__c = ExternalId);
                                                                        listTUCFHistory.add(tuCFHistoryObject);
                                                                        
                                                                    }
                                                                }
                                                            }
                                                        }
                                                        
                                                        //CreditFacilityOverdueDetailsVec
                                                        CommercialPRResponse.CreditFacilityOverdueDetailsVec creditFacilityOverdueDetailsVecObj = creditFacilityDetailsasBorrowerSecObj.creditFacilityOverdueDetailsVec;
                                                        If(creditFacilityOverdueDetailsVecObj != null) {
                                                            //CreditFacilityOverdueDetails
                                                            CommercialPRResponse.CreditFacilityOverdueDetails creditFacilityOverdueDetailsObj = creditFacilityOverdueDetailsVecObj.creditFacilityOverdueDetails;
                                                            If(creditFacilityOverdueDetailsObj != null) {
                                                                If(!Utility.ISStringBlankorNull(creditFacilityOverdueDetailsObj.DPD1to30amt))
                                                                    creditFacilityObj.DPD1_to_30amt__c = creditFacilityOverdueDetailsObj.DPD1to30amt;
                                                                If(!Utility.ISStringBlankorNull(creditFacilityOverdueDetailsObj.DPD31to60amt))
                                                                    creditFacilityObj.DPD31_to_60_amt__c = creditFacilityOverdueDetailsObj.DPD31to60amt;
                                                                If(!Utility.ISStringBlankorNull(creditFacilityOverdueDetailsObj.DPD61t090amt))
                                                                    creditFacilityObj.DPD61_to_90_amt__c = creditFacilityOverdueDetailsObj.DPD61t090amt;
                                                                If(!Utility.ISStringBlankorNull(creditFacilityOverdueDetailsObj.DPD91to180amt))
                                                                    creditFacilityObj.DPD91_to_180_amt__c = creditFacilityOverdueDetailsObj.DPD91to180amt;
                                                                If(!Utility.ISStringBlankorNull(creditFacilityOverdueDetailsObj.DPDabove180amt))
                                                                    creditFacilityObj.DPD_above_180_amt__c = creditFacilityOverdueDetailsObj.DPDabove180amt;
                                                            }
                                                        }
                                                        //ChequeDishounouredDuetoInsufficientFunds
                                                        CommercialPRResponse.ChequeDishounouredDuetoInsufficientFunds chequeDishounouredDuetoInsufficientFundsObj = creditFacilityDetailsasBorrowerSecObj.chequeDishounouredDuetoInsufficientFunds;
                                                        If(chequeDishounouredDuetoInsufficientFundsObj != null) {
                                                            If(!Utility.ISStringBlankorNull(chequeDishounouredDuetoInsufficientFundsObj.message))
                                                                creditFacilityObj.Cheque_Dishounoured_Due_Message__c = chequeDishounouredDuetoInsufficientFundsObj.message;
                                                            If(!Utility.ISStringBlankorNull(chequeDishounouredDuetoInsufficientFundsObj.CD3monthcount))
                                                                creditFacilityObj.CD_3month_count__c = chequeDishounouredDuetoInsufficientFundsObj.CD3monthcount;
                                                            If(!Utility.ISStringBlankorNull(chequeDishounouredDuetoInsufficientFundsObj.CD4to6monthcount))
                                                                creditFacilityObj.CD_4to6_month_count__c = chequeDishounouredDuetoInsufficientFundsObj.CD4to6monthcount;
                                                            If(!Utility.ISStringBlankorNull(chequeDishounouredDuetoInsufficientFundsObj.CD7to9monthcount))
                                                                creditFacilityObj.CD_7to9_month_count__c = chequeDishounouredDuetoInsufficientFundsObj.CD7to9monthcount;
                                                            If(!Utility.ISStringBlankorNull(chequeDishounouredDuetoInsufficientFundsObj.CD10to12monthcount))
                                                                creditFacilityObj.CD_10to12_month_count__c = chequeDishounouredDuetoInsufficientFundsObj.CD10to12monthcount;
                                                        }
                                                        
                                                        //CreditFacilitySecurityDetailsVec
                                                        CommercialPRResponse.CreditFacilitySecurityDetailsVec creditFacilitySecurityDetailsVecObj = creditFacilityDetailsasBorrowerSecObj.creditFacilitySecurityDetailsVec;
                                                        If(creditFacilitySecurityDetailsVecObj != null) {
                                                            If(!Utility.ISStringBlankorNull(creditFacilitySecurityDetailsVecObj.message))
                                                                creditFacilityObj.Credit_Facility_Security_Details_Message__c = creditFacilitySecurityDetailsVecObj.message;
                                                            If(creditFacilitySecurityDetailsVecObj.creditFacilitySecurityDetails !=null) {
                                                                List<CommercialPRResponse.CreditFacilitySecurityDetails> listCreditFacilitySecurityDetails  = creditFacilitySecurityDetailsVecObj.creditFacilitySecurityDetails;
                                                                for(CommercialPRResponse.CreditFacilitySecurityDetails creditFacilitySecurityDetailsObj     :   listCreditFacilitySecurityDetails) {
                                                                    Credit_Facility_Detail__c creditFacilityObject = new Credit_Facility_Detail__c();
                                                                    If(creditFacilitySecurityDetailsObj !=null) {
                                                                        If(!Utility.ISStringBlankorNull(creditFacilitySecurityDetailsObj.relatedType))
                                                                            creditFacilityObject.Related_Type__c = creditFacilitySecurityDetailsObj.relatedType;
                                                                        If(!Utility.ISStringBlankorNull(creditFacilitySecurityDetailsObj.classification))
                                                                            creditFacilityObject.Classification__c = creditFacilitySecurityDetailsObj.classification;
                                                                        If(!Utility.ISStringBlankorNull(creditFacilitySecurityDetailsObj.value))
                                                                            creditFacilityObject.Value__c = creditFacilitySecurityDetailsObj.value;
                                                                        If(!Utility.ISStringBlankorNull(creditFacilitySecurityDetailsObj.amount))
                                                                            creditFacilityObject.Amount__c = creditFacilitySecurityDetailsObj.amount;
                                                                        If(!Utility.ISStringBlankorNull(creditFacilitySecurityDetailsObj.validationDt))
                                                                            creditFacilityObject.Validation_Date__c = creditFacilitySecurityDetailsObj.validationDt;
                                                                        If(!Utility.ISStringBlankorNull(creditFacilitySecurityDetailsObj.lastReportedDt))
                                                                            creditFacilityObject.Last_Reported_Date__c = creditFacilitySecurityDetailsObj.lastReportedDt;
                                                                        
                                                                        creditFacilityObject.Tu_Credit_Report__r = new ints__TransUnion_Credit_Report__c(External_Id__c = TranExternalId);
                                                                        listCreditFacilityDetail.add(creditFacilityObject);
                                                                    }
                                                                } 
                                                            }
                                                        }
                                                        //CreditFacilityGuarantorDetailsVec
                                                        CommercialPRResponse.CreditFacilityGuarantorDetailsVec creditFacilityGuarantorDetailsVecObj = creditFacilityDetailsasBorrowerSecObj.creditFacilityGuarantorDetailsVec;
                                                        If(creditFacilityGuarantorDetailsVecObj != null) {
                                                            If(!Utility.ISStringBlankorNull(creditFacilityGuarantorDetailsVecObj.message))
                                                                creditFacilityObj.Credit_Facility_GuarantorDetails_Message__c = creditFacilityGuarantorDetailsVecObj.message;
                                                            //CreditFacilityGuarantorDetails
                                                            List < CommercialPRResponse.CreditFacilityGuarantorDetails > listcreditFacilityGuarantorDetails = creditFacilityGuarantorDetailsVecObj.creditFacilityGuarantorDetails;
                                                            If(listcreditFacilityGuarantorDetails != null) {
                                                                for (CommercialPRResponse.CreditFacilityGuarantorDetails creditFacilityGuarantorDetailsObj: listcreditFacilityGuarantorDetails) {
                                                                    Relationship_Detail__c relationshipDetailObj = new Relationship_Detail__c();
                                                                    String relationExternalId = String.valueOf(Math.random());
                                                                    relationshipDetailObj.External_Id__c = relationExternalId;
                                                                    If(creditFacilityGuarantorDetailsObj != null) {
                                                                        //GuarantorDetails
                                                                        CommercialPRResponse.GuarantorDetails guarantorDetailsObj = creditFacilityGuarantorDetailsObj.guarantorDetails;
                                                                        If(guarantorDetailsObj != null) {
                                                                            If(!Utility.ISStringBlankorNull(guarantorDetailsObj.name))
                                                                                relationshipDetailObj.Name__c = guarantorDetailsObj.name;
                                                                            If(!Utility.ISStringBlankorNull(guarantorDetailsObj.relatedType))
                                                                                relationshipDetailObj.Related_Type__c = guarantorDetailsObj.relatedType;
                                                                            If(!Utility.ISStringBlankorNull(guarantorDetailsObj.businessCategory))
                                                                                relationshipDetailObj.Business_Category__c = guarantorDetailsObj.businessCategory;
                                                                            If(!Utility.ISStringBlankorNull(guarantorDetailsObj.businessIndustryType))
                                                                                relationshipDetailObj.Business_Industry_Type__c = guarantorDetailsObj.businessIndustryType;
                                                                        }
                                                                        //BorrwerAddressContactDetails
                                                                        CommercialPRResponse.BorrwerAddressContactDetails guarantorAddressContactDetailsObj = creditFacilityGuarantorDetailsObj.guarantorAddressContactDetails;
                                                                        If(guarantorAddressContactDetailsObj != null) {
                                                                            If(!Utility.ISStringBlankorNull(guarantorAddressContactDetailsObj.address))
                                                                                relationshipDetailObj.Address__c = guarantorAddressContactDetailsObj.address;
                                                                            If(!Utility.ISStringBlankorNull(guarantorAddressContactDetailsObj.telephoneNumber))
                                                                                relationshipDetailObj.Phone_Number__c = guarantorAddressContactDetailsObj.telephoneNumber;
                                                                            If(!Utility.ISStringBlankorNull(guarantorAddressContactDetailsObj.faxNumber))
                                                                                relationshipDetailObj.Fax_Number__c = guarantorAddressContactDetailsObj.faxNumber.deleteWhitespace();
                                                                            If(!Utility.ISStringBlankorNull(guarantorAddressContactDetailsObj.mobileNumber))
                                                                                relationshipDetailObj.Mobile_Number__c = guarantorAddressContactDetailsObj.mobileNumber;
                                                                        }
                                                                        //GuarantorDetailsBorrwerIDDetailsVec
                                                                        CommercialPRResponse.GuarantorDetailsBorrwerIDDetailsVec guarantorDetailsBorrwerIDDetailsVecObj = creditFacilityGuarantorDetailsObj.guarantorDetailsBorrwerIDDetailsVec;
                                                                        If(guarantorDetailsBorrwerIDDetailsVecObj != null) {
                                                                            If(!Utility.ISStringBlankorNull(guarantorDetailsBorrwerIDDetailsVecObj.lastReportedDate))
                                                                                relationshipDetailObj.Last_Reported_Date__c = guarantorDetailsBorrwerIDDetailsVecObj.lastReportedDate;
                                                                            //GuarantorIDDetails
                                                                            List < CommercialPRResponse.GuarantorIDDetails > listGuarantorIDDetails = guarantorDetailsBorrwerIDDetailsVecObj.guarantorIDDetails;
                                                                            If(listGuarantorIDDetails != null) {
                                                                                for (CommercialPRResponse.GuarantorIDDetails guarantorIDDetailsObj: listGuarantorIDDetails) {
                                                                                    TU_ID_s__c tuIDsObj = new TU_ID_s__c();
                                                                                    If(guarantorIDDetailsObj != null) {
                                                                                        If(!Utility.ISStringBlankorNull(guarantorIDDetailsObj.pan))
                                                                                            tuIDsObj.Pan_Card_Number__c = guarantorIDDetailsObj.pan;
                                                                                        If(!Utility.ISStringBlankorNull(guarantorIDDetailsObj.din))
                                                                                            tuIDsObj.DIN_Number__c = guarantorIDDetailsObj.din;
                                                                                        If(!Utility.ISStringBlankorNull(guarantorIDDetailsObj.voterID))
                                                                                            tuIDsObj.Voter_ID_Number__c = guarantorIDDetailsObj.voterID;
                                                                                        If(!Utility.ISStringBlankorNull(guarantorIDDetailsObj.passportNumber))
                                                                                            tuIDsObj.Passport_Number__c = guarantorIDDetailsObj.passportNumber;
                                                                                        If(!Utility.ISStringBlankorNull(guarantorIDDetailsObj.uid))
                                                                                            tuIDsObj.Aadhar_Card_Number__c = guarantorIDDetailsObj.uid;
                                                                                        If(!Utility.ISStringBlankorNull(guarantorIDDetailsObj.drivingLicenseNumber))
                                                                                            tuIDsObj.Driving_Licence_Number__c = guarantorIDDetailsObj.drivingLicenseNumber;
                                                                                        If(!Utility.ISStringBlankorNull(guarantorIDDetailsObj.rationCard))
                                                                                            tuIDsObj.Ration_Card_Number__c = guarantorIDDetailsObj.rationCard;
                                                                                        
                                                                                        String recordtypeIDStr = recordtypeIdMap.get('Relationship_ID_Details');
                                                                                        tuIDsObj.recordtypeId   =   recordtypeIDStr;
                                                                                        //tuIDsObj.recordtype.developerName = 'Relationship_ID_Details';
                                                                                        tuIDsObj.Relationship_ID_Details__r = new Relationship_Detail__c(External_Id__c = relationExternalId);
                                                                                        listTUIDs.add(tuIDsObj);
                                                                                        
                                                                                    }
                                                                                }
                                                                                
                                                                            }
                                                                            
                                                                        }
                                                                    }
                                                                    relationshipDetailObj.Tu_Credit_Report__r = new ints__TransUnion_Credit_Report__c(External_Id__c = TranExternalId);
                                                                    listRelationshipDetail.add(relationshipDetailObj);
                                                                }
                                                                
                                                            }
                                                            
                                                        }
                                                        
                                                    }
                                                    creditFacilityObj.Tu_Credit_Report__r = new ints__TransUnion_Credit_Report__c(External_Id__c = TranExternalId);
                                                    listCreditFacilityDetail.add(creditFacilityObj);
                                                    
                                                }
                                            }
                                        }
                                        //CreditFacilityDetailsasGuarantorVec
                                        CommercialPRResponse.CreditFacilityDetailsasGuarantorVec creditFacilityDetailsasGuarantorVecObj = productSecObj.creditFacilityDetailsasGuarantorVec;
                                        //TU_Message__c messageObj = new TU_Message__c();
                                        If(creditFacilityDetailsasGuarantorVecObj != null) {
                                            If(!Utility.ISStringBlankorNull(creditFacilityDetailsasGuarantorVecObj.message))
                                                messageObj.CreditFacility_Details_as_Guarantor__c = creditFacilityDetailsasGuarantorVecObj.message;
                                            
                                            //List of CreditFacilityDetailsasGuarantor
                                            If(creditFacilityDetailsasGuarantorVecObj.creditFacilityDetailsasGuarantor !=null){
                                                
                                                List<CommercialPRResponse.CreditFacilityDetailsasGuarantor> listCreditFacilityDetailAS = creditFacilityDetailsasGuarantorVecObj.creditFacilityDetailsasGuarantor;
                                                If(listCreditFacilityDetailAS !=null){
                                                    for(CommercialPRResponse.CreditFacilityDetailsasGuarantor   creditFacDetailObj      :   listCreditFacilityDetailAS){
                                                        If(creditFacDetailObj !=null){
                                                            
                                                            Credit_facility_Details_as_Guarantor__c creditFacilityDetailGuaObj = new Credit_facility_Details_as_Guarantor__c();
                                                            
                                                            String ExternalId = String.valueOf(Math.random());
                                                            
                                                            List<CommercialPRResponse.CreditFacilityCurrentDetails> listCreditFacDetObj =   creditFacDetailObj.creditFacilityCurrentDetails;
                                                            If(listCreditFacDetObj !=null){
                                                                for(CommercialPRResponse.CreditFacilityCurrentDetails   creditFacDetObj : listCreditFacDetObj) {
                                                                    If(creditFacDetObj !=null){
                                                                        Credit_Facility_Detail__c creditFacilityObj = new Credit_Facility_Detail__c();
                                                                        
                                                                        If(!Utility.ISStringBlankorNull(creditFacDetObj.derivative))
                                                                            creditFacilityObj.Derivative__c = Boolean.valueOf(creditFacDetObj.derivative);
                                                                        If(!Utility.ISStringBlankorNull(creditFacDetObj.accountNumber))
                                                                            creditFacilityObj.Account_Number__c = creditFacDetObj.accountNumber;
                                                                        If(!Utility.ISStringBlankorNull(creditFacDetObj.cfSerialNumber))
                                                                            creditFacilityObj.CF_Serial_Number__c = creditFacDetObj.cfSerialNumber;
                                                                        If(!Utility.ISStringBlankorNull(creditFacDetObj.cfType))
                                                                            creditFacilityObj.CF_Type__c = creditFacDetObj.cfType;
                                                                        If(!Utility.ISStringBlankorNull(creditFacDetObj.cfMember))
                                                                            creditFacilityObj.CF_Member__c = creditFacDetObj.cfMember;
                                                                        If(!Utility.ISStringBlankorNull(creditFacDetObj.assetClassificationDaysPastDueDpd))
                                                                            creditFacilityObj.Asset_Classification__c = creditFacDetObj.assetClassificationDaysPastDueDpd;
                                                                        If(!Utility.ISStringBlankorNull(creditFacDetObj.status))
                                                                            creditFacilityObj.Status__c = creditFacDetObj.status;
                                                                        If(!Utility.ISStringBlankorNull(creditFacDetObj.lastReportedDate))
                                                                            creditFacilityObj.Last_Reported_Date__c = creditFacDetObj.lastReportedDate;
                                                                        //Amount
                                                                        CommercialPRResponse.Amount amountObject = creditFacDetObj.amount;
                                                                        If(amountObject != null) {
                                                                            If(!Utility.ISStringBlankorNull(amountObject.amount))
                                                                                creditFacilityObj.Amount__c = amountObject.amount;
                                                                            If(!Utility.ISStringBlankorNull(amountObject.sanctionedAmt))
                                                                                creditFacilityObj.Sanctioned_Amount__c = amountObject.sanctionedAmt;
                                                                            If(!Utility.ISStringBlankorNull(amountObject.drawingPower))
                                                                                creditFacilityObj.Drawing_Power__c = amountObject.drawingPower;
                                                                            If(!Utility.ISStringBlankorNull(amountObject.outstandingBalance))
                                                                                creditFacilityObj.Outstanding_Balance__c = amountObject.outstandingBalance;
                                                                            If(!Utility.ISStringBlankorNull(amountObject.overdue))
                                                                                creditFacilityObj.Over_Due__c = amountObject.overdue;
                                                                            If(!Utility.ISStringBlankorNull(amountObject.suitFiledAmt))
                                                                                creditFacilityObj.Suit_Filed_Amount__c = amountObject.suitFiledAmt;
                                                                            If(!Utility.ISStringBlankorNull(amountObject.markToMarket))
                                                                                creditFacilityObj.Mark_To_Market__c = amountObject.markToMarket;
                                                                            If(!Utility.ISStringBlankorNull(amountObject.highCredit))
                                                                                creditFacilityObj.High_Credit__c = amountObject.highCredit;
                                                                            If(!Utility.ISStringBlankorNull(amountObject.installmentAmt))
                                                                                creditFacilityObj.Installment_Amount__c = amountObject.installmentAmt;
                                                                            If(!Utility.ISStringBlankorNull(amountObject.lastRepaid))
                                                                                creditFacilityObj.Last_Repaid__c = amountObject.lastRepaid;
                                                                            If(!Utility.ISStringBlankorNull(amountObject.writtenOFF))
                                                                                creditFacilityObj.Written_OFF__c = amountObject.writtenOFF;
                                                                            If(!Utility.ISStringBlankorNull(amountObject.settled))
                                                                                creditFacilityObj.Settled__c = amountObject.settled;
                                                                            If(!Utility.ISStringBlankorNull(amountObject.naorc))
                                                                                creditFacilityObj.Naorc__c = amountObject.naorc;
                                                                            If(!Utility.ISStringBlankorNull(amountObject.notionalAmountOfContracts))
                                                                                creditFacilityObj.Notional_Amount_of_Contracts__c = amountObject.notionalAmountOfContracts;
                                                                            If(!Utility.ISStringBlankorNull(amountObject.contractsClassifiedAsNPA))
                                                                                creditFacilityObj.Contracts_Classified_as_NPA__c = amountObject.contractsClassifiedAsNPA;
                                                                        }
                                                                        //Dates
                                                                        CommercialPRResponse.Dates datesObj = creditFacDetObj.dates;
                                                                        If(datesObj != null) {
                                                                            If(!Utility.ISStringBlankorNull(datesObj.sanctionedDt))
                                                                                creditFacilityObj.Sanction_Date__c = datesObj.sanctionedDt;
                                                                        }
                                                                        //OtherDetails
                                                                        CommercialPRResponse.OtherDetails otherDetailsObj = creditFacDetObj.otherDetails;
                                                                        If(otherDetailsObj != null) {
                                                                            If(!Utility.ISStringBlankorNull(otherDetailsObj.repaymentFrequency))
                                                                                creditFacilityObj.Repayment_Frequency__c = otherDetailsObj.repaymentFrequency;
                                                                        }
                                                                        creditFacilityObj.Credit_Facility_Details_Guarantor__r = new Credit_facility_Details_as_Guarantor__c(External_Id__c = ExternalId);
                                                                        listCreditFacilityDetail.add(creditFacilityObj); 
                                                                    }
                                                                    
                                                                }
                                                            }
                                                            CommercialPRResponse.BorrwerInfo  borrwerInfoObj  =   creditFacDetailObj.borrwerInfo; 
                                                            If(borrwerInfoObj !=null){
                                                                //BorrwerDetails
                                                                CommercialPRResponse.BorrwerDetails borrwerDetailsObj = borrwerInfoObj.borrwerDetails;
                                                                If(borrwerDetailsObj != null) {
                                                                    If(!Utility.ISStringBlankorNull(borrwerDetailsObj.name))
                                                                        creditFacilityDetailGuaObj.Borrower_Name__c = borrwerDetailsObj.name;
                                                                    If(!Utility.ISStringBlankorNull(borrwerDetailsObj.borrowersLegalConstitution))
                                                                        creditFacilityDetailGuaObj.Borrowers_Legal_Constitution__c = borrwerDetailsObj.borrowersLegalConstitution;
                                                                    If(!Utility.ISStringBlankorNull(borrwerDetailsObj.businessCategory))
                                                                        creditFacilityDetailGuaObj.Business_Category__c = borrwerDetailsObj.businessCategory;
                                                                    If(!Utility.ISStringBlankorNull(borrwerDetailsObj.businessIndustryType))
                                                                        creditFacilityDetailGuaObj.Business_IndustryType__c = borrwerDetailsObj.businessIndustryType;
                                                                    If(!Utility.ISStringBlankorNull(borrwerDetailsObj.numberOfEmployees))
                                                                        creditFacilityDetailGuaObj.Number_Of_Employees__c = borrwerDetailsObj.numberOfEmployees;
                                                                    If(!Utility.ISStringBlankorNull(borrwerDetailsObj.dateOfIncorporation))
                                                                        creditFacilityDetailGuaObj.Date_Of_Incorporation__c = borrwerDetailsObj.dateOfIncorporation;
                                                                    If(!Utility.ISStringBlankorNull(borrwerDetailsObj.salesFigure))
                                                                        creditFacilityDetailGuaObj.Sales_Figure__c = borrwerDetailsObj.salesFigure;
                                                                    If(!Utility.ISStringBlankorNull(borrwerDetailsObj.year))
                                                                        creditFacilityDetailGuaObj.Year__c = borrwerDetailsObj.year;
                                                                    // classOfActivityVec
                                                                    If(borrwerDetailsObj.classOfActivityVec !=null){
                                                                        CommercialPRResponse.ClassOfActivityVec  classOfActivityVecObj          =   borrwerDetailsObj.classOfActivityVec;
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
                                                                CommercialPRResponse.BorrwerAddressContactDetailsVec borrwerAddressContactDetailsVecObj = borrwerInfoObj.borrwerAddressContactDetailsVec;
                                                                If(borrwerAddressContactDetailsVecObj !=null){
                                                                    List<CommercialPRResponse.BorrwerAddressContactDetails> listBorrwerAddressContactDetails = borrwerAddressContactDetailsVecObj.borrwerAddressContactDetails;
                                                                    If(listBorrwerAddressContactDetails !=null){
                                                                        for(CommercialPRResponse.BorrwerAddressContactDetails   borrwerAddressContactDetailsObj     :   listBorrwerAddressContactDetails){
                                                                            Guarantor_Address__c   guarantorAddressObj =   new Guarantor_Address__c();
                                                                            If(borrwerAddressContactDetailsObj != null) {
                                                                                If(!Utility.ISStringBlankorNull(borrwerAddressContactDetailsObj.address))
                                                                                    guarantorAddressObj.Address__c = borrwerAddressContactDetailsObj.address;
                                                                                If(!Utility.ISStringBlankorNull(borrwerAddressContactDetailsObj.faxNumber))
                                                                                    guarantorAddressObj.Fax_Number__c = borrwerAddressContactDetailsObj.faxNumber.deleteWhitespace();
                                                                                If(!Utility.ISStringBlankorNull(borrwerAddressContactDetailsObj.mobileNumber))
                                                                                    guarantorAddressObj.Mobile_Number__c = borrwerAddressContactDetailsObj.mobileNumber;
                                                                                If(!Utility.ISStringBlankorNull(borrwerAddressContactDetailsObj.telephoneNumber))
                                                                                    guarantorAddressObj.Phone_Number__c = borrwerAddressContactDetailsObj.telephoneNumber;
                                                                                
                                                                                guarantorAddressObj.credit_Facility_Details_Guarantor__r    = new Credit_facility_Details_as_Guarantor__c(External_Id__c = ExternalId);
                                                                                listGuarantorAddress.add(guarantorAddressObj);
                                                                                
                                                                            }   
                                                                        }
                                                                    }
                                                                }
                                                                //BorrwerIDDetailsVec
                                                                CommercialPRResponse.BorrwerIDDetailsVec borrwerIDDetailsVecObj = borrwerInfoObj.borrwerIDDetailsVec;
                                                                If(borrwerIDDetailsVecObj != null) {
                                                                    //BorrwerIDDetails
                                                                    List < CommercialPRResponse.BorrwerIDDetails > listBorrwerIDDetails = borrwerIDDetailsVecObj.borrwerIDDetails;
                                                                    If(listBorrwerIDDetails != null) {
                                                                        
                                                                        for (CommercialPRResponse.BorrwerIDDetails borrwerIDDetailsObj: listBorrwerIDDetails) {
                                                                            TU_ID_s__c tuIDsObj = new TU_ID_s__c();
                                                                            If(borrwerIDDetailsObj != null) {
                                                                                
                                                                                If(!Utility.ISStringBlankorNull(borrwerIDDetailsObj.pan))
                                                                                    tuIDsObj.Pan_Card_Number__c = borrwerIDDetailsObj.pan;
                                                                                If(!Utility.ISStringBlankorNull(borrwerIDDetailsObj.registrationNumber))
                                                                                    tuIDsObj.Registration_Number__c = borrwerIDDetailsObj.registrationNumber;
                                                                                If(!Utility.ISStringBlankorNull(borrwerIDDetailsObj.cin))
                                                                                    tuIDsObj.Cin__c = borrwerIDDetailsObj.cin;
                                                                                If(!Utility.ISStringBlankorNull(borrwerIDDetailsObj.tin))
                                                                                    tuIDsObj.Tin__c = borrwerIDDetailsObj.tin;
                                                                                If(!Utility.ISStringBlankorNull(borrwerIDDetailsObj.serviceTaxNumber))
                                                                                    tuIDsObj.Service_Tax_Number__c = borrwerIDDetailsObj.serviceTaxNumber;
                                                                                
                                                                                String recordtypeIDStr = recordtypeIdMap.get('Borrwer_ID_Details');
                                                                                tuIDsObj.recordtypeId   =   recordtypeIDStr;
                                                                                
                                                                                tuIDsObj.Credit_Facility_Details_Guarantor__r = new Credit_facility_Details_as_Guarantor__c(External_Id__c = ExternalId);
                                                                                listTUIDs.add(tuIDsObj);
                                                                                
                                                                            }
                                                                            
                                                                        }
                                                                        
                                                                    }
                                                                    
                                                                }
                                                                
                                                            }
                                                            If(creditFacilityDetailGuaObj !=null){
                                                                creditFacilityDetailGuaObj.External_Id__c = ExternalId;
                                                            }
                                                            creditFacilityDetailGuaObj.Tu_Credit_Report__r = new ints__TransUnion_Credit_Report__c(External_Id__c = TranExternalId);
                                                            listCreditfacilityDetailsGuarantor.add(creditFacilityDetailGuaObj);
                                                            
                                                        }
                                                        
                                                    }
                                                }
                                            }
                                        }
                                        //SuitFiledVec
                                        CommercialPRResponse.SuitFiledVec suitFiledVecObj = productSecObj.suitFiledVec;
                                        If(suitFiledVecObj != null) {
                                            If(!Utility.ISStringBlankorNull(suitFiledVecObj.message))
                                                messageObj.SuitFiled_Vec_Message__c = suitFiledVecObj.message;
                                            If(suitFiledVecObj.suitFilled !=null){
                                                List<CommercialPRResponse.SuitFilled_Z>     listSuitFilledObj   =   suitFiledVecObj.suitFilled;
                                                If(listSuitFilledObj !=null) {
                                                    for(CommercialPRResponse.SuitFilled_Z   suitFilledObj   :   listSuitFilledObj) {
                                                        SuitFilled__c   suitfilledObject    =   new SuitFilled__c();
                                                        If(!Utility.ISStringBlankorNull(suitFilledObj.suitFilledBy))
                                                            suitfilledObject.SuitFilled_By__c = suitFilledObj.suitFilledBy; 
                                                        If(!Utility.ISStringBlankorNull(suitFilledObj.suitStatus))
                                                            suitfilledObject.Suit_Status__c = suitFilledObj.suitStatus;
                                                        If(!Utility.ISStringBlankorNull(suitFilledObj.suitRefNumber))
                                                            suitfilledObject.Suit_Ref_Number__c = suitFilledObj.suitRefNumber;
                                                        If(!Utility.ISStringBlankorNull(suitFilledObj.suitAmt))
                                                            suitfilledObject.Suit_Amount__c = suitFilledObj.suitAmt;
                                                        If(!Utility.ISStringBlankorNull(suitFilledObj.dateSuit))
                                                            suitfilledObject.Date_Suit__c = suitFilledObj.dateSuit; 
                                                        
                                                        suitfilledObject.Tu_Credit_Report__r = new ints__TransUnion_Credit_Report__c(External_Id__c = TranExternalId);
                                                        listSuitFilled.add(suitfilledObject);
                                                    }
                                                }
                                            }
                                            
                                        }
                                        //CreditRatingSummaryVec
                                        CommercialPRResponse.CreditRatingSummaryVec creditRatingSummaryVecObj = productSecObj.creditRatingSummaryVec;
                                        If(creditRatingSummaryVecObj != null) {
                                            If(!Utility.ISStringBlankorNull(creditRatingSummaryVecObj.message))
                                                messageObj.Credit_Rating_Summary_Message__c = creditRatingSummaryVecObj.message;
                                            List<CommercialPRResponse.CreditRatingSummary> listCreditRatingSummaryObj   =   creditRatingSummaryVecObj.creditRatingSummary;
                                            If(listCreditRatingSummaryObj !=null) {
                                                for(CommercialPRResponse.CreditRatingSummary    creditRatingSummaryObj  :   listCreditRatingSummaryObj) {
                                                    If(creditRatingSummaryObj !=null){
                                                        List<CommercialPRResponse.CreditRatingSummaryDetailsVec>   listCreditRatingSummaryDetailsVec =  creditRatingSummaryObj.creditRatingSummaryDetailsVec;
                                                        If(listCreditRatingSummaryDetailsVec !=null){
                                                            for(CommercialPRResponse.CreditRatingSummaryDetailsVec  creditRatingSummaryDetailsVecObj    :   listCreditRatingSummaryDetailsVec) {
                                                                Credit_Rating_Summary__c    creditRatingSummaryObject   = new Credit_Rating_Summary__c();
                                                                
                                                                If(!Utility.ISStringBlankorNull(creditRatingSummaryObj.creditRatingAgency))
                                                                    creditRatingSummaryObject.creditRating_Agency__c = creditRatingSummaryObj.creditRatingAgency;
                                                                
                                                                If(creditRatingSummaryDetailsVecObj !=null) {
                                                                    If(!Utility.ISStringBlankorNull(creditRatingSummaryDetailsVecObj.creditRating))
                                                                        creditRatingSummaryObject.Credit_Rating__c = creditRatingSummaryDetailsVecObj.creditRating;
                                                                    
                                                                    If(!Utility.ISStringBlankorNull(creditRatingSummaryDetailsVecObj.ratingAsOn))
                                                                        creditRatingSummaryObject.RatingAs_On__c = creditRatingSummaryDetailsVecObj.ratingAsOn; 
                                                                    
                                                                    If(!Utility.ISStringBlankorNull(creditRatingSummaryDetailsVecObj.ratingExpiryDt))
                                                                        creditRatingSummaryObject.Rating_Expiry_Date__c = creditRatingSummaryDetailsVecObj.ratingExpiryDt;
                                                                    
                                                                    If(!Utility.ISStringBlankorNull(creditRatingSummaryDetailsVecObj.lastReportedDt))
                                                                        creditRatingSummaryObject.Last_Reported_Date__c = creditRatingSummaryDetailsVecObj.lastReportedDt;
                                                                }
                                                                creditRatingSummaryObject.Tu_Credit_Report__r = new ints__TransUnion_Credit_Report__c(External_Id__c = TranExternalId);
                                                                listCreditRatingSummary.add(creditRatingSummaryObject);
                                                            }
                                                        }
                                                    }
                                                }   
                                            }
                                        }
                                        
                                        //EnquiryDetailsInLast24MonthVec
                                        CommercialPRResponse.EnquiryDetailsInLast24MonthVec enquiryDetailsInLast24MonthVecObj = productSecObj.enquiryDetailsInLast24MonthVec;
                                        If(enquiryDetailsInLast24MonthVecObj != null) {
                                            If(!Utility.ISStringBlankorNull(enquiryDetailsInLast24MonthVecObj.message))
                                                messageObj.Enquiry_Details_In_Last_24Month_Message__c                                       =   enquiryDetailsInLast24MonthVecObj.message;
                                            //List of EnquiryDetailsInLast24Month
                                            listenquiryDetailsInLast24Month = enquiryDetailsInLast24MonthVecObj.enquiryDetailsInLast24Month;
                                            If(listenquiryDetailsInLast24Month != null && listenquiryDetailsInLast24Month.size() > 0) {
                                                for (CommercialPRResponse.EnquiryDetailsInLast24Month enquiryDetailsInLast24MonthObj: listenquiryDetailsInLast24Month) {
                                                    Enquiry_Summary__c enquirySummaryObj = new Enquiry_Summary__c();
                                                    If(enquiryDetailsInLast24MonthObj != null) {
                                                        If(!Utility.ISStringBlankorNull(enquiryDetailsInLast24MonthObj.creditLender))
                                                            enquirySummaryObj.Credit_Lender__c = enquiryDetailsInLast24MonthObj.creditLender;
                                                        If(!Utility.ISStringBlankorNull(enquiryDetailsInLast24MonthObj.enquiryDt))
                                                            enquirySummaryObj.Enquiry_Date__c = enquiryDetailsInLast24MonthObj.enquiryDt;
                                                        If(!Utility.ISStringBlankorNull(enquiryDetailsInLast24MonthObj.enquiryPurpose))
                                                            enquirySummaryObj.Enquiry_Purpose__c = enquiryDetailsInLast24MonthObj.enquiryPurpose;
                                                        If(!Utility.ISStringBlankorNull(enquiryDetailsInLast24MonthObj.enquiryAmt))
                                                            enquirySummaryObj.Enquiry_Amount__c = enquiryDetailsInLast24MonthObj.enquiryAmt;
                                                        enquirySummaryObj.Tu_Credit_Report__r = new ints__TransUnion_Credit_Report__c(External_Id__c = TranExternalId);
                                                        listenquirySummary.add(enquirySummaryObj);
                                                    }
                                                    
                                                }
                                            }
                                        }
                                        //CreditFacilitiesSummary   
                                        CommercialPRResponse.CreditFacilitiesSummary creditFacilitiesSummaryObj = productSecObj.creditFacilitiesSummary;
                                        If(creditFacilitiesSummaryObj != null) {
                                            //CountOfCreditFacilities
                                            CommercialPRResponse.CountOfCreditFacilities countOfCreditFacilitiesObj = creditFacilitiesSummaryObj.countOfCreditFacilities;
                                            If(countOfCreditFacilitiesObj != null) {
                                                //NoOfCreditFacilities
                                                CommercialPRResponse.NoOfCreditFacilities noOfCreditFacilitiesObj = countOfCreditFacilitiesObj.noOfCreditFacilities;
                                                If(noOfCreditFacilitiesObj != null) {
                                                    If(!Utility.ISStringBlankorNull(noOfCreditFacilitiesObj.yourBank))
                                                        transunionObj.Your_Bank__c = Integer.valueOf(noOfCreditFacilitiesObj.yourBank);
                                                    If(!Utility.ISStringBlankorNull(noOfCreditFacilitiesObj.others))
                                                        transunionObj.Others__c = Integer.valueOf(noOfCreditFacilitiesObj.others);
                                                    If(!Utility.ISStringBlankorNull(noOfCreditFacilitiesObj.total))
                                                        transunionObj.Total__c = Integer.valueOf(noOfCreditFacilitiesObj.total);
                                                }
                                                //NoOfCreditFacilities
                                                CommercialPRResponse.NoOfCreditFacilities noOfCreditGrantorsObj = countOfCreditFacilitiesObj.noOfCreditGrantors;
                                                If(noOfCreditGrantorsObj != null) {
                                                    If(!Utility.ISStringBlankorNull(noOfCreditGrantorsObj.yourBank))
                                                        transunionObj.CreditGrantors_Your_Bank__c = noOfCreditGrantorsObj.yourBank;
                                                    If(!Utility.ISStringBlankorNull(noOfCreditGrantorsObj.others))
                                                        transunionObj.CreditGrantors_Others__c = noOfCreditGrantorsObj.others;
                                                    If(!Utility.ISStringBlankorNull(noOfCreditGrantorsObj.total))
                                                        transunionObj.CreditGrantors_Total__c = noOfCreditGrantorsObj.total;
                                                }
                                            }
                                            CommercialPRResponse.SummaryOfCreditFacilitiesVec   summaryOfCreditFacilitiesVecObj =   creditFacilitiesSummaryObj.summaryOfCreditFacilitiesVec;
                                            If(summaryOfCreditFacilitiesVecObj !=null){
                                                If(summaryOfCreditFacilitiesVecObj.summaryOfCreditFacilitiesRec !=null){
                                                    List<CommercialPRResponse.SummaryOfCreditFacilitiesRec> listSummaryOfCreditFacilitiesRec =  summaryOfCreditFacilitiesVecObj.summaryOfCreditFacilitiesRec; 
                                                    If(listSummaryOfCreditFacilitiesRec !=null) {
                                                        for(CommercialPRResponse.SummaryOfCreditFacilitiesRec summaryOfCreditFacilitiesRecObj   :   listSummaryOfCreditFacilitiesRec){
                                                            Summary_Credit_Facility__c  summaryCreditFacilityObj    =   new Summary_Credit_Facility__c();
                                                            If(summaryOfCreditFacilitiesRecObj !=null){
                                                                If(!Utility.ISStringBlankorNull(summaryOfCreditFacilitiesRecObj.creditType))
                                                                    summaryCreditFacilityObj.Credit_Type__c = summaryOfCreditFacilitiesRecObj.creditType;
                                                                If(!Utility.ISStringBlankorNull(summaryOfCreditFacilitiesRecObj.yourBank))
                                                                    summaryCreditFacilityObj.Your_Bank__c = summaryOfCreditFacilitiesRecObj.yourBank;
                                                                If(!Utility.ISStringBlankorNull(summaryOfCreditFacilitiesRecObj.othersBank))
                                                                    summaryCreditFacilityObj.Other_Bank__c = summaryOfCreditFacilitiesRecObj.othersBank; 
                                                                
                                                                summaryCreditFacilityObj.Tu_Credit_Report__r = new ints__TransUnion_Credit_Report__c(External_Id__c = TranExternalId);
                                                                listSummaryCreditFacility.add(summaryCreditFacilityObj);
                                                            }    
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                        CommercialPRResponse.CreditFacilitiesDetailsVec creditFacilitiesDetailsVecObj   =  productSecObj.creditFacilitiesDetailsVec;    
                                        
                                        If(creditFacilitiesDetailsVecObj !=null){
                                            //Message
                                            If(!Utility.ISStringBlankorNull(creditFacilitiesDetailsVecObj.message))
                                                messageObj.Credit_Facility_Details_Message__c = creditFacilitiesDetailsVecObj.message;
                                            //Total
                                            List<CommercialPRResponse.CreditFacilitiesDetails> listCreditFacilitiesDetails   = creditFacilitiesDetailsVecObj.creditFacilitiesDetails;
                                            If(listCreditFacilitiesDetails !=null){
                                                for(CommercialPRResponse.CreditFacilitiesDetails    creditFacilitiesDetailsObj  :   listCreditFacilitiesDetails) {
                                                    Credit_Facility_Detail__c creditFacilityObj = new Credit_Facility_Detail__c();
                                                    If(creditFacilitiesDetailsObj !=null) {
                                                        If(!Utility.ISStringBlankorNull(creditFacilitiesDetailsObj.creditType))
                                                            creditFacilityObj.Credit_Type__c = creditFacilitiesDetailsObj.creditType;
                                                        If(!Utility.ISStringBlankorNull(creditFacilitiesDetailsObj.group_Z))
                                                            creditFacilityObj.Group__c = creditFacilitiesDetailsObj.group_Z;
                                                        If(!Utility.ISStringBlankorNull(creditFacilitiesDetailsObj.accountNo))
                                                            creditFacilityObj.Account_Number__c = creditFacilitiesDetailsObj.accountNo;
                                                        If(!Utility.ISStringBlankorNull(creditFacilitiesDetailsObj.reportedBy))
                                                            creditFacilityObj.Reported_By__c = creditFacilitiesDetailsObj.reportedBy;
                                                        If(!Utility.ISStringBlankorNull(creditFacilitiesDetailsObj.currentBalance))
                                                            creditFacilityObj.Current_Balance__c = creditFacilitiesDetailsObj.currentBalance;
                                                        If(!Utility.ISStringBlankorNull(creditFacilitiesDetailsObj.closedDate))
                                                            creditFacilityObj.Closed_Date__c = creditFacilitiesDetailsObj.closedDate;
                                                        If(!Utility.ISStringBlankorNull(creditFacilitiesDetailsObj.lastReported))
                                                            creditFacilityObj.Last_Reported__c = creditFacilitiesDetailsObj.lastReported;
                                                    }
                                                    creditFacilityObj.Tu_Credit_Report__r = new ints__TransUnion_Credit_Report__c(External_Id__c = TranExternalId);
                                                    listCreditFacilityDetail.add(creditFacilityObj);
                                                }
                                            }
                                        }
                                        
                                        //Message
                                        messageObj.TU_Credit_Report__r = new ints__TransUnion_Credit_Report__c(External_Id__c = TranExternalId);
                                        listMessage.add(messageObj);
                                    }
                                    catch(Exception ex){
                                        System.debug(ex.getMessage());
                                        Database.rollback(sp);
                                        res.status                  = Constants.WS_ERROR_STATUS;
                                        res.statusCode              = Constants.WS_ERROR_CODE;
                                        failedRes.cust_Id        = custId;
                                        failedRes.error_reason   = ex.getMessage(); 
                                        failedRes.error_table    = 'responseReport.productSec parsing error';
                                        res.Error_List.add(failedRes);
                                        continue;
                                    }
                                    
                                    
                                }
                            }
                        }
                        
                        
                        
                    }
                    Integer currentYear = Utility.getCurrentYear();
                    String cyString = String.valueOf(currentYear);
                    String currentFY = (currentYear-1)+'-'+Integer.valueOf(cyString.subString(cyString.length()-2,cyString.length())); 
                    transunionObj.Fiscal_year__c    = currentFY;    
                    listTransUnion.add(transunionObj);
                    
                    //Insertion of records
                    try{
                        If(listTransUnion.size() > 0)
                            insert listTransUnion;
                    }
                    catch(Exception ex){
                        System.debug(ex.getMessage());
                        Database.rollback(sp);
                        res.status                  = Constants.WS_ERROR_STATUS;
                        res.statusCode              = Constants.WS_ERROR_CODE;
                        failedRes.cust_Id        = custId;
                        failedRes.error_reason   = ex.getMessage(); 
                        failedRes.error_table    = 'TransUnion Credit Report Insertion Rrror';
                        res.Error_List.add(failedRes);
                        continue;
                    }
                    try{
                        If(listcreditProfile.size() > 0)
                            insert listcreditProfile;
                    }
                    catch(Exception ex){
                        System.debug(ex.getMessage());
                        Database.rollback(sp);
                        res.status                  = Constants.WS_ERROR_STATUS;
                        res.statusCode              = Constants.WS_ERROR_CODE;
                        failedRes.cust_Id        = custId;
                        failedRes.error_reason   = ex.getMessage(); 
                        failedRes.error_table    = 'Credit Profile Insertion Rrror';
                        res.Error_List.add(failedRes);
                        continue;
                    }
                    
                    try{
                        If(listenquirySummary.size() > 0)
                            insert listenquirySummary;
                    }
                    catch(Exception ex){
                        System.debug(ex.getMessage());
                        Database.rollback(sp);
                        res.status                  = Constants.WS_ERROR_STATUS;
                        res.statusCode              = Constants.WS_ERROR_CODE;
                        failedRes.cust_Id        = custId;
                        failedRes.error_reason   = ex.getMessage(); 
                        failedRes.error_table    = 'Enquiry Summary Insertion Rrror';
                        res.Error_List.add(failedRes);
                        continue;
                    }

                    try{
                        If(listderogatoryInformationParent.size() > 0)
                            insert listderogatoryInformationParent;
                    }
                    catch(Exception ex){
                        System.debug(ex.getMessage());
                        Database.rollback(sp);
                        res.status                  = Constants.WS_ERROR_STATUS;
                        res.statusCode              = Constants.WS_ERROR_CODE;
                        failedRes.cust_Id        = custId;
                        failedRes.error_reason   = ex.getMessage(); 
                        failedRes.error_table    = 'Derogatory Information Insertion Rrror';
                        res.Error_List.add(failedRes);
                        continue;
                    }

                    try{
                        If(listderogatoryInformation.size() > 0)
                            insert listderogatoryInformation;
                    }
                    catch(Exception ex){
                        System.debug(ex.getMessage());
                        Database.rollback(sp);
                        res.status                  = Constants.WS_ERROR_STATUS;
                        res.statusCode              = Constants.WS_ERROR_CODE;
                        failedRes.cust_Id        = custId;
                        failedRes.error_reason   = ex.getMessage(); 
                        failedRes.error_table    = 'Derogatory Information Insertion Rrror';
                        res.Error_List.add(failedRes);
                        continue;
                    }

                    try{
                        If(listOustandingBalancebyCF.size() > 0)
                            insert listOustandingBalancebyCF;
                    }
                    catch(Exception ex){
                        System.debug(ex.getMessage());
                        Database.rollback(sp);
                        res.status                  = Constants.WS_ERROR_STATUS;
                        res.statusCode              = Constants.WS_ERROR_CODE;
                        failedRes.cust_Id        = custId;
                        failedRes.error_reason   = ex.getMessage(); 
                        failedRes.error_table    = 'Oustanding Balance By CF Insertion Rrror';
                        res.Error_List.add(failedRes);
                        continue;
                    }

                    try{
                        If(listCreditfacilityDetailsGuarantor.size() > 0)
                            insert listCreditfacilityDetailsGuarantor;
                    }
                    catch(Exception ex){
                        System.debug(ex.getMessage());
                        Database.rollback(sp);
                        res.status                  = Constants.WS_ERROR_STATUS;
                        res.statusCode              = Constants.WS_ERROR_CODE;
                        failedRes.cust_Id        = custId;
                        failedRes.error_reason   = ex.getMessage(); 
                        failedRes.error_table    = 'Credit Facility Details As Guarantor Insertion Rrror';
                        res.Error_List.add(failedRes);
                        continue;
                    }

                    try{
                        If(listlocationDetail.size() > 0)
                            insert listlocationDetail;
                    }
                    catch(Exception ex){
                        System.debug(ex.getMessage());
                        Database.rollback(sp);
                        res.status                  = Constants.WS_ERROR_STATUS;
                        res.statusCode              = Constants.WS_ERROR_CODE;
                        failedRes.cust_Id        = custId;
                        failedRes.error_reason   = ex.getMessage(); 
                        failedRes.error_table    = 'Location Detail Insertion Rrror';
                        res.Error_List.add(failedRes);
                        continue;
                    }

                    try{
                        If(listRelationshipDetail.size() > 0)
                            insert listRelationshipDetail;
                    }
                    catch(Exception ex){
                        System.debug(ex.getMessage());
                        Database.rollback(sp);
                        res.status                  = Constants.WS_ERROR_STATUS;
                        res.statusCode              = Constants.WS_ERROR_CODE;
                        failedRes.cust_Id        = custId;
                        failedRes.error_reason   = ex.getMessage(); 
                        failedRes.error_table    = 'Relationship Detail Insertion Rrror';
                        res.Error_List.add(failedRes);
                        continue;
                    }

                    try{
                        If(listCreditFacilityDetail.size() > 0)
                            insert listCreditFacilityDetail;
                    }
                    catch(Exception ex){
                        System.debug(ex.getMessage());
                        Database.rollback(sp);
                        res.status                  = Constants.WS_ERROR_STATUS;
                        res.statusCode              = Constants.WS_ERROR_CODE;
                        failedRes.cust_Id        = custId;
                        failedRes.error_reason   = ex.getMessage(); 
                        failedRes.error_table    = 'Credit Facility Detail Insertion Rrror';
                        res.Error_List.add(failedRes);
                        continue;
                    }

                    try{
                        If(listTUIDs.size() > 0)
                            insert listTUIDs;
                    }
                    catch(Exception ex){
                        System.debug(ex.getMessage());
                        Database.rollback(sp);
                        res.status                  = Constants.WS_ERROR_STATUS;
                        res.statusCode              = Constants.WS_ERROR_CODE;
                        failedRes.cust_Id        = custId;
                        failedRes.error_reason   = ex.getMessage(); 
                        failedRes.error_table    = 'TU ID Insertion Rrror';
                        res.Error_List.add(failedRes);
                        continue;
                    }

                    try{
                        If(listRankVecObj.size() > 0)
                            insert listRankVecObj;
                    }
                    catch(Exception ex){
                        System.debug(ex.getMessage());
                        Database.rollback(sp);
                        res.status                  = Constants.WS_ERROR_STATUS;
                        res.statusCode              = Constants.WS_ERROR_CODE;
                        failedRes.cust_Id        = custId;
                        failedRes.error_reason   = ex.getMessage(); 
                        failedRes.error_table    = 'RankVec Insertion Rrror';
                        res.Error_List.add(failedRes);
                        continue;
                    }

                    try{
                        If(listMessage.size() > 0)
                            insert listMessage;
                    }
                    catch(Exception ex){
                        System.debug(ex.getMessage());
                        Database.rollback(sp);
                        res.status                  = Constants.WS_ERROR_STATUS;
                        res.statusCode              = Constants.WS_ERROR_CODE;
                        failedRes.cust_Id        = custId;
                        failedRes.error_reason   = ex.getMessage(); 
                        failedRes.error_table    = 'TU Message Insertion Rrror';
                        res.Error_List.add(failedRes);
                        continue;
                    }

                    try{
                        If(listGuarantorAddress.size()>0)
                            insert listGuarantorAddress; 
                    }
                    catch(Exception ex){
                        System.debug(ex.getMessage());
                        Database.rollback(sp);
                        res.status                  = Constants.WS_ERROR_STATUS;
                        res.statusCode              = Constants.WS_ERROR_CODE;
                        failedRes.cust_Id        = custId;
                        failedRes.error_reason   = ex.getMessage(); 
                        failedRes.error_table    = 'Guarantor Address Insertion Rrror';
                        res.Error_List.add(failedRes);
                        continue;
                    }

                    try{
                        If(listSuitFilled.size() > 0)
                            insert listSuitFilled;
                    }
                    catch(Exception ex){
                        System.debug(ex.getMessage());
                        Database.rollback(sp);
                        res.status                  = Constants.WS_ERROR_STATUS;
                        res.statusCode              = Constants.WS_ERROR_CODE;
                        failedRes.cust_Id        = custId;
                        failedRes.error_reason   = ex.getMessage(); 
                        failedRes.error_table    = 'Suit Filled Insertion Rrror';
                        res.Error_List.add(failedRes);
                        continue;
                    }

                    try{
                        If(listCreditRatingSummary.size()>0)
                            insert listCreditRatingSummary;
                    }
                    catch(Exception ex){
                        System.debug(ex.getMessage());
                        Database.rollback(sp);
                        res.status                  = Constants.WS_ERROR_STATUS;
                        res.statusCode              = Constants.WS_ERROR_CODE;
                        failedRes.cust_Id        = custId;
                        failedRes.error_reason   = ex.getMessage(); 
                        failedRes.error_table    = 'Credit Rating Summary Insertion Rrror';
                        res.Error_List.add(failedRes);
                        continue;
                    }

                    try{
                        If(listSummaryCreditFacility.size()>0)
                            insert listSummaryCreditFacility;
                    }
                    catch(Exception ex){
                        System.debug(ex.getMessage());
                        Database.rollback(sp);
                        res.status                  = Constants.WS_ERROR_STATUS;
                        res.statusCode              = Constants.WS_ERROR_CODE;
                        failedRes.cust_Id        = custId;
                        failedRes.error_reason   = ex.getMessage(); 
                        failedRes.error_table    = 'Summary Credit Facility Insertion Rrror';
                        res.Error_List.add(failedRes);
                        continue;
                    }

                    try{
                        If(listTUCFHistory.size() > 0)
                            insert listTUCFHistory;
                    }
                    catch(Exception ex){
                        System.debug(ex.getMessage());
                        Database.rollback(sp);
                        res.status                  = Constants.WS_ERROR_STATUS;
                        res.statusCode              = Constants.WS_ERROR_CODE;
                        failedRes.cust_Id        = custId;
                        failedRes.error_reason   = ex.getMessage(); 
                        failedRes.error_table    = 'TU CF History Insertion Rrror';
                        res.Error_List.add(failedRes);
                        continue;
                    }

                    try{
                        If(listBorrowerDelinquencyReport.size() > 0)
                            insert listBorrowerDelinquencyReport;
                    }
                    catch(Exception ex){
                        System.debug(ex.getMessage());
                        Database.rollback(sp);
                        res.status                  = Constants.WS_ERROR_STATUS;
                        res.statusCode              = Constants.WS_ERROR_CODE;
                        failedRes.cust_Id        = custId;
                        failedRes.error_reason   = ex.getMessage(); 
                        failedRes.error_table    = 'Borrower Delinquency Report Insertion Rrror';
                        res.Error_List.add(failedRes);
                        continue;
                    }
                    
                    List<genesis__Applications__c> appList = [select id,CommercialPR_Stage__c from genesis__Applications__c where RecordType.DeveloperName ='SME_Renewal' AND genesis__Account__r.CBS_Customer_ID__c IN :extIdList];
                    if(!appList.isEmpty()){
                        for(genesis__Applications__c app : appList){
                            app.CommercialPR_Stage__c = 'Completed';
                        }
                        ApplicationTriggerHandler.IsFirstRun = false;   
                        update appList;
                    } 
                    
                    res.status                  = Constants.WS_SUCCESS_STATUS;
                    res.statusCode              = Constants.WS_SUCCESS_CODE;
                    successRes.cust_Id          = custId;
                    successRes.sucess_message   = 'TU data Inserted';
                    res.Success_List.add(successRes);
                    
                }
            }
        }
        RETURN res;
    }
}