/*
* Name    : WS_FetchBankName
* Company : ET Marlabs
* Purpose : Class used to fetch Indian bank names
* Author  : Braj
* CreatedDate : 09-Feb-2019
*/
global class WS_FetchBankName {
    Webservice static List<String> fetchBankNameList(){
        try{
            System.debug('Inside fetchBankName^^^');
            String accessTkn = WS_ApiGatewayAccToken.getAccTkn();
            Map<String,String> headerMap = new Map<String,String>();
            headerMap.put('Content-Type','application/json');
            headerMap.put('Authorization',accessTkn);
            System.debug('**HeaderMap##'+headerMap);
            HTTPResponse response = new HTTPResponse();
            String endPoint = Utility.getFullEndpoints('BankName');
            response = HttpUtility.sendHTTPRequest(endPoint, 'GET', null,null,headerMap,null);
            System.debug('####'+response);
            system.debug('$$$$'+response.getBody());
            if(response.getStatusCode() == 200 || response.getStatusCode() == 201){
                String json = response.getBody();
                System.debug('JSON>> '+json);
                InstitutionBankWrp Banks = (InstitutionBankWrp) System.JSON.deserialize(json, InstitutionBankWrp.class);
                System.debug('Banks>> '+Banks);
                List<String> BankNameList = new List<String>();
                if (Banks!=null && Banks.Institutions!=null && Banks.Institutions.Institution.size() > 0) {
                    for(InstitutionObj eachBank: Banks.Institutions.Institution) {
                        BankNameList.add(eachBank.name);
                    }
                    return BankNameList;
                }
                return null;
            } else {
                return null;
            }
        }catch(Exception e){
            System.debug('Line No. '+e.getLineNumber()+'WS_FetchBankName.fetchBankNameList message'+e.getMessage());
            HandleBusinessException.captureError('WS_FetchBankName', 'fetchBankNameList', e);
            return null;
        }
    }
    
    public class InstitutionBankWrp {
        public InstitutionBanks Institutions;
    }
    
    public class InstitutionBanks {
        public List<InstitutionObj> Institution;
    }
    
    public class InstitutionObj {
        public String id;
        public String name;
        public String institutionType;
        public String addressAvailable;
        public String originalStatementAvailable;
        public String form26AsAvailable;
        public String itrVAvailable;
    }
    
}