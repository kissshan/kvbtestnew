@isTest
public class Test_IDVResponseTU_HL {
    @isTest
    public static String testParse(){
        String json=		'{'+
            '    "Status": "Success",'+
            '    "Authentication": {'+
            '        "Status": "Success",'+
            '        "Token": "String"'+
            '    },'+
            '    "ResponseInfo": {'+
            '        "ApplicationId": "Number",'+
            '        "SolutionSetInstanceId": "String",'+
            '        "CurrentQueue": "String"'+
            '    },'+
            '    "ContextData": {'+
            '        "Applicants": ['+
            '            {'+
            '                "Applicant": {'+
            '                    "Gender": "String",'+
            '                    "DateOfBirth": "String",'+
            '                    "ApplicantLastName": "String",'+
            '                    "ApplicantMiddleName": "String",'+
            '                    "ApplicantFirstName": "String",'+
            '                    "ApplicantType": "String",'+
            '                    "DsIDVision": {'+
            '                        "CPVAttributes": {'+
            '                            "Match": {'+
            '                                "ContactabilityAadhaarTelephone1Status": "String",'+
            '                                "ContactabilityAadhaarTelephone1Match": "String",'+
            '                                "AddressAadhaarPermanentStatus": "String",'+
            '                                "AddressAadhaarPermanentMatch": "String",'+
            '                                "AddressAadhaarResidenceStatus": "String",'+
            '                                "AddressAadhaarResidenceMatch": "String",'+
            '                                "IDAadhaarIdentifierStatus": "String",'+
            '                                "IDAadhaarIdentifierMatch": "String",'+
            '                                "IDAadharGenderStatus": "String",'+
            '                                "IDAadharGenderMatch": "100",'+
            '                                "IDAadharDOBYearStatus": "String",'+
            '                                "IDAadharDOBYearMatch": "100",'+
            '                                "IDAadharNameStatus": "String",'+
            '                                "IDAadharNameMatch": "100",'+
            '                                "AddressVoterPermanentStatus": "String",'+
            '                                "AddressVoterPermanentMatch": "String",'+
            '                                "AddressVoterResidenceStatus": "String",'+
            '                                "AddressVoterResidenceMatch": "String",'+
            '                                "IDVoterIdentifierStatus": "String",'+
            '                                "IDVoterIdentifierMatch": "String",'+
            '                                "IDVoterGenderStatus": "String",'+
            '                                "IDVoterGenderMatch": "String",'+
            '                                "IDVoterNameStatus": "String",'+
            '                                "IDVoterNameMatch": "String",'+
            '                                "IDNSDLIdentifierStatus": "String",'+
            '                                "IDNSDLIdentifierMatch": "String",'+
            '                                "IDNSDLNameStatus": "String",'+
            '                                "IDNSDLNameMatch": "90",'+
            '                                "ContactabilityOfficeNumberStatus": "String",'+
            '                                "ContactabilityOfficeNumberMatch": "String",'+
            '                                "ContactabilityResidenceNumberStatus": "String",'+
            '                                "ContactabilityResidenceNumberMatch": "String",'+
            '                                "ContactabilityMobileNumberStatus": "String",'+
            '                                "ContactabilityMobileNumberMatch": "String",'+
            '                                "AddressCIBILOfficeStatus": "String",'+
            '                                "AddressCIBILOfficeMatch": "String",'+
            '                                "AddressCIBILPermanentStatus": "String",'+
            '                                "AddressCIBILPermanentMatch": "String",'+
            '                                "AddressCIBILResidenceStatus": "String",'+
            '                                "AddressCIBILResidenceMatch": "String",'+
            '                                "IDCIBILDrivingLicenseIDStatus": "String",'+
            '                                "IDCIBILDrivingLicenseIDMatch": "String",'+
            '                                "IDCIBILRationCardIDStatus": "String",'+
            '                                "IDCIBILRationCardIDMatch": "String",'+
            '                                "IDCIBILPassportIDStatus": "String",'+
            '                                "IDCIBILPassportIDMatch": "String",'+
            '                                "IDCIBILAadhaarIDStatus": "String",'+
            '                                "IDCIBILAadhaarIDMacth": "String",'+
            '                                "IDCIBILVoterIDStatus": "String",'+
            '                                "IDCIBILVoterIDMatch": "String",'+
            '                                "IDCIBILPANStatus": "String",'+
            '                                "IDCIBILPANMatch": "String",'+
            '                                "IDCIBILGenderStatus": "String",'+
            '                                "IDCIBILGenderMatch": "String",'+
            '                                "IDCIBILDOBStatus": "String",'+
            '                                "IDCIBILDOBMatch": "String",'+
            '                                "IDCIBILNameStatus": "String",'+
            '                                "IDCIBILNameMatch": "String",'+
            '                                "ExceptionMessage": {'+
            '                                    "PANMessage": "String",'+
            '                                    "VoterMessage": "String",'+
            '                                    "AadhaarMessage": "String"'+
            '                                }'+
            '                            },'+
            '                            "EnquiryInfo": {'+
            '                                "MobileNumber": "long",'+
            '                                "PermanentAddressCity": "String",'+
            '                                "PermanentAddressState": "String",'+
            '                                "PermanentAddressStateCode": "String",'+
            '                                "PermanentAddressPinCode": "String",'+
            '                                "PermanentAddressLine": "int",'+
            '                                "UID": "long",'+
            '                                "PAN": "String",'+
            '                                "EmailID": "String",'+
            '                                "DateofBirth": "String",'+
            '                                "Gender": "String",'+
            '                                "LastName": "String",'+
            '                                "MiddleName": "String",'+
            '                                "FirstName": "String"'+
            '                            },'+
            '                            "VerificationScore": {'+
            '                                "IDNameScore": "String",'+
            '                                "IDNameStatus": "String",'+
            '                                "IDAltNameScore": "String",'+
            '                                "IDAltDOBScore": "String",'+
            '                                "IDDOBScore": "String",'+
            '                                "IDDOBStatus": "String",'+
            '                                "IDAltGenderScore": "String",'+
            '                                "IDGenderScore": "String",'+
            '                                "IDGenderStatus": "String",'+
            '                                "IDAltIdentifierScore": "String",'+
            '                                "IDIdentifierScore": "String",'+
            '                                "IDIdentifierStatus": "String",'+
            '                                "AddAltResScore": "String",'+
            '                                "AddressResidenceScore": "String",'+
            '                                "AddressResidenceStatus": "String",'+
            '                                "AddAltPerScore": "String",'+
            '                                "AddressPermanentScore": "String",'+
            '                                "AddressPermanentStatus": "String",'+
            '                                "AddressOfficeScore": "String",'+
            '                                "AddressOfficeStatus": "String",'+
            '                                "ConAltPhoneScore": "String",'+
            '                                "ContactabilityTelephone1Score": "String",'+
            '                                "ContactabilityTelephone1Status": "String",'+
            '                                "ContactabilityTelephone2Score": "String",'+
            '                                "ContactabilityTelephone2Status": "String",'+
            '                                "ContactabilityTelephone3Score": "String",'+
            '                                "ContactabilityTelephone3Status": "String",'+
            '                                "FinalIdentityScore": "String",'+
            '                                "FinalIdentityStatus": "String",'+
            '                                "FinalAddressScore": "String",'+
            '                                "FinalAddressStatus": "String",'+
            '                                "FinalContactabilityScore": "String",'+
            '                                "FinalContactabilityStatus": "String",'+
            '                                "FinalVerificationScore": "String",'+
            '                                "FinalVerificationStatus": "String"'+
            '                            },'+
            '                            "Velocity": {'+
            '                                "ProductInfo1month": ['+
            '                                    {'+
            '                                        "NoOfEnquiries": "String",'+
            '                                        "ProductType": "String"'+
            '                                    }'+
            '                                ],'+
            '                                "ProductInfo3months": ['+
            '                                    {'+
            '                                        "NoOfEnquiries": "String",'+
            '                                        "ProductType": "String"'+
            '                                    }'+
            '                                ],'+
            '                                "ProductInfo6months": ['+
            '                                    {'+
            '                                        "NoOfEnquiries": "String",'+
            '                                        "ProductType": "String"'+
            '                                    }'+
            '                                ]'+
            '                            },'+
            '                            "PAN": {'+
            '                                "Name": "String",'+
            '                                "ID": "String",'+
            '                                "ExceptionMessage": "String",'+
            '                                "Message": "String"'+
            '                            },'+
            '                            "Aadhar": {'+
            '                                "ID": "long",'+
            '                                "ExceptionMessage": "String",'+
            '                                "Message": "String"'+
            '                            },'+
            '                            "CIBILDetect": {'+
            '                                "Responseheader": {'+
            '                                    "HitCount": "String",'+
            '                                    "NoHitCount": "String",'+
            '                                    "ErrorCount": "String",'+
            '                                    "ProcessDate": "String"'+
            '                                },'+
            '                                "ResponseBody": {'+
            '                                    "incidentReport": ['+
            '                                        {'+
            '                                            "incidentinformation": {'+
            '                                                "dateofreporting": "String",'+
            '                                                "complainttolawenforcement": "String",'+
            '                                                "amountrecovered": "String",'+
            '                                                "amountinvolved": "String",'+
            '                                                "membername": "String",'+
            '                                                "accountnumber": "String",'+
            '                                                "incidentdescription": "String",'+
            '                                                "modusoperandi": "String",'+
            '                                                "modusoperandidetails": "String",'+
            '                                                "detectiondate": "String",'+
            '                                                "occurencedate": "String",'+
            '                                                "incidentstatus": "String",'+
            '                                                "areaofoperationtype": "String",'+
            '                                                "bankrelationship": "String",'+
            '                                                "incidentrelationship": "String",'+
            '                                                "incidenttype": "String",'+
            '                                                "incidentnumber": "int",'+
            '                                                "complaintnumber": "String",'+
            '                                                "complaintoffice": "String"'+
            '                                            },'+
            '                                            "consumeridentity": {'+
            '                                                "name": "String",'+
            '                                                "dateofbirth": "String",'+
            '                                                "employername": "String",'+
            '                                                "PanNo": "String",'+
            '                                                "PanDateReported": "String",'+
            '                                                "Phones": ['+
            '                                                    {'+
            '                                                        "PersonalTelephone": "String",'+
            '                                                        "PersonalTelephoneDateReported": "String"'+
            '                                                    }'+
            '                                                ],'+
            '                                                "PERSONALline1": "String",'+
            '                                                "PERSONALline2": "String",'+
            '                                                "PERSONALline3": "String",'+
            '                                                "PERSONALcity": "String",'+
            '                                                "PERSONALdistrict": "String",'+
            '                                                "PERSONALstate": "String",'+
            '                                                "PERSONALpincode": "int",'+
            '                                                "PERSONALcountry": "String",'+
            '                                                "PERSONALreportingdate": "String"'+
            '                                            },'+
            '                                            "enquiryinformation": ['+
            '                                                {'+
            '                                                    "membername": "String",'+
            '                                                    "enquirydate": "String",'+
            '                                                    "enquirypurpose": "String"'+
            '                                                }'+
            '                                            ],'+
            '                                            "MatchedOnInformation": {'+
            '                                                "MatchedOn": "String"'+
            '                                            }'+
            '                                        }'+
            '                                    ]'+
            '                                },'+
            '                                "ExceptionMessage": "String"'+
            '                            },'+
            '                            "WilfulDefaultDetails": {'+
            '                                "SuitFiled": ['+
            '                                    {'+
            '                                        "MemberDetails": ['+
            '                                            {'+
            '                                                "ProductCategory": "String",'+
            '                                                "MemberName": "String",'+
            '                                                "AccountNumber": "String",'+
            '                                                "OwenershipIndicator": "unsignedByte",'+
            '                                                "ProductType": "String",'+
            '                                                "DateReported": "String",'+
            '                                                "AmountOutstandingasonReportedDate": "String"'+
            '                                            }'+
            '                                        ],'+
            '                                        "Status": "Success"'+
            '                                    }'+
            '                                ],'+
            '                                "WilfulDefault": ['+
            '                                    {'+
            '                                        "MemberDetails": ['+
            '                                            {'+
            '                                                "ProductCategory": "String",'+
            '                                                "MemberName": "String",'+
            '                                                "AccountNumber": "String",'+
            '                                                "OwenershipIndicator": "String",'+
            '                                                "ProductType": "String",'+
            '                                                "DateReported": "String",'+
            '                                                "AmountOutstandingasonReportedDate": "String"'+
            '                                            }'+
            '                                        ],'+
            '                                        "Status": "Success"'+
            '                                    }'+
            '                                ],'+
            '                                "SuitfiledandWilfuldefault": ['+
            '                                    {'+
            '                                        "MemberDetails": ['+
            '                                            {'+
            '                                                "ProductCategory": "String",'+
            '                                                "MemberName": "String",'+
            '                                                "AccountNumber": "String",'+
            '                                                "OwenershipIndicator": "String",'+
            '                                                "ProductType": "String",'+
            '                                                "DateReported": "String",'+
            '                                                "AmountOutstandingasonReportedDate": "String"'+
            '                                            }'+
            '                                        ],'+
            '                                        "Status": "Success"'+
            '                                    }'+
            '                                ],'+
            '                                "ExceptionMessage": "String"'+
            '                            }'+
            '                        }'+
            '                    }'+
            '                }'+
            '            }'+
            '        ]'+
            '    }'+
            '}';
        //RETURN json;
        IDVResponseTU_HL.parse(json);
        RETURN json;
        
    }
    
}