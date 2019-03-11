@isTest
public class Test_ApplicantService {
    @isTest
    public static void methodCreateAccount(){
        ApplicantService.borrowerDetail borrDetail = new ApplicantService.borrowerDetail();
        borrDetail.AdhaarNumber = 'uhkjkjk' ;
        borrDetail.Bname = 'Tenyampet';
        borrDetail.Caste = 'sss';
        
        	 borrDetail.Fname		=  'Priti';
             borrDetail.Lname 		=  'Gupta ';
             borrDetail.Mname 		=  'Kumari';
             borrDetail.POstreet	=  'Kormangala';
             borrDetail.POcity		=  'Bangalore';
             borrDetail.POstate		=  'Karnataka';
             borrDetail.POcountry	=  'India';  
             borrDetail.POpostalcode=  '560037';
             borrDetail.PMstreet	=  'Park Street';   
             borrDetail.PMcity		=  'Chennai';
             borrDetail.PMstate		=  'Tamilnadu';
             borrDetail.PMcountry	=  'India';  
             borrDetail.PMpostalcode=  '542344';
             borrDetail.Gender		=  'M';
             borrDetail.Bname		=  'str12';   
             borrDetail.Pbirthdate	=  Date.today();
             borrDetail.Nationality	=  'Indian';
             borrDetail.NationalIdentificationCode=  '"Passport';
             borrDetail.CustType	=  'Str12';
             borrDetail.MariStatus	=  'Un';   
             borrDetail.PersonEmail	=  'pr@l.com';
             borrDetail.PersonMobile=  '7975270524';
             borrDetail.CBScustID	=  'iuhijkijojoi';
             borrDetail.AdhaarNumber=  'uhkjkjk';
             borrDetail.PanNumber	=  'iuhkkjn';
             borrDetail.FatherName	=  'SS';
             borrDetail.HusbName	=  'ss';
             borrDetail.CBSaccountNumber1=  '7868723430876';
             borrDetail.Occupation	=  'employee';
        	 borrDetail.Customer_IC	=  'aa';
        	 borrDetail.Phone		=  '4545324098';
             borrDetail.Fax_no		=  '6327832623';
        	 borrDetail.Title		=  'st';
         	 borrDetail.Caste		=  'xzcc'; 
       		 borrDetail.Religion	=  'bwjheh'; 
             borrDetail.IsExistingCustomer=  true;
        	 borrDetail.CustIDCreatedDate= String.ValueofGmt (Date.today());	
        	 borrDetail.CBSaccountNumber2=  '328743285133';
			 borrDetail.CBSaccountNumber3=  '169723097465';
        	 borrDetail.CBSaccountNumber4=  '765423340200';
             borrDetail.CBSaccountNumber5=  '528716547621';
        
        ApplicantService.CreateAccount(borrDetail);
        
    }

}