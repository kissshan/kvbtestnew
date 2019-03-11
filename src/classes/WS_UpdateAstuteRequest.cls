/*
* Name     : WS_UpdateFieldVerificationAPI
* Company  : ET Marlabs
* Purpose  : This is request structure for WS_UpdateAstuteRequest
* Author   : Shubham Shukla
*/
public class WS_UpdateAstuteRequest {
	public class EmployerInfo {
		public String name;
		public String address;
		public String propertyType;
		public String telephone;
		
	}

	public class FieldReport_Z {
		public String dateOfVisit;
		public String timeOfVisit;
		public String addressConfirmed;
		public String prominentLandmark;
		public String locality;
		public String officeType;
		public ColleagueInfo colleagueInfo;
		public String BusinessActivityLevel;
		public String noOfSightedEmployees;
		public String noOfSightedClients;
		public ApplicantVerification applicantVerification;
		public OtherDetails_Z otherDetails;
	}

	public class OtherDetails {
		public String comments;
		public String deDupeStatus;
		public String deDupeRemark;
		public String verifierName;
	}

	public class ApplicantVerification {
		public String designation;
		public String department;
		public String grade;
		public String salary;
		public String dateOfJoining;
		public String serviceDuration;
		public String PFNumber;
		public String typeOfJob;
		public String natureOfJob;
		public String natureOfBusiness;
		public String CarpetArea;
		public String employerVerification;
	}

	public class OfficeDetails {
		public EmployerInfo employerInfo;
		public FieldReport_Z fieldReport;
	}

	public ApplicationData applicationData;
	public ResidenceDetails residenceDetails;
	public OfficeDetails officeDetails;

	public class ColleagueInfo {
		public String name;
		public String designation;
		public String directTelephone;
		public String mobileNumber;
		public String visitingCardObtained;
	}

	public class ApplicationData {
		public String applicationNumber;
		public String fileNumber;
		public String applicantName;
        public String CaseNotificationId;
	}

	public class FieldReport {
		public String dateOfVisit;
		public String timeOfVisit;
		public String AddressConfirmed;
		public String prominentLandmark;
		public String locality;
		public String Accessibility;
		public String residenceType;
		public String ownershipStatus;
		public String noOfStoreys;
		public String Lift;
		public String externalAppearance;
		public String construction;
		public String AreaSqFt;
		public String internalAppearance;
		public String Asset;
		public String personContacted;
		public String stayStatus;
		public String durationOfStay;
		public String timeOfTheDay;
		public String noOfPersonStaying;
		public List<String> relationshipWithApplicant;
		public String neighbourFeedback;
		public String politicalLink;
		public String residenceVerification;
		public OtherDetails otherDetails;
	}

	public class ResidenceDetails {
		public String address;
		public String propertyType;
		public String CaseNotificationId;
		public FieldReport fieldReport;
	}

	public class OtherDetails_Z {
		public String comments;
		public String deDupeStatus;
		public String deDupeRemark;
		public String verifierName;
	}
    public class RelationshipWithApplicant{
        
    }

	public static WS_UpdateAstuteRequest parse(String json) {
		return (WS_UpdateAstuteRequest) System.JSON.deserialize(json, WS_UpdateAstuteRequest.class);
	}
}