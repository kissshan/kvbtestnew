@RestResource(urlMapping='/getDropDownValues')
global with sharing class WS_DropDownValues_SME  {

    global class Response extends WS_Response{
        public DROW_DOWN_WRAPPER dropDownValues;
        public Response(){
            dropDownValues = new DROW_DOWN_WRAPPER();
        }
    }

    @HttpGet
    global static Response getAllPicklistvalues() {

        RestRequest req      = Restcontext.Request;
        Response res         = new Response();
		try{
            List<All_Drop_Down_value__mdt> listallDropDownObj	= [select id,Label,Field_Api_Name__c,Object_Api_Name__c from All_Drop_Down_value__mdt];
            for(All_Drop_Down_value__mdt allDropObj		:	listallDropDownObj){
                //System.debug('Object API Name'+ allDropObj.Object_Api_Name__c);
                //System.debug('Field API Name'+ allDropObj.Field_Api_Name__c);
                
                List<String> listDropDown 		=	DropDownHandler.getPicklistEntries(allDropObj.Object_Api_Name__c, allDropObj.Field_Api_Name__c);
                If(listDropDown !=null){
                    res.dropDownValues.DROP_DOWN_DETAILS.put(allDropObj.Label,listDropDown);
                }
            }
       
            res.status      = Constants.WS_SUCCESS_STATUS;
            res.statusCode  = Constants.WS_SUCCESS_CODE;
             

        }catch(Exception e){

            res.status          = Constants.WS_ERROR_STATUS;
            res.errorMessage   = e.getMessage();
            res.statusCode  = Constants.WS_ERROR_CODE;
            system.debug('Exception::'+e);
            
        }
        return res;

    }

    

}