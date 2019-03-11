/*
* Name      : WS_LiabilitiesAPI
* Company   : ET Marlabs
* Purpose   : For storing Business Account & keyPerson Liabilities Data.
* Author    : Raushan
*/

public class WS_LiabilitiesAPI {
  //Method   
  public static void getDataFromCBS(String appId){
      if(appId !=null && appId !=''){
          system.debug('appId==++'+appId);
          Request_Structure reqObj	=	new  Request_Structure();
          List<genesis__Applications__c> listOfApp = [Select Id,Type__c,RecordType.DeveloperName,genesis__Account__c,genesis__Account__r.CBS_Customer_ID__c from genesis__Applications__c where Id =: appId];
          system.debug('listOfApp==++'+listOfApp);
          If(listOfApp !=null && listOfApp.size() > 0 && listOfApp[0].Type__c !=null){
              reqObj.appType = listOfApp[0].Type__c;
              reqObj.customerIds = new List<String>();
              If(listOfApp[0].Type__c.contains('NTB')){
              	List<genesis__Application_Parties__c> listOfParties = [Select id,Active__c,genesis__Application__c,genesis__Party_Account_Name__c,genesis__Party_Account_Name__r.CBS_Customer_ID__c from genesis__Application_Parties__c where genesis__Application__c =:appId AND Active__c = true];
                  If(listOfParties !=null && listOfParties.size() > 0){
                      for(genesis__Application_Parties__c partiesObj : listOfParties){
                          system.debug('partiesObj==++'+partiesObj);
                          if(partiesObj !=null && partiesObj.genesis__Party_Account_Name__r.CBS_Customer_ID__c !=null){
                              system.debug('partiesObj.genesis__Party_Account_Name__r.CBS_Customer_ID__c ==++'+partiesObj.genesis__Party_Account_Name__r.CBS_Customer_ID__c );
                          	reqObj.customerIds.add(partiesObj.genesis__Party_Account_Name__r.CBS_Customer_ID__c);			    
                          }
                      }
                  }  
                  system.debug('reqObj==++'+reqObj);
              }else{
                  if(listOfApp[0].genesis__Account__r.CBS_Customer_ID__c !=null && listOfApp[0].genesis__Account__r.CBS_Customer_ID__c != ''){
                  	reqObj.customerIds.add(listOfApp[0].genesis__Account__r.CBS_Customer_ID__c);    
                  }
              }
          }
          try{
              Map<String,String> headerMap     = new Map<String,String>();
              headerMap.put('Content-Type','application/json');
              headerMap.put('Authorization',WS_ApiGatewayAccToken.getAccTkn());
              HTTPResponse response                 = new HTTPResponse();
              response = HttpUtility.sendHTTPRequest(Utility.getFullEndpoints('Liabilities API'), 'POST', null,JSON.serialize(reqObj),headerMap,null);
              If(response.getStatusCode() == 200 || response.getStatusCode() == 201){
                  String jsonData                 = response.getBody();
                  Response_Structure resStrObj	= (Response_Structure)JSON.deserialize(jsonData, Response_Structure.class);
                  If(resStrObj !=null){
                      if(resStrObj.BusinessLiabilityDetails !=null){
                          Customer360view.cls_BusinessLiabilityDetails businessLiabilityObj = resStrObj.BusinessLiabilityDetails;
                          if(businessLiabilityObj !=null && listOfApp[0].Id !=null && listOfApp[0].genesis__Account__c !=null){
                              SMELoan_Helper_Handler.updateBusinessLiablities(listOfApp[0].Id,listOfApp[0].genesis__Account__c,businessLiabilityObj);    
                          }    
                      }
                      if(resStrObj.KeyPersonLiabilityDetails !=null && resStrObj.KeyPersonLiabilityDetails.size() > 0){
                          List<Customer360view.cls_KeyPersonLiabilityDetails> kPersonLiabilityObj = resStrObj.KeyPersonLiabilityDetails;
                          if(kPersonLiabilityObj !=null && kPersonLiabilityObj.size() > 0 && listOfApp[0].Id !=null && listOfApp[0].genesis__Account__c !=null){
                              SMELoan_Helper_Handler.updateKeyPersonLiablities(listOfApp[0].Id,kPersonLiabilityObj);    
                          }
                      }    
                  }
              }
          }catch(Exception ex){
          	System.debug('Exception ::'+ex.getMessage() + 'Line Number ::'+ex.getLineNumber());    
          }
      }
  }
  class Request_Structure{
     List<String> customerIds;
     String appType;
  }
    class Response_Structure {
         Customer360view.cls_BusinessLiabilityDetails BusinessLiabilityDetails;
         List<Customer360view.cls_KeyPersonLiabilityDetails> KeyPersonLiabilityDetails;    
    }
}