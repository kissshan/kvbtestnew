public class IDVResponseTU_HL{
	public String Status;	//String
	public cls_Authentication Authentication;
	public cls_ResponseInfo ResponseInfo;
	public cls_ContextData ContextData;
	public class cls_Authentication {
		public String Status;	//String
		public String TokeResponseInfon;	//String
	}
	public class cls_ResponseInfo {
		public String ApplicationId;	//Number
		public String SolutionSetInstanceId;	//String
		public String CurrentQueue;	//String
        public string ReferenceNumber;//added by prashant singh for account number
        public string appid;//added by prashant singh for application id
         public string LosApplicationId;//added by prashant singh for application id
	}
	public class cls_ContextData {
		public cls_Applicants[] Applicants;
	}
	public class cls_Applicants {
		public cls_Applicant Applicant;
	}
	public class cls_Applicant {
		public String Gender;	//String
		public String DateOfBirth;	//String
		public String ApplicantLastName;	//String
		public String ApplicantMiddleName;	//String
		public String ApplicantFirstName;	//String
		public String ApplicantType;	//String
		public cls_DsIDVision DsIDVision;
	}
	public class cls_DsIDVision {
		public cls_CPVAttributes CPVAttributes;
	}
	public class cls_CPVAttributes {
		public cls_Match Match;
		public cls_EnquiryInfo EnquiryInfo;
		public cls_VerificationScore VerificationScore;
		public cls_Velocity Velocity;
		public cls_PAN PAN;
		public cls_Aadhar Aadhar;
		public cls_CIBILDetect CIBILDetect;
		public cls_WilfulDefaultDetails WilfulDefaultDetails;
	}
	public class cls_Match {
		public String ContactabilityAadhaarTelephone1Status;	//String
		public String ContactabilityAadhaarTelephone1Match;	//String
		public String AddressAadhaarPermanentStatus;	//String
		public String AddressAadhaarPermanentMatch;	//String
		public String AddressAadhaarResidenceStatus;	//String
		public String AddressAadhaarResidenceMatch;	//String
		public String IDAadhaarIdentifierStatus;	//String
		public String IDAadhaarIdentifierMatch;	//String
		public String IDAadharGenderStatus;	//String
		public String IDAadharGenderMatch;	//String
		public String IDAadharDOBYearStatus;	//String
		public String IDAadharDOBYearMatch;	//String
		public String IDAadharNameStatus;	//String
		public String IDAadharNameMatch;	//String
		public String AddressVoterPermanentStatus;	//String
		public String AddressVoterPermanentMatch;	//String
		public String AddressVoterResidenceStatus;	//String
		public String AddressVoterResidenceMatch;	//String
		public String IDVoterIdentifierStatus;	//String
		public String IDVoterIdentifierMatch;	//String
		public String IDVoterGenderStatus;	//String
		public String IDVoterGenderMatch;	//String
		public String IDVoterNameStatus;	//String
		public String IDVoterNameMatch;	//String
		public String IDNSDLIdentifierStatus;	//String
		public String IDNSDLIdentifierMatch;	//String
		public String IDNSDLNameStatus;	//String
		public String IDNSDLNameMatch;	//String
		public String ContactabilityOfficeNumberStatus;	//String
		public String ContactabilityOfficeNumberMatch;	//String
		public String ContactabilityResidenceNumberStatus;	//String
		public String ContactabilityResidenceNumberMatch;	//String
		public String ContactabilityMobileNumberStatus;	//String
		public String ContactabilityMobileNumberMatch;	//String
		public String AddressCIBILOfficeStatus;	//String
		public String AddressCIBILOfficeMatch;	//String
		public String AddressCIBILPermanentStatus;	//String
		public String AddressCIBILPermanentMatch;	//String
		public String AddressCIBILResidenceStatus;	//String
		public String AddressCIBILResidenceMatch;	//String
		public String IDCIBILDrivingLicenseIDStatus;	//String
		public String IDCIBILDrivingLicenseIDMatch;	//String
		public String IDCIBILRationCardIDStatus;	//String
		public String IDCIBILRationCardIDMatch;	//String
		public String IDCIBILPassportIDStatus;	//String
		public String IDCIBILPassportIDMatch;	//String
		public String IDCIBILAadhaarIDStatus;	//String
		public String IDCIBILAadhaarIDMacth;	//String
		public String IDCIBILVoterIDStatus;	//String
		public String IDCIBILVoterIDMatch;	//String
		public String IDCIBILPANStatus;	//String
		public String IDCIBILPANMatch;	//String
		public String IDCIBILGenderStatus;	//String
		public String IDCIBILGenderMatch;	//String
		public String IDCIBILDOBStatus;	//String
		public String IDCIBILDOBMatch;	//String
		public String IDCIBILNameStatus;	//String
		public String IDCIBILNameMatch;	//String
		public cls_ExceptionMessage ExceptionMessage;
	}
	public class cls_ExceptionMessage {
		public String PANMessage;	//String
		public String VoterMessage;	//String
		public String AadhaarMessage;	//String
	}
	public class cls_EnquiryInfo {
		public String MobileNumber;	//long
		public String PermanentAddressCity;	//String
		public String PermanentAddressState;	//String
		public String PermanentAddressStateCode;	//String
		public String PermanentAddressPinCode;	//String
		public String PermanentAddressLine;	//int
		public String UID;	//long
		public String PAN;	//String
		public String EmailID;	//String
		public String DateofBirth;	//String
		public String Gender;	//String
		public String LastName;	//String
		public String MiddleName;	//String
		public String FirstName;	//String
	}
	public class cls_VerificationScore {
		public String IDNameScore;	//String
		public String IDNameStatus;	//String
		public String IDAltNameScore;	//String
		public String IDAltDOBScore;	//String
		public String IDDOBScore;	//String
		public String IDDOBStatus;	//String
		public String IDAltGenderScore;	//String
		public String IDGenderScore;	//String
		public String IDGenderStatus;	//String
		public String IDAltIdentifierScore;	//String
		public String IDIdentifierScore;	//String
		public String IDIdentifierStatus;	//String
		public String AddAltResScore;	//String
		public String AddressResidenceScore;	//String
		public String AddressResidenceStatus;	//String
		public String AddAltPerScore;	//String
		public String AddressPermanentScore;	//String
		public String AddressPermanentStatus;	//String
		public String AddressOfficeScore;	//String
		public String AddressOfficeStatus;	//String
		public String ConAltPhoneScore;	//String
		public String ContactabilityTelephone1Score;	//String
		public String ContactabilityTelephone1Status;	//String
		public String ContactabilityTelephone2Score;	//String
		public String ContactabilityTelephone2Status;	//String
		public String ContactabilityTelephone3Score;	//String
		public String ContactabilityTelephone3Status;	//String
		public String FinalIdentityScore;	//String
		public String FinalIdentityStatus;	//String
		public String FinalAddressScore;	//String
		public String FinalAddressStatus;	//String
		public String FinalContactabilityScore;	//String
		public String FinalContactabilityStatus;	//String
		public String FinalVerificationScore;	//String
		public String FinalVerificationStatus;	//String
	}
	public class cls_Velocity {
		public cls_ProductInfo1month[] ProductInfo1month;
		public cls_ProductInfo3months[] ProductInfo3months;
		public cls_ProductInfo6months[] ProductInfo6months;
	}
	public class cls_ProductInfo1month {
		public String NoOfEnquiries;	//String
		public String ProductType;	//String
	}
	public class cls_ProductInfo3months {
		public String NoOfEnquiries;	//String
		public String ProductType;	//String
	}
	public class cls_ProductInfo6months {
		public String NoOfEnquiries;	//String
		public String ProductType;	//String
	}
	public class cls_PAN {
		public String Name;	//String
		public String ID;	//String
		public String ExceptionMessage;	//String
		public String Message;	//String
	}
	public class cls_Aadhar {
		public String ID;	//long
		public String ExceptionMessage;	//String
		public String Message;	//String
	}
	public class cls_CIBILDetect {
		public cls_Responseheader Responseheader;
		public cls_ResponseBody ResponseBody;
		public String ExceptionMessage;	//String
	}
	public class cls_Responseheader {
		public String HitCount;	//String
		public String NoHitCount;	//String
		public String ErrorCount;	//String
		public String ProcessDate;	//String
	}
	public class cls_ResponseBody {
		public cls_incidentReport[] incidentReport;
	}
	public class cls_incidentReport {
		public cls_incidentinformation incidentinformation;
		public cls_consumeridentity consumeridentity;
		public cls_enquiryinformation[] enquiryinformation;
		public cls_MatchedOnInformation MatchedOnInformation;
	}
	public class cls_incidentinformation {
		public String dateofreporting;	//String
		public String complainttolawenforcement;	//String
		public String amountrecovered;	//String
		public String amountinvolved;	//String
		public String membername;	//String
		public String accountnumber;	//String
		public String incidentdescription;	//String
		public String modusoperandi;	//String
		public String modusoperandidetails;	//String
		public String detectiondate;	//String
		public String occurencedate;	//String
		public String incidentstatus;	//String
		public String areaofoperationtype;	//String
		public String bankrelationship;	//String
		public String incidentrelationship;	//String
		public String incidenttype;	//String
		public String incidentnumber;	//int
		public String complaintnumber;	//String
		public String complaintoffice;	//String
	}
	public class cls_consumeridentity {
		public String name;	//String
		public String dateofbirth;	//String
		public String employername;	//String
		public String PanNo;	//String
		public String PanDateReported;	//String
		public cls_Phones[] Phones;
		public String PERSONALline1;	//String
		public String PERSONALline2;	//String
		public String PERSONALline3;	//String
		public String PERSONALcity;	//String
		public String PERSONALdistrict;	//String
		public String PERSONALstate;	//String
		public String PERSONALpincode;	//int
		public String PERSONALcountry;	//String
		public String PERSONALreportingdate;	//String
	}
	public class cls_Phones {
		public String PersonalTelephone;	//String
		public String PersonalTelephoneDateReported;	//String
	}
	public class cls_enquiryinformation {
		public String membername;	//String
		public String enquirydate;	//String
		public String enquirypurpose;	//String
	}
	public class cls_MatchedOnInformation {
		public String MatchedOn;	//String
	}
	public class cls_WilfulDefaultDetails {
		public cls_SuitFiled[] SuitFiled;
		public cls_WilfulDefault[] WilfulDefault;
		public cls_SuitfiledandWilfuldefault[] SuitfiledandWilfuldefault;
		public String ExceptionMessage;	//String
	}
	public class cls_SuitFiled {
		public cls_MemberDetails[] MemberDetails;
		public String Status;	//String
	}
	public class cls_MemberDetails {
		public String ProductCategory;	//String
		public String MemberName;	//String
		public String AccountNumber;	//String
		public String OwenershipIndicator;	//String
		public String ProductType;	//String
		public String DateReported;	//String
		public String AmountOutstandingasonReportedDate;	//String
	}
	public class cls_WilfulDefault {
		public cls_MemberDetails[] MemberDetails;
		public String Status;	//String
	}
	public class cls_SuitfiledandWilfuldefault {
		public cls_MemberDetails[] MemberDetails;
		public String Status;	//String
	}
	public static IDVResponseTU_HL parse(String json){
		return (IDVResponseTU_HL) System.JSON.deserialize(json, IDVResponseTU_HL.class);
	}
 }