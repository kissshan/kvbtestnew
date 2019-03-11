/*
* Name    : TL_RCVerification
* Company : ET Marlabs
* Purpose : Class used to call InstaVeritas to fetch Vehicle details
* Author  : Jitesh Yadav
* CreatedDate : 29-Jan-2018
*/
global class TL_RCVerification{

  Webservice static clcommon__Collateral__c  getVehicleDetails(string RegistrationNo,String collateralId){
       //List<clcommon__Collateral__c> collist=new List<clcommon__Collateral__c>();
       clcommon__Collateral__c coll = new clcommon__Collateral__c();
        try{
        
            System.debug('RegistrationNo ==> '+RegistrationNo);
            if(RegistrationNo!=null && RegistrationNo!='' && collateralId !=null){
              String accessTkn = WS_ApiGatewayAccToken.getAccTkn();
            Map<String,String> headerMap = new Map<String,String>();
            headerMap.put('Content-Type','application/json');
            headerMap.put('Authorization',accessTkn);
              System.debug('**HeaderMap##'+headerMap);
              HTTPResponse response = new HTTPResponse();
              String endPoint = Utility.getFullEndpoints('VL_RCInstaVeritasAPI');
              endPoint = endPoint+RegistrationNo;
              response = HttpUtility.sendHTTPRequest(endPoint, 'GET', null,null,headerMap,null);
              System.debug('####'+response);
              system.debug('$$$$'+response.getBody());
              if(response.getStatusCode() == 200 || response.getStatusCode() == 201){
                  String jsona = response.getBody();
                  System.debug('jsona'+jsona);
                  List<VL_RC_Response> res = VL_RC_Response.parse(jsona);
                  System.debug('res=='+res);
                  if(res.size()>1) {
                    System.debug('More than more response received==>'+res.size());
                  } else {
                  System.debug('engine number here -->'+res[0].engine_number);
                    
                    
                    //coll.RC_No__c = RegistrationNo;
                  coll.Id = collateralId;
                  coll.RC_No__c=RegistrationNo;
                  coll.Financing_Authority__c=res[0].financing_authority;
                  //coll.Engine_number__c=res[0].engine_number;
                  //coll.Chassis_Number__c=res[0].chassis_number;
                  coll.Vehicle_Owner_Name__c=res[0].owners_name;
                  coll.RCCheckDone__c=true;
                  update coll;
                  }
              } else {
                
                WS_RCInstaVeritasAPI_VL errorResponse = WS_RCInstaVeritasAPI_VL.parse(response.getBody());
                System.debug('parse message=='+errorResponse);
                
                if(errorResponse.code!='') {
                  coll.RC_Response_Error_Code__c = String.valueOf(errorResponse.code);
                  coll.RC_Response_Error_Message__c = errorResponse.message;
                } else {
                  coll.RC_Response_Error_Code__c = String.valueOf(errorResponse.errorCode);
                  coll.RC_Response_Error_Message__c = errorResponse.errorMessage;
                }
                coll.Financing_Authority__c=null;
                  coll.Engine_number__c=null;
                  coll.Chassis_Number__c=null;
                  coll.Vehicle_Owner_Name__c=null;
                coll.RC_No__c =null;
                coll.Id = collateralId;
                update coll;
                  //throw new CustomException('Status Code-'+response.getStatusCode()+' Status-'+response.getStatus());
              }
              system.debug('here '+ coll);
            } else {
              System.debug('RegistrationNo and collateralId should not be blank!!');
            }
            system.debug('here '+ coll);
        }catch(Exception e){
            System.debug(e.getLineNumber()+'Vehicle RC API call failed!!'+e.getStackTraceString());
            HandleBusinessException.captureError('WS_RCInstaVeritasAPI_VL', 'callVehicleRC', e);
        }
        system.debug('here '+ coll);
        return coll;   
    }

   
    //Below class used for parsing error response Json
  public class Errors {
    public List<String> rc_number;
  }

  public String message;
  public String code;
  public Errors errors;
  public String errorMessage;
  public String errorCode;

  
  public static WS_RCInstaVeritasAPI_VL parse(String json) {
    return (WS_RCInstaVeritasAPI_VL) System.JSON.deserialize(json, WS_RCInstaVeritasAPI_VL.class);
  }

  Webservice static Task  getTask(String parentid,string taskSubject, string taskType){
Task t=new Task();
t.whatid=parentId;
t.OwnerId='0050l0000019AVB';
t.Subject=taskSubject;
t.Type=taskType;
t.Activitydate=system.today()+2;

insert t;

return t;
}

}