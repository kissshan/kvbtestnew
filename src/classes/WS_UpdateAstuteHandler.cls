/*
* Name     : WS_UpdateFieldVerificationAPI
* Company  : ET Marlabs
* Purpose  : This is Handler class for Astute request and response
* Author   : Shubham Shukla
*/

public with sharing class WS_UpdateAstuteHandler {

    public static void getAstuteDetails(WS_UpdateAstuteRequest AstuteDetails){

         try{
        if(AstuteDetails != null) {
            Astute_Verification__c a = new Astute_Verification__c ();
            List<Astute_Verification__c> astList = new List<Astute_Verification__c> ();
            WS_UpdateAstuteRequest.ApplicationData appData;
            if (AstuteDetails.applicationData != null) {
                appData = AstuteDetails.applicationData;
                
                if (appData != null) {
                    if (!String.isBlank(appData.applicantName)) {
                        
                    }
                    if (!String.isBlank(appData.applicationNumber)) {
                        a.Application__c = appData.applicationNumber;
                    }
                    if (!String.isBlank(appData.fileNumber)) {

                    }
                    if (!String.isBlank(appData.CaseNotificationId)) {
                        a.Case_Notification_Id__c = appData.CaseNotificationId;
                    }
                }
            }

            if (AstuteDetails.residenceDetails != null) {
                WS_UpdateAstuteRequest.ResidenceDetails resData = AstuteDetails.residenceDetails;
                if (resData != null) { 
                    if (!String.isBlank(resData.address)) {
                        a.Employer_Address__c = resData.address;
                    }
                    if (!String.isBlank(resData.propertyType)) {
                        a.Property_Type__c = resData.propertyType;
                    }
                    WS_UpdateAstuteRequest.FieldReport fldData = resData.fieldReport;
                    if (fldData != null) {
                        if (!String.isBlank(fldData.dateOfVisit)) {
                            //a.Date_of_Visit__c = Date.parse(fldData.dateOfVisit);
                           
                            a.Date_of_Visit__c = queryService.getDateFormatFromString(fldData.dateOfVisit);
                        }
                        if (!String.isBlank(fldData.timeOfVisit)) {
                            a.Time_of_Visit__c = String.valueOf(fldData.timeOfVisit);
                        }
                        if (!String.isBlank(fldData.AddressConfirmed)) {
                            if(fldData.AddressConfirmed == 'Yes'){
                            a.Address_Confirmed__c = true;
                        }else if(fldData.AddressConfirmed == 'No'){
                            a.Address_Confirmed__c = false;
                        }
                        }
                        if (!String.isBlank(fldData.prominentLandmark)) {
                            a.Prominent_Landmark__c = fldData.prominentLandmark;
                        }
                        if (!String.isBlank(fldData.locality)) {
                            a.Locality__c = fldData.locality;
                        }
                        if (!String.isBlank(fldData.Accessibility)) {
                            a.Accessibility__c = fldData.Accessibility;
                        }
                        if (!String.isBlank(fldData.residenceType)) {
                            a.Residence_Type__c = fldData.residenceType;
                        }
                        if (!String.isBlank(fldData.ownershipStatus)) {
                            a.Ownership_Status__c = fldData.ownershipStatus;
                        }
                        if (!String.isBlank(fldData.noOfStoreys)) {
                            a.No_Of_Storeys__c = Decimal.valueOf(fldData.noOfStoreys);
                        }
                        if (!String.isBlank(fldData.Lift)) {
                            a.Lift__c = fldData.Lift;
                        }
                        if (!String.isBlank(fldData.externalAppearance)) {
                            a.External_Appearance__c = fldData.externalAppearance;
                        }
                        if (!String.isBlank(fldData.construction)) {
                            a.Construction__c = fldData.construction;
                        }
                        if (!String.isBlank(fldData.AreaSqFt)) {
                            a.Area_SqFt__c = fldData.AreaSqFt;
                        }
                        if (!String.isBlank(fldData.internalAppearance)) {
                            a.Internal_Appearance__c = fldData.internalAppearance;
                        }
                        if (!String.isBlank(fldData.Asset)) {
                            a.Asset__c = fldData.Asset;
                        }
                        if (!String.isBlank(fldData.personContacted)) {
                            a.Person_Contacted__c = fldData.personContacted;
                        }
                        if (!String.isBlank(fldData.stayStatus)) {
                            a.Stay_Status__c = fldData.stayStatus;
                        }
                        if (!String.isBlank(fldData.durationOfStay)) {
                            a.Duration_Of_Stay__c = fldData.durationOfStay;
                        }
                        if (!String.isBlank(fldData.timeOfTheDay)) {
                            a.Time_Of_The_Day__c = fldData.timeOfTheDay;
                        }
                        if (!String.isBlank(fldData.noOfPersonStaying)) {
                            a.No_Of_Person_Staying__c = Decimal.valueOf(fldData.noOfPersonStaying);
                        }
                        if (!String.isBlank(fldData.neighbourFeedback)) {
                            a.Neighbour_Feedback__c = fldData.neighbourFeedback;
                        }
                        if (!String.isBlank(fldData.politicalLink)) {
                            a.Political_Link__c = fldData.politicalLink;
                        }
                        if (!String.isBlank(fldData.residenceVerification)) {
                            a.Residence_Verification__c = fldData.residenceVerification;
                        }
                        WS_UpdateAstuteRequest.OtherDetails oth = flddata.otherDetails;
                        if (oth != null) {
                            if (!String.isBlank(oth.comments)) {
                                a.Commets__c = oth.comments;
                            }
                            if (!String.isBlank(oth.deDupeRemark)) {
                                a.DeDupe_Remark__c = oth.deDupeRemark;
                            }
                            if (!String.isBlank(oth.deDupeStatus)) {
                                a.DeDupe_Status__c = oth.deDupeStatus;
                            }
                            if (!String.isBlank(oth.verifierName)) {
                                a.Verifier_Name__c = oth.verifierName;
                            }

                        }
                           List<String> relData = flddata.relationshipWithApplicant;
                       String str='';
                        if (relData != null) {
                            for (String rel : relData) {
                                str += rel+',';
                            }
                            str = str.removeEnd(',');
                            System.debug(str);
                            a.Applicant_Relationship__c = str;
                        }
                    }
                    if (!String.isBlank(appData.applicationNumber)) {
                        a.Application__c = appData.applicationNumber;
                    }
                    
                    upsert a Case_Notification_Id__c;
                }


             //update

            }
            WS_UpdateAstuteRequest.OfficeDetails offData = AstuteDetails.officeDetails;
            if (offData != null) {
                WS_UpdateAstuteRequest.EmployerInfo emp = offData.employerInfo;
                if (emp != null) {
                    if (!String.isBlank(emp.name)) {
                        a.Employer_Name__c = emp.name;
                    }
                    if (!String.isBlank(emp.address)) {
                        a.Employer_Address__c = emp.address;
                    }
                    if (!String.isBlank(emp.propertyType)) {
                        a.Property_Type__c = emp.propertyType;
                    }
                    if (!String.isBlank(emp.telephone)) {
                        a.Employer__c = emp.telephone;
                    }
                }
                Ws_UpdateAstuteRequest.FieldReport_Z fldz = offData.fieldReport;
                if (fldz != null) {
                    if (!String.isBlank(fldz.dateOfVisit)) {
                       System.debug('#####'+fldz.dateOfVisit);
                        System.debug('#####'+queryService.getDateFormatFromString(fldz.dateOfVisit));
                        a.Date_of_Visit__c = queryService.getDateFormatFromString(fldz.dateOfVisit);
                       
                    }
                    if (!String.isBlank(fldz.timeOfVisit)) {
                        a.Time_of_Visit__c = String.valueOf(fldz.timeOfVisit);
                    }
                       if (!String.isBlank(fldz.AddressConfirmed)) {
                            if(fldz.AddressConfirmed == 'Yes'){
                            a.Address_Confirmed__c = true;
                        }else if(fldz.AddressConfirmed == 'No'){
                            a.Address_Confirmed__c = false;
                        }
                        }
                    if (!String.isBlank(fldz.prominentLandmark)) {
                        a.Prominent_Landmark__c = fldz.prominentLandmark;
                    }
                    if (!String.isBlank(fldz.locality)) {
                        a.Locality__c = fldz.locality;
                    }
                    if (!String.isBlank(fldz.officeType)) {
                        a.Office_Type__c = fldz.officeType;
                    }
                    if (!String.isBlank(fldz.BusinessActivityLevel)) {
                        a.Business_Activity_Level__c = fldz.BusinessActivityLevel;
                    }
                    if (!String.isBlank(fldz.noOfSightedEmployees)) {
                        a.No_Of_Sighted_Employees__c = Decimal.valueOf(fldz.noOfSightedEmployees);
                    }
                    if (!String.isBlank(fldz.noOfSightedClients)) {
                        a.No_Of_Sighted_Clients__c = decimal.valueOf(fldz.noOfSightedClients);
                    }

                    Ws_UpdateAstuteRequest.ColleagueInfo clg = fldz.colleagueInfo;
                    if (clg != null) {
                        if (!String.isBlank(clg.name)) {
                            a.Colleague_Name__c = clg.name;
                        }
                        if (!String.isBlank(clg.designation)) {
                            a.Colleague_Designation__c = clg.designation;
                        }
                        if (!String.isBlank(clg.directTelephone)) {
                            a.Colleague_Telephone__c = clg.directTelephone;
                        }
                        if (!String.isBlank(clg.mobileNumber)) {
                            a.Colleague_Mobile__c = clg.mobileNumber;
                        }
                        if (!String.isBlank(clg.visitingCardObtained)) {
                            a.Colleague_Visiting_Card_Obtained__c = Boolean.valueOf(clg.visitingCardObtained);
                        }
                    }
                    Ws_UpdateAstuteRequest.ApplicantVerification apv = fldz.applicantVerification;
                    if (apv != null) {
                        if (!String.isBlank(apv.designation)) {
                            a.Designation__c = apv.designation;
                        }
                        if (!String.isBlank(apv.department)) {
                            a.department__c = apv.department;
                        }
                        if (!String.isBlank(apv.grade)) {
                            a.Grade__c = apv.grade;
                        }
                        if (!String.isBlank(apv.salary)) {
                            a.Salary__c = Decimal.valueOf(apv.salary);
                        }
                        if (!String.isBlank(apv.dateOfJoining)) {
                            a.Date_Of_Joining__c = queryService.getDateFormatFromString(apv.dateOfJoining);
                        }
                        if (!String.isBlank(apv.serviceDuration)) {
                            a.Service_Duration__c = apv.serviceDuration;
                        }
                        if (!String.isBlank(apv.PFNumber)) {
                            a.PF_Number__c = apv.PFNumber;
                        }
                        if (!String.isBlank(apv.typeOfJob)) {
                            a.Type_Of_Job__c = apv.typeOfJob;
                        }
                        if (!String.isBlank(apv.natureOfJob)) {
                            a.Nature_Of_Job__c = apv.natureOfJob;
                        }
                        if (!String.isBlank(apv.natureOfBusiness)) {
                            a.Nature_Of_Business__c = apv.natureOfBusiness;
                        }
                        if (!String.isBlank(apv.CarpetArea)) {
                            a.Carpet_Area__c = apv.CarpetArea;
                        }
                        if (!String.isBlank(apv.employerVerification)) {
                            a.Employer_Verification__c = String.valueOf(apv.employerVerification);
                        }
                    }
                    Ws_UpdateAstuteRequest.OtherDetails_Z othz = fldz.otherDetails;
                    if (othz != null) {
                        if (!String.isBlank(othz.comments)) {
                            a.Commets__c = othz.comments;
                        }
                        if (!String.isBlank(othz.deDupeStatus)) {
                            a.DeDupe_Status__c = othz.deDupeStatus;
                        }
                        if (!String.isBlank(othz.deDupeRemark)) {
                            a.DeDupe_Remark__c = othz.deDupeRemark;
                        }
                        if (!String.isBlank(othz.verifierName)) {
                            a.Verifier_Name__c = othz.verifierName;
                        }
                    }

                }
                if (!String.isBlank(appData.applicationNumber)) {
                        a.Application__c = appData.applicationNumber;
                }
                System.debug('@@@@'+a);
                upsert a Case_Notification_Id__c;
            }

        }
    }
    catch(Exception e){
        System.debug('e'+e);
        HandleBusinessException.captureError('WS_UpdateAstuteHandler', 'getAstuteDetails', e);
    }
}
}