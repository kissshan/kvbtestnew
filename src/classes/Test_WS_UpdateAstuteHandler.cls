@isTest
public class Test_WS_UpdateAstuteHandler {
    public static testMethod void updateAstuteHandlerMethod(){
    genesis__applications__c app = TestUtility.intialSetUp('Personal Loan', false);
    
    String jSon = '{'+
	'"applicationData": {'+
		'"applicationNumber":"'+app.id+'",'+
		'"fileNumber": "a4V0l000000HPKV",'+
		'"applicantName": "KVB",'+
		'"caseNotificationId": "123344444",'+
        '"fieldReport": {'+
			'"dateOfVisit": "20/06/2018",'+
			'"timeOfVisit": "11:00",'+
			'"addressConfirmed": "YES",'+
			'"prominentLandmark": "MAHARASHTRA",'+
			'"locality": "Commercial Complex",'+
			'"officeType": "Residential cum Office",'+
			'"colleagueInfo": {'+
				'"name": "Sagar",'+
				'"designation": "manager",'+
				'"directTelephone": "1236547890",'+
				'"mobileNumber": "9087654321",'+
				'"visitingCardObtained": "Yes"'+
			'},'+
			'"businessActivityLevel": "Low",'+
			'"noOfSightedEmployees": "50",'+
			'"noOfSightedClients": "3",'+
			'"applicantVerification": {'+
				'"designation": "IT Head",'+
				'"department": "IT",'+
				'"grade": "A",'+
				'"salary": "50000",'+
				'"dateOfJoining": "01/01/2018",'+
				'"serviceDuration": "3",'+
				'"PFNumber": "dffds243",'+
				'"typeOfJob": "Permanent",'+
				'"natureOfJob": "Not Transferable",'+
				'"natureOfBusiness": "good",'+
				'"carpetArea": "2000",'+
				'"employerVerification": "Negative"'+
			'},'+
			'"otherDetails": {'+
				'"comments": "Testing Purpose",'+
				'"deDupeStatus": "Match not found",'+
				'"deDupeRemark": "Test",'+
				'"verifierName": "Test FE"'+			
		'}'+
	'}'+
	'},'+
    
	'"officeDetails": {'+
		'"employerInfo": {'+
			'"name": "Sumy S G .",'+
			'"address": "rajastan",'+
			'"telephone": "8013285896"'+
		'},'+
		'"fieldReport": {'+
			'"dateOfVisit": "20/06/2018",'+
			'"timeOfVisit": "11:00",'+
			'"addressConfirmed": "YES",'+
			'"prominentLandmark": "MAHARASHTRA",'+
			'"locality": "Commercial Complex",'+
			'"officeType": "Residential cum Office",'+
			'"colleagueInfo": {'+
				'"name": "Sagar",'+
				'"designation": "manager",'+
				'"directTelephone": "1236547890",'+
				'"mobileNumber": "9087654321",'+
				'"visitingCardObtained": "Yes"'+
			'},'+
			'"businessActivityLevel": "Low",'+
			'"noOfSightedEmployees": "50",'+
			'"noOfSightedClients": "3",'+
			'"applicantVerification": {'+
				'"designation": "IT Head",'+
				'"department": "IT",'+
				'"grade": "A",'+
				'"salary": "50000",'+
				'"dateOfJoining": "01/01/2018",'+
				'"serviceDuration": "3",'+
				'"PFNumber": "dffds243",'+
				'"typeOfJob": "Permanent",'+
				'"natureOfJob": "Not Transferable",'+
				'"natureOfBusiness": "good",'+
				'"carpetArea": "2000",'+
				'"employerVerification": "Negative"'+
			'},'+
			'"otherDetails": {'+
				'"comments": "Testing Purpose",'+
				'"deDupeStatus": "Match not found",'+
				'"deDupeRemark": "Test",'+
				'"verifierName": "Test FE"'+
 			
		'}'+
	'}'+
'}'+
'}';

	WS_UpdateAstuteRequest ast = WS_UpdateAstuteRequest.parse(jSon);
	WS_UpdateAstuteHandler.getAstuteDetails(ast);
	}
}