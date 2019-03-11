@isTest
public class Test_CibilTUService {
    @isTest
    public static String methodGetCibilDetails(){
        genesis__Applications__c app=TestUtility.intialSetUp('TestName',true);
        Account acc=new Account(Name='TestName');
        insert acc;
        String json=		'{'+
		'    "Status": "Success",'+
		'    "Authentication": {'+
		'        "Status": "Success",'+
		'        "Token": "String"'+
		'    },'+
		'    "ResponseInfo": {'+
		'        "ApplicationId": "'+app.id+'",'+
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
		'                    "DsCibilBureau": {'+
		'                        "DsCibilBureauStatus": {'+
		'                            "Trail": "String"'+
		'                        },'+
		'                        "DsCibilResponse": {'+
		'                            "CibilBureauResponse": {'+
		'                                "BureauResponseRaw": "String",'+
		'                                "BureauResponseXml": {'+
		'                                    "CreditReport": {'+
		'                                        "Header": {'+
		'                                            "SegmentTag": "String",'+
		'                                            "Version": "String",'+
		'                                            "ReferenceNumber": "'+acc.id+'",'+
		'                                            "MemberCode": "String",'+
		'                                            "SubjectReturnCode": "String",'+
		'                                            "EnquiryControlNumber": "String",'+
		'                                            "DateProcessed": "String",'+
		'                                            "TimeProcessed": "String"'+
		'                                        },'+
		'                                        "NameSegment": {'+
		'                                            "Length": "String",'+
		'                                            "SegmentTag": "String",'+
		'                                            "ConsumerName1FieldLength": "String",'+
		'                                            "ConsumerName1": "String",'+
		'                                            "ConsumerName2FieldLength": "String",'+
		'                                            "ConsumerName2": "String",'+
		'                                            "ConsumerName3FieldLength": "String",'+
		'                                            "ConsumerName3": "String",'+
		'                                            "DateOfBirthFieldLength": "String",'+
		'                                            "DateOfBirth": "String",'+
		'                                            "GenderFieldLength": "String",'+
		'                                            "Gender": "String"'+
		'                                        },'+
		'                                        "IDSegment": ['+
		'                                            {'+
		'                                                "Length": "String",'+
		'                                                "SegmentTag": "String",'+
		'                                                "IDType": "String",'+
		'                                                "IDNumberFieldLength": "String",'+
		'                                                "IDNumber": "String",'+
		'                                                "EnrichedThroughEnquiry": "String"'+
		'                                            }'+
		'                                        ],'+
		'                                        "TelephoneSegment": ['+
		'                                            {'+
		'                                                "Length": "String",'+
		'                                                "SegmentTag": "String",'+
		'                                                "TelephoneNumberFieldLength": "String",'+
		'                                                "TelephoneNumber": "String",'+
		'                                                "TelephoneType": "String",'+
		'                                                "EnrichedThroughEnquiry": "String"'+
		'                                            }'+
		'                                        ],'+
		'                                        "ScoreSegment": ['+
		'                                            {'+
		'                                                "Length": "String",'+
		'                                                "ScoreName": "String",'+
		'                                                "ScoreCardName": "String",'+
		'                                                "ScoreCardVersion": "String",'+
		'                                                "ScoreDate": "String",'+
		'                                                "Score": "000-1"'+
		'                                            }'+
		'                                        ],'+
		'                                        "Enquiry": ['+
		'                                            {'+
		'                                                "Length": "String",'+
		'                                                "SegmentTag": "String",'+
		'                                                "DateOfEnquiryFields": "String",'+
		'                                                "EnquiringMemberShortNameFieldLength": "String",'+
		'                                                "EnquiringMemberShortName": "String",'+
		'                                                "EnquiryPurpose": "String",'+
		'                                                "EnquiryAmountFieldLength": "String",'+
		'                                                "EnquiryAmount": "String"'+
		'                                            }'+
		'                                        ],'+
		'                                        "ReportAddress": ['+
		'                                            {'+
		'                                                "AddressSegmentTag": "String",'+
		'                                                "Length": "String",'+
		'                                                "SegmentTag": "String",'+
		'                                                "AddressLine1FieldLength": "String",'+
		'                                                "AddressLine1": "String",'+
		'                                                "AddressLine2FieldLength": "String",'+
		'                                                "AddressLine2": "String",'+
		'                                                "AddressLine3FieldLength": "String",'+
		'                                                "AddressLine3": "String",'+
		'                                                "AddressLine4FieldLength": "String",'+
		'                                                "AddressLine4": "String",'+
		'                                                "AddressLine5FieldLength": "String",'+
		'                                                "AddressLine5": "String",'+
		'                                                "StateCode": "String",'+
		'                                                "PinCodeFieldLength": "String",'+
		'                                                "PinCode": "String",'+
		'                                                "AddressCategory": "String",'+
		'                                                "ResidenceCode": "String",'+
		'                                                "DateReported": "String",'+
		'                                                "EnrichedThroughEnquiry": "String"'+
		'                                            }'+
		'                                        ],'+
		'                                        "Accounts": ['+
		'                                        {'+
		'                                            "Length": "String",'+
		'                                            "SegmentTag": "String",'+
		'                                            "Account_Summary_Segment_Fields": ['+
		'                                                {'+
		'                                                    "ReportingMemberShortName": "String",'+
		'                                                    "NumberOfAccounts": "String",'+
		'                                                    "AccountGroup": "String",'+
		'                                                    "LiveClosedIndicator": "String",'+
		'                                                    "DateOpenedOrDisbursed": "String",'+
		'                                                    "DateOfLastPayment": "String",'+
		'                                                    "DateClosed": "String",'+
		'                                                    "DateReported": "String",'+
		'                                                    "HighCreditOrSanctionedAmount": "String",'+
		'                                                    "CurrentBalance": "String",'+
		'                                                    "AmountOverdue": "String",'+
		'                                                    "PaymentHistory1": "String",'+
		'                                                    "PaymentHistory2": "String",'+
		'                                                    "PaymentHistoryStartDate": "String",'+
		'                                                    "PaymentHistoryEndDate": "String"'+
		'                                                }'+
		'                                            ],'+
		'                                            "Account_NonSummary_Segment_Fields": ['+
		'                                                {'+
		'                                                    "ReportingMemberShortNameFieldLength": "String",'+
		'                                                    "ReportingMemberShortName": "String",'+
		'                                                    "AccountNumber": "String",'+
		'                                                    "AccountType": "String",'+
		'                                                    "OwenershipIndicator": "String",'+
		'                                                    "DateOpenedOrDisbursed": "String",'+
		'                                                    "DateOfLastPayment": "String",'+
		'                                                    "DateClosed": "String",'+
		'                                                    "DateReportedAndCertified": "String",'+
		'                                                    "HighCreditOrSanctionedAmount": "String",'+
		'                                                    "CurrentBalance": "String",'+
		'                                                    "AmountOverdue": "String",'+
		'                                                    "PaymentHistory1": "String",'+
		'                                                    "PaymentHistory2": "String",'+
		'                                                    "PaymentHistoryStartDate": "String",'+
		'                                                    "PaymentHistoryEndDate": "String",'+
		'                                                    "SuitFiledOrWilfulDefault": "String",'+
		'                                                    "WrittenOffAndSettled": "String",'+
		'                                                    "ValueOfCollateralFieldLength": "String",'+
		'                                                    "ValueOfCollateral": "String",'+
		'                                                    "TypeOfCollateral": "String",'+
		'                                                    "CreditLimit": "String",'+
		'                                                    "CashLimit": "String",'+
		'                                                    "RateOfInterest": "String",'+
		'                                                    "RepaymentTenure": "String",'+
		'                                                    "EmiAmount": "String",'+
		'                                                    "WrittenOffAmountTotal": "String",'+
		'                                                    "WrittenOffAmountPrincipal": "String",'+
		'                                                    "SettlementAmount": "String",'+
		'                                                    "PaymentFrequency": "String",'+
		'                                                    "ActualPaymentAmount": "String",'+
		'                                                    "ErrorCode": "String",'+
		'                                                    "CIBILRemarksCode": "String",'+
		'                                                    "DateOfEntryForErrorDisputeRemarksCode": "String",'+
		'                                                    "ErrorDisputeRemarksCode1": "String",'+
		'                                                    "ErrorDisputeRemarksCode2": "String",'+
		'                                                    "FID": "String",'+
		'                                                    "SNo": "String",'+
		'                                                    "SuppressFlag": "String",'+
		'                                                    "DateOfSuppression": "String"'+
		'                                                }'+
		'                                            ]'+
		'                                        }],'+
		'                                        "ReportEnd": {'+
		'                                            "SegmentTag": "String",'+
		'                                            "TotalLength": "String"'+
		'                                        }'+
		'                                    }'+
		'                                },'+
		'                                "IsSucess": "String"'+
		'                            }'+
		'                        }'+
		'                    }'+
		'                }'+
		'            }'+
		'        ]'+
		'    }'+
		'}';
        
         
        
        CibilResponseTU_HL ob=CibilResponseTU_HL.parse(json);
        CibilTUService.getcibildetails(ob,'Parent');
        CibilTUService.getcibildetails(null,'Parent');
        RETURN json;
    }

    
    @isTest
    public static String methodGetIDVDetails(){
        genesis__Applications__c app=TestUtility.intialSetUp('TestName',true);
        Account acc=new Account(Name='TestName');
        insert acc;
    	String json=		'{'+
		'    "Status": "Success",'+
		'    "Authentication": {'+
		'        "Status": "Success",'+
		'        "Token": "String"'+
		'    },'+
		'    "ResponseInfo": {'+
		'        "ApplicationId":"'+app.id+'",'+
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
		'                                        "Status": "String"'+
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
		'                                        "Status": "String"'+
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
		'                                        "Status": "String"'+
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
        IDVResponseTU_HL ob=IDVResponseTU_HL.parse(json);
         CibilTUService.getIDV(ob);
        RETURN json;
      
    }

}