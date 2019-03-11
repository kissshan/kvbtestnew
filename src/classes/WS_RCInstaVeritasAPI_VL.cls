/*
* Name    : WS_RCInstaVeritasAPI_VL
* Company : ET Marlabs
* Purpose : Class used to call InstaVeritas to fetch Vehicle details
* Author  : Braj
* CreatedDate : 29-Aug-2018
*/
global class WS_RCInstaVeritasAPI_VL {
    
    Webservice static void callVehicleRC(string RegistrationNo,String collateralId){
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
                        //start 
                        clcommon__Collateral__c collNew=[select id,name,Response_check_first__c,Engine_No__c,Chassis_No__c from clcommon__Collateral__c where id=:collateralId];
                        if(!(res[0].engine_number.equalsIgnoreCase(collNew.Engine_No__c)) && !(res[0].chassis_number.equalsIgnoreCase(collNew.Chassis_No__c))){
                            if(!(res[0].engine_number.left(4).equalsIgnoreCase(collNew.Engine_No__c.left(4))) && !(res[0].chassis_number.left(4).equalsIgnoreCase(collNew.Chassis_No__c.left(4)))){
                                System.debug('test wrong coll');
                                clcommon__Collateral__c collChange = new clcommon__Collateral__c();
                                collChange.Chassis_No__c='';
                                collChange.Engine_No__c='';                                
                                collChange.Response_check_first__c=false;
                                collChange.RC_Response_Error_Message__c='Engine no or chasis no is not matched';
                                collChange.Id = collateralId;
                                // collNew.addError('Engine no or chasis no is not matched');
                                update collChange;
                                
                            }
                        }
                        else{                     //end
                            //createVL_RC(res,collateralId);//commented after discussion with shreya on Date:27-09-2018
                            clcommon__Collateral__c coll = new clcommon__Collateral__c();
                            coll.RC_No__c = RegistrationNo;
                            coll.Id = collateralId;
                            coll.RC_Response_Error_Code__c = '';
                            coll.RC_Response_Error_Message__c = '';
                            update coll;
                        }
                    }
                } else {
                    WS_RCInstaVeritasAPI_VL errorResponse = WS_RCInstaVeritasAPI_VL.parse(response.getBody());
                    System.debug('parse message=='+errorResponse);
                    clcommon__Collateral__c coll = new clcommon__Collateral__c();
                    if(errorResponse.code!='') {
                        coll.RC_Response_Error_Code__c = String.valueOf(errorResponse.code);
                        coll.RC_Response_Error_Message__c = errorResponse.message;
                    } else {
                        coll.RC_Response_Error_Code__c = String.valueOf(errorResponse.errorCode);
                        coll.RC_Response_Error_Message__c = errorResponse.errorMessage;
                    }
                    coll.RC_No__c = RegistrationNo;
                    coll.Id = collateralId;
                    update coll;
                    //throw new CustomException('Status Code-'+response.getStatusCode()+' Status-'+response.getStatus());
                }
            } else {
                System.debug('RegistrationNo and collateralId should not be blank!!');
            }
        }catch(Exception e){
            System.debug(e.getLineNumber()+'Vehicle RC API call failed!!'+e.getStackTraceString());
            HandleBusinessException.captureError('WS_RCInstaVeritasAPI_VL', 'callVehicleRC', e);
        }   
    }
    
    public static void createVL_RC(List<VL_RC_Response> response,String collId){
        System.debug(response.size()+'<--response==>'+response);
        Boolean checkdiff=true;
        genesis__Applications__c appdetails;
        System.debug('collId==>'+collId);
        try {
            if(response.size()>0) {
                if(collId==null && response[0].registration_number!=null) {
                    try {
                        List<clcommon__Collateral__c> collLst=new List<clcommon__Collateral__c>();
                        collLst=[select id,genesis__Application__c,name,RC_No__c,Engine_No__c,Chassis_No__c from clcommon__Collateral__c where RC_No__c=:response[0].registration_number Limit 1];
                        System.debug('collLst==>'+collLst);
                        if(collLst.size()>0){
                            collId = collLst[0].Id;
                            
                            if(!(response[0].engine_number.equalsIgnoreCase(collLst[0].Engine_No__c)) && !(response[0].chassis_number.equalsIgnoreCase(collLst[0].Chassis_No__c))){
                                if(!(response[0].engine_number.left(4).equalsIgnoreCase(collLst[0].Engine_No__c.left(4))) && !(response[0].chassis_number.left(4).equalsIgnoreCase(collLst[0].Chassis_No__c.left(4)))){
                                    checkdiff=false;
                                }
                            }
                           
                          appdetails=[select id, Sub_Stage__c  from genesis__Applications__c where id =:collLst[0].genesis__Application__c];
                            
                        }
                    } catch(Exception e) {
                        System.debug('Collateral record of given RC No. not found!!'+e.getMessage());
                    }
                } 
                if(collId!=null && checkdiff && appdetails.Sub_Stage__c==Constants.APPL_STAGE_LOAN_ACCOUNT_OPENED) {
                    clcommon__Collateral__c coll = new clcommon__Collateral__c();
                    coll.RC_No__c = response[0].registration_number;
                    coll.Chassis_Number__c = response[0].chassis_number;
                    coll.clcommon__Vehicle_Serial_Number__c = response[0].engine_number;
                    if(response[0].registration_date!=null && response[0].registration_date!='NA'){
                        List<String> strlst = response[0].registration_date.split('-');
                        Date regDate = Date.newInstance(Integer.valueOf(strlst[2]),Utility.convertMonthTextToNumber(strlst[1]),Integer.valueOf(strlst[0]));
                        System.debug('regDate==>'+regDate);
                        coll.RC_Date__c = regDate;
                    }
                    if(response[0].expiry_date!=null && response[0].expiry_date!='NA'){   ////.....V1.1
                        List<String> strlst1 = response[0].expiry_date.split('-');
                        Date regDate1 = Date.newInstance(Integer.valueOf(strlst1[2]),Utility.convertMonthTextToNumber(strlst1[1]),Integer.valueOf(strlst1[0]));
                        System.debug('regDate==>'+regDate1);
                        coll.Expire_date__c = regDate1;
                    }
                    coll.Vehicle_Company__c = response[0].vehicle_company;
                    coll.Vehicle_Model__c = response[0].vehicle_model;
                    coll.Vehicle_Age__c = response[0].vehicle_age;
                    coll.Vehicle_Owner_Name__c = response[0].owners_name;
                    coll.Financing_Authority__c = response[0].financing_authority;
                    coll.clcommon__Description__c = response[0].vehicle_type;
                    coll.clcommon__Style__c= response[0].registering_authority;
                    coll.Registration_State__c=response[0].registration_state;  //.....V1.1
                    coll.RC_Response_Error_Code__c = '';
                    coll.RC_Response_Error_Message__c = '';
                    coll.id = collId;
                    update coll;
                    System.debug('coll==>'+coll);
                }
            }
        } catch(Exception e) {
            System.debug(e.getLineNumber()+'Vehicle RC Insertion failed!!'+e.getStackTraceString());
            HandleBusinessException.captureError('WS_RCInstaVeritasAPI_VL', 'createVL_RC', e);
        }
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
    
}