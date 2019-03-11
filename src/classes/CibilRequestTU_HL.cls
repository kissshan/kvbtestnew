public class CibilRequestTU_HL{
	public cls_Applicants[] Applicants;
	public cls_ApplicationData ApplicationData;
	public class cls_Applicants {
		public String ApplicantType;	//Main
		public String ApplicantFirstName;	//SAILAJA
		public String ApplicantMiddleName;	//
		public String ApplicantLastName;	//K
		public String DateOfBirth;	//08081983
		public String Gender;	//FEMALE
		public cls_Identifiers Identifiers;
		public cls_Telephones Telephones;
		public cls_Addresses Addresses;
	}
	public class cls_Identifiers {
		public cls_Identifier[] Identifier;
	}
	public class cls_Identifier {
		public String IdNumber;	//989153465252
		public String IdType;	//UID
	}
	public class cls_Telephones {
		public cls_Telephone[] Telephone;
	}
	public class cls_Telephone {
		public String TelephoneExtension;	//
		public String TelephoneNumber;	//919848283898
		public String TelephoneType;	//Mobile Phone
	}
	public class cls_Addresses {
		public cls_Address[] Address;
	}
	public class cls_Address {
		public String AddressLine1;	//H NO 58-3-25
		public String AddressLine2;	//RAMU NAIDU COLONY
		public String AddressLine3;	//MARRIPALEM
		public String AddressLine4;	//VISAKHAPATNAM
		public String AddressLine5;	//VISAKHAPATNAM
		public String City;	//VISAKHAPATNAM
		public String PinCode;	//530042
		public String StateCode;	//Andhra Pradesh
		public String AddressType;	//Permanent Address
		public String ResidenceType;	//Owned
	}
	public class cls_ApplicationData {
		public String ReferenceNumber;	//
		public String NTCProductType;	//
		public String ConsumerConsentForUIDAIAuthentication;	//Y
		public String GSTStateCode;	//Rajasthan
		public String CenterReferenceNo;	//
		public String BranchReferenceNo;	//
		public String CibilBureauFlag;	//True
		public String DSTuNtcFlag;	//True
		public String IDVerificationFlag;	//False
		public String MFIBureauFlag;	//True
		public String CIBILPDFReport;	//False
		public String MFIPDFReport;	//False
		public String IDVPDFReport;	//True
	}
	public static CibilRequestTU_HL parse(String json){
		return (CibilRequestTU_HL) System.JSON.deserialize(json, CibilRequestTU_HL.class);
	}
}
/*
 public class CibilRequestTU_HL{
	public cls_Applicants[] Applicants;
	public cls_ApplicationData ApplicationData;
	public class cls_Applicants {
		public String ApplicantType;	//Main
		public String ApplicantFirstName;	//NAVUKA
		public String ApplicantMiddleName;	//RASU
		public String ApplicantLastName;	//RM
		public String DateOfBirth;	//15081961
		public String Gender;	//MALE
		public cls_Identifiers[] Identifiers;
		public cls_Telephones[] Telephones;
		public cls_Addresses[] Addresses;
	}
	public class cls_Identifiers {
		public cls_Identifier Identifier;
	}
	public class cls_Identifier {
		public String IdNumber;	//TN/03/020/0711193
		public String IdType;	//Voter Id
	}
	public class cls_Telephones {
		public cls_Telephone Telephone;
	}
	public class cls_Telephone {
		public String TelephoneExtension;	//
		public String TelephoneNumber;	//7303066788
		public String TelephoneType;	//Mobile Phone
	}
	public class cls_Addresses {
		public cls_Address Address;
	}
	public class cls_Address {
		public String AddressLine1;	//1 / 11 senanaai  J-5 shasthri nagar
		public String AddressLine2;	//senanaai 3- 3.,velasse puthaiy vatu
		public String AddressLine3;	//N.177 mahalakshmi nagar
		public String AddressLine4;	//1st kurukku street,
		public String AddressLine5;	//Chennai
		public String City;	//Chennai
		public String PinCode;	//622001
		public String StateCode;	//Tamil Nadu
		public String AddressType;	//Permanent Address
		public String ResidenceType;	//Owned
	}
	public class cls_ApplicationData {
		public String ReferenceNumber;	//
		public String NTCProductType;	//
		public String ConsumerConsentForUIDAIAuthentication;	//Y
		public String GSTStateCode;	//Tamil Nadu
		public String CenterReferenceNo;	//
		public String BranchReferenceNo;	//
		public String CibilBureauFlag;	//True
		public String DSTuNtcFlag;	//True
		public String IDVerificationFlag;	//False
		public String MFIBureauFlag;	//True
		public String CIBILPDFReport;	//False
		public String MFIPDFReport;	//False
		public String IDVPDFReport;	//True
	}
	public static CibilRequestTU_HL parse(String json){
		return (CibilRequestTU_HL) System.JSON.deserialize(json, CibilRequestTU_HL.class);
	}
}

*/