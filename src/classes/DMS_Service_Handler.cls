/*
* Name    	: DMS_Structure_Handler
* Company  	: ET Marlabs
* Purpose   : DMS request/response handler
* Author  	: SOUVIK
* last Modified By : SOUVIK
*/

public class DMS_Service_Handler{
    
    /*Download document from DMS(uuId,versionId)*/
    public static Blob getDocById(String UUId,String versionId){
        
        Blob fileStrm;
        try{
            String endPoint						= '';
            Map<String,String> headerMap 		= new Map<String,String>();	
            headerMap.put('Authorization',WS_ApiGatewayAccToken.getAccTkn());
            endPoint                     		= 	Utility.getEndpointApigee('DMS_Apigee');			
            endPoint							+= '/document/'+UUId+'?'+'versionId='+versionId;
            HTTPResponse response  	= new HTTPResponse();
            response 			   	=  HttpUtility.sendHTTPRequest(endPoint,'GET',null,null,headerMap,label.CA_CERTIFICATE);
            
            if(response.getStatusCode() == 200 || response.getStatusCode() == 201){
                try{
                    String responseString = response.getBody();
                    System.debug('ResponseString--->' + responseString);
                    DMS_Structure.docDowloandById res = (DMS_Structure.docDowloandById)Json.deserialize(responseString,DMS_Structure.docDowloandById.class);
                    if(res.status == 1)
                        fileStrm = EncodingUtil.base64Decode(res.data.fileStream);
                    //Attachment attt = new Attachment(parentId='a4V0l0000004SoB',Body=fileStrm,Name='aaa.pdf');
                 return fileStrm;   
                }catch(Exception e){
                    HandleBusinessException.captureError('DMS_Structure_Handler', 'getDocById', e);
                   return null; 
                }
            }else{
                System.debug('Error::' + response.getBody());
                return null;
            }
        }
        catch(Exception e){
            System.debug(e.getStackTraceString());
            HandleBusinessException.captureError('DMS_Structure_Handler', 'getDocById', e);
            return null;
        }
    }
    public static void docGeneration(String appId,String documentName,String templateName){
        
    }
}