/*
 * Name		: WS_Response
 * Company	: ET Marlabs
 * Author	: Amritesh
*/

global virtual class WS_Response {
    
    global String status; 
    global String errorMessage;
    global String successMessage;
    global String statusCode;
    
    
    global WS_Response(){
        status          = Constants.WS_SUCCESS_STATUS;
        statusCode		= Constants.WS_SUCCESS_CODE;
        errorMessage='';
        successMessage='';    
    }
}