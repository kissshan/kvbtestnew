/*
 * Name     : CommercialPR_EAE_Request
 * Company  : ET Marlabs
 * Purpose  : Request class  to send CommercialPRCallout request to APIGEE. 
 * Author   : Raushan
*/

global class CommercialPR_EAE_Request {
    
    public List<ApplicantsData> applicantsData;
    public ApplicationData applicationData;
    
    public class Addresses {
        public List<Address> Address;
    }
    public class Identifier {
        public String IdNumber;
        public String IdType;
    }
    public class Telephone {
        public String TelephoneExtension;
        public String TelephoneNumber;
        public String TelephoneType;
    }
    public class Address {
        public String AddressLine1;
        public String AddressLine2;
        public String AddressLine3;
        public String AddressLine4;
        public String AddressLine5;
        public String AddressType;
        public String City;
        public String PinCode;
        public String ResidenceType;
        public String StateCode;
    }
    public class RegisteredAddress {
        public String AddressType;
        public String AddressLine1;
        public String AddressLine2;
        public String AddressLine3;
        public String AddressCity;
        public String AddressStateCode;
        public String AddressPincode;
        public Telephone Telephone;
    }
    public class OtherAddresses {
        public List<RegisteredAddress> OtherAddress;
    }
    public class Telephones {
        public List<Telephone> Telephone;
    }
    public class ApplicantsData {
        public String ApplicantType;
        public String CIN;
        public String PAN;
        public String CRN;
        public String TIN;
        public String CompanyName;
        public String ClassOfActivity;
        public String TypeOfEntity;
        public String DateOfRegistration;
        public RegisteredAddress RegisteredAddress;
        public OtherAddresses OtherAddresses;
        public String MemberReferenceNumber;
        public String FacilityCategory;
        public String FacilityType;
        public String DIN;
        public String RelationType;
        public String ConsumerBureauCheck;
        public String IndividualPanCheck;
        public String ApplicantFirstName;
        public String ApplicantMiddleName;
        public String ApplicantLastName;
        public String DateOfBirth;
        public String Gender;
        public String EmailAddress;
        public Identifiers Identifiers;
        public Telephones Telephones;
        public Addresses Addresses;
    }
    public class ApplicationData {
        public String ConsumerCIR;
        public String NoOfDirector;
        public String GSTStateCode;
        
    }
    public class Identifiers {
        public List<Identifier> Identifier;
    }
    public static CommercialPR_EAE_Request parse(String json) {
       return (CommercialPR_EAE_Request) System.JSON.deserialize(json, CommercialPR_EAE_Request.class);
   }
}