@isTest
public class Test_CibilRequestTU_HL {
@isTest
    public static void method1(){
        String json=		'{'+
		'    "Applicants": [{'+
		'        "ApplicantType": "Main",'+
		'        "ApplicantFirstName": "SAILAJA",'+
		'        "ApplicantMiddleName": "",'+
		'        "ApplicantLastName": "K",'+
		'        "DateOfBirth": "08081983",'+
		'        "Gender": "FEMALE",'+
		'        "Identifiers": {'+
		'            "Identifier": [{'+
		'                "IdNumber": "989153465252",'+
		'                "IdType": "UID"'+
		'            },{'+
		'                "IdNumber": "BFMPS3956K",'+
		'                "IdType": "Pan Card"'+
		'            }]'+
		'        },'+
		'        "Telephones": {'+
		'            "Telephone": [{'+
		'                "TelephoneExtension": "",'+
		'                "TelephoneNumber": "919848283898",'+
		'                "TelephoneType": "Mobile Phone"'+
		'            }]'+
		'        },'+
		'        "Addresses": {'+
		'            "Address": [{'+
		'                "AddressLine1": "H NO 58-3-25",'+
		'                "AddressLine2": "RAMU NAIDU COLONY",'+
		'                "AddressLine3": "MARRIPALEM",'+
		'                "AddressLine4": "VISAKHAPATNAM",'+
		'                "AddressLine5": "VISAKHAPATNAM",'+
		'                "City": "VISAKHAPATNAM",'+
		'                "PinCode": "530042",'+
		'                "StateCode": "Andhra Pradesh",'+
		'                "AddressType": "Permanent Address",'+
		'                "ResidenceType": "Owned"'+
		'            }]'+
		'        }'+
		'    }],'+
		'    "ApplicationData": {'+
		'        "ReferenceNumber": "",'+
		'        "NTCProductType": "",'+
		'        "ConsumerConsentForUIDAIAuthentication": "Y",'+
		'        "GSTStateCode": "Tamil Nadu",'+
		'        "CenterReferenceNo": "",'+
		'        "BranchReferenceNo": "",'+
		''+
		'        "CibilBureauFlag": "False",'+
		'        "DSTuNtcFlag": "True",'+
		'        "IDVerificationFlag": "True",'+
		'        "MFIBureauFlag": "True",'+
		''+
		'        "CIBILPDFReport": "True",'+
		'        "MFIPDFReport": "False",'+
		'        "IDVPDFReport": "False"'+
		'    }'+
		'}';
        
        String json2=		'{'+
		'	"Applicants": ['+
		'		{'+
		'			"ApplicantFirstName": "Test",'+
		'			"ApplicantLastName": "Test"'+
		'		},'+
		'		{'+
		'			"ApplicantFirstName": "Test1",'+
		'			"ApplicantLastName": "Test1"'+
		'		}'+
		'	]'+
		'}';
        
        CibilRequestTU_HL.parse(json2);
    }
}