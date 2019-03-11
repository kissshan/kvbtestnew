/*
* Name    : ApplicantService
* Company : ET Marlabs
* Purpose : This class is used to Create applicant from App
* Author  : Venugopal N
-----------------------------------------------------------------------
   Version  Date         Author             Remarks                                                 
  =======   ==========   =============  ==================================
   V1.1    28-Sep-2018    Venu          Fetching and creating Applicant Service
  
*******************************************************************************************/
global class ApplicantService {
    
    
    public class borrowerDetail{
        public string Fname;
        public string Lname;
        public string Mname;
        public string POstreet;
        public string POcity;
        public string POstate;
        public string POcountry;  
        public string POpostalcode; 
        public string PMstreet;   
        public string PMcity;
        public string PMstate;
        public string PMcountry;  
        public string PMpostalcode;
        public string Gender;
        public string Bname;   
        public Date Pbirthdate;
        public string Nationality;
        public string NationalIdentificationCode;
        public string CustType;
        public string MariStatus;   
        public string PersonEmail;
        public string PersonMobile;
        public string CBScustID;
        public string AdhaarNumber;
        public string PanNumber;
        public string FatherName;
        public string HusbName;
        public string CBSaccountNumber1;
        public string Occupation;
        public string Customer_IC;
        public string Phone;
        public string Fax_no;
        public string Title;
        public string Caste; 
        public string Religion; 
        public boolean IsExistingCustomer;
        public string CustIDCreatedDate;	
        public string CBSaccountNumber2;
        public string CBSaccountNumber3;
        public string CBSaccountNumber4;
        public string CBSaccountNumber5;
        public string FullName;
        public boolean isAadharAvailable;
        public boolean isPanAvailabe;
        public string iskyc;  //V1.1
    }
    
    
    public static Account CreateAccount(borrowerDetail Bdetail){
        system.debug('Bdetail'+Bdetail);
        account acc= new account();
        acc.FirstName=Bdetail.Fname;
        acc.LastName=Bdetail.Lname;
        acc.MiddleName=Bdetail.Mname;
        acc.PersonOtherStreet =Bdetail.POstreet;
        acc.PersonOtherCity  =Bdetail.POcity;
        acc.PersonOtherState =Bdetail.POstate;
        acc.PersonOtherCountry =Bdetail.POcountry;
        acc.PersonOtherPostalCode =Bdetail.POpostalcode;
        acc.PersonMailingStreet =Bdetail.PMstreet;
        acc.PersonMailingCity =Bdetail.PMcity;
        acc.PersonMailingState=Bdetail.PMstate;
        acc.PersonMailingCountry =Bdetail.PMcountry;
        acc.PersonMailingPostalCode =Bdetail.PMpostalcode;
        acc.Gender__pc =Bdetail.Gender;
        acc.Branch_Name__c =Bdetail.Bname;
        acc.PersonBirthdate =Bdetail.Pbirthdate;
        acc.Nationality__pc =Bdetail.Nationality;
        acc.National_Identification_Code__c =Bdetail.NationalIdentificationCode;
        acc.Customer_Type__c =Bdetail.CustType;
        acc.Marital_Status__pc=Bdetail.MariStatus;
        acc.PersonEmail=Bdetail.PersonEmail;
        acc.PersonMobilePhone =Bdetail.PersonMobile;
        acc.CBS_Customer_ID__c =Bdetail.CBScustID;
        acc.Aadhaar_Number__pc =Bdetail.AdhaarNumber;
        acc.Pan_Number__c =Bdetail.PanNumber;
        acc.Father_Name__pc =Bdetail.FatherName;
        acc.Husband_Name__pc=Bdetail.HusbName;
        acc.Occupation__pc=Bdetail.Occupation;
        //acc.CBS_Account_No_1__c=Bdetail.CBSaccountNumber1;
        acc.Are_you_An_Existing_Customer__c=Bdetail.IsExistingCustomer;
        if(Bdetail.CustIDCreatedDate !=null && (!String.isBlank(Bdetail.CustIDCreatedDate) )){
        acc.Customer_ID_Creation_Date__c=Date.valueOf(Bdetail.CustIDCreatedDate) ;
        }
        acc.Phone=Bdetail.Phone;
        acc.Fax=Bdetail.Fax_no;
        acc.PersonTitle=Bdetail.Title;
        acc.Caste__pc=Bdetail.Caste;
        acc.Religion__c=Bdetail.Religion;
        acc.Customer_IC__c=Bdetail.Customer_IC;
        acc.Full_Name__c=Bdetail.FullName;
        acc.CBS_Account_No_2__c=Bdetail.CBSaccountNumber2;
        acc.CBS_Account_No_3__c=Bdetail.CBSaccountNumber3;
        acc.CBS_Account_No_4__c=Bdetail.CBSaccountNumber4;
        acc.CBS_Account_No_5__c=Bdetail.CBSaccountNumber5;
        acc.Is_Aadhaar_Card_Available__c = Bdetail.isAadharAvailable;
        acc.Is_PAN_card_available__c = Bdetail.isPanAvailabe;        
        
        // insert acc;
        return acc;
        
    }
    
}